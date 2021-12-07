-- Insert stream data straight from whse_basemapping
-- include all streams:
-- - connected to network
-- - in BC
-- - not a side channel of unknown location
-- - in the watershed groups of interest
INSERT INTO bcfishpass.segmented_streams
 (linear_feature_id,
  watershed_group_id,
  edge_type,
  blue_line_key,
  watershed_key,
  fwa_watershed_code,
  local_watershed_code,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  feature_source,
  gnis_id,
  gnis_name,
  left_right_tributary,
  stream_order,
  stream_magnitude,
  waterbody_key,
  blue_line_key_50k,
  watershed_code_50k,
  watershed_key_50k,
  watershed_group_code_50k,
  feature_code,
  geom)
SELECT
  s.linear_feature_id,
  s.watershed_group_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.fwa_watershed_code,
  s.local_watershed_code,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.feature_source,
  s.gnis_id,
  s.gnis_name,
  s.left_right_tributary,
  s.stream_order,
  s.stream_magnitude,
  s.waterbody_key,
  s.blue_line_key_50k,
  s.watershed_code_50k,
  s.watershed_key_50k,
  s.watershed_group_code_50k,
  s.feature_code,
  s.geom
FROM whse_basemapping.fwa_stream_networks_sp s
WHERE
  s.watershed_group_code = :'wsg'
  AND s.wscode_ltree <@ '999' IS FALSE
  AND s.edge_type != 6010
  AND s.localcode_ltree IS NOT NULL
ORDER BY random();