DROP TABLE IF EXISTS bcfishpass.barriers_subsurfaceflow;

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


INSERT INTO bcfishpass.barriers_subsurfaceflow
(
    barriers_subsurfaceflow_id,
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
    linear_feature_id as barriers_subsurfaceflow_id,
    'SUBSURFACEFLOW' as barrier_type,
    NULL as barrier_name,
    s.linear_feature_id,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_LineInterpolatePoint(
        ST_Force2D(
            (ST_Dump(s.geom)).geom
        ),
        0
    ) as geom
FROM whse_basemapping.fwa_stream_networks_sp s
INNER JOIN bcfishpass.watershed_groups g
ON s.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
WHERE s.edge_type IN (1410, 1425)
AND s.local_watershed_code IS NOT NULL
AND s.blue_line_key = s.watershed_key
AND s.fwa_watershed_code NOT LIKE '999%%'
-- Do not include subsurface flows on the Chilcotin at the Clusco.
-- The subsurface flow is a side channel, the Chilcotin merges
-- with the Clusco farther upstream
AND NOT (s.blue_line_key = 356363411 AND s.downstream_route_measure < 213010)
ON CONFLICT DO NOTHING;


CREATE INDEX ON bcfishpass.barriers_subsurfaceflow (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_subsurfaceflow USING GIST (geom);