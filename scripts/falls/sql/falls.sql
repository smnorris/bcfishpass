DROP TABLE IF EXISTS bcfishpass.fiss_obstacles_falls;

-- ---------------------------------------------
-- Create fiss_obstacles_falls table from fiss obsatacles (from bcgw and unpublished),
-- combining data to get only one feature at a given point (using max height at that point)
-- ---------------------------------------------
CREATE TABLE bcfishpass.fiss_obstacles_falls
(
 fiss_obstacles_falls_id    serial primary key  ,
 height                     double precision    ,
 new_watershed_code         text                ,
 watershed_group_code       text                ,
 geom                       geometry(Point, 3005)
);

WITH distinct_unpublished AS
(
  SELECT DISTINCT  -- source may include duplicates
    featur_typ_code as feature_type_code,
    -- tweak codes to match those in existing table
    CASE
      WHEN featur_typ_code = 'F' THEN 'Falls'
      WHEN featur_typ_code = 'D' THEN 'Dam'
    END AS obstacle_name,
    point_id_field,
    utm_zone,
    utm_easting,
    utm_northing,
    height,
    length,
    sitesrvy_id,
    comments,
    ST_Transform(ST_PointFromText('POINT (' || utm_easting || ' ' || utm_northing || ')', 32600 + utm_zone::int), 3005) as geom
  FROM bcfishpass.fiss_obstacles_unpublished
),

singlepart_unpublished AS
(
  SELECT
    feature_type_code,
    obstacle_name,
    height,
    length,
    utm_zone,
    utm_easting,
    utm_northing,
    (ST_Dump(geom)).geom
  FROM distinct_unpublished
  -- not all data has geom (lots of null UTMs), filter those out
  WHERE geom is not null
),

height_cleaned AS
(
  SELECT
    CASE
      -- remove garbage from height values
      WHEN height = 999 THEN NULL
      WHEN height = 9999 THEN NULL
      WHEN height = -1000 THEN NULL
      ELSE height
    END as height,
    new_watershed_code,
    geom
  FROM whse_fish.fiss_obstacles_pnt_sp o
  WHERE o.obstacle_name = 'Falls'
  UNION ALL
  SELECT
    CASE
      -- remove garbage from height values
      WHEN height = 999 THEN NULL
      WHEN height = 9999 THEN NULL
      WHEN height = -1000 THEN NULL
      ELSE height
    END as height,
    NULL as new_watershed_code,
    geom
  FROM singlepart_unpublished o
  WHERE o.obstacle_name = 'Falls'
),

agg AS
(
  SELECT
    unnest(array_agg(height)) as height,
    new_watershed_code,
    geom
  FROM height_cleaned
  GROUP BY new_watershed_code, geom
)

INSERT INTO bcfishpass.fiss_obstacles_falls
(height, new_watershed_code, watershed_group_code, geom)
SELECT
  max(agg.height) as height,
  agg.new_watershed_code,
  g.watershed_group_code,
  agg.geom
FROM agg
INNER JOin whse_basemapping.fwa_watershed_groups_poly g
ON ST_Intersects(agg.geom, g.geom)
GROUP BY g.watershed_group_code, agg.new_watershed_code, agg.geom;


-- ---------------------------------------------
-- Create table holding all falls, referenced to stream network
-- ---------------------------------------------
DROP TABLE IF EXISTS bcfishpass.falls;

CREATE TABLE bcfishpass.falls
 (
  -- source falls data does not have pk, generate a (big) integer pk from blkey and measure
 falls_id bigint
     GENERATED ALWAYS AS ((((blue_line_key::bigint + 1) - 354087611) * 10000000) + round(downstream_route_measure::bigint)) STORED PRIMARY KEY,
 fiss_obstacles_falls_id  integer          , -- temporary column, for tracking what gets inserted
 source                   text             ,
 height                   double precision ,
 barrier_ind              boolean          ,
 falls_name               text             ,
 reviewer_name            text             ,
 notes                    text             ,
 distance_to_stream       double precision ,
 linear_feature_id        bigint           ,
 blue_line_key            integer          ,
 downstream_route_measure double precision ,
 wscode_ltree             ltree            ,
 localcode_ltree          ltree            ,
 watershed_group_code     text,
 geom                     geometry(Point, 3005),
 UNIQUE (blue_line_key, downstream_route_measure)
);


