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
  s.access_model_wct,
  ua.upstream_area_ha
FROM bcfishpass.:point_table a
INNER JOIN bcfishpass.streams s
ON a.linear_feature_id = s.linear_feature_id
AND a.downstream_route_measure > s.downstream_route_measure - .001
AND a.downstream_route_measure + .001 < s.upstream_route_measure
LEFT OUTER JOIN whse_basemapping.fwa_streams_watersheds_lut l
ON s.linear_feature_id = l.linear_feature_id
INNER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
ON l.watershed_feature_id = ua.watershed_feature_id
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
  b.upstream_area_ha AS watershed_upstr_ha,
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
  b.upstream_area_ha,
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
  watershed_upstr_ha = r.watershed_upstr_ha,
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


-- increase linear total for co and sk rearing by 50% within wetlands/lakes
-- this is just an attempt to give these more importance (as they aren't really linear anyway)
WITH lake_wetland_rearing AS
(
  SELECT
    a.:point_id,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_co IS TRUE AND wb.waterbody_type = 'W') / 1000))::numeric, 2), 0) AS co_rearing_km_wetland,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_sk IS TRUE AND wb.waterbody_type IN ('X','L')) / 1000))::numeric, 2), 0) AS sk_rearing_km_lake
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
  WHERE a.watershed_group_code = :'wsg'
  AND s.watershed_group_code = :'wsg'
  GROUP BY a.:point_id
)

UPDATE bcfishpass.:point_table p
SET
  co_rearing_km = co_rearing_km + (r.co_rearing_km_wetland * .5),
  sk_rearing_km = sk_rearing_km + (r.sk_rearing_km_lake * .5),
  all_rearing_km = all_rearing_km + (r.co_rearing_km_wetland * .5) + (r.sk_rearing_km_lake * .5),
  all_spawningrearing_km = all_spawningrearing_km + (r.co_rearing_km_wetland * .5) + (r.sk_rearing_km_lake * .5)
FROM lake_wetland_rearing r
WHERE p.:point_id = r.:point_id;


-- populate upstream area stats
WITH upstr_wb AS
(SELECT DISTINCT
  a.:point_id,
  s.waterbody_key,
  s.access_model_ch_co_sk,
  s.access_model_st,
  s.access_model_wct,
  s.rearing_model_co,
  s.rearing_model_sk,
  ST_Area(lake.geom) as area_lake,
  ST_Area(manmade.geom) as area_manmade,
  ST_Area(wetland.geom) as area_wetland
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
LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lake
ON s.waterbody_key = lake.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly manmade
ON s.waterbody_key = manmade.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_wetlands_poly wetland
ON s.waterbody_key = wetland.waterbody_key
WHERE s.waterbody_key IS NOT NULL
AND a.watershed_group_code = :'wsg'
AND s.watershed_group_code = :'wsg'
ORDER BY a.:point_id
),

report AS
(SELECT
  :point_id,
  ROUND(((
    SUM(COALESCE(uwb.area_lake, 0)) + SUM(COALESCE(uwb.area_manmade,0))) / 10000)::numeric, 2
  ) AS total_lakereservoir_ha,
  ROUND((SUM(COALESCE(uwb.area_wetland, 0)) / 10000)::numeric, 2) AS total_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.access_model_ch_co_sk LIKE '%ACCESSIBLE%') +
          SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.access_model_ch_co_sk LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS ch_co_sk_lakereservoir_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.access_model_ch_co_sk LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS ch_co_sk_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.access_model_st LIKE '%ACCESSIBLE%') +
          SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.access_model_st LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS st_lakereservoir_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.access_model_st LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS st_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.access_model_wct LIKE '%ACCESSIBLE%') +
          SUM(uwb.area_manmade) FILTER (WHERE uwb.access_model_wct LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS wct_lakereservoir_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.access_model_wct LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS wct_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.rearing_model_co = True)) / 10000)::numeric, 2) AS co_rearing_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.rearing_model_sk = True) +
          SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.rearing_model_sk = True)) / 10000)::numeric, 2) AS sk_rearing_ha
