select * from 
(
SELECT
  barriers_majordams_id as barrier_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code,
  count(o.fish_observation_point_id) as n_observations,
  array_agg(o.fish_observation_point_id) as observations
FROM bcfishpass.barriers_majordams b
INNER JOIN bcfishobs.fiss_fish_obsrvtn_events_sp o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE o.species_code = 'ST'
GROUP BY 
  barriers_majordams_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code

UNION ALL

SELECT
  barriers_gradient_20_id as barrier_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code,
  count(o.fish_observation_point_id) as n_observations,
  array_agg(o.fish_observation_point_id) as observations
FROM bcfishpass.barriers_gradient_20 b
INNER JOIN bcfishobs.fiss_fish_obsrvtn_events_sp o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE o.species_code = 'ST'
GROUP BY 
  barriers_gradient_20_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code

UNION ALL

SELECT
  barriers_gradient_25_id as barrier_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code,
  count(o.fish_observation_point_id) as n_observations,
  array_agg(o.fish_observation_point_id) as observations
FROM bcfishpass.barriers_gradient_25 b
INNER JOIN bcfishobs.fiss_fish_obsrvtn_events_sp o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE o.species_code = 'ST'
GROUP BY 
  barriers_gradient_25_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code

UNION ALL

SELECT
  barriers_gradient_30_id as barrier_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code,
  count(o.fish_observation_point_id) as n_observations,
  array_agg(o.fish_observation_point_id) as observations
FROM bcfishpass.barriers_gradient_30 b
INNER JOIN bcfishobs.fiss_fish_obsrvtn_events_sp o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE o.species_code = 'ST'
GROUP BY 
  barriers_gradient_30_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code

UNION ALL

SELECT
  barriers_falls_id as barrier_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code,
  count(o.fish_observation_point_id) as n_observations,
  array_agg(o.fish_observation_point_id) as observations
FROM bcfishpass.barriers_falls b
INNER JOIN bcfishobs.fiss_fish_obsrvtn_events_sp o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE o.species_code = 'ST'
GROUP BY barriers_falls_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code

UNION ALL

SELECT
  barriers_subsurfaceflow_id as barrier_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code,
  count(o.fish_observation_point_id) as n_observations,
  array_agg(o.fish_observation_point_id) as observations
FROM bcfishpass.barriers_subsurfaceflow b
INNER JOIN bcfishobs.fiss_fish_obsrvtn_events_sp o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE o.species_code = 'ST'
GROUP BY 
  barriers_subsurfaceflow_id,
  barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code
) 
as f
ORDER BY barrier_type asc, n_observations desc