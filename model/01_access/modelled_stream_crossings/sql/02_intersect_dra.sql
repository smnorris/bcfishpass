WITH streams AS
(
  SELECT s.*
  FROM whse_basemapping.fwa_stream_networks_sp s
  WHERE s.watershed_group_code = :'wsg'
  AND s.fwa_watershed_code NOT LIKE '999%'   -- exclude streams that are not part of the network
  AND s.edge_type NOT IN (1410, 1425)        -- exclude subsurface flow
  AND s.localcode_ltree IS NOT NULL          -- exclude streams with no local code
),

roads AS
(
  -- DRA
  SELECT
    transport_line_id,
    transport_line_type_code,
    geom
  FROM whse_basemapping.transport_line r
  WHERE transport_line_type_code NOT IN ('F','FP','FR','T','TR','TS','RP','RWA')      -- exclude trails other than demographic and all ferry/water
  AND transport_line_surface_code != 'D'                                              -- exclude decomissioned roads
  AND COALESCE(transport_line_structure_code, '') != 'T'                              -- exclude tunnels
),

-- overlay with streams, creating intersection points and labelling bridges
intersections AS
(
  SELECT
    r.transport_line_id,
    r.transport_line_type_code,
    s.linear_feature_id,
    s.wscode_ltree,
    s.localcode_ltree,
    s.blue_line_key,
    s.waterbody_key,
    s.length_metre,
    s.downstream_route_measure,
    s.upstream_route_measure,
    s.stream_order,
    s.geom as geom_s,
    r.geom as geom_r,
    -- dump any collections/mulitpart features to singlepart
    (ST_Dump(
      ST_Intersection(
        (ST_Dump(ST_Force2d(r.geom))).geom,
        (ST_Dump(ST_Force2d(s.geom))).geom
      )
    )).geom AS geom
  FROM roads r
  INNER JOIN streams s
  ON ST_Intersects(r.geom, s.geom)
),

-- to eliminate duplication, cluster the crossings,
-- merging points on the same type of road/structure and on the same stream
-- do this for variable widths depending on level of road
cluster_by_type AS
(
  -- 30m clustering for freeways/highways
  SELECT
    linear_feature_id,
    ST_Centroid(unnest(ST_ClusterWithin(geom, 30))) as geom
  FROM intersections
  WHERE transport_line_type_code IN ('RF', 'RH1', 'RH2')
  GROUP BY linear_feature_id
  UNION ALL
  -- 20m for arterial / collector
  SELECT
    linear_feature_id,
    ST_Centroid(unnest(ST_ClusterWithin(geom, 20))) as geom
  FROM intersections
  WHERE transport_line_type_code IN ('RA1', 'RA2', 'RC1', 'RC2')
  GROUP BY linear_feature_id
  UNION ALL
  -- 12.5m for everything else
  SELECT
    linear_feature_id,
    ST_Centroid(unnest(ST_ClusterWithin(geom, 12.5))) as geom_x
  FROM intersections
  WHERE transport_line_type_code NOT IN ('RF', 'RH1', 'RH2', 'RA1', 'RA2', 'RC1', 'RC2')
  GROUP BY linear_feature_id
),

-- Cluster again across road types and streams using a smaller tolerance
cluster_across_types AS
(
  SELECT
    ST_Centroid(unnest(ST_ClusterWithin(geom, 10))) as geom
  FROM cluster_by_type
),

-- By clustering/aggregating above, we lose stream and road attributes of the point.
-- Join back to streams - when there is more than 1 stream within our tolerance
-- due to clustering above, match on the stream with the higher order.
streams_nn AS
(
  SELECT DISTINCT ON (geom_x)
    geom_x,
    linear_feature_id,
    wscode_ltree,
    localcode_ltree,
    blue_line_key,
    waterbody_key,
    length_metre,
    downstream_route_measure,
    upstream_route_measure,
    geom_s
  FROM
     (
      SELECT
        pt.geom as geom_x,
        nn.linear_feature_id,
        nn.wscode_ltree,
        nn.localcode_ltree,
        nn.blue_line_key,
        nn.waterbody_key,
        nn.length_metre,
        nn.downstream_route_measure,
        nn.upstream_route_measure,
        nn.stream_order,
        nn.geom_s
      FROM cluster_across_types as pt
      CROSS JOIN LATERAL
      (SELECT
         i.linear_feature_id,
         i.wscode_ltree,
         i.localcode_ltree,
         i.blue_line_key,
         i.waterbody_key,
         i.length_metre,
         i.downstream_route_measure,
         i.upstream_route_measure,
         i.stream_order,
         i.geom_s,
         ST_Distance(i.geom_s, pt.geom) as distance_to_stream
        FROM intersections AS i
        ORDER BY i.geom <-> pt.geom
        LIMIT 5) as nn
      WHERE nn.distance_to_stream < 5.01
    ) as stream_nn
  ORDER BY geom_x, stream_order desc
),

-- derive the measures
crossing_measures AS
(
  SELECT
    *,
    (ST_LineLocatePoint(geom_s, geom_x) * length_metre)
      + downstream_route_measure AS downstream_route_measure_pt
  FROM streams_nn
),

-- and then the geoms
crossing_geoms AS
(
  SELECT
    linear_feature_id,
    blue_line_key,
    downstream_route_measure_pt as downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    (ST_Dump(ST_LocateAlong(geom_s, downstream_route_measure_pt))).geom as geom
  FROM crossing_measures
)

-- and finally, join back to closest road and insert the result into the crossing table
INSERT INTO bcfishpass.modelled_stream_crossings
  (
    transport_line_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
  )
SELECT
  nn.transport_line_id,
  pt.linear_feature_id,
  pt.blue_line_key,
  pt.downstream_route_measure,
  pt.wscode_ltree,
  pt.localcode_ltree,
  :'wsg' AS watershed_group_code,
  pt.geom
FROM crossing_geoms as pt
CROSS JOIN LATERAL
  ( SELECT
      i.transport_line_id,
      ST_Distance(i.geom_r, pt.geom) as distance_to_road
    FROM intersections AS i
    ORDER BY i.geom <-> pt.geom
    LIMIT 1
  ) AS nn
WHERE nn.distance_to_road < 16;  -- use a fairly generous tolerance to handle crossings that were clustered at 30m