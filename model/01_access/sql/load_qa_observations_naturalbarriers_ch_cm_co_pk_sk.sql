-- count barriers downstream of observations (salmon/steelhead)
truncate bcfishpass.qa_observations_ch_cm_co_pk_sk;

insert into bcfishpass.qa_observations_ch_cm_co_pk_sk (
  observation_key,
  species_code,
  observation_date,
  activity_code,
  activity,
  life_stage_code,
  life_stage,
  acat_report_url,
  agency_name,
  source,
  source_ref,
  watershed_group_code,
  gradient_15_dnstr,
  gradient_20_dnstr,
  gradient_25_dnstr,
  gradient_30_dnstr,
  falls_dnstr,
  subsurfaceflow_dnstr,
  gradient_15_dnstr_count,
  gradient_20_dnstr_count,
  gradient_25_dnstr_count,
  gradient_30_dnstr_count,
  falls_dnstr_count,
  subsurfaceflow_dnstr_count
)
select * from (
SELECT
  a.observation_key,
  a.species_code,
  a.observation_date,
  a.activity_code,
  a.activity,
  a.life_stage_code,
  a.life_stage,
  a.acat_report_url,
  a.agency_name,
  a.source,
  a.source_ref,
  a.watershed_group_code,
  array_to_string(array_agg(DISTINCT g15.gradient_barrier_id), ';') as gradient_15_dnstr,
  array_to_string(array_agg(DISTINCT g20.gradient_barrier_id), ';') as gradient_20_dnstr,
  array_to_string(array_agg(DISTINCT g25.gradient_barrier_id), ';') as gradient_25_dnstr,
  array_to_string(array_agg(DISTINCT g30.gradient_barrier_id), ';') as gradient_30_dnstr,
  array_to_string(array_agg(DISTINCT f.barriers_falls_id), ';') as falls_dnstr,
  array_to_string(array_agg(DISTINCT s.barriers_subsurfaceflow_id), ';') as subsurfaceflow_dnstr,
  count(DISTINCT g15.gradient_barrier_id) as gradient_15_dnstr_count,
  count(DISTINCT g20.gradient_barrier_id) as gradient_20_dnstr_count,
  count(DISTINCT g25.gradient_barrier_id) as gradient_25_dnstr_count,
  count(DISTINCT g30.gradient_barrier_id) as gradient_30_dnstr_count,
  count(DISTINCT f.barriers_falls_id) as falls_dnstr_count,
  count(DISTINCT s.barriers_subsurfaceflow_id) as subsurfaceflow_dnstr_count
FROM bcfishobs.observations a
LEFT OUTER JOIN bcfishpass.gradient_barriers g15
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode,
    a.localcode,
    g15.blue_line_key,
    g15.downstream_route_measure,
    g15.wscode_ltree,
    g15.localcode_ltree,
    False
) AND g15.gradient_class = 15
LEFT OUTER JOIN bcfishpass.gradient_barriers g20
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode,
    a.localcode,
    g20.blue_line_key,
    g20.downstream_route_measure,
    g20.wscode_ltree,
    g20.localcode_ltree,
    False
) AND g20.gradient_class = 20
LEFT OUTER JOIN bcfishpass.gradient_barriers g25
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode,
    a.localcode,
    g25.blue_line_key,
    g25.downstream_route_measure,
    g25.wscode_ltree,
    g25.localcode_ltree,
    False
) AND g25.gradient_class = 25
LEFT OUTER JOIN bcfishpass.gradient_barriers g30
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode,
    a.localcode,
    g30.blue_line_key,
    g30.downstream_route_measure,
    g30.wscode_ltree,
    g30.localcode_ltree,
    False
) AND g30.gradient_class = 30
LEFT OUTER JOIN bcfishpass.barriers_falls f
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode,
    a.localcode,
    f.blue_line_key,
    f.downstream_route_measure,
    f.wscode_ltree,
    f.localcode_ltree,
    False
)
LEFT OUTER JOIN bcfishpass.barriers_subsurfaceflow s
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode,
    a.localcode,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    False
)
WHERE a.species_code in ('CH','CM','CO','PK','SK')
GROUP BY
  a.observation_key,
  a.species_code,
  a.observation_date,
  a.activity_code,
  a.activity,
  a.life_stage_code,
  a.life_stage,
  a.acat_report_url,
  a.agency_name,
  a.source,
  a.source_ref,
  a.watershed_group_code,
  a.geom
) as f
WHERE 
  gradient_20_dnstr_count >= 1 or
  gradient_25_dnstr_count >= 1 or
  gradient_30_dnstr_count >= 1 or
  falls_dnstr_count >= 1 or
  subsurfaceflow_dnstr_count >= 1
ORDER BY observation_key;


-- count observations upstream of natural barriers (salmon/steelhead)
-- natural barriers to steelhead (having <5 salmon or steelhead observations upstream since 1990)
truncate bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk;