FROM upstr_wb uwb
GROUP BY :point_id
)

UPDATE bcfishpass.:point_table p
SET
  total_lakereservoir_ha = r.total_lakereservoir_ha,
  total_wetland_ha = r.total_wetland_ha,
  ch_co_sk_lakereservoir_ha = r.ch_co_sk_lakereservoir_ha,
  ch_co_sk_wetland_ha = r.ch_co_sk_wetland_ha,
  st_lakereservoir_ha = r.st_lakereservoir_ha,
  st_wetland_ha = r.st_wetland_ha,
  wct_lakereservoir_ha = r.wct_lakereservoir_ha,
  wct_wetland_ha = r.wct_wetland_ha,
  co_rearing_ha = r.co_rearing_ha,
  sk_rearing_ha = r.sk_rearing_ha
FROM report r
WHERE p.:point_id = r.:point_id;


-- Calculate and populate upstream length/area stats for below addtional upstream barriers
-- (this is the total at the given point as already calculated, minus the total on all points immediately upstream of the point)
-- NOTE - this has to be re-run separately for bcfishpass.crossings because it includes a mixture of passable/barriers,
-- and not all tables we run this report on will have the barrier_status column
-- see 00_report_crossings_obs_belowupstrbarriers.sql

-- default to total upstream
UPDATE bcfishpass.:point_table p
SET
  total_belowupstrbarriers_network_km = total_network_km,
  total_belowupstrbarriers_stream_km = total_stream_km,
  total_belowupstrbarriers_lakereservoir_ha = total_lakereservoir_ha,
  total_belowupstrbarriers_wetland_ha = total_wetland_ha,
  total_belowupstrbarriers_slopeclass03_waterbodies_km = total_slopeclass03_waterbodies_km,
  total_belowupstrbarriers_slopeclass03_km = total_slopeclass03_km,
  total_belowupstrbarriers_slopeclass05_km = total_slopeclass05_km,
  total_belowupstrbarriers_slopeclass08_km = total_slopeclass08_km,
  total_belowupstrbarriers_slopeclass15_km = total_slopeclass15_km,
  total_belowupstrbarriers_slopeclass22_km = total_slopeclass22_km,
  total_belowupstrbarriers_slopeclass30_km = total_slopeclass30_km,
  ch_co_sk_belowupstrbarriers_network_km = ch_co_sk_network_km,
  ch_co_sk_belowupstrbarriers_stream_km = ch_co_sk_stream_km,
  ch_co_sk_belowupstrbarriers_lakereservoir_ha = ch_co_sk_lakereservoir_ha,
  ch_co_sk_belowupstrbarriers_wetland_ha = ch_co_sk_wetland_ha,
  ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km = ch_co_sk_slopeclass03_waterbodies_km,
  ch_co_sk_belowupstrbarriers_slopeclass03_km = ch_co_sk_slopeclass03_km,
  ch_co_sk_belowupstrbarriers_slopeclass05_km = ch_co_sk_slopeclass05_km,
  ch_co_sk_belowupstrbarriers_slopeclass08_km = ch_co_sk_slopeclass08_km,
  ch_co_sk_belowupstrbarriers_slopeclass15_km = ch_co_sk_slopeclass15_km,
  ch_co_sk_belowupstrbarriers_slopeclass22_km = ch_co_sk_slopeclass22_km,
  ch_co_sk_belowupstrbarriers_slopeclass30_km = ch_co_sk_slopeclass30_km,
  st_belowupstrbarriers_network_km = st_network_km,
  st_belowupstrbarriers_stream_km = st_stream_km,
  st_belowupstrbarriers_lakereservoir_ha = st_lakereservoir_ha,
  st_belowupstrbarriers_wetland_ha = st_wetland_ha,
  st_belowupstrbarriers_slopeclass03_km = st_slopeclass03_km,
  st_belowupstrbarriers_slopeclass05_km = st_slopeclass05_km,
  st_belowupstrbarriers_slopeclass08_km = st_slopeclass08_km,
  st_belowupstrbarriers_slopeclass15_km = st_slopeclass15_km,
  st_belowupstrbarriers_slopeclass22_km = st_slopeclass22_km,
  st_belowupstrbarriers_slopeclass30_km = st_slopeclass30_km,
  wct_belowupstrbarriers_network_km = wct_network_km,
  wct_belowupstrbarriers_stream_km = wct_stream_km,
  wct_belowupstrbarriers_lakereservoir_ha = wct_lakereservoir_ha,
  wct_belowupstrbarriers_wetland_ha = wct_wetland_ha,
  wct_belowupstrbarriers_slopeclass03_km = wct_slopeclass03_km,
  wct_belowupstrbarriers_slopeclass05_km = wct_slopeclass05_km,
  wct_belowupstrbarriers_slopeclass08_km = wct_slopeclass08_km,
  wct_belowupstrbarriers_slopeclass15_km = wct_slopeclass15_km,
  wct_belowupstrbarriers_slopeclass22_km = wct_slopeclass22_km,
  wct_belowupstrbarriers_slopeclass30_km = wct_slopeclass30_km,
  ch_spawning_belowupstrbarriers_km = ch_spawning_km,
  ch_rearing_belowupstrbarriers_km = ch_rearing_km,
  co_spawning_belowupstrbarriers_km = co_spawning_km,
  co_rearing_belowupstrbarriers_km = co_rearing_km,
  sk_spawning_belowupstrbarriers_km = sk_spawning_km,
  sk_rearing_belowupstrbarriers_km = sk_rearing_km,
  st_spawning_belowupstrbarriers_km = st_spawning_km,
  st_rearing_belowupstrbarriers_km = st_rearing_km,
  wct_spawning_belowupstrbarriers_km = wct_spawning_km,
  wct_rearing_belowupstrbarriers_km = wct_rearing_km,
  all_spawning_belowupstrbarriers_km = all_spawning_km,
  all_rearing_belowupstrbarriers_km = all_rearing_km,
  all_spawningrearing_belowupstrbarriers_km = all_spawningrearing_km
  WHERE watershed_group_code = :'wsg';

