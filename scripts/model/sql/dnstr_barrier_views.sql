-- to make common updates faster, create views that relate stream segments to
-- downstream barriers, with each type of barrier in a separate view
-- (generally, most of the definite barriers will rarely be refreshed, while
-- the smaller pscis/anthropogenic barriers view will need to be refreshed regularly
-- as data improves/more assessments are done)

CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_gradient_15_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_barriers_gradient_15
  FROM (
    SELECT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.barriers_gradient_15_id as dnstr_id
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.barriers_gradient_15 b ON
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

CREATE INDEX ON bcfishpass.dnstr_barriers_gradient_15_vw (blue_line_key, downstream_route_measure);

CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_gradient_20_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_barriers_gradient_20
  FROM (
    SELECT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.barriers_gradient_20_id as dnstr_id
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.barriers_gradient_20 b ON
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

CREATE INDEX ON bcfishpass.dnstr_barriers_gradient_20_vw (blue_line_key, downstream_route_measure);

CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_gradient_30_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_barriers_gradient_30
  FROM (
    SELECT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.barriers_gradient_30_id as dnstr_id
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.barriers_gradient_30 b ON
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

CREATE INDEX ON bcfishpass.dnstr_barriers_gradient_30_vw (blue_line_key, downstream_route_measure);

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


CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_majordams_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_barriers_majordams
  FROM (
    SELECT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.barriers_majordams_id as dnstr_id
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.barriers_majordams b ON
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
    -- while major dams in downstream groups will be barriers, this is accounted for
    -- in wsg_species_presence - watersheds isolated by these features will not be included
    AND a.watershed_group_code = b.watershed_group_code
  ) as f
  GROUP BY blue_line_key, downstream_route_measure
  WITH NO DATA;

CREATE INDEX ON bcfishpass.dnstr_barriers_majordams_vw (blue_line_key, downstream_route_measure);


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


CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.dnstr_barriers_remediated_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(dnstr_id) FILTER (WHERE dnstr_id IS NOT NULL) AS dnstr_remediated
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
    INNER JOIN bcfishpass.barriers_remediated b ON
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

CREATE INDEX ON bcfishpass.dnstr_barriers_remediated_vw (blue_line_key, downstream_route_measure);

