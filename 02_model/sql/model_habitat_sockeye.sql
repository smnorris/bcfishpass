-- Sockeye rearing is simply all lakes >2km2, spawning is in adjacent streams

ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_sockeye boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_sockeye boolean;

-- rearing
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


-- spawning
