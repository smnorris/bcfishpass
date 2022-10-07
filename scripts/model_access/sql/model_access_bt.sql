-- --------------------
-- refresh access model for given watershed group
-- --------------------

-- first, set to null
UPDATE bcfishpass.streams s
SET model_access_bt = NULL
WHERE model_access_bt IS NOT NULL
AND watershed_group_code = :'wsg';


-- then re-calculate accessibility
WITH model_access AS 
(
  SELECT
    s.segmented_stream_id,
      -- steelhead accessibility
    CASE
      WHEN
          barriers_bt_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
          barriers_pscis_dnstr IS NULL AND            -- but not a pscis barrier
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE bt IS TRUE
            )
          )
      THEN 'POTENTIALLY ACCESSIBLE'
      WHEN
          barriers_bt_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
          barriers_pscis_dnstr IS NOT NULL AND        -- and is a pscis barrier
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE bt IS TRUE
            )
          )
      THEN 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
      WHEN
          barriers_bt_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NULL AND
          barriers_pscis_dnstr IS NULL AND
          barriers_remediated_dnstr IS NULL AND
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE bt IS TRUE
            )
          )
      THEN 'ACCESSIBLE'
      WHEN
          barriers_bt_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NULL AND
          barriers_pscis_dnstr IS NULL AND
          barriers_remediated_dnstr IS NOT NULL AND
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE bt IS TRUE
            )
          )
      THEN 'ACCESSIBLE - REMEDIATED'
    END AS model_access_bt
  FROM bcfishpass.streams s
  WHERE s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET 
  model_access_bt = m.model_access_bt
FROM model_access m
WHERE s.segmented_stream_id = m.segmented_stream_id;

-- note streams with BT observations upstream
--UPDATE bcfishpass.streams
--SET model_access_bt = model_access_bt||' - OBSRVTN UPSTR'
--WHERE
--  model_access_bt is not null and
--  obsrvtn_species_codes_upstr && ARRAY['BT'] and
--  watershed_group_code = :'wsg';