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
    falls_id as barriers_load_id,
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
WHERE
  a.barrier_ind IS TRUE AND
  a.watershed_group_code = :'wsg';
