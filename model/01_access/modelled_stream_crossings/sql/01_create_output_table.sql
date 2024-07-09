DROP TABLE IF EXISTS bcfishpass.modelled_stream_crossings_build;

CREATE TABLE bcfishpass.modelled_stream_crossings_build
(
  modelled_crossing_id serial primary key,
  modelled_crossing_type character varying(5),
  modelled_crossing_type_source text[],
  transport_line_id integer,
  ften_road_section_lines_id integer,
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

CREATE INDEX ON bcfishpass.modelled_stream_crossings_build (transport_line_id);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build (ften_road_section_lines_id);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build (og_road_segment_permit_id);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build (og_petrlm_dev_rd_pre06_pub_id);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build (railway_track_id);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build (blue_line_key);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build (linear_feature_id);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build USING GIST (geom);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_build USING BTREE (localcode_ltree);


DROP TABLE IF EXISTS bcfishpass.modelled_stream_crossings_output;

CREATE TABLE bcfishpass.modelled_stream_crossings_output
(
  temp_id integer,
  modelled_crossing_id serial primary key,
  modelled_crossing_type character varying(5),
  modelled_crossing_type_source text[],
  transport_line_id integer,
  ften_road_section_lines_id integer,
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

SELECT setval('bcfishpass.modelled_stream_crossings_output_modelled_crossing_id_seq', (SELECT max(modelled_crossing_id) FROM bcfishpass.modelled_stream_crossings));

CREATE INDEX ON bcfishpass.modelled_stream_crossings_output (temp_id);