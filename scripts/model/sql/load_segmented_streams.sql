-- Insert stream data straight from whse_basemapping
-- include all streams:
-- - connected to network
-- - in BC
-- - not a side channel of unknown location
-- - in the watershed groups of interest
INSERT INTO bcfishpass.segmented_streams
 (segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  wscode_ltree,
  localcode_ltree,
  geom)
SELECT
  s.linear_feature_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree,
  s.localcode_ltree,
  s.geom
FROM whse_basemapping.fwa_stream_networks_sp s
WHERE
  s.watershed_group_code = :'wsg'
  AND s.wscode_ltree <@ '999' IS FALSE
  AND s.edge_type != 6010
  AND s.localcode_ltree IS NOT NULL
ORDER BY random();
