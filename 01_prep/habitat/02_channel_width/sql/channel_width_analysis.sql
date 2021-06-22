-- Create table for channel width analysis/modelling, holding all measured values 
-- (measured in field and as mapped in FWA)
-- Output is used to derive formula for estimating channel width


DROP TABLE IF EXISTS bcfishpass.channel_width_analysis;

CREATE TABLE bcfishpass.channel_width_analysis
(
  channel_width_id serial primary key,
  stream_sample_site_id integer,
  stream_crossing_id integer,
  source text,
  channel_width double precision,
  linear_feature_id bigint,
  blue_line_key integer,
  downstream_route_measure double precision,
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code text,
  
  -- predictor variables
  stream_order integer,
  stream_magnitude integer,
  gradient double precision,
  upstream_area double precision,
  upstream_area_lake double precision,
  upstream_area_manmade double precision,
  upstream_area_wetland double precision,
  elevation double precision, 
  map integer,
  map_upstream integer,
  ecoregion_code text,
  ecosection_code text,
  zone text
);


-- combine measurements from all 3 sources
WITH measurements AS
(
SELECT
  e.stream_sample_site_id,
  NULL as stream_crossing_id,
  'FISS' as source,
  e.linear_feature_id,
  e.blue_line_key,
  e.downstream_route_measure,
  p.channel_width
FROM bcfishpass.fiss_stream_sample_sites_events_sp e
INNER JOIN whse_fish.fiss_stream_sample_sites_sp p
ON e.stream_sample_site_id = p.stream_sample_site_id
WHERE p.channel_width IS NOT NULL
UNION ALL
SELECT
  NULL as stream_sample_site_id,
  e.stream_crossing_id,
  'PSCIS' as source,
  e.linear_feature_id,
  e.blue_line_key,
  e.downstream_route_measure,
  a.downstream_channel_width as channel_width
FROM bcfishpass.pscis_events_sp e
LEFT OUTER JOIN whse_fish.pscis_assessment_svw a
ON e.stream_crossing_id = a.stream_crossing_id
WHERE a.downstream_channel_width IS NOT NULL
UNION ALL
SELECT 
  NULL as stream_sample_site_id,
  NULL as stream_crossing_id,
  'FWA' as source,
  e.linear_feature_id,
  s.blue_line_key,
  s.downstream_route_measure,
  e.channel_width_mapped as channel_width
FROM bcfishpass.channel_width_mapped e
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON e.linear_feature_id = s.linear_feature_id
)

-- join to streams, get stream info, overlay with some stuff, insert results

INSERT INTO bcfishpass.channel_width_analysis
( stream_sample_site_id,
  stream_crossing_id,
  source,
  channel_width,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  stream_order,
  stream_magnitude,
  gradient,
  elevation,
  upstream_area,
  upstream_area_lake,
  upstream_area_manmade,
  upstream_area_wetland,
  --map,
  --map_upstream,
  ecoregion_code,
  ecosection_code,
  zone
)

SELECT 
  m.stream_sample_site_id,
  m.stream_crossing_id,
  m.source,
  m.channel_width,
  m.linear_feature_id,
  m.blue_line_key,
  m.downstream_route_measure,
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  ROUND((ST_Z(ST_PointN(s.geom, - 1)))::numeric) as elevation,
  coalesce(ua.upstream_area, 0) as upstream_area,
  coalesce(uwb.upstream_area_lake, 0) as upstream_area_lake,
  coalesce(uwb.upstream_area_manmade, 0) as upstream_area_manmade,
  coalesce(uwb.upstream_area_wetland, 0) as upstream_area_wetland,
  es.parent_ecoregion_code as ecoregion_code,
  es.ecosection_code,
  bec.zone
FROM measurements m
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON m.linear_feature_id = s.linear_feature_id
LEFT OUTER JOIN whse_basemapping.fwa_watersheds_poly w
ON s.wscode_ltree = w.wscode_ltree AND s.localcode_ltree = w.localcode_ltree
LEFT OUTER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
ON w.watershed_feature_id = ua.watershed_feature_id
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies_upstream_area uwb
ON w.watershed_feature_id = uwb.watershed_feature_id
LEFT OUTER JOIN whse_terrestrial_ecology.erc_ecosections_sp es
ON ST_Intersects(ST_PointOnSurface(s.geom), es.geom)
LEFT OUTER JOIN whse_forest_vegetation.bec_biogeoclimatic_poly bec
ON ST_Intersects(ST_PointOnSurface(s.geom), bec.geom);

-- load map values.
-- this can be added to above query 
/*UPDATE bcfishpass.channel_width_analysis cw
SET
  map = map.map,
  map_upstream = map.map_upstream --added2
FROM bcfishpass.mean_annual_precip map
WHERE cw.wscode_ltree = map.wscode_ltree AND
cw.localcode_ltree = map.localcode_ltree;
*/