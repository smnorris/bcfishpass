-- Find rearing downstream of spawning
-- Rearing streams/wetlands must be connected (to some degree) to spawning streams of the same spp,
-- so rearing model is applied per species to make connectivity/clustering straightforward

-- CHINOOK
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cluster_id,
    s.wscode_ltree,
    s.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.discharge mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'CH'
  WHERE
    s.accessibility_model_salmon IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL AND
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    )
  AND s.watershed_group_code = :'wsg'
),

cluster_minimums AS
(
  SELECT DISTINCT ON (cluster_id)
    cluster_id,
    wscode_ltree,
    localcode_ltree,
    blue_line_key,
    downstream_route_measure
  FROM rearing
  ORDER BY cluster_id, wscode_ltree asc, localcode_ltree asc, downstream_route_measure asc
),

-- find all rearing clusters with spawning either:
--   - upstream
--   - upstream of stream that the rearing is trib to (and rearing is within 10m of confluence)
rearing_clusters_dnstr_of_spawn AS
(
  SELECT DISTINCT s.cluster_id
  FROM cluster_minimums s
  INNER JOIN bcfishpass.streams spawn
  -- make sure there is spawning habitat either upstream
  ON FWA_Upstream(s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree, spawn.blue_line_key, spawn.downstream_route_measure, spawn.wscode_ltree, spawn.localcode_ltree)
  -- OR, if we are at/near a confluence (<10m measure), also consider stream upstream from the confluence
  OR (s.downstream_route_measure < 10 AND FWA_Upstream(subpath(s.wscode_ltree, 0, -1), s.wscode_ltree, spawn.wscode_ltree, spawn.localcode_ltree))
  WHERE spawn.spawning_model_chinook IS TRUE
  AND spawn.watershed_group_code = :'wsg'
),

-- find the stream ids that we want to update
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing a
  INNER JOIN rearing_clusters_dnstr_of_spawn b
  ON a.cluster_id = b.cluster_id
)

-- set rearing as true for these streams
UPDATE bcfishpass.streams s
SET rearing_model_chinook = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);



-- ----------------------------------------------
-- COHO
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cluster_id,
    s.wscode_ltree,
    s.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.discharge mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'CO'
  WHERE
    s.accessibility_model_salmon IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers/wetlands
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300,1050,1150)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    OR s.edge_type IN (1050, 1150)  -- any wetlands are potential rearing
    )

    AND s.watershed_group_code = :'wsg'
),

cluster_minimums AS
(
SELECT DISTINCT ON (cluster_id)
  cluster_id,
  wscode_ltree,
  localcode_ltree,
  blue_line_key,
  downstream_route_measure
FROM rearing
ORDER BY cluster_id, wscode_ltree asc, localcode_ltree asc, downstream_route_measure asc
),


-- find all rearing clusters with spawning either:
--   - upstream
--   - upstream of stream that the rearing is trib to (and rearing is within 10m of confluence)
rearing_clusters_dnstr_of_spawn AS
(
  SELECT DISTINCT s.cluster_id
  FROM cluster_minimums s
  INNER JOIN bcfishpass.streams spawn
  -- make sure there is spawning habitat either upstream
  ON FWA_Upstream(s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree, spawn.blue_line_key, spawn.downstream_route_measure, spawn.wscode_ltree, spawn.localcode_ltree)
  -- OR, if we are at/near a confluence (<10m measure), also consider stream upstream from the confluence
  OR (s.downstream_route_measure < 10 AND FWA_Upstream(subpath(s.wscode_ltree, 0, -1), s.wscode_ltree, spawn.wscode_ltree, spawn.localcode_ltree))
  WHERE spawn.spawning_model_coho IS TRUE
  AND spawn.watershed_group_code = :'wsg'
),

-- find the stream ids that we want to update
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing a
  INNER JOIN rearing_clusters_dnstr_of_spawn b
  ON a.cluster_id = b.cluster_id
)

-- set rearing as true for these streams
UPDATE bcfishpass.streams s
SET rearing_model_coho = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);



-- ----------------------------------------------
-- STEELHEAD
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cluster_id,
    s.wscode_ltree,
    s.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.discharge mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'ST'
  WHERE
    s.accessibility_model_steelhead IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    )
),

cluster_minimums AS
(
SELECT DISTINCT ON (cluster_id)
  cluster_id,
  wscode_ltree,
  localcode_ltree,
  blue_line_key,
  downstream_route_measure
FROM rearing
ORDER BY cluster_id, wscode_ltree asc, localcode_ltree asc, downstream_route_measure asc
),

-- find all rearing clusters with spawning either:
--   - upstream
--   - upstream of stream that the rearing is trib to (and rearing is within 10m of confluence)
rearing_clusters_dnstr_of_spawn AS
(
  SELECT DISTINCT s.cluster_id
  FROM cluster_minimums s
  INNER JOIN bcfishpass.streams spawn
  -- make sure there is spawning habitat either upstream
  ON FWA_Upstream(s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree, spawn.blue_line_key, spawn.downstream_route_measure, spawn.wscode_ltree, spawn.localcode_ltree)
  -- OR, if we are at/near a confluence (<10m measure), also consider stream upstream from the confluence
  OR (s.downstream_route_measure < 10 AND FWA_Upstream(subpath(s.wscode_ltree, 0, -1), s.wscode_ltree, spawn.wscode_ltree, spawn.localcode_ltree))
  WHERE spawn.spawning_model_steelhead IS TRUE
  AND spawn.watershed_group_code = :'wsg'
),

-- find the stream ids that we want to update
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing a
  INNER JOIN rearing_clusters_dnstr_of_spawn b
  ON a.cluster_id = b.cluster_id
)

-- set rearing as true for these streams
UPDATE bcfishpass.streams s
SET rearing_model_steelhead = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);


-- ----------------------------------------------
-- WESTSLOPE CUTTHROAT TROUT
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cluster_id,
    s.wscode_ltree,
    s.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.discharge mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'WCT'
  WHERE
    s.accessibility_model_wct IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    )
),

cluster_minimums AS
(
SELECT DISTINCT ON (cluster_id)
  cluster_id,
  wscode_ltree,
  localcode_ltree,
  blue_line_key,
  downstream_route_measure
FROM rearing
ORDER BY cluster_id, wscode_ltree asc, localcode_ltree asc, downstream_route_measure asc
),

-- find all rearing clusters with spawning either:
--   - upstream
--   - upstream of stream that the rearing is trib to (and rearing is within 10m of confluence)
rearing_clusters_dnstr_of_spawn AS
(
  SELECT DISTINCT s.cluster_id
  FROM cluster_minimums s
  INNER JOIN bcfishpass.streams spawn
  -- make sure there is spawning habitat either upstream
  ON FWA_Upstream(s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree, spawn.blue_line_key, spawn.downstream_route_measure, spawn.wscode_ltree, spawn.localcode_ltree)
  -- OR, if we are at/near a confluence (<10m measure), also consider stream upstream from the confluence
  OR (s.downstream_route_measure < 10 AND FWA_Upstream(subpath(s.wscode_ltree, 0, -1), s.wscode_ltree, spawn.wscode_ltree, spawn.localcode_ltree))
  WHERE spawn.spawning_model_wct IS TRUE
  AND spawn.watershed_group_code = :'wsg'
),

-- find the stream ids that we want to update
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing a
  INNER JOIN rearing_clusters_dnstr_of_spawn b
  ON a.cluster_id = b.cluster_id
)

-- set rearing as true for these streams
UPDATE bcfishpass.streams s
SET rearing_model_wct = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);