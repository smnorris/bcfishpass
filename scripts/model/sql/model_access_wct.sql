delete from bcfishpass.barriers_wct
where watershed_group_code = :'wsg';


WITH barriers AS
(
    SELECT
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
FROM bcfishpass.barriers_majordams b
LEFT OUTER JOIN bcfishpass.observations o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
-- do not include any features downstream of WCT observations
WHERE b.watershed_group_code = :'wsg' AND
    (
      o.species_codes && ARRAY['WCT'] IS FALSE
      OR o.species_codes IS NULL
    )
UNION ALL

SELECT
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
FROM bcfishpass.barriers_gradient_20 b
LEFT OUTER JOIN bcfishpass.observations o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
-- do not include any features downstream of WCT observations
WHERE b.watershed_group_code = :'wsg' AND
    (
      o.species_codes && ARRAY['WCT'] IS FALSE
      OR o.species_codes IS NULL
    )
UNION ALL

SELECT
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
FROM bcfishpass.barriers_gradient_25 b
LEFT OUTER JOIN bcfishpass.observations o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
-- do not include any features downstream of WCT observations
WHERE b.watershed_group_code = :'wsg' AND
    (
      o.species_codes && ARRAY['WCT'] IS FALSE
      OR o.species_codes IS NULL
    )
UNION ALL

SELECT
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
FROM bcfishpass.barriers_gradient_30 b
LEFT OUTER JOIN bcfishpass.observations o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
-- do not include any features downstream of WCT observations
WHERE b.watershed_group_code = :'wsg' AND
    (
      o.species_codes && ARRAY['WCT'] IS FALSE
      OR o.species_codes IS NULL
    )
UNION ALL
SELECT
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
FROM bcfishpass.barriers_falls b
LEFT OUTER JOIN bcfishpass.observations o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
-- do not include any features downstream of WCT observations
WHERE b.watershed_group_code = :'wsg' AND
    (
      o.species_codes && ARRAY['WCT'] IS FALSE
      OR o.species_codes IS NULL
    )
UNION ALL
SELECT
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
FROM bcfishpass.barriers_subsurfaceflow b
LEFT OUTER JOIN bcfishpass.observations o
ON FWA_Upstream(
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree,
      False,
      1
    )
  AND b.watershed_group_code = o.watershed_group_code
-- do not include any features downstream of WCT observations
WHERE b.watershed_group_code = :'wsg' AND
    (
      o.species_codes && ARRAY['WCT'] IS FALSE
      OR o.species_codes IS NULL
    )
UNION ALL
SELECT
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
FROM bcfishpass.barriers_user_definite b
-- DO include these user added features that may be below WCT observations
)

INSERT INTO bcfishpass.barriers_wct
(
    barriers_wct_id,
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
              WHERE wct IS TRUE
            )
          )
ON CONFLICT DO NOTHING;
