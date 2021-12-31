-- --------------
-- SEGMENTED_STREAMS
--
-- a copy of fwa_stream_networks_sp for breaking at barriers/observations
-- unique segmented stream id is created by combining blkey and measure
-- (with measure rounded to nearest mm, because some source stream lines are really short)
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.segmented_streams
(
  segmented_stream_id       text
     GENERATED ALWAYS AS (blue_line_key::text|| '.' || round((downstream_route_measure) * 1000)::text) STORED PRIMARY KEY,
  linear_feature_id         bigint                           ,
  edge_type                 integer                          ,
  blue_line_key             integer                          ,
  watershed_key             integer                          ,
  watershed_group_code      character varying(4)             ,
  downstream_route_measure  double precision                 ,
  length_metre              double precision                 ,
  waterbody_key             integer                          ,
  wscode_ltree              ltree                            ,
  localcode_ltree           ltree                            ,
  gradient                  double precision
    GENERATED ALWAYS AS (round((((ST_Z (ST_PointN (geom, - 1)) - ST_Z (ST_PointN (geom, 1))) / ST_Length (geom))::numeric), 4)) STORED,
  upstream_route_measure    double precision
    GENERATED ALWAYS AS (downstream_route_measure + ST_Length (geom)) STORED,
  geom geometry(LineStringZM,3005)
);

