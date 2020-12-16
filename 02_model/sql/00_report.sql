-- add the reporting columns

ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS observedspp_dnstr text[];
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS observedspp_upstr text[];
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS stream_order integer;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS stream_magnitude integer;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS gradient double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS watershed_upstr_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass_03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass_05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass_08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass_15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass_22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass_30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass_03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass_05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass_08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass_15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass_22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass_30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass_03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass_05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass_08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass_15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass_22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass_30_km double precision;

-- run the report, updating new columns in existing table
WITH
spp_downstream AS
(
  SELECT
    {point_id},
    array_agg(species_code) as species_codes
  FROM
    (
      SELECT DISTINCT
        a.{point_id},
        unnest(species_codes) as species_code
      FROM {point_schema}.{point_table} a
      LEFT OUTER JOIN whse_fish.fiss_fish_obsrvtn_events fo
      ON a.blue_line_key = fo.blue_line_key
      AND a.downstream_route_measure > fo.downstream_route_measure
      ORDER BY {point_id}, species_code
    ) AS f
  GROUP BY {point_id}
),

spp_upstream AS
(
SELECT
  {point_id},
  array_agg(species_code) as species_codes
FROM
  (
    SELECT DISTINCT
      a.{point_id},
      unnest(species_codes) as species_code
    FROM {point_schema}.{point_table} a
    LEFT OUTER JOIN whse_fish.fiss_fish_obsrvtn_events fo
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
GROUP BY {point_id}
),

grade AS
(
SELECT
  a.{point_id},
  s.gradient,
  s.stream_order,
  s.stream_magnitude,
  s.upstream_area_ha
FROM {point_schema}.{point_table} a
INNER JOIN bcfishpass.streams s
ON a.linear_feature_id = s.linear_feature_id
AND a.downstream_route_measure > s.downstream_route_measure - .001
AND a.downstream_route_measure + .001 < s.upstream_route_measure
ORDER BY a.{point_id}, s.downstream_route_measure
),

upstr_wb AS
(SELECT DISTINCT
  a.{point_id},
  s.waterbody_key,
  s.accessibility_model_salmon,
  s.accessibility_model_steelhead,
  s.accessibility_model_wct,
  ST_Area(lake.geom) as area_lake,
  ST_Area(manmade.geom) as area_manmade,
  ST_Area(wetland.geom) as area_wetland
FROM {point_schema}.{point_table} a
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
    .02
   )
LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lake
ON s.waterbody_key = lake.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly manmade
ON s.waterbody_key = manmade.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_wetlands_poly wetland
ON s.waterbody_key = wetland.waterbody_key
WHERE s.waterbody_key IS NOT NULL
ORDER BY a.{point_id}
),

report AS
(SELECT
  a.{point_id},
  b.stream_order,
  b.stream_magnitude,
  b.gradient,
  b.upstream_area_ha AS watershed_upstr_ha,
  spd.species_codes as observedspp_dnstr,
  spu.species_codes as observedspp_upstr,

-- totals
  COALESCE(ROUND((SUM(ST_Length(s.geom)::numeric) / 1000), 2), 0) AS total_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))) / 1000)::numeric, 2), 0) AS total_stream_km,
  ROUND(COALESCE((SUM(uwb.area_lake) + SUM(uwb.area_manmade)) / 10000, 0)::numeric, 2) AS total_lakereservoir_ha,
  ROUND(COALESCE(SUM(uwb.area_wetland) / 10000, 0)::numeric, 2) AS total_wetland_ha,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= 0 AND s.gradient < .03) / 1000))::numeric, 2), 0) as total_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .03 AND s.gradient < .05) / 1000))::numeric, 2), 0) as total_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .05 AND s.gradient < .08) / 1000))::numeric, 2), 0) as total_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .08 AND s.gradient < .15) / 1000))::numeric, 2), 0) as total_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .15 AND s.gradient < .22) / 1000))::numeric, 2), 0) as total_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .22 AND s.gradient < .30) / 1000))::numeric, 2), 0) as total_slopeclass30_km,

