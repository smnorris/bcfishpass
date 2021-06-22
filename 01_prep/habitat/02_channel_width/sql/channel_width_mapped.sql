-- Calculate the average channel width of stream segments for main flow of double line rivers.
-- (where stream segment = distinct linear_feature_id)
-- To calculate average, this measures distance at 100m intervals along individual geoms.

WITH measures AS
(
  SELECT
    linear_feature_id,
    waterbody_key,
    generate_series(ceil(downstream_route_measure)::integer,
                    floor(upstream_route_measure)::integer, 100) as route_measure,
    geom
  FROM whse_basemapping.fwa_stream_networks_sp
  WHERE edge_type = 1250                      -- main flow only, do not consider side channels
  AND watershed_group_code = :'wsg'
  ORDER BY downstream_route_measure
),

channel_points AS
(
SELECT
  s.linear_feature_id,
  s.waterbody_key,
  s.route_measure,
  (ST_Dump(ST_LocateAlong(geom, route_measure))).geom::geometry(pointzm,3005) as geom
FROM measures s
),

-- find closest right bank (or right bank of closest island)
right_bank AS
 ( SELECT
    pt.linear_feature_id,
    pt.route_measure,
    nn.distance_to_pt,
    nn.geom
  FROM channel_points pt
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
    pt.linear_feature_id,
    nn.distance_to_pt,
    nn.geom
  FROM channel_points pt
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
  downstream_route_measure,
  watershed_group_code,
  channel_width_mapped
)

-- calculate avg dist to each bank and add the averages together
SELECT
  r.linear_feature_id,
  r.route_measure AS downstream_route_measure,
  s.watershed_group_code,
  ROUND((r.distance_to_pt + l.distance_to_pt)::numeric, 2) as channel_width_mapped
FROM right_bank r
INNER JOIN left_bank l ON r.linear_feature_id = l.linear_feature_id
INNER JOIN whse_basemapping.fwa_stream_networks_sp s ON r.linear_feature_id = s.linear_feature_id
ON CONFLICT DO NOTHING;
