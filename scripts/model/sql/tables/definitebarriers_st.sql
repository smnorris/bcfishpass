-- steelhead barriers (20% scenario)

DROP TABLE IF EXISTS bcfishpass.definitebarriers_st;

CREATE TABLE bcfishpass.definitebarriers_st
(
    definitebarriers_st_id serial primary key,
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

INSERT INTO bcfishpass.definitebarriers_st
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
WHERE watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE st IS TRUE
            )
          )
ON CONFLICT DO NOTHING;

CREATE INDEX ON bcfishpass.definitebarriers_st (linear_feature_id);
CREATE INDEX ON bcfishpass.definitebarriers_st (blue_line_key);
CREATE INDEX ON bcfishpass.definitebarriers_st (watershed_group_code);
CREATE INDEX ON bcfishpass.definitebarriers_st USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_st USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_st USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_st USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_st USING GIST (geom);