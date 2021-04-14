-- Create separate barrier table,
-- holding crossings that are barriers and potential barriers

DROP TABLE IF EXISTS bcfishpass.barriers_anthropogenic;

CREATE TABLE bcfishpass.barriers_anthropogenic
(
    aggregated_crossings_id             integer         PRIMARY KEY ,
    stream_crossing_id                  integer              ,
    dam_id                              integer              ,
    modelled_crossing_id                integer              ,
    crossing_source                     text                 ,
    pscis_status                        text                 ,
    crossing_type_code                  text                 ,
    crossing_subtype_code               text                 ,
    modelled_crossing_type_source       text[]               ,
    barrier_status                      text                 ,
    wcrp_barrier_type                   text                 ,
    linear_feature_id                   integer              ,
    blue_line_key                       integer              ,
    downstream_route_measure            double precision     ,
    wscode_ltree                        ltree                ,
    localcode_ltree                     ltree                ,
    watershed_group_code                text                 ,
    geom                                geometry(Point,3005)
);



-- insert all barriers from aggregated crossings table
-- (pscis, dams, modelled xings)
-- no additonal logic required
INSERT INTO bcfishpass.barriers_anthropogenic
(
    aggregated_crossings_id,
    stream_crossing_id,
    dam_id,
    modelled_crossing_id,
    crossing_source,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    modelled_crossing_type_source,
    barrier_status,
    wcrp_barrier_type,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    aggregated_crossings_id,
    stream_crossing_id,
    dam_id,
    modelled_crossing_id,
    crossing_source,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    modelled_crossing_type_source,
    barrier_status,
    wcrp_barrier_type,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    c.watershed_group_code as watershed_group_code,
    c.geom as geom
FROM bcfishpass.crossings c
INNER JOIN bcfishpass.param_watersheds g
ON c.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
WHERE barrier_status IN ('BARRIER', 'POTENTIAL')
ON CONFLICT DO NOTHING;

CREATE INDEX ON bcfishpass.barriers_anthropogenic (stream_crossing_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (dam_id);
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