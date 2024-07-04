-- crossing feature type
create view bcfishpass.crossings_feature_type_vw as
select
  aggregated_crossings_id,
  case 
    when crossing_subtype_code = 'WEIR' then 'WEIR'
    when crossing_subtype_code = 'DAM' then 'DAM'
    -- RAIL, pscis crossings within 50m of rail line and with RAIL in the road name
    when 
      rail_owner_name is not null
      and aggregated_crossings_id in (
        select 
          aggregated_crossings_id
        from bcfishpass.crossings c
        inner join whse_basemapping.gba_railway_tracks_sp r
        on st_dwithin(c.geom, r.geom, 50)
        where crossing_source = 'PSCIS'
        and upper(pscis_road_name) like '%RAIL%' and upper(pscis_road_name) not like '%TRAIL%'
      ) 
    then 'RAIL'
    -- RAIL, pscis crossings within 10m of rail line
    when 
      rail_owner_name is not null
      and aggregated_crossings_id in (
        select 
          aggregated_crossings_id
        from bcfishpass.crossings c
        inner join whse_basemapping.gba_railway_tracks_sp r
        on st_dwithin(c.geom, r.geom, 10)
        where crossing_source = 'PSCIS'
      )
    then 'RAIL'
    -- modelled rail crossings
    when 
      rail_owner_name is not null
      and crossing_source = 'MODELLED CROSSINGS'
    then 'RAIL'
    -- tenured roads
    when 
      ften_forest_file_id is not NULL OR
      ogc_proponent is not NULL
    then 'ROAD, RESOURCE/OTHER'
    -- demographic roads
    when
      transport_line_type_description IN (
        'Road alleyway',
        'Road arterial major',
        'Road arterial minor',
        'Road collector major',
        'Road collector minor',
        'Road freeway',
        'Road highway major',
        'Road highway minor',
        'Road lane',
        'Road local',
        'Private driveway demographic',
        'Road pedestrian mall',
        'Road runway non-demographic',
        'Road recreation demographic',
        'Road ramp',
        'Road restricted',
        'Road strata',
        'Road service',
        'Road yield lane'
      )
    then 'ROAD, DEMOGRAPHIC'
    -- trails
    when
      upper(transport_line_type_description) LIKE 'TRAIL%'
    then 'TRAIL'
    -- everything else (DRA)
    when
      transport_line_type_description is not NULL
    then 'ROAD, RESOURCE/OTHER'
    -- in the absence of any of the above info, assume a resource/other road
    else 'ROAD, RESOURCE/OTHER'
  end as crossing_feature_type
from bcfishpass.crossings;


-- counts of anthropogenic barriers upstream per access model
-- (for example, number of barriers on steelhead accessible stream upstream of given barrier)
create materialized view bcfishpass.crossings_upstr_barriers_per_model_vw as

with access_models as (
  select
    c.aggregated_crossings_id,
    a.barriers_bt_dnstr,
    a.barriers_ch_cm_co_pk_sk_dnstr,
    a.barriers_ct_dv_rb_dnstr,
    a.barriers_st_dnstr,
    a.barriers_wct_dnstr
  from bcfishpass.crossings c
  left outer join bcfishpass.streams s ON s.blue_line_key = c.blue_line_key
  AND round(s.downstream_route_measure::numeric, 4) <= round(c.downstream_route_measure::numeric, 4)
  AND round(s.upstream_route_measure::numeric, 4) > round(c.downstream_route_measure::numeric, 4)
  AND s.watershed_group_code = c.watershed_group_code
  left outer join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
),

barriers_unnested as (
  select
    a.aggregated_crossings_id,
    unnest(a.features_upstr) as barrier_upstr
    from bcfishpass.crossings_upstr_barriers_anthropogenic a
),

barriers_upstr as (
  select
    b.aggregated_crossings_id,
    b.barrier_upstr,
    m.barriers_bt_dnstr,
    m.barriers_ch_cm_co_pk_sk_dnstr,
    m.barriers_ct_dv_rb_dnstr,
    m.barriers_st_dnstr,
    m.barriers_wct_dnstr
  from barriers_unnested b
  left outer join access_models m on b.barrier_upstr = m.aggregated_crossings_id
),

