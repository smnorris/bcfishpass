-- add modelled channel width and habitat columns to streams table
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS channel_width double precision;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_chinook boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_coho boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_steelhead boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS spawning_model_sockeye boolean;


-- apply spawning model
WITH model AS
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
      mad.mad_m3s > ch.spawn_mad_min AND
      mad.mad_m3s <= ch.spawn_mad_max AND
      s.accessibility_model_salmon IS NOT NULL
    THEN true
  END AS spawn_ch,
  CASE
    WHEN
      s.gradient <= co.spawn_gradient_max AND
      mad.mad_m3s > co.spawn_mad_min AND
      mad.mad_m3s <= co.spawn_mad_max AND
      s.accessibility_model_salmon IS NOT NULL
    THEN true
  END AS spawn_co,
  CASE
    WHEN
      s.gradient <= sk.spawn_gradient_max AND
      mad.mad_m3s > sk.spawn_mad_min AND
      mad.mad_m3s <= sk.spawn_mad_max AND
      s.accessibility_model_salmon IS NOT NULL
    THEN true
  END AS spawn_sk,
  CASE
    WHEN
      s.gradient <= st.spawn_gradient_max AND
      mad.mad_m3s > st.spawn_mad_min AND
      mad.mad_m3s <= st.spawn_mad_max AND
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
LEFT OUTER JOIN foundry.fwa_streams_mad mad
ON s.linear_feature_id = mad.linear_feature_id
WHERE s.watershed_group_code IN ('BULK','HORS')
)

UPDATE bcfishpass.streams s
SET
  spawning_model_chinook = model.spawn_ch,
  spawning_model_coho = model.spawn_co,
  spawning_model_sockeye = model.spawn_sk,
  spawning_model_steelhead = model.spawn_st
FROM model
WHERE s.segmented_stream_id = model.segmented_stream_id;