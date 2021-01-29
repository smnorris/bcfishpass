DROP TABLE IF EXISTS bcfishpass.barriers_intermittentflow;

CREATE TABLE bcfishpass.barriers_intermittentflow
(
    barriers_intermittentflow_id serial primary key,
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


INSERT INTO bcfishpass.barriers_intermittentflow
(
    barriers_intermittentflow_id,
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
  s.linear_feature_id AS barriers_intermittentflow_id,
  'INTERMITTENTFLOW',
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
WHERE s.feature_code = 'GA24850150'
AND s.blue_line_key = s.watershed_key
AND s.localcode_ltree IS NOT NULL
AND s.fwa_watershed_code NOT LIKE '999%%'
AND s.watershed_group_code IN ('HORS','LNIC','BULK','ELKR');

CREATE INDEX ON bcfishpass.barriers_intermittentflow (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_intermittentflow (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_intermittentflow (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_intermittentflow USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_intermittentflow USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_intermittentflow USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_intermittentflow USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_intermittentflow USING GIST (geom);