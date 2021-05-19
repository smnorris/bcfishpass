-- Calculate the average channel width of stream segments for main flow of double line rivers.
-- (where stream segment = distinct linear_feature_id)
-- To calculate average, this measures distance at 10% intervals along individual geoms.
-- There will only be multiple geoms where a stream is broken by a fish passage feature
-- (ie, bridge, dam, observation, etc))

DROP TABLE IF EXISTS bcfishpass.channel_width_mapped;

CREATE TABLE bcfishpass.channel_width_mapped
(
  linear_feature_id bigint primary key,
  watershed_group_code text,
  channel_width_mapped double precision
);


-- get points at .1, .2. .3 etc pct along the line
WITH midpoint AS
(
SELECT
  --s.segmented_stream_id,
  s.linear_feature_id,
  s.waterbody_key,
  (ST_Dump(ST_LineInterpolatePoints(geom, .1))).geom as geom
FROM whse_basemapping.fwa_stream_networks_sp s
WHERE s.edge_type = 1250
),

-- find closest right bank (or right bank of closest island)
right_bank AS
 ( SELECT
    --pt.segmented_stream_id,
    pt.linear_feature_id,
    nn.distance_to_pt,
    nn.geom
  FROM midpoint pt
  CROSS JOIN LATERAL
  (SELECT
     lb.linear_feature_id,
     lb.geom,
     ST_Distance(lb.geom, pt.geom) as distance_to_pt
    FROM whse_basemapping.fwa_linear_boundaries_sp AS lb
    WHERE lb.waterbody_key = pt.waterbody_key
    AND lb.edge_type IN (1800, 1825, 1900)
    ORDER BY lb.geom <-> pt.geom
    LIMIT 1) as nn
  WHERE nn.distance_to_pt < 4000
),

-- find left bank (or left bank of closest island)
left_bank AS
 ( SELECT
    --pt.segmented_stream_id,
    pt.linear_feature_id,
    nn.distance_to_pt,
    nn.geom
  FROM midpoint pt
  CROSS JOIN LATERAL
  (SELECT
     lb.linear_feature_id,
     lb.geom,
     ST_Distance(lb.geom, pt.geom) as distance_to_pt
    FROM whse_basemapping.fwa_linear_boundaries_sp AS lb
    WHERE lb.waterbody_key = pt.waterbody_key
    AND lb.edge_type IN (1850, 1875, 1950)
    ORDER BY lb.geom <-> pt.geom
    LIMIT 1) as nn
  WHERE nn.distance_to_pt < 4000
)

INSERT INTO bcfishpass.channel_width_mapped
(
  linear_feature_id,
  watershed_group_code,
  channel_width_mapped
)

-- calculate avg dist to each bank and add the averages together
SELECT
  r.linear_feature_id,
  s.watershed_group_code,
  ROUND((avg(r.distance_to_pt) + avg(l.distance_to_pt))::numeric, 2) as channel_width_mapped
FROM right_bank r
INNER JOIN left_bank l ON r.linear_feature_id = l.linear_feature_id
INNER JOIN whse_basemapping.fwa_stream_networks_sp s ON r.linear_feature_id = s.linear_feature_id
GROUP BY r.linear_feature_id, s.watershed_group_code;
