DROP TABLE IF EXISTS bcfishpass.falls_fiss;

-- ---------------------------------------------
-- Create falls_fiss table from fiss obsetacles and fiss obstacles unpublished,
-- combining data to get only one feature at a given point (using max height at that point)
-- ---------------------------------------------
CREATE TABLE bcfishpass.falls_fiss
(
 falls_fiss_id              serial primary key  ,
 height                     double precision    ,
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
    geom
  FROM singlepart_unpublished o
  WHERE o.obstacle_name = 'Falls'
),

agg AS
(
  SELECT
    unnest(array_agg(o.height)) as height,
    geom
  FROM height_cleaned o
  GROUP BY o.geom
)

INSERT INTO bcfishpass.falls_fiss
(height, watershed_group_code, geom)
SELECT
  max(agg.height) as height,
  g.watershed_group_code,
  agg.geom
FROM agg
INNER JOin whse_basemapping.fwa_watershed_groups_subdivided g
ON ST_Intersects(agg.geom, g.geom)
GROUP BY g.watershed_group_code, agg.geom;


-- ---------------------------------------------
-- Next, reference falls to the FWA stream network, creating output
-- event table falls_events_sp. Simply join falls to closest stream.
-- FISS falls >= 5m are barriers, or as indicated in falls_fiss_barrier_ind.csv
-- ---------------------------------------------
DROP TABLE IF EXISTS bcfishpass.falls_events_sp;

CREATE TABLE bcfishpass.falls_events_sp
 (
 falls_event_id           serial primary key,
 source                   text             ,
 height                   double precision ,
 barrier_ind              boolean          ,
 distance_to_stream       double precision ,
 linear_feature_id        bigint           ,
 blue_line_key            integer          ,
 downstream_route_measure double precision ,
 wscode_ltree             ltree            ,
 localcode_ltree          ltree            ,
 watershed_group_code     text,
 geom                     geometry(Point, 3005),
 -- since blkey/measure needs to be unique we might as well use it as the pk
 -- in the absence of anything else (stable)
 UNIQUE (blue_line_key, downstream_route_measure)
);

-- first, find up to 10 streams within 200m of the falls
WITH candidates AS
 ( SELECT
    pt.falls_fiss_id,
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
  FROM bcfishpass.falls_fiss as pt
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
      falls_fiss_id,
      blue_line_key,
      min(distance_to_stream) AS distance_to_stream
    FROM candidates
    GROUP BY falls_fiss_id, blue_line_key) as f
  ORDER BY distance_to_stream asc
),

-- from the selected blue lines, generate downstream_route_measure
-- and only return the closest match
events AS

(
  SELECT DISTINCT ON (bluelines.falls_fiss_id )
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
  INNER JOIN candidates ON bluelines.falls_fiss_id  = candidates.falls_fiss_id
  AND bluelines.blue_line_key = candidates.blue_line_key
  AND bluelines.distance_to_stream = candidates.distance_to_stream
  INNER JOIN bcfishpass.falls_fiss pts
  ON bluelines.falls_fiss_id  = pts.falls_fiss_id
  ORDER BY bluelines.falls_fiss_id, candidates.distance_to_stream asc
)

INSERT INTO bcfishpass.falls_events_sp
 (
 source,
 height,
 barrier_ind,
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
 CASE
   WHEN b.barrier_ind IS NOT NULL THEN b.barrier_ind
   WHEN b.barrier_ind IS NULL AND e.height >= 5 THEN True
   ELSE False
 END as barrier_ind,
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
LEFT OUTER JOIN bcfishpass.falls_fiss_barrier_ind b
ON e.blue_line_key = b.blue_line_key AND
   e.downstream_route_measure = b.downstream_route_measure
ON CONFLICT DO NOTHING;


-- ---------------------------------------------
-- now insert other (non-fiss) falls
-- ---------------------------------------------

-- first, find up to 10 streams within 200m of the falls
WITH candidates AS
 ( SELECT
    pt.falls_other_id,
    pt.source,
    pt.barrier_ind,
    nn.linear_feature_id,
    nn.wscode_ltree,
    nn.localcode_ltree,
    nn.blue_line_key,
    nn.length_metre,
    nn.downstream_route_measure,
    nn.upstream_route_measure,
    nn.distance_to_stream,
    nn.watershed_group_code,
    ST_LineMerge(nn.geom) AS geom
  FROM bcfishpass.falls_other as pt
  CROSS JOIN LATERAL
  (SELECT
     str.linear_feature_id,
     str.wscode_ltree,
     str.localcode_ltree,
     str.blue_line_key,
     str.length_metre,
     str.downstream_route_measure,
     str.upstream_route_measure,
     str.watershed_group_code,
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
      falls_other_id,
      blue_line_key,
      min(distance_to_stream) AS distance_to_stream
    FROM candidates
    GROUP BY falls_other_id, blue_line_key) as f
  ORDER BY distance_to_stream asc
),

-- from the selected blue lines, generate downstream_route_measure
-- and only return the closest match
measures AS
(SELECT DISTINCT ON (b.falls_other_id)
  pts.source,
  pts.barrier_ind,
  c.linear_feature_id,
  c.wscode_ltree,
  c.localcode_ltree,
  b.blue_line_key,
  -- reference the point to the stream, making output measure an integer
  -- (ensuring point measure is between stream's downtream measure and upstream measure)
  CEIL(GREATEST(c.downstream_route_measure, FLOOR(LEAST(c.upstream_route_measure,
  (ST_LineLocatePoint(c.geom, ST_ClosestPoint(c.geom, pts.geom)) * c.length_metre) + c.downstream_route_measure
  )))) as downstream_route_measure,
  c.distance_to_stream,
  c.watershed_group_code
FROM bluelines b
INNER JOIN candidates c ON b.falls_other_id = c.falls_other_id
AND b.blue_line_key = c.blue_line_key
AND b.distance_to_stream = c.distance_to_stream
INNER JOIN bcfishpass.falls_other pts
ON b.falls_other_id = pts.falls_other_id
ORDER BY b.falls_other_id, c.distance_to_stream asc
)

INSERT INTO bcfishpass.falls_events_sp
 (
 source,
 barrier_ind,
 distance_to_stream,
 linear_feature_id,
 blue_line_key,
 downstream_route_measure,
 wscode_ltree,
 localcode_ltree,
 watershed_group_code,
 geom)
SELECT
  p.source,
  p.barrier_ind,
  p.distance_to_stream,
  p.linear_feature_id,
  p.blue_line_key,
  p.downstream_route_measure,
  p.wscode_ltree,
  p.localcode_ltree,
  p.watershed_group_code,
  (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, p.downstream_route_measure)))).geom as geom
FROM measures p
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON p.linear_feature_id = s.linear_feature_id
ON CONFLICT DO NOTHING;



CREATE INDEX ON bcfishpass.falls_events_sp (linear_feature_id);
CREATE INDEX ON bcfishpass.falls_events_sp (blue_line_key);
CREATE INDEX ON bcfishpass.falls_events_sp USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.falls_events_sp USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.falls_events_sp USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.falls_events_sp USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.falls_events_sp USING GIST (geom);
