-- For main flow of double line rivers,
-- measure mapped channel width at midpoint of stream segment


DROP TABLE IF EXISTS bcfishpass.channel_width_mapped;

CREATE TABLE bcfishpass.channel_width_mapped
(
  channel_width_mapped_id serial primary key,
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code text,
  channel_width_mapped double precision,
  UNIQUE (wscode_ltree, localcode_ltree)
);


-- get midpoint
WITH midpoint AS
(
SELECT
  s.segmented_stream_id,
  s.linear_feature_id,
  s.waterbody_key,
  ST_LineInterpolatePoint(geom, .5) as geom
FROM bcfishpass.streams s
WHERE s.edge_type = 1250
),

-- find closest right bank (or right bank of closest island)
right_bank AS
 ( SELECT
    pt.segmented_stream_id,
    nn.linear_feature_id,
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
    pt.segmented_stream_id,
    nn.linear_feature_id,
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
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  channel_width_mapped
)

SELECT
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code,
  --round(r.distance_to_pt::numeric, 2) as distance_to_right_bank,
  --round(l.distance_to_pt::numeric, 2) as distance_to_left_bank,
  round(avg(r.distance_to_pt + l.distance_to_pt)::numeric, 2) as channel_width_mapped
FROM right_bank r
INNER JOIN left_bank l ON r.segmented_stream_id = l.segmented_stream_id
INNER JOIN bcfishpass.streams s ON r.segmented_stream_id = s.segmented_stream_id
GROUP BY s.wscode_ltree, s.localcode_ltree, s.watershed_group_code;


-- as a rough visual QA - buffer streams by the calculated channel width
DROP TABLE IF EXISTS bcfishpass.channel_width_mapped_qa ;

CREATE TABLE bcfishpass.channel_width_mapped_qa
(id SERIAL primary key,
wscode_ltree ltree,
localcode_ltree ltree,
watershed_group_code text,
geom geometry(polygon, 3005)
);

INSERT INTO bcfishpass.channel_width_mapped_qa
(wscode_ltree,
localcode_ltree,
watershed_group_code,
geom)

SELECT
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code,
  ST_Buffer(s.geom, cw.channel_width_mapped) as geom
FROM bcfishpass.streams s
INNER JOIN bcfishpass.channel_width_mapped cw ON s.wscode_ltree = cw.wscode_ltree AND s.localcode_ltree = cw.localcode_ltree
WHERE s.edge_type = 1250;

CREATE INDEX ON bcfishpass.channel_width_mapped_qa USING GIST (geom);
