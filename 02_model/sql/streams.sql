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
  upstream_area_ha double precision,
  upstream_lake_ha double precision,
  upstream_reservoir_ha double precision,
  upstream_wetland_ha double precision,
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
  upstream_area_ha,
  upstream_lake_ha,
  upstream_reservoir_ha,
  upstream_wetland_ha,
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
  s.upstream_area_ha,
  s.upstream_lake_ha,
  s.upstream_reservoir_ha,
  s.upstream_wetland_ha,
  s.geom
FROM whse_basemapping.fwa_stream_networks_sp s
INNER JOIN bcfishpass.watershed_groups g
ON s.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
WHERE
  s.fwa_watershed_code NOT LIKE '999%%'
  AND s.edge_type != 6010
  AND s.localcode_ltree IS NOT NULL
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
