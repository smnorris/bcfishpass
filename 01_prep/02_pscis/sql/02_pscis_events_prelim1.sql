-- Match PSCIS points to all distinct streams (blue lines) within 200m

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
  FROM bcfishpass.pscis_points_all as pt
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
    LIMIT 20) as nn
  WHERE nn.distance_to_stream < 200
)

SELECT DISTINCT ON (stream_crossing_id, blue_line_key)
  c.stream_crossing_id,
  c.linear_feature_id,
  c.wscode_ltree,
  c.localcode_ltree,
  c.fwa_watershed_code,
  c.local_watershed_code,
  c.blue_line_key,
  CEIL(
    GREATEST(c.downstream_route_measure,
      FLOOR(
        LEAST(c.upstream_route_measure,
          (ST_LineLocatePoint(c.geom, ST_ClosestPoint(c.geom, pts.geom)) * c.length_metre) + c.downstream_route_measure
  )))) as downstream_route_measure,
  c.distance_to_stream,
  c.watershed_group_code
FROM candidates c
INNER JOIN bcfishpass.pscis_points_all pts ON c.stream_crossing_id = pts.stream_crossing_id
ORDER BY c.stream_crossing_id, c.blue_line_key, c.distance_to_stream;

CREATE INDEX ON bcfishpass.pscis_events_prelim1 (stream_crossing_id);
CREATE INDEX ON bcfishpass.pscis_events_prelim1 (linear_feature_id);