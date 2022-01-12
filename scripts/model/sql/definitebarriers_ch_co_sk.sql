WITH barriers AS
(
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_majordams
WHERE watershed_group_code = :'wsg'
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_15
WHERE watershed_group_code = :'wsg'
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_20
WHERE watershed_group_code = :'wsg'
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_25
WHERE watershed_group_code = :'wsg'
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_30
WHERE watershed_group_code = :'wsg'
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_falls
WHERE watershed_group_code = :'wsg'
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_subsurfaceflow
WHERE watershed_group_code = :'wsg'
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_other_definite
WHERE watershed_group_code = :'wsg'
)

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
-- add a primary key guaranteed to be unique provincially (presuming unique blkey/measure values within 1m)
SELECT
  (((blue_line_key::bigint + 1) - 354087611) * 10000000) + round(downstream_route_measure::bigint) as barrier_load_id,
  barrier_type,
  barrier_name,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
FROM barriers b
WHERE watershed_group_code = ANY(
    ARRAY(
      SELECT watershed_group_code
      FROM bcfishpass.wsg_species_presence
      WHERE ch IS TRUE OR co IS TRUE OR sk IS TRUE
    )
)
ON CONFLICT DO NOTHING;