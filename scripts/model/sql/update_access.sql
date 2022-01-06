-- --------------------
-- refresh access model for given watershed group
-- --------------------

-- first, set to null
UPDATE bcfishpass.streams s
SET access_model_ch_co_sk = NULL
WHERE access_model_ch_co_sk IS NOT NULL
AND watershed_group_code = :'wsg';

UPDATE bcfishpass.streams s
SET access_model_st = NULL
WHERE access_model_st IS NOT NULL
AND watershed_group_code = :'wsg';

UPDATE bcfishpass.streams s
SET access_model_wct = NULL
WHERE access_model_wct IS NOT NULL
AND watershed_group_code = :'wsg';


-- then re-calculate accessibility
WITH model_access AS 
(
  SELECT
    s.segmented_stream_id,
    -- salmon accessibility
    CASE
      WHEN
          barriers_gradient_15_dnstr IS NULL AND
          barriers_gradient_20_dnstr IS NULL AND
          barriers_gradient_25_dnstr IS NULL AND
          barriers_gradient_30_dnstr IS NULL AND
          barriers_falls_dnstr IS NULL AND
          barriers_subsurfaceflow_dnstr IS NULL AND
          barriers_other_definite_dnstr IS NULL AND
          barriers_majordams_dnstr IS NULL AND
          barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
          barriers_pscis_dnstr IS NULL AND            -- but not a pscis barrier
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
            )
          )
      THEN 'POTENTIALLY ACCESSIBLE'
      WHEN
          barriers_gradient_15_dnstr IS NULL AND
          barriers_gradient_20_dnstr IS NULL AND
          barriers_gradient_25_dnstr IS NULL AND
          barriers_gradient_30_dnstr IS NULL AND
          barriers_falls_dnstr IS NULL AND
          barriers_subsurfaceflow_dnstr IS NULL AND
          barriers_other_definite_dnstr IS NULL AND
          barriers_majordams_dnstr IS NULL AND
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
          barriers_gradient_15_dnstr IS NULL AND
          barriers_gradient_20_dnstr IS NULL AND
          barriers_gradient_25_dnstr IS NULL AND
          barriers_gradient_30_dnstr IS NULL AND
          barriers_falls_dnstr IS NULL AND
          barriers_subsurfaceflow_dnstr IS NULL AND
          barriers_other_definite_dnstr IS NULL AND
          barriers_majordams_dnstr IS NULL AND
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
          barriers_gradient_15_dnstr IS NULL AND
          barriers_gradient_20_dnstr IS NULL AND
          barriers_gradient_25_dnstr IS NULL AND
          barriers_gradient_30_dnstr IS NULL AND
          barriers_falls_dnstr IS NULL AND
          barriers_subsurfaceflow_dnstr IS NULL AND
          barriers_other_definite_dnstr IS NULL AND
          barriers_majordams_dnstr IS NULL AND
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
    END AS access_model_ch_co_sk,

      -- steelhead accessibility
    CASE
      WHEN
          barriers_gradient_20_dnstr IS NULL AND
          barriers_gradient_25_dnstr IS NULL AND
          barriers_gradient_30_dnstr IS NULL AND
          barriers_falls_dnstr IS NULL AND
          barriers_subsurfaceflow_dnstr IS NULL AND
          barriers_other_definite_dnstr IS NULL AND
          barriers_majordams_dnstr IS NULL AND
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
          barriers_gradient_20_dnstr IS NULL AND
          barriers_gradient_25_dnstr IS NULL AND
          barriers_gradient_30_dnstr IS NULL AND
          barriers_falls_dnstr IS NULL AND
          barriers_subsurfaceflow_dnstr IS NULL AND
          barriers_other_definite_dnstr IS NULL AND
          barriers_majordams_dnstr IS NULL AND
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
          barriers_gradient_20_dnstr IS NULL AND
          barriers_gradient_25_dnstr IS NULL AND
          barriers_gradient_30_dnstr IS NULL AND
          barriers_falls_dnstr IS NULL AND
          barriers_subsurfaceflow_dnstr IS NULL AND
          barriers_other_definite_dnstr IS NULL AND
          barriers_majordams_dnstr IS NULL AND
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
          barriers_gradient_20_dnstr IS NULL AND
          barriers_gradient_25_dnstr IS NULL AND
          barriers_gradient_30_dnstr IS NULL AND
          barriers_falls_dnstr IS NULL AND
          barriers_subsurfaceflow_dnstr IS NULL AND
          barriers_other_definite_dnstr IS NULL AND
          barriers_majordams_dnstr IS NULL AND
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
    END AS access_model_st,

    -- westslope cutthroat trout
    CASE
      WHEN
          watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE wct IS TRUE
            )
          )
          AND
          -- do not include areas behind manually defined definite barriers
          barriers_other_definite_dnstr IS NULL AND
          -- an anthropogenic barrier is downstream
          barriers_anthropogenic_dnstr IS NOT NULL AND
          -- but not a pscis barrier
          barriers_pscis_dnstr IS NULL AND
          -- and not remediated
          barriers_remediated_dnstr IS NULL AND
          (
            (
              barriers_gradient_20_dnstr IS NULL AND
              barriers_gradient_25_dnstr IS NULL AND
              barriers_gradient_30_dnstr IS NULL AND
              barriers_falls_dnstr IS NULL AND
              barriers_subsurfaceflow_dnstr IS NULL
              -- barriers_majordams_dnstr IS NULL AND

            ) OR obsrvtn_species_codes_upstr && ARRAY['WCT']  -- upstr wct observations override dnst barriers
          )
      THEN 'POTENTIALLY ACCESSIBLE'
      WHEN
          s.watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE wct IS TRUE
            )
          )
          AND
          (
          -- do not include areas behind manually defined definite barriers
          barriers_other_definite_dnstr IS NULL AND
          -- an anthropogenic barrier is downstream
          barriers_anthropogenic_dnstr IS NOT NULL AND
          -- a pscis barrier is downstream
          barriers_pscis_dnstr IS NOT NULL AND
          -- and not remediated
          barriers_remediated_dnstr IS NULL AND
          (
            (
              barriers_gradient_20_dnstr IS NULL AND
              barriers_gradient_25_dnstr IS NULL AND
              barriers_gradient_30_dnstr IS NULL AND
              barriers_falls_dnstr IS NULL AND
              barriers_subsurfaceflow_dnstr IS NULL
             -- barriers_majordams_dnstr IS NULL AND
            ) OR obsrvtn_species_codes_upstr && ARRAY['WCT']    -- upstr wct observations override dnst barriers
          )
          )
      THEN 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
      WHEN
          s.watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE wct IS TRUE
            )
          )
          AND
                (
          -- do not include areas behind manually defined definite barriers
          barriers_other_definite_dnstr IS NULL AND
          -- no anthropogenic barrier is downstream
          barriers_anthropogenic_dnstr IS NULL AND
          -- no pscis barrier is downstream
          barriers_pscis_dnstr IS NULL AND
          -- and not remediated
          barriers_remediated_dnstr IS NULL AND
          (
            (
              barriers_gradient_20_dnstr IS NULL AND
              barriers_gradient_25_dnstr IS NULL AND
              barriers_gradient_30_dnstr IS NULL AND
              barriers_falls_dnstr IS NULL AND
              barriers_subsurfaceflow_dnstr IS NULL
             -- barriers_majordams_dnstr IS NULL AND
            ) OR obsrvtn_species_codes_upstr && ARRAY['WCT']    -- upstr wct observations override dnst barriers
          )
          )
      THEN 'ACCESSIBLE'
      WHEN
          s.watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE wct IS TRUE
            )
          )
          AND
          (
          -- do not include areas behind manually defined definite barriers
          barriers_other_definite_dnstr IS NULL AND
          -- no anthropogenic barrier is downstream
          barriers_anthropogenic_dnstr IS NULL AND
          -- no pscis barrier is downstream
          barriers_pscis_dnstr IS NULL AND
          -- remediated
          barriers_remediated_dnstr IS NOT NULL AND
          (
            (
              barriers_gradient_20_dnstr IS NULL AND
              barriers_gradient_25_dnstr IS NULL AND
              barriers_gradient_30_dnstr IS NULL AND
              barriers_falls_dnstr IS NULL AND
              barriers_subsurfaceflow_dnstr IS NULL
             -- barriers_majordams_dnstr IS NULL AND
            ) OR obsrvtn_species_codes_upstr && ARRAY['WCT']    -- upstr wct observations override dnst barriers
          )
          )
      THEN 'ACCESSIBLE - REMEDIATED'
    END AS access_model_wct
  FROM bcfishpass.streams s
  WHERE s.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.streams s
SET 
  access_model_ch_co_sk = m.access_model_ch_co_sk,
  access_model_st = m.access_model_st,
  access_model_wct = m.access_model_wct
FROM model_access m
WHERE s.segmented_stream_id = m.segmented_stream_id;