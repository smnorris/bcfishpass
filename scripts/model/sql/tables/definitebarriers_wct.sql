


-- wct barriers (20%)

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
WHERE watershed_group_code = ANY(
            ARRAY(
              SELECT watershed_group_code
              FROM bcfishpass.wsg_species_presence
              WHERE wct IS TRUE
            )
          )
ON CONFLICT DO NOTHING;


CREATE INDEX ON bcfishpass.definitebarriers_wct (linear_feature_id);
CREATE INDEX ON bcfishpass.definitebarriers_wct (blue_line_key);
CREATE INDEX ON bcfishpass.definitebarriers_wct (watershed_group_code);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.definitebarriers_wct USING GIST (geom);