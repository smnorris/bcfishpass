-- create pscis events table, linking pscis points to streams
DROP TABLE IF EXISTS bcfishpass.pscis_events_sp;

CREATE TABLE bcfishpass.pscis_events_sp
(
 stream_crossing_id       integer  PRIMARY KEY ,
 modelled_crossing_id        integer              ,
 distance_to_stream       double precision     ,
 linear_feature_id        bigint               ,
 wscode_ltree             ltree                ,
 localcode_ltree          ltree                ,
 blue_line_key            integer              ,
 downstream_route_measure double precision     ,
 watershed_group_code     character varying(4) ,
 score                    integer              ,
 pscis_status             text                 ,
 current_barrier_result_code text              ,
 geom                     geometry(Point, 3005)
);

-- first, insert PSCIS points that have been manually matched to streams (by CWF)
-- note that we include features that we know are not matched to streams,
-- this ensures they are not added in later steps. Delete them later.
WITH referenced AS
(SELECT
  a.stream_crossing_id,
  a.modelled_crossing_id,
  ST_Distance(p.geom, s.geom) as distance_to_stream,
  a.linear_feature_id,
  s.wscode_ltree,
  s.localcode_ltree,
  s.blue_line_key,
  -- reference the point to the stream, making output measure an integer
  -- (ensuring point measure is between stream's downtream measure and upstream measure)
  CEIL(GREATEST(s.downstream_route_measure, FLOOR(LEAST(s.upstream_route_measure,
  (ST_LineLocatePoint(s.geom, ST_ClosestPoint(s.geom, p.geom)) * s.length_metre) + s.downstream_route_measure
  )))) as downstream_route_measure,
  s.watershed_group_code,
  NULL::integer as score,
  CASE
    WHEN hc.stream_crossing_id IS NOT NULL
    THEN 'HABITAT CONFIRMATION'
    ELSE p.current_pscis_status
  END AS pscis_status,
  p.current_barrier_result_code
FROM bcfishpass.pscis_modelledcrossings_streams_xref a
INNER JOIN bcfishpass.pscis_points_all p
ON a.stream_crossing_id = p.stream_crossing_id
LEFT OUTER JOIN whse_basemapping.fwa_stream_networks_sp s
ON a.linear_feature_id = s.linear_feature_id
LEFT OUTER JOIN whse_fish.pscis_habitat_confirmation_svw hc
ON a.stream_crossing_id = hc.stream_crossing_id
)
-- ensure that we include points that do not get referenced
-- (so they are not added later by the automated process)
INSERT INTO bcfishpass.pscis_events_sp
SELECT r.*, NULL as geom
FROM referenced r
WHERE linear_feature_id is NULL
UNION ALL
SELECT
  r.*,
  (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, r.downstream_route_measure)))).geom as geom
FROM referenced r
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON r.linear_feature_id = s.linear_feature_id
WHERE r.linear_feature_id is NOT NULL;

-- Now insert data from the prelim tables, pruning PSCIS duplicates that remain

-- First, find all crossings on same stream within 5m of another
-- in the _prelim3 table

-- Then, by selecting DISTINCT ON blue line key and measure, and sorting,
-- we remove duplicate events, retaining (in order of priority)
--  - higher index status (1 REMEDIATED, 2 DESIGN, 3 ASSESSED)
--  - most recently assessed
--  - closest source point to stream


INSERT INTO bcfishpass.pscis_events_sp
SELECT
  p.stream_crossing_id,
  p.modelled_crossing_id,
  p.distance_to_stream,
  p.linear_feature_id,
  p.wscode_ltree,
  p.localcode_ltree,
  p.blue_line_key,
  p.downstream_route_measure,
  p.watershed_group_code,
  p.score,
  CASE
    WHEN hc.stream_crossing_id IS NOT NULL
    THEN 'HABITAT CONFIRMATION'
    ELSE pa.current_pscis_status
  END AS pscis_status,
  pa.current_barrier_result_code,
  ST_Force2D((ST_Dump(ST_LocateAlong(s.geom, p.downstream_route_measure))).geom) as geom
FROM (
  SELECT DISTINCT ON (blue_line_key, m_mid)
      a.stream_crossing_id,
      a.modelled_crossing_id,
      a.linear_feature_id,
      a.wscode_ltree,
      a.localcode_ltree,
      a.distance_to_stream,
      a.blue_line_key,
      a.downstream_route_measure,
      -- find the midpoint between the duplicate crossings so that
      -- we have some way to find unique locations (this doesn't get retained,
      COALESCE(
        (a.downstream_route_measure + b.downstream_route_measure) / 2,
        a.downstream_route_measure)
      AS m_mid,
      ass.assessment_date,
      CASE
        WHEN x.current_pscis_status = 'REMEDIATED' THEN 1
        WHEN x.current_pscis_status = 'DESIGN' THEN 2
        WHEN x.current_pscis_status = 'ASSESSED' THEN 3
      END AS status_idx,
      a.watershed_group_code,
      a.score
  FROM bcfishpass.pscis_events_prelim3 a
  LEFT OUTER JOIN
  -- Manually remove a handful of crossings from consideration
  -- (the query fails when there are three sites at one location,
  -- this is an easy fix)
    (SELECT *
       FROM bcfishpass.pscis_events_prelim3
      WHERE stream_crossing_id NOT IN (1110, 1106, 6817, 124622, 196740)
    ) b
  -- find points on the same stream, measure is within 5m, not the same pt
    ON a.blue_line_key = b.blue_line_key
   AND abs(a.downstream_route_measure - b.downstream_route_measure) < 5
   AND a.stream_crossing_id != b.stream_crossing_id
  LEFT OUTER JOIN whse_fish.pscis_assessment_svw ass
    ON a.stream_crossing_id = ass.stream_crossing_id
  LEFT OUTER JOIN bcfishpass.pscis_points_all x
    ON a.stream_crossing_id = x.stream_crossing_id
  ORDER BY
    blue_line_key,
    m_mid,
    status_idx,
    assessment_date,
    distance_to_stream)
AS p
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON p.linear_feature_id = s.linear_feature_id
INNER JOIN bcfishpass.pscis_points_all pa
ON p.stream_crossing_id = pa.stream_crossing_id
LEFT OUTER JOIN whse_fish.pscis_habitat_confirmation_svw hc
ON p.stream_crossing_id = hc.stream_crossing_id
ON CONFLICT DO NOTHING; -- don't re-insert data we've already manually matched

-- now delete crossings that aren't matched to streams
DELETE FROM bcfishpass.pscis_events_sp WHERE linear_feature_id IS NULL;

CREATE INDEX ON bcfishpass.pscis_events_sp (modelled_crossing_id);
CREATE INDEX ON bcfishpass.pscis_events_sp (linear_feature_id);
CREATE INDEX ON bcfishpass.pscis_events_sp (blue_line_key);
CREATE INDEX ON bcfishpass.pscis_events_sp USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.pscis_events_sp USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.pscis_events_sp USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.pscis_events_sp USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.pscis_events_sp USING GIST (geom);