WITH streams AS
(
  SELECT s.*
  FROM whse_basemapping.fwa_stream_networks_sp s
  WHERE s.watershed_group_code = :'wsg'
  AND s.fwa_watershed_code NOT LIKE '999%' -- exclude streams that are not part of the network
  AND s.edge_type NOT IN (1410, 1425)        -- exclude subsurface flow
  AND s.localcode_ltree IS NOT NULL          -- exclude streams with no local code
),

roads AS
(

  -- OGC PERMITS PRE 06
  SELECT
    og_petrlm_dev_rd_pre06_pub_id,
    geom
  FROM whse_mineral_tenure.og_petrlm_dev_rds_pre06_pub_sp r
  WHERE petrlm_development_road_type != 'WINT' -- exclude winter roads
),

-- overlay with streams, creating intersection points and labelling bridges
intersections AS
(
  SELECT
    r.og_petrlm_dev_rd_pre06_pub_id,
    s.linear_feature_id,
    s.blue_line_key,
    s.wscode_ltree,
    s.localcode_ltree,
    s.length_metre,
    s.downstream_route_measure,
    s.geom as geom_s,
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

-- to eliminate duplication, cluster the crossings,
clusters AS
(
  -- 12.5m clustering. Don't bother to cluster across streams at this point
  SELECT
    max(og_petrlm_dev_rd_pre06_pub_id) AS og_petrlm_dev_rd_pre06_pub_id,
    linear_feature_id,
    blue_line_key,
    wscode_ltree,
    localcode_ltree,
    length_metre,
    downstream_route_measure,
    geom_s,
    ST_Centroid(unnest(ST_ClusterWithin(geom_x, 12.5))) as geom_x
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

-- finally, generate the point from the measure.
INSERT INTO bcfishpass.modelled_stream_crossings
  (og_petrlm_dev_rd_pre06_pub_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom)
SELECT
  og_petrlm_dev_rd_pre06_pub_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure_pt as downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  :'wsg' AS watershed_group_code,
  (ST_Dump(ST_LocateAlong(geom_s, downstream_route_measure_pt))).geom as geom
FROM intersections_measures;