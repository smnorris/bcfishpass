CREATE OR REPLACE FUNCTION bcfishpass.break_streams(point_table text, wsg text)
  RETURNS VOID
  LANGUAGE plpgsql AS
$func$

BEGIN

  EXECUTE format('
    ---------------------------------------------------------------
    -- create a temp table where we segment streams at point locations
    ---------------------------------------------------------------
    CREATE TEMPORARY TABLE temp_streams AS
    WITH breakpoints AS
    (
    -- because we are rounding the measure, collapse any duplicates with DISTINCT
    -- note that rounding only works (does not potentially shift the point off of stream of interest)
    -- because we are joining only if the point is not within 1m of the endpoint
      SELECT DISTINCT
        blue_line_key,
        round(downstream_route_measure::numeric)::integer as downstream_route_measure
      FROM bcfishpass.%I
      WHERE watershed_group_code = %L
    ),

    to_break AS
    (
      SELECT
        s.segmented_stream_id,
        s.linear_feature_id,
        s.downstream_route_measure AS meas_stream_ds,
        s.upstream_route_measure AS meas_stream_us,
        b.downstream_route_measure AS meas_event
      FROM
        bcfishpass.segmented_streams s
        INNER JOIN breakpoints b
        ON s.blue_line_key = b.blue_line_key AND
        -- match based on measure, but only break stream lines where the
        -- barrier pt is >1m from the end of the existing stream segment
        (b.downstream_route_measure - s.downstream_route_measure) > 1 AND
        (s.upstream_route_measure - b.downstream_route_measure) > 1
    ),

    -- derive measures of new lines from break points
    new_measures AS
    (
      SELECT
        segmented_stream_id,
        linear_feature_id,
        --meas_stream_ds,
        --meas_stream_us,
        meas_event AS downstream_route_measure,
        lead(meas_event, 1, meas_stream_us) OVER (PARTITION BY segmented_stream_id
          ORDER BY meas_event) AS upstream_route_measure
      FROM
        to_break
    )

    -- create new geoms
    SELECT
      row_number() OVER () AS id,
      n.segmented_stream_id,
      s.linear_feature_id,
      n.downstream_route_measure,
      n.upstream_route_measure,
      (ST_Dump(ST_LocateBetween
        (s.geom, n.downstream_route_measure, n.upstream_route_measure
        ))).geom AS geom
    FROM new_measures n
    INNER JOIN bcfishpass.segmented_streams s ON n.segmented_stream_id = s.segmented_stream_id;


    ---------------------------------------------------------------
    -- shorten existing stream features
    ---------------------------------------------------------------
    WITH min_segs AS
    (
      SELECT DISTINCT ON (segmented_stream_id)
        segmented_stream_id,
        downstream_route_measure
      FROM
        temp_streams
      ORDER BY
        segmented_stream_id,
        downstream_route_measure ASC
    ),

    shortened AS
    (
      SELECT
        m.segmented_stream_id,
        ST_Length(ST_LocateBetween(s.geom, s.downstream_route_measure, m.downstream_route_measure)) as length_metre,
        (ST_Dump(ST_LocateBetween (s.geom, s.downstream_route_measure, m.downstream_route_measure))).geom as geom
      FROM min_segs m
      INNER JOIN bcfishpass.segmented_streams s
      ON m.segmented_stream_id = s.segmented_stream_id
    )

    UPDATE
      bcfishpass.segmented_streams a
    SET
      length_metre = b.length_metre,
      geom = b.geom
    FROM
      shortened b
    WHERE
      b.segmented_stream_id = a.segmented_stream_id;


    ---------------------------------------------------------------
    -- now insert new features
    ---------------------------------------------------------------
    INSERT INTO bcfishpass.segmented_streams
    (
      linear_feature_id,
      edge_type,
      blue_line_key,
      watershed_key,
      watershed_group_code,
      downstream_route_measure,
      length_metre,
      waterbody_key,
      wscode_ltree,
      localcode_ltree,
      geom
    )
    SELECT
      t.linear_feature_id,
      s.edge_type,
      s.blue_line_key,
      s.watershed_key,
      s.watershed_group_code,
      t.downstream_route_measure,
      ST_Length(t.geom) as length_metre,
      s.waterbody_key,
      s.wscode_ltree,
      s.localcode_ltree,
      t.geom
    FROM temp_streams t
    INNER JOIN whse_basemapping.fwa_stream_networks_sp s
    ON t.linear_feature_id = s.linear_feature_id
    ON CONFLICT DO NOTHING;',
    point_table,
    wsg
  );

END
$func$;
