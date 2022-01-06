-- model rearing that is simply on modelled spawning habitat,
-- no connectivity analysis required

-- before doing anything, reset to NULL
UPDATE bcfishpass.streams s
SET rearing_model_ch = NULL
WHERE watershed_group_code = :'wsg'
AND rearing_model_ch IS NOT NULL;

UPDATE bcfishpass.streams s
SET rearing_model_co = NULL
WHERE watershed_group_code = :'wsg'
AND rearing_model_co IS NOT NULL;

UPDATE bcfishpass.streams s
SET rearing_model_st = NULL
WHERE watershed_group_code = :'wsg'
AND rearing_model_st IS NOT NULL;

UPDATE bcfishpass.streams s
SET rearing_model_wct = NULL
WHERE watershed_group_code = :'wsg'
AND rearing_model_wct IS NOT NULL;

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
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'CH'
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.spawning_model_chinook IS TRUE AND          -- on spawning habitat
    s.access_model_salmon IS NOT NULL AND  -- accessibility check
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
        s.mad_m3s > h.rear_mad_min AND
        s.mad_m3s <= h.rear_mad_max
      )
    )
)

UPDATE bcfishpass.streams s
SET rearing_model_ch = TRUE
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
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'CO'
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.spawning_model_coho IS TRUE AND             -- on spawning habitat
    s.access_model_salmon IS NOT NULL AND  -- accessibility check
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
        s.mad_m3s > h.rear_mad_min AND
        s.mad_m3s <= h.rear_mad_max
      )
    OR s.edge_type IN (1050, 1150)  -- any wetlands are potential rearing
    )
)

UPDATE bcfishpass.streams s
SET rearing_model_co = TRUE
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
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'ST'
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.spawning_model_steelhead IS TRUE AND        -- on spawning habitat
    s.access_model_steelhead IS NOT NULL AND  -- accessibility check
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
        s.mad_m3s > h.rear_mad_min AND
        s.mad_m3s <= h.rear_mad_max
      )
    )
)

UPDATE bcfishpass.streams s
SET rearing_model_st = TRUE
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
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'WCT'
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.spawning_model_wct IS TRUE AND              -- on spawning habitat
    s.access_model_wct IS NOT NULL AND     -- accessibility check
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
        s.mad_m3s > h.rear_mad_min AND
        s.mad_m3s <= h.rear_mad_max
      )
    )
)

UPDATE bcfishpass.streams s
SET rearing_model_wct = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing);