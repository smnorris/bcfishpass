-- From all streams matched to a PSCIS crossing, find the best match

-- Scoring attemts to identify crossings which have been matched
-- to the wrong stream, based on
--  + distance
--  + stream name
--  + channel width

DROP TABLE IF EXISTS bcfishpass.pscis_events_prelim2;

CREATE TABLE bcfishpass.pscis_events_prelim2 AS

WITH scored AS
(
  SELECT
   e.stream_crossing_id,
   m.modelled_crossing_id,
   e.linear_feature_id,
   e.blue_line_key,
   e.downstream_route_measure,
   e.wscode_ltree,
   e.localcode_ltree,
   e.watershed_group_code,
   e.distance_to_stream,
   str.gnis_name,
   a.stream_name,
   str.stream_order,
   a.downstream_channel_width,
   a.crossing_type_code,
   m.modelled_crossing_type,
   m.geom as model_geom,
   round(ABS(e.downstream_route_measure - m.downstream_route_measure)::numeric, 1) as modelled_xing_dist_instream,
   CASE
      WHEN e.distance_to_stream < 10 THEN 100
      WHEN e.distance_to_stream >= 10 AND e.distance_to_stream < 20 THEN 75
      WHEN e.distance_to_stream >= 20 AND e.distance_to_stream < 50 THEN 25
      WHEN e.distance_to_stream >= 50 THEN 0
    END AS distance_score,
    CASE
      WHEN UPPER(a.stream_name) = UPPER(str.gnis_name) THEN 100
      ELSE 0
    END AS name_score,
    -- when comparing channel width and stream order, we only want to flag the obvious problems,
    -- these width/order relationships are not based on any comprehensive review
    CASE
      -- speculate that order 1 should probably be <5m, most likely under 10
      WHEN stream_order = 1 AND downstream_channel_width !=0 AND downstream_channel_width >= 5 AND downstream_channel_width < 10 THEN -25
      WHEN stream_order = 1 AND downstream_channel_width !=0 AND downstream_channel_width >= 10 THEN -100

      -- order 2 probably under 7, likely under 15m
      WHEN stream_order = 2 AND downstream_channel_width !=0 AND downstream_channel_width > 7 AND downstream_channel_width < 15 THEN -25
      WHEN stream_order = 2 AND downstream_channel_width !=0 AND downstream_channel_width >= 15 THEN -100

      -- order 3 probably more than 1, probably less than 20
      WHEN stream_order = 3 AND downstream_channel_width !=0 AND downstream_channel_width < 1 THEN -25
      WHEN stream_order = 3 AND downstream_channel_width !=0 AND downstream_channel_width >= 20 THEN -25

      -- order 4 def more than 1, probably more than 2
      WHEN stream_order = 4 AND downstream_channel_width !=0 AND downstream_channel_width < 1 THEN -100
      WHEN stream_order = 4 AND downstream_channel_width !=0 AND downstream_channel_width >= 1 AND downstream_channel_width < 2 THEN -25

      -- order 5 def more than 2, prob more than 5
      WHEN stream_order = 5 AND downstream_channel_width !=0 AND downstream_channel_width < 2 THEN -100
      WHEN stream_order = 5 AND downstream_channel_width !=0 AND downstream_channel_width >= 2 AND downstream_channel_width < 5 THEN -25

      -- everything else should be fairly big
      WHEN stream_order >= 6 AND downstream_channel_width !=0 AND downstream_channel_width < 1 THEN -200
      WHEN stream_order >= 6 AND downstream_channel_width !=0 AND downstream_channel_width < 2 THEN -100
      WHEN stream_order >= 6 AND downstream_channel_width !=0 AND downstream_channel_width < 10 THEN -25

      -- also, we know what streams are polygonal. If channel width is <4m on a polygonal river feature, something is definitely wrong
      WHEN r.waterbody_key IS NOT NULL AND downstream_channel_width !=0 AND downstream_channel_width < 4 THEN -200

    ELSE 0
    END as width_order_score

  FROM bcfishpass.pscis_events_prelim1 e
  INNER JOIN whse_basemapping.fwa_stream_networks_sp str
  ON e.linear_feature_id = str.linear_feature_id
  LEFT OUTER JOIN whse_fish.pscis_assessment_svw a ON e.stream_crossing_id = a.stream_crossing_id
  LEFT OUTER JOIN bcfishpass.modelled_stream_crossings m
  ON e.blue_line_key = m.blue_line_key AND
     ABS(e.downstream_route_measure - m.downstream_route_measure) < 100
  LEFT OUTER JOIN whse_basemapping.fwa_rivers_poly r ON str.waterbody_key = r.waterbody_key
)

