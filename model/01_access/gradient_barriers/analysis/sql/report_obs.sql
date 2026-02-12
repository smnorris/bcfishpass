SELECT
  t1.observation_key,
  t1.species_code,
  o.life_stage,
  CASE
    WHEN o.life_stage ilike '%ADULT%' then 'true'
    WHEN o.life_stage ilike '%ADULT%' is false then 'false'
    WHEN o.life_stage is null then 'NULL'
  END AS adult,
  t1.watershed_group_code,
  t1.stream_order,
  t1.elevation,
  round((t4.obs_dist_to_ocean / 1000)::numeric, 2) as obs_dist_to_ocean,
  round((t2.max_upstr_gradient_100m * 100)::numeric, 2)  as upstr100m_grade,
  t1.max_gradient as dnstr_max_grade,
  round((t3.max_grade_dnstr_dist_to_ocean / 1000)::numeric, 2) as dnstr_max_grade_dist_to_ocean_km
FROM obs_max_grade_dnstr t1
INNER JOIN bcfishobs.observations o ON t1.observation_key = o.observation_key
LEFT OUTER JOIN obs_max_grade_dnstr_dist_to_ocean t3 ON t1.max_gradient_id = t3.max_gradient_id
LEFT OUTER JOIN obs_grade_upstr t2 ON o.blue_line_key = t2.blue_line_key and abs(o.downstream_route_measure - t2.downstream_route_measure) < .0001
LEFT OUTER JOIN obs_dist_to_ocean t4 ON o.blue_line_key = t4.blue_line_key and abs(o.downstream_route_measure - t4.downstream_route_measure) < .0001
WHERE t1.species_code IN ('CH','CM','CO','PK','SK','ST')
ORDER BY t1.observation_key;