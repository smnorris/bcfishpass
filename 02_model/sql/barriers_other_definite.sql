-- other data sources that indicate a stream is not potentially accessible

DROP TABLE IF EXISTS bcfishpass.barriers_other_definite;

CREATE TABLE bcfishpass.barriers_other_definite
(
    barriers_other_definite_id serial primary key,
    stream_crossing_id integer,
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
    stream_crossing_id,
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
    e.stream_crossing_id,
    'PSCIS_NOT_ACCESSIBLE',
    e.linear_feature_id,
    e.blue_line_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    e.geom
FROM bcfishpass.pscis_events_sp e
INNER JOIN bcfishpass.pscis_fixes f
ON e.stream_crossing_id = f.stream_crossing_id
WHERE f.updated_barrier_result_code = 'NOT ACCESSIBLE'
AND e.watershed_group_code IN ('HORS','LNIC','BULK','ELKR')
ORDER BY e.stream_crossing_id
ON CONFLICT DO NOTHING;


CREATE INDEX ON bcfishpass.barriers_other_definite (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_other_definite (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_other_definite (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (geom);