-- then calculate the rest where there is/are anthropogenic crossings upstream
WITH report AS
(SELECT
  a.:point_id,
  ROUND((COALESCE(a.total_network_km, 0) - SUM(COALESCE(b.total_network_km, 0)))::numeric, 2) total_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.total_stream_km, 0) - SUM(COALESCE(b.total_stream_km, 0)))::numeric, 2) total_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.total_lakereservoir_ha, 0) - SUM(COALESCE(b.total_lakereservoir_ha, 0)))::numeric, 2) total_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.total_wetland_ha, 0) - SUM(COALESCE(b.total_wetland_ha, 0)))::numeric, 2) total_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.total_slopeclass03_waterbodies_km, 0) - SUM(COALESCE(b.total_slopeclass03_waterbodies_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND((COALESCE(a.total_slopeclass03_km, 0) - SUM(COALESCE(b.total_slopeclass03_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.total_slopeclass05_km, 0) - SUM(COALESCE(b.total_slopeclass05_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.total_slopeclass08_km, 0) - SUM(COALESCE(b.total_slopeclass08_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.total_slopeclass15_km, 0) - SUM(COALESCE(b.total_slopeclass15_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.total_slopeclass22_km, 0) - SUM(COALESCE(b.total_slopeclass22_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.total_slopeclass30_km, 0) - SUM(COALESCE(b.total_slopeclass30_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.ch_co_sk_network_km, 0) - SUM(COALESCE(b.ch_co_sk_network_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.ch_co_sk_stream_km, 0) - SUM(COALESCE(b.ch_co_sk_stream_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.ch_co_sk_lakereservoir_ha, 0) - SUM(COALESCE(b.ch_co_sk_lakereservoir_ha, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.ch_co_sk_wetland_ha, 0) - SUM(COALESCE(b.ch_co_sk_wetland_ha, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.ch_co_sk_slopeclass03_waterbodies_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass03_waterbodies_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass03_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass03_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass05_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass05_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass08_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass08_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass15_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass15_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass22_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass22_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass30_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass30_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.st_network_km, 0) - SUM(COALESCE(b.st_network_km, 0)))::numeric, 2) st_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.st_stream_km, 0) - SUM(COALESCE(b.st_stream_km, 0)))::numeric, 2) st_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.st_lakereservoir_ha, 0) - SUM(COALESCE(b.st_lakereservoir_ha, 0)))::numeric, 2) st_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.st_wetland_ha, 0) - SUM(COALESCE(b.st_wetland_ha, 0)))::numeric, 2) st_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.st_slopeclass03_km, 0) - SUM(COALESCE(b.st_slopeclass03_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.st_slopeclass05_km, 0) - SUM(COALESCE(b.st_slopeclass05_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.st_slopeclass08_km, 0) - SUM(COALESCE(b.st_slopeclass08_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.st_slopeclass15_km, 0) - SUM(COALESCE(b.st_slopeclass15_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.st_slopeclass22_km, 0) - SUM(COALESCE(b.st_slopeclass22_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.st_slopeclass30_km, 0) - SUM(COALESCE(b.st_slopeclass30_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.wct_network_km, 0) - SUM(COALESCE(b.wct_network_km, 0)))::numeric, 2) wct_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.wct_stream_km, 0) - SUM(COALESCE(b.wct_stream_km, 0)))::numeric, 2) wct_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.wct_lakereservoir_ha, 0) - SUM(COALESCE(b.wct_lakereservoir_ha, 0)))::numeric, 2) wct_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.wct_wetland_ha, 0) - SUM(COALESCE(b.wct_wetland_ha, 0)))::numeric, 2) wct_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.wct_slopeclass03_km, 0) - SUM(COALESCE(b.wct_slopeclass03_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.wct_slopeclass05_km, 0) - SUM(COALESCE(b.wct_slopeclass05_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.wct_slopeclass08_km, 0) - SUM(COALESCE(b.wct_slopeclass08_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.wct_slopeclass15_km, 0) - SUM(COALESCE(b.wct_slopeclass15_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.wct_slopeclass22_km, 0) - SUM(COALESCE(b.wct_slopeclass22_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.wct_slopeclass30_km, 0) - SUM(COALESCE(b.wct_slopeclass30_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.ch_spawning_km, 0) - SUM(COALESCE(b.ch_spawning_km, 0)))::numeric, 2) ch_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.ch_rearing_km, 0) - SUM(COALESCE(b.ch_rearing_km, 0)))::numeric, 2) ch_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_spawning_km, 0) - SUM(COALESCE(b.co_spawning_km, 0)))::numeric, 2) co_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_rearing_km, 0) - SUM(COALESCE(b.co_rearing_km, 0)))::numeric, 2) co_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_rearing_ha, 0) - SUM(COALESCE(b.co_rearing_ha, 0)))::numeric, 2) co_rearing_belowupstrbarriers_ha,
  ROUND((COALESCE(a.sk_spawning_km, 0) - SUM(COALESCE(b.sk_spawning_km, 0)))::numeric, 2) sk_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.sk_rearing_km, 0) - SUM(COALESCE(b.sk_rearing_km, 0)))::numeric, 2) sk_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.sk_rearing_ha, 0) - SUM(COALESCE(b.sk_rearing_ha, 0)))::numeric, 2) sk_rearing_belowupstrbarriers_ha  ,
  ROUND((COALESCE(a.st_spawning_km, 0) - SUM(COALESCE(b.st_spawning_km, 0)))::numeric, 2) st_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.st_rearing_km, 0) - SUM(COALESCE(b.st_rearing_km, 0)))::numeric, 2) st_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.wct_spawning_km, 0) - SUM(COALESCE(b.wct_spawning_km, 0)))::numeric, 2) wct_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.wct_rearing_km, 0) - SUM(COALESCE(b.wct_rearing_km, 0)))::numeric, 2) wct_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.all_spawning_km, 0) - SUM(COALESCE(b.all_spawning_km, 0)))::numeric, 2) all_spawning_belowupstrbarriers_km,
  ROUND((COALESCE(a.all_rearing_km, 0) - SUM(COALESCE(b.all_rearing_km, 0)))::numeric, 2) all_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.all_spawningrearing_km, 0) - SUM(COALESCE(b.all_spawningrearing_km, 0)))::numeric, 2) all_spawningrearing_belowupstrbarriers_km
