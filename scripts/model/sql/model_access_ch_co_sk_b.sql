-- --------------------
-- refresh access model for given watershed group
-- --------------------

-- first, set to null
UPDATE bcfishpass.streams s
SET access_model_ch_co_sk_b = NULL
WHERE access_model_ch_co_sk_b IS NOT NULL
AND watershed_group_code = :'wsg';


-- then re-calculate accessibility
WITH model_access AS
(
  SELECT
    s.segmented_stream_id,
    -- salmon accessibility, with barriers cancelled by observations upstream
    CASE
      WHEN
          barriers_ch_co_sk_b_dnstr IS NULL AND
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
          barriers_ch_co_sk_b_dnstr IS NULL AND
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
          barriers_ch_co_sk_b_dnstr IS NULL AND
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
          barriers_ch_co_sk_b_dnstr IS NULL AND
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
    END AS access_model_ch_co_sk_b
  FROM bcfishpass.streams s
  WHERE s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET
  access_model_ch_co_sk_b = m.access_model_ch_co_sk_b
FROM model_access m
WHERE s.segmented_stream_id = m.segmented_stream_id;