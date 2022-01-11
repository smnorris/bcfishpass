-- --------------------
-- NOW POPULATE THE VARIOUS COLUMNS
-- --------------------

-- first, linear stats
WITH
spp_downstream AS
(
  SELECT
    :point_id,
    array_agg(species_code) as species_codes
  FROM
    (
      SELECT DISTINCT
        a.:point_id,
        unnest(species_codes) as species_code
      FROM bcfishpass.:point_table a
      LEFT OUTER JOIN bcfishobs.fiss_fish_obsrvtn_events fo
      ON a.blue_line_key = fo.blue_line_key
      AND a.downstream_route_measure > fo.downstream_route_measure
      WHERE a.watershed_group_code = :'wsg'
      ORDER BY :point_id, species_code
    ) AS f
  GROUP BY :point_id
),

spp_upstream AS
(
SELECT
  :point_id,
  array_agg(species_code) as species_codes
FROM
  (
    SELECT DISTINCT
      a.:point_id,
      unnest(species_codes) as species_code
    FROM bcfishpass.:point_table a
    LEFT OUTER JOIN bcfishobs.fiss_fish_obsrvtn_events fo
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
    WHERE a.watershed_group_code = :'wsg'
    AND fo.watershed_group_code = :'wsg'
    ORDER BY species_code
  ) AS f
GROUP BY :point_id
),

grade AS
(
SELECT
  a.:point_id,
  s.gradient,
  s.stream_order,
  s.stream_magnitude,
  s.access_model_ch_co_sk,
  s.access_model_st,
  s.access_model_wct
  --,ua.upstream_area_ha
FROM bcfishpass.:point_table a
INNER JOIN bcfishpass.streams s
ON a.linear_feature_id = s.linear_feature_id
AND a.downstream_route_measure > s.downstream_route_measure - .001
AND a.downstream_route_measure + .001 < s.upstream_route_measure
--LEFT OUTER JOIN whse_basemapping.fwa_streams_watersheds_lut l
--ON s.linear_feature_id = l.linear_feature_id
--INNER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
--ON l.watershed_feature_id = ua.watershed_feature_id
WHERE a.watershed_group_code = :'wsg'
AND s.watershed_group_code = :'wsg'
ORDER BY a.:point_id, s.downstream_route_measure
),

report AS
(SELECT
  a.:point_id,
  b.stream_order,
  b.stream_magnitude,
  b.gradient,
  b.access_model_ch_co_sk,
  b.access_model_st,
  b.access_model_wct,
  --b.upstream_area_ha AS watershed_upstr_ha,
  spd.species_codes as observedspp_dnstr,
  spu.species_codes as observedspp_upstr,

-- totals
  COALESCE(ROUND((SUM(ST_Length(s.geom)::numeric) / 1000), 2), 0) AS total_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))) / 1000)::numeric, 2), 0) AS total_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS total_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS total_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .03 AND s.gradient < .05) / 1000))::numeric, 2), 0) as total_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .05 AND s.gradient < .08) / 1000))::numeric, 2), 0) as total_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .08 AND s.gradient < .15) / 1000))::numeric, 2), 0) as total_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .15 AND s.gradient < .22) / 1000))::numeric, 2), 0) as total_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .22 AND s.gradient < .30) / 1000))::numeric, 2), 0) as total_slopeclass30_km,

-- salmon model
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS ch_co_sk_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS ch_co_sk_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.access_model_ch_co_sk LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS ch_co_sk_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.access_model_ch_co_sk LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS ch_co_sk_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass30_km,

-- steelhead
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_st LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS st_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_st LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS st_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.access_model_st LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS st_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.access_model_st LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS st_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as st_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as st_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as st_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as st_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as st_slopeclass30_km,

-- wct
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS wct_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS wct_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.access_model_wct LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.access_model_wct LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as wct_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as wct_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as wct_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as wct_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as wct_slopeclass30_km,

-- habitat models
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_ch IS TRUE) / 1000))::numeric, 2), 0) AS ch_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_ch IS TRUE) / 1000))::numeric, 2), 0) AS ch_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_co IS TRUE) / 1000))::numeric, 2), 0) AS co_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_co IS TRUE) / 1000))::numeric, 2), 0) AS co_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_sk IS TRUE) / 1000))::numeric, 2), 0) AS sk_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_sk IS TRUE) / 1000))::numeric, 2), 0) AS sk_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_st IS TRUE) / 1000))::numeric, 2), 0) AS st_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_st IS TRUE) / 1000))::numeric, 2), 0) AS st_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_wct IS TRUE) / 1000))::numeric, 2), 0) AS wct_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_wct IS TRUE) / 1000))::numeric, 2), 0) AS wct_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_ch IS TRUE OR
                                                        s.spawning_model_co IS TRUE OR
                                                        s.spawning_model_sk IS TRUE OR
                                                        s.spawning_model_st IS TRUE OR
                                                        s.spawning_model_wct IS TRUE
                                                  ) / 1000))::numeric, 2), 0)  AS all_spawning_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_ch IS TRUE OR
                                                        s.rearing_model_co IS TRUE OR
                                                        s.rearing_model_sk IS TRUE OR
                                                        s.rearing_model_st IS TRUE OR
                                                        s.rearing_model_wct IS TRUE
                                                  ) / 1000))::numeric, 2), 0) AS all_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_ch IS TRUE OR
                                                        s.spawning_model_co IS TRUE OR
                                                        s.spawning_model_sk IS TRUE OR
                                                        s.spawning_model_st IS TRUE OR
                                                        s.spawning_model_wct IS TRUE OR
                                                        s.rearing_model_ch IS TRUE OR
                                                        s.rearing_model_co IS TRUE OR
                                                        s.rearing_model_sk IS TRUE OR
                                                        s.rearing_model_st IS TRUE OR
                                                        s.rearing_model_wct IS TRUE
                                                  ) / 1000))::numeric, 2), 0) AS all_spawningrearing_km

