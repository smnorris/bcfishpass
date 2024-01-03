-- --------------
-- STREAMS
--
-- a copy of fwa_stream_networks_sp for breaking at barriers/observations
-- unique segmented stream id is created by combining blkey and measure
-- (with measure rounded to nearest mm, because some source stream lines are really short)
-- --------------

drop table if exists bcfishpass.streams cascade;

create table bcfishpass.streams
(
  segmented_stream_id       text
     generated always as (blue_line_key::text|| '.' || round((ST_M(ST_PointN(geom, 1))) * 1000)::text) stored primary key,

  -- standard fwa columns
  linear_feature_id        bigint                      ,
  edge_type                integer                     ,
  blue_line_key            integer                     ,
  watershed_key            integer                     ,
  watershed_group_code     character varying(4)        ,
  downstream_route_measure double precision
    generated always as (ST_M(ST_PointN(geom, 1))) STORED,
  length_metre             double precision
    generated always as (ST_Length(geom)) STORED         ,
  waterbody_key            integer                     ,
  wscode_ltree             ltree                       ,
  localcode_ltree          ltree                       ,
  gnis_name                 character varying(80)      ,
  stream_order              integer                    ,
  stream_magnitude          integer                    ,
  gradient                  double precision
    generated always as (round((((ST_Z (ST_PointN (geom, -1)) - ST_Z (ST_PointN (geom, 1))) / ST_Length (geom))::numeric), 4)) STORED,
  feature_code              character varying(10)      ,
  upstream_route_measure    double precision
    generated always as (ST_M(ST_PointN(geom, -1))) STORED,

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

create index streams_lfeatid_idx on bcfishpass.streams (linear_feature_id);
create index streams_blkey_idx on bcfishpass.streams (blue_line_key);
create index streams_wsg_idx on bcfishpass.streams (watershed_group_code);
create index streams_wbkey_idx on bcfishpass.streams (waterbody_key);
create index streams_wsc_gidx on bcfishpass.streams using gist (wscode_ltree);
create index streams_wsc_bidx on bcfishpass.streams using btree (wscode_ltree);
create index streams_lc_gidx on bcfishpass.streams using gist (localcode_ltree);
create index streams_lc_bidx on bcfishpass.streams using btree (localcode_ltree);
create index streams_geom_idx on bcfishpass.streams using gist (geom);