
begin;


-- recreate bcfishpass observations view - much the same as bcfishobs.observations, but target species only, and tidied up slightly

drop materialized view bcfishpass.observations_vw cascade;

create materialized view bcfishpass.observations_vw as

-- Convert the boolean species columns in wsg_species_presence into array of species presence for each wsg
-- (We could modify the input file's multiple spp columns into a single column of spp codes but current
-- design works fine and is easy to validate. Down side is that this query must be modified when spp are added)
with wsg_spp as
(
select
  watershed_group_code, string_to_array(array_to_string(array[bt, ch, cm, co, ct, dv, gr, pk, rb, sk, st, wct], ','),',') as species_codes
from (
  select
    p.watershed_group_code,
    case when p.bt is true then 'BT' else NULL end as bt,
    case when p.ch is true then 'CH' else NULL end as ch,
    case when p.cm is true then 'CM' else NULL end as cm,
    case when p.co is true then 'CO' else NULL end as co,
    case when p.ct is true then 'CT' else NULL end as ct,
    case when p.dv is true then 'DV' else NULL end as dv,
    case when p.gr is true then 'GR' else NULL end as gr,
    case when p.pk is true then 'PK' else NULL end as pk,
    case when p.rb is true then 'RB' else NULL end as rb,
    case when p.sk is true then 'SK' else NULL end as sk,
    case when p.st is true then 'ST' else NULL end as st,
    case when p.wct is true then 'WCT' else NULL end as wct
  from bcfishpass.wsg_species_presence p
  ) as f
),

-- simplify CT species codes
species_code_remap as (
  select distinct
    species_code,
    case
      when species_code = 'CCT' then 'CT'
      when species_code = 'ACT' then 'CT'
      when species_code = 'CT/RB' then 'CT'
      else species_code
    end as species_code_remap
  from bcfishobs.observations e
)

-- filter on species code and watershed group
select
 o.observation_key,
 o.fish_observation_point_id,
 r.species_code_remap as species_code,
 o.agency_id,
 o.point_type_code,
 o.observation_date,
 o.agency_name,
 o.source,
 o.source_ref,
 o.utm_zone,
 o.utm_easting,
 o.utm_northing,
 o.activity_code,
 o.activity,
 o.life_stage_code,
 o.life_stage,
 o.species_name,
 o.waterbody_identifier,
 o.waterbody_type,
 o.gazetted_name,
 o.new_watershed_code,
 o.trimmed_watershed_code,
 o.acat_report_url,
 o.feature_code,
 o.linear_feature_id,
 o.wscode as wscode_ltree,
 o.localcode as localcode_ltree,
 o.blue_line_key,
 o.watershed_group_code,
 o.downstream_route_measure,
 o.match_type,
 o.distance_to_stream,
 o.geom
from bcfishobs.observations o
inner join wsg_spp on o.watershed_group_code = wsg_spp.watershed_group_code
inner join species_code_remap r on o.species_code = r.species_code
and array[o.species_code]::text[] && wsg_spp.species_codes;

create unique index on bcfishpass.observations_vw (observation_key);
create index on bcfishpass.observations_vw using gist (wscode_ltree);
create index on bcfishpass.observations_vw using btree (wscode_ltree);
create index on bcfishpass.observations_vw using gist (localcode_ltree);
create index on bcfishpass.observations_vw using btree (localcode_ltree);

-- regenerate dependent objects

create materialized view bcfishpass.fptwg_summary_observations_vw as
select
  l.assmnt_watershed_id as watershed_feature_id,
  count(*) as n_fishobservations,
  array_agg(distinct o.species_code order by o.species_code) as speciesobserved,
  array_length(array_agg(distinct o.species_code order by o.species_code), 1) as n_speciesobserved,
  count(*) filter (where o.species_code in ('CH','CM','CO','PK','SK')) as n_salmonobservations,
  count(*) filter (where o.species_code = 'ST') as n_steelheadobservations,
  count(*) filter (where o.species_code in ('ACT', 'ADV', 'CCT', 'CH', 'CM', 'CO', 'EU', 'GSG', 'PK', 'PL', 'RL', 'SK', 'ST', 'WSG')) as n_anadromousobservations
from bcfishobs.observations o
inner join whse_basemapping.fwa_assessment_watersheds_streams_lut l on o.linear_feature_id = l.linear_feature_id
group by l.assmnt_watershed_id;
create index on bcfishpass.fptwg_summary_observations_vw (watershed_feature_id);

create view bcfishpass.fptwg_assmt_wsd_summary_vw as
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
left outer join bcfishpass.fptwg_summary_linear_vw l on a.watershed_feature_id = l.watershed_feature_id
left outer join bcfishpass.fptwg_summary_crossings_vw c on a.watershed_feature_id = c.watershed_feature_id
left outer join bcfishpass.fptwg_summary_observations_vw o on a.watershed_feature_id = o.watershed_feature_id
left outer join bcfishpass.fptwg_summary_roads_vw r on a.watershed_feature_id = r.watershed_feature_id;

--fptwg_assmt_wsd_summary_vw
--bcfishpass.dams_vw 
--bcfishpass.dams_not_matched_to_streams
--bcfishpass.falls_upstr_anadromous_vw
--bcfishpass.obsrvtn_above_barriers_ch_cm_co_pk_sk_st

commit;

--drop view bcfishobs.fiss_fish_obsrvtn_events_vw;
--drop table bcfishobs.fiss_fish_obsrvtn_events;
--drop table bcfishobs.fiss_fish_obsrvtn_unmatched;
--drop table bcfishobs.summary;
--
---- to recreate
--bcfishpass.crossings_dnstr_observations_vw depends on table bcfishobs.fiss_fish_obsrvtn_events
--bcfishpass.crossings_upstr_observations_vw depends on table bcfishobs.fiss_fish_obsrvtn_events
--bcfishpass.crossings_wcrp_vw depends on materialized view bcfishpass.crossings_upstr_observations_vw
--bcfishpass.crossings_vw depends on materialized view bcfishpass.crossings_upstr_observations_vw
--view bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw depends on materialized view bcfishpass.crossings_vw
--materialized view bcfishpass.fptwg_summary_crossings_vw depends on materialized view bcfishpass.crossings_vw

