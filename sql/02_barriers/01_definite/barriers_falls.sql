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
    -- add a unique constraint so that we don't have equivalent barriers messing up subsequent joins
    UNIQUE (linear_feature_id, downstream_route_measure)
);


INSERT INTO cwf.barriers_falls
(
    source_id,
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    fish_obstacle_point_id,
   'FALLS' as barrier_type,
    NULL as barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM whse_fish.fiss_falls_events_sp
-- these are the only barriers to insert - hard code them for now,
-- at some point we may want to maintain a lookup table
WHERE fish_obstacle_point_id IN (27481, 27482, 19653, 19565)
ON CONFLICT DO NOTHING;