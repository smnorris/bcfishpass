-- ==============================================
-- WESTSLOPE CUTTHROAT TROUT HABITAT POTENTIAL MODEL 
-- ==============================================

-- ----------------------------------------------
-- SPAWNING
-- ----------------------------------------------
WITH rivers AS  -- get unique river waterbodies, there are some duplicates
(
  SELECT DISTINCT waterbody_key
  FROM whse_basemapping.fwa_rivers_poly
),

model AS (
  SELECT
    s.segmented_stream_id,
    s.blue_line_key,
    s.wscode_ltree,
    s.localcode_ltree,
    cw.channel_width,
    s.gradient,
    CASE
      WHEN
        wsg.model = 'cw' AND
        s.gradient <= t.spawn_gradient_max AND
        (cw.channel_width > t.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
        cw.channel_width <= t.spawn_channel_width_max AND
        av.barriers_wct_dnstr = array[]::text[]
      THEN true
      WHEN
        wsg.model = 'mad' AND
        s.gradient <= t.spawn_gradient_max AND
        mad.mad_m3s > t.spawn_mad_min AND
        mad.mad_m3s <= t.spawn_mad_max AND
        av.barriers_wct_dnstr IS NOT NULL
      THEN true
    END AS spawning
  FROM bcfishpass.streams s
  inner join bcfishpass.streams_access_vw av on s.segmented_stream_id = av.segmented_stream_id
  LEFT OUTER JOIN bcfishpass.discharge mad ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.channel_width cw ON s.linear_feature_id = cw.linear_feature_id
  INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'WCT'
  INNER JOIN bcfishpass.wsg_species_presence p ON s.watershed_group_code = p.watershed_group_code
  LEFT OUTER JOIN rivers r ON s.waterbody_key = r.waterbody_key
  WHERE
    p.wct is true AND
    s.watershed_group_code = :'wsg' AND
    -- streams and rivers only
    (
      wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))
    )
)

insert into bcfishpass.habitat_linear_wct
(segmented_stream_id, spawning)
select
  segmented_stream_id,
  spawning
FROM model
where spawning is true;


-- ----------------------------------------------
-- REARING ON SPAWNING STREAMS (NO CONNECTIVITY ANALYSIS)
-- ----------------------------------------------
INSERT INTO bcfishpass.habitat_linear_wct (
  segmented_stream_id,
  rearing
)
SELECT
  s.segmented_stream_id,
  true as rearing
FROM bcfishpass.streams s
-- ensure stream is modelled as spawning and accessible
INNER JOIN bcfishpass.habitat_linear_wct h on s.segmented_stream_id = h.segmented_stream_id
LEFT OUTER JOIN bcfishpass.discharge mad ON s.linear_feature_id = mad.linear_feature_id
LEFT OUTER JOIN bcfishpass.channel_width cw ON s.linear_feature_id = cw.linear_feature_id
INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'WCT'
WHERE
  s.watershed_group_code = :'wsg' AND
  s.gradient <= t.rear_gradient_max AND         -- gradient check
  (
    wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
    (
      wb.waterbody_type IS NULL AND
      s.edge_type IN (1000,1100,2000,2300)
    )
  ) AND

  (
    ( -- channel width based model
      wsg.model = 'cw' AND
      cw.channel_width <= t.rear_channel_width_max AND
      -- apply minimum channel width for rearing, except for first order
      -- streams with parent order >=5)
      (cw.channel_width >= t.rear_channel_width_min OR
       (s.stream_order_parent >= 5 AND s.stream_order = 1)
      )
    )
  OR
    ( -- discharge based model
      wsg.model = 'mad' AND
      mad.mad_m3s > t.rear_mad_min AND
      mad.mad_m3s <= t.rear_mad_max
    )
  )