-- ----------------------------------------------
-- Reference FISS falls to the FWA stream network, matching to closest stream
-- that has matching watershed code (via 50k/20k lookup)
-- ----------------------------------------------

WITH candidates AS -- first, find up to 10 streams within 200m of the falls
 ( SELECT
    pt.fiss_obstacles_falls_id,
    nn.linear_feature_id,
    nn.wscode_ltree,
    nn.localcode_ltree,
    nn.blue_line_key,
    nn.waterbody_key,
    nn.length_metre,
    nn.downstream_route_measure,
    nn.upstream_route_measure,
    nn.distance_to_stream,
    pt.height,
    pt.watershed_group_code,
    ST_LineMerge(nn.geom) AS geom
  FROM bcfishpass.fiss_obstacles_falls as pt
  CROSS JOIN LATERAL
  (SELECT
     str.linear_feature_id,
     str.wscode_ltree,
     str.localcode_ltree,
     str.blue_line_key,
     str.waterbody_key,
     str.length_metre,
     str.downstream_route_measure,
     str.upstream_route_measure,
     str.geom,
     ST_Distance(str.geom, pt.geom) as distance_to_stream
    FROM whse_basemapping.fwa_stream_networks_sp AS str
    WHERE str.localcode_ltree IS NOT NULL
    AND NOT str.wscode_ltree <@ '999'
    ORDER BY str.geom <-> pt.geom
    LIMIT 10) as nn
  WHERE nn.distance_to_stream < 200
),

-- find just the closest point for distinct blue_line_keys -
-- we don't want to match to all individual stream segments
bluelines AS
(SELECT * FROM
    (SELECT
      fiss_obstacles_falls_id,
      blue_line_key,
      min(distance_to_stream) AS distance_to_stream
    FROM candidates
    GROUP BY fiss_obstacles_falls_id, blue_line_key) as f
  ORDER BY distance_to_stream asc
),

-- from the selected blue lines, generate downstream_route_measure
-- and join to the 20k-50k lookup table
events AS
(
  SELECT
    bluelines.fiss_obstacles_falls_id,
    candidates.linear_feature_id,
    (REPLACE(REPLACE(lut.fwa_watershed_code_20k, '-000000', ''), '-', '.')::ltree) as wscode_ltree_lookup,
    candidates.wscode_ltree,
    candidates.localcode_ltree,
    candidates.waterbody_key,
    bluelines.blue_line_key,
    -- reference the point to the stream, making output measure an integer
    -- (ensuring point measure is between stream's downtream measure and upstream measure)
    CEIL(GREATEST(candidates.downstream_route_measure, FLOOR(LEAST(candidates.upstream_route_measure,
    (ST_LineLocatePoint(candidates.geom, ST_ClosestPoint(candidates.geom, pts.geom)) * candidates.length_metre) + candidates.downstream_route_measure
    )))) as downstream_route_measure,
    candidates.distance_to_stream,
    candidates.height,
    candidates.watershed_group_code
  FROM bluelines
  INNER JOIN candidates ON bluelines.fiss_obstacles_falls_id  = candidates.fiss_obstacles_falls_id
  AND bluelines.blue_line_key = candidates.blue_line_key
  AND bluelines.distance_to_stream = candidates.distance_to_stream
  INNER JOIN bcfishpass.fiss_obstacles_falls pts
  ON bluelines.fiss_obstacles_falls_id  = pts.fiss_obstacles_falls_id
  LEFT OUTER JOIN whse_basemapping.fwa_streams_20k_50k lut
  ON REPLACE(pts.new_watershed_code,'-','') = lut.watershed_code_50k
  ORDER BY bluelines.fiss_obstacles_falls_id, candidates.distance_to_stream asc
),

-- grab closest with a matched code
matched AS
(
SELECT DISTINCT ON (fiss_obstacles_falls_id) *
FROM events
WHERE wscode_ltree_lookup = wscode_ltree
ORDER BY fiss_obstacles_falls_id, distance_to_stream asc
)

INSERT INTO bcfishpass.falls
 (
 fiss_obstacles_falls_id,
 source,
 height,
 distance_to_stream,
 linear_feature_id,
 blue_line_key,
 downstream_route_measure,
 wscode_ltree,
 localcode_ltree,
 watershed_group_code,
 geom)
SELECT
  fiss_obstacles_falls_id,
 'FISS' as source,
 e.height,
 e.distance_to_stream,
 e.linear_feature_id,
 e.blue_line_key,
 e.downstream_route_measure,
 e.wscode_ltree,
 e.localcode_ltree,
 e.watershed_group_code,
 (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, e.downstream_route_measure)))).geom as geom
