-- in case this is a rerun, drop the columns first to ensure nothing is retained from previous runs
ALTER TABLE bcfishpass.segmented_streams DROP COLUMN IF EXISTS accessibility_model_salmon;
ALTER TABLE bcfishpass.segmented_streams DROP COLUMN IF EXISTS accessibility_model_steelhead;
ALTER TABLE bcfishpass.segmented_streams DROP COLUMN IF EXISTS accessibility_model_wct;

-- and add the model output columns back in
ALTER TABLE bcfishpass.segmented_streams ADD COLUMN accessibility_model_salmon text;
ALTER TABLE bcfishpass.segmented_streams ADD COLUMN accessibility_model_steelhead text;
ALTER TABLE bcfishpass.segmented_streams ADD COLUMN accessibility_model_wct text;


-- SALMON
UPDATE bcfishpass.segmented_streams
SET accessibility_model_salmon = 'POTENTIALLY ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_15 IS NULL AND
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_majordams IS NULL
    AND watershed_group_code in
    (
        SELECT watershed_group_code
        FROM bcfishpass.wsg_species_presence
        WHERE (co IS TRUE OR ch IS TRUE OR sk IS TRUE)
    );

UPDATE bcfishpass.segmented_streams
SET accessibility_model_salmon = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
WHERE accessibility_model_salmon = 'POTENTIALLY ACCESSIBLE'
AND dnstr_barriers_pscis IS NOT NULL;

UPDATE bcfishpass.segmented_streams
SET accessibility_model_salmon = 'ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_15 IS NULL AND
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_majordams IS NULL AND
    dnstr_barriers_anthropogenic IS NULL AND
    dnstr_remediated IS NULL AND
    watershed_group_code IN
    (
        SELECT watershed_group_code
        FROM bcfishpass.wsg_species_presence
        WHERE (co IS TRUE OR ch IS TRUE OR sk IS TRUE)
    );

UPDATE bcfishpass.segmented_streams
SET accessibility_model_salmon = 'ACCESSIBLE - REMEDIATED'
WHERE
    dnstr_barriers_gradient_15 IS NULL AND
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_majordams IS NULL AND
    dnstr_barriers_anthropogenic IS NULL AND
    dnstr_remediated IS NOT NULL AND
    watershed_group_code IN
    (
        SELECT watershed_group_code
        FROM bcfishpass.wsg_species_presence
        WHERE (co IS TRUE OR ch IS TRUE OR sk IS TRUE)
    );

-- STEELHEAD
UPDATE bcfishpass.segmented_streams
SET accessibility_model_steelhead = 'POTENTIALLY ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_majordams IS NULL
    AND watershed_group_code IN
    (
        SELECT watershed_group_code
        FROM bcfishpass.wsg_species_presence
        WHERE st IS TRUE
    );

UPDATE bcfishpass.segmented_streams
SET accessibility_model_steelhead = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
WHERE accessibility_model_steelhead = 'POTENTIALLY ACCESSIBLE'
AND dnstr_barriers_pscis IS NOT NULL;

UPDATE bcfishpass.segmented_streams
SET accessibility_model_steelhead = 'ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_majordams IS NULL AND
    dnstr_barriers_anthropogenic IS NULL AND
    dnstr_remediated IS NULL
    AND watershed_group_code IN
    (
        SELECT watershed_group_code
        FROM bcfishpass.wsg_species_presence
        WHERE st IS TRUE
    );

UPDATE bcfishpass.segmented_streams
SET accessibility_model_steelhead = 'ACCESSIBLE - REMEDIATED'
WHERE
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_majordams IS NULL AND
    dnstr_barriers_anthropogenic IS NULL AND
    dnstr_remediated IS NOT NULL
    AND watershed_group_code IN
    (
        SELECT watershed_group_code
        FROM bcfishpass.wsg_species_presence
        WHERE st IS TRUE
    );

