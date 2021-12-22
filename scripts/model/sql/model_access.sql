CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.model_access AS

SELECT
  s.*,
  md.dnstr_barriers_majordams,
  ssf.dnstr_barriers_subsurfaceflow,
  falls.dnstr_barriers_falls,
  g15.dnstr_barriers_gradient_15,
  g20.dnstr_barriers_gradient_20,
  g30.dnstr_barriers_gradient_30,
  od.dnstr_barriers_other_definite,
  anth.dnstr_barriers_anthropogenic,
  pscis.dnstr_barriers_pscis,
  rmd.dnstr_remediated,
  obs.upstr_obsrvtn_pnt_distinct,
  -- salmon accessibility
  CASE
    WHEN
        g15.dnstr_barriers_gradient_15 IS NULL AND
        g20.dnstr_barriers_gradient_20 IS NULL AND
        g30.dnstr_barriers_gradient_30 IS NULL AND
        falls.dnstr_barriers_falls IS NULL AND
        ssf.dnstr_barriers_subsurfaceflow IS NULL AND
        od.dnstr_barriers_other_definite IS NULL AND
        md.dnstr_barriers_majordams IS NULL AND
        anth.dnstr_barriers_anthropogenic IS NOT NULL AND -- dam/barrier downstream
        pscis.dnstr_barriers_pscis IS NULL AND            -- but not a pscis barrier
        rmd.dnstr_remediated IS NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
          )
        )
    THEN 'POTENTIALLY ACCESSIBLE'
    WHEN
        g15.dnstr_barriers_gradient_15 IS NULL AND
        g20.dnstr_barriers_gradient_20 IS NULL AND
        g30.dnstr_barriers_gradient_30 IS NULL AND
        falls.dnstr_barriers_falls IS NULL AND
        ssf.dnstr_barriers_subsurfaceflow IS NULL AND
        od.dnstr_barriers_other_definite IS NULL AND
        md.dnstr_barriers_majordams IS NULL AND
        anth.dnstr_barriers_anthropogenic IS NOT NULL AND -- dam/barrier downstream
        pscis.dnstr_barriers_pscis IS NOT NULL AND        -- and is a pscis barrier
        rmd.dnstr_remediated IS NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
          )
        )
    THEN 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
    WHEN
        g15.dnstr_barriers_gradient_15 IS NULL AND
        g20.dnstr_barriers_gradient_20 IS NULL AND
        g30.dnstr_barriers_gradient_30 IS NULL AND
        falls.dnstr_barriers_falls IS NULL AND
        ssf.dnstr_barriers_subsurfaceflow IS NULL AND
        od.dnstr_barriers_other_definite IS NULL AND
        md.dnstr_barriers_majordams IS NULL AND
        anth.dnstr_barriers_anthropogenic IS NULL AND
        pscis.dnstr_barriers_pscis IS NULL AND
        rmd.dnstr_remediated IS NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
          )
        )
    THEN 'ACCESSIBLE'
    WHEN
        g15.dnstr_barriers_gradient_15 IS NULL AND
        g20.dnstr_barriers_gradient_20 IS NULL AND
        g30.dnstr_barriers_gradient_30 IS NULL AND
        falls.dnstr_barriers_falls IS NULL AND
        ssf.dnstr_barriers_subsurfaceflow IS NULL AND
        od.dnstr_barriers_other_definite IS NULL AND
        md.dnstr_barriers_majordams IS NULL AND
        anth.dnstr_barriers_anthropogenic IS NULL AND
        pscis.dnstr_barriers_pscis IS NULL AND
        rmd.dnstr_remediated IS NOT NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
          )
        )
    THEN 'ACCESSIBLE - REMEDIATED'
  END AS accessibility_model_salmon,

    -- steelhead accessibility
  CASE
    WHEN
        g20.dnstr_barriers_gradient_20 IS NULL AND
        g30.dnstr_barriers_gradient_30 IS NULL AND
        falls.dnstr_barriers_falls IS NULL AND
        ssf.dnstr_barriers_subsurfaceflow IS NULL AND
        od.dnstr_barriers_other_definite IS NULL AND
        md.dnstr_barriers_majordams IS NULL AND
        anth.dnstr_barriers_anthropogenic IS NOT NULL AND -- dam/barrier downstream
        pscis.dnstr_barriers_pscis IS NULL AND            -- but not a pscis barrier
        rmd.dnstr_remediated IS NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE st IS TRUE
          )
        )
    THEN 'POTENTIALLY ACCESSIBLE'
    WHEN
        g20.dnstr_barriers_gradient_20 IS NULL AND
        g30.dnstr_barriers_gradient_30 IS NULL AND
        falls.dnstr_barriers_falls IS NULL AND
        ssf.dnstr_barriers_subsurfaceflow IS NULL AND
        od.dnstr_barriers_other_definite IS NULL AND
        md.dnstr_barriers_majordams IS NULL AND
        anth.dnstr_barriers_anthropogenic IS NOT NULL AND -- dam/barrier downstream
        pscis.dnstr_barriers_pscis IS NOT NULL AND        -- and is a pscis barrier
        rmd.dnstr_remediated IS NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE st IS TRUE
          )
        )
    THEN 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
    WHEN
        g20.dnstr_barriers_gradient_20 IS NULL AND
        g30.dnstr_barriers_gradient_30 IS NULL AND
        falls.dnstr_barriers_falls IS NULL AND
        ssf.dnstr_barriers_subsurfaceflow IS NULL AND
        od.dnstr_barriers_other_definite IS NULL AND
        md.dnstr_barriers_majordams IS NULL AND
        anth.dnstr_barriers_anthropogenic IS NULL AND
        pscis.dnstr_barriers_pscis IS NULL AND
        rmd.dnstr_remediated IS NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE st IS TRUE
          )
        )
    THEN 'ACCESSIBLE'
    WHEN
        g20.dnstr_barriers_gradient_20 IS NULL AND
        g30.dnstr_barriers_gradient_30 IS NULL AND
        falls.dnstr_barriers_falls IS NULL AND
        ssf.dnstr_barriers_subsurfaceflow IS NULL AND
        od.dnstr_barriers_other_definite IS NULL AND
        md.dnstr_barriers_majordams IS NULL AND
        anth.dnstr_barriers_anthropogenic IS NULL AND
        pscis.dnstr_barriers_pscis IS NULL AND
        rmd.dnstr_remediated IS NOT NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE st IS TRUE
          )
        )
    THEN 'ACCESSIBLE - REMEDIATED'
  END AS accessibility_model_steelhead,

  -- westslope cutthroat trout
  CASE
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
          (
            g20.dnstr_barriers_gradient_20 IS NULL AND
            g30.dnstr_barriers_gradient_30 IS NULL AND
            falls.dnstr_barriers_falls IS NULL AND
            ssf.dnstr_barriers_subsurfaceflow IS NULL AND
            od.dnstr_barriers_other_definite IS NULL AND
           -- md.dnstr_barriers_majordams IS NULL AND
            anth.dnstr_barriers_anthropogenic IS NOT NULL AND -- dam/barrier downstream
            pscis.dnstr_barriers_pscis IS NULL AND            -- but not a pscis barrier
            rmd.dnstr_remediated IS NULL
          ) OR
            obs.upstr_obsrvtn_species_codes && ARRAY['WCT'] AND         -- upstr wct observations override dnst barriers
            anth.dnstr_barriers_anthropogenic IS NOT NULL AND -- anth barrier present downstream
            pscis.dnstr_barriers_pscis IS NULL AND            -- but it is not a pscis barrier
            rmd.dnstr_remediated IS NULL
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
          (
            g20.dnstr_barriers_gradient_20 IS NULL AND
            g30.dnstr_barriers_gradient_30 IS NULL AND
            falls.dnstr_barriers_falls IS NULL AND
            ssf.dnstr_barriers_subsurfaceflow IS NULL AND
            od.dnstr_barriers_other_definite IS NULL AND
           -- md.dnstr_barriers_majordams IS NULL AND
            anth.dnstr_barriers_anthropogenic IS NOT NULL AND -- dam/barrier downstream
            pscis.dnstr_barriers_pscis IS NOT NULL AND        -- and it is a pscis barrier
            rmd.dnstr_remediated IS NULL
          ) OR
            obs.upstr_obsrvtn_species_codes && ARRAY['WCT'] AND         -- upstr wct observations override dnst barriers
            anth.dnstr_barriers_anthropogenic IS NOT NULL AND -- anth barrier present downstream
            pscis.dnstr_barriers_pscis IS NOT NULL AND        -- and it is a pscis barrier
            rmd.dnstr_remediated IS NULL
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
          (
            g20.dnstr_barriers_gradient_20 IS NULL AND
            g30.dnstr_barriers_gradient_30 IS NULL AND
            falls.dnstr_barriers_falls IS NULL AND
            ssf.dnstr_barriers_subsurfaceflow IS NULL AND
            od.dnstr_barriers_other_definite IS NULL AND
           -- md.dnstr_barriers_majordams IS NULL AND
            anth.dnstr_barriers_anthropogenic IS NULL AND
            pscis.dnstr_barriers_pscis IS NULL AND
            rmd.dnstr_remediated IS NULL
          ) OR
            obs.upstr_obsrvtn_species_codes && ARRAY['WCT'] AND         -- upstr wct observations override dnst barriers
            anth.dnstr_barriers_anthropogenic IS NULL AND
            pscis.dnstr_barriers_pscis IS NULL AND
            rmd.dnstr_remediated IS NULL
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
          (
            g20.dnstr_barriers_gradient_20 IS NULL AND
            g30.dnstr_barriers_gradient_30 IS NULL AND
            falls.dnstr_barriers_falls IS NULL AND
            ssf.dnstr_barriers_subsurfaceflow IS NULL AND
            od.dnstr_barriers_other_definite IS NULL AND
           -- md.dnstr_barriers_majordams IS NULL AND
            anth.dnstr_barriers_anthropogenic IS NULL AND
            pscis.dnstr_barriers_pscis IS NULL AND
            rmd.dnstr_remediated IS NULL
          ) OR
            obs.upstr_obsrvtn_species_codes && ARRAY['WCT'] AND         -- upstr wct observations override dnst barriers
            anth.dnstr_barriers_anthropogenic IS NULL AND
            pscis.dnstr_barriers_pscis IS NULL AND
            rmd.dnstr_remediated IS NOT NULL
        )
    THEN 'ACCESSIBLE - REMEDIATED'
  END AS accessibility_model_wct
