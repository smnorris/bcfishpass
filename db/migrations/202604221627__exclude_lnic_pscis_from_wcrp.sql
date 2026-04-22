BEGIN;

  DROP MATERIALIZED VIEW bcfishpass.crossings_wcrp_vw;
  
  CREATE MATERIALIZED VIEW bcfishpass.crossings_wcrp_vw AS
  
  WITH upstr_wcrp_barriers AS MATERIALIZED (
         SELECT DISTINCT ba.aggregated_crossings_id,
            h_1.aggregated_crossings_id AS upstr_barriers,
            h_1.all_spawningrearing_km
           FROM (bcfishpass.crossings_upstr_barriers_anthropogenic ba
             JOIN bcfishpass.crossings_upstream_habitat_wcrp h_1 ON ((h_1.aggregated_crossings_id = ANY (ba.features_upstr))))
          WHERE (h_1.all_spawningrearing_km > (0)::double precision)
          ORDER BY ba.aggregated_crossings_id, h_1.aggregated_crossings_id
        ), upstr_wcrp_barriers_list AS (
         SELECT upstr_wcrp_barriers.aggregated_crossings_id,
            array_to_string(array_agg(upstr_wcrp_barriers.upstr_barriers), ';'::text) AS barriers_anthropogenic_habitat_wcrp_upstr,
            COALESCE(array_length(array_agg(upstr_wcrp_barriers.upstr_barriers), 1), 0) AS barriers_anthropogenic_habitat_wcrp_upstr_count
           FROM upstr_wcrp_barriers
          GROUP BY upstr_wcrp_barriers.aggregated_crossings_id
          ORDER BY upstr_wcrp_barriers.aggregated_crossings_id
  )
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
    h.cm_spawning_km,
    h.cm_spawning_belowupstrbarriers_km,
    h.co_spawning_km,
    h_wcrp.co_rearing_km,
    h_wcrp.co_spawningrearing_km,
    h.co_rearing_ha,
    h.co_spawning_belowupstrbarriers_km,
    h_wcrp.co_rearing_belowupstrbarriers_km,
    h_wcrp.co_spawningrearing_belowupstrbarriers_km,
    h.co_rearing_belowupstrbarriers_ha,
    h.pk_spawning_km,
    h.pk_spawning_belowupstrbarriers_km,
    h.sk_spawning_km,
    h_wcrp.sk_rearing_km,
    h_wcrp.sk_spawningrearing_km,
    h.sk_rearing_ha,
    h.sk_spawning_belowupstrbarriers_km,
    h_wcrp.sk_rearing_belowupstrbarriers_km,
    h_wcrp.sk_spawningrearing_belowupstrbarriers_km,
    h.sk_rearing_belowupstrbarriers_ha,
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
    h_wcrp.all_spawning_km,
    h_wcrp.all_spawning_belowupstrbarriers_km,
    h_wcrp.all_rearing_km,
    h_wcrp.all_rearing_belowupstrbarriers_km,
    h_wcrp.all_spawningrearing_km,
    h_wcrp.all_spawningrearing_belowupstrbarriers_km,
    r.set_id,
    r.total_hab_gain_set,
    r.num_barriers_set,
    r.avg_gain_per_barrier,
    r.dnstr_set_ids,
    r.rank_avg_gain_per_barrier,
    r.rank_avg_gain_tiered,
    r.rank_total_upstr_hab,
    r.rank_combined,
    r.tier_combined,
    c.geom
   FROM (((((((((((((bcfishpass.crossings c
     JOIN bcfishpass.wcrp_watersheds w ON ((c.watershed_group_code = (w.watershed_group_code)::text)))
     LEFT JOIN bcfishpass.crossings_dnstr_observations cdo ON ((c.aggregated_crossings_id = cdo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_observations cuo ON ((c.aggregated_crossings_id = cuo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_crossings cd ON ((c.aggregated_crossings_id = cd.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_barriers_anthropogenic ad ON ((c.aggregated_crossings_id = ad.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_barriers_anthropogenic au ON ((c.aggregated_crossings_id = au.aggregated_crossings_id)))
     LEFT JOIN upstr_wcrp_barriers_list uwbl ON ((c.aggregated_crossings_id = uwbl.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_access a ON ((c.aggregated_crossings_id = a.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_habitat h ON ((c.aggregated_crossings_id = h.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_habitat_wcrp h_wcrp ON ((c.aggregated_crossings_id = h_wcrp.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.streams s ON ((c.linear_feature_id = s.linear_feature_id)))
     LEFT JOIN whse_basemapping.dbm_mof_50k_grid t ON (public.st_intersects(c.geom, t.geom)))
     LEFT JOIN bcfishpass.wcrp_ranked_barriers r ON ((c.aggregated_crossings_id = r.aggregated_crossings_id)))
  WHERE (COALESCE(c.stream_crossing_id, 0) <> ALL (ARRAY[199427, 197789, 197838, 197861, 197805, 125961, 199428, 197891, 203633, 198883 ]))
  ORDER BY c.aggregated_crossings_id, s.downstream_route_measure
  WITH NO DATA;
 
COMMIT;
