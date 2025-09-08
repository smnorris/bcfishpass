INSERT INTO bcfishpass.barriers_dams
(
    barriers_dams_id,
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
    c.aggregated_crossings_id,
    c.crossing_feature_type,
    c.dam_name as barrier_name,
    c.linear_feature_id,
    c.blue_line_key,
    c.watershed_key,
    c.downstream_route_measure,
    c.wscode_ltree,
    c.localcode_ltree,
    c.watershed_group_code,
    st_force2d(c.geom) as geom
FROM bcfishpass.crossings c
WHERE
  dam_id IS NOT NULL AND
  barrier_status IN ('BARRIER', 'POTENTIAL') AND
  blue_line_key = watershed_key AND -- do not include side channel features as barriers
  watershed_group_code = :'wsg'
ORDER BY watershed_group_code, blue_line_key, downstream_route_measure;