insert into bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk (
  barrier_id,
  barrier_type,
  watershed_group_code,
  observations_upstr,
  n_observations_upstr
)
SELECT
  b.barriers_falls_id as barrier_id,
  b.barrier_type,
  b.watershed_group_code,
  array_to_string(array_agg(DISTINCT o.observation_key), ';') as observations_upstr,
  count(DISTINCT o.observation_key) as n_observations_upstr
from bcfishpass.barriers_falls b
inner join bcfishobs.observations o on
 fwa_upstream(
   b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode, o.localcode,
   False,
   20)  -- same tolerance as in the model, don't count observations < 20m upstream from the barrier
where o.species_code in ('CH','CM','CO','PK','SK')
group by
  b.barriers_falls_id,
  b.barrier_type,
  b.watershed_group_code
order by barrier_id;


insert into bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk (
  barrier_id,
  barrier_type,
  watershed_group_code,
  observations_upstr,
  n_observations_upstr
)
SELECT
  b.gradient_barrier_id as barrier_id,
  'GRADIENT_15' as barrier_type,
  b.watershed_group_code,
  array_to_string(array_agg(DISTINCT o.observation_key), ';') as observations_upstr,
  count(DISTINCT o.observation_key) as n_observations_upstr
from bcfishpass.gradient_barriers b
inner join bcfishobs.observations o on
 fwa_upstream(
   b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode, o.localcode,
   False,
   20)  -- same tolerance as in the model, don't count observations < 20m upstream from the barrier
where o.species_code in ('CH','CM','CO','PK','SK')
and b.gradient_class = 15
group by
  b.gradient_barrier_id,
  barrier_type,
  b.watershed_group_code
order by barrier_id;


insert into bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk (
  barrier_id,
  barrier_type,
  watershed_group_code,
  observations_upstr,
  n_observations_upstr
)
SELECT
  b.gradient_barrier_id as barrier_id,
  'GRADIENT_20' as barrier_type,
  b.watershed_group_code,
  array_to_string(array_agg(DISTINCT o.observation_key), ';') as observations_upstr,
  count(DISTINCT o.observation_key) as n_observations_upstr
from bcfishpass.gradient_barriers b
inner join bcfishobs.observations o on
 fwa_upstream(
   b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode, o.localcode,
   False,
   20)  -- same tolerance as in the model, don't count observations < 20m upstream from the barrier
where o.species_code in ('CH','CM','CO','PK','SK')
and b.gradient_class = 20
group by
  b.gradient_barrier_id,
  barrier_type,
  b.watershed_group_code
order by barrier_id;


insert into bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk (
  barrier_id,
  barrier_type,
  watershed_group_code,
  observations_upstr,
  n_observations_upstr
)
SELECT
  b.gradient_barrier_id as barrier_id,
  'GRADIENT_25' as barrier_type,
  b.watershed_group_code,
  array_to_string(array_agg(DISTINCT o.observation_key), ';') as observations_upstr,
  count(DISTINCT o.observation_key) as n_observations_upstr
from bcfishpass.gradient_barriers b
inner join bcfishobs.observations o on
 fwa_upstream(
   b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode, o.localcode,
   False,
   20)  -- same tolerance as in the model, don't count observations < 20m upstream from the barrier
where o.species_code in ('CH','CM','CO','PK','SK')
and b.gradient_class = 25
group by
  b.gradient_barrier_id,
  barrier_type,
  b.watershed_group_code
order by barrier_id;


insert into bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk (
  barrier_id,
  barrier_type,
  watershed_group_code,
  observations_upstr,
  n_observations_upstr
)
SELECT
  b.gradient_barrier_id as barrier_id,
  'GRADIENT_30' as barrier_type,
  b.watershed_group_code,
  array_to_string(array_agg(DISTINCT o.observation_key), ';') as observations_upstr,
  count(DISTINCT o.observation_key) as n_observations_upstr
from bcfishpass.gradient_barriers b
inner join bcfishobs.observations o on
 fwa_upstream(
   b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode, o.localcode,
   False,
   20)  -- same tolerance as in the model, don't count observations < 20m upstream from the barrier
where o.species_code in ('CH','CM','CO','PK','SK')
and b.gradient_class = 30
group by
  b.gradient_barrier_id,
  barrier_type,
  b.watershed_group_code
order by barrier_id;


insert into bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk (
  barrier_id,
  barrier_type,
  watershed_group_code,
  observations_upstr,
  n_observations_upstr
)
SELECT
  b.barriers_subsurfaceflow_id as barrier_id,
  b.barrier_type,
  b.watershed_group_code,
  array_to_string(array_agg(DISTINCT o.observation_key), ';') as observations_upstr,
  count(DISTINCT o.observation_key) as n_observations_upstr
from bcfishpass.barriers_subsurfaceflow b
inner join bcfishobs.observations o on
 fwa_upstream(
   b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode, o.localcode,
   False,
   20)  -- same tolerance as in the model, don't count observations < 20m upstream from the barrier
where o.species_code in ('CH','CM','CO','PK','SK')
group by
  barrier_id,
  barrier_type,
  b.watershed_group_code
order by barrier_id
ON CONFLICT DO NOTHING; -- subsurface flow can be located at the same spot / have the same id as a gradient barrier