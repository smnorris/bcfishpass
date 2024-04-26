-- match modelled_stream_crossings modelled_crossing_id to modelled_crossing_id in bcfishpass.modelled_stream_crossings_archive
-- match is done for crossings within 10m distance in any direction
-- (rather than matching on blue_line_key and measure, just in case the FWA stream has changed)

WITH matched AS
(
    SELECT
      a.modelled_crossing_id,
      a.modelled_crossing_type,
      a.modelled_crossing_type_source,
      a.transport_line_id,
      a.ften_road_section_lines_id,
      a.og_road_segment_permit_id,
      a.og_petrlm_dev_rd_pre06_pub_id,
      a.railway_track_id,
      a.linear_feature_id,
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      a.watershed_group_code,
      a.geom,
      nn.modelled_crossing_id as archive_id,
      nn.dist
    FROM bcfishpass.modelled_stream_crossings_build a
    CROSS JOIN LATERAL
    (SELECT
       modelled_crossing_id,
       ST_Distance(a.geom, b.geom) as dist
     FROM bcfishpass.modelled_stream_crossings b
     ORDER BY a.geom <-> b.geom
     LIMIT 1) as nn
    WHERE nn.dist < 10
)

-- be sure to only return one match
INSERT INTO bcfishpass.modelled_stream_crossings_output
(
  temp_id,
  modelled_crossing_id,
  modelled_crossing_type,
  modelled_crossing_type_source,
  transport_line_id,
  ften_road_section_lines_id,
  og_road_segment_permit_id,
  og_petrlm_dev_rd_pre06_pub_id,
  railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
)
SELECT DISTINCT ON (archive_id)
  modelled_crossing_id as temp_id,
  archive_id as modelled_crossing_id,
  modelled_crossing_type,
  modelled_crossing_type_source,
  transport_line_id,
  ften_road_section_lines_id,
  og_road_segment_permit_id,
  og_petrlm_dev_rd_pre06_pub_id,
  railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
FROM matched m
ORDER BY archive_id, dist;

-- now insert records that did not get matched
INSERT INTO bcfishpass.modelled_stream_crossings_output
(
  temp_id,
  modelled_crossing_type,
  modelled_crossing_type_source,
  transport_line_id,
  ften_road_section_lines_id,
  og_road_segment_permit_id,
  og_petrlm_dev_rd_pre06_pub_id,
  railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
)
SELECT
  modelled_crossing_id AS temp_id,
  modelled_crossing_type,
  modelled_crossing_type_source,
  transport_line_id,
  ften_road_section_lines_id,
  og_road_segment_permit_id,
  og_petrlm_dev_rd_pre06_pub_id,
  railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
FROM bcfishpass.modelled_stream_crossings_build
WHERE modelled_crossing_id NOT IN (SELECT temp_id FROM bcfishpass.modelled_stream_crossings_output);

ALTER TABLE bcfishpass.modelled_stream_crossings_output DROP COLUMN temp_id;
