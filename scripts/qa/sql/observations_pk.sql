select * from
(SELECT
  a.species_code,
  a.fish_observation_point_id,
  a.observation_date,
  a.agency_name,
  a.source,
  a.source_ref,
  --array_agg(DISTINCT b.barriers_gradient_07_id) as barriers_gradient_07_dnstr,
  count(DISTINCT b.barriers_gradient_07_id) as n_barriers_gradient_07_dnstr,
  --array_agg(DISTINCT c.barriers_gradient_10_id) as barriers_gradient_10_dnstr,
  count(DISTINCT c.barriers_gradient_10_id) as n_barriers_gradient_10_dnstr,
  --array_agg(DISTINCT d.barriers_gradient_15_id) as barriers_gradient_15_dnstr,
  count(DISTINCT d.barriers_gradient_15_id) as n_barriers_gradient_15_dnstr,
  --array_agg(DISTINCT e.barriers_gradient_20_id) as barriers_gradient_20_dnstr,
  count(DISTINCT e.barriers_gradient_20_id) as n_barriers_gradient_20_dnstr,
  --array_agg(DISTINCT f.barriers_gradient_25_id) as barriers_gradient_25_dnstr,
  count(DISTINCT f.barriers_gradient_25_id) as n_barriers_gradient_25_dnstr,
  --array_agg(DISTINCT g.barriers_gradient_30_id) as barriers_gradient_30_dnstr,
  count(DISTINCT g.barriers_gradient_30_id) as n_barriers_gradient_30_dnstr,
  --array_agg(DISTINCT h.barriers_falls_id) as barriers_falls_dnstr,
  count(DISTINCT h.barriers_falls_id) as n_barriers_falls_dnstr
FROM bcfishobs.fiss_fish_obsrvtn_events_sp a
LEFT OUTER JOIN bcfishpass.barriers_gradient_07 b
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    True,
    1
)
LEFT OUTER JOIN bcfishpass.barriers_gradient_10 c
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    c.blue_line_key,
    c.downstream_route_measure,
    c.wscode_ltree,
    c.localcode_ltree,
    True,
    1
)
LEFT OUTER JOIN bcfishpass.barriers_gradient_15 d
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    d.blue_line_key,
    d.downstream_route_measure,
    d.wscode_ltree,
    d.localcode_ltree,
    True,
    1
)
LEFT OUTER JOIN bcfishpass.barriers_gradient_20 e
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    e.blue_line_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    True,
    1
)
LEFT OUTER JOIN bcfishpass.barriers_gradient_25 f
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
    1
)
LEFT OUTER JOIN bcfishpass.barriers_gradient_30 g
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    g.blue_line_key,
    g.downstream_route_measure,
    g.wscode_ltree,
    g.localcode_ltree,
    True,
    1
)
LEFT OUTER JOIN bcfishpass.barriers_falls h
ON FWA_Downstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    h.blue_line_key,
    h.downstream_route_measure,
    h.wscode_ltree,
    h.localcode_ltree,
    True,
    1
)
WHERE a.species_code = 'PK'
GROUP BY a.species_code,
  a.fish_observation_point_id,
  a.observation_date,
  a.agency_name,
  a.source,
  a.source_ref
) as f
WHERE 
  n_barriers_gradient_07_dnstr >= 1 or
  n_barriers_gradient_10_dnstr >= 1 or
  n_barriers_gradient_15_dnstr >= 1 or
  n_barriers_gradient_20_dnstr >= 1 or
  n_barriers_gradient_25_dnstr >= 1 or
  n_barriers_gradient_30_dnstr >= 1 or
  n_barriers_falls_dnstr >= 1
ORDER BY fish_observation_point_id;