barriers_upstr_per_model as (
  select
    c.aggregated_crossings_id,
    array_agg(barrier_upstr) filter (where u.barriers_bt_dnstr = array[]::text[]) as barriers_upstr_bt,
    array_agg(barrier_upstr) filter (where u.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]) as barriers_upstr_ch_cm_co_pk_sk,
    array_agg(barrier_upstr) filter (where u.barriers_ct_dv_rb_dnstr = array[]::text[]) as barriers_upstr_ct_dv_rb,
    array_agg(barrier_upstr) filter (where u.barriers_st_dnstr = array[]::text[]) as barriers_upstr_st,
    array_agg(barrier_upstr) filter (where u.barriers_wct_dnstr = array[]::text[]) as barriers_upstr_wct
  from bcfishpass.crossings c
  inner join barriers_upstr u on c.aggregated_crossings_id = u.aggregated_crossings_id
  group by c.aggregated_crossings_id
)

select
 c.aggregated_crossings_id            ,
 bpm.barriers_upstr_bt                ,
 bpm.barriers_upstr_ch_cm_co_pk_sk    ,
 bpm.barriers_upstr_ct_dv_rb          ,
 bpm.barriers_upstr_st                ,
 bpm.barriers_upstr_wct
from bcfishpass.crossings c
left outer join barriers_upstr_per_model bpm
on c.aggregated_crossings_id = bpm.aggregated_crossings_id;

create unique index on bcfishpass.crossings_upstr_barriers_per_model_vw (aggregated_crossings_id);


create materialized view bcfishpass.crossings_admin_vw AS
SELECT DISTINCT ON (c.aggregated_crossings_id) -- some of the admin areas are not clean/distinct, make sure to select just one
  c.aggregated_crossings_id,
  rd.admin_area_abbreviation as abms_regional_district,
  muni.admin_area_abbreviation as abms_municipality,
  ir.english_name as clab_indian_reserve_name,
  ir.band_name as clab_indian_reserve_band_name,
  np.english_name as clab_national_park_name,
  pp.protected_lands_name as bc_protected_lands_name,
  pmbc.owner_type as pmbc_owner_type,
  nr.region_org_unit_name as adm_nr_region,
  nr.district_name as adm_nr_district
FROM bcfishpass.crossings c
LEFT OUTER JOIN whse_legal_admin_boundaries.abms_regional_districts_sp rd
ON ST_Intersects(c.geom, rd.geom)
LEFT OUTER JOIN whse_legal_admin_boundaries.abms_municipalities_sp muni
ON ST_Intersects(c.geom, muni.geom)
LEFT OUTER JOIN whse_admin_boundaries.adm_indian_reserves_bands_sp ir
ON ST_Intersects(c.geom, ir.geom)
LEFT OUTER JOIN whse_admin_boundaries.clab_national_parks np
ON ST_Intersects(c.geom, np.geom)
LEFT OUTER JOIN whse_tantalis.ta_park_ecores_pa_svw pp
ON ST_Intersects(c.geom, pp.geom)
LEFT OUTER JOIN whse_cadastre.pmbc_parcel_fabric_poly_svw pmbc
ON ST_Intersects(c.geom, pmbc.geom)
LEFT OUTER JOIN whse_admin_boundaries.adm_nr_districts_spg nr
ON ST_Intersects(c.geom, pmbc.geom)
ORDER BY c.aggregated_crossings_id, rd.admin_area_abbreviation, muni.admin_area_abbreviation, ir.english_name, pp.protected_lands_name, pmbc.owner_type, nr.district_name;


-- downstream observations ***within the same watershed group***
create materialized view bcfishpass.crossings_dnstr_observations_vw as
select
  aggregated_crossings_id,
  array_agg(species_code) as observedspp_dnstr
FROM
  (
    select distinct
      a.aggregated_crossings_id,
      unnest(species_codes) as species_code
    from bcfishpass.crossings a
    left outer join bcfishobs.fiss_fish_obsrvtn_events fo
    on FWA_Downstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      fo.blue_line_key,
      fo.downstream_route_measure,
      fo.wscode_ltree,
      fo.localcode_ltree
   )
  and a.watershed_group_code = fo.watershed_group_code
  order by a.aggregated_crossings_id, species_code
  ) AS f
group by aggregated_crossings_id;

create index on bcfishpass.crossings_dnstr_observations_vw (aggregated_crossings_id);


-- upstream observations ***within the same watershed group***
create materialized view bcfishpass.crossings_upstr_observations_vw as
select
  aggregated_crossings_id,
  array_agg(species_code) as observedspp_upstr