-- salmon model
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS salmon_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS salmon_stream_km,
  ROUND(COALESCE((SUM(uwb.area_lake) FILTER (WHERE uwb.accessibility_model_salmon LIKE '%ACCESSIBLE%') + SUM(uwb.area_manmade) FILTER (WHERE uwb.accessibility_model_salmon LIKE '%ACCESSIBLE%')) / 10000, 0)::numeric, 2) AS salmon_lakereservoir_ha,
  ROUND(COALESCE((SUM(uwb.area_wetland) FILTER (WHERE uwb.accessibility_model_salmon LIKE '%ACCESSIBLE%')) / 10000, 0)::numeric, 2) AS salmon_wetland_ha,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= 0 AND s.gradient < .03)) / 1000))::numeric, 2), 0) as salmon_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as salmon_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as salmon_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as salmon_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as salmon_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as salmon_slopeclass30_km,

-- steelhead
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS steelhead_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS steelhead_stream_km,
  ROUND(COALESCE((SUM(uwb.area_lake) FILTER (WHERE uwb.accessibility_model_steelhead LIKE '%ACCESSIBLE%') + SUM(uwb.area_manmade) FILTER (WHERE uwb.accessibility_model_steelhead LIKE '%ACCESSIBLE%')) / 10000, 0)::numeric, 2) AS steelhead_lakereservoir_ha,
  ROUND(COALESCE((SUM(uwb.area_wetland) FILTER (WHERE uwb.accessibility_model_steelhead LIKE '%ACCESSIBLE%')) / 10000, 0)::numeric, 2) AS steelhead_wetland_ha,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= 0 AND s.gradient < .03)) / 1000))::numeric, 2), 0) as steelhead_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as steelhead_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as steelhead_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as steelhead_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as steelhead_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as steelhead_slopeclass30_km,

-- wct
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS wct_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS wct_stream_km,
  ROUND(COALESCE((SUM(uwb.area_lake) FILTER (WHERE uwb.accessibility_model_wct LIKE '%ACCESSIBLE%') + SUM(uwb.area_manmade) FILTER (WHERE uwb.accessibility_model_wct LIKE '%ACCESSIBLE%')) / 10000, 0)::numeric, 2) AS wct_lakereservoir_ha,
  ROUND(COALESCE((SUM(uwb.area_wetland) FILTER (WHERE uwb.accessibility_model_wct LIKE '%ACCESSIBLE%')) / 10000, 0)::numeric, 2) AS wct_wetland_ha,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= 0 AND s.gradient < .03)) / 1000))::numeric, 2), 0) as wct_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as wct_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as wct_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as wct_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as wct_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as wct_slopeclass30_km
FROM {point_schema}.{point_table} a
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
    .02
   )
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
LEFT OUTER JOIN spp_upstream spu
ON a.{point_id} = spu.{point_id}
LEFT OUTER JOIN spp_downstream spd
ON a.{point_id} = spd.{point_id}
LEFT OUTER JOIN grade b
ON a.{point_id} = b.{point_id}
LEFT OUTER JOIN upstr_wb uwb
ON a.{point_id} = uwb.{point_id}
WHERE a.watershed_group_code IN ('LNIC','BULK','ELKR','HORS')
GROUP BY a.{point_id}, b.stream_order, b.gradient, b.stream_magnitude, b.upstream_area_ha, spd.species_codes, spu.species_codes
)

