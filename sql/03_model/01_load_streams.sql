-- create initial stream table based on provincial table
DROP TABLE IF EXISTS bcfishpass.streams;

CREATE TABLE bcfishpass.streams
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

-- Insert stream data straight from whse_basemapping
-- include all streams:
-- - connected to network
-- - in BC
-- - not a side channel of unknown location
-- - in the watershed groups of interest
INSERT INTO bcfishpass.streams
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
  linear_feature_id,
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
  geom
FROM
  whse_basemapping.fwa_stream_networks_sp s
WHERE
  s.fwa_watershed_code NOT LIKE '999%%'
  AND s.edge_type != 6010
  AND s.localcode_ltree IS NOT NULL
  AND s.watershed_group_code IN ('BULK','HORS','LNIC','ELKR')
ORDER BY
  linear_feature_id;


CREATE INDEX ON bcfishpass.streams (linear_feature_id);
CREATE INDEX ON bcfishpass.streams (blue_line_key);
CREATE INDEX ON bcfishpass.streams (watershed_group_code);
CREATE INDEX ON bcfishpass.streams USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.streams USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.streams USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.streams USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.streams USING GIST (geom);

