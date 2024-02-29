-- create table for holding barriers of given type

CREATE FUNCTION bcfishpass.create_barrier_table(barriertype text)
  RETURNS VOID
  LANGUAGE plpgsql AS
$func$
BEGIN

    EXECUTE format('
        CREATE TABLE IF NOT EXISTS bcfishpass.%I
        (
            %I text primary key,
            barrier_type text,
            barrier_name text,
            linear_feature_id integer,
            blue_line_key integer,
            watershed_key integer,
            downstream_route_measure double precision,
            wscode_ltree ltree,
            localcode_ltree ltree,
            watershed_group_code character varying (4),
            geom geometry(Point, 3005),
            UNIQUE (blue_line_key, downstream_route_measure)
        )',
        'barriers_' || barriertype,
        'barriers_' || barriertype || '_id'
    );

    EXECUTE format('
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (linear_feature_id);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (blue_line_key);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (watershed_key);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (blue_line_key, downstream_route_measure);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (watershed_group_code);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING GIST (wscode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING BTREE (wscode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING GIST (localcode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING BTREE (localcode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING GIST (geom);',
        'br_' || barriertype || '_linear_feature_id_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_blue_line_key_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_wskey_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_blk_meas_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_watershed_group_code_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_wscode_ltree_gidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_wscode_ltree_bidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_localcode_ltree_gidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_localcode_ltree_bidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_geom_idx',
        'barriers_' || barriertype
    );

END
$func$;
