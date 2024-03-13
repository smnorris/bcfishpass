-- for fptwg reporting
create materialized view bcfishpass.fwa_assessment_watersheds_waterbodies_vw as

with lakes as (
  select
    w.watershed_feature_id,
    wb.waterbody_poly_id,
    case
      when st_coveredby(wb.geom, w.geom) then wb.geom
    else
      st_intersection(wb.geom, w.geom)
    end as geom
  from whse_basemapping.fwa_assessment_watersheds_poly w
  inner join whse_basemapping.fwa_lakes_poly wb on st_intersects(w.geom, wb.geom)
  and w.watershed_group_code = wb.watershed_group_code
),

reservoirs as (
  select
    w.watershed_feature_id,
    wb.waterbody_poly_id,
    case
      when st_coveredby(wb.geom, w.geom) then wb.geom
    else
      st_intersection(wb.geom, w.geom)
    end as geom
  from whse_basemapping.fwa_assessment_watersheds_poly w
  inner join whse_basemapping.fwa_manmade_waterbodies_poly wb on st_intersects(w.geom, wb.geom)
  and w.watershed_group_code = wb.watershed_group_code
),

wetlands as (
  select
    w.watershed_feature_id,
    wb.waterbody_poly_id,
    case
      when st_coveredby(wb.geom, w.geom) then wb.geom
    else
      st_intersection(wb.geom, w.geom)
    end as geom
  from whse_basemapping.fwa_assessment_watersheds_poly w
  inner join whse_basemapping.fwa_manmade_waterbodies_poly wb on st_intersects(w.geom, wb.geom)
  and w.watershed_group_code = wb.watershed_group_code
)

select
  a.watershed_feature_id,
  count(distinct l.waterbody_poly_id) as n_lakes,
  round((sum(st_area(l.geom)) / 10000)::numeric, 2) as area_lakes,
  count(distinct m.waterbody_poly_id) as n_manmade_waterbodies,
  round((sum(st_area(m.geom)) / 10000)::numeric, 2) as area_manmade_waterbodies,
  count(distinct w.waterbody_poly_id) as n_wetlands,
  round((sum(st_area(w.geom)) / 10000)::numeric, 2) as area_wetlands
from whse_basemapping.fwa_assessment_watersheds_poly a
left outer join lakes l on a.watershed_feature_id = l.watershed_feature_id
left outer join reservoirs m on a.watershed_feature_id = m.watershed_feature_id
left outer join wetlands w on a.watershed_feature_id = w.watershed_feature_id
group by a.watershed_feature_id
order by a.watershed_feature_id;

create index on bcfishpass.fwa_assessment_watersheds_waterbodies_vw (watershed_feature_id);

