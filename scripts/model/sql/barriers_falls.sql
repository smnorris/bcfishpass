INSERT INTO bcfishpass.barrier_load
(
    barrier_load_id,
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
    falls_id as barriers_load_id,
    'FALLS' as barrier_type,
    falls_name as barrier_name,
    f.linear_feature_id,
    f.blue_line_key,
    s.watershed_key,
    f.downstream_route_measure,
    f.wscode_ltree,
    f.localcode_ltree,
    f.watershed_group_code,
    f.geom
FROM bcfishpass.falls f
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON f.linear_feature_id = s.linear_feature_id
WHERE
  f.watershed_group_code = :'wsg' AND
  f.barrier_ind IS TRUE

ON CONFLICT DO NOTHING;