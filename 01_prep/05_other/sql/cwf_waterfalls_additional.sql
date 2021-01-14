-- ---------------------------------------------
-- join additional waterfalls to FWA streams
-- ---------------------------------------------
DROP TABLE IF EXISTS cwf.waterfalls_additional_events;

CREATE TABLE cwf.waterfalls_additional_events
 (
 ogc_fid                 integer primary key,
 name  text        ,
 source text           ,
 linear_feature_id        bigint           ,
 wscode_ltree             ltree            ,
 localcode_ltree          ltree            ,
 waterbody_key            integer          ,
 blue_line_key            integer          ,
 downstream_route_measure double precision ,
 distance_to_stream       double precision ,
 height                   double precision ,
 watershed_group_code     text,
 geom                     geometry(Point,3005),
 -- be certain we do not duplicate features at the same spot
 UNIQUE (blue_line_key, downstream_route_measure)
);

-- first, find up to 10 streams within 200m of the falls
WITH candidates AS
 ( SELECT
    pt.ogc_fid,
    pt.name,
    pt.source,
    nn.linear_feature_id,
    nn.wscode_ltree,
    nn.localcode_ltree,
    nn.blue_line_key,
    nn.waterbody_key,
    nn.length_metre,
    nn.downstream_route_measure,
    nn.upstream_route_measure,
    nn.distance_to_stream,
    nn.watershed_group_code,
    ST_LineMerge(nn.geom) AS geom
  FROM cwf.waterfalls_additional as pt
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
      ogc_fid,
      blue_line_key,
      min(distance_to_stream) AS distance_to_stream
    FROM candidates
    GROUP BY ogc_fid, blue_line_key) as f
  ORDER BY distance_to_stream asc
),

-- from the selected blue lines, generate downstream_route_measure
-- and only return the closest match
measures AS
(SELECT DISTINCT ON (bluelines.ogc_fid)
  bluelines.ogc_fid,
  candidates.name,
  candidates.source,
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
  candidates.watershed_group_code
FROM bluelines
INNER JOIN candidates ON bluelines.ogc_fid = candidates.ogc_fid
AND bluelines.blue_line_key = candidates.blue_line_key
AND bluelines.distance_to_stream = candidates.distance_to_stream
INNER JOIN cwf.waterfalls_additional pts
ON bluelines.ogc_fid = pts.ogc_fid
ORDER BY bluelines.ogc_fid, candidates.distance_to_stream asc
)

INSERT INTO cwf.waterfalls_additional_events
 (ogc_fid,
 name,
 source,
 linear_feature_id,
 wscode_ltree,
 localcode_ltree,
 waterbody_key,
 blue_line_key,
 downstream_route_measure,
 distance_to_stream,
 watershed_group_code,
 geom)
SELECT
  p.ogc_fid,
  p.name,
  p.source,
  p.linear_feature_id,
  p.wscode_ltree,
  p.localcode_ltree,
  p.waterbody_key,
  p.blue_line_key,
  p.downstream_route_measure,
  p.distance_to_stream,
  p.watershed_group_code,
  (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, p.downstream_route_measure)))).geom as geom
FROM measures p
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON p.linear_feature_id = s.linear_feature_id
ON CONFLICT DO NOTHING;

CREATE INDEX ON cwf.waterfalls_additional_events (ogc_fid);
CREATE INDEX ON cwf.waterfalls_additional_events (linear_feature_id);
CREATE INDEX ON cwf.waterfalls_additional_events (blue_line_key);
CREATE INDEX ON cwf.waterfalls_additional_events USING GIST (wscode_ltree);
CREATE INDEX ON cwf.waterfalls_additional_events USING BTREE (wscode_ltree);
CREATE INDEX ON cwf.waterfalls_additional_events USING GIST (localcode_ltree);
CREATE INDEX ON cwf.waterfalls_additional_events USING BTREE (localcode_ltree);


