-- ==============================================
-- CHUM HABITAT POTENTIAL MODEL 
-- ==============================================

-- ----------------------------------------------
-- RESET OUTPUTS
-- ----------------------------------------------
UPDATE bcfishpass.streams s
SET model_spawning_cm = NULL
WHERE model_spawning_cm IS NOT NULL
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
    cw.channel_width,
    s.gradient,
    s.barriers_ch_cm_co_pk_sk_dnstr,
    CASE
      WHEN
        wsg.model = 'cw' AND
        s.gradient <= cm.spawn_gradient_max AND
        (cw.channel_width > cm.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
        cw.channel_width <= cm.spawn_channel_width_max AND
        s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
      THEN true
      WHEN wsg.model = 'mad' AND
        s.gradient <= cm.spawn_gradient_max AND
          (mad.mad_m3s > cm.spawn_mad_min OR
          s.stream_order >= 8) AND
        s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
      THEN true
    END AS spawn_cm
  FROM bcfishpass.streams s
  LEFT OUTER JOIN bcfishpass.discharge mad ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.channel_width cw ON s.linear_feature_id = cw.linear_feature_id
  INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
  INNER JOIN bcfishpass.wsg_species_presence p ON s.watershed_group_code = p.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds cm
  ON cm.species_code = 'CM'
  LEFT OUTER JOIN rivers r
  ON s.waterbody_key = r.waterbody_key
  WHERE (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))) -- apply to streams/rivers only
  and p.cm is true
  AND s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET
  model_spawning_cm = model.spawn_cm
FROM model
WHERE s.segmented_stream_id = model.segmented_stream_id
AND model.spawn_cm is true;