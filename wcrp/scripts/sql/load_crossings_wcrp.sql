BEGIN;
  
  TRUNCATE bcfishpass.crossings_wcrp;

  -- update crossings_upstr_barriers_anthropogenic with fixed upstream barriers for side channels (vs entire upstr watershed)
  WITH adjusted_upstr_barriers_anthropogenic AS (

    SELECT
      aggregated_crossings_id,
      array_agg(features_upstr) as features_upstr
    FROM bcfishpass.barriers_sidechannel_upstr_barriers_anthropogenic AS b
    GROUP BY aggregated_crossings_id

    UNION ALL

    SELECT 
      aggregated_crossings_id, 
      features_upstr
    FROM bcfishpass.crossings_upstr_barriers_anthropogenic  AS a
    WHERE NOT EXISTS (
      SELECT 1 FROM bcfishpass.barriers_sidechannel_upstr_barriers_anthropogenic AS b
      WHERE b.aggregated_crossings_id = a.aggregated_crossings_id
    )
  ),

  -- find upstream crossings with wcrp 'all spawning rearing habitat' upstream   
  upstr_wcrp_barriers AS (    
    SELECT DISTINCT 
      b.aggregated_crossings_id,
      h.aggregated_crossings_id AS upstr_barriers
     FROM adjusted_upstr_barriers_anthropogenic b
     JOIN bcfishpass.crossings_upstream_habitat_wcrp h ON h.aggregated_crossings_id = ANY (b.features_upstr)
    WHERE h.all_spawningrearing_km > (0)::double precision
    ORDER BY b.aggregated_crossings_id, h.aggregated_crossings_id
  ), 
  
  -- aggregate the upstream wcrp crossings into a list and count
  upstr_wcrp_barriers_list AS (
  
      SELECT aggregated_crossings_id,
        array_to_string(array_agg(upstr_barriers), ';'::text) AS barriers_anthropogenic_habitat_wcrp_upstr,
        COALESCE(array_length(array_agg(upstr_barriers), 1), 0) AS barriers_anthropogenic_habitat_wcrp_upstr_count
       FROM upstr_wcrp_barriers
      GROUP BY aggregated_crossings_id
      ORDER BY aggregated_crossings_id
  )


  INSERT INTO bcfishpass.crossings_wcrp (
    aggregated_crossings_id,
    modelled_crossing_id,
    crossing_source,
    crossing_feature_type,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    barrier_status,
    pscis_road_name,
    pscis_stream_name,
    pscis_assessment_comment,
    pscis_assessment_date,
    transport_line_structured_name_1,
    rail_track_name,
    dam_name,
    dam_height,
    dam_owner,
    dam_use,
    dam_operating_status,
    utm_zone,
    utm_easting,
    utm_northing,
    blue_line_key,
    downstream_route_measure,
    wscode,
    localcode,
    watershed_group_code,
    gnis_stream_name,
    barriers_anthropogenic_dnstr,
    barriers_anthropogenic_dnstr_count,
    barriers_anthropogenic_habitat_wcrp_upstr,
    barriers_anthropogenic_habitat_wcrp_upstr_count,
    barriers_ch_cm_co_pk_sk_dnstr,
    barriers_st_dnstr,
    barriers_wct_dnstr,
    ch_spawning_km,
    ch_rearing_km,
    ch_spawningrearing_km,
    ch_spawning_belowupstrbarriers_km,
    ch_rearing_belowupstrbarriers_km,
    ch_spawningrearing_belowupstrbarriers_km,
    co_spawning_km,
    co_rearing_km,
    co_spawningrearing_km,
    co_spawning_belowupstrbarriers_km,
    co_rearing_belowupstrbarriers_km,
    co_spawningrearing_belowupstrbarriers_km,
    sk_spawning_km,
    sk_rearing_km,
    sk_spawningrearing_km,
    sk_spawning_belowupstrbarriers_km,
    sk_rearing_belowupstrbarriers_km,
    sk_spawningrearing_belowupstrbarriers_km,
    st_spawning_km,
    st_rearing_km,
    st_spawningrearing_km,
    st_spawning_belowupstrbarriers_km,
    st_rearing_belowupstrbarriers_km,
    st_spawningrearing_belowupstrbarriers_km,
    wct_spawning_km,
    wct_rearing_km,
    wct_spawningrearing_km,
    wct_spawning_belowupstrbarriers_km,
    wct_rearing_belowupstrbarriers_km,
    wct_spawningrearing_belowupstrbarriers_km,
    all_spawning_km,
    all_spawning_belowupstrbarriers_km,
    all_rearing_km,
    all_rearing_belowupstrbarriers_km,
    all_spawningrearing_km,
    all_spawningrearing_belowupstrbarriers_km,
    geom
  )

  -- joining to streams based on measure can be error prone due to precision.
  -- Join to streams on linear_feature_id and keep the first result
  -- (since streams are segmented there is often >1 match)
  SELECT DISTINCT ON (c.aggregated_crossings_id) c.aggregated_crossings_id,
   c.modelled_crossing_id,
   c.crossing_source,
   c.crossing_feature_type,
   c.pscis_status,
   c.crossing_type_code,
   c.crossing_subtype_code,
   c.barrier_status,
   c.pscis_road_name,
   c.pscis_stream_name,
   c.pscis_assessment_comment,
   c.pscis_assessment_date,
   c.transport_line_structured_name_1,
   c.rail_track_name,
   c.dam_name,
   c.dam_height,
   c.dam_owner,
   c.dam_use,
   c.dam_operating_status,
   c.utm_zone,
   c.utm_easting,
   c.utm_northing,
   c.blue_line_key,
   c.downstream_route_measure,
   c.wscode_ltree AS wscode,
   c.localcode_ltree AS localcode,
   c.watershed_group_code,
   c.gnis_stream_name,
   array_to_string(ad.features_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
   COALESCE(array_length(ad.features_dnstr, 1), 0) AS barriers_anthropogenic_dnstr_count,
   uwbl.barriers_anthropogenic_habitat_wcrp_upstr,
   uwbl.barriers_anthropogenic_habitat_wcrp_upstr_count,
   array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
   array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
   array_to_string(a.barriers_wct_dnstr, ';'::text) AS barriers_wct_dnstr,
   h.ch_spawning_km,
   h.ch_rearing_km,
   h.ch_spawningrearing_km,
   h.ch_spawning_belowupstrbarriers_km,
   h.ch_rearing_belowupstrbarriers_km,
   h.ch_spawningrearing_belowupstrbarriers_km,
   h.co_spawning_km,
   h.co_rearing_km,
   h.co_spawningrearing_km,
   h.co_spawning_belowupstrbarriers_km,
   h.co_rearing_belowupstrbarriers_km,
   h.co_spawningrearing_belowupstrbarriers_km,
   h.sk_spawning_km,
   h.sk_rearing_km,
   h.sk_spawningrearing_km,
   h.sk_spawning_belowupstrbarriers_km,
   h.sk_rearing_belowupstrbarriers_km,
   h.sk_spawningrearing_belowupstrbarriers_km,
   h.st_spawning_km,
   h.st_rearing_km,
   h.st_spawningrearing_km,
   h.st_spawning_belowupstrbarriers_km,
   h.st_rearing_belowupstrbarriers_km,
   h.st_spawningrearing_belowupstrbarriers_km,
   h.wct_spawning_km,
   h.wct_rearing_km,
   h.wct_spawningrearing_km,
   h.wct_spawning_belowupstrbarriers_km,
   h.wct_rearing_belowupstrbarriers_km,
   h.wct_spawningrearing_belowupstrbarriers_km,
   h.all_spawning_km,
   h.all_spawning_belowupstrbarriers_km,
   h.all_rearing_km,
   h.all_rearing_belowupstrbarriers_km,
   h.all_spawningrearing_km,
   h.all_spawningrearing_belowupstrbarriers_km,
   c.geom
   FROM bcfishpass.crossings c
   JOIN bcfishpass.wcrp_watersheds w ON c.watershed_group_code = w.watershed_group_code
   LEFT JOIN bcfishpass.crossings_dnstr_observations cdo ON c.aggregated_crossings_id = cdo.aggregated_crossings_id
   LEFT JOIN bcfishpass.crossings_upstr_observations cuo ON c.aggregated_crossings_id = cuo.aggregated_crossings_id
   LEFT JOIN bcfishpass.crossings_dnstr_crossings cd ON c.aggregated_crossings_id = cd.aggregated_crossings_id
   LEFT JOIN bcfishpass.crossings_dnstr_barriers_anthropogenic ad ON c.aggregated_crossings_id = ad.aggregated_crossings_id
   LEFT JOIN upstr_wcrp_barriers_list uwbl ON c.aggregated_crossings_id = uwbl.aggregated_crossings_id
   LEFT JOIN bcfishpass.crossings_upstream_access a ON c.aggregated_crossings_id = a.aggregated_crossings_id
   LEFT JOIN bcfishpass.crossings_upstream_habitat_wcrp h ON c.aggregated_crossings_id = h.aggregated_crossings_id
   LEFT JOIN bcfishpass.streams s ON c.linear_feature_id = s.linear_feature_id
   LEFT JOIN whse_basemapping.dbm_mof_50k_grid t ON st_intersects(c.geom, t.geom)
  -- remove these PSCIS crossings from ranking/reporting
  WHERE (COALESCE(c.stream_crossing_id, 0) <> ALL (ARRAY[199427, 197789, 197838, 197861, 197805, 125961, 199428, 197891, 203633, 198883 ]))
  ORDER BY c.aggregated_crossings_id, s.downstream_route_measure;

COMMIT;  