on conflict (segmented_stream_id)
do update set rearing = EXCLUDED.rearing;


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
  inner join bcfishpass.streams_access_vw av on s.segmented_stream_id = av.segmented_stream_id
  LEFT OUTER JOIN bcfishpass.discharge mad ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.channel_width cw ON s.linear_feature_id = cw.linear_feature_id
  INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'WCT'
  WHERE
    av.barriers_wct_dnstr = array[]::text[] AND  -- accessibility check
    s.gradient <= t.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        cw.channel_width <= t.rear_channel_width_max AND
        -- apply minimum channel width for rearing, except for first order
        -- streams with parent order >=5)
        (cw.channel_width >= t.rear_channel_width_min OR
         (s.stream_order_parent >=5 AND s.stream_order = 1)
        )
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > t.rear_mad_min AND
        mad.mad_m3s <= t.rear_mad_max
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
rearing_clusters_dnstr_of_spawn AS materialized
(
  SELECT DISTINCT s.cluster_id
  FROM cluster_minimums s
  INNER JOIN bcfishpass.streams st
  -- make sure there is spawning habitat either upstream
  ON FWA_Upstream(s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree, st.blue_line_key, st.downstream_route_measure, st.wscode_ltree, st.localcode_ltree)
  -- OR, if we are at/near a confluence (<10m measure), also consider stream upstream from the confluence
  OR (s.downstream_route_measure < 10 AND FWA_Upstream(subpath(s.wscode_ltree, 0, -1), s.wscode_ltree, st.wscode_ltree, st.localcode_ltree))
  INNER JOIN bcfishpass.habitat_linear_wct h on st.segmented_stream_id = h.segmented_stream_id
  WHERE h.spawning IS TRUE
  AND st.watershed_group_code = :'wsg'
)

-- upsert the rearing downstream of spawning clusters
INSERT INTO bcfishpass.habitat_linear_wct (
  segmented_stream_id,
  rearing
)
SELECT
  a.segmented_stream_id,
  true as rearing
FROM rearing a
INNER JOIN rearing_clusters_dnstr_of_spawn b
ON a.cluster_id = b.cluster_id
on conflict (segmented_stream_id)
do update set rearing = EXCLUDED.rearing;


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
  inner join bcfishpass.streams_access_vw av on s.segmented_stream_id = av.segmented_stream_id
  LEFT OUTER JOIN bcfishpass.discharge mad ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.channel_width cw ON s.linear_feature_id = cw.linear_feature_id
  INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'WCT'
  WHERE
    s.watershed_group_code = :'wsg' AND
    av.barriers_wct_dnstr = array[]::text[] AND  -- accessibility check
    s.gradient <= t.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        cw.channel_width <= t.rear_channel_width_max AND
        -- apply minimum channel width for rearing, except for first order
        -- streams with parent order >=5)
        (cw.channel_width >= t.rear_channel_width_min OR
         (s.stream_order_parent >=5 AND s.stream_order = 1)
        )
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > t.rear_mad_min AND
        mad.mad_m3s <= t.rear_mad_max
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
    h.spawning,
    -length_metre + sum(length_metre) OVER (PARTITION BY r.cid ORDER BY s.wscode_ltree desc, s.downstream_route_measure desc) as dist_to_rear
  FROM bcfishpass.streams s
  INNER JOIN rearing_minimums r
  ON FWA_Downstream(r.blue_line_key, r.downstream_route_measure, r.wscode_ltree, r.localcode_ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
  LEFT OUTER JOIN bcfishpass.habitat_linear_wct h ON s.segmented_stream_id = h.segmented_stream_id
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
  WHERE spawning IS TRUE
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
    a.spawning,
    b.row_number as row_barrier,
    b.gradient
  FROM nearest_spawn a
  LEFT OUTER JOIN nearest_5pct b
  ON a.cid = b.cid
  WHERE b.row_number IS NULL OR b.row_number > a.row_number
)

-- upsert the rearing
INSERT INTO bcfishpass.habitat_linear_wct (
  segmented_stream_id,
  rearing
)
SELECT
   a.segmented_stream_id,
   true as rearing
FROM rearing_clusters a
INNER JOIN valid_rearing b
ON a.cid = b.cid
on conflict (segmented_stream_id)
do update set rearing = EXCLUDED.rearing;