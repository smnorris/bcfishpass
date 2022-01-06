-- Sockeye rearing is simply all lakes >2km2, spawning is in adjacent streams

-- reset
UPDATE bcfishpass.streams s
SET spawning_model_sk = NULL,
WHERE spawning_model_sk IS NOT NULL,
AND watershed_group_code = :'wsg';

UPDATE bcfishpass.streams s
SET rearing_model_sk = NULL,
WHERE rearing_model_sk IS NOT NULL,
AND watershed_group_code = :'wsg';



-- ---------------------
-- rearing
-- ---------------------
WITH rearing AS
(
  SELECT
    s.segmented_stream_id
  FROM bcfishpass.streams s
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'SK'
  LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lk
  ON s.waterbody_key = lk.waterbody_key
  LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly res
  ON s.waterbody_key = res.waterbody_key
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.access_model_ch_co_sk IS NOT NULL AND  -- this takes care of watershed selection as well
     (
          lk.area_ha >= h.rear_lake_ha_min OR  -- lakes
          res.area_ha >= h.rear_lake_ha_min    -- reservoirs
     )
)

UPDATE bcfishpass.streams s
SET rearing_model_sk = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing);

-- ---------------------
-- spawning, downstream
-- ---------------------
-- find outlets of the rearing lakes
WITH rearing_minimums AS
(
  SELECT DISTINCT ON (waterbody_key)
    s.waterbody_key,
    s.wscode_ltree,
    s.localcode_ltree,
    s.downstream_route_measure,
    s.blue_line_key
  FROM bcfishpass.streams s
  WHERE rearing_model_sk = True
  AND s.watershed_group_code = :'wsg'
  ORDER BY s.waterbody_key, s.wscode_ltree, s.localcode_ltree, s.downstream_route_measure
),

-- find everything downstream of the rearing lake outlets
downstream AS
(
  SELECT
    r.waterbody_key,
    s.segmented_stream_id,
    s.blue_line_key,
    s.wscode_ltree,
    s.localcode_ltree,
    s.downstream_route_measure,
    s.gradient,
    -length_metre + sum(length_metre) OVER (PARTITION BY r.waterbody_key ORDER BY s.wscode_ltree desc, s.downstream_route_measure desc) as dist_to_lake
    FROM bcfishpass.streams s
  INNER JOIN rearing_minimums r
  ON FWA_Downstream(r.blue_line_key, r.downstream_route_measure, r.wscode_ltree, r.localcode_ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
  WHERE s.blue_line_key = s.watershed_key  -- note that to keep the instream distance to lake correct we do not include side channels in this query
  AND s.watershed_group_code = :'wsg'
),

-- we only want records within 3km of the rearing lakes,
-- create a sequential (downstream, from outlet of lake) row_number column
-- in the query result so that we can easily find streams above any 5% grade
downstream_within_3k AS
(SELECT row_number() over (PARTITION BY waterbody_key), *
 FROM downstream
 WHERE dist_to_lake < 3000
),

-- extract from above the segments that are too steep, acting as barriers
too_steep AS
(
  SELECT DISTINCT ON (waterbody_key)
  *
  FROM downstream_within_3k
  WHERE gradient > .05
  ORDER BY waterbody_key, row_number
),

-- Now find only segments that are upstream of the too_steep records
-- (or have no upstream too_streep records) by comparing the generated
-- row_number column -> these are the spawning lines
dnstr_spawning AS
(
  SELECT
    a.*,
    b.waterbody_key,
    b.row_number,
    CASE
      WHEN
        wsg.model = 'cw' AND
        s.gradient <= sk.spawn_gradient_max AND
        s.channel_width > sk.spawn_channel_width_min AND
        (s.channel_width > sk.spawn_channel_width_min) AND  -- double line riv do not default to spawn cw
        s.channel_width <= sk.spawn_channel_width_max
      THEN true
      WHEN
        wsg.model = 'mad' AND
        s.gradient <= sk.spawn_gradient_max AND
        s.mad_m3s > sk.spawn_mad_min AND
        s.mad_m3s <= sk.spawn_mad_max
      THEN true
  END AS spawn_sk
  FROM downstream_within_3k a
  LEFT OUTER JOIN too_steep b
  ON a.waterbody_key = b.waterbody_key
  INNER JOIN bcfishpass.streams s
  ON a.segmented_stream_id = s.segmented_stream_id
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN bcfishpass.param_habitat sk
  ON sk.species_code = 'SK'
  WHERE b.waterbody_key IS NULL OR a.row_number < b.row_number
)

UPDATE bcfishpass.streams
SET spawning_model_sk = TRUE
WHERE segmented_stream_id IN (SELECT DISTINCT segmented_stream_id FROM dnstr_spawning WHERE spawn_sk IS TRUE);


-- ---------------------
-- spawning, upstream
-- ---------------------

WITH spawn AS
(
  SELECT
    s.segmented_stream_id,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN bcfishpass.param_habitat sk
  ON sk.species_code = 'SK'
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  WHERE
  s.watershed_group_code = :'wsg' AND

  ((
    wsg.model = 'cw' AND
    s.gradient <= sk.spawn_gradient_max AND
    s.channel_width > sk.spawn_channel_width_min AND
    (s.channel_width > sk.spawn_channel_width_min) AND  -- double line riv do not default to spawn cw
    s.channel_width <= sk.spawn_channel_width_max
  ) OR
  (
    wsg.model = 'mad' AND
    s.gradient <= sk.spawn_gradient_max AND
    s.mad_m3s > sk.spawn_mad_min AND
    s.mad_m3s <= sk.spawn_mad_max
  ))

  AND
  (wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
    (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))
  )
),

