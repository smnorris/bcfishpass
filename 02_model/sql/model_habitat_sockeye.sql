-- Sockeye rearing is simply all lakes >2km2, spawning is in adjacent streams

ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_sockeye boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_sockeye boolean;

-- ---------------------
-- rearing
-- ---------------------
WITH rearing AS
(
  SELECT
    s.segmented_stream_id
  FROM bcfishpass.streams s
  LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat h
  ON h.species_code = 'SK'
  LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lk
  ON s.waterbody_key = lk.waterbody_key
  LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly res
  ON s.waterbody_key = res.waterbody_key
  WHERE
    s.accessibility_model_salmon IS NOT NULL AND  -- this takes care of watershed selection as well
     (
          lk.area_ha >= h.rear_lake_ha_min OR  -- lakes
          res.area_ha >= h.rear_lake_ha_min    -- reservoirs
     )
)

UPDATE bcfishpass.streams s
SET rearing_model_sockeye = TRUE
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
  WHERE rearing_model_sockeye = True
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
    b.row_number
  FROM downstream_within_3k a
  LEFT OUTER JOIN too_steep b
  ON a.waterbody_key = b.waterbody_key
  WHERE b.waterbody_key IS NULL OR a.row_number < b.row_number
)

UPDATE bcfishpass.streams
SET spawning_model_sockeye = TRUE
WHERE segmented_stream_id IN (SELECT DISTINCT segmented_stream_id FROM dnstr_spawning);