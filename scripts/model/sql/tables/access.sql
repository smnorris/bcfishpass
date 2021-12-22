-- create various empty tables required for access model

-- --------------
-- BARRIER_LOAD
--
-- intermediate table for loading various barrier types to consistent structure/location before processing as barriers
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.barrier_load
(
    barrier_load_id int unique,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code character varying (4),
    geom geometry(Point, 3005),
    PRIMARY KEY (blue_line_key, downstream_route_measure)
);

-- --------------
-- SEGMENTED_STREAMS
--
-- a copy of fwa_stream_networks_sp for breaking at barriers/observations
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.segmented_streams
(
  segmented_stream_id serial primary key,
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
  gradient double precision GENERATED ALWAYS AS (round((((ST_Z (ST_PointN (geom, - 1)) - ST_Z
    (ST_PointN (geom, 1))) / ST_Length (geom))::numeric), 4)) STORED,
  upstream_route_measure double precision GENERATED ALWAYS AS (downstream_route_measure +
    ST_Length (geom)) STORED,
  geom geometry(LineStringZM,3005)
);

-- segmented stream id defaults to linear_feature_id, increment from max id present in streams table
ALTER SEQUENCE bcfishpass.segmented_streams_segmented_stream_id_seq AS bigint;
ALTER SEQUENCE bcfishpass.segmented_streams_segmented_stream_id_seq start 868144440;

-- --------------
-- BREAKPOINTS
--
-- holds all barriers/observations/other where streams are to be broken
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.breakpoints
(
  blue_line_key integer,
  downstream_route_measure double precision,
  primary key (blue_line_key, downstream_route_measure)
);


-- --------------
-- OBSERVATIONS_LOAD
--
-- initial load target for all latest observation data
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.observations_load
(
  fish_obsrvtn_pnt_distinct_id integer primary key,
  linear_feature_id         bigint                           ,
  blue_line_key             integer                          ,
  wscode_ltree ltree                                         ,
  localcode_ltree ltree                                      ,
  downstream_route_measure  double precision                 ,
  watershed_group_code      character varying(4)             ,
  species_codes text[]                                      ,
  observation_ids int[] ,
  geom geometry(PointZM, 3005)
);

-- --------------
-- OBSERVATIONS
--
-- observation data to be used in model
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.observations
(
  fish_obsrvtn_pnt_distinct_id integer primary key,
  linear_feature_id         bigint                           ,
  blue_line_key             integer                          ,
  wscode_ltree ltree                                         ,
  localcode_ltree ltree                                      ,
  downstream_route_measure  double precision                 ,
  watershed_group_code      character varying(4)             ,
  species_codes text[]                                      ,
  observation_ids int[] ,
  geom geometry(PointZM, 3005)
);

CREATE INDEX IF NOT EXISTS obsrvtn_linear_feature_id_idx ON bcfishpass.observations (linear_feature_id);
CREATE INDEX IF NOT EXISTS obsrvtn_blue_line_key_idx ON bcfishpass.observations (blue_line_key);
CREATE INDEX IF NOT EXISTS obsrvtn_watershed_group_code_idx ON bcfishpass.observations (watershed_group_code);
CREATE INDEX IF NOT EXISTS obsrvtn_wsc_gidx ON bcfishpass.observations USING GIST (wscode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_wsc_bidx ON bcfishpass.observations USING BTREE (wscode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_lc_gidx ON bcfishpass.observations USING GIST (localcode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_lc_bidx ON bcfishpass.observations USING BTREE (localcode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_geom_idx ON bcfishpass.observations USING GIST (geom);


-- --------------
-- OBSERVATIONS_UPSTR
--
-- lookup relating streams to observations upstream
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.observations_upstr
(
  blue_line_key integer,
  downstream_route_measure double precision,
  watershed_group_code character varying(4),
  obsrvtn_pnt_distinct_upstr integer[],
  obsrvtn_species_codes_upstr text[]
);

CREATE INDEX IF NOT EXISTS obsrvtnupstr_rte_idx ON bcfishpass.observations_upstr (blue_line_key, downstream_route_measure);
