DROP TABLE IF EXISTS bcfishpass.barriers_gradient_30;

CREATE TABLE bcfishpass.barriers_gradient_30
(
    barriers_gradient30 serial primary key,
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
    UNIQUE (linear_feature_id, downstream_route_measure)
);


INSERT INTO bcfishpass.barriers_gradient_30
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
SELECT DISTINCT ON (blue_line_key, round(downstream_route_measure::numeric, 2))
    'GRADIENT_30' as barrier_type,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    ST_Force2D((st_Dump(b.geom)).geom)
FROM cwf.gradient_barriers b
WHERE b.threshold = .30
AND b.watershed_group_code = 'VICT'
-- spot manual QA of gradient barriers
AND b.linear_feature_id != 701934669 -- odd point on Salmon River that looks like a data error
ORDER BY blue_line_key, round(downstream_route_measure::numeric, 2)
ON CONFLICT DO NOTHING;