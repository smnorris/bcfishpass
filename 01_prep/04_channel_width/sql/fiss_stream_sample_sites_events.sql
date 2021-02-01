-- Join fiss sample sites to nearest streams within 100m,
-- then finalize match by preferring the stream with matching watershed codes

DROP TABLE IF EXISTS whse_fish.fiss_stream_sample_sites_events;

CREATE TABLE whse_fish.fiss_stream_sample_sites_events AS

-- only wsd of interest
WITH pts AS
(SELECT pt.stream_sample_site_id, pt.geom
FROM whse_fish.fiss_stream_sample_sites_sp as pt
INNER JOIN whse_basemapping.fwa_watershed_groups_poly wsd
ON ST_Intersects(pt.geom, wsd.geom)
WHERE wsd.watershed_group_code IN ('LNIC','HORS','BULK','ELKR','MORR')
),

-- match pts to closest 10 streams within 100m
candidates AS
 ( SELECT
    pts.stream_sample_site_id,
    nn.linear_feature_id,
    nn.wscode_ltree,
    nn.localcode_ltree,
    nn.blue_line_key,
    nn.waterbody_key,
    nn.length_metre,
    nn.downstream_route_measure,
    nn.distance_to_stream,
    ST_LineMerge(nn.geom) AS geom
  FROM pts
  CROSS JOIN LATERAL
  (SELECT
     str.linear_feature_id,
     str.wscode_ltree,
     str.localcode_ltree,
     str.blue_line_key,
     str.waterbody_key,
     str.length_metre,
     str.downstream_route_measure,
     str.geom,
     ST_Distance(str.geom, pts.geom) as distance_to_stream
    FROM whse_basemapping.fwa_stream_networks_sp AS str
    WHERE str.localcode_ltree IS NOT NULL
    AND NOT str.wscode_ltree <@ '999'
    ORDER BY str.geom <-> pts.geom
    LIMIT 10) as nn
  WHERE nn.distance_to_stream < 250
),

-- find just the closest point for distinct blue_line_keys -
-- we don't want to match to all individual stream segments
bluelines AS
(SELECT * FROM
    (SELECT
      stream_sample_site_id,
      blue_line_key,
      min(distance_to_stream) AS distance_to_stream
    FROM candidates
    GROUP BY stream_sample_site_id, blue_line_key) as f
  ORDER BY distance_to_stream
),

-- from the selected blue lines, generate downstream_route_measure
indexed AS
(SELECT
  bluelines.stream_sample_site_id,
  candidates.linear_feature_id,
  (REPLACE(REPLACE(lut.fwa_watershed_code_20k, '-000000', ''), '-', '.')::ltree) as wscode_ltree_lookup,
  candidates.wscode_ltree,
  candidates.localcode_ltree,
  candidates.waterbody_key,
  bluelines.blue_line_key,
  (ST_LineLocatePoint(candidates.geom,
                       ST_ClosestPoint(candidates.geom, pts.geom))
     * candidates.length_metre) + candidates.downstream_route_measure
    AS downstream_route_measure,
  candidates.distance_to_stream
FROM bluelines
INNER JOIN candidates ON bluelines.stream_sample_site_id = candidates.stream_sample_site_id
AND bluelines.blue_line_key = candidates.blue_line_key
AND bluelines.distance_to_stream = candidates.distance_to_stream
INNER JOIN whse_fish.fiss_stream_sample_sites_sp pts
ON bluelines.stream_sample_site_id = pts.stream_sample_site_id
LEFT OUTER JOIN
 (SELECT
     MIN(fwa_watershed_code_20k) fwa_watershed_code_20k,
     watershed_code_50k
  FROM whse_basemapping.fwa_streams_20k_50k
  GROUP BY watershed_code_50k) AS lut
ON REPLACE(pts.new_watershed_code,'-','') = lut.watershed_code_50k
)

-- grab closest with a matched code
SELECT DISTINCT ON (stream_sample_site_id) *
FROM indexed
WHERE wscode_ltree_lookup = wscode_ltree
ORDER BY indexed.stream_sample_site_id, indexed.distance_to_stream asc