SELECT DISTINCT ON (stream_crossing_id)
  a.stream_crossing_id,
  a.modelled_crossing_id,
  a.linear_feature_id,
  a.blue_line_key,
  a.downstream_route_measure,
  a.wscode_ltree,
  a.localcode_ltree,
  a.watershed_group_code,
  a.distance_to_stream,
  (a.distance_score + a.name_score + a.width_order_score) as match_score,
  ST_Distance(p.geom, a.model_geom) as distance_to_modelled_xing
FROM scored a INNER JOIN bcfishpass.pscis_points_all p
ON a.stream_crossing_id = p.stream_crossing_id
-- tighten up our final tolerances, PSCIS crossing must be 150m from stream and 175m from modelled crossing (if present)
WHERE distance_to_stream < 150 AND COALESCE(ST_Distance(p.geom, a.model_geom), 0) < 175
ORDER BY stream_crossing_id, match_score desc, distance_to_modelled_xing;

CREATE INDEX ON bcfishpass.pscis_events_prelim2 (stream_crossing_id);
CREATE INDEX ON bcfishpass.pscis_events_prelim2 (modelled_crossing_id);

-- Above we match PSCIS crossings to streams... and if there are modelled crossings on that matched stream,
-- we match the PSCIS crossing to the modelled crossing that is closest. In cases where two PSCIS crossings
-- get matched to the same stream, and a single modelled crosing is closest to both, that modelled crossing
-- will be associated with two PSCIS crossings. This is no good, so we post-process here and make sure
-- that any modelled crossing is only matched to a single (the closest) PSCIS crossing (on the same stream)
-- (there are actually 1899 instances of duplicates, it is quite common).
-- Because there is already a (closer) PSCIS crossing associated with this stream in the vicinity, we
-- also want to knock back the score on the stream match as well, many instances will be unmapped streams
WITH dups AS

-- Find records that are matched to the same modelled crossing
(
  SELECT modelled_crossing_id, count(*) as n
  FROM bcfishpass.pscis_events_prelim2
  GROUP BY modelled_crossing_id
  HAVING count(*) > 1
),

-- find which one should actually be matched (minimum distance)
to_retain AS
(
  SELECT DISTINCT ON (modelled_crossing_id)
    p.stream_crossing_id,
    p.modelled_crossing_id,
    p.distance_to_modelled_xing
  FROM bcfishpass.pscis_events_prelim2 p
  INNER JOIN dups ON p.modelled_crossing_id = dups.modelled_crossing_id
  ORDER BY modelled_crossing_id, distance_to_modelled_xing asc
),

-- based on which one should be matched, set modelled crossing id for the rest to NULL
to_update AS
(
  SELECT
    p.stream_crossing_id,
    p.modelled_crossing_id,
    p.distance_to_modelled_xing
  FROM bcfishpass.pscis_events_prelim2 p
  INNER JOIN dups ON p.modelled_crossing_id = dups.modelled_crossing_id
  LEFT OUTER JOIN to_retain r ON p.stream_crossing_id = r.stream_crossing_id
  WHERE r.stream_crossing_id IS NULL
)

UPDATE bcfishpass.pscis_events_prelim2 e
SET
  modelled_crossing_id = NULL,
  match_score = match_score - 50
WHERE stream_crossing_id IN (SELECT stream_crossing_id FROM to_update);

--SELECT count(*) FROM bcfishpass.pscis_events_prelim2 where match_score = 0;