-- ==============================================
-- PINK HABITAT POTENTIAL MODEL 
-- ==============================================

-- ----------------------------------------------
-- RESET OUTPUTS
-- ----------------------------------------------
UPDATE bcfishpass.streams s
SET model_spawning_pk = NULL
WHERE model_spawning_pk IS NOT NULL
AND watershed_group_code = :'wsg';


-- ----------------------------------------------
-- SPAWNING
-- ----------------------------------------------
WITH rivers AS  -- get unique river waterbodies, there are some duplicates
(
  SELECT DISTINCT waterbody_key
  FROM whse_basemapping.fwa_rivers_poly
),

model AS
(
  SELECT
    s.segmented_stream_id,
    s.blue_line_key,
    s.wscode_ltree,
    s.localcode_ltree,
    s.channel_width,
    s.gradient,
    s.model_access_ch_co_sk,
    CASE
      WHEN
        wsg.model = 'cw' AND
        s.gradient <= pk.spawn_gradient_max AND
        (s.channel_width > pk.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
        s.channel_width <= pk.spawn_channel_width_max AND
        s.model_access_ch_co_sk IS NOT NULL  -- note: this also ensures only wsg where pk occur are included
      THEN true
      WHEN wsg.model = 'mad' AND
        s.gradient <= pk.spawn_gradient_max AND
        s.mad_m3s > pk.spawn_mad_min AND
        s.mad_m3s <= pk.spawn_mad_max AND
        s.model_access_ch_co_sk IS NOT NULL
      THEN true
    END AS spawn_pk
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.param_habitat pk
  ON pk.species_code = 'PK'
  LEFT OUTER JOIN rivers r
  ON s.waterbody_key = r.waterbody_key
  WHERE wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)) -- apply to streams/rivers only
  AND s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET
  model_spawning_pk = model.spawn_pk
FROM model
WHERE s.segmented_stream_id = model.segmented_stream_id;