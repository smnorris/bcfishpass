DELETE FROM bcfishpass.barriers_falls;

INSERT INTO bcfishpass.barriers_falls
(
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
   'FALLS' as barrier_type,
    NULL as barrier_name,
    a.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    a.watershed_group_code,
    a.geom
FROM bcfishpass.falls a
INNER JOIN bcfishpass.param_watersheds g
ON a.watershed_group_code = g.watershed_group_code
WHERE a.barrier_ind IS TRUE
ON CONFLICT DO NOTHING;
