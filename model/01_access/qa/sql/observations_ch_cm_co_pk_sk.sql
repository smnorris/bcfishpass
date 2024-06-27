select * from
(SELECT
  a.species_code,
  a.fish_observation_point_id,
  a.observation_date,
  a.activity_code,
  a.activity,
  a.life_stage_code,
  a.life_stage,
  a.acat_report_url,
  o.agency_name,
  o.source,
  o.source_ref,
  count(DISTINCT g05.barriers_gradient_id) as n_barriers_gradient_05_dnstr,
  count(DISTINCT g10.barriers_gradient_id) as n_barriers_gradient_10_dnstr,
  --array_agg(DISTINCT d.barriers_gradient_id) as barriers_gradient_15_dnstr,
  count(DISTINCT g15.barriers_gradient_id) as n_barriers_gradient_15_dnstr,
  --array_agg(DISTINCT e.barriers_gradient_id) as barriers_gradient_20_dnstr,
  count(DISTINCT g20.barriers_gradient_id) as n_barriers_gradient_20_dnstr,
  --array_agg(DISTINCT f.barriers_gradient_id) as barriers_gradient_25_dnstr,
  count(DISTINCT g25.barriers_gradient_id) as n_barriers_gradient_25_dnstr,
  --array_agg(DISTINCT g.barriers_gradient_id) as barriers_gradient_30_dnstr,
  count(DISTINCT g30.barriers_gradient_id) as n_barriers_gradient_30_dnstr,
  --array_agg(DISTINCT h.barriers_falls_id) as barriers_falls_dnstr,
  count(DISTINCT f.barriers_falls_id) as n_barriers_falls_dnstr,
  count(DISTINCT s.barriers_subsurfaceflow_id) as n_barriers_subsurfaceflow_dnstr
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
WHERE a.species_code in ('CH','CM','CO','PK','SK')
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
  n_barriers_gradient_15_dnstr >= 1 or
  n_barriers_gradient_20_dnstr >= 1 or
  n_barriers_gradient_25_dnstr >= 1 or
  n_barriers_gradient_30_dnstr >= 1 or
  n_barriers_falls_dnstr >= 1 or
  n_barriers_subsurfaceflow_dnstr >= 1
ORDER BY fish_observation_point_id;