-- subsurface flow
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
    (((s.blue_line_key::bigint + 1) - 354087611) * 10000000) + round(s.downstream_route_measure::bigint) as barrier_load_id,
    'SUBSURFACEFLOW' as barrier_type,
    NULL as barrier_name,
    s.linear_feature_id,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_LineInterpolatePoint(
        ST_Force2D(
            (ST_Dump(s.geom)).geom
        ),
        0
    ) as geom
FROM whse_basemapping.fwa_stream_networks_sp s
LEFT OUTER JOIN bcfishpass.user_barriers_definite_control c
ON s.blue_line_key = c.blue_line_key and abs(s.downstream_route_measure - c.downstream_route_measure) < 1
WHERE
  s.watershed_group_code = :'wsg' AND
  s.edge_type IN (1410, 1425) AND
  s.local_watershed_code IS NOT NULL AND
  s.blue_line_key = s.watershed_key AND
  s.fwa_watershed_code NOT LIKE '999%%' AND
  c.barrier_ind is not false
ON CONFLICT DO NOTHING;