UPDATE {point_schema}.{point_table} p
SET
  observedspp_dnstr = r.observedspp_dnstr,
  observedspp_upstr = r.observedspp_upstr,
  stream_order = r.stream_order,
  stream_magnitude = r.stream_magnitude,
  gradient = r.gradient,
  watershed_upstr_ha = r.watershed_upstr_ha,
  total_network_km = r.total_network_km,
  total_stream_km = r.total_stream_km,
  total_lakereservoir_ha = r.total_lakereservoir_ha,
  total_wetland_ha = r.total_wetland_ha,
  total_slopeclass03_km = r.total_slopeclass03_km,
  total_slopeclass05_km = r.total_slopeclass05_km,
  total_slopeclass08_km = r.total_slopeclass08_km,
  total_slopeclass15_km = r.total_slopeclass15_km,
  total_slopeclass22_km = r.total_slopeclass22_km,
  total_slopeclass30_km = r.total_slopeclass30_km,
  salmon_network_km = r.salmon_network_km,
  salmon_stream_km = r.salmon_stream_km,
  salmon_lakereservoir_ha = r.salmon_lakereservoir_ha,
  salmon_wetland_ha = r.salmon_wetland_ha,
  salmon_slopeclass03_km = r.salmon_slopeclass03_km,
  salmon_slopeclass05_km = r.salmon_slopeclass05_km,
  salmon_slopeclass08_km = r.salmon_slopeclass08_km,
  salmon_slopeclass15_km = r.salmon_slopeclass15_km,
  salmon_slopeclass22_km = r.salmon_slopeclass22_km,
  salmon_slopeclass30_km = r.salmon_slopeclass30_km,
  --salmon_belowupstrbarriers_network_km = r.salmon_belowupstrbarriers_network_km,
  --salmon_belowupstrbarriers_stream_km = r.salmon_belowupstrbarriers_stream_km,
  --salmon_belowupstrbarriers_lakereservoir_ha = r.salmon_belowupstrbarriers_lakereservoir_ha,
  --salmon_belowupstrbarriers_wetland_ha = r.salmon_belowupstrbarriers_wetland_ha,
  --salmon_belowupstrbarriers_slopeclass_03_km = r.salmon_belowupstrbarriers_slopeclass_03_km,
  --salmon_belowupstrbarriers_slopeclass_05_km = r.salmon_belowupstrbarriers_slopeclass_05_km,
  --salmon_belowupstrbarriers_slopeclass_08_km = r.salmon_belowupstrbarriers_slopeclass_08_km,
  --salmon_belowupstrbarriers_slopeclass_15_km = r.salmon_belowupstrbarriers_slopeclass_15_km,
  --salmon_belowupstrbarriers_slopeclass_22_km = r.salmon_belowupstrbarriers_slopeclass_22_km,
  --salmon_belowupstrbarriers_slopeclass_30_km = r.salmon_belowupstrbarriers_slopeclass_30_km,
  steelhead_network_km = r.steelhead_network_km,
  steelhead_stream_km = r.steelhead_stream_km,
  steelhead_lakereservoir_ha = r.steelhead_lakereservoir_ha,
  steelhead_wetland_ha = r.steelhead_wetland_ha,
  steelhead_slopeclass03_km = r.steelhead_slopeclass03_km,
  steelhead_slopeclass05_km = r.steelhead_slopeclass05_km,
  steelhead_slopeclass08_km = r.steelhead_slopeclass08_km,
  steelhead_slopeclass15_km = r.steelhead_slopeclass15_km,
  steelhead_slopeclass22_km = r.steelhead_slopeclass22_km,
  steelhead_slopeclass30_km = r.steelhead_slopeclass30_km,
  --steelhead_belowupstrbarriers_network_km = r.steelhead_belowupstrbarriers_network_km,
  --steelhead_belowupstrbarriers_stream_km = r.steelhead_belowupstrbarriers_stream_km,
  --steelhead_belowupstrbarriers_lakereservoir_ha = r.steelhead_belowupstrbarriers_lakereservoir_ha,
  --steelhead_belowupstrbarriers_wetland_ha = r.steelhead_belowupstrbarriers_wetland_ha,
  --steelhead_belowupstrbarriers_slopeclass_03_km = r.steelhead_belowupstrbarriers_slopeclass_03_km,
  --steelhead_belowupstrbarriers_slopeclass_05_km = r.steelhead_belowupstrbarriers_slopeclass_05_km,
  --steelhead_belowupstrbarriers_slopeclass_08_km = r.steelhead_belowupstrbarriers_slopeclass_08_km,
  --steelhead_belowupstrbarriers_slopeclass_15_km = r.steelhead_belowupstrbarriers_slopeclass_15_km,
  --steelhead_belowupstrbarriers_slopeclass_22_km = r.steelhead_belowupstrbarriers_slopeclass_22_km,
  --steelhead_belowupstrbarriers_slopeclass_30_km = r.steelhead_belowupstrbarriers_slopeclass_30_km,
  wct_network_km = r.wct_network_km,
  wct_stream_km = r.wct_stream_km,
  wct_lakereservoir_ha = r.wct_lakereservoir_ha,
  wct_wetland_ha = r.wct_wetland_ha,
  wct_slopeclass03_km = r.wct_slopeclass03_km,
  wct_slopeclass05_km = r.wct_slopeclass05_km,
  wct_slopeclass08_km = r.wct_slopeclass08_km,
  wct_slopeclass15_km = r.wct_slopeclass15_km,
  wct_slopeclass22_km = r.wct_slopeclass22_km,
  wct_slopeclass30_km = r.wct_slopeclass30_km
  --wct_belowupstrbarriers_network_km = r.wct_belowupstrbarriers_network_km,
  --wct_belowupstrbarriers_stream_km = r.wct_belowupstrbarriers_stream_km,
  --wct_belowupstrbarriers_lakereservoir_ha = r.wct_belowupstrbarriers_lakereservoir_ha,
  --wct_belowupstrbarriers_wetland_ha = r.wct_belowupstrbarriers_wetland_ha,
  --wct_belowupstrbarriers_slopeclass_03_km = r.wct_belowupstrbarriers_slopeclass_03_km,
  --wct_belowupstrbarriers_slopeclass_05_km = r.wct_belowupstrbarriers_slopeclass_05_km,
  --wct_belowupstrbarriers_slopeclass_08_km = r.wct_belowupstrbarriers_slopeclass_08_km,
  --wct_belowupstrbarriers_slopeclass_15_km = r.wct_belowupstrbarriers_slopeclass_15_km,
  --wct_belowupstrbarriers_slopeclass_22_km = r.wct_belowupstrbarriers_slopeclass_22_km,
  --wct_belowupstrbarriers_slopeclass_30_km = r.wct_belowupstrbarriers_slopeclass_30_km
