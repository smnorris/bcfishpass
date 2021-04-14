-- other data sources that indicate a stream is not potentially accessible

DROP TABLE IF EXISTS bcfishpass.barriers_other_definite;

CREATE TABLE bcfishpass.barriers_other_definite
(
    barriers_other_definite_id serial primary key,
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


INSERT INTO bcfishpass.barriers_other_definite
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

SELECT
    'PSCIS_NOT_ACCESSIBLE',
    e.linear_feature_id,
    e.blue_line_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    e.geom
FROM bcfishpass.pscis_events_sp e
INNER JOIN bcfishpass.pscis_barrier_result_fixes f
ON e.stream_crossing_id = f.stream_crossing_id
INNER JOIN bcfishpass.param_watersheds g
ON e.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
WHERE f.updated_barrier_result_code = 'NOT ACCESSIBLE'
ORDER BY e.stream_crossing_id
ON CONFLICT DO NOTHING;

INSERT INTO bcfishpass.barriers_other_definite
(
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
    a.barrier_type,
    a.barrier_name,
    s.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_Force2D(FWA_LocateAlong(a.blue_line_key, a.downstream_route_measure))
FROM bcfishpass.misc_barriers_definite a
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON a.blue_line_key = s.blue_line_key AND
   a.downstream_route_measure > s.downstream_route_measure - .001 AND
   a.downstream_route_measure + .001 < s.upstream_route_measure
ON CONFLICT DO NOTHING;


CREATE INDEX ON bcfishpass.barriers_other_definite (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_other_definite (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_other_definite (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (geom);