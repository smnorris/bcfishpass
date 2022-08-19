-- --------------
-- BARRIER_LOAD
--
-- intermediate table for loading various barrier types to consistent structure/location before processing as barriers
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.barrier_load
(
    barrier_load_id text unique,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code character varying (4),
    geom geometry(Point, 3005),
    PRIMARY KEY (blue_line_key, downstream_route_measure)
);