create materialized view bcfishpass.fptwg_summary_linear as
  select
    l.assmnt_watershed_id as watershed_feature_id,
    sum(st_length(geom)) as length_total,
    sum(st_length(geom)) filter (where stream_order = 1) as length_total_order1,
    sum(st_length(geom)) filter (where stream_order = 2) as length_total_order2,
    sum(st_length(geom)) filter (where stream_order = 3) as length_total_order3,
    sum(st_length(geom)) filter (where stream_order = 4) as length_total_order4,
    sum(st_length(geom)) filter (where stream_order = 5) as length_total_order5,
    sum(st_length(geom)) filter (where stream_order = 6) as length_total_order6,
    sum(st_length(geom)) filter (where stream_order = 7) as length_total_order7,
    sum(st_length(geom)) filter (where stream_order = 8) as length_total_order8,
    sum(st_length(geom)) filter (where stream_order = 9) as length_total_order9,
    sum(st_length(geom)) filter (where cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon,
    sum(st_length(geom)) filter (where cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0 and obsrvtn_species_codes_upstr && array['CH','CM','CO','PK','SK']) as length_potentiallyaccessible_salmon_observed,
    sum(st_length(geom)) filter (where cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_salmon_accessible_a,
    sum(st_length(geom)) filter (where cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0 and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_salmon_accessible_b,
    sum(st_length(geom)) filter (where cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead,
    sum(st_length(geom)) filter (where cardinality(barriers_st_dnstr) = 0 and 'ST' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_steelhead_observed,
    sum(st_length(geom)) filter (where cardinality(barriers_st_dnstr) = 0 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_steelhead_accessible_a,
    sum(st_length(geom)) filter (where cardinality(barriers_st_dnstr) = 0 and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_steelhead_accessible_b,
    sum(st_length(geom)) filter (where stream_order = 1 and cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon_order1,
    sum(st_length(geom)) filter (where stream_order = 2 and cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon_order2,
    sum(st_length(geom)) filter (where stream_order = 3 and cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon_order3,
    sum(st_length(geom)) filter (where stream_order = 4 and cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon_order4,
    sum(st_length(geom)) filter (where stream_order = 5 and cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon_order5,
    sum(st_length(geom)) filter (where stream_order = 6 and cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon_order6,
    sum(st_length(geom)) filter (where stream_order = 7 and cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon_order7,
    sum(st_length(geom)) filter (where stream_order = 8 and cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon_order8,
    sum(st_length(geom)) filter (where stream_order = 9 and cardinality(barriers_ch_cm_co_pk_sk_dnstr) = 0) as length_potentiallyaccessible_salmon_order9,
    sum(st_length(geom)) filter (where stream_order = 1 and cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead_order1,
    sum(st_length(geom)) filter (where stream_order = 2 and cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead_order2,
    sum(st_length(geom)) filter (where stream_order = 3 and cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead_order3,
    sum(st_length(geom)) filter (where stream_order = 4 and cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead_order4,
    sum(st_length(geom)) filter (where stream_order = 5 and cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead_order5,
    sum(st_length(geom)) filter (where stream_order = 6 and cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead_order6,
    sum(st_length(geom)) filter (where stream_order = 7 and cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead_order7,
    sum(st_length(geom)) filter (where stream_order = 8 and cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead_order8,
    sum(st_length(geom)) filter (where stream_order = 9 and cardinality(barriers_st_dnstr) = 0) as length_potentiallyaccessible_steelhead_order9
  from bcfishpass.streams s
  inner join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
  inner join whse_basemapping.fwa_assessment_watersheds_streams_lut l on s.linear_feature_id = l.linear_feature_id
  group by l.assmnt_watershed_id;
create index on bcfishpass.fptwg_summary_linear (watershed_feature_id);

create materialized view bcfishpass.fptwg_summary_crossings as
select
  l.assmnt_watershed_id as watershed_feature_id,
  count(*) as n_crossings_total,
  count(*) filter (where crossing_feature_type = 'DAM') as n_dam,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'PASSABLE') as n_dam_passable,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'POTENTIAL') as n_dam_potential,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'UNKNOWN') as n_dam_unknown,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER') as n_dam_barrier,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_dam_barrier_salmon,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_dam_barrier_steelhead,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'ASSESSED') as n_pscisassessment,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'HABITAT CONFIRMATION') as n_pscisconfirmation,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'DESIGN') as n_pscisdesign,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'REMEDIATED') as n_pscisremediation,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'PASSABLE') as n_pscis_passable,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'POTENTIAL') as n_pscis_potential,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'UNKNOWN') as n_pscis_unknown,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER') as n_pscis_barrier,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_pscis_barrier_salmon,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_pscis_barrier_steelhead,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS') as n_modelledxings,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'PASSABLE') as n_modelledxings_passable,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'POTENTIAL') as n_modelledxings_potential,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'UNKNOWN') as n_modelledxings_unknown,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER') as n_modelledxings_barrier,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_modelledxings_barrier_salmon,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_modelledxings_barrier_steelhead,
  count(*) filter (where crossing_source = 'MISC BARRIERS') as n_miscbarriers,
  count(*) filter (where crossing_source = 'MISC BARRIERS' and barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_miscbarriers_barrier_salmon,
  count(*) filter (where crossing_source = 'MISC BARRIERS' and barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_miscbarriers_barrier_steelhead
from bcfishpass.crossings_vw c
inner join whse_basemapping.fwa_assessment_watersheds_streams_lut l on c.linear_feature_id = l.linear_feature_id
group by l.assmnt_watershed_id;
create index on bcfishpass.fptwg_summary_crossings (watershed_feature_id);

create materialized view bcfishpass.fptwg_summary_observations as
select
  l.assmnt_watershed_id as watershed_feature_id,
  count(*) as n_fishobservations,
  array_agg(distinct o.species_code order by o.species_code) as speciesobserved,
  array_length(array_agg(distinct o.species_code order by o.species_code), 1) as n_speciesobserved,
  count(*) filter (where o.species_code in ('CH','CM','CO','PK','SK')) as n_salmonobservations,
  count(*) filter (where o.species_code = 'ST') as n_steelheadobservations,
  count(*) filter (where o.species_code in ('ACT', 'ADV', 'CH', 'CM', 'CO', 'EU', 'GSG', 'PK', 'PL', 'RL', 'SK', 'ST', 'WSG')) as n_anadromousobservations
from bcfishobs.fiss_fish_obsrvtn_events_vw o
inner join whse_basemapping.fwa_assessment_watersheds_streams_lut l on o.linear_feature_id = l.linear_feature_id
group by l.assmnt_watershed_id;
create index on bcfishpass.fptwg_summary_observations (watershed_feature_id);

create materialized view bcfishpass.fptwg_summary_roads as
with roads as (
  select
    w.watershed_feature_id,
    case when
      c.description IN (
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
      when upper(c.description) LIKE 'TRAIL%' then 'TRAIL'
      when c.description is not NULL then 'ROAD, RESOURCE/OTHER'
    end as road_type,
    case
      when st_coveredby(r.geom, w.geom) then r.geom
    else
      st_intersection(r.geom, w.geom)
    end as geom
  from whse_basemapping.fwa_assessment_watersheds_poly w
  inner join whse_basemapping.transport_line r on st_intersects(w.geom, r.geom)
  inner join whse_basemapping.transport_line_type_code c on r.transport_line_type_code = c.transport_line_type_code
  where r.transport_line_type_code NOT IN ('F','FP','FR','T','TR','TS','RP','RWA')      -- exclude trails other than demographic and all ferry/water
  and r.transport_line_surface_code != 'D'                                              -- exclude decomissioned roads
  and coalesce(r.transport_line_structure_code, '') != 'T'                              -- exclude tunnels

  UNION ALL

  select
    w.watershed_feature_id,
    'RAIL' as road_type,
    case
      when st_coveredby(r.geom, w.geom) then r.geom
    else
      st_intersection(r.geom, w.geom)
    end as geom
  from whse_basemapping.fwa_assessment_watersheds_poly w
  inner join whse_basemapping.gba_railway_tracks_sp r on st_intersects(w.geom, r.geom)
  WHERE r.track_classification not in ('Ferry Route', 'Yard', 'Siding')   -- do we want to exclude yard/siding from this linear summary? this is the query for modelled xings
)

select
  watershed_feature_id,
  sum(st_length(geom)) filter (where road_type = 'RAIL') as length_rail,
  sum(st_length(geom)) filter (where road_type = 'ROAD, RESOURCE/OTHER') as length_resourceroad,
  sum(st_length(geom)) filter (where road_type = 'ROAD, DEMOGRAPHIC') as length_demographicroad,
  sum(st_length(geom)) filter (where road_type = 'TRAIL') as length_trail
from roads
where st_dimension(geom) = 1
group by watershed_feature_id;
create index on bcfishpass.fptwg_summary_roads (watershed_feature_id);

create view bcfishpass.fptwg_summary as
select
  a.watershed_feature_id,
  a.watershed_group_code,
  a.gnis_name_1,
  a.wscode_ltree as wscode,
  a.localcode_ltree as localcode,
  a.left_right_tributary,
  a.watershed_order,
  a.watershed_magnitude,
  a.local_watershed_order,
  a.local_watershed_magnitude,
  wb.n_lakes,
  wb.area_lakes,
  wb.n_manmade_waterbodies,
  wb.area_manmade_waterbodies,
  wb.n_wetlands,
  wb.area_wetlands,
  l.length_total,
  l.length_total_order1,
  l.length_total_order2,
  l.length_total_order3,
  l.length_total_order4,
  l.length_total_order5,
  l.length_total_order6,
  l.length_total_order7,
  l.length_total_order8,
  l.length_total_order9,
  l.length_potentiallyaccessible_salmon,
  l.length_potentiallyaccessible_salmon_observed,
  l.length_potentiallyaccessible_salmon_accessible_a,
  l.length_potentiallyaccessible_salmon_accessible_b,
  l.length_potentiallyaccessible_steelhead,
  l.length_potentiallyaccessible_steelhead_observed,
  l.length_potentiallyaccessible_steelhead_accessible_a,
  l.length_potentiallyaccessible_steelhead_accessible_b,
  l.length_potentiallyaccessible_salmon_order1,
  l.length_potentiallyaccessible_salmon_order2,
  l.length_potentiallyaccessible_salmon_order3,
  l.length_potentiallyaccessible_salmon_order4,
  l.length_potentiallyaccessible_salmon_order5,
  l.length_potentiallyaccessible_salmon_order6,
  l.length_potentiallyaccessible_salmon_order7,
  l.length_potentiallyaccessible_salmon_order8,
  l.length_potentiallyaccessible_salmon_order9,
  l.length_potentiallyaccessible_steelhead_order1,
  l.length_potentiallyaccessible_steelhead_order2,
  l.length_potentiallyaccessible_steelhead_order3,
  l.length_potentiallyaccessible_steelhead_order4,
  l.length_potentiallyaccessible_steelhead_order5,
  l.length_potentiallyaccessible_steelhead_order6,
  l.length_potentiallyaccessible_steelhead_order7,
  l.length_potentiallyaccessible_steelhead_order8,
  l.length_potentiallyaccessible_steelhead_order9,

  l.length_potentiallyaccessible_salmon / l.length_total as pct_total_potentiallyaccessible_salmon,
  l.length_potentiallyaccessible_salmon_observed / l.length_total as pct_total_potentiallyaccessible_salmon_observed,
  l.length_potentiallyaccessible_salmon_accessible_a  / l.length_total as pct_total_potentiallyaccessible_salmon_accessible_a,
  l.length_potentiallyaccessible_salmon_accessible_b  / l.length_total as pct_total_potentiallyaccessible_salmon_accessible_b,
  l.length_potentiallyaccessible_salmon_accessible_a / l.length_potentiallyaccessible_salmon as pct_potentiallyaccessible_salmon_accessible_a,
  l.length_potentiallyaccessible_salmon_accessible_b / l.length_potentiallyaccessible_salmon as pct_potentiallyaccessible_salmon_accessible_b,
  l.length_potentiallyaccessible_steelhead / l.length_total as pct_total_potentiallyaccessible_steelhead,
  l.length_potentiallyaccessible_steelhead_observed / l.length_total as pct_total_potentiallyaccessible_steelhead_observed,
  l.length_potentiallyaccessible_steelhead_accessible_a / l.length_total as pct_total_potentiallyaccessible_steelhead_accessible_a,
  l.length_potentiallyaccessible_steelhead_accessible_b / l.length_total as pct_total_potentiallyaccessible_steelhead_accessible_b,
  l.length_potentiallyaccessible_steelhead_accessible_a / l.length_potentiallyaccessible_steelhead as pct_potentiallyaccessible_steelhead_accessible_a,
  l.length_potentiallyaccessible_steelhead_accessible_b / l.length_potentiallyaccessible_steelhead as pct_potentiallyaccessible_steelhead_accessible_b,

  c.n_crossings_total,
  c.n_dam,
  c.n_dam_passable,
  c.n_dam_potential,
  c.n_dam_unknown,
  c.n_dam_barrier,
  c.n_dam_barrier_salmon,
  c.n_dam_barrier_steelhead,
  c.n_pscisassessment,
  c.n_pscisconfirmation,
  c.n_pscisdesign,
  c.n_pscisremediation,
  c.n_pscis_passable,
  c.n_pscis_potential,
  c.n_pscis_unknown,
  c.n_pscis_barrier,
  c.n_pscis_barrier_salmon,
  c.n_pscis_barrier_steelhead,
  c.n_modelledxings,
  c.n_modelledxings_passable,
  c.n_modelledxings_potential,
  c.n_modelledxings_unknown,
  c.n_modelledxings_barrier,
  c.n_modelledxings_barrier_salmon,
  c.n_modelledxings_barrier_steelhead,
  c.n_miscbarriers,
  c.n_miscbarriers_barrier_salmon,
  c.n_miscbarriers_barrier_steelhead,
  o.n_fishobservations,
  o.speciesobserved,
  o.n_speciesobserved,
  o.n_salmonobservations,
  o.n_steelheadobservations,
  o.n_anadromousobservations,
  r.length_rail,
  r.length_resourceroad,
  r.length_demographicroad,
  r.length_trail,
  a.geom
from whse_basemapping.fwa_assessment_watersheds_poly a
left outer join bcfishpass.fwa_assessment_watersheds_waterbodies_vw wb on a.watershed_feature_id = wb.watershed_feature_id
left outer join bcfishpass.fptwg_summary_linear l on a.watershed_feature_id = l.watershed_feature_id
left outer join bcfishpass.fptwg_summary_crossings c on a.watershed_feature_id = c.watershed_feature_id
left outer join bcfishpass.fptwg_summary_observations o on a.watershed_feature_id = o.watershed_feature_id
left outer join bcfishpass.fptwg_summary_roads r on a.watershed_feature_id = r.watershed_feature_id;