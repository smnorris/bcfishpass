-- for given watershed group,
--   - transfer data from temp load table to given barrier table
--   - populate _dnstr table relating streams to barriers downstream
-- this overwrites any existing records for given watershed group

CREATE OR REPLACE FUNCTION bcfishpass.refresh_barriers_dnstr(barriertype text, wsg text)
  RETURNS VOID
  LANGUAGE plpgsql AS
$func$

BEGIN

  EXECUTE format(
    'DELETE FROM bcfishpass.%I WHERE watershed_group_code = %L',
    'barriers_' || barriertype || '_dnstr',
    wsg
  );

  EXECUTE format(
    'INSERT INTO bcfishpass.%I
      (
        segmented_stream_id,
        watershed_group_code,
        %I
      )
      SELECT
        a.segmented_stream_id,
        a.watershed_group_code,
        array_agg(DISTINCT %I) FILTER (WHERE %I IS NOT NULL) AS %I
      FROM bcfishpass.segmented_streams a
      INNER JOIN bcfishpass.%I b ON
      a.watershed_group_code = b.watershed_group_code
      AND FWA_Downstream(
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
      WHERE b.watershed_group_code = %L
      GROUP BY a.segmented_stream_id, a.watershed_group_code;',
      'barriers_' || barriertype || '_dnstr',
      'barriers_' || barriertype || '_dnstr',
      'barriers_' || barriertype || '_id',
      'barriers_' || barriertype || '_id',
      'barriers_' || barriertype || '_dnstr',
      'barriers_' || barriertype,
      wsg
    );

END
$func$;