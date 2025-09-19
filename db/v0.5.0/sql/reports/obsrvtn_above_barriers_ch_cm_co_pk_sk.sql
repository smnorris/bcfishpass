-- ============
-- deprecated - we cannot effectivley create materialized views that use fwapg functions for postgres >= 17
-- (unless fwapg functions are moved into an extension, which is not a priority)
-- Instead, see db/v0.7.0/sql/qa_observations_naturalbarriers_dnst.sql
-- ============

-- report on all potential barriers below salmon/steelhead observations

-- NOTE - all potential gradient barriers are reported, but only falls tagged as a barrier are included

drop materialized view if exists bcfishpass.obsrvtn_above_barriers_ch_cm_co_pk_sk_st;

create materialized view bcfishpass.obsrvtn_above_barriers_ch_cm_co_pk_sk_st as
select * from
(SELECT
  a.fish_observation_point_id,
  a.species_code,
  a.observation_date,
  a.activity_code,
  a.activity,
  a.life_stage_code,
  a.life_stage,
  a.acat_report_url,
  o.agency_name,
  o.source,
  o.source_ref,
  array_to_string(array_agg(DISTINCT g05.barriers_gradient_id), ';') as gradient_05_dnstr,
  array_to_string(array_agg(DISTINCT g10.barriers_gradient_id), ';') as gradient_10_dnstr,
  array_to_string(array_agg(DISTINCT g15.barriers_gradient_id), ';') as gradient_15_dnstr,
  array_to_string(array_agg(DISTINCT g20.barriers_gradient_id), ';') as gradient_20_dnstr,
  array_to_string(array_agg(DISTINCT g25.barriers_gradient_id), ';') as gradient_25_dnstr,
  array_to_string(array_agg(DISTINCT g30.barriers_gradient_id), ';') as gradient_30_dnstr,
  array_to_string(array_agg(DISTINCT f.barriers_falls_id), ';') as falls_dnstr,
  array_to_string(array_agg(DISTINCT s.barriers_subsurfaceflow_id), ';') as subsurfaceflow_dnstr,
  count(DISTINCT g05.barriers_gradient_id) as gradient_05_dnstr_count,
  count(DISTINCT g10.barriers_gradient_id) as gradient_10_dnstr_count,
  count(DISTINCT g15.barriers_gradient_id) as gradient_15_dnstr_count,
  count(DISTINCT g20.barriers_gradient_id) as gradient_20_dnstr_count,
  count(DISTINCT g25.barriers_gradient_id) as gradient_25_dnstr_count,
  count(DISTINCT g30.barriers_gradient_id) as gradient_30_dnstr_count,
  count(DISTINCT f.barriers_falls_id) as falls_dnstr_count,
  count(DISTINCT s.barriers_subsurfaceflow_id) as subsurfaceflow_dnstr_count
FROM bcfishpass.observations_vw a
LEFT OUTER JOIN bcfishpass.barriers_gradient g05
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    g05.blue_line_key,
    g05.downstream_route_measure,
    g05.wscode_ltree,
    g05.localcode_ltree,
    True,
    20
)
LEFT OUTER JOIN bcfishpass.barriers_gradient g10
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    g10.blue_line_key,
    g10.downstream_route_measure,
    g10.wscode_ltree,
    g10.localcode_ltree,
    True,
    20
)
LEFT OUTER JOIN bcfishpass.barriers_gradient g15
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    g15.blue_line_key,
    g15.downstream_route_measure,
    g15.wscode_ltree,
    g15.localcode_ltree,
    True,
    20
)
LEFT OUTER JOIN bcfishpass.barriers_gradient g20
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    g20.blue_line_key,
    g20.downstream_route_measure,
    g20.wscode_ltree,
    g20.localcode_ltree,
    True,
    20
)
LEFT OUTER JOIN bcfishpass.barriers_gradient g25
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    g25.blue_line_key,
    g25.downstream_route_measure,
    g25.wscode_ltree,
    g25.localcode_ltree,
    True,
    20
)
LEFT OUTER JOIN bcfishpass.barriers_gradient g30
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    g30.blue_line_key,
    g30.downstream_route_measure,
    g30.wscode_ltree,
    g30.localcode_ltree,
    True,
    20
)
LEFT OUTER JOIN bcfishpass.barriers_falls f
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    f.blue_line_key,
    f.downstream_route_measure,
    f.wscode_ltree,
    f.localcode_ltree,
    True,
    20
)
LEFT OUTER JOIN bcfishpass.barriers_subsurfaceflow s
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    True,
    20
)
inner join whse_fish.fiss_fish_obsrvtn_pnt_sp o
on a.fish_observation_point_id = o.fish_observation_point_id
WHERE a.species_code in ('CH','CM','CO','PK','SK','ST')
AND g05.barrier_type = 'GRADIENT_05'
AND g10.barrier_type = 'GRADIENT_10'
AND g15.barrier_type = 'GRADIENT_15'
AND g20.barrier_type = 'GRADIENT_20'
AND g25.barrier_type = 'GRADIENT_25'
AND g30.barrier_type = 'GRADIENT_30'
GROUP BY a.species_code,
  a.fish_observation_point_id,
  a.observation_date,
  a.activity_code,
  a.activity,
  a.life_stage_code,
  a.life_stage,
  a.acat_report_url,
  o.agency_name,
  o.source,
  o.source_ref
) as f
WHERE 
  gradient_05_dnstr_count >= 1 or
  gradient_10_dnstr_count >= 1 or
  gradient_15_dnstr_count >= 1 or
  gradient_20_dnstr_count >= 1 or
  gradient_25_dnstr_count >= 1 or
  gradient_30_dnstr_count >= 1 or
  falls_dnstr_count >= 1 or
  subsurfaceflow_dnstr_count >= 1
ORDER BY fish_observation_point_id;