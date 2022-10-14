INSERT INTO bcfishpass.barriers_gradient_30
(
    barriers_gradient_30_id,
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    watershed_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    ((((b.blue_line_key::bigint + 1) - 354087611) * 10000000) + round(b.downstream_route_measure::bigint))::text as barrier_load_id,
    'GRADIENT_30' as barrier_type,
    NULL as barrier_name,
    s.linear_feature_id,
    b.blue_line_key,
    s.watershed_key,
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
LEFT OUTER JOIN bcfishpass.user_barriers_definite_control p
  ON b.blue_line_key = p.blue_line_key
  AND abs(b.downstream_route_measure - p.downstream_route_measure) < 1
WHERE
  b.gradient_class = 30 AND
  -- do not include any records matched to passable table
  p.blue_line_key IS NULL
  AND s.watershed_group_code = :'wsg'
ORDER BY b.blue_line_key, b.downstream_route_measure
ON CONFLICT DO NOTHING;