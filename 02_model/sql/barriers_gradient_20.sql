DROP TABLE IF EXISTS bcfishpass.barriers_gradient_20;

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


INSERT INTO bcfishpass.barriers_gradient_20
(
    barrier_type,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
-- ensure that points are unique so that when splitting streams,
-- we don't generate zero length lines
SELECT DISTINCT ON (blue_line_key, round(b.downstream_route_measure::numeric, 2))
    'GRADIENT_20' as barrier_type,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    ST_Force2D((st_Dump(b.geom)).geom)
FROM bcfishpass.gradient_barriers b
INNER JOIN bcfishpass.param_watersheds g
ON b.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
LEFT OUTER JOIN bcfishpass.gradient_barriers_passable p
ON b.blue_line_key = p.blue_line_key
AND b.downstream_route_measure <= p.downstream_route_measure
AND b.upstream_route_measure > p.downstream_route_measure
WHERE b.threshold = .20
AND p.blue_line_key IS NULL -- don't include any that get matched to passable table
ORDER BY blue_line_key, round(b.downstream_route_measure::numeric, 2)
ON CONFLICT DO NOTHING;

CREATE INDEX ON bcfishpass.barriers_gradient_20 (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_gradient_20 (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_gradient_20 (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_20 USING GIST (geom);