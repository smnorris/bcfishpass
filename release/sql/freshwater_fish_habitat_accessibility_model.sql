-- for publication to DataBC Catalouge
-- freshwater_fish_habitat_accessibility_MODEL.gpkg.zip

drop materialized view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_salmon_vw;

create materialized view bcfishpass.freshwater_fish_habitat_accessibility_model_salmon_vw as

with observations as
(
  select 
    segmented_stream_id,
    array_agg(fish_observation_point_id) FILTER (WHERE fish_observation_point_id IS NOT NULL) AS obsrvtn_ids_upstr,
    array_agg(observation_date) FILTER (WHERE fish_observation_point_id IS NOT NULL) AS obsrvtn_dates_upstr,
    array_agg(DISTINCT (species_code)) FILTER (WHERE fish_observation_point_id IS NOT NULL) as obsrvtn_species_codes_upstr
  from (
  select distinct
    s.segmented_stream_id,  
    o.species_code,
    o.fish_observation_point_id,
    o.observation_date
  from bcfishpass.streams s
  left outer join bcfishpass.observations_vw o
  on FWA_Upstream(
          s.blue_line_key,
          s.downstream_route_measure,
          s.wscode_ltree,
          s.localcode_ltree,
          o.blue_line_key,
          o.downstream_route_measure,
          o.wscode_ltree,
          o.localcode_ltree,
          False,
          1
        )
  and s.watershed_group_code = o.watershed_group_code
  where o.species_code in ('CH','CM','CO','PK','SK')
  and s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
  ) as f
  group by segmented_stream_id
)