FROM matched e
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON e.linear_feature_id = s.linear_feature_id
ON CONFLICT DO NOTHING;


-- ----------------------------------------------
-- Above only inserts records with matching watershed codes.
-- Now insert records that are not inserted above but are still very close to a stream (50m)
-- ----------------------------------------------
WITH pts AS
(
  SELECT *
  FROM bcfishpass.fiss_obstacles_falls
  WHERE fiss_obstacles_falls_id NOT IN (
     SELECT fiss_obstacles_falls_id from bcfishpass.falls
     WHERE fiss_obstacles_falls_id IS NOT NULL
  )
),

candidates AS -- now find up to 10 streams within 50m of the falls
 ( SELECT
    pt.fiss_obstacles_falls_id,
    nn.linear_feature_id,
    nn.wscode_ltree,
    nn.localcode_ltree,
    nn.blue_line_key,
    nn.waterbody_key,
    nn.length_metre,
    nn.downstream_route_measure,
    nn.upstream_route_measure,
    nn.distance_to_stream,
    pt.height,
    pt.watershed_group_code,
    ST_LineMerge(nn.geom) AS geom
  FROM pts pt
  CROSS JOIN LATERAL
  (SELECT
     str.linear_feature_id,
     str.wscode_ltree,
     str.localcode_ltree,
     str.blue_line_key,
     str.waterbody_key,
     str.length_metre,
     str.downstream_route_measure,
     str.upstream_route_measure,
     str.geom,
     ST_Distance(str.geom, pt.geom) as distance_to_stream
    FROM whse_basemapping.fwa_stream_networks_sp AS str
    WHERE str.localcode_ltree IS NOT NULL
    AND NOT str.wscode_ltree <@ '999'
    ORDER BY str.geom <-> pt.geom
    LIMIT 10) as nn
  WHERE nn.distance_to_stream < 50
),

-- find just the closest point for distinct blue_line_keys -
-- we don't want to match to all individual stream segments
bluelines AS
(SELECT * FROM
    (SELECT
      fiss_obstacles_falls_id,
      blue_line_key,
      min(distance_to_stream) AS distance_to_stream
    FROM candidates
    GROUP BY fiss_obstacles_falls_id, blue_line_key) as f
  ORDER BY distance_to_stream asc
),

-- from the selected blue lines, generate downstream_route_measure
-- and join to the 20k 50k lookup table
events AS
(
  SELECT DISTINCT ON (bluelines.fiss_obstacles_falls_id)
    bluelines.fiss_obstacles_falls_id,
    candidates.linear_feature_id,
    candidates.wscode_ltree,
    candidates.localcode_ltree,
    candidates.waterbody_key,
    bluelines.blue_line_key,
    -- reference the point to the stream, making output measure an integer
    -- (ensuring point measure is between stream's downtream measure and upstream measure)
    CEIL(GREATEST(candidates.downstream_route_measure, FLOOR(LEAST(candidates.upstream_route_measure,
    (ST_LineLocatePoint(candidates.geom, ST_ClosestPoint(candidates.geom, pts.geom)) * candidates.length_metre) + candidates.downstream_route_measure
    )))) as downstream_route_measure,
    candidates.distance_to_stream,
    candidates.height,
    candidates.watershed_group_code
  FROM bluelines
  INNER JOIN candidates ON bluelines.fiss_obstacles_falls_id  = candidates.fiss_obstacles_falls_id
  AND bluelines.blue_line_key = candidates.blue_line_key
  AND bluelines.distance_to_stream = candidates.distance_to_stream
  INNER JOIN bcfishpass.fiss_obstacles_falls pts
  ON bluelines.fiss_obstacles_falls_id  = pts.fiss_obstacles_falls_id
  ORDER BY bluelines.fiss_obstacles_falls_id, candidates.distance_to_stream asc
)

INSERT INTO bcfishpass.falls
 (
 source,
 height,
 distance_to_stream,
 linear_feature_id,
 blue_line_key,
 downstream_route_measure,
 wscode_ltree,
 localcode_ltree,
 watershed_group_code,
 geom)
SELECT
 'FISS' as source,
 e.height,
 e.distance_to_stream,
 e.linear_feature_id,
 e.blue_line_key,
 e.downstream_route_measure,
 e.wscode_ltree,
 e.localcode_ltree,
 e.watershed_group_code,
 (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, e.downstream_route_measure)))).geom as geom
