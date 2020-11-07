WITH streams AS
(
  SELECT s.*
  FROM whse_basemapping.fwa_stream_networks_sp s
  WHERE s.watershed_group_code = :wsg
  AND s.fwa_watershed_code NOT LIKE '999%' -- exclude streams that are not part of the network
  AND s.edge_type NOT IN (1410, 1425)        -- exclude subsurface flow
  AND s.localcode_ltree IS NOT NULL          -- exclude streams with no local code
),

roads AS
(
  -- RAILWAY
  SELECT
    railway_track_id,
    geom
  FROM whse_basemapping.gba_railway_tracks_sp r
),

-- overlay with streams, creating intersection points
intersections AS
(
  SELECT
    r.railway_track_id,
    s.linear_feature_id,
    s.blue_line_key,
    s.wscode_ltree,
    s.localcode_ltree,
    s.length_metre,
    s.downstream_route_measure,
    s.geom as geom_s,
    s.edge_type,
    -- dump any collections/mulitpart features to singlepart
    (ST_Dump(
      ST_Intersection(
        (ST_Dump(ST_Force2d(r.geom))).geom,
        (ST_Dump(ST_Force2d(s.geom))).geom
      )
    )).geom AS geom_x
  FROM roads r
  INNER JOIN streams s
  ON ST_Intersects(r.geom, s.geom)
),

-- to eliminate duplication, cluster crossings within 20m
-- do not cluster across streams
clusters AS
(
  SELECT
    max(railway_track_id) as railway_track_id,
    linear_feature_id,
    blue_line_key,
    wscode_ltree,
    localcode_ltree,
    length_metre,
    downstream_route_measure,
    geom_s,
    ST_Centroid(unnest(ST_ClusterWithin(geom_x, 20))) as geom_x
  FROM intersections
  GROUP BY linear_feature_id, blue_line_key, wscode_ltree, localcode_ltree, geom_s, length_metre, downstream_route_measure
),

-- derive measures
intersections_measures AS
(
  SELECT
    i.*,
    ST_LineLocatePoint(
       ST_Linemerge(geom_s),
       geom_x
      ) * length_metre + downstream_route_measure
    AS downstream_route_measure_pt
  FROM clusters i
)

-- finally, generate output point from the measure
INSERT INTO fish_passage.modelled_stream_crossings
(railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom)
SELECT
  railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure_pt as downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  :wsg AS watershed_group_code,
  (ST_Dump(ST_LocateAlong(geom_s, downstream_route_measure_pt))).geom as geom
FROM intersections_measures;