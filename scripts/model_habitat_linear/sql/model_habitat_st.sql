-- ==============================================
-- STEELHEAD HABITAT POTENTIAL MODEL
-- ==============================================

-- ----------------------------------------------
-- RESET OUTPUTS
-- ----------------------------------------------
UPDATE bcfishpass.streams s
SET model_spawning_st = NULL
WHERE model_spawning_st IS NOT NULL
AND watershed_group_code = :'wsg';

UPDATE bcfishpass.streams s
SET model_rearing_st = NULL
WHERE watershed_group_code = :'wsg'
AND model_rearing_st IS NOT NULL;

-- ----------------------------------------------
-- SPAWNING
-- ----------------------------------------------
WITH rivers AS  -- get unique river waterbodies, there are some duplicates
(
  SELECT DISTINCT waterbody_key
  FROM whse_basemapping.fwa_rivers_poly
),

model AS
(SELECT
  s.segmented_stream_id,
  s.blue_line_key,
  s.wscode_ltree,
  s.localcode_ltree,
  s.channel_width,
  s.gradient,
  s.model_access_st,
  CASE
    WHEN
      wsg.model = 'cw' AND
      s.gradient <= st.spawn_gradient_max AND
      (s.channel_width > st.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
      s.channel_width <= st.spawn_channel_width_max AND
      s.model_access_st IS NOT NULL -- note: this also ensures only wsg where st occur are included
    THEN true
    WHEN
      wsg.model = 'mad' AND
      s.gradient <= st.spawn_gradient_max AND
      s.mad_m3s > st.spawn_mad_min AND
      s.mad_m3s <= st.spawn_mad_max AND
      s.model_access_st IS NOT NULL
    THEN true
  END AS spawn_st
FROM bcfishpass.streams s
INNER JOIN bcfishpass.param_watersheds wsg
ON s.watershed_group_code = wsg.watershed_group_code
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
LEFT OUTER JOIN bcfishpass.param_habitat st
ON st.species_code = 'ST'
LEFT OUTER JOIN rivers r
ON s.waterbody_key = r.waterbody_key
WHERE (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))) -- apply to streams/rivers only
AND s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET
  model_spawning_st = model.spawn_st
FROM model
WHERE s.segmented_stream_id = model.segmented_stream_id
AND model.spawn_st is true;


-- ----------------------------------------------
-- REARING ON SPAWNING STREAMS (NO CONNECTIVITY ANALYSIS)
-- ----------------------------------------------
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'ST'
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.model_spawning_st IS TRUE AND        -- on spawning habitat
    s.model_access_st IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max AND
        -- apply minimum channel width for rearing, except for first order
        -- streams with parent order >=5)
        (s.channel_width >= h.rear_channel_width_min OR
         (s.stream_order_parent >=5 AND s.stream_order = 1)
        )
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        s.mad_m3s > h.rear_mad_min AND
        s.mad_m3s <= h.rear_mad_max
      )
    )
)

UPDATE bcfishpass.streams s
SET model_rearing_st = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing);


-- ----------------------------------------------
-- REARING DOWNSTREAM OF SPAWNING
-- Rearing streams/wetlands must be connected (to some degree) to spawning streams of the same spp
-- ----------------------------------------------
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
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'ST'
  WHERE
    s.model_access_st IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max AND
        -- apply minimum channel width for rearing, except for first order
        -- streams with parent order >=5)
        (s.channel_width >= h.rear_channel_width_min OR
         (s.stream_order_parent >=5 AND s.stream_order = 1)
        )
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        s.mad_m3s > h.rear_mad_min AND
        s.mad_m3s <= h.rear_mad_max
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
  WHERE spawn.model_spawning_st IS TRUE
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
SET model_rearing_st = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);


-- ----------------------------------------------
-- REARING UPSTREAM OF SPAWNING
-- include rearing segments if slope between the rearing/spawning does not exceed 5%
-- ----------------------------------------------
-- First, get all potential rearing based on gradient and cw/mad
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'ST'
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.model_access_st IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max AND
        -- apply minimum channel width for rearing, except for first order
        -- streams with parent order >=5)
        (s.channel_width >= h.rear_channel_width_min OR
         (s.stream_order_parent >=5 AND s.stream_order = 1)
        )
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        s.mad_m3s > h.rear_mad_min AND
        s.mad_m3s <= h.rear_mad_max
      )
    )
),

-- cluster/aggregate the rearing geoms
rearing_clusters as
(
  SELECT
    segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cid
  FROM rearing
  ORDER BY segmented_stream_id
),

rearing_minimums AS
(
SELECT DISTINCT ON (cid)
    c.cid,
    s.wscode_ltree,
    s.localcode_ltree,
    s.downstream_route_measure,
    s.blue_line_key
  FROM rearing_clusters c
  INNER JOIN bcfishpass.streams s
  ON c.segmented_stream_id = s.segmented_stream_id
  ORDER BY c.cid, s.wscode_ltree, s.localcode_ltree, s.downstream_route_measure
),

-- find everything downstream of the rearing clusters
-- this is a full downstream trace of each cluster - seemingly inefficent but it is surprisingly fast
downstream AS
(
  SELECT
    r.cid,
    s.segmented_stream_id,
    s.blue_line_key,
    s.wscode_ltree,
    s.localcode_ltree,
    s.downstream_route_measure,
    s.gradient,
    s.model_spawning_st,
    -length_metre + sum(length_metre) OVER (PARTITION BY r.cid ORDER BY s.wscode_ltree desc, s.downstream_route_measure desc) as dist_to_rear
  FROM bcfishpass.streams s
  INNER JOIN rearing_minimums r
  ON FWA_Downstream(r.blue_line_key, r.downstream_route_measure, r.wscode_ltree, r.localcode_ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
  WHERE s.blue_line_key = s.watershed_key  -- note that to keep the instream distance correct we do not include side channels in this query
  AND s.watershed_group_code = :'wsg'      -- restrict downstream trace to within watershed group
),

-- we don't have a specific threshold but lets cap the distance between rear/spawn at 10k for now
-- Create a sequential (downstream, from outlet of lake) row_number column
-- in the query result so that we can easily find streams above any 5% grade
downstream_within_10k AS
(SELECT row_number() over (PARTITION BY cid), *
 FROM downstream
 WHERE dist_to_rear < 10000
),

-- find downstream spawning closest to the cluster
nearest_spawn AS
(
  SELECT DISTINCT ON (cid)
  *
  FROM downstream_within_10k
  WHERE model_spawning_st IS TRUE
  ORDER BY cid, wscode_ltree desc, downstream_route_measure desc
),

-- find downsream slope > 5pct closest to cluster
nearest_5pct AS
(
  SELECT DISTINCT ON (cid)
  *
  FROM downstream_within_10k
  WHERE gradient >= .05
  ORDER BY cid, wscode_ltree desc, downstream_route_measure desc
),

-- find all clusters that have spawn downstream within tolerance and no 5pct or bigger grade between cluster and spawn
valid_rearing AS
(
  SELECT
    a.cid,
    a.row_number as row_spawn,
    a.model_spawning_st,
    b.row_number as row_barrier,
    b.gradient
  FROM nearest_spawn a
  LEFT OUTER JOIN nearest_5pct b
  ON a.cid = b.cid
  WHERE b.row_number IS NULL OR b.row_number > a.row_number
)

UPDATE bcfishpass.streams
SET model_rearing_st = TRUE
WHERE segmented_stream_id IN
(
  SELECT a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN valid_rearing b
  ON a.cid = b.cid
);