select 
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.downstream_route_measure,
  s.upstream_route_measure,
  s.watershed_group_code,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.feature_code,
  array_to_string(o.obsrvtn_ids_upstr, ';') as obsrvtn_ids_upstr,
  array_to_string(o.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(s.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(s.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(s.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  s.dam_dnstr_ind,
  s.dam_hydro_dnstr_ind,
  s.remediated_dnstr_ind,
  s.geom
from bcfishpass.streams s
left outer join observations o
on s.segmented_stream_id = o.segmented_stream_id
where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[];


drop materialized view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_steelhead_vw;

create materialized view bcfishpass.freshwater_fish_habitat_accessibility_model_steelhead_vw as
with observations as
(
  select 
    segmented_stream_id,
    array_agg(fish_observation_point_id) FILTER (WHERE fish_observation_point_id IS NOT NULL) AS obsrvtn_ids_upstr,
    array_agg(observation_date) FILTER (WHERE fish_observation_point_id IS NOT NULL) AS obsrvtn_dates_upstr,
    array_agg(DISTINCT (species_code)) FILTER (WHERE fish_observation_point_id IS NOT NULL) as obsrvtn_species_codes_upstr
  from (
  select distinct
    s.segmented_stream_id,  
    o.species_code,
    o.fish_observation_point_id,
    o.observation_date
  from bcfishpass.streams s
  left outer join bcfishpass.observations_vw o
  on FWA_Upstream(
          s.blue_line_key,
          s.downstream_route_measure,
          s.wscode_ltree,
          s.localcode_ltree,
          o.blue_line_key,
          o.downstream_route_measure,
          o.wscode_ltree,
          o.localcode_ltree,
          False,
          1
        )
  and s.watershed_group_code = o.watershed_group_code
  where o.species_code = 'ST' 
  and s.barriers_st_dnstr = array[]::text[]
  ) as f
  group by segmented_stream_id
)

select 
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.upstream_route_measure,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.feature_code,
  array_to_string(o.obsrvtn_ids_upstr, ';') as obsrvtn_ids_upstr,
  array_to_string(o.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(s.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(s.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(s.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  s.dam_dnstr_ind,
  s.dam_hydro_dnstr_ind,
  s.remediated_dnstr_ind,
  s.geom
from bcfishpass.streams s
left outer join observations o
on s.segmented_stream_id = o.segmented_stream_id
where barriers_st_dnstr = array[]::text[];


-- no views required for barrier tables, they can be used directly (only change would be renaming wscode/localcode)

-- dump observations for salmon and steelhead used in this analysis
drop materialized view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw;
create materialized view bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw as
select * from bcfishpass.observations_vw 
where species_code in ('CH','CM','CO','PK','SK','ST');


-- dump crossings 

drop materialized view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw;
create materialized view bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw as
select
 c.aggregated_crossings_id,
 c.stream_crossing_id,
 c.dam_id,
 c.user_barrier_anthropogenic_id,
 c.modelled_crossing_id,
 c.crossing_source,
 c.crossing_feature_type,
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
 c.dbm_mof_50k_grid,
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
 array_to_string(c.observedspp_dnstr, ';') as observedspp_dnstr,
 array_to_string(c.observedspp_upstr, ';') as observedspp_upstr,
 array_to_string(c.crossings_dnstr, ';') as crossings_dnstr,
 array_to_string(c.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
 array_to_string(c.barriers_anthropogenic_upstr, ';') as barriers_anthropogenic_upstr,
 coalesce(array_length(barriers_anthropogenic_dnstr, 1), 0) as barriers_anthropogenic_dnstr_count,
 coalesce(array_length(barriers_anthropogenic_upstr, 1), 0) as barriers_anthropogenic_upstr_count,
 r.gradient,
 r.total_network_km,
 r.total_stream_km,
 r.total_lakereservoir_ha,
 r.total_wetland_ha,
 r.total_slopeclass03_waterbodies_km,
 r.total_slopeclass03_km,
 r.total_slopeclass05_km,
 r.total_slopeclass08_km,
 r.total_slopeclass15_km,
 r.total_slopeclass22_km,
 r.total_slopeclass30_km,
 r.total_belowupstrbarriers_network_km,
 r.total_belowupstrbarriers_stream_km,
 r.total_belowupstrbarriers_lakereservoir_ha,
 r.total_belowupstrbarriers_wetland_ha,
 r.total_belowupstrbarriers_slopeclass03_waterbodies_km,
 r.total_belowupstrbarriers_slopeclass03_km,
 r.total_belowupstrbarriers_slopeclass05_km,
 r.total_belowupstrbarriers_slopeclass08_km,
 r.total_belowupstrbarriers_slopeclass15_km,
 r.total_belowupstrbarriers_slopeclass22_km,
 r.total_belowupstrbarriers_slopeclass30_km,
 array_to_string(r.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
 r.ch_cm_co_pk_sk_network_km,
 r.ch_cm_co_pk_sk_stream_km,
 r.ch_cm_co_pk_sk_lakereservoir_ha,
 r.ch_cm_co_pk_sk_wetland_ha,
 r.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
 r.ch_cm_co_pk_sk_slopeclass03_km,
 r.ch_cm_co_pk_sk_slopeclass05_km,
 r.ch_cm_co_pk_sk_slopeclass08_km,
 r.ch_cm_co_pk_sk_slopeclass15_km,
 r.ch_cm_co_pk_sk_slopeclass22_km,
 r.ch_cm_co_pk_sk_slopeclass30_km,
 r.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
 r.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
 r.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
 r.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
 r.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
 r.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
 r.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
 r.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
 r.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
 r.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
 r.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,
 array_to_string(r.barriers_st_dnstr, ';') as barriers_st_dnstr,
 r.st_network_km,
 r.st_stream_km,
 r.st_lakereservoir_ha,
 r.st_wetland_ha,
 r.st_slopeclass03_waterbodies_km,
 r.st_slopeclass03_km,
 r.st_slopeclass05_km,
 r.st_slopeclass08_km,
 r.st_slopeclass15_km,
 r.st_slopeclass22_km,
 r.st_slopeclass30_km,
 r.st_belowupstrbarriers_network_km,
 r.st_belowupstrbarriers_stream_km,
 r.st_belowupstrbarriers_lakereservoir_ha,
 r.st_belowupstrbarriers_wetland_ha,
 r.st_belowupstrbarriers_slopeclass03_waterbodies_km,
 r.st_belowupstrbarriers_slopeclass03_km,
 r.st_belowupstrbarriers_slopeclass05_km,
 r.st_belowupstrbarriers_slopeclass08_km,
 r.st_belowupstrbarriers_slopeclass15_km,
 r.st_belowupstrbarriers_slopeclass22_km,
 r.st_belowupstrbarriers_slopeclass30_km,
 c.geom
 from bcfishpass.crossings c
 left outer join bcfishpass.crossings_upstream_access r
 on c.aggregated_crossings_id = r.aggregated_crossings_id;
create index on bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw using gist (geom);