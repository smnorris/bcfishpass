-- refresh access model for given watershed group
DELETE FROM bcfishpass.model_access WHERE watershed_group_code = :'wsg';

INSERT INTO bcfishpass.model_access
(
  segmented_stream_id,
  watershed_group_code,
  barriers_majordams_dnstr,
  barriers_subsurfaceflow_dnstr,
  barriers_falls_dnstr,
  barriers_gradient_05_dnstr,
  barriers_gradient_07_dnstr,
  barriers_gradient_10_dnstr,
  barriers_gradient_15_dnstr,
  barriers_gradient_20_dnstr,
  barriers_gradient_25_dnstr,
  barriers_gradient_30_dnstr,
  barriers_other_definite_dnstr,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_remediated_dnstr,
  obsrvtn_pnt_distinct_upstr,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct
  )
SELECT
  s.segmented_stream_id,
  s.watershed_group_code,
  md.barriers_majordams_dnstr,
  ssf.barriers_subsurfaceflow_dnstr,
  falls.barriers_falls_dnstr,
  g05.barriers_gradient_05_dnstr,
  g07.barriers_gradient_07_dnstr,
  g10.barriers_gradient_10_dnstr,
  g15.barriers_gradient_15_dnstr,
  g20.barriers_gradient_20_dnstr,
  g25.barriers_gradient_25_dnstr,
  g30.barriers_gradient_30_dnstr,
  od.barriers_other_definite_dnstr,
  anth.barriers_anthropogenic_dnstr,
  pscis.barriers_pscis_dnstr,
  rmd.barriers_remediated_dnstr,
  obs.obsrvtn_pnt_distinct_upstr,
  -- salmon accessibility
  CASE
    WHEN
        g15.barriers_gradient_15_dnstr IS NULL AND
        g20.barriers_gradient_20_dnstr IS NULL AND
        g25.barriers_gradient_25_dnstr IS NULL AND
        g30.barriers_gradient_30_dnstr IS NULL AND
        falls.barriers_falls_dnstr IS NULL AND
        ssf.barriers_subsurfaceflow_dnstr IS NULL AND
        od.barriers_other_definite_dnstr IS NULL AND
        md.barriers_majordams_dnstr IS NULL AND
        anth.barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
        pscis.barriers_pscis_dnstr IS NULL AND            -- but not a pscis barrier
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
          )
        )
    THEN 'POTENTIALLY ACCESSIBLE'
    WHEN
        g15.barriers_gradient_15_dnstr IS NULL AND
        g20.barriers_gradient_20_dnstr IS NULL AND
        g25.barriers_gradient_25_dnstr IS NULL AND
        g30.barriers_gradient_30_dnstr IS NULL AND
        falls.barriers_falls_dnstr IS NULL AND
        ssf.barriers_subsurfaceflow_dnstr IS NULL AND
        od.barriers_other_definite_dnstr IS NULL AND
        md.barriers_majordams_dnstr IS NULL AND
        anth.barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
        pscis.barriers_pscis_dnstr IS NOT NULL AND        -- and is a pscis barrier
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
          )
        )
    THEN 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
    WHEN
        g15.barriers_gradient_15_dnstr IS NULL AND
        g20.barriers_gradient_20_dnstr IS NULL AND
        g25.barriers_gradient_25_dnstr IS NULL AND
        g30.barriers_gradient_30_dnstr IS NULL AND
        falls.barriers_falls_dnstr IS NULL AND
        ssf.barriers_subsurfaceflow_dnstr IS NULL AND
        od.barriers_other_definite_dnstr IS NULL AND
        md.barriers_majordams_dnstr IS NULL AND
        anth.barriers_anthropogenic_dnstr IS NULL AND
        pscis.barriers_pscis_dnstr IS NULL AND
        rmd.barriers_remediated_dnstr IS NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE co IS TRUE OR ch IS TRUE OR sk IS TRUE
          )
        )
    THEN 'ACCESSIBLE'
    WHEN
        g15.barriers_gradient_15_dnstr IS NULL AND
        g20.barriers_gradient_20_dnstr IS NULL AND
        g25.barriers_gradient_25_dnstr IS NULL AND
        g30.barriers_gradient_30_dnstr IS NULL AND
        falls.barriers_falls_dnstr IS NULL AND
        ssf.barriers_subsurfaceflow_dnstr IS NULL AND
        od.barriers_other_definite_dnstr IS NULL AND
        md.barriers_majordams_dnstr IS NULL AND
        anth.barriers_anthropogenic_dnstr IS NULL AND
        pscis.barriers_pscis_dnstr IS NULL AND
        rmd.barriers_remediated_dnstr IS NOT NULL AND
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
        g20.barriers_gradient_20_dnstr IS NULL AND
        g25.barriers_gradient_25_dnstr IS NULL AND
        g30.barriers_gradient_30_dnstr IS NULL AND
        falls.barriers_falls_dnstr IS NULL AND
        ssf.barriers_subsurfaceflow_dnstr IS NULL AND
        od.barriers_other_definite_dnstr IS NULL AND
        md.barriers_majordams_dnstr IS NULL AND
        anth.barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
        pscis.barriers_pscis_dnstr IS NULL AND            -- but not a pscis barrier
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE st IS TRUE
          )
        )
    THEN 'POTENTIALLY ACCESSIBLE'
    WHEN
        g20.barriers_gradient_20_dnstr IS NULL AND
        g25.barriers_gradient_25_dnstr IS NULL AND
        g30.barriers_gradient_30_dnstr IS NULL AND
        falls.barriers_falls_dnstr IS NULL AND
        ssf.barriers_subsurfaceflow_dnstr IS NULL AND
        od.barriers_other_definite_dnstr IS NULL AND
        md.barriers_majordams_dnstr IS NULL AND
        anth.barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
        pscis.barriers_pscis_dnstr IS NOT NULL AND        -- and is a pscis barrier
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE st IS TRUE
          )
        )
    THEN 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM'
    WHEN
        g20.barriers_gradient_20_dnstr IS NULL AND
        g25.barriers_gradient_25_dnstr IS NULL AND
        g30.barriers_gradient_30_dnstr IS NULL AND
        falls.barriers_falls_dnstr IS NULL AND
        ssf.barriers_subsurfaceflow_dnstr IS NULL AND
        od.barriers_other_definite_dnstr IS NULL AND
        md.barriers_majordams_dnstr IS NULL AND
        anth.barriers_anthropogenic_dnstr IS NULL AND
        pscis.barriers_pscis_dnstr IS NULL AND
        rmd.barriers_remediated_dnstr IS NULL AND
        s.watershed_group_code = ANY(
          ARRAY(
            SELECT watershed_group_code
            FROM bcfishpass.wsg_species_presence
            WHERE st IS TRUE
          )
        )
    THEN 'ACCESSIBLE'
    WHEN
        g20.barriers_gradient_20_dnstr IS NULL AND
        g25.barriers_gradient_25_dnstr IS NULL AND
        g30.barriers_gradient_30_dnstr IS NULL AND
        falls.barriers_falls_dnstr IS NULL AND
        ssf.barriers_subsurfaceflow_dnstr IS NULL AND
        od.barriers_other_definite_dnstr IS NULL AND
        md.barriers_majordams_dnstr IS NULL AND
        anth.barriers_anthropogenic_dnstr IS NULL AND
        pscis.barriers_pscis_dnstr IS NULL AND
        rmd.barriers_remediated_dnstr IS NOT NULL AND
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
            g20.barriers_gradient_20_dnstr IS NULL AND
            g25.barriers_gradient_25_dnstr IS NULL AND
            g30.barriers_gradient_30_dnstr IS NULL AND
            falls.barriers_falls_dnstr IS NULL AND
            ssf.barriers_subsurfaceflow_dnstr IS NULL AND
            od.barriers_other_definite_dnstr IS NULL AND
           -- md.barriers_majordams_dnstr IS NULL AND
            anth.barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
            pscis.barriers_pscis_dnstr IS NULL                -- but not a pscis barrier
          ) OR
            obs.obsrvtn_species_codes_upstr && ARRAY['WCT'] AND         -- upstr wct observations override dnst barriers
            anth.barriers_anthropogenic_dnstr IS NOT NULL AND -- anth barrier present downstream
            pscis.barriers_pscis_dnstr IS NULL AND            -- but it is not a pscis barrier
            rmd.barriers_remediated_dnstr IS NULL
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
            g20.barriers_gradient_20_dnstr IS NULL AND
            g25.barriers_gradient_25_dnstr IS NULL AND
            g30.barriers_gradient_30_dnstr IS NULL AND
            falls.barriers_falls_dnstr IS NULL AND
            ssf.barriers_subsurfaceflow_dnstr IS NULL AND
            od.barriers_other_definite_dnstr IS NULL AND
           -- md.barriers_majordams_dnstr IS NULL AND
            anth.barriers_anthropogenic_dnstr IS NOT NULL AND -- dam/barrier downstream
            pscis.barriers_pscis_dnstr IS NOT NULL            -- and it is a pscis barrier
          ) OR
            obs.obsrvtn_species_codes_upstr && ARRAY['WCT'] AND         -- upstr wct observations override dnst barriers
            anth.barriers_anthropogenic_dnstr IS NOT NULL AND -- anth barrier present downstream
            pscis.barriers_pscis_dnstr IS NOT NULL            -- and it is a pscis barrier
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
            g20.barriers_gradient_20_dnstr IS NULL AND
            g25.barriers_gradient_25_dnstr IS NULL AND
            g30.barriers_gradient_30_dnstr IS NULL AND
            falls.barriers_falls_dnstr IS NULL AND
            ssf.barriers_subsurfaceflow_dnstr IS NULL AND
            od.barriers_other_definite_dnstr IS NULL AND
           -- md.barriers_majordams_dnstr IS NULL AND
            anth.barriers_anthropogenic_dnstr IS NULL AND
            pscis.barriers_pscis_dnstr IS NULL AND
            rmd.barriers_remediated_dnstr IS NULL
          ) OR
            obs.obsrvtn_species_codes_upstr && ARRAY['WCT'] AND         -- upstr wct observations override dnst barriers
            anth.barriers_anthropogenic_dnstr IS NULL AND
            pscis.barriers_pscis_dnstr IS NULL AND
            rmd.barriers_remediated_dnstr IS NULL
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
            g20.barriers_gradient_20_dnstr IS NULL AND
            g25.barriers_gradient_25_dnstr IS NULL AND
            g30.barriers_gradient_30_dnstr IS NULL AND
            falls.barriers_falls_dnstr IS NULL AND
            ssf.barriers_subsurfaceflow_dnstr IS NULL AND
            od.barriers_other_definite_dnstr IS NULL AND
           -- md.barriers_majordams_dnstr IS NULL AND
            anth.barriers_anthropogenic_dnstr IS NULL AND
            pscis.barriers_pscis_dnstr IS NULL AND
            rmd.barriers_remediated_dnstr IS NOT NULL
          ) OR
            obs.obsrvtn_species_codes_upstr && ARRAY['WCT'] AND         -- upstr wct observations override dnst barriers
            anth.barriers_anthropogenic_dnstr IS NULL AND
            pscis.barriers_pscis_dnstr IS NULL AND
            rmd.barriers_remediated_dnstr IS NOT NULL
        )
    THEN 'ACCESSIBLE - REMEDIATED'
  END AS accessibility_model_wct
