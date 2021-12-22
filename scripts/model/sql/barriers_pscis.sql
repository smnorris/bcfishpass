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
    aggregated_crossings_id,
    wcrp_barrier_type,
    crossing_source as barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code as watershed_group_code,
    geom as geom
FROM bcfishpass.crossings
WHERE
  stream_crossing_id IS NOT NULL AND
  barrier_status IN ('BARRIER', 'POTENTIAL') AND
  blue_line_key = watershed_key AND -- do not include side channel features as barriers
  watershed_group_code = :'wsg'
ORDER BY watershed_group_code, blue_line_key, downstream_route_measure;
