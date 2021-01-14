-- in case this is a rerun, drop the columns first to ensure nothing is retained from previous runs
ALTER TABLE bcfishpass.streams DROP COLUMN IF EXISTS accessibility_model_salmon;
ALTER TABLE bcfishpass.streams DROP COLUMN IF EXISTS accessibility_model_steelhead;
ALTER TABLE bcfishpass.streams DROP COLUMN IF EXISTS accessibility_model_wct;

-- and add the model output columns back in
ALTER TABLE bcfishpass.streams ADD COLUMN accessibility_model_salmon text;
ALTER TABLE bcfishpass.streams ADD COLUMN accessibility_model_steelhead text;
ALTER TABLE bcfishpass.streams ADD COLUMN accessibility_model_wct text;


-- SALMON
UPDATE bcfishpass.streams
SET accessibility_model_salmon = 'POTENTIALLY ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_15 IS NULL AND
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_majordams IS NULL
    AND watershed_group_code in ('HORS','BULK','LNIC');

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
    dnstr_barriers_majordams IS NULL AND
    dnstr_barriers_anthropogenic IS NULL
    AND watershed_group_code = ('HORS','BULK','LNIC');

-- STEELHEAD
UPDATE bcfishpass.streams
SET accessibility_model_steelhead = 'POTENTIALLY ACCESSIBLE'
WHERE
    dnstr_barriers_gradient_20 IS NULL AND
    dnstr_barriers_gradient_30 IS NULL AND
    dnstr_barriers_falls IS NULL AND
    dnstr_barriers_subsurfaceflow IS NULL AND
    dnstr_barriers_other_definite IS NULL AND
    dnstr_barriers_majordams IS NULL
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
    dnstr_barriers_majordams IS NULL AND
    dnstr_barriers_anthropogenic IS NULL
    AND watershed_group_code IN ('BULK','LNIC');


-- WESTSLOPE CUTTHROAT
UPDATE bcfishpass.streams
SET accessibility_model_wct = 'POTENTIALLY ACCESSIBLE'
WHERE dnstr_barriers_wct IS NULL
AND watershed_group_code = 'ELKR';

UPDATE bcfishpass.streams
SET accessibility_model_wct = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
WHERE accessibility_model_wct = 'POTENTIALLY ACCESSIBLE'
AND dnstr_barriers_pscis IS NOT NULL;

UPDATE bcfishpass.streams
SET accessibility_model_wct = 'ACCESSIBLE'
WHERE dnstr_barriers_wct IS NULL
AND dnstr_barriers_anthropogenic IS NULL
AND watershed_group_code = 'ELKR';