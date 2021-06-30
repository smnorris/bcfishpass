-- calculated area-weighted discharge and convert to m3/s for given watershed group
-- near instant for some groups (GUIC), extremely slow for others

-- load watershed group
INSERT INTO bcfishpass.discharge_wsd
(
  watershed_feature_id,
  watershed_group_code,
  mad_mm,
  mad_m3s
)

-- get raw discharge values from discharge_load (result of wsd overlay with raster)
WITH src AS
(
  SELECT
    a.*,
    b.wscode_ltree,
    b.localcode_ltree,
    b.geom
  FROM bcfishpass.discharge_load a
  INNER JOIN whse_basemapping.fwa_watersheds_poly b
  ON a.watershed_feature_id = b.watershed_feature_id
  WHERE b.watershed_group_code = :'wsg'
),

-- calculate weighted average of discharge for all area upstream of given wsd polygon
weighted_avg AS
(
SELECT
  a.watershed_feature_id,
  b.watershed_feature_id as id_up,
  b.discharge_mm,
  ua.upstream_area,
  ST_Area(uw.geom) as area,
  ST_Area(uw.geom) / upstream_area as pct,
  (ST_Area(uw.geom) / upstream_area) * b.discharge_mm as weighted_discharge,
  a.geom
FROM src a
INNER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
ON a.watershed_feature_id = ua.watershed_feature_id
INNER JOIN whse_basemapping.fwa_watersheds_poly uw
ON FWA_Upstream(a.wscode_ltree, a.localcode_ltree, uw.wscode_ltree, uw.localcode_ltree)
INNER JOIN bcfishpass.discharge_load b
ON uw.watershed_feature_id = b.watershed_feature_id
)

-- populate output with the area-weighted average mm discharge and also convert to m3s
SELECT
  a.watershed_feature_id,
  w.watershed_group_code,
  round(sum(weighted_discharge)::numeric, 5) as mad_mm,
  round(((sum(weighted_discharge) * ua.upstream_area) / 31536000000.0)::numeric, 5) as mad_m3s  -- m3s = (mm * m2 upstream area) / (1000mm/m * 365d/y * 24h/d * 3600s/h)
FROM weighted_avg a
INNER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
ON a.watershed_feature_id = ua.watershed_feature_id
INNER JOIN whse_basemapping.fwa_watersheds_poly w
ON ua.watershed_feature_id = w.watershed_feature_id
GROUP BY a.watershed_feature_id, w.watershed_group_code, ua.upstream_area;