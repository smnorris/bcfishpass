ALTER TABLE bcfishpass.streams ADD COLUMN accessibility_model_salmon text;
ALTER TABLE bcfishpass.streams ADD COLUMN accessibility_model_steelhead text;
ALTER TABLE bcfishpass.streams ADD COLUMN accessibility_model_wct text;

UPDATE bcfishpass.streams
SET accessibility_model_salmon = 'POTENTIALLY ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_15 IS NULL AND
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL
    AND watershed_group_code = 'HORS';

UPDATE bcfishpass.streams
SET accessibility_model_salmon = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
WHERE accessibility_model_salmon = 'POTENTIALLY ACCESSIBLE'
AND dnstr_barriers_pscis IS NOT NULL;

UPDATE bcfishpass.streams
SET accessibility_model_salmon = 'ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_15 IS NULL AND
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_anthropogenic IS NULL
    AND watershed_group_code = 'HORS';

UPDATE bcfishpass.streams
SET accessibility_model_steelhead = 'POTENTIALLY ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL
    AND watershed_group_code IN ('BULK','LNIC');

UPDATE bcfishpass.streams
SET accessibility_model_steelhead = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
WHERE accessibility_model_steelhead = 'POTENTIALLY ACCESSIBLE'
AND dnstr_barriers_pscis IS NOT NULL;

UPDATE bcfishpass.streams
SET accessibility_model_steelhead = 'ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_anthropogenic IS NULL
    AND watershed_group_code IN ('BULK','LNIC');

UPDATE bcfishpass.streams
SET accessibility_model_wct = 'POTENTIALLY ACCESSIBLE'
WHERE
    ((dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL)
    OR upstr_observation_id IS NOT NULL)
    AND watershed_group_code = 'ELKR';

UPDATE bcfishpass.streams
SET accessibility_model_wct = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
WHERE accessibility_model_wct = 'POTENTIALLY ACCESSIBLE'
AND dnstr_barriers_pscis IS NOT NULL;

UPDATE bcfishpass.streams
SET accessibility_model_wct = 'ACCESSIBLE'
WHERE
    ((dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL)
    OR upstr_observation_id IS NOT NULL)
    AND dnstr_barriers_anthropogenic IS NULL
    AND watershed_group_code = 'ELKR';