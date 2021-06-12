INSERT INTO bcfishpass.discharge_load
(watershed_feature_id, discharge_mm)
SELECT 
  p.watershed_feature_id,
  ST_Value(rast, st_pointonsurface(p.geom)) as discharge_mm
FROM whse_basemapping.fwa_watersheds_poly p 
INNER JOIN bcfishpass.discharge_raster
ON ST_intersects(p.geom, st_convexhull(rast))
WHERE p.watershed_group_code = :'wsg';