-- extract all ch/co/sk observations to cancel barriers downstream
with obs as
(
    select *
    from bcfishpass.observations
    where species_codes && ARRAY['CH','CO','SK']
),

barriers AS
(

-- major dams do not get removed by observations
-- (they are confirmed barriers to anadramous passage and out of scope for removal)
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
WHERE b.watershed_group_code = :'wsg'

UNION ALL

SELECT DISTINCT
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
FROM bcfishpass.barriers_gradient_15 b
LEFT OUTER JOIN obs o
-- note that observations only 0-50m upstream of the barrier do not cancel a given barrier,
-- precision of input feature locations is not nearly good enough
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
      50
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE
  b.watershed_group_code = :'wsg' AND
  o.fish_obsrvtn_pnt_distinct_id IS NULL

UNION ALL

SELECT DISTINCT
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
LEFT OUTER JOIN obs o
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
      50
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE
  b.watershed_group_code = :'wsg' AND
  o.fish_obsrvtn_pnt_distinct_id IS NULL

UNION ALL

SELECT DISTINCT
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
LEFT OUTER JOIN obs o
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
      50
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE
  b.watershed_group_code = :'wsg' AND
  o.fish_obsrvtn_pnt_distinct_id IS NULL

UNION ALL

SELECT DISTINCT
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
LEFT OUTER JOIN obs o
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
      50
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE
  b.watershed_group_code = :'wsg' AND
  o.fish_obsrvtn_pnt_distinct_id IS NULL

UNION ALL

SELECT DISTINCT
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
LEFT OUTER JOIN obs o
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
      50
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE
  b.watershed_group_code = :'wsg' AND
  o.fish_obsrvtn_pnt_distinct_id IS NULL

UNION ALL

SELECT DISTINCT
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
LEFT OUTER JOIN obs o
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
      50
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE
  b.watershed_group_code = :'wsg' AND
  o.fish_obsrvtn_pnt_distinct_id IS NULL

UNION ALL

SELECT DISTINCT
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
FROM bcfishpass.barriers_other_definite b
LEFT OUTER JOIN obs o
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
      50
    )
  AND b.watershed_group_code = o.watershed_group_code
WHERE
  b.watershed_group_code = :'wsg' AND
  o.fish_obsrvtn_pnt_distinct_id IS NULL
)

INSERT INTO bcfishpass.barriers_ch_co_sk_b
(
    barriers_barrier_ch_co_sk_b_id,
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