FROM events e
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON e.linear_feature_id = s.linear_feature_id
ON CONFLICT DO NOTHING;


ALTER TABLE bcfishpass.falls DROP COLUMN fiss_obstacles_falls_id;  -- dump the meaningless column

-- ----------------------------------------------
-- insert falls from FWA obstructions
-- ----------------------------------------------
INSERT INTO bcfishpass.falls
(source,
 linear_feature_id,
 blue_line_key,
 downstream_route_measure,
 wscode_ltree,
 localcode_ltree,
 watershed_group_code,
 geom)
SELECT
 'FWA' as source,
  linear_feature_id,
  blue_line_key,
  route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  (ST_Dump(geom)).geom as geom
FROM whse_basemapping.fwa_obstructions_sp
WHERE obstruction_type = 'Falls'
ON CONFLICT DO NOTHING;

-- ---------------------------------------------
-- Load manually added falls
-- ---------------------------------------------
INSERT INTO bcfishpass.falls
 (
 source,
 height,
 barrier_ind,
 falls_name,
 reviewer_name,
 notes,
 linear_feature_id,
 blue_line_key,
 downstream_route_measure,
 wscode_ltree,
 localcode_ltree,
 watershed_group_code,
 geom)
SELECT
  p.source,
  p.height,
  p.barrier_ind,
  p.falls_name,
  p.reviewer_name,
  p.notes,
  s.linear_feature_id,
  p.blue_line_key,
  p.downstream_route_measure,
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code,
  (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, p.downstream_route_measure)))).geom as geom
FROM bcfishpass.user_falls p
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON p.blue_line_key = s.blue_line_key AND
p.downstream_route_measure > s.downstream_route_measure - .001 AND
p.downstream_route_measure + .001 < s.upstream_route_measure
ON CONFLICT DO NOTHING;

-- index
CREATE INDEX ON bcfishpass.falls (linear_feature_id);
CREATE INDEX ON bcfishpass.falls (blue_line_key);
CREATE INDEX ON bcfishpass.falls USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.falls USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.falls USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.falls USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.falls USING GIST (geom);

-- drop load/intermediate tables (but keeping the barrier_ind table for QA)
DROP TABLE bcfishpass.fiss_obstacles_falls;
DROP TABLE bcfishpass.fiss_obstacles_unpublished;


-- --------------------------
-- set default barrier status for fiss/fwa records
-- --------------------------

-- fiss falls < 5m or NULL default to passable
UPDATE bcfishpass.falls
SET barrier_ind = False
WHERE source = 'FISS' AND (height < 5 or height is null);

-- fiss falls >= 5m are barriers
UPDATE bcfishpass.falls
SET barrier_ind = True
WHERE source = 'FISS' AND height >= 5;

-- all fwa features default to barriers
UPDATE bcfishpass.falls
SET barrier_ind = True
WHERE source = 'FWA';

-- --------------------------
-- finalize barrier status from the user control table
-- --------------------------
UPDATE bcfishpass.falls a
SET barrier_ind = b.barrier_ind
FROM bcfishpass.user_barriers_definite_control b
WHERE a.blue_line_key = b.blue_line_key and abs(a.downstream_route_measure - b.downstream_route_measure) < 1;