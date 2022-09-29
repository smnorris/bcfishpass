-- --------------
-- STREAMS
--
-- a copy of fwa_stream_networks_sp for breaking at barriers/observations
-- unique segmented stream id is created by combining blkey and measure
-- (with measure rounded to nearest mm, because some source stream lines are really short)
-- --------------

DROP TABLE IF EXISTS bcfishpass.streams;

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
  
  -- precipitation, channel width, discharge models
  map_upstream integer,
  channel_width double precision,
  mad_m3s double precision,

  -- anthropogenic features downstream
  barriers_anthropogenic_dnstr text[],
  barriers_pscis_dnstr text[],
  barriers_remediated_dnstr text[],

  -- definite barriers downstream (per spp scenario)
  barriers_ch_co_sk_dnstr text[],
  barriers_ch_co_sk_b_dnstr text[],
  barriers_st_dnstr text[],
  barriers_bt_dnstr text[],
  barriers_wct_dnstr text[],
  barriers_gr_dnstr text[],
  barriers_rb_dnstr text[],

  -- observations upstream
  obsrvtn_pnt_distinct_upstr integer[],
  obsrvtn_species_codes_upstr text[],

  -- access models
  access_model_ch_co_sk text,
  access_model_ch_co_sk_b text,
  access_model_st text,
  access_model_wct text,
  access_model_bt text,
  access_model_gr text,
  access_model_rb text,

  -- habitat models
  spawning_model_ch boolean,
  spawning_model_cm boolean,
  spawning_model_co boolean,
  spawning_model_pk boolean,
  spawning_model_sk boolean,
  spawning_model_st boolean,
  spawning_model_wct boolean,
  spawning_model_bt boolean,
  
  rearing_model_ch boolean,
  rearing_model_co boolean,
  rearing_model_sk boolean,
  rearing_model_st boolean,
  rearing_model_wct boolean,
  rearing_model_bt boolean,

  geom geometry(LineStringZM,3005)
);
