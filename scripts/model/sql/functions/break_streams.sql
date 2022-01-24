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
        bcfishpass.streams s
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

    -- create new geoms and load them into a separate column so we can retain all columns
    -- from source without listing them out
    SELECT
      s.*,
      (ST_Dump(ST_LocateBetween
        (s.geom, n.downstream_route_measure, n.upstream_route_measure
        ))).geom AS geom_new
    FROM new_measures n
    INNER JOIN bcfishpass.streams s ON n.segmented_stream_id = s.segmented_stream_id;

    -- drop the old geom from temp table, retain the new shorter geoms
    ALTER TABLE temp_streams DROP COLUMN geom;
    ALTER TABLE temp_streams RENAME COLUMN geom_new TO geom;

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
        (ST_Dump(ST_LocateBetween (s.geom, s.downstream_route_measure, m.downstream_route_measure))).geom as geom
      FROM min_segs m
      INNER JOIN bcfishpass.streams s
      ON m.segmented_stream_id = s.segmented_stream_id
    )

    UPDATE
      bcfishpass.streams a
    SET
      geom = b.geom
    FROM
      shortened b
    WHERE
      b.segmented_stream_id = a.segmented_stream_id;


    ---------------------------------------------------------------
    -- now insert new features
    -- note that required columns need to be explicitly listed because we cannot
    -- automatically exclude generated columns without getting into dynamic sql/introspection
    -- https://stackoverflow.com/questions/44100163/postgresql-copy-row-minus-a-few-columns
    ---------------------------------------------------------------
    INSERT INTO bcfishpass.streams
    (
      linear_feature_id,
      edge_type,
      blue_line_key,
      watershed_key,
      watershed_group_code,
      waterbody_key,
      wscode_ltree,
      localcode_ltree,
      gnis_name,
      stream_order,
      stream_magnitude,
      barriers_anthropogenic_dnstr,
      barriers_pscis_dnstr,
      barriers_remediated_dnstr,
      barriers_ch_co_sk_dnstr,
      barriers_ch_co_sk_b_dnstr,
      barriers_st_dnstr,
      barriers_pk_dnstr,
      barriers_cm_dnstr,
      barriers_bt_dnstr,
      barriers_wct_dnstr,
      barriers_gr_dnstr,
      barriers_rb_dnstr,
      obsrvtn_pnt_distinct_upstr,
      obsrvtn_species_codes_upstr,
      access_model_ch_co_sk,
      access_model_ch_co_sk_b,
      access_model_st,
      access_model_wct,
      access_model_pk,
      access_model_cm,
      access_model_bt,
      access_model_gr,
      access_model_rb,
      channel_width,
      mad_m3s,
      spawning_model_ch,
      spawning_model_co,
      spawning_model_sk,
      spawning_model_st,
      spawning_model_wct,
      rearing_model_ch,
      rearing_model_co,
      rearing_model_sk,
      rearing_model_st,
      rearing_model_wct,
      geom
    )
    SELECT
      linear_feature_id,
      edge_type,
      blue_line_key,
      watershed_key,
      watershed_group_code,
      waterbody_key,
      wscode_ltree,
      localcode_ltree,
      gnis_name,
      stream_order,
      stream_magnitude,
      barriers_anthropogenic_dnstr,
      barriers_pscis_dnstr,
      barriers_remediated_dnstr,
      barriers_ch_co_sk_dnstr,
      barriers_ch_co_sk_b_dnstr,
      barriers_st_dnstr,
      barriers_pk_dnstr,
      barriers_cm_dnstr,
      barriers_bt_dnstr,
      barriers_wct_dnstr,
      barriers_gr_dnstr,
      barriers_rb_dnstr,
      obsrvtn_pnt_distinct_upstr,
      obsrvtn_species_codes_upstr,
      access_model_ch_co_sk,
      access_model_ch_co_sk_b,
      access_model_st,
      access_model_wct,
      access_model_pk,
      access_model_cm,
      access_model_bt,
      access_model_gr,
      access_model_rb,
      channel_width,
      mad_m3s,
      spawning_model_ch,
      spawning_model_co,
      spawning_model_sk,
      spawning_model_st,
      spawning_model_wct,
      rearing_model_ch,
      rearing_model_co,
      rearing_model_sk,
      rearing_model_st,
      rearing_model_wct,
      geom
    FROM temp_streams t
    ON CONFLICT DO NOTHING;',
    point_table,
    wsg
  );

END
$func$;