FROM bcfishpass.:point_table a
INNER JOIN bcfishpass.:barriers_table b
ON a.:point_id = b.:dnstr_barriers_id[1]
WHERE a.watershed_group_code = :'wsg'
AND b.watershed_group_code = :'wsg'
GROUP BY a.:point_id
)

UPDATE bcfishpass.:point_table p
SET
  total_belowupstrbarriers_network_km = r.total_belowupstrbarriers_network_km,
  total_belowupstrbarriers_stream_km = r.total_belowupstrbarriers_stream_km,
  total_belowupstrbarriers_lakereservoir_ha = r.total_belowupstrbarriers_lakereservoir_ha,
  total_belowupstrbarriers_wetland_ha = r.total_belowupstrbarriers_wetland_ha,
  total_belowupstrbarriers_slopeclass03_waterbodies_km = r.total_belowupstrbarriers_slopeclass03_waterbodies_km,
  total_belowupstrbarriers_slopeclass03_km = r.total_belowupstrbarriers_slopeclass03_km,
  total_belowupstrbarriers_slopeclass05_km = r.total_belowupstrbarriers_slopeclass05_km,
  total_belowupstrbarriers_slopeclass08_km = r.total_belowupstrbarriers_slopeclass08_km,
  total_belowupstrbarriers_slopeclass15_km = r.total_belowupstrbarriers_slopeclass15_km,
  total_belowupstrbarriers_slopeclass22_km = r.total_belowupstrbarriers_slopeclass22_km,
  total_belowupstrbarriers_slopeclass30_km = r.total_belowupstrbarriers_slopeclass30_km,
  ch_co_sk_belowupstrbarriers_network_km = r.ch_co_sk_belowupstrbarriers_network_km,
  ch_co_sk_belowupstrbarriers_stream_km = r.ch_co_sk_belowupstrbarriers_stream_km,
  ch_co_sk_belowupstrbarriers_lakereservoir_ha = r.ch_co_sk_belowupstrbarriers_lakereservoir_ha,
  ch_co_sk_belowupstrbarriers_wetland_ha = r.ch_co_sk_belowupstrbarriers_wetland_ha,
  ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km = r.ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  ch_co_sk_belowupstrbarriers_slopeclass03_km = r.ch_co_sk_belowupstrbarriers_slopeclass03_km,
  ch_co_sk_belowupstrbarriers_slopeclass05_km = r.ch_co_sk_belowupstrbarriers_slopeclass05_km,
  ch_co_sk_belowupstrbarriers_slopeclass08_km = r.ch_co_sk_belowupstrbarriers_slopeclass08_km,
  ch_co_sk_belowupstrbarriers_slopeclass15_km = r.ch_co_sk_belowupstrbarriers_slopeclass15_km,
  ch_co_sk_belowupstrbarriers_slopeclass22_km = r.ch_co_sk_belowupstrbarriers_slopeclass22_km,
  ch_co_sk_belowupstrbarriers_slopeclass30_km = r.ch_co_sk_belowupstrbarriers_slopeclass30_km,
  st_belowupstrbarriers_network_km = r.st_belowupstrbarriers_network_km,
  st_belowupstrbarriers_stream_km = r.st_belowupstrbarriers_stream_km,
  st_belowupstrbarriers_lakereservoir_ha = r.st_belowupstrbarriers_lakereservoir_ha,
  st_belowupstrbarriers_wetland_ha = r.st_belowupstrbarriers_wetland_ha,
  st_belowupstrbarriers_slopeclass03_km = r.st_belowupstrbarriers_slopeclass03_km,
  st_belowupstrbarriers_slopeclass05_km = r.st_belowupstrbarriers_slopeclass05_km,
  st_belowupstrbarriers_slopeclass08_km = r.st_belowupstrbarriers_slopeclass08_km,
  st_belowupstrbarriers_slopeclass15_km = r.st_belowupstrbarriers_slopeclass15_km,
  st_belowupstrbarriers_slopeclass22_km = r.st_belowupstrbarriers_slopeclass22_km,
  st_belowupstrbarriers_slopeclass30_km = r.st_belowupstrbarriers_slopeclass30_km,
  wct_belowupstrbarriers_network_km = r.wct_belowupstrbarriers_network_km,
  wct_belowupstrbarriers_stream_km = r.wct_belowupstrbarriers_stream_km,
  wct_belowupstrbarriers_lakereservoir_ha = r.wct_belowupstrbarriers_lakereservoir_ha,
  wct_belowupstrbarriers_wetland_ha = r.wct_belowupstrbarriers_wetland_ha,
  wct_belowupstrbarriers_slopeclass03_km = r.wct_belowupstrbarriers_slopeclass03_km,
  wct_belowupstrbarriers_slopeclass05_km = r.wct_belowupstrbarriers_slopeclass05_km,
  wct_belowupstrbarriers_slopeclass08_km = r.wct_belowupstrbarriers_slopeclass08_km,
  wct_belowupstrbarriers_slopeclass15_km = r.wct_belowupstrbarriers_slopeclass15_km,
  wct_belowupstrbarriers_slopeclass22_km = r.wct_belowupstrbarriers_slopeclass22_km,
  wct_belowupstrbarriers_slopeclass30_km = r.wct_belowupstrbarriers_slopeclass30_km,
  ch_spawning_belowupstrbarriers_km = r.ch_spawning_belowupstrbarriers_km,
  ch_rearing_belowupstrbarriers_km = r.ch_rearing_belowupstrbarriers_km,
  co_spawning_belowupstrbarriers_km = r.co_spawning_belowupstrbarriers_km,
  co_rearing_belowupstrbarriers_km = r.co_rearing_belowupstrbarriers_km,
  sk_spawning_belowupstrbarriers_km = r.sk_spawning_belowupstrbarriers_km,
  sk_rearing_belowupstrbarriers_km = r.sk_rearing_belowupstrbarriers_km,
  st_spawning_belowupstrbarriers_km = r.st_spawning_belowupstrbarriers_km,
  st_rearing_belowupstrbarriers_km = r.st_rearing_belowupstrbarriers_km,
  wct_spawning_belowupstrbarriers_km = r.wct_spawning_belowupstrbarriers_km,
  wct_rearing_belowupstrbarriers_km = r.wct_rearing_belowupstrbarriers_km,
  all_spawning_belowupstrbarriers_km = r.all_spawning_belowupstrbarriers_km,
  all_rearing_belowupstrbarriers_km = r.all_rearing_belowupstrbarriers_km,
  all_spawningrearing_belowupstrbarriers_km = r.all_spawningrearing_belowupstrbarriers_km
FROM report r
WHERE p.:point_id = r.:point_id;

-- also, populate map tile column
WITH tile AS
(
    SELECT
      a.:point_id,
      b.map_tile_display_name
    FROM bcfishpass.:point_table a
    INNER JOIN whse_basemapping.dbm_mof_50k_grid b
    ON ST_Intersects(a.geom, b.geom)
    WHERE a.watershed_group_code = :'wsg'
)

UPDATE bcfishpass.:point_table p
SET dbm_mof_50k_grid = t.map_tile_display_name
FROM tile t
WHERE p.:point_id = t.:point_id;
