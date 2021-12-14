-- insert exclusions first as they take priority in event there are other features at the same location
-- other data sources that indicate a stream is not potentially accessible

DROP TABLE IF EXISTS bcfishpass.barriers_other_definite CASCADE;

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
    UNIQUE (blue_line_key, downstream_route_measure)
);


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
    'EXCLUSION' as barrier_type,
    a.barrier_name,
    s.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_Force2D(postgisftw.FWA_LocateAlong(a.blue_line_key, a.downstream_route_measure))
FROM bcfishpass.exclusions a
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON a.blue_line_key = s.blue_line_key AND
   a.downstream_route_measure > s.downstream_route_measure - .001 AND
   a.downstream_route_measure + .001 < s.upstream_route_measure
INNER JOIN bcfishpass.param_watersheds g
ON a.watershed_group_code = g.watershed_group_code
ON CONFLICT DO NOTHING;


CREATE INDEX ON bcfishpass.barriers_other_definite (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_other_definite (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_other_definite (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_other_definite USING GIST (geom);


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
FROM bcfishpass.pscis e
INNER JOIN bcfishpass.pscis_barrier_result_fixes f
ON e.stream_crossing_id = f.stream_crossing_id
INNER JOIN bcfishpass.param_watersheds g
ON e.watershed_group_code = g.watershed_group_code
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
    'MISC' as barrier_type,
    a.barrier_name,
    s.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_Force2D(postgisftw.FWA_LocateAlong(a.blue_line_key, a.downstream_route_measure))
FROM bcfishpass.misc_barriers_definite a
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON a.blue_line_key = s.blue_line_key AND
   a.downstream_route_measure > s.downstream_route_measure - .001 AND
   a.downstream_route_measure + .001 < s.upstream_route_measure
INNER JOIN bcfishpass.param_watersheds g
ON a.watershed_group_code = g.watershed_group_code
ON CONFLICT DO NOTHING;


CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_other_definite_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_barriers_other_definite
  FROM (
    SELECT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.barriers_other_definite_id as dnstr_id
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.barriers_other_definite b ON
    FWA_Downstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      True,
      1
    )
    AND a.watershed_group_code = b.watershed_group_code
  ) as f
  GROUP BY blue_line_key, downstream_route_measure
  WITH NO DATA;

CREATE INDEX ON bcfishpass.dnstr_barriers_other_definite_vw (blue_line_key, downstream_route_measure);
