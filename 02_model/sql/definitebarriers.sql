-- for each species scenario, merge all definite barriers into single table
-- (for visualization and for easier processing when dealing with observations upstream)

-- steelhead barriers (20% scenario)
DROP TABLE IF EXISTS bcfishpass.definitebarriers_steelhead;

CREATE TABLE bcfishpass.definitebarriers_steelhead
(
    definitebarriers_steelhead_id serial primary key,
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


WITH barriers AS

(SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_20
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_30
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_falls
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_subsurfaceflow
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_other_definite
)

INSERT INTO bcfishpass.definitebarriers_steelhead
(   barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT b.*
FROM barriers b
INNER JOIN bcfishpass.watershed_groups g
ON b.watershed_group_code = g.watershed_group_code AND g.st IS TRUE
ON CONFLICT DO NOTHING;

CREATE INDEX ON bcfishpass.definitebarriers_steelhead (linear_feature_id);
CREATE INDEX ON bcfishpass.definitebarriers_steelhead (blue_line_key);
CREATE INDEX ON bcfishpass.definitebarriers_steelhead (watershed_group_code);
CREATE INDEX ON bcfishpass.definitebarriers_steelhead USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_steelhead USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_steelhead USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_steelhead USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_steelhead USING GIST (geom);


-- salmon barriers (15%)
DROP TABLE IF EXISTS bcfishpass.definitebarriers_salmon;

CREATE TABLE bcfishpass.definitebarriers_salmon
(
    definitebarriers_salmon_id serial primary key,
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


WITH barriers AS
(
    SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_15
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_20
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_30
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_falls
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_subsurfaceflow
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_other_definite
)

INSERT INTO bcfishpass.definitebarriers_salmon
(   barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT b.*
FROM barriers b
INNER JOIN bcfishpass.watershed_groups g
ON b.watershed_group_code = g.watershed_group_code AND
(g.co IS TRUE OR g.ch IS TRUE OR g.sk IS TRUE)
ON CONFLICT DO NOTHING;

CREATE INDEX ON bcfishpass.definitebarriers_salmon (linear_feature_id);
CREATE INDEX ON bcfishpass.definitebarriers_salmon (blue_line_key);
CREATE INDEX ON bcfishpass.definitebarriers_salmon (watershed_group_code);
CREATE INDEX ON bcfishpass.definitebarriers_salmon USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_salmon USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_salmon USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_salmon USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_salmon USING GIST (geom);


-- wct barriers (20%, not below observation)
DROP TABLE IF EXISTS bcfishpass.definitebarriers_wct;

CREATE TABLE bcfishpass.definitebarriers_wct
(
    definitebarriers_wct_id serial primary key,
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



WITH barriers AS (
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_20
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_30
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_falls
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_subsurfaceflow
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_other_definite
)

INSERT INTO bcfishpass.definitebarriers_wct
(   barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT b.*
FROM barriers b
INNER JOIN bcfishpass.watershed_groups g
ON b.watershed_group_code = g.watershed_group_code AND g.wct IS TRUE
ON CONFLICT DO NOTHING;


CREATE INDEX ON bcfishpass.definitebarriers_wct (linear_feature_id);
CREATE INDEX ON bcfishpass.definitebarriers_wct (blue_line_key);
CREATE INDEX ON bcfishpass.definitebarriers_wct (watershed_group_code);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING GIST (geom);