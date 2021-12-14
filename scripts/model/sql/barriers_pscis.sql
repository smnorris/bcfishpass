-- for stream visualization, we also want to create a table of pscis confirmed barriers only,
-- so we can see which streams are upstream of CONFIRMED barriers.

DROP TABLE IF EXISTS bcfishpass.barriers_pscis CASCADE;

CREATE TABLE bcfishpass.barriers_pscis
(
    stream_crossing_id integer primary key,
    barrier_status text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    UNIQUE (linear_feature_id, downstream_route_measure)
);


INSERT INTO bcfishpass.barriers_pscis
(
    stream_crossing_id,
    barrier_status,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    stream_crossing_id,
    barrier_status,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_anthropogenic
WHERE stream_crossing_id IS NOT NULL;


CREATE INDEX ON bcfishpass.barriers_pscis (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_pscis (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_pscis (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_pscis USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING GIST (geom);


CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_pscis_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_barriers_pscis
  FROM (
    SELECT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.stream_crossing_id as dnstr_id
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.barriers_pscis b ON
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

CREATE INDEX ON bcfishpass.dnstr_barriers_pscis_vw (blue_line_key, downstream_route_measure);
