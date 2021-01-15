-- temporary calculation of wetland areas until this is added to fwapg

ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS upstream_lake_ha double precision;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS upstream_reservoir_ha double precision;
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS upstream_wetland_ha double precision;

-- this takes 2min for lower nicola
WITH upstr_wb AS
(SELECT DISTINCT
  a.linear_feature_id,
  ST_Area(lake.geom) as area_lake,
  ST_Area(manmade.geom) as area_manmade,
  ST_Area(wetland.geom) as area_wetland
FROM bcfishpass.streams a
INNER JOIN whse_basemapping.fwa_stream_networks_sp b
ON FWA_Upstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    True,
    .02
   )
LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lake
ON b.waterbody_key = lake.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly manmade
ON b.waterbody_key = manmade.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_wetlands_poly wetland
ON b.waterbody_key = wetland.waterbody_key
WHERE b.waterbody_key IS NOT NULL
AND a.watershed_group_code = 'LNIC'
ORDER BY a.linear_feature_id
),

report as
(SELECT
  linear_feature_id,
  ROUND((SUM(COALESCE(uwb.area_lake, 0)) / 10000)::numeric, 2) AS total_lake_ha,
  ROUND((SUM(COALESCE(uwb.area_manmade, 0)) / 10000)::numeric, 2) AS total_reservoir_ha,
  ROUND((SUM(COALESCE(uwb.area_wetland, 0)) / 10000)::numeric, 2) AS total_wetland_ha
FROM upstr_wb uwb
GROUP BY linear_feature_id)

UPDATE bcfishpass.streams p
SET
  upstream_lake_ha = r.total_lake_ha,
  upstream_reservoir_ha = r.total_reservoir_ha,
  upstream_wetland_ha = r.total_wetland_ha
FROM report r
WHERE p.linear_feature_id = r.linear_feature_id;