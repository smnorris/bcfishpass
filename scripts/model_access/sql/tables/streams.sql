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
  
  -- precipitation, channel width, discharge models
  map_upstream integer,
  channel_width double precision,
  mad_m3s double precision,

  -- anthropogenic features downstream
  barriers_anthropogenic_dnstr text[],
  barriers_pscis_dnstr text[],
  barriers_dams_dnstr text[],
  barriers_dams_hydro_dnstr text[],
  barriers_remediated_dnstr text[],

  -- observations upstream
  obsrvtn_event_upstr bigint[],
  obsrvtn_species_codes_upstr text[],

  -- definite barriers downstream (per spp scenario)
  barriers_ch_cm_co_pk_sk_dnstr text[],
  barriers_st_dnstr text[],
  barriers_bt_dnstr text[],
  barriers_wct_dnstr text[],
  barriers_gr_dnstr text[],
  barriers_rb_dnstr text[],
  
  -- access models
  model_access_bt text,
  model_access_gr text,
  model_access_ch_cm_co_pk_sk text,
  model_access_rb text,
  model_access_st text,
  model_access_wct text,
  
  -- habitat models
  model_spawning_bt boolean,
  model_spawning_ch boolean,
  model_spawning_cm boolean,
  model_spawning_co boolean,
  model_spawning_pk boolean,
  model_spawning_sk boolean,
  model_spawning_st boolean,
  model_spawning_wct boolean,
  model_rearing_bt boolean,
  model_rearing_ch boolean,
  model_rearing_co boolean,
  model_rearing_sk boolean,
  model_rearing_st boolean,
  model_rearing_wct boolean,

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