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
     GENERATED ALWAYS AS (blue_line_key::text|| '.' || round((downstream_route_measure) * 1000)::text) STORED PRIMARY KEY,

  -- standard fwa columns
  linear_feature_id        bigint                      ,
  edge_type                integer                     ,
  blue_line_key            integer                     ,
  watershed_key            integer                     ,
  watershed_group_code     character varying(4)        ,
  downstream_route_measure double precision            ,
  length_metre             double precision            ,
  waterbody_key            integer                     ,
  wscode_ltree             ltree                       ,
  localcode_ltree          ltree                       ,
  gnis_name                 character varying(80)      ,
  stream_order              integer                    ,
  stream_magnitude          integer                    ,
  gradient                  double precision
    GENERATED ALWAYS AS (round((((ST_Z (ST_PointN (geom, - 1)) - ST_Z (ST_PointN (geom, 1))) / ST_Length (geom))::numeric), 4)) STORED,
  upstream_route_measure    double precision
    GENERATED ALWAYS AS (downstream_route_measure + ST_Length (geom)) STORED,

  -- barriers downstream
  barriers_majordams_dnstr integer[],
  barriers_subsurfaceflow_dnstr integer[],
  barriers_falls_dnstr bigint[],
  barriers_gradient_05_dnstr integer[],
  barriers_gradient_07_dnstr integer[],
  barriers_gradient_10_dnstr integer[],
  barriers_gradient_15_dnstr integer[],
  barriers_gradient_20_dnstr integer[],
  barriers_gradient_25_dnstr integer[],
  barriers_gradient_30_dnstr integer[],
  barriers_other_definite_dnstr integer[],
  barriers_anthropogenic_dnstr integer[],
  barriers_pscis_dnstr integer[],
  barriers_remediated_dnstr integer[],

  -- observations upstream
  obsrvtn_pnt_distinct_upstr integer[],
  obsrvtn_species_codes_upstr text[],

  -- access models
  access_model_ch_co_sk text,
  access_model_st text,
  access_model_wct text,
  access_model_pk text,
  access_model_cm text,

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
