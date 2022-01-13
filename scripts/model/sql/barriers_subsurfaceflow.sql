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
    s.linear_feature_id as barriers_load_id,
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
WHERE
  s.watershed_group_code = :'wsg' AND
  s.edge_type IN (1410, 1425) AND
  s.local_watershed_code IS NOT NULL AND
  s.blue_line_key = s.watershed_key AND
  s.fwa_watershed_code NOT LIKE '999%%'
-- Do not include subsurface flows on the Chilcotin at the Clusco.
-- The subsurface flow is a side channel, the Chilcotin merges
-- with the Clusco farther upstream
-- TODO - add a user table for corrections like this
  AND NOT
  (s.blue_line_key = 356363411 AND s.downstream_route_measure < 213010)
ON CONFLICT DO NOTHING;