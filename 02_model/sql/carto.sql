-- steelhead barriers (20% scenario)
DROP TABLE IF EXISTS bcfishpass.carto_barriers_definite_steelhead;

CREATE TABLE bcfishpass.carto_barriers_definite_steelhead
(
    carto_barriers_definite_steelhead_id serial primary key,
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


INSERT INTO bcfishpass.carto_barriers_definite_steelhead
(   barrier_type,
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
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_20
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_30
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_falls
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_subsurfaceflow
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_other_definite
ON CONFLICT DO NOTHING;

-- steelhead is only BULK,NICL
DELETE FROM bcfishpass.carto_barriers_definite_steelhead WHERE watershed_group_code NOT IN ('BULK','LNIC');

CREATE INDEX ON bcfishpass.carto_barriers_definite_steelhead (linear_feature_id);
CREATE INDEX ON bcfishpass.carto_barriers_definite_steelhead (blue_line_key);
CREATE INDEX ON bcfishpass.carto_barriers_definite_steelhead (watershed_group_code);
CREATE INDEX ON bcfishpass.carto_barriers_definite_steelhead USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_steelhead USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_steelhead USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_steelhead USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_steelhead USING GIST (geom);


-- salmon barriers (15%)
DROP TABLE IF EXISTS bcfishpass.carto_barriers_definite_salmon;

CREATE TABLE bcfishpass.carto_barriers_definite_salmon
(
    carto_barriers_definite_salmon_id serial primary key,
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


INSERT INTO bcfishpass.carto_barriers_definite_salmon
(   barrier_type,
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
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_15
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_20
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_30
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_falls
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_subsurfaceflow
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_other_definite
ON CONFLICT DO NOTHING;

-- salmon is only hors
DELETE FROM bcfishpass.carto_barriers_definite_salmon WHERE watershed_group_code NOT IN ('HORS');


CREATE INDEX ON bcfishpass.carto_barriers_definite_salmon (linear_feature_id);
CREATE INDEX ON bcfishpass.carto_barriers_definite_salmon (blue_line_key);
CREATE INDEX ON bcfishpass.carto_barriers_definite_salmon (watershed_group_code);
CREATE INDEX ON bcfishpass.carto_barriers_definite_salmon USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_salmon USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_salmon USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_salmon USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_salmon USING GIST (geom);


-- wct barriers (20%, not below observation)
-- TODO get rid of / note barriers below observations
DROP TABLE IF EXISTS bcfishpass.carto_barriers_definite_wct;

CREATE TABLE bcfishpass.carto_barriers_definite_wct
(
    carto_barriers_definite_wct_id serial primary key,
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


INSERT INTO bcfishpass.carto_barriers_definite_wct
(   barrier_type,
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
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_20
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_gradient_30
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_falls
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_subsurfaceflow
UNION ALL
SELECT
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_other_definite
ON CONFLICT DO NOTHING;

-- wct is elkr
DELETE FROM bcfishpass.carto_barriers_definite_wct WHERE watershed_group_code NOT IN ('ELKR');

CREATE INDEX ON bcfishpass.carto_barriers_definite_wct (linear_feature_id);
CREATE INDEX ON bcfishpass.carto_barriers_definite_wct (blue_line_key);
CREATE INDEX ON bcfishpass.carto_barriers_definite_wct (watershed_group_code);
CREATE INDEX ON bcfishpass.carto_barriers_definite_wct USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_wct USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_wct USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_wct USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.carto_barriers_definite_wct USING GIST (geom);

-- small scale streams - aggregate over blueline, class, order > 1
DROP TABLE IF EXISTS bcfishpass.carto_streams_large;

CREATE TABLE bcfishpass.carto_streams_large
(
  carto_stream_large_id serial primary key,
  blue_line_key             integer                           ,
  gnis_name                 character varying(80)            ,
  stream_order              integer                           ,
  accessibility_model_salmon    text,
  accessibility_model_steelhead text,
  accessibility_model_wct       text,
  geom geometry(LineString,3005)
);

INSERT INTO bcfishpass.carto_streams_large
  (blue_line_key,
  gnis_name,
  stream_order,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct,
  geom)
SELECT
  blue_line_key,
  gnis_name,
  stream_order,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct,
  (ST_Dump(ST_UNION(ST_Force2D(geom)))).geom as geom
FROM bcfishpass.streams
WHERE stream_order > 1
AND
GROUP BY blue_line_key,
  gnis_name,
  stream_order,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct;