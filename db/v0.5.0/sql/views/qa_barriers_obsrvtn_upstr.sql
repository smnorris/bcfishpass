-- list barriers to salmon having salmon observations upstream


-- natural barriers to salmon (having <5 salmon observations upstream since 1990)
create materialized view bcfishpass.qa_barriers_natural_obsrvtn_upstr_ch_cm_co_pk_sk as
select
  b.barriers_ch_cm_co_pk_sk_id,
  b.barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code,
  count(*) as n_observations,
  array_agg(o.fish_observation_point_id) as fish_observation_point_id,
  array_agg(o.species_code) as species_codes,
  array_agg(o.observation_date) as observation_dates
from bcfishpass.barriers_ch_cm_co_pk_sk b
inner join bcfishpass.observations_vw o on
 fwa_upstream(
   b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode_ltree, o.localcode_ltree)
where o.species_code in ('CH','CM','CO','PK','SK')
group by
  b.barriers_ch_cm_co_pk_sk_id,
  b.barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code
order by barriers_ch_cm_co_pk_sk_id;



-- natural barriers to steelhead (having <5 salmon or steelhead observations upstream since 1990)
create materialized view bcfishpass.qa_barriers_natural_obsrvtn_upstr_st as
select
  b.barriers_st_id,
  b.barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code,
  count(*) as n_observations,
  array_agg(o.fish_observation_point_id) as fish_observation_point_id,
  array_agg(o.species_code) as species_codes,
  array_agg(o.observation_date) as observation_dates
from bcfishpass.barriers_st b
inner join bcfishpass.observations_vw o on
 fwa_upstream(
   b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode_ltree, o.localcode_ltree)
where o.species_code in ('CH','CM','CO','PK','SK','ST')
group by
  b.barriers_st_id,
  b.barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code
order by barriers_st_id;


-- dams, do not aggregate observation info
create materialized view bcfishpass.qa_barriers_dams_obsrvtn_upstr_ch_cm_co_pk_sk_st as
select
  d.dam_id,
  cabd.dam_name_en,
  cabd.owner,
  cabd.operating_status,
  cabd.construction_year,
  cabd.dam_use,
  case
    when cabd.passability_status_code = 1 THEN 'BARRIER'
    when cabd.passability_status_code = 2 THEN 'POTENTIAL'
    when cabd.passability_status_code = 3 THEN 'PASSABLE'
    when cabd.passability_status_code = 4 THEN 'UNKNOWN'
  end AS barrier_status,
  o.fish_observation_point_id,
  o.species_code,
  o.observation_date,
  s.agency_name,
  s.source,
  s.source_ref,
  s.activity,
  s.life_stage,
  s.acat_report_url
from bcfishpass.dams_vw d
inner join bcfishpass.observations_vw o on
 fwa_upstream(
   d.blue_line_key, d.downstream_route_measure, d.wscode_ltree, d.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode_ltree, o.localcode_ltree)
inner join cabd.dams cabd on d.dam_id = cabd.cabd_id::text and cabd.passability_status_code = 1
inner join whse_fish.fiss_fish_obsrvtn_pnt_sp s on o.fish_observation_point_id = s.fish_observation_point_id
where o.species_code in ('CH','CM','CO','PK','SK','ST')
order by dam_name_en, fish_observation_point_id;
