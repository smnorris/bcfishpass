-- insert all barriers from aggregated crossings table
-- (pscis, dams, modelled xings)
-- no additonal logic required, simply records from crossings table that are barriers and potential barriers

INSERT INTO bcfishpass.barriers_anthropogenic
(
    barriers_anthropogenic_id,
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
    crossing_feature_type as barrier_type,
    NULL as barrier_name,
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
  barrier_status IN ('BARRIER', 'POTENTIAL') AND
  blue_line_key = watershed_key AND  -- do not include side channel features as barriers
  watershed_group_code = :'wsg';
