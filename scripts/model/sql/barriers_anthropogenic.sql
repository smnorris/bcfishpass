-- insert all barriers from aggregated crossings table
-- (pscis, dams, modelled xings)
-- no additonal logic required
-- records from crossings table that are barriers and potential barriers
DROP TABLE IF EXISTS bcfishpass.barriers_anthropogenic CASCADE;
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
WHERE barrier_status IN ('BARRIER', 'POTENTIAL')
AND c.watershed_group_code = ANY(
  ARRAY(
    SELECT watershed_group_code
    FROM bcfishpass.param_watersheds
  )
)
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

CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_anthropogenic_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_barriers_anthropogenic
  FROM (
    SELECT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.aggregated_crossings_id as dnstr_id
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.barriers_anthropogenic b ON
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

CREATE INDEX ON bcfishpass.dnstr_barriers_anthropogenic_vw (blue_line_key, downstream_route_measure);