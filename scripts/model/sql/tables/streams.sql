-- --------------
-- STREAMS
--
-- a copy of fwa_stream_networks_sp for breaking at barriers/observations
-- unique segmented stream id is created by combining blkey and measure
-- (with measure rounded to nearest mm, because some source stream lines are really short)
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.streams 
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
  upstream_route_measure    double precision
    GENERATED ALWAYS AS (ST_M(ST_PointN(geom, -1))) STORED,

  -- anthropogenic features downstream
  barriers_anthropogenic_dnstr bigint[],
  barriers_pscis_dnstr bigint[],
  barriers_remediated_dnstr bigint[],

  -- definite barriers downstream (per spp scenario)
  barriers_ch_co_sk_dnstr bigint[],
  barriers_ch_co_sk_b_dnstr bigint[],
  barriers_st_dnstr bigint[],
  barriers_pk_dnstr bigint[],
  barriers_cm_dnstr bigint[],
  barriers_bt_dnstr bigint[],
  barriers_wct_dnstr bigint[],
  barriers_gr_dnstr bigint[],
  barriers_rb_dnstr bigint[],

  -- observations upstream
  obsrvtn_pnt_distinct_upstr integer[],
  obsrvtn_species_codes_upstr text[],

  -- access models
  access_model_ch_co_sk text,
  access_model_ch_co_sk_b text,
  access_model_st text,
  access_model_wct text,
  access_model_pk text,
  access_model_cm text,
  access_model_bt text,
  access_model_gr text,
  access_model_rb text,

  -- habitat models and modelled flow/channel width
  channel_width double precision,
  mad_m3s double precision,
  spawning_model_ch boolean,
  spawning_model_co boolean,
  spawning_model_sk boolean,
  spawning_model_st boolean,
  spawning_model_wct boolean,
  rearing_model_ch boolean,
  rearing_model_co boolean,
  rearing_model_sk boolean,
  rearing_model_st boolean,
  rearing_model_wct boolean,

  geom geometry(LineStringZM,3005)
);
