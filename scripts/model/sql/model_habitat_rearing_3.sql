-- Validate rearing upstream of spawning:
-- include rearing segments if slope between the rearing/spawning does not exceed 5%

-- ----------------------------------
-- CHINOOK
-- ----------------------------------
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
  ON h.species_code = 'CH'
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.access_model_salmon IS NOT NULL AND  -- accessibility check
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
    s.spawning_model_ch,
    -length_metre + sum(length_metre) OVER (PARTITION BY r.cid ORDER BY s.wscode_ltree desc, s.downstream_route_measure desc) as dist_to_rear
  FROM bcfishpass.streams s
  INNER JOIN rearing_minimums r
  ON FWA_Downstream(r.blue_line_key, r.downstream_route_measure, r.wscode_ltree, r.localcode_ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
  WHERE s.blue_line_key = s.watershed_key  -- note that to keep the instream distance correct we do not include side channels in this query
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
  WHERE spawning_model_ch IS TRUE
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
    a.spawning_model_ch,
    b.row_number as row_barrier,
    b.gradient
  FROM nearest_spawn a
  LEFT OUTER JOIN nearest_5pct b
  ON a.cid = b.cid
  WHERE b.row_number IS NULL OR b.row_number > a.row_number
)

UPDATE bcfishpass.streams
SET rearing_model_ch = TRUE
WHERE segmented_stream_id IN
(
  SELECT a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN valid_rearing b
  ON a.cid = b.cid
);


-- ----------------------------------
-- COHO
-- ----------------------------------
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
  ON h.species_code = 'CO'
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.access_model_salmon IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers/wetlands
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300,1050,1150) -- note inclusion of wetlands
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
        s.mad_m3s > h.rear_mad_min AND
        s.mad_m3s <= h.rear_mad_max
      )
    OR s.edge_type IN (1050, 1150)  -- any wetlands are potential rearing
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
    s.spawning_model_co,
    -length_metre + sum(length_metre) OVER (PARTITION BY r.cid ORDER BY s.wscode_ltree desc, s.downstream_route_measure desc) as dist_to_rear
  FROM bcfishpass.streams s
  INNER JOIN rearing_minimums r
  ON FWA_Downstream(r.blue_line_key, r.downstream_route_measure, r.wscode_ltree, r.localcode_ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
  WHERE s.blue_line_key = s.watershed_key  -- note that to keep the instream distance correct we do not include side channels in this query
),

-- we don't have a specific threshold but lets cap the distance between rear/spawn at 10k for now
-- Create a sequential (downstream of cluster) row_number column
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
  WHERE spawning_model_co IS TRUE
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
    a.spawning_model_co,
    b.row_number as row_barrier,
    b.gradient
  FROM nearest_spawn a
  LEFT OUTER JOIN nearest_5pct b
  ON a.cid = b.cid
  WHERE b.row_number IS NULL OR b.row_number > a.row_number
)

UPDATE bcfishpass.streams
SET rearing_model_co = TRUE
WHERE segmented_stream_id IN
(
  SELECT a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN valid_rearing b
  ON a.cid = b.cid
);

-- ----------------------------------
-- STEELHEAD
-- ----------------------------------
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
    s.access_model_st IS NOT NULL AND  -- accessibility check
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
    s.spawning_model_st,
    -length_metre + sum(length_metre) OVER (PARTITION BY r.cid ORDER BY s.wscode_ltree desc, s.downstream_route_measure desc) as dist_to_rear
  FROM bcfishpass.streams s
  INNER JOIN rearing_minimums r
  ON FWA_Downstream(r.blue_line_key, r.downstream_route_measure, r.wscode_ltree, r.localcode_ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
  WHERE s.blue_line_key = s.watershed_key  -- note that to keep the instream distance correct we do not include side channels in this query
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
  WHERE spawning_model_st IS TRUE
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
    a.spawning_model_st,
    b.row_number as row_barrier,
    b.gradient
  FROM nearest_spawn a
  LEFT OUTER JOIN nearest_5pct b
  ON a.cid = b.cid
  WHERE b.row_number IS NULL OR b.row_number > a.row_number
)

UPDATE bcfishpass.streams
SET rearing_model_st = TRUE
WHERE segmented_stream_id IN
(
  SELECT a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN valid_rearing b
  ON a.cid = b.cid
);


-- ----------------------------------
-- WESTSLOPE CUTTHROAT TROUT
-- ----------------------------------
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
  ON h.species_code = 'WCT'
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.access_model_wct IS NOT NULL AND  -- accessibility check
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
    s.spawning_model_wct,
    -length_metre + sum(length_metre) OVER (PARTITION BY r.cid ORDER BY s.wscode_ltree desc, s.downstream_route_measure desc) as dist_to_rear
  FROM bcfishpass.streams s
  INNER JOIN rearing_minimums r
  ON FWA_Downstream(r.blue_line_key, r.downstream_route_measure, r.wscode_ltree, r.localcode_ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
  WHERE s.blue_line_key = s.watershed_key  -- note that to keep the instream distance correct we do not include side channels in this query
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
  WHERE spawning_model_wct IS TRUE
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
    a.spawning_model_wct,
    b.row_number as row_barrier,
    b.gradient
  FROM nearest_spawn a
  LEFT OUTER JOIN nearest_5pct b
  ON a.cid = b.cid
  WHERE b.row_number IS NULL OR b.row_number > a.row_number
)

UPDATE bcfishpass.streams
SET rearing_model_wct = TRUE
WHERE segmented_stream_id IN
(
  SELECT a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN valid_rearing b
  ON a.cid = b.cid
);