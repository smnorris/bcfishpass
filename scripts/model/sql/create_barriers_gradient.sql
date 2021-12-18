-- create and load barrier table holding gradient breaks of specified slope percentage

CREATE OR REPLACE FUNCTION bcfishpass.create_barriers_gradient(gradient integer)
  RETURNS VOID
  LANGUAGE plpgsql AS
$func$
BEGIN

   EXECUTE format(
    'DROP TABLE IF EXISTS bcfishpass.%I CASCADE',
    'barriers_gradient_' || lpad(gradient::text, 2, '0')
   );

   EXECUTE format('
      CREATE TABLE bcfishpass.%I
    (
        %I serial primary key,
        barrier_type text,
        barrier_name text,
        linear_feature_id integer,
        blue_line_key integer,
        downstream_route_measure double precision,
        wscode_ltree ltree,
        localcode_ltree ltree,
        watershed_group_code text,
        geom geometry(Point, 3005),
        UNIQUE (blue_line_key, downstream_route_measure)
    )', 'barriers_gradient_' || lpad(gradient::text, 2, '0'), 'barriers_gradient_' || lpad(gradient::text, 2, '0') || '_id'
    );

    EXECUTE format('
        INSERT INTO bcfishpass.%I
        (
            barrier_type,
            linear_feature_id,
            blue_line_key,
            downstream_route_measure,
            wscode_ltree,
            localcode_ltree,
            watershed_group_code,
            geom
        )
        SELECT
            %L as barrier_type,
            s.linear_feature_id,
            b.blue_line_key,
            b.downstream_route_measure,
            s.wscode_ltree,
            s.localcode_ltree,
            s.watershed_group_code,
            ST_Force2D((ST_Dump(ST_Locatealong(s.geom, b.downstream_route_measure))).geom)::geometry(Point,3005) as geom
        FROM bcfishpass.gradient_barriers b
        INNER JOIN whse_basemapping.fwa_stream_networks_sp s
        ON b.blue_line_key = s.blue_line_key
        AND s.downstream_route_measure <= b.downstream_route_measure
        AND s.upstream_route_measure + .01 > b.downstream_route_measure
        INNER JOIN bcfishpass.param_watersheds g
        ON s.watershed_group_code = g.watershed_group_code
        LEFT OUTER JOIN bcfishpass.gradient_barriers_passable p
        ON b.blue_line_key = p.blue_line_key
        AND b.downstream_route_measure = p.downstream_route_measure
        WHERE b.gradient_class = %L
        AND p.blue_line_key IS NULL -- do not include any passable features
        ORDER BY b.blue_line_key, b.downstream_route_measure
        ON CONFLICT DO NOTHING;',
        'barriers_gradient_' || lpad(gradient::text, 2, '0'),
        'GRADIENT_' || lpad(gradient::text, 2, '0'),
        gradient
    );

    EXECUTE format('
        CREATE INDEX ON bcfishpass.%I (linear_feature_id);
        CREATE INDEX ON bcfishpass.%I (blue_line_key);
        CREATE INDEX ON bcfishpass.%I (blue_line_key, downstream_route_measure);
        CREATE INDEX ON bcfishpass.%I (watershed_group_code);
        CREATE INDEX ON bcfishpass.%I USING GIST (wscode_ltree);
        CREATE INDEX ON bcfishpass.%I USING BTREE (wscode_ltree);
        CREATE INDEX ON bcfishpass.%I USING GIST (localcode_ltree);
        CREATE INDEX ON bcfishpass.%I USING BTREE (localcode_ltree);
        CREATE INDEX ON bcfishpass.%I USING GIST (geom);',
        'barriers_gradient_' || lpad(gradient::text, 2, '0'),
        'barriers_gradient_' || lpad(gradient::text, 2, '0'),
        'barriers_gradient_' || lpad(gradient::text, 2, '0'),
        'barriers_gradient_' || lpad(gradient::text, 2, '0'),
        'barriers_gradient_' || lpad(gradient::text, 2, '0'),
        'barriers_gradient_' || lpad(gradient::text, 2, '0'),
        'barriers_gradient_' || lpad(gradient::text, 2, '0'),
        'barriers_gradient_' || lpad(gradient::text, 2, '0'),
        'barriers_gradient_' || lpad(gradient::text, 2, '0')
    );

END
$func$;