FROM bcfishpass.segmented_streams s
LEFT OUTER JOIN bcfishpass.barriers_majordams_dnstr md
ON s.blue_line_key = md.blue_line_key
AND s.downstream_route_measure = md.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_subsurfaceflow_dnstr ssf
ON s.blue_line_key = ssf.blue_line_key
AND s.downstream_route_measure = ssf.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_falls_dnstr falls
ON s.blue_line_key = falls.blue_line_key
AND s.downstream_route_measure = falls.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_gradient_05_dnstr g05
ON s.blue_line_key = g05.blue_line_key
AND s.downstream_route_measure = g05.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_gradient_07_dnstr g07
ON s.blue_line_key = g07.blue_line_key
AND s.downstream_route_measure = g07.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_gradient_10_dnstr g10
ON s.blue_line_key = g10.blue_line_key
AND s.downstream_route_measure = g10.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_gradient_15_dnstr g15
ON s.blue_line_key = g15.blue_line_key
AND s.downstream_route_measure = g15.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_gradient_20_dnstr g20
ON s.blue_line_key = g20.blue_line_key
AND s.downstream_route_measure = g20.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_gradient_25_dnstr g25
ON s.blue_line_key = g25.blue_line_key
AND s.downstream_route_measure = g25.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_gradient_30_dnstr g30
ON s.blue_line_key = g30.blue_line_key
AND s.downstream_route_measure = g30.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_other_definite_dnstr od
ON s.blue_line_key = od.blue_line_key
AND s.downstream_route_measure = od.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_anthropogenic_dnstr anth
ON s.blue_line_key = anth.blue_line_key
AND s.downstream_route_measure = anth.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_pscis_dnstr pscis
ON s.blue_line_key = pscis.blue_line_key
AND s.downstream_route_measure = pscis.downstream_route_measure
LEFT OUTER JOIN bcfishpass.barriers_remediated_dnstr rmd
ON s.blue_line_key = rmd.blue_line_key
AND s.downstream_route_measure = rmd.downstream_route_measure
LEFT OUTER JOIN bcfishpass.observations_upstr obs
ON s.blue_line_key = obs.blue_line_key
AND s.downstream_route_measure = obs.downstream_route_measure
WHERE s.watershed_group_code = :'wsg';
