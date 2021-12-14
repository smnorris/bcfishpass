-- subsurface flow

DROP TABLE IF EXISTS bcfishpass.barriers_subsurfaceflow CASCADE;

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
INNER JOIN bcfishpass.param_watersheds g
ON s.watershed_group_code = g.watershed_group_code
WHERE s.edge_type IN (1410, 1425)
AND s.local_watershed_code IS NOT NULL
AND s.blue_line_key = s.watershed_key
AND s.fwa_watershed_code NOT LIKE '999%%'
-- Do not include subsurface flows on the Chilcotin at the Clusco.
-- The subsurface flow is a side channel, the Chilcotin merges
-- with the Clusco farther upstream
-- TODO - add a user table for corrections like this
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


CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_subsurfaceflow_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_barriers_subsurfaceflow
  FROM (
    SELECT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.barriers_subsurfaceflow_id as dnstr_id
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.barriers_subsurfaceflow b ON
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


CREATE INDEX ON bcfishpass.dnstr_barriers_subsurfaceflow_vw (blue_line_key, downstream_route_measure);