FROM report r
WHERE p.{point_id} = r.{point_id};

COMMENT ON COLUMN {point_schema}.{point_table}.stream_order IS 'Order of FWA stream at point';
COMMENT ON COLUMN {point_schema}.{point_table}.stream_magnitude IS 'Magnitude of FWA stream at point';
COMMENT ON COLUMN {point_schema}.{point_table}.gradient IS 'Stream slope at point';
COMMENT ON COLUMN {point_schema}.{point_table}.watershed_upstr_ha IS 'Total watershed area upstream of point (approximate, does not include area of the fundamental watershed in which the point lies)';
COMMENT ON COLUMN {point_schema}.{point_table}.observedspp_dnstr IS 'Fish species observed downstream of point (on the same stream/blue_line_key)';
COMMENT ON COLUMN {point_schema}.{point_table}.observedspp_upstr IS 'Fish species observed anywhere upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.total_network_km IS 'Total length of stream network upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.total_stream_km IS 'Total length of streams and rivers upstream of point (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.total_lakereservoir_ha IS 'Total area lakes and reservoirs upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.total_wetland_ha IS 'Total area wetlands upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass03_km IS 'Total length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass05_km IS 'Total length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass08_km IS 'Total length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass15_km IS 'Total length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass22_km IS 'Total length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass30_km IS 'Total length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_network_km IS 'Salmon model, total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_stream_km IS 'Salmon model, total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_lakereservoir_ha IS 'Salmon model, total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_wetland_ha IS 'Salmon model, total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass03_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass05_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass08_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass15_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass22_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass30_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_network_km IS 'Salmon model, total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_stream_km IS 'Salmon model, total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_lakereservoir_ha IS 'Salmon model, total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_wetland_ha IS 'Salmon model, total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass_03_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass_05_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass_08_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass_15_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass_22_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass_30_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_network_km IS 'Steelhead model, total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_stream_km IS 'Steelhead model, total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_lakereservoir_ha IS 'Steelhead model, total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_wetland_ha IS 'Steelhead model, total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass03_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass05_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass08_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass15_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass22_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass30_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_network_km IS 'Steelhead model, total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_stream_km IS 'Steelhead model, total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_lakereservoir_ha IS 'Steelhead model, total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_wetland_ha IS 'Steelhead model, total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass_03_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass_05_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass_08_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass_15_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass_22_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass_30_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_network_km IS 'Westslope Cuthroat Trout model, total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_stream_km IS 'Westslope Cuthroat Trout model, total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_lakereservoir_ha IS 'Westslope Cuthroat Trout model, total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_wetland_ha IS 'Westslope Cuthroat Trout model, total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass03_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass05_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass08_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass15_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass22_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass30_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_network_km IS 'Westslope Cutthroat Trout model, total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_stream_km IS 'Westslope Cuthroat Trout model, total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_lakereservoir_ha IS 'Westslope Cutthroat Trout model, total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_wetland_ha IS 'Westslope Cutthroat Trout model, total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass_03_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass_05_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass_08_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass_15_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass_22_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass_30_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';