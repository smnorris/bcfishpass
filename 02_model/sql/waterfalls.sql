DROP TABLE IF EXISTS bcfishpass.waterfalls;

CREATE TABLE bcfishpass.waterfalls
(
    falls_id serial primary key,
    fish_obstacle_point_ids integer[],
    name text,
    source text,
    height double precision,
    distance_to_stream double precision,
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

-- insert fiss
INSERT INTO bcfishpass.waterfalls
(fish_obstacle_point_ids,
    name,
    source,
    height,
    distance_to_stream,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
    )
SELECT
    fish_obstacle_point_ids,
    null as name,
    'FISS' as source,
    height,
    distance_to_stream,
    a.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    a.watershed_group_code,
    (ST_Dump(ST_Force2D(ST_locateAlong(b.geom, a.downstream_route_measure)))).geom as geom
FROM whse_fish.fiss_falls_events a
INNER JOIN whse_basemapping.fwa_stream_networks_sp b
ON a.linear_feature_id = b.linear_feature_id
INNER JOIN bcfishpass.param_watersheds g
ON a.watershed_group_code = g.watershed_group_code AND g.include IS TRUE;

-- insert others
INSERT INTO bcfishpass.waterfalls
(   name,
    source,
    distance_to_stream,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
    )

SELECT
    e.name,
    e.source,
    e.distance_to_stream,
    e.linear_feature_id,
    e.blue_line_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    e.geom
FROM cwf.waterfalls_additional_events e
INNER JOIN bcfishpass.param_watersheds g
ON e.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
ON CONFLICT DO NOTHING;