-- update the barriers_dnstr column for given barrier type / watershed group
CREATE OR REPLACE FUNCTION bcfishpass.update_barriers_dnstr(target_table text, target_table_id text, barriertype text, point_table text, include_equivalents text, wsg text)
  RETURNS VOID
  LANGUAGE plpgsql AS
$func$

BEGIN

  -- ensure target table has column required
  EXECUTE format('ALTER TABLE bcfishpass.%I
    ADD COLUMN IF NOT EXISTS %I bigint[];',
    target_table,
    'barriers_' || barriertype || '_dnstr'
  );

  -- before update with new values, remove existing values
  EXECUTE format('
    UPDATE bcfishpass.%I
    SET %I = NULL
    WHERE watershed_group_code = %L
    AND %I IS NOT NULL;',
    target_table,
    'barriers_' || barriertype || '_dnstr',
    wsg,
    'barriers_' || barriertype || '_dnstr'
    );

  EXECUTE format('

    WITH barriers_dnstr AS
    (
      SELECT
        a.%I,
        array_agg(DISTINCT b.%I) FILTER (WHERE b.%I IS NOT NULL) AS barriers_dnstr
      FROM bcfishpass.%I a
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
        %L,
        1
    )
    WHERE b.watershed_group_code = %L
    GROUP BY a.%I, a.watershed_group_code
    )

    UPDATE bcfishpass.%I s
    SET %I = b.barriers_dnstr
    FROM barriers_dnstr b
    WHERE s.%I = b.%I;',
    target_table_id,
    'barriers_' || barriertype || '_id',
    'barriers_' || barriertype || '_id',
    target_table,
    point_table,
    include_equivalents,
    wsg,
    target_table_id,
    target_table,
    'barriers_' || barriertype || '_dnstr',
    target_table_id,
    target_table_id
  );

END
$func$;  