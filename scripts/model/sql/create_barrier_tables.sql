-- records from crossings table that are barriers and potential barriers
DROP TABLE IF EXISTS bcfishpass.barriers_anthropogenic CASCADE;
CREATE TABLE bcfishpass.barriers_anthropogenic
(
    aggregated_crossings_id             integer         PRIMARY KEY ,
    stream_crossing_id                  integer              ,
    dam_id                              integer              ,
    modelled_crossing_id                integer              ,
    crossing_source                     text                 ,
    pscis_status                        text                 ,
    crossing_type_code                  text                 ,
    crossing_subtype_code               text                 ,
    modelled_crossing_type_source       text[]               ,
    barrier_status                      text                 ,
    wcrp_barrier_type                   text                 ,
    linear_feature_id                   integer              ,
    blue_line_key                       integer              ,
    downstream_route_measure            double precision     ,
    wscode_ltree                        ltree                ,
    localcode_ltree                     ltree                ,
    watershed_group_code                text                 ,
    geom                                geometry(Point,3005)
);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (stream_crossing_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (dam_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (modelled_crossing_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING GIST (geom);


-- falls
DROP TABLE IF EXISTS bcfishpass.barriers_falls CASCADE;
CREATE TABLE bcfishpass.barriers_falls
(
    barriers_falls_id serial primary key,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    UNIQUE (blue_line_key, downstream_route_measure)
);
CREATE INDEX ON bcfishpass.barriers_falls (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_falls (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_falls (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_falls USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_falls USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_falls USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_falls USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_falls USING GIST (geom);


-- gradient 15
DROP TABLE IF EXISTS bcfishpass.barriers_gradient_15 CASCADE;
CREATE TABLE bcfishpass.barriers_gradient_15
(
    barriers_gradient_15_id serial primary key,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    -- add a unique constraint so that we don't have equivalent barriers messing up subsequent joins
    UNIQUE (blue_line_key, downstream_route_measure)
);
CREATE INDEX ON bcfishpass.barriers_gradient_15 (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_gradient_15 (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_gradient_15 (blue_line_key, downstream_route_measure);
CREATE INDEX ON bcfishpass.barriers_gradient_15 (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING GIST (geom);


-- gradient 20
DROP TABLE IF EXISTS bcfishpass.barriers_gradient_20 CASCADE;
CREATE TABLE bcfishpass.barriers_gradient_20
(
    barriers_gradient_20_id serial primary key,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    -- add a unique constraint so that we don't have equivalent barriers messing up subsequent joins
    UNIQUE (blue_line_key, downstream_route_measure)
);
CREATE INDEX ON bcfishpass.barriers_gradient_20 (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_gradient_20 (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_gradient_20 (blue_line_key, downstream_route_measure);
CREATE INDEX ON bcfishpass.barriers_gradient_20 (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING GIST (geom);


-- gradient 30
DROP TABLE IF EXISTS bcfishpass.barriers_gradient_30 CASCADE;
CREATE TABLE bcfishpass.barriers_gradient_30
(
    barriers_gradient_30_id serial primary key,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    -- add a unique constraint so that we don't have equivalent barriers messing up subsequent joins
    UNIQUE (blue_line_key, downstream_route_measure)
);
CREATE INDEX ON bcfishpass.barriers_gradient_30 (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_gradient_30 (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_gradient_30 (blue_line_key, downstream_route_measure);
CREATE INDEX ON bcfishpass.barriers_gradient_30 (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_gradient_30 USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_30 USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_30 USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_30 USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_30 USING GIST (geom);


-- major dams
DROP TABLE IF EXISTS bcfishpass.barriers_majordams CASCADE;
CREATE TABLE bcfishpass.barriers_majordams
(
    barriers_majordams_id serial primary key,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    -- add a unique constraint so that we don't have equivalent barriers messing up subsequent joins
    UNIQUE (blue_line_key, downstream_route_measure)
);
CREATE INDEX ON bcfishpass.barriers_majordams (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_majordams (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_majordams (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_majordams USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_majordams USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_majordams USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_majordams USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_majordams USING GIST (geom);


-- other data sources that indicate a stream is not potentially accessible
DROP TABLE IF EXISTS bcfishpass.barriers_other_definite CASCADE;
CREATE TABLE bcfishpass.barriers_other_definite
(
    barriers_other_definite_id serial primary key,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    UNIQUE (blue_line_key, downstream_route_measure)
);
CREATE INDEX ON bcfishpass.barriers_other_definite (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_other_definite (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_other_definite (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (geom);


-- pscis barriers (included in anthropogenic but required separately for reporting)
DROP TABLE IF EXISTS bcfishpass.barriers_pscis CASCADE;
CREATE TABLE bcfishpass.barriers_pscis
(
    stream_crossing_id integer primary key,
    barrier_status text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    UNIQUE (linear_feature_id, downstream_route_measure)
);
CREATE INDEX ON bcfishpass.barriers_pscis (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_pscis (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_pscis (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_pscis USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING GIST (geom);


-- again, just for reporting, subset of crossings table that is just remediated (former) barriers
DROP TABLE IF EXISTS bcfishpass.barriers_remediated CASCADE;
CREATE TABLE bcfishpass.barriers_remediated
(
    aggregated_crossings_id             integer         PRIMARY KEY ,
    stream_crossing_id                  integer              ,
    dam_id                              integer              ,
    modelled_crossing_id                integer              ,
    crossing_source                     text                 ,
    pscis_status                        text                 ,
    crossing_type_code                  text                 ,
    crossing_subtype_code               text                 ,
    modelled_crossing_type_source       text[]               ,
    barrier_status                      text                 ,
    wcrp_barrier_type                   text                 ,
    linear_feature_id                   integer              ,
    blue_line_key                       integer              ,
    downstream_route_measure            double precision     ,
    wscode_ltree                        ltree                ,
    localcode_ltree                     ltree                ,
    watershed_group_code                text                 ,
    geom                                geometry(Point,3005)
);
CREATE INDEX ON bcfishpass.barriers_remediated (stream_crossing_id);
CREATE INDEX ON bcfishpass.barriers_remediated (dam_id);
CREATE INDEX ON bcfishpass.barriers_remediated (modelled_crossing_id);
CREATE INDEX ON bcfishpass.barriers_remediated (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_remediated (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_remediated (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_remediated USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_remediated USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_remediated USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_remediated USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_remediated USING GIST (geom);


-- subsurface flow
DROP TABLE IF EXISTS bcfishpass.barriers_subsurfaceflow CASCADE;
CREATE TABLE bcfishpass.barriers_subsurfaceflow
(
    barriers_subsurfaceflow_id serial primary key,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    -- add a unique constraint so that we don't have equivalent barriers messing up subsequent joins
    UNIQUE (blue_line_key, downstream_route_measure)
);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING GIST (geom);