-- add modelled channel width and habitat columns to streams table
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS channel_width double precision;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_chinook boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_coho boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_steelhead boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_sockeye boolean;

ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_chinook boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_coho boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_steelhead boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_sockeye boolean;

-- populate channel width from the measured/modelled data
WITH cw AS
(SELECT DISTINCT
  s.linear_feature_id,
  CASE
    WHEN w.channel_width_measured IS NOT NULL THEN w.channel_width_measured
    ELSE w.channel_width_modelled
  END AS channel_width
FROM bcfishpass.channel_width w
INNER JOIN bcfishpass.streams s
ON s.wscode_ltree = w.wscode_ltree
AND s.localcode_ltree = w.localcode_ltree
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
-- only apply channel width to rivers and streams
WHERE wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))
)

UPDATE bcfishpass.streams s
SET
  channel_width = cw.channel_width
FROM cw
WHERE s.linear_feature_id = cw.linear_feature_id;

-- apply salmon spawning model
WITH model AS
(SELECT
  s.segmented_stream_id,
  s.blue_line_key,
  s.wscode_ltree,
  s.localcode_ltree,
  s.channel_width,
  s.gradient,
  s.accessibility_model_salmon,
  CASE
    WHEN
      s.gradient <= ch.spawn_gradient_max AND
      s.channel_width > ch.spawn_channel_width_min AND
      s.channel_width <= ch.spawn_channel_width_max
    THEN true
    ELSE false
  END AS spawn_ch,
  CASE
    WHEN
      s.gradient <= ch.rear_gradient_max AND
      s.channel_width <= ch.rear_channel_width_max
    THEN true
    ELSE false
  END AS rear_ch,
  CASE
    WHEN
      s.gradient <= co.spawn_gradient_max AND
      s.channel_width > co.spawn_channel_width_min AND
      s.channel_width <= co.spawn_channel_width_max
    THEN true
    ELSE false
  END AS spawn_co,
  CASE
    WHEN
      s.gradient <= co.rear_gradient_max AND
      s.channel_width <= co.rear_channel_width_max
    THEN true
    ELSE false
  END AS rear_co,
    CASE
    WHEN
      s.gradient <= sk.spawn_gradient_max AND
      s.channel_width > sk.spawn_channel_width_min AND
      s.channel_width <= sk.spawn_channel_width_max
    THEN true
    ELSE false
  END AS spawn_sk,
  -- sockeye rearing model is different, simply locate lakes above size threshold
  CASE
    WHEN lk.area_ha >= sk.rear_lake_ha_min OR res.area_ha >= sk.rear_lake_ha_min
    THEN true
    ELSE false
  END AS rear_sk
FROM bcfishpass.streams s
LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat ch
ON ch.species_code = 'CH'
LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat co
ON co.species_code = 'CO'
LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat sk
ON sk.species_code = 'SK'
LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lk
ON s.waterbody_key = lk.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly res
ON s.waterbody_key = res.waterbody_key
WHERE s.watershed_group_code = 'BULK'
AND s.accessibility_model_salmon IS NOT NULL
)

UPDATE bcfishpass.streams s
SET
  spawning_model_chinook = model.spawn_ch,
  rearing_model_chinook = model.rear_ch,
  spawning_model_coho = model.spawn_co,
  rearing_model_coho = model.rear_co,
  spawning_model_sockeye = model.spawn_sk,
  rearing_model_sockeye = model.rear_sk
FROM model
WHERE s.segmented_stream_id = model.segmented_stream_id;



-- apply steelhead model
WITH model AS
(SELECT
  s.segmented_stream_id,
  s.blue_line_key,
  s.wscode_ltree,
  s.localcode_ltree,
  s.channel_width,
  s.gradient,
  s.accessibility_model_steelhead,
CASE
    WHEN
      s.gradient <= st.spawn_gradient_max AND
      s.channel_width > st.spawn_channel_width_min AND
      s.channel_width <= st.spawn_channel_width_max
    THEN true
    ELSE false
  END AS spawn_st,
  CASE
    WHEN
      s.gradient <= st.rear_gradient_max AND
      s.channel_width <= st.rear_channel_width_max
    THEN true
    ELSE false
  END AS rear_st
FROM bcfishpass.streams s
LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat st
ON st.species_code = 'ST'
LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lk
ON s.waterbody_key = lk.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly res
ON s.waterbody_key = res.waterbody_key
WHERE s.watershed_group_code = 'BULK'
AND s.accessibility_model_steelhead IS NOT NULL
)

UPDATE bcfishpass.streams s
SET
  spawning_model_steelhead = model.spawn_st,
  rearing_model_steelhead = model.rear_st
FROM model
WHERE s.segmented_stream_id = model.segmented_stream_id;

