-- Join discharge per wsd to streams to create per-linear_feature_id discharge table
-- For best results, this is a two step process:

-- Step 1 - load streams with watershed code that matches the watershed polys
-- This is not a 1:1 relationship, order by distance from stream centre-point to
-- poly centorid to find best match
INSERT INTO bcfishpass.discharge
(linear_feature_id, watershed_group_code, mad_mm, mad_m3s)
SELECT DISTINCT ON (linear_feature_id)
  s.linear_feature_id,
  s.watershed_group_code,
  mad.mad_mm,
  mad.mad_m3s
FROM whse_basemapping.fwa_stream_networks_sp s
INNER JOIN whse_basemapping.fwa_watersheds_poly w
ON (s.wscode_ltree = w.wscode_ltree AND
    s.localcode_ltree = w.localcode_ltree AND
    s.watershed_group_code = w.watershed_group_code)
INNER JOIN bcfishpass.discharge03_wsd mad
ON w.watershed_feature_id = mad.watershed_feature_id
WHERE s.watershed_group_code = :'wsg'
ORDER BY s.linear_feature_id, ST_Distance(ST_LineInterpolatePoint(s.geom, .5), ST_PointOnSurface(w.geom))
ON CONFLICT DO NOTHING;


-- Step 2 - many streams do not get loaded with above watershed code join,
-- join them to watersheds via a spatial intersection
WITH stream_pts AS
(
  SELECT
    s.linear_feature_id,
    s.watershed_group_code,
    ST_LineInterpolatePoint(s.geom, .5) as geom
  FROM whse_basemapping.fwa_stream_networks_sp s
  LEFT OUTER JOIN bcfishpass.discharge d
  ON s.linear_feature_id = d.linear_feature_id
  WHERE d.linear_feature_id IS NULL
  AND s.watershed_group_code = :'wsg'
  AND s.fwa_watershed_code NOT LIKE '999%'
  AND s.local_watershed_code IS NOT NULL
)

INSERT INTO bcfishpass.discharge
(
  linear_feature_id,
  watershed_group_code,
  mad_mm,
  mad_m3s
)
SELECT
  p.linear_feature_id,
  p.watershed_group_code,
  mad.mad_mm,
  mad.mad_m3s
FROM stream_pts p
INNER JOIN whse_basemapping.fwa_watersheds_poly w
ON ST_Intersects(p.geom, w.geom)
INNER JOIN bcfishpass.discharge03_wsd mad
ON w.watershed_feature_id = mad.watershed_feature_id
ON CONFLICT DO NOTHING;