FROM bcfishpass.:point_table a
LEFT OUTER JOIN bcfishpass.streams s
ON FWA_Upstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    True,
    1
   )
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
LEFT OUTER JOIN spp_upstream spu
ON a.:point_id = spu.:point_id
LEFT OUTER JOIN spp_downstream spd
ON a.:point_id = spd.:point_id
LEFT OUTER JOIN grade b
ON a.:point_id = b.:point_id
WHERE a.watershed_group_code = :'wsg'
AND s.watershed_group_code = :'wsg'
GROUP BY
  a.:point_id,
  b.stream_order,
  b.gradient,
  b.stream_magnitude,
  b.access_model_ch_co_sk,
  b.access_model_st,
  b.access_model_wct,
  --b.upstream_area_ha,
  spd.species_codes,
  spu.species_codes
)

UPDATE bcfishpass.:point_table p
SET
  observedspp_dnstr = r.observedspp_dnstr,
  observedspp_upstr = r.observedspp_upstr,
  stream_order = r.stream_order,
  stream_magnitude = r.stream_magnitude,
  gradient = r.gradient,
  access_model_ch_co_sk = r.access_model_ch_co_sk,
  access_model_st = r.access_model_st,
  access_model_wct = r.access_model_wct,
  --watershed_upstr_ha = r.watershed_upstr_ha,
  total_network_km = r.total_network_km,
  total_stream_km = r.total_stream_km,
  total_slopeclass03_waterbodies_km = r.total_slopeclass03_waterbodies_km,
  total_slopeclass03_km = r.total_slopeclass03_km,
  total_slopeclass05_km = r.total_slopeclass05_km,
  total_slopeclass08_km = r.total_slopeclass08_km,
  total_slopeclass15_km = r.total_slopeclass15_km,
  total_slopeclass22_km = r.total_slopeclass22_km,
  total_slopeclass30_km = r.total_slopeclass30_km,
  ch_co_sk_network_km = r.ch_co_sk_network_km,
  ch_co_sk_stream_km = r.ch_co_sk_stream_km,
  ch_co_sk_slopeclass03_waterbodies_km = r.ch_co_sk_slopeclass03_waterbodies_km,
  ch_co_sk_slopeclass03_km = r.ch_co_sk_slopeclass03_km,
  ch_co_sk_slopeclass05_km = r.ch_co_sk_slopeclass05_km,
  ch_co_sk_slopeclass08_km = r.ch_co_sk_slopeclass08_km,
  ch_co_sk_slopeclass15_km = r.ch_co_sk_slopeclass15_km,
  ch_co_sk_slopeclass22_km = r.ch_co_sk_slopeclass22_km,
  ch_co_sk_slopeclass30_km = r.ch_co_sk_slopeclass30_km,
  st_network_km = r.st_network_km,
  st_stream_km = r.st_stream_km,
  st_slopeclass03_waterbodies_km = r.st_slopeclass03_waterbodies_km,
  st_slopeclass03_km = r.st_slopeclass03_km,
  st_slopeclass05_km = r.st_slopeclass05_km,
  st_slopeclass08_km = r.st_slopeclass08_km,
  st_slopeclass15_km = r.st_slopeclass15_km,
  st_slopeclass22_km = r.st_slopeclass22_km,
  st_slopeclass30_km = r.st_slopeclass30_km,
  wct_network_km = r.wct_network_km,
  wct_stream_km = r.wct_stream_km,
  wct_slopeclass03_waterbodies_km = r.wct_slopeclass03_waterbodies_km,
  wct_slopeclass03_km = r.wct_slopeclass03_km,
  wct_slopeclass05_km = r.wct_slopeclass05_km,
  wct_slopeclass08_km = r.wct_slopeclass08_km,
  wct_slopeclass15_km = r.wct_slopeclass15_km,
  wct_slopeclass22_km = r.wct_slopeclass22_km,
  wct_slopeclass30_km = r.wct_slopeclass30_km,
  ch_spawning_km = r.ch_spawning_km,
  ch_rearing_km = r.ch_rearing_km,
  co_spawning_km = r.co_spawning_km,
  co_rearing_km = r.co_rearing_km,
  sk_spawning_km = r.sk_spawning_km,
  sk_rearing_km = r.sk_rearing_km,
  st_spawning_km = r.st_spawning_km,
  st_rearing_km = r.st_rearing_km,
  wct_spawning_km = r.wct_spawning_km,
  wct_rearing_km = r.wct_rearing_km,
  all_spawning_km = r.all_spawning_km,
  all_rearing_km = r.all_rearing_km,
  all_spawningrearing_km = r.all_spawningrearing_km
FROM report r
WHERE p.:point_id = r.:point_id;


