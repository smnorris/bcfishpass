-- create initial stream table based on provincial table
DROP TABLE IF EXISTS bcfishpass.segmented_streams CASCADE;

CREATE TABLE bcfishpass.segmented_streams
(
  segmented_stream_id serial primary key,
  linear_feature_id         bigint                           ,
  watershed_group_id        integer                           ,
  edge_type                 integer                           ,
  blue_line_key             integer                           ,
  watershed_key             integer                           ,
  fwa_watershed_code        character varying(143)           ,
  local_watershed_code      character varying(143)           ,
  watershed_group_code      character varying(4)             ,
  downstream_route_measure  double precision                 ,
  length_metre              double precision                 ,
  feature_source            character varying(15)            ,
  gnis_id                   integer                           ,
  gnis_name                 character varying(80)            ,
  left_right_tributary      character varying(7)             ,
  stream_order              integer                           ,
  stream_magnitude          integer                           ,
  waterbody_key             integer                           ,
  blue_line_key_50k         integer                           ,
  watershed_code_50k        character varying(45)            ,
  watershed_key_50k         integer                           ,
  watershed_group_code_50k  character varying(4)             ,
  gradient double precision GENERATED ALWAYS AS (round((((ST_Z (ST_PointN (geom, - 1)) - ST_Z
    (ST_PointN (geom, 1))) / ST_Length (geom))::numeric), 4)) STORED,
  feature_code character varying(10),
    wscode_ltree ltree GENERATED ALWAYS AS (REPLACE(REPLACE(fwa_watershed_code,
      '-000000', ''), '-', '.')::ltree) STORED,
  localcode_ltree ltree GENERATED ALWAYS AS
    (REPLACE(REPLACE(local_watershed_code, '-000000', ''), '-', '.')::ltree) STORED,
  upstream_route_measure double precision GENERATED ALWAYS AS (downstream_route_measure +
    ST_Length (geom)) STORED,
  geom geometry(LineStringZM,3005)
);