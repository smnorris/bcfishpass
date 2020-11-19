
DROP TABLE IF EXISTS bcfishpass.modelled_stream_crossings;

CREATE TABLE bcfishpass.modelled_stream_crossings
(
  modelled_crossing_id serial primary key,
  modelled_crossing_type character varying(5),
  modelled_crossing_type_source text[],
  transport_line_id integer,
  ften_road_section_lines_id text,
  og_road_segment_permit_id integer,
  og_petrlm_dev_rd_pre06_pub_id integer,
  railway_track_id integer,
  linear_feature_id bigint,
  blue_line_key integer,
  downstream_route_measure double precision,
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code character varying(4),
  geom geometry(PointZM, 3005)
);