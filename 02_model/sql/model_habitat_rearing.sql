-- Because rearing habitat must be connected to spawning habitat (requiring more complex queries),
-- the rearing model is applied per species


ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_chinook boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_coho boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_steelhead boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_sockeye boolean;

-- ---------------------------------------------
-- CHINOOK
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat h
  ON h.species_code = 'CH'
  WHERE
    s.watershed_group_code IN ('BULK','LNIC') AND
    s.accessibility_model_salmon IS NOT NULL AND
    s.gradient <= h.rear_gradient_max AND
    s.channel_width <= h.rear_channel_width_max
),

-- cluster/aggregate
rearing_clusters as
(
    SELECT
      segmented_stream_id,
      ST_ClusterDBSCAN(geom, 1, 1) over() as cid,
      geom
    FROM rearing
    ORDER BY segmented_stream_id
),

-- find connected rearing segment clusters connected to spawning habitat
rearing_clusters_spawn AS
(
SELECT DISTINCT
  s1.cid,
  bool_or(s2.spawning_model_chinook) as ch
FROM rearing_clusters s1
LEFT OUTER JOIN bcfishpass.streams s2
-- join to all streams within 1m
-- (including itself, a stream could be spawning and rearing habitat,
--  without connectivity to anything else)
ON ST_DWithin(s1.geom, s2.geom, 1)
WHERE s2.spawning_model_chinook IS TRUE
GROUP BY s1.segmented_stream_id, s1.cid
),

-- and get the ids of the streams that compose the clusters connected to spawning habitat
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN rearing_clusters_spawn b
  ON a.cid = b.cid
)

-- finally, apply update based on above ids
UPDATE bcfishpass.streams s
SET rearing_model_chinook = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);

-- ----------------------------------------------
-- COHO
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat h
  ON h.species_code = 'CO'
  WHERE
    s.watershed_group_code IN ('BULK','LNIC') AND
    s.accessibility_model_salmon IS NOT NULL AND
    -- coho rearing is based on gradient/width, plus any connected wetland
    (
      s.gradient <= h.rear_gradient_max AND
      s.channel_width <= h.rear_channel_width_max OR
      s.edge_type IN (1050, 1150)
    )
),

-- cluster/aggregate
rearing_clusters as
(
    SELECT
      segmented_stream_id,
      ST_ClusterDBSCAN(geom, 1, 1) over() as cid,
      geom
    FROM rearing
    ORDER BY segmented_stream_id
),

-- find connected rearing segment clusters connected to spawning habitat
rearing_clusters_spawn AS
(
SELECT DISTINCT
  s1.cid,
  bool_or(s2.spawning_model_coho) as ch
FROM rearing_clusters s1
LEFT OUTER JOIN bcfishpass.streams s2
-- join to all streams within 1m
-- (including itself, a stream could be spawning and rearing habitat,
--  without connectivity to anything else)
ON ST_DWithin(s1.geom, s2.geom, 1)
WHERE s2.spawning_model_coho IS TRUE
GROUP BY s1.segmented_stream_id, s1.cid
),

-- and get the ids of the streams that compose the clusters connected to spawning habitat
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN rearing_clusters_spawn b
  ON a.cid = b.cid
)

-- finally, apply update based on above ids
UPDATE bcfishpass.streams s
SET rearing_model_coho = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);


-- ----------------------------------------------
-- SOCKEYE
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat h
  ON h.species_code = 'SK'
  LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lk
  ON s.waterbody_key = lk.waterbody_key
  LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly res
  ON s.waterbody_key = res.waterbody_key
  WHERE
    s.watershed_group_code IN ('BULK','LNIC') AND
    s.accessibility_model_salmon IS NOT NULL AND
    -- sockeye rear in lakes bigger than given size
     (
          lk.area_ha >= h.rear_lake_ha_min OR
          res.area_ha >= h.rear_lake_ha_min
     )
),

-- cluster/aggregate
rearing_clusters as
(
    SELECT
      segmented_stream_id,
      ST_ClusterDBSCAN(geom, 1, 1) over() as cid,
      geom
    FROM rearing
    ORDER BY segmented_stream_id
),

-- find connected rearing segment clusters connected to spawning habitat
rearing_clusters_spawn AS
(
SELECT DISTINCT
  s1.cid,
  bool_or(s2.spawning_model_sockeye) as ch
FROM rearing_clusters s1
LEFT OUTER JOIN bcfishpass.streams s2
-- join to all streams within 1m
-- (including itself, a stream could be spawning and rearing habitat,
--  without connectivity to anything else)
ON ST_DWithin(s1.geom, s2.geom, 1)
WHERE s2.spawning_model_sockeye IS TRUE
GROUP BY s1.segmented_stream_id, s1.cid
),

-- and get the ids of the streams that compose the clusters connected to spawning habitat
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN rearing_clusters_spawn b
  ON a.cid = b.cid
)

-- finally, apply update based on above ids
UPDATE bcfishpass.streams s
SET rearing_model_sockeye = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);

-- ----------------------------------------------
-- STEELHEAD
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat h
  ON h.species_code = 'ST'
  LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lk
  ON s.waterbody_key = lk.waterbody_key
  LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly res
  ON s.waterbody_key = res.waterbody_key
  WHERE
    s.watershed_group_code IN ('BULK','LNIC') AND
    s.accessibility_model_salmon IS NOT NULL AND
     (
        s.gradient <= h.rear_gradient_max AND
        s.channel_width <= h.rear_channel_width_max
     )
),

-- cluster/aggregate
rearing_clusters as
(
    SELECT
      segmented_stream_id,
      ST_ClusterDBSCAN(geom, 1, 1) over() as cid,
      geom
    FROM rearing
    ORDER BY segmented_stream_id
),

-- find connected rearing segment clusters connected to spawning habitat
rearing_clusters_spawn AS
(
SELECT DISTINCT
  s1.cid,
  bool_or(s2.spawning_model_steelhead) as ch
FROM rearing_clusters s1
LEFT OUTER JOIN bcfishpass.streams s2
-- join to all streams within 1m
-- (including itself, a stream could be spawning and rearing habitat,
--  without connectivity to anything else)
ON ST_DWithin(s1.geom, s2.geom, 1)
WHERE s2.spawning_model_steelhead IS TRUE
GROUP BY s1.segmented_stream_id, s1.cid
),

-- and get the ids of the streams that compose the clusters connected to spawning habitat
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN rearing_clusters_spawn b
  ON a.cid = b.cid
)

-- finally, apply update based on above ids
UPDATE bcfishpass.streams s
SET rearing_model_steelhead = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);

