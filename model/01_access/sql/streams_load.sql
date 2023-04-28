-- Insert stream data straight from whse_basemapping
-- include all streams:
-- - connected to network
-- - in BC
-- - not a side channel of unknown location
-- - in the watershed group provided as parameter

INSERT INTO bcfishpass.streams
 (linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  waterbody_key,
  wscode_ltree,
  localcode_ltree,
  gnis_name,
  stream_order,
  stream_magnitude,
  feature_code,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  geom)
SELECT
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.waterbody_key,
  s.wscode_ltree,
  s.localcode_ltree,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.feature_code,
  ua.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  p.map_upstream,
  cw.channel_width,
  mad.mad_m3s,
  s.geom
FROM whse_basemapping.fwa_stream_networks_sp s
LEFT OUTER JOIN whse_basemapping.fwa_streams_watersheds_lut l
ON s.linear_feature_id = l.linear_feature_id
INNER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
ON l.watershed_feature_id = ua.watershed_feature_id
LEFT OUTER JOIN bcfishpass.mean_annual_precip p ON s.wscode_ltree = p.wscode_ltree AND s.localcode_ltree = p.localcode_ltree
LEFT OUTER JOIN bcfishpass.channel_width cw ON s.linear_feature_id = cw.linear_feature_id
LEFT OUTER JOIN bcfishpass.discharge mad ON s.linear_feature_id = mad.linear_feature_id
WHERE
  s.watershed_group_code = :'wsg'
  AND s.wscode_ltree <@ '999' IS FALSE
  AND s.edge_type != 6010
  AND s.localcode_ltree IS NOT NULL
  AND s.linear_feature_id NOT IN (832498864, 832474945); -- exclude bad data