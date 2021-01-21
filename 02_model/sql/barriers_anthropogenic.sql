-- Create separate barrier table,
-- holding crossings that are barriers and potential barriers

DROP TABLE IF EXISTS bcfishpass.barriers_anthropogenic;

CREATE TABLE bcfishpass.barriers_anthropogenic
(
    barriers_anthropogenic_id integer primary key,
    stream_crossing_id integer,
    dam_id integer,
    modelled_crossing_id integer,
    crossing_source text,
    crossing_type text,
    crossing_name text,
    barrier_status text,
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

-- insert all barriers from aggregated crossings table
-- (pscis, dams, modelled xings)
-- no additonal logic required
INSERT INTO bcfishpass.barriers_anthropogenic
(
    barriers_anthropogenic_id,
    stream_crossing_id,
    dam_id,
    modelled_crossing_id,
    crossing_source,
    crossing_type,
    crossing_name,
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
    c.aggregated_crossings_id as barriers_anthropogenic_id,
    c.stream_crossing_id,
    c.dam_id,
    c.modelled_crossing_id,
    c.crossing_source,
    c.crossing_type,
    c.crossing_name,
    c.barrier_status,
    c.linear_feature_id,
    c.blue_line_key,
    c.downstream_route_measure,
    c.wscode_ltree,
    c.localcode_ltree,
    c.watershed_group_code,
    c.geom
FROM bcfishpass.crossings c
INNER JOIN bcfishpass.watershed_groups g
ON c.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
WHERE barrier_status IN ('BARRIER', 'POTENTIAL')
ON CONFLICT DO NOTHING;


-- --------------------------------
-- index for speed
-- --------------------------------
CREATE INDEX ON bcfishpass.barriers_anthropogenic (dam_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (stream_crossing_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (modelled_crossing_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING GIST (geom);


-- for stream visualization, we also want to create a table of pscis confirmed barriers only,
-- so we can see which streams are upstream of CONFIRMED barriers.
-- (this is deleted after coding the streams to avoid confusion)
DROP TABLE IF EXISTS bcfishpass.barriers_pscis;

CREATE TABLE bcfishpass.barriers_pscis
(
    stream_crossing_id integer primary key,
    crossing_source text,
    crossing_type text,
    crossing_name text,
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
    crossing_source,
    crossing_type,
    crossing_name,
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
    crossing_source,
    crossing_type,
    crossing_name,
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