FROM bcfishpass.segmented_streams s
LEFT OUTER JOIN bcfishpass.dnstr_barriers_majordams_vw md
ON s.blue_line_key = md.blue_line_key
AND s.downstream_route_measure = md.downstream_route_measure
LEFT OUTER JOIN bcfishpass.dnstr_barriers_subsurfaceflow_vw ssf
ON s.blue_line_key = ssf.blue_line_key
AND s.downstream_route_measure = ssf.downstream_route_measure
LEFT OUTER JOIN bcfishpass.dnstr_barriers_falls_vw falls
ON s.blue_line_key = falls.blue_line_key
AND s.downstream_route_measure = falls.downstream_route_measure
LEFT OUTER JOIN bcfishpass.dnstr_barriers_gradient_15_vw g15
ON s.blue_line_key = g15.blue_line_key
AND s.downstream_route_measure = g15.downstream_route_measure
LEFT OUTER JOIN bcfishpass.dnstr_barriers_gradient_20_vw g20
ON s.blue_line_key = g20.blue_line_key
AND s.downstream_route_measure = g20.downstream_route_measure
LEFT OUTER JOIN bcfishpass.dnstr_barriers_gradient_30_vw g30
ON s.blue_line_key = g30.blue_line_key
AND s.downstream_route_measure = g30.downstream_route_measure
LEFT OUTER JOIN bcfishpass.dnstr_barriers_other_definite_vw od
ON s.blue_line_key = od.blue_line_key
AND s.downstream_route_measure = od.downstream_route_measure
LEFT OUTER JOIN bcfishpass.dnstr_barriers_anthropogenic_vw anth
ON s.blue_line_key = anth.blue_line_key
AND s.downstream_route_measure = anth.downstream_route_measure
LEFT OUTER JOIN bcfishpass.dnstr_barriers_pscis_vw pscis
ON s.blue_line_key = pscis.blue_line_key
AND s.downstream_route_measure = pscis.downstream_route_measure
LEFT OUTER JOIN bcfishpass.dnstr_barriers_remediated_vw rmd
ON s.blue_line_key = rmd.blue_line_key
AND s.downstream_route_measure = rmd.downstream_route_measure
LEFT OUTER JOIN bcfishpass.upstr_observations_vw obs
ON s.blue_line_key = obs.blue_line_key
AND s.downstream_route_measure = obs.downstream_route_measure;


CREATE INDEX ON bcfishpass.model_access (segmented_stream_id);

CREATE INDEX ON bcfishpass.model_access (linear_feature_id);
CREATE INDEX ON bcfishpass.model_access (blue_line_key);
CREATE INDEX ON bcfishpass.model_access (watershed_group_code);
CREATE INDEX ON bcfishpass.model_access USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.model_access USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.model_access USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.model_access USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.model_access USING GIST (geom);
