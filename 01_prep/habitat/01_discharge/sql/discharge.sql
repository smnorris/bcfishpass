-- Join discharge per wsd to streams to create per-linear_feature_id discharge table

WITH stream_pts AS
(SELECT
  linear_feature_id,
  watershed_group_code,
  ST_PointOnSurface(geom) as geom
FROM whse_basemapping.fwa_stream_networks_sp
WHERE watershed_group_code = :'wsg'
AND fwa_watershed_code NOT LIKE '999%'
AND local_watershed_code IS NOT NULL)

INSERT INTO bcfishpass.discharge
(linear_feature_id, watershed_group_code, mad_mm, mad_m3s)
SELECT
  p.linear_feature_id,
  p.watershed_group_code,
  mad.mad_mm,
  mad.mad_m3s
FROM stream_pts p
INNER JOIN whse_basemapping.fwa_watersheds_poly w
ON ST_Intersects(p.geom, w.geom)
INNER JOIN bcfishpass.discharge_wsd mad
ON w.watershed_feature_id = mad.watershed_feature_id
ON CONFLICT DO NOTHING;