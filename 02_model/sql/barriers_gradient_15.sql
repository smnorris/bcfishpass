DROP TABLE IF EXISTS bcfishpass.barriers_gradient_15;

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


INSERT INTO bcfishpass.barriers_gradient_15
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
SELECT
    'GRADIENT_15' as barrier_type,
    s.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_Force2D((ST_Dump(ST_Locatealong(s.geom, b.downstream_route_measure))).geom)::geometry(Point,3005) as geom
FROM bcfishpass.gradient_barriers b
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON b.blue_line_key = s.blue_line_key
AND s.downstream_route_measure <= b.downstream_route_measure
AND s.upstream_route_measure + .01 > b.downstream_route_measure
INNER JOIN bcfishpass.param_watersheds g
ON s.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
LEFT OUTER JOIN bcfishpass.gradient_barriers_passable p
ON b.blue_line_key = p.blue_line_key
AND b.downstream_route_measure = p.downstream_route_measure
WHERE b.gradient_class = 15
AND p.blue_line_key IS NULL -- don't include any that get matched to passable table
ORDER BY b.blue_line_key, b.downstream_route_measure
ON CONFLICT DO NOTHING;

CREATE INDEX ON bcfishpass.barriers_gradient_15 (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_gradient_15 (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_gradient_15 (blue_line_key, downstream_route_measure);
CREATE INDEX ON bcfishpass.barriers_gradient_15 (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_gradient_15 USING GIST (geom);