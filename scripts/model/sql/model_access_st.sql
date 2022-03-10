-- --------------------
-- refresh access model for given watershed group
-- --------------------

-- first, set to null
UPDATE bcfishpass.streams s
SET access_model_st = NULL
WHERE access_model_st IS NOT NULL
AND watershed_group_code = :'wsg';


-- then re-calculate accessibility
WITH model_access AS
(
  SELECT
    s.segmented_stream_id,
      -- steelhead accessibility
    CASE
      WHEN
          barriers_st_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
          barriers_pscis_dnstr IS NULL AND            -- but not a pscis barrier
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE st IS TRUE
            )
          )
      THEN 'POTENTIALLY ACCESSIBLE'
      WHEN
          barriers_st_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
          barriers_pscis_dnstr IS NOT NULL AND        -- and is a pscis barrier
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE st IS TRUE
            )
          )
      THEN 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
      WHEN
          barriers_st_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NULL AND
          barriers_pscis_dnstr IS NULL AND
          barriers_remediated_dnstr IS NULL AND
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE st IS TRUE
            )
          )
      THEN 'ACCESSIBLE'
      WHEN
          barriers_st_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NULL AND
          barriers_pscis_dnstr IS NULL AND
          barriers_remediated_dnstr IS NOT NULL AND
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE st IS TRUE
            )
          )
      THEN 'ACCESSIBLE - REMEDIATED'
    END AS access_model_st
  FROM bcfishpass.streams s
  WHERE s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET
  access_model_st = m.access_model_st
FROM model_access m
WHERE s.segmented_stream_id = m.segmented_stream_id;