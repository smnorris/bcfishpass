INSERT INTO bcfishpass.barrier_load
(
    barrier_load_id,
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    (watershed_group_id * 100000) + row_number() over() as barrier_load_id,
    'GRADIENT_20' as barrier_type,
    NULL as barrier_name,
    s.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_Force2D((ST_Dump(ST_Locatealong(s.geom, b.downstream_route_measure))).geom)::geometry(Point,3005) as geom
FROM bcfishpass.gradient_barriers b
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON b.blue_line_key = s.blue_line_key
  AND s.downstream_route_measure <= b.downstream_route_measure
  AND s.upstream_route_measure + .01 > b.downstream_route_measure
LEFT OUTER JOIN bcfishpass.gradient_barriers_passable p
ON b.blue_line_key = p.blue_line_key
  AND b.downstream_route_measure = p.downstream_route_measure
LEFT OUTER JOIN bcfishpass.observations o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      s.wscode_ltree,
      s.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND s.watershed_group_code = o.watershed_group_code
WHERE
  b.gradient_class = 20
  -- do not include any records matched to passable table
  AND p.blue_line_key IS NULL
  AND s.watershed_group_code = :'wsg'
ORDER BY b.blue_line_key, b.downstream_route_measure
ON CONFLICT DO NOTHING;