insert into bcfishpass.modelled_stream_crossings (
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
select
 modelled_crossing_id,
 modelled_crossing_type,
 string_to_array(modelled_crossing_type_source, '; ') as modelled_crossing_type_source,
 transport_line_id,
 ften_road_section_lines_id,
 og_road_segment_permit_id,
 og_petrlm_dev_rd_pre06_pub_id,
 railway_track_id,
 linear_feature_id,
 blue_line_key,
 downstream_route_measure,
 wscode_ltree::ltree,
 localcode_ltree::ltree,
 watershed_group_code,
 geom
from bcfishpass.modelled_stream_crossings_archive;