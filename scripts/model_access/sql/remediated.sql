-- extract remediated crossings from the crossings table

DROP TABLE IF EXISTS bcfishpass.remediated;

CREATE TABLE bcfishpass.remediated
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

-- insert all remediated crossings from aggregated crossings table
-- no additonal logic required
INSERT INTO bcfishpass.remediated
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
-- only include crossings that are still passable, in theory something may have failed after a remediation
WHERE
  pscis_status = 'REMEDIATED' AND
  barrier_status = 'PASSABLE' AND
  c.watershed_group_code = ANY(
    ARRAY(
      SELECT watershed_group_code
      FROM bcfishpass.param_watersheds
    )
  )
ON CONFLICT DO NOTHING;

CREATE INDEX ON bcfishpass.remediated (stream_crossing_id);
CREATE INDEX ON bcfishpass.remediated (dam_id);
CREATE INDEX ON bcfishpass.remediated (modelled_crossing_id);
CREATE INDEX ON bcfishpass.remediated (linear_feature_id);
CREATE INDEX ON bcfishpass.remediated (blue_line_key);
CREATE INDEX ON bcfishpass.remediated (watershed_group_code);
CREATE INDEX ON bcfishpass.remediated USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.remediated USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.remediated USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.remediated USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.remediated USING GIST (geom);