-- find spawn upstream of rearing
spawn_upstream AS
(
  SELECT DISTINCT
    sp.*
  FROM spawn sp
  INNER JOIN bcfishpass.streams r
  ON FWA_Upstream(
    r.blue_line_key,
    r.downstream_route_measure,
    r.wscode_ltree,
    r.localcode_ltree,
    sp.blue_line_key,
    sp.downstream_route_measure,
    sp.wscode_ltree,
    sp.localcode_ltree
  )
  WHERE r.rearing_model_sk IS TRUE
  AND r.watershed_group_code = :'wsg'
),

-- cluster the spawning
clusters as
(
  SELECT
    segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cid,
    geom
  FROM spawn_upstream
  ORDER BY segmented_stream_id
),

-- get waterbody keys of rearing lakes/reservoirs
wb AS
(
  SELECT DISTINCT waterbody_key
  FROM bcfishpass.streams
  WHERE rearing_model_sk IS TRUE
),

-- and geoms of the lakes/reservoirs
wb_geom AS
(
  SELECT
    waterbody_key,
    geom
  FROM whse_basemapping.fwa_lakes_poly l
  WHERE waterbody_key IN (SELECT waterbody_key from wb)
  UNION ALL
  SELECT
    waterbody_key,
    geom
  FROM whse_basemapping.fwa_manmade_waterbodies_poly l
  WHERE waterbody_key IN (SELECT waterbody_key from wb)
),

-- find all spawning clusters adjacent to lake (give or take a metre or so)
clusters_near_rearing AS
(
  SELECT DISTINCT
    s1.cid,
    bool_or(l.waterbody_key IS NOT NULL) as wb
  FROM clusters s1
  LEFT OUTER JOIN wb_geom l
  ON ST_DWithin(s1.geom, l.geom, 2)
  GROUP BY s1.cid
),

-- and get the ids of the streams that compose the clusters connected to lakes
ids AS
(
  SELECT
    b.segmented_stream_id
  FROM clusters_near_rearing a
  INNER JOIN clusters b
  ON a.cid = b.cid
  WHERE a.wb IS TRUE
)

-- finally, apply update based on above ids
UPDATE bcfishpass.streams s
SET spawning_model_sk = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM ids);
