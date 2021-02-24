-- add modelled channel width and habitat columns to streams table
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS channel_width double precision;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_chinook boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_coho boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_steelhead boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_sockeye boolean;

-- populate channel width from the measured/modelled data
WITH cw AS
(SELECT DISTINCT
  s.wscode_ltree,
  s.localcode_ltree,
  s.linear_feature_id,
  COALESCE(cw1.channel_width_measured, cw2.channel_width_modelled) as channel_width,
  s.edge_type
FROM bcfishpass.streams s
LEFT OUTER JOIN bcfishpass.channel_width_measured cw1
ON s.wscode_ltree = cw1.wscode_ltree
AND s.localcode_ltree = cw1.localcode_ltree
LEFT OUTER JOIN bcfishpass.channel_width_modelled cw2
ON s.wscode_ltree = cw2.wscode_ltree
AND s.localcode_ltree = cw2.localcode_ltree
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
WHERE
-- only watersheds where we have a model
s.watershed_group_code in ('BULK','LNIC','HORS')
-- don't model channel width on first order streams
AND s.stream_order > 1
-- only apply channel width to rivers and streams
AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
)

UPDATE bcfishpass.streams s
SET
  channel_width = cw.channel_width
FROM cw
WHERE s.linear_feature_id = cw.linear_feature_id;

-- apply spawning model
WITH rivers AS  -- get unique river waterbody keys, there is a handful of duplicates
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
  s.accessibility_model_salmon,
  s.accessibility_model_steelhead,
  CASE
    WHEN
      s.gradient <= ch.spawn_gradient_max AND
      (s.channel_width > ch.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
      s.channel_width <= ch.spawn_channel_width_max AND
      s.accessibility_model_salmon IS NOT NULL
    THEN true
  END AS spawn_ch,
  CASE
    WHEN
      s.gradient <= co.spawn_gradient_max AND
      (s.channel_width > co.spawn_channel_width_min  OR r.waterbody_key IS NOT NULL) AND
      s.channel_width <= co.spawn_channel_width_max AND
      s.accessibility_model_salmon IS NOT NULL
    THEN true
  END AS spawn_co,
  CASE
    WHEN
      s.gradient <= sk.spawn_gradient_max AND
      (s.channel_width > sk.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
      s.channel_width <= sk.spawn_channel_width_max AND
      s.accessibility_model_salmon IS NOT NULL
    THEN true
  END AS spawn_sk,
  CASE
    WHEN
      s.gradient <= st.spawn_gradient_max AND
      (s.channel_width > st.spawn_channel_width_min  OR r.waterbody_key IS NOT NULL) AND
      s.channel_width <= st.spawn_channel_width_max AND
      s.accessibility_model_steelhead IS NOT NULL
    THEN true
  END AS spawn_st
FROM bcfishpass.streams s
LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat ch
ON ch.species_code = 'CH'
LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat co
ON co.species_code = 'CO'
LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat sk
ON sk.species_code = 'SK'
LEFT OUTER JOIN bcfishpass.model_spawning_rearing_habitat st
ON st.species_code = 'ST'
LEFT OUTER JOIN rivers r
ON s.waterbody_key = r.waterbody_key
WHERE s.watershed_group_code IN ('LNIC')  -- MAD model in BULK/HORS for now
)

UPDATE bcfishpass.streams s
SET
  spawning_model_chinook = model.spawn_ch,
  spawning_model_coho = model.spawn_co,
  spawning_model_sockeye = model.spawn_sk,
  spawning_model_steelhead = model.spawn_st
FROM model
WHERE s.segmented_stream_id = model.segmented_stream_id;