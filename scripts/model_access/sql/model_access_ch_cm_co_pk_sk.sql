-- --------------------
-- refresh ch_co_sk access model for given watershed group
-- --------------------

-- first, set to null
UPDATE bcfishpass.streams s
SET model_access_ch_cm_co_pk_sk = NULL
WHERE model_access_ch_cm_co_pk_sk IS NOT NULL
AND watershed_group_code = :'wsg';


-- then re-calculate accessibility
WITH model_access AS
(
  SELECT
    s.segmented_stream_id,
    -- salmon accessibility
    CASE
      WHEN
          barriers_ch_cm_co_pk_sk_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
          barriers_pscis_dnstr IS NULL AND             -- but not a pscis barrier
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE OR cm IS TRUE OR pk IS TRUE
            )
          )
      THEN 'POTENTIALLY ACCESSIBLE'
      WHEN
          barriers_ch_cm_co_pk_sk_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
          barriers_pscis_dnstr IS NOT NULL AND        -- and is a pscis barrier
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE OR cm IS TRUE OR pk IS TRUE
            )
          )
      THEN 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
      WHEN
          barriers_ch_cm_co_pk_sk_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NULL AND
          barriers_pscis_dnstr IS NULL AND
          barriers_remediated_dnstr IS NULL AND
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE OR cm IS TRUE OR pk IS TRUE
            )
          )
      THEN 'ACCESSIBLE'
      WHEN
          barriers_ch_cm_co_pk_sk_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NULL AND
          barriers_pscis_dnstr IS NULL AND
          barriers_remediated_dnstr IS NOT NULL AND
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE OR cm IS TRUE OR pk IS TRUE
            )
          )
      THEN 'ACCESSIBLE - REMEDIATED'
    END AS model_access_ch_cm_co_pk_sk
  FROM bcfishpass.streams s
  WHERE s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET
  model_access_ch_cm_co_pk_sk = m.model_access_ch_cm_co_pk_sk
FROM model_access m
WHERE s.segmented_stream_id = m.segmented_stream_id;

-- note streams with observations upstream
--UPDATE bcfishpass.streams
--SET model_access_ch_cm_co_pk_sk = model_access_ch_cm_co_pk_sk||' - OBSRVTN UPSTR'
--WHERE
--  model_access_ch_cm_co_pk_sk is not null and
--  obsrvtn_species_codes_upstr && ARRAY['CH','CO','SK'] and
--  watershed_group_code = :'wsg';