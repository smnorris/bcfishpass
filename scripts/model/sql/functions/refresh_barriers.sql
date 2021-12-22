-- for given watershed group,
--   - transfer data from temp load table to given barrier table
--   - populate _dnstr table relating streams to barriers downstream
-- this overwrites any existing records for given watershed group

CREATE OR REPLACE FUNCTION bcfishpass.refresh_barriers(barriertype text, wsg text)
  RETURNS VOID
  LANGUAGE plpgsql AS
$func$

BEGIN

    EXECUTE format('
      DELETE FROM bcfishpass.%I
      WHERE watershed_group_code = %L;',
    'barriers_' || barriertype,
    wsg
    );

    EXECUTE format('
      INSERT INTO bcfishpass.%I
      SELECT
          barrier_load_id as %I,
          barrier_type,
          barrier_name,
          linear_feature_id,
          blue_line_key,
          downstream_route_measure,
          wscode_ltree,
          localcode_ltree,
          watershed_group_code,
          geom
      FROM bcfishpass.barrier_load
      WHERE watershed_group_code = %L;',
    'barriers_' || barriertype,
    'barriers_' || barriertype || '_id',
    wsg
    );

END
$func$;