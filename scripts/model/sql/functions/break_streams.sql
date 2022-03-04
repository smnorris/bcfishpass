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

    -- create new geoms
    -- model data needs to be retained in the new table and columns have to be listed
    -- (not the fwa data though, join back to get that from source via linear_feature_id)
    SELECT
      n.segmented_stream_id,
      s.linear_feature_id,
      n.downstream_route_measure,
      n.upstream_route_measure,
      s.upstream_area_ha             ,
      s.map_upstream                 ,
      s.channel_width                ,
      s.mad_m3s                      ,
      s.barriers_anthropogenic_dnstr ,
      s.barriers_pscis_dnstr         ,
      s.barriers_remediated_dnstr    ,
      s.barriers_ch_co_sk_dnstr      ,
      s.barriers_ch_co_sk_b_dnstr    ,
      s.barriers_st_dnstr            ,
      s.barriers_pk_dnstr            ,
      s.barriers_cm_dnstr            ,
      s.barriers_bt_dnstr            ,
      s.barriers_wct_dnstr           ,
      s.barriers_gr_dnstr            ,
      s.barriers_rb_dnstr            ,
      s.obsrvtn_pnt_distinct_upstr   ,
      s.obsrvtn_species_codes_upstr  ,
      s.access_model_ch_co_sk        ,
      s.access_model_ch_co_sk_b      ,
      s.access_model_st              ,
      s.access_model_wct             ,
      s.access_model_pk              ,
      s.access_model_cm              ,
      s.access_model_bt              ,
      s.access_model_gr              ,
      s.access_model_rb              ,
      s.spawning_model_ch            ,
      s.spawning_model_co            ,
      s.spawning_model_sk            ,
      s.spawning_model_st            ,
      s.spawning_model_wct           ,
      s.rearing_model_ch             ,
      s.rearing_model_co             ,
      s.rearing_model_sk             ,
      s.rearing_model_st             ,
      s.rearing_model_wct            ,
      (ST_Dump(ST_LocateBetween
        (s.geom, n.downstream_route_measure, n.upstream_route_measure
        ))).geom AS geom
    FROM new_measures n
    INNER JOIN bcfishpass.streams s ON n.segmented_stream_id = s.segmented_stream_id;


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
    ---------------------------------------------------------------
    INSERT INTO bcfishpass.streams
    (
      linear_feature_id,
      edge_type,
      blue_line_key,
      watershed_key,
      watershed_group_code,
      --downstream_route_measure,
      --length_metre,
      waterbody_key,
      wscode_ltree,
      localcode_ltree,
      gnis_name,
      stream_order,
      stream_magnitude,
      feature_code,
      upstream_area_ha             ,
      map_upstream                 ,
      channel_width                ,
      mad_m3s                      ,
      barriers_anthropogenic_dnstr ,
      barriers_pscis_dnstr         ,
      barriers_remediated_dnstr    ,
      barriers_ch_co_sk_dnstr      ,
      barriers_ch_co_sk_b_dnstr    ,
      barriers_st_dnstr            ,
      barriers_pk_dnstr            ,
      barriers_cm_dnstr            ,
      barriers_bt_dnstr            ,
      barriers_wct_dnstr           ,
      barriers_gr_dnstr            ,
      barriers_rb_dnstr            ,
      obsrvtn_pnt_distinct_upstr   ,
      obsrvtn_species_codes_upstr  ,
      access_model_ch_co_sk        ,
      access_model_ch_co_sk_b      ,
      access_model_st              ,
      access_model_wct             ,
      access_model_pk              ,
      access_model_cm              ,
      access_model_bt              ,
      access_model_gr              ,
      access_model_rb              ,
      spawning_model_ch            ,
      spawning_model_co            ,
      spawning_model_sk            ,
      spawning_model_st            ,
      spawning_model_wct           ,
      rearing_model_ch             ,
      rearing_model_co             ,
      rearing_model_sk             ,
      rearing_model_st             ,
      rearing_model_wct            ,
      geom
    )
    SELECT
      t.linear_feature_id,
      s.edge_type,
      s.blue_line_key,
      s.watershed_key,
      s.watershed_group_code,
      --t.downstream_route_measure,
      --ST_Length(t.geom) as length_metre,
      s.waterbody_key,
      s.wscode_ltree,
      s.localcode_ltree,
      s.gnis_name,
      s.stream_order,
      s.stream_magnitude,
      s.feature_code,
      t.upstream_area_ha             ,
      t.map_upstream                 ,
      t.channel_width                ,
      t.mad_m3s                      ,
      t.barriers_anthropogenic_dnstr ,
      t.barriers_pscis_dnstr         ,
      t.barriers_remediated_dnstr    ,
      t.barriers_ch_co_sk_dnstr      ,
      t.barriers_ch_co_sk_b_dnstr    ,
      t.barriers_st_dnstr            ,
      t.barriers_pk_dnstr            ,
      t.barriers_cm_dnstr            ,
      t.barriers_bt_dnstr            ,
      t.barriers_wct_dnstr           ,
      t.barriers_gr_dnstr            ,
      t.barriers_rb_dnstr            ,
      t.obsrvtn_pnt_distinct_upstr   ,
      t.obsrvtn_species_codes_upstr  ,
      t.access_model_ch_co_sk        ,
      t.access_model_ch_co_sk_b      ,
      t.access_model_st              ,
      t.access_model_wct             ,
      t.access_model_pk              ,
      t.access_model_cm              ,
      t.access_model_bt              ,
      t.access_model_gr              ,
      t.access_model_rb              ,
      t.spawning_model_ch            ,
      t.spawning_model_co            ,
      t.spawning_model_sk            ,
      t.spawning_model_st            ,
      t.spawning_model_wct           ,
      t.rearing_model_ch             ,
      t.rearing_model_co             ,
      t.rearing_model_sk             ,
      t.rearing_model_st             ,
      t.rearing_model_wct            ,
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
