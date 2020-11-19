DROP TABLE IF EXISTS bcfishpass.pscis_events_prelim1;

CREATE TABLE bcfishpass.pscis_events_prelim1 AS

WITH candidates AS
 ( SELECT
    pt.stream_crossing_id,
    nn.linear_feature_id,
    nn.wscode_ltree,
    nn.localcode_ltree,
    nn.fwa_watershed_code,
    nn.local_watershed_code,
    nn.blue_line_key,
    nn.length_metre,
    nn.downstream_route_measure,
    nn.upstream_route_measure,
    nn.distance_to_stream,
    nn.watershed_group_code,
    ST_LineMerge(nn.geom) AS geom
  FROM whse_fish.pscis_points_all as pt
  CROSS JOIN LATERAL
  (SELECT
     str.linear_feature_id,
     str.wscode_ltree,
     str.localcode_ltree,
     str.fwa_watershed_code,
     str.local_watershed_code,
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
    LIMIT 100) as nn
  WHERE nn.distance_to_stream < 100
),

bluelines AS
(SELECT DISTINCT ON (stream_crossing_id, blue_line_key)
  stream_crossing_id,
  blue_line_key,
  distance_to_stream
FROM candidates
ORDER BY stream_crossing_id, blue_line_key, distance_to_stream
)

SELECT
  bluelines.stream_crossing_id,
  candidates.linear_feature_id,
  candidates.wscode_ltree,
  candidates.localcode_ltree,
  candidates.fwa_watershed_code,
  candidates.local_watershed_code,
  bluelines.blue_line_key,
  --(ST_LineLocatePoint(candidates.geom,
  --                     ST_ClosestPoint(candidates.geom, pts.geom))
  --   * candidates.length_metre) + candidates.downstream_route_measure
  --  AS downstream_route_measure,
  -- reference the point to the stream, making output measure an integer
  -- (ensuring point measure is between stream's downtream measure and upstream measure)
  CEIL(GREATEST(candidates.downstream_route_measure, FLOOR(LEAST(candidates.upstream_route_measure,
  (ST_LineLocatePoint(candidates.geom, ST_ClosestPoint(candidates.geom, pts.geom)) * candidates.length_metre) + candidates.downstream_route_measure
  )))) as downstream_route_measure,
  candidates.distance_to_stream,
  candidates.watershed_group_code
FROM bluelines
INNER JOIN candidates ON bluelines.stream_crossing_id = candidates.stream_crossing_id
AND bluelines.blue_line_key = candidates.blue_line_key
AND bluelines.distance_to_stream = candidates.distance_to_stream
INNER JOIN whse_fish.pscis_points_all pts ON bluelines.stream_crossing_id = pts.stream_crossing_id;

CREATE INDEX ON bcfishpass.pscis_events_prelim1 (stream_crossing_id);
CREATE INDEX ON bcfishpass.pscis_events_prelim1 (linear_feature_id);