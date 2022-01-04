-- update the barriers_dnstr column for given barrier type / watershed group

CREATE OR REPLACE FUNCTION bcfishpass.update_barriers_dnstr(barriertype text, wsg text)
  RETURNS VOID
  LANGUAGE plpgsql AS
$func$

BEGIN

  -- before update with new values, remove existing values
  EXECUTE format('
    UPDATE bcfishpass.streams
    SET %I = NULL
    WHERE watershed_group_code = %L
    AND %I IS NOT NULL;',
    'barriers_' || barriertype || '_dnstr',
    wsg,
    'barriers_' || barriertype || '_dnstr'
    );

  EXECUTE format('

    WITH barriers_dnstr AS
    (
      SELECT
      a.segmented_stream_id,
      array_agg(DISTINCT %I) FILTER (WHERE %I IS NOT NULL) AS barriers_dnstr
    FROM bcfishpass.streams a
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
    GROUP BY a.segmented_stream_id, a.watershed_group_code
    )

    UPDATE bcfishpass.streams s
    SET %I = b.barriers_dnstr
    FROM barriers_dnstr b
    WHERE s.segmented_stream_id = b.segmented_stream_id;',
    'barriers_' || barriertype || '_id',
    'barriers_' || barriertype || '_id',
    'barriers_' || barriertype,
    wsg,
    'barriers_' || barriertype || '_dnstr'
  );

END
$func$;  