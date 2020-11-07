-- total number of crossings by road data source
SELECT
  count(*) filter (where transport_line_id IS NOT NULL) as src_ften,
  count(*) filter (where transport_line_id IS NULL and ften_road_section_lines_id IS NOT NULL) as src_ften,
  count(*) filter (where transport_line_id IS NULL and ften_road_section_lines_id IS NULL AND og_road_segment_permit_id IS NOT NULL) as src_ogcpermit,
  count(*) filter (where transport_line_id IS NULL and ften_road_section_lines_id IS NULL AND og_road_segment_permit_id IS NULL AND og_petrlm_dev_rd_pre06_pub_id IS NOT NULL) as src_ogcpre06
FROM fish_passage.modelled_stream_crossings;