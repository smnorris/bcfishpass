-- Build a stream discharge table from the provided watershed discharge table
-- This could be run in-line when building the model but it takes a few seconds to process, just run it once

-- Note that only Bulkley and Horsefly watersheds currently have data, Lower Nicola is anticipated in 2021

DROP TABLE IF EXISTS foundry.fwa_streams_mad;

CREATE TABLE foundry.fwa_streams_mad
(
    linear_feature_id bigint primary key,
    watershed_group_code character varying(4),
    mad_m3s double precision
);

-- load streams with watershed code that matches the watershed polys
INSERT INTO foundry.fwa_streams_mad
(linear_feature_id, watershed_group_code, mad_m3s)
SELECT
  s.linear_feature_id,
  s.watershed_group_code,
  mad.mad_m3s
FROM whse_basemapping.fwa_stream_networks_sp s
INNER JOIN whse_basemapping.fwa_watersheds_poly w
ON s.wscode_ltree = w.wscode_ltree
AND s.localcode_ltree = w.localcode_ltree
AND s.watershed_group_code = w.watershed_group_code
LEFT OUTER JOIN foundry.fwa_watersheds_mad mad
ON w.watershed_feature_id = mad.watershed_feature_id
WHERE s.watershed_group_code IN ('BULK','HORS','LNIC')
ON CONFLICT DO NOTHING;


-- 535 streams (with local codes) don't get loaded above
-- add them with a spatial query
WITH stream_pts AS
(SELECT
  s.linear_feature_id,
  s.watershed_group_code,
  ST_PointOnSurface(s.geom) as geom
FROM whse_basemapping.fwa_stream_networks_sp s
LEFT OUTER JOIN foundry.fwa_streams_mad st
ON s.linear_feature_id = st.linear_feature_id
WHERE s.watershed_group_code IN ('BULK','HORS','LNIC')
AND st.linear_feature_id is null
AND s.fwa_watershed_code NOT LIKE '999%'
AND s.local_watershed_code IS NOT NULL)

INSERT INTO foundry.fwa_streams_mad
(linear_feature_id, watershed_group_code, mad_m3s)
SELECT
  p.linear_feature_id,
  p.watershed_group_code,
  mad.mad_m3s
FROM stream_pts p
INNER JOIN whse_basemapping.fwa_watersheds_poly w
ON ST_Intersects(p.geom, w.geom)
INNER JOIN foundry.fwa_watersheds_mad mad
ON w.watershed_feature_id = mad.watershed_feature_id
ON CONFLICT DO NOTHING;