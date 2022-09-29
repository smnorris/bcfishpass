-- --------------------
-- refresh ch_co_sk access model for given watershed group
-- --------------------

-- first, set to null
UPDATE bcfishpass.streams s
SET access_model_ch_co_sk = NULL
WHERE access_model_ch_co_sk IS NOT NULL
AND watershed_group_code = :'wsg';


-- then re-calculate accessibility
WITH model_access AS
(
  SELECT
    s.segmented_stream_id,
    -- salmon accessibility
    CASE
      WHEN
          barriers_ch_co_sk_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
          barriers_pscis_dnstr IS NULL AND             -- but not a pscis barrier
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
            )
          )
      THEN 'POTENTIALLY ACCESSIBLE'
      WHEN
          barriers_ch_co_sk_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
          barriers_pscis_dnstr IS NOT NULL AND        -- and is a pscis barrier
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
            )
          )
      THEN 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
      WHEN
          barriers_ch_co_sk_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NULL AND
          barriers_pscis_dnstr IS NULL AND
          barriers_remediated_dnstr IS NULL AND
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
            )
          )
      THEN 'ACCESSIBLE'
      WHEN
          barriers_ch_co_sk_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NULL AND
          barriers_pscis_dnstr IS NULL AND
          barriers_remediated_dnstr IS NOT NULL AND
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
            )
          )
      THEN 'ACCESSIBLE - REMEDIATED'
    END AS access_model_ch_co_sk
  FROM bcfishpass.streams s
  WHERE s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET
  access_model_ch_co_sk = m.access_model_ch_co_sk
FROM model_access m
WHERE s.segmented_stream_id = m.segmented_stream_id;

-- note streams with observations upstream
--UPDATE bcfishpass.streams
--SET access_model_ch_co_sk = access_model_ch_co_sk||' - OBSRVTN UPSTR'
--WHERE
--  access_model_ch_co_sk is not null and
--  obsrvtn_species_codes_upstr && ARRAY['CH','CO','SK'] and
--  watershed_group_code = :'wsg';