-- in case this is a rerun, drop the columns first to ensure nothing is retained from previous runs
ALTER TABLE bcfishpass.segmented_streams DROP COLUMN IF EXISTS upstr_observedspp;
ALTER TABLE bcfishpass.segmented_streams DROP COLUMN IF EXISTS accessibility_model_salmon;
ALTER TABLE bcfishpass.segmented_streams DROP COLUMN IF EXISTS accessibility_model_steelhead;
ALTER TABLE bcfishpass.segmented_streams DROP COLUMN IF EXISTS accessibility_model_wct;

-- add the model output columns
ALTER TABLE bcfishpass.segmented_streams ADD COLUMN IF NOT EXISTS upstr_observedspp text[];
ALTER TABLE bcfishpass.segmented_streams ADD COLUMN accessibility_model_salmon text;
ALTER TABLE bcfishpass.segmented_streams ADD COLUMN accessibility_model_steelhead text;
ALTER TABLE bcfishpass.segmented_streams ADD COLUMN accessibility_model_wct text;


-- note all species observed upstream
WITH spp_upstream AS (
  SELECT
    segmented_stream_id,
    array_agg(species_code) as species_codes
  FROM
    (
      SELECT DISTINCT
        a.segmented_stream_id,
        unnest(species_codes) as species_code
      FROM bcfishpass.segmented_streams a
      LEFT OUTER JOIN bcfishpass.observations fo
      ON FWA_Upstream(
        a.blue_line_key,
        a.downstream_route_measure,
        a.wscode_ltree,
        a.localcode_ltree,
        fo.blue_line_key,
        fo.downstream_route_measure,
        fo.wscode_ltree,
        fo.localcode_ltree
       )
      ORDER BY species_code
    ) AS f
  GROUP BY segmented_stream_id
)
UPDATE bcfishpass.segmented_streams s
SET upstr_observedspp = u.species_codes
FROM spp_upstream u
WHERE s.segmented_stream_id = u.segmented_stream_id;


-- -------------------------------
-- SALMON (CO/CH/SK)
-- -------------------------------
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



-- -------------------------------
-- STEELHEAD
-- -------------------------------
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

-- -------------------------------
-- WESTSLOPE CUTTHROAT
-- -------------------------------
UPDATE bcfishpass.segmented_streams
SET accessibility_model_wct = 'POTENTIALLY ACCESSIBLE'
WHERE
(
    (
        dnstr_barriers_gradient_20 IS NULL AND
        dnstr_barriers_gradient_30 IS NULL AND
        dnstr_barriers_falls IS NULL AND
        dnstr_barriers_subsurfaceflow IS NULL AND
        dnstr_barriers_other_definite IS NULL
    ) OR
    (
        upstr_observedspp && ARRAY['WCT']  -- upstr wct observations override dnst barriers
    )
) AND
watershed_group_code = ANY(
  ARRAY(
    SELECT watershed_group_code
    FROM bcfishpass.wsg_species_presence
    WHERE wct IS TRUE
  )
);

-- refine 'potentially accessible' where known barriers are downstream
UPDATE bcfishpass.segmented_streams
SET accessibility_model_wct = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
WHERE accessibility_model_wct = 'POTENTIALLY ACCESSIBLE'
AND dnstr_barriers_pscis IS NOT NULL;

-- set 'potentially accessible' to accessible where no potential barriers downstream
UPDATE bcfishpass.segmented_streams
SET accessibility_model_wct = 'ACCESSIBLE'
WHERE accessibility_model_wct = 'POTENTIALLY ACCESSIBLE'
AND dnstr_remediated IS NULL
AND dnstr_barriers_anthropogenic IS NULL
AND watershed_group_code = ANY(
  ARRAY(
    SELECT watershed_group_code
    FROM bcfishpass.wsg_species_presence
    WHERE wct IS TRUE
  )
);

-- refine accessible streams into accessible - remedated where applicable
UPDATE bcfishpass.segmented_streams
SET accessibility_model_wct = 'ACCESSIBLE - REMEDIATED'
WHERE accessibility_model_wct = 'ACCESSIBLE'
AND dnstr_remediated IS NOT NULL
AND watershed_group_code = ANY(
  ARRAY(
    SELECT watershed_group_code
    FROM bcfishpass.wsg_species_presence
    WHERE wct IS TRUE
  )
);