FROM
  (
    select distinct
      a.aggregated_crossings_id,
      unnest(species_codes) as species_code
    from bcfishpass.crossings a
    left outer join bcfishobs.fiss_fish_obsrvtn_events fo
    on FWA_Upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      fo.blue_line_key,
      fo.downstream_route_measure,
      fo.wscode_ltree,
      fo.localcode_ltree
     )
    and a.watershed_group_code = fo.watershed_group_code
    order by a.aggregated_crossings_id, species_code
  ) AS f
group by aggregated_crossings_id;

create index on bcfishpass.crossings_upstr_observations_vw (aggregated_crossings_id);



-- final output crossings view -
-- join crossings table to streams / access / habitat tables
-- and convert array types to text for easier dumps
create materialized view bcfishpass.crossings_vw as
select
  -- joining to streams based on measure can be error prone due to precision.
  -- Join to streams on linear_feature_id and keep the first result
  -- (since streams are segmented there is often >1 match)
  distinct on (c.aggregated_crossings_id)
  c.aggregated_crossings_id,
  c.stream_crossing_id,
  c.dam_id,
  c.user_barrier_anthropogenic_id,
  c.modelled_crossing_id,
  c.crossing_source,
  cft.crossing_feature_type,
  c.pscis_status,
  c.crossing_type_code,
  c.crossing_subtype_code,
  array_to_string(c.modelled_crossing_type_source, ';') as modelled_crossing_type_source,
  c.barrier_status,
  c.pscis_road_name,
  c.pscis_stream_name,
  c.pscis_assessment_comment,
  c.pscis_assessment_date,
  c.pscis_final_score,
  c.transport_line_structured_name_1,
  c.transport_line_type_description,
  c.transport_line_surface_description,
  c.ften_forest_file_id,
  c.ften_file_type_description,
  c.ften_client_number,
  c.ften_client_name,
  c.ften_life_cycle_status_code,
  c.rail_track_name,
  c.rail_owner_name,
  c.rail_operator_english_name,
  c.ogc_proponent,
  c.dam_name,
  c.dam_height,
  c.dam_owner,
  c.dam_use,
  c.dam_operating_status,
  c.utm_zone,
  c.utm_easting,
  c.utm_northing,
  t.map_tile_display_name as dbm_mof_50k_grid,
  c.linear_feature_id,
  c.blue_line_key,
  c.watershed_key,
  c.downstream_route_measure,
  c.wscode_ltree as wscode,
  c.localcode_ltree as localcode,
  c.watershed_group_code,
  c.gnis_stream_name,
  c.stream_order,
  c.stream_magnitude,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(cdo.observedspp_dnstr, ';') as observedspp_dnstr,
  array_to_string(cuo.observedspp_upstr, ';') as observedspp_upstr,
  array_to_string(cd.features_dnstr, ';') as crossings_dnstr,
  array_to_string(ad.features_dnstr, ';') as barriers_anthropogenic_dnstr,
  coalesce(array_length(ad.features_dnstr, 1), 0) as barriers_anthropogenic_dnstr_count,
  array_to_string(au.features_upstr, ';') as barriers_anthropogenic_upstr,
  coalesce(array_length(au.features_upstr, 1), 0) as barriers_anthropogenic_upstr_count,
  array_to_string(aum.barriers_upstr_bt, ';') as barriers_anthropogenic_bt_upstr,
  coalesce(array_length(aum.barriers_upstr_bt, 1), 0) as barriers_anthropogenic_upstr_bt_count,
  array_to_string(aum.barriers_upstr_ch_cm_co_pk_sk, ';') as barriers_anthropogenic_ch_cm_co_pk_sk_upstr,
  coalesce(array_length(aum.barriers_upstr_ch_cm_co_pk_sk, 1), 0) as barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count,
  array_to_string(aum.barriers_upstr_st, ';') as barriers_anthropogenic_st_upstr,
  coalesce(array_length(aum.barriers_upstr_st, 1), 0) as barriers_anthropogenic_st_upstr_count,
  array_to_string(aum.barriers_upstr_wct, ';') as barriers_anthropogenic_wct_upstr,
  coalesce(array_length(aum.barriers_upstr_wct, 1), 0) as barriers_anthropogenic_wct_upstr_count,
  a.gradient,
  a.total_network_km,
  a.total_stream_km,
  a.total_lakereservoir_ha,
  a.total_wetland_ha,
  a.total_slopeclass03_waterbodies_km,
  a.total_slopeclass03_km,
  a.total_slopeclass05_km,
  a.total_slopeclass08_km,
  a.total_slopeclass15_km,
  a.total_slopeclass22_km,
  a.total_slopeclass30_km,
  a.total_belowupstrbarriers_network_km,
  a.total_belowupstrbarriers_stream_km,
  a.total_belowupstrbarriers_lakereservoir_ha,
  a.total_belowupstrbarriers_wetland_ha,
  a.total_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.total_belowupstrbarriers_slopeclass03_km,
  a.total_belowupstrbarriers_slopeclass05_km,
  a.total_belowupstrbarriers_slopeclass08_km,
  a.total_belowupstrbarriers_slopeclass15_km,
  a.total_belowupstrbarriers_slopeclass22_km,
  a.total_belowupstrbarriers_slopeclass30_km,

  -- access models
  array_to_string(a.barriers_bt_dnstr, ';') as barriers_bt_dnstr,
  a.bt_network_km,
  a.bt_stream_km,
  a.bt_lakereservoir_ha,
  a.bt_wetland_ha,
  a.bt_slopeclass03_waterbodies_km,
  a.bt_slopeclass03_km,
  a.bt_slopeclass05_km,
  a.bt_slopeclass08_km,
  a.bt_slopeclass15_km,
  a.bt_slopeclass22_km,
  a.bt_slopeclass30_km,
  a.bt_belowupstrbarriers_network_km,
  a.bt_belowupstrbarriers_stream_km,
  a.bt_belowupstrbarriers_lakereservoir_ha,
  a.bt_belowupstrbarriers_wetland_ha,
  a.bt_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.bt_belowupstrbarriers_slopeclass03_km,
  a.bt_belowupstrbarriers_slopeclass05_km,
  a.bt_belowupstrbarriers_slopeclass08_km,
  a.bt_belowupstrbarriers_slopeclass15_km,
  a.bt_belowupstrbarriers_slopeclass22_km,
  a.bt_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  a.ch_cm_co_pk_sk_network_km,
  a.ch_cm_co_pk_sk_stream_km,
  a.ch_cm_co_pk_sk_lakereservoir_ha,
  a.ch_cm_co_pk_sk_wetland_ha,
  a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
  a.ch_cm_co_pk_sk_slopeclass03_km,
  a.ch_cm_co_pk_sk_slopeclass05_km,
  a.ch_cm_co_pk_sk_slopeclass08_km,
  a.ch_cm_co_pk_sk_slopeclass15_km,
  a.ch_cm_co_pk_sk_slopeclass22_km,
  a.ch_cm_co_pk_sk_slopeclass30_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
  a.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  a.st_network_km,
  a.st_stream_km,
  a.st_lakereservoir_ha,
  a.st_wetland_ha,
  a.st_slopeclass03_waterbodies_km,
  a.st_slopeclass03_km,
  a.st_slopeclass05_km,
  a.st_slopeclass08_km,
  a.st_slopeclass15_km,
  a.st_slopeclass22_km,
  a.st_slopeclass30_km,
  a.st_belowupstrbarriers_network_km,
  a.st_belowupstrbarriers_stream_km,
  a.st_belowupstrbarriers_lakereservoir_ha,
  a.st_belowupstrbarriers_wetland_ha,
  a.st_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.st_belowupstrbarriers_slopeclass03_km,
  a.st_belowupstrbarriers_slopeclass05_km,
  a.st_belowupstrbarriers_slopeclass08_km,
  a.st_belowupstrbarriers_slopeclass15_km,
  a.st_belowupstrbarriers_slopeclass22_km,
  a.st_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
  a.wct_network_km,
  a.wct_stream_km,
  a.wct_lakereservoir_ha,
  a.wct_wetland_ha,
  a.wct_slopeclass03_waterbodies_km,
  a.wct_slopeclass03_km,
  a.wct_slopeclass05_km,
  a.wct_slopeclass08_km,
  a.wct_slopeclass15_km,
  a.wct_slopeclass22_km,
  a.wct_slopeclass30_km,
  a.wct_belowupstrbarriers_network_km,
  a.wct_belowupstrbarriers_stream_km,
  a.wct_belowupstrbarriers_lakereservoir_ha,
  a.wct_belowupstrbarriers_wetland_ha,
  a.wct_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.wct_belowupstrbarriers_slopeclass03_km,
  a.wct_belowupstrbarriers_slopeclass05_km,
  a.wct_belowupstrbarriers_slopeclass08_km,
  a.wct_belowupstrbarriers_slopeclass15_km,
  a.wct_belowupstrbarriers_slopeclass22_km,
  a.wct_belowupstrbarriers_slopeclass30_km,

  -- habitat models
  h.bt_spawning_km,
  h.bt_rearing_km,
  h.bt_spawning_belowupstrbarriers_km,
  h.bt_rearing_belowupstrbarriers_km,
  h.ch_spawning_km,
  h.ch_rearing_km,
  h.ch_spawning_belowupstrbarriers_km,
  h.ch_rearing_belowupstrbarriers_km,
  h.cm_spawning_km,
  h.cm_spawning_belowupstrbarriers_km,
  h.co_spawning_km,
  h.co_rearing_km,
  h.co_rearing_ha,
  h.co_spawning_belowupstrbarriers_km,
  h.co_rearing_belowupstrbarriers_km,
  h.co_rearing_belowupstrbarriers_ha,
  h.pk_spawning_km,
  h.pk_spawning_belowupstrbarriers_km,
  h.sk_spawning_km,
  h.sk_rearing_km,
  h.sk_rearing_ha,
  h.sk_spawning_belowupstrbarriers_km,
  h.sk_rearing_belowupstrbarriers_km,
  h.sk_rearing_belowupstrbarriers_ha,
  h.st_spawning_km,
  h.st_rearing_km,
  h.st_spawning_belowupstrbarriers_km,
  h.st_rearing_belowupstrbarriers_km,
  h.wct_spawning_km,
  h.wct_rearing_km,
  h.wct_spawning_belowupstrbarriers_km,
  h.wct_rearing_belowupstrbarriers_km,
  c.geom
from bcfishpass.crossings c
inner join bcfishpass.crossings_feature_type_vw cft on c.aggregated_crossings_id = cft.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_observations_vw cdo on c.aggregated_crossings_id = cdo.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_observations_vw cuo on c.aggregated_crossings_id = cuo.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_crossings cd on c.aggregated_crossings_id = cd.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on c.aggregated_crossings_id = ad.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_anthropogenic au on c.aggregated_crossings_id = au.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_per_model_vw aum on c.aggregated_crossings_id = aum.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat h on c.aggregated_crossings_id = h.aggregated_crossings_id
left outer join bcfishpass.streams s on c.linear_feature_id = s.linear_feature_id
left outer join whse_basemapping.dbm_mof_50k_grid t ON ST_Intersects(c.geom, t.geom)
order by c.aggregated_crossings_id, s.downstream_route_measure;

create unique index on bcfishpass.crossings_vw (aggregated_crossings_id);
create index on bcfishpass.crossings_vw using gist (geom);


-- wcrp version of the output crossings view -
create materialized view bcfishpass.crossings_wcrp_vw as
select
  -- joining to streams based on measure can be error prone due to precision.
  -- Join to streams on linear_feature_id and keep the first result
  -- (since streams are segmented there is often >1 match)
  distinct on (c.aggregated_crossings_id)
  c.aggregated_crossings_id,
  c.stream_crossing_id,
  c.dam_id,
  c.user_barrier_anthropogenic_id,
  c.modelled_crossing_id,
  c.crossing_source,
  cft.crossing_feature_type,
  c.pscis_status,
  c.crossing_type_code,
  c.crossing_subtype_code,
  array_to_string(c.modelled_crossing_type_source, ';') as modelled_crossing_type_source,
  c.barrier_status,
  c.pscis_road_name,
  c.pscis_stream_name,
  c.pscis_assessment_comment,
  c.pscis_assessment_date,
  c.pscis_final_score,
  c.transport_line_structured_name_1,
  c.transport_line_type_description,
  c.transport_line_surface_description,
  c.ften_forest_file_id,
  c.ften_file_type_description,
  c.ften_client_number,
  c.ften_client_name,
  c.ften_life_cycle_status_code,
  c.rail_track_name,
  c.rail_owner_name,
  c.rail_operator_english_name,
  c.ogc_proponent,
  c.dam_name,
  c.dam_height,
  c.dam_owner,
  c.dam_use,
  c.dam_operating_status,
  c.utm_zone,
  c.utm_easting,
  c.utm_northing,
  t.map_tile_display_name as dbm_mof_50k_grid,
  c.linear_feature_id,
  c.blue_line_key,
  c.watershed_key,
  c.downstream_route_measure,
  c.wscode_ltree as wscode,
  c.localcode_ltree as localcode,
  c.watershed_group_code,
  c.gnis_stream_name,
  c.stream_order,
  c.stream_magnitude,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(cdo.observedspp_dnstr, ';') as observedspp_dnstr,
  array_to_string(cuo.observedspp_upstr, ';') as observedspp_upstr,
  array_to_string(cd.features_dnstr, ';') as crossings_dnstr,
  array_to_string(ad.features_dnstr, ';') as barriers_anthropogenic_dnstr,
  coalesce(array_length(ad.features_dnstr, 1), 0) as barriers_anthropogenic_dnstr_count,
  array_to_string(au.features_upstr, ';') as barriers_anthropogenic_upstr,
  coalesce(array_length(au.features_upstr, 1), 0) as barriers_anthropogenic_upstr_count,
  array_to_string(aum.barriers_upstr_bt, ';') as barriers_anthropogenic_bt_upstr,
  coalesce(array_length(aum.barriers_upstr_bt, 1), 0) as barriers_anthropogenic_upstr_bt_count,
  array_to_string(aum.barriers_upstr_ch_cm_co_pk_sk, ';') as barriers_anthropogenic_ch_cm_co_pk_sk_upstr,
  coalesce(array_length(aum.barriers_upstr_ch_cm_co_pk_sk, 1), 0) as barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count,
  array_to_string(aum.barriers_upstr_st, ';') as barriers_anthropogenic_st_upstr,
  coalesce(array_length(aum.barriers_upstr_st, 1), 0) as barriers_anthropogenic_st_upstr_count,
  array_to_string(aum.barriers_upstr_wct, ';') as barriers_anthropogenic_wct_upstr,
  coalesce(array_length(aum.barriers_upstr_wct, 1), 0) as barriers_anthropogenic_wct_upstr_count,
  a.gradient,
  a.total_network_km,
  a.total_stream_km,
  a.total_lakereservoir_ha,
  a.total_wetland_ha,
  a.total_slopeclass03_waterbodies_km,
  a.total_slopeclass03_km,
  a.total_slopeclass05_km,
  a.total_slopeclass08_km,
  a.total_slopeclass15_km,
  a.total_slopeclass22_km,
  a.total_slopeclass30_km,
  a.total_belowupstrbarriers_network_km,
  a.total_belowupstrbarriers_stream_km,
  a.total_belowupstrbarriers_lakereservoir_ha,
  a.total_belowupstrbarriers_wetland_ha,
  a.total_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.total_belowupstrbarriers_slopeclass03_km,
  a.total_belowupstrbarriers_slopeclass05_km,
  a.total_belowupstrbarriers_slopeclass08_km,
  a.total_belowupstrbarriers_slopeclass15_km,
  a.total_belowupstrbarriers_slopeclass22_km,
  a.total_belowupstrbarriers_slopeclass30_km,

  -- access models
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  a.ch_cm_co_pk_sk_network_km,
  a.ch_cm_co_pk_sk_stream_km,
  a.ch_cm_co_pk_sk_lakereservoir_ha,
  a.ch_cm_co_pk_sk_wetland_ha,
  a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
  a.ch_cm_co_pk_sk_slopeclass03_km,
  a.ch_cm_co_pk_sk_slopeclass05_km,
  a.ch_cm_co_pk_sk_slopeclass08_km,
  a.ch_cm_co_pk_sk_slopeclass15_km,
  a.ch_cm_co_pk_sk_slopeclass22_km,
  a.ch_cm_co_pk_sk_slopeclass30_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
  a.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  a.st_network_km,
  a.st_stream_km,
  a.st_lakereservoir_ha,
  a.st_wetland_ha,
  a.st_slopeclass03_waterbodies_km,
  a.st_slopeclass03_km,
  a.st_slopeclass05_km,
  a.st_slopeclass08_km,
  a.st_slopeclass15_km,
  a.st_slopeclass22_km,
  a.st_slopeclass30_km,
  a.st_belowupstrbarriers_network_km,
  a.st_belowupstrbarriers_stream_km,
  a.st_belowupstrbarriers_lakereservoir_ha,
  a.st_belowupstrbarriers_wetland_ha,
  a.st_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.st_belowupstrbarriers_slopeclass03_km,
  a.st_belowupstrbarriers_slopeclass05_km,
  a.st_belowupstrbarriers_slopeclass08_km,
  a.st_belowupstrbarriers_slopeclass15_km,
  a.st_belowupstrbarriers_slopeclass22_km,
  a.st_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
  a.wct_network_km,
  a.wct_stream_km,
  a.wct_lakereservoir_ha,
  a.wct_wetland_ha,
  a.wct_slopeclass03_waterbodies_km,
  a.wct_slopeclass03_km,
  a.wct_slopeclass05_km,
  a.wct_slopeclass08_km,
  a.wct_slopeclass15_km,
  a.wct_slopeclass22_km,
  a.wct_slopeclass30_km,
  a.wct_belowupstrbarriers_network_km,
  a.wct_belowupstrbarriers_stream_km,
  a.wct_belowupstrbarriers_lakereservoir_ha,
  a.wct_belowupstrbarriers_wetland_ha,
  a.wct_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.wct_belowupstrbarriers_slopeclass03_km,
  a.wct_belowupstrbarriers_slopeclass05_km,
  a.wct_belowupstrbarriers_slopeclass08_km,
  a.wct_belowupstrbarriers_slopeclass15_km,
  a.wct_belowupstrbarriers_slopeclass22_km,
  a.wct_belowupstrbarriers_slopeclass30_km,

  -- habitat models
  h.ch_spawning_km,
  h.ch_rearing_km,
  h.ch_spawning_belowupstrbarriers_km,
  h.ch_rearing_belowupstrbarriers_km,
  h.cm_spawning_km,
  h.cm_spawning_belowupstrbarriers_km,
  h.co_spawning_km,
  h_wcrp.co_rearing_km,
  h.co_rearing_ha,
  h.co_spawning_belowupstrbarriers_km,
  h_wcrp.co_rearing_belowupstrbarriers_km,
  h.co_rearing_belowupstrbarriers_ha,
  h.pk_spawning_km,
  h.pk_spawning_belowupstrbarriers_km,
  h.sk_spawning_km,
  h_wcrp.sk_rearing_km,
  h.sk_rearing_ha,
  h.sk_spawning_belowupstrbarriers_km,
  h_wcrp.sk_rearing_belowupstrbarriers_km,
  h.sk_rearing_belowupstrbarriers_ha,
  h.st_spawning_km,
  h.st_rearing_km,
  h.st_spawning_belowupstrbarriers_km,
  h.st_rearing_belowupstrbarriers_km,
  h.wct_spawning_km,
  h.wct_rearing_km,
  h.wct_spawning_belowupstrbarriers_km,
  h.wct_rearing_belowupstrbarriers_km,
  h_wcrp.all_spawning_km,
  h_wcrp.all_spawning_belowupstrbarriers_km,
  h_wcrp.all_rearing_km,
  h_wcrp.all_rearing_belowupstrbarriers_km,
  h_wcrp.all_spawningrearing_km,
  h_wcrp.all_spawningrearing_belowupstrbarriers_km,
  c.geom
from bcfishpass.crossings c
inner join bcfishpass.crossings_feature_type_vw cft on c.aggregated_crossings_id = cft.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_observations_vw cdo on c.aggregated_crossings_id = cdo.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_observations_vw cuo on c.aggregated_crossings_id = cuo.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_crossings cd on c.aggregated_crossings_id = cd.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on c.aggregated_crossings_id = ad.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_anthropogenic au on c.aggregated_crossings_id = au.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_per_model_vw aum on c.aggregated_crossings_id = aum.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat h on c.aggregated_crossings_id = h.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat_wcrp h_wcrp on c.aggregated_crossings_id = h_wcrp.aggregated_crossings_id
left outer join bcfishpass.streams s on c.linear_feature_id = s.linear_feature_id
left outer join whse_basemapping.dbm_mof_50k_grid t ON ST_Intersects(c.geom, t.geom)
order by c.aggregated_crossings_id, s.downstream_route_measure;

create unique index on bcfishpass.crossings_wcrp_vw (aggregated_crossings_id);
create index on bcfishpass.crossings_wcrp_vw using gist (geom);