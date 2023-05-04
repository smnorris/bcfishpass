-- --------------
-- STREAMS
--
-- a copy of fwa_stream_networks_sp for breaking at barriers/observations
-- unique segmented stream id is created by combining blkey and measure
-- (with measure rounded to nearest mm, because some source stream lines are really short)
-- --------------

DROP TABLE IF EXISTS bcfishpass.streams CASCADE;

CREATE TABLE bcfishpass.streams 
(
  segmented_stream_id       text
     GENERATED ALWAYS AS (blue_line_key::text|| '.' || round((ST_M(ST_PointN(geom, 1))) * 1000)::text) STORED PRIMARY KEY,

  -- standard fwa columns
  linear_feature_id        bigint                      ,
  edge_type                integer                     ,
  blue_line_key            integer                     ,
  watershed_key            integer                     ,
  watershed_group_code     character varying(4)        ,
  downstream_route_measure double precision
    GENERATED ALWAYS AS (ST_M(ST_PointN(geom, 1))) STORED,
  length_metre             double precision
    GENERATED ALWAYS AS (ST_Length(geom)) STORED         ,
  waterbody_key            integer                     ,
  wscode_ltree             ltree                       ,
  localcode_ltree          ltree                       ,
  gnis_name                 character varying(80)      ,
  stream_order              integer                    ,
  stream_magnitude          integer                    ,
  gradient                  double precision
    GENERATED ALWAYS AS (round((((ST_Z (ST_PointN (geom, -1)) - ST_Z (ST_PointN (geom, 1))) / ST_Length (geom))::numeric), 4)) STORED,
  feature_code              character varying(10)      ,
  upstream_route_measure    double precision
    GENERATED ALWAYS AS (ST_M(ST_PointN(geom, -1))) STORED,

  -- value added fwapg columns
  upstream_area_ha double precision,
  stream_order_parent integer,

  -- max stream order associated with blkey (for scale based filtering)
  stream_order_max integer,

  -- precip/cw/discharge
  map_upstream integer,
  channel_width double precision,
  mad_m3s double precision,
  
  geom geometry(LineStringZM,3005)
);

CREATE INDEX streams_lfeatid_idx ON bcfishpass.streams (linear_feature_id);
CREATE INDEX streams_blkey_idx ON bcfishpass.streams (blue_line_key);
CREATE INDEX streams_wsg_idx ON bcfishpass.streams (watershed_group_code);
CREATE INDEX streams_wbkey_idx ON bcfishpass.streams (waterbody_key);
CREATE INDEX streams_wsc_gidx ON bcfishpass.streams USING GIST (wscode_ltree);
CREATE INDEX streams_wsc_bidx ON bcfishpass.streams USING BTREE (wscode_ltree);
CREATE INDEX streams_lc_gidx ON bcfishpass.streams USING GIST (localcode_ltree);
CREATE INDEX streams_lc_bidx ON bcfishpass.streams USING BTREE (localcode_ltree);
CREATE INDEX streams_geom_idx ON bcfishpass.streams USING GIST (geom);