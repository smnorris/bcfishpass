-- model rearing that is simply on modelled spawning habitat,
-- no connectivity analysis required

ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_chinook boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_coho boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_steelhead boolean;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS rearing_model_wct boolean;


-- ----------------------------------------------
-- CHINOOK
-- ----------------------------------------------
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN foundry.fwa_streams_mad mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'CH'
  WHERE
    s.spawning_model_chinook IS TRUE AND          -- on spawning habitat
    s.accessibility_model_salmon IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL AND
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    )
)

UPDATE bcfishpass.streams s
SET rearing_model_chinook = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing);


-- ----------------------------------------------
-- COHO
-- ----------------------------------------------
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN foundry.fwa_streams_mad mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'CO'
  WHERE
    s.spawning_model_coho IS TRUE AND             -- on spawning habitat
    s.accessibility_model_salmon IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers/wetlands
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300,1050,1150)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    OR s.edge_type IN (1050, 1150)  -- any wetlands are potential rearing
    )
)

UPDATE bcfishpass.streams s
SET rearing_model_coho = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing);


-- ----------------------------------------------
-- STEELHEAD
-- ----------------------------------------------
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN foundry.fwa_streams_mad mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'ST'
  WHERE
    s.spawning_model_steelhead IS TRUE AND        -- on spawning habitat
    s.accessibility_model_steelhead IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    )
)

UPDATE bcfishpass.streams s
SET rearing_model_steelhead = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing);

-- ----------------------------------------------
-- WESTSLOPE CUTTHROAT TROUT
-- ----------------------------------------------
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN foundry.fwa_streams_mad mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'WCT'
  WHERE
    s.spawning_model_wct IS TRUE AND              -- on spawning habitat
    s.accessibility_model_wct IS NOT NULL AND     -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    )
)

UPDATE bcfishpass.streams s
SET rearing_model_wct = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing);