-- apply ch/co/st/wct spawning models

-- first, reset everything to NULL
UPDATE bcfishpass.streams s
SET spawning_model_ch = NULL
WHERE spawning_model_ch IS NOT NULL
AND watershed_group_code = :'wsg';

UPDATE bcfishpass.streams s
SET spawning_model_co = NULL
WHERE spawning_model_co IS NOT NULL
AND watershed_group_code = :'wsg';

UPDATE bcfishpass.streams s
SET spawning_model_st = NULL
WHERE spawning_model_st IS NOT NULL
AND watershed_group_code = :'wsg';

UPDATE bcfishpass.streams s
SET spawning_model_wct = NULL
WHERE spawning_model_wct IS NOT NULL
AND watershed_group_code = :'wsg';

-- then do the calculation
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
  s.access_model_ch_co_sk,
  s.access_model_st,
  CASE
    WHEN
      wsg.model = 'cw' AND
      s.gradient <= ch.spawn_gradient_max AND
      (s.channel_width > ch.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
      s.channel_width <= ch.spawn_channel_width_max AND
      s.access_model_ch_co_sk IS NOT NULL  -- note: this also ensures only wsg where ch occur are included
    THEN true
    WHEN wsg.model = 'mad' AND
      s.gradient <= ch.spawn_gradient_max AND
      s.mad_m3s > ch.spawn_mad_min AND
      s.mad_m3s <= ch.spawn_mad_max AND
      s.access_model_ch_co_sk IS NOT NULL
    THEN true
  END AS spawn_ch,
  CASE
    WHEN
      wsg.model = 'cw' AND
      s.gradient <= co.spawn_gradient_max AND
      (s.channel_width > co.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
      s.channel_width <= co.spawn_channel_width_max AND
      s.access_model_ch_co_sk IS NOT NULL -- note: this also ensures only wsg where co occur are included
    THEN true
    WHEN wsg.model = 'mad' AND
      s.gradient <= co.spawn_gradient_max AND
      s.mad_m3s > co.spawn_mad_min AND
      s.mad_m3s <= co.spawn_mad_max AND
      s.access_model_ch_co_sk IS NOT NULL
    THEN true
  END AS spawn_co,
  CASE
    WHEN
      wsg.model = 'cw' AND
      s.gradient <= st.spawn_gradient_max AND
      (s.channel_width > st.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
      s.channel_width <= st.spawn_channel_width_max AND
      s.access_model_st IS NOT NULL -- note: this also ensures only wsg where st occur are included
    THEN true
    WHEN
      wsg.model = 'mad' AND
      s.gradient <= st.spawn_gradient_max AND
      s.mad_m3s > st.spawn_mad_min AND
      s.mad_m3s <= st.spawn_mad_max AND
      s.access_model_st IS NOT NULL
    THEN true
  END AS spawn_st,
  CASE
    WHEN
      wsg.model = 'cw' AND
      s.gradient <= wct.spawn_gradient_max AND
      (s.channel_width > wct.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
      s.channel_width <= wct.spawn_channel_width_max AND
      s.access_model_wct IS NOT NULL -- note: this also ensures only wsg where wct occur are included
    THEN true
    WHEN
      wsg.model = 'mad' AND
      s.gradient <= wct.spawn_gradient_max AND
      s.mad_m3s > wct.spawn_mad_min AND
      s.mad_m3s <= wct.spawn_mad_max AND
      s.access_model_wct IS NOT NULL
    THEN true
  END AS spawn_wct
FROM bcfishpass.streams s
INNER JOIN bcfishpass.param_watersheds wsg
ON s.watershed_group_code = wsg.watershed_group_code
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
LEFT OUTER JOIN bcfishpass.param_habitat ch
ON ch.species_code = 'CH'
LEFT OUTER JOIN bcfishpass.param_habitat co
ON co.species_code = 'CO'
LEFT OUTER JOIN bcfishpass.param_habitat st
ON st.species_code = 'ST'
LEFT OUTER JOIN bcfishpass.param_habitat wct
ON wct.species_code = 'WCT'
LEFT OUTER JOIN rivers r
ON s.waterbody_key = r.waterbody_key
WHERE wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)) -- apply to streams/rivers only
AND s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET
  spawning_model_ch = model.spawn_ch,
  spawning_model_co = model.spawn_co,
  spawning_model_st = model.spawn_st,
  spawning_model_wct = model.spawn_wct
FROM model
WHERE s.segmented_stream_id = model.segmented_stream_id;