-- falls
DROP TABLE IF EXISTS bcfishpass.barriers_falls CASCADE;

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
    UNIQUE (blue_line_key, downstream_route_measure)
);

CREATE INDEX ON bcfishpass.barriers_falls (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_falls (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_falls (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_falls USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_falls USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_falls USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_falls USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_falls USING GIST (geom);


INSERT INTO bcfishpass.barriers_falls
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
   'FALLS' as barrier_type,
    NULL as barrier_name,
    a.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    a.watershed_group_code,
    a.geom
FROM bcfishpass.falls a
INNER JOIN bcfishpass.param_watersheds g
ON a.watershed_group_code = g.watershed_group_code
WHERE a.barrier_ind IS TRUE
ON CONFLICT DO NOTHING;


CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_falls_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_barriers_falls
  FROM (
    SELECT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.barriers_falls_id as dnstr_id
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.barriers_falls b ON
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

CREATE INDEX ON bcfishpass.dnstr_barriers_falls_vw (blue_line_key, downstream_route_measure);