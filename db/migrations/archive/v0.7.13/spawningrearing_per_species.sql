BEGIN;

  -- before rebuilding the crossings view with the new fk, also add per species combined spawning rearing
  -- columns to crossings_upstream_habitat tables (primary, plus wcrp adjusted values)
  alter table bcfishpass.crossings_upstream_habitat add column bt_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat add column bt_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;
 
  alter table bcfishpass.crossings_upstream_habitat add column ch_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat add column ch_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;
  
  alter table bcfishpass.crossings_upstream_habitat add column co_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat add column co_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;

  alter table bcfishpass.crossings_upstream_habitat add column sk_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat add column sk_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;
  
  alter table bcfishpass.crossings_upstream_habitat add column st_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat add column st_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;

  -- also add an all salmon and all salmon/steelhead
  alter table bcfishpass.crossings_upstream_habitat add column salmon_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat add column salmon_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;

  alter table bcfishpass.crossings_upstream_habitat add column salmonsteelhead_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat add column salmonsteelhead_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;

  -- wcrp specific spawningrearing for co/sk (with .5x multiplier for rearing in lakes/wetleands)
  alter table bcfishpass.crossings_upstream_habitat_wcrp add column co_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat_wcrp add column co_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;
  
  alter table bcfishpass.crossings_upstream_habitat_wcrp add column sk_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat_wcrp add column sk_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;

  alter table bcfishpass.crossings_upstream_habitat add column wct_spawningrearing_km double precision DEFAULT 0;
  alter table bcfishpass.crossings_upstream_habitat add column wct_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0;
 
  

  -- with new columns in place, rebuild crossings_vw

  drop materialized view bcfishpass.crossings_vw;

  create materialized view bcfishpass.crossings_vw as
  select
    -- joining to streams based on measure can be error prone due to precision.
    -- Join to streams on linear_feature_id and keep the first result
    -- (since streams are segmented there is often >1 match)
    distinct on (c.aggregated_crossings_id)
    c.aggregated_crossings_id,
    c.stream_crossing_id,
    c.dam_id,
    c.user_crossing_misc_id,
    c.modelled_crossing_id,
    c.crossing_source,
    c.crossing_feature_type,
    c.pscis_status,
    c.crossing_type_code,
    c.crossing_subtype_code,
    array_to_string(c.modelled_crossing_type_source, ';') as modelled_crossing_type_source,
    c.barrier_status,
    c.pscis_road_name,
    c.pscis_stream_name,
    c.pscis_assessment_comment,
    c.pscis_assessment_date,
    c.pscis_final_score,
    c.transport_line_structured_name_1,
    c.transport_line_type_description,
    c.transport_line_surface_description,
    c.ften_forest_file_id,
    c.ften_road_section_id,
    c.ften_file_type_description,
    c.ften_client_number,
    c.ften_client_name,
    c.ften_life_cycle_status_code,
    c.ften_map_label,
    c.rail_track_name,
    c.rail_owner_name,
    c.rail_operator_english_name,
    c.ogc_proponent,
    c.dam_name,
    c.dam_height,
    c.dam_owner,
    c.dam_use,
    c.dam_operating_status,
    c.utm_zone,
    c.utm_easting,
    c.utm_northing,
    t.map_tile_display_name as dbm_mof_50k_grid,
    c.linear_feature_id,
    c.blue_line_key,
    c.watershed_key,
    c.downstream_route_measure,
    c.wscode_ltree as wscode,
    c.localcode_ltree as localcode,
    c.watershed_group_code,
    c.gnis_stream_name,
    c.stream_order,
    c.stream_magnitude,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(cdo.observedspp_dnstr, ';') as observedspp_dnstr,
    array_to_string(cuo.observedspp_upstr, ';') as observedspp_upstr,
    array_to_string(cd.features_dnstr, ';') as crossings_dnstr,
    array_to_string(ad.features_dnstr, ';') as barriers_anthropogenic_dnstr,
    coalesce(array_length(ad.features_dnstr, 1), 0) as barriers_anthropogenic_dnstr_count,
    array_to_string(au.features_upstr, ';') as barriers_anthropogenic_upstr,
    coalesce(array_length(au.features_upstr, 1), 0) as barriers_anthropogenic_upstr_count,
    array_to_string(aum.barriers_upstr_bt, ';') as barriers_anthropogenic_bt_upstr,
    coalesce(array_length(aum.barriers_upstr_bt, 1), 0) as barriers_anthropogenic_upstr_bt_count,
    array_to_string(aum.barriers_upstr_ch_cm_co_pk_sk, ';') as barriers_anthropogenic_ch_cm_co_pk_sk_upstr,
    coalesce(array_length(aum.barriers_upstr_ch_cm_co_pk_sk, 1), 0) as barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count,
    array_to_string(aum.barriers_upstr_st, ';') as barriers_anthropogenic_st_upstr,
    coalesce(array_length(aum.barriers_upstr_st, 1), 0) as barriers_anthropogenic_st_upstr_count,
    array_to_string(aum.barriers_upstr_wct, ';') as barriers_anthropogenic_wct_upstr,
    coalesce(array_length(aum.barriers_upstr_wct, 1), 0) as barriers_anthropogenic_wct_upstr_count,
    a.gradient,
    a.total_network_km,
    a.total_stream_km,
    a.total_lakereservoir_ha,
    a.total_wetland_ha,
    a.total_slopeclass03_waterbodies_km,
    a.total_slopeclass03_km,
    a.total_slopeclass05_km,
    a.total_slopeclass08_km,
    a.total_slopeclass15_km,
    a.total_slopeclass22_km,
    a.total_slopeclass30_km,
    a.total_belowupstrbarriers_network_km,
    a.total_belowupstrbarriers_stream_km,
    a.total_belowupstrbarriers_lakereservoir_ha,
    a.total_belowupstrbarriers_wetland_ha,
    a.total_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.total_belowupstrbarriers_slopeclass03_km,
    a.total_belowupstrbarriers_slopeclass05_km,
    a.total_belowupstrbarriers_slopeclass08_km,
    a.total_belowupstrbarriers_slopeclass15_km,
    a.total_belowupstrbarriers_slopeclass22_km,
    a.total_belowupstrbarriers_slopeclass30_km,

    -- access models
    array_to_string(a.barriers_bt_dnstr, ';') as barriers_bt_dnstr,
    a.bt_network_km,
    a.bt_stream_km,
    a.bt_lakereservoir_ha,
    a.bt_wetland_ha,
    a.bt_slopeclass03_waterbodies_km,
    a.bt_slopeclass03_km,
    a.bt_slopeclass05_km,
    a.bt_slopeclass08_km,
    a.bt_slopeclass15_km,
    a.bt_slopeclass22_km,
    a.bt_slopeclass30_km,
    a.bt_belowupstrbarriers_network_km,
    a.bt_belowupstrbarriers_stream_km,
    a.bt_belowupstrbarriers_lakereservoir_ha,
    a.bt_belowupstrbarriers_wetland_ha,
    a.bt_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.bt_belowupstrbarriers_slopeclass03_km,
    a.bt_belowupstrbarriers_slopeclass05_km,
    a.bt_belowupstrbarriers_slopeclass08_km,
    a.bt_belowupstrbarriers_slopeclass15_km,
    a.bt_belowupstrbarriers_slopeclass22_km,
    a.bt_belowupstrbarriers_slopeclass30_km,

    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
    a.ch_cm_co_pk_sk_network_km,
    a.ch_cm_co_pk_sk_stream_km,
    a.ch_cm_co_pk_sk_lakereservoir_ha,
    a.ch_cm_co_pk_sk_wetland_ha,
    a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
    a.ch_cm_co_pk_sk_slopeclass03_km,
    a.ch_cm_co_pk_sk_slopeclass05_km,
    a.ch_cm_co_pk_sk_slopeclass08_km,
    a.ch_cm_co_pk_sk_slopeclass15_km,
    a.ch_cm_co_pk_sk_slopeclass22_km,
    a.ch_cm_co_pk_sk_slopeclass30_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
    a.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,

    array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
    a.st_network_km,
    a.st_stream_km,
    a.st_lakereservoir_ha,
    a.st_wetland_ha,
    a.st_slopeclass03_waterbodies_km,
    a.st_slopeclass03_km,
    a.st_slopeclass05_km,
    a.st_slopeclass08_km,
    a.st_slopeclass15_km,
    a.st_slopeclass22_km,
    a.st_slopeclass30_km,
    a.st_belowupstrbarriers_network_km,
    a.st_belowupstrbarriers_stream_km,
    a.st_belowupstrbarriers_lakereservoir_ha,
    a.st_belowupstrbarriers_wetland_ha,
    a.st_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.st_belowupstrbarriers_slopeclass03_km,
    a.st_belowupstrbarriers_slopeclass05_km,
    a.st_belowupstrbarriers_slopeclass08_km,
    a.st_belowupstrbarriers_slopeclass15_km,
    a.st_belowupstrbarriers_slopeclass22_km,
    a.st_belowupstrbarriers_slopeclass30_km,

    array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
    a.wct_network_km,
    a.wct_stream_km,
    a.wct_lakereservoir_ha,
    a.wct_wetland_ha,
    a.wct_slopeclass03_waterbodies_km,
    a.wct_slopeclass03_km,
    a.wct_slopeclass05_km,
    a.wct_slopeclass08_km,
    a.wct_slopeclass15_km,
    a.wct_slopeclass22_km,
    a.wct_slopeclass30_km,
    a.wct_belowupstrbarriers_network_km,
    a.wct_belowupstrbarriers_stream_km,
    a.wct_belowupstrbarriers_lakereservoir_ha,
    a.wct_belowupstrbarriers_wetland_ha,
    a.wct_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.wct_belowupstrbarriers_slopeclass03_km,
    a.wct_belowupstrbarriers_slopeclass05_km,
    a.wct_belowupstrbarriers_slopeclass08_km,
    a.wct_belowupstrbarriers_slopeclass15_km,
    a.wct_belowupstrbarriers_slopeclass22_km,
    a.wct_belowupstrbarriers_slopeclass30_km,

    -- habitat models
    h.bt_spawning_km,
    h.bt_rearing_km,
    h.bt_spawningrearing_km,
    h.bt_spawning_belowupstrbarriers_km,
    h.bt_rearing_belowupstrbarriers_km,
    h.bt_spawningrearing_belowupstrbarriers_km,
    h.ch_spawning_km,
    h.ch_rearing_km,
    h.ch_spawningrearing_km,
    h.ch_spawning_belowupstrbarriers_km,
    h.ch_rearing_belowupstrbarriers_km,
    h.ch_spawningrearing_belowupstrbarriers_km,
    h.cm_spawning_km,
    h.cm_spawning_belowupstrbarriers_km,
    h.co_spawning_km,
    h.co_rearing_km,
    h.co_rearing_ha,
    h.co_spawningrearing_km,
    h.co_spawning_belowupstrbarriers_km,
    h.co_rearing_belowupstrbarriers_km,
    h.co_rearing_belowupstrbarriers_ha,
    h.co_spawningrearing_belowupstrbarriers_km,
    h.pk_spawning_km,
    h.pk_spawning_belowupstrbarriers_km,
    h.sk_spawning_km,
    h.sk_rearing_km,
    h.sk_rearing_ha,
    h.sk_spawningrearing_km,
    h.sk_spawning_belowupstrbarriers_km,
    h.sk_rearing_belowupstrbarriers_km,
    h.sk_rearing_belowupstrbarriers_ha,
    h.sk_spawningrearing_belowupstrbarriers_km,
    h.st_spawning_km,
    h.st_rearing_km,
    h.st_spawningrearing_km,
    h.st_spawning_belowupstrbarriers_km,
    h.st_rearing_belowupstrbarriers_km,
    h.st_spawningrearing_belowupstrbarriers_km,
    h.salmon_spawningrearing_km,
    h.salmon_spawningrearing_belowupstrbarriers_km,
    h.salmonsteelhead_spawningrearing_km,
    h.salmonsteelhead_spawningrearing_belowupstrbarriers_km,
    h.wct_spawning_km,
    h.wct_rearing_km,
    h.wct_spawningrearing_km,
    h.wct_spawning_belowupstrbarriers_km,
    h.wct_rearing_belowupstrbarriers_km,
    h.wct_spawningrearing_belowupstrbarriers_km,
    c.geom
  from bcfishpass.crossings c
  left outer join bcfishpass.crossings_dnstr_observations cdo on c.aggregated_crossings_id = cdo.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstr_observations cuo on c.aggregated_crossings_id = cuo.aggregated_crossings_id
  left outer join bcfishpass.crossings_dnstr_crossings cd on c.aggregated_crossings_id = cd.aggregated_crossings_id
  left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on c.aggregated_crossings_id = ad.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstr_barriers_anthropogenic au on c.aggregated_crossings_id = au.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstr_barriers_per_model aum on c.aggregated_crossings_id = aum.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstream_habitat h on c.aggregated_crossings_id = h.aggregated_crossings_id
  left outer join bcfishpass.streams s on c.linear_feature_id = s.linear_feature_id
  left outer join whse_basemapping.dbm_mof_50k_grid t ON ST_Intersects(c.geom, t.geom)
  order by c.aggregated_crossings_id, s.downstream_route_measure;

  create unique index on bcfishpass.crossings_vw (aggregated_crossings_id);
  create index on bcfishpass.crossings_vw using gist (geom);

  comment on column bcfishpass.crossings_vw.aggregated_crossings_id IS 'unique identifier for crossing, generated from stream_crossing_id, modelled_crossing_id + 1000000000, user_barrier_anthropogenic_id + 1200000000, cabd_id';
  comment on column bcfishpass.crossings_vw.stream_crossing_id IS 'PSCIS stream crossing unique identifier';
  comment on column bcfishpass.crossings_vw.dam_id IS 'BC Dams unique identifier';
  comment on column bcfishpass.crossings_vw.user_crossing_misc_id IS 'Misc user added crossings unique identifier';
  comment on column bcfishpass.crossings_vw.modelled_crossing_id IS 'Modelled crossing unique identifier';
  comment on column bcfishpass.crossings_vw.crossing_source IS 'Data source for the crossing, one of: {PSCIS,MODELLED CROSSINGS,CABD,MISC BARRIERS}';
  comment on column bcfishpass.crossings_vw.pscis_status IS 'From PSCIS, the current_pscis_status of the crossing, one of: {ASSESSED,HABITAT CONFIRMATION,DESIGN,REMEDIATED}';
  comment on column bcfishpass.crossings_vw.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. Acceptable types are: OBS = Open Bottom Structure CBS = Closed Bottom Structure OTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';
  comment on column bcfishpass.crossings_vw.crossing_subtype_code IS 'Further definition of the type of crossing, one of {BRIDGE,CRTBOX,DAM,FORD,OVAL,PIPEARCH,ROUND,WEIR,WOODBOX,NULL}';
  comment on column bcfishpass.crossings_vw.modelled_crossing_type_source IS 'List of sources that indicate if a modelled crossing is open bottom, Acceptable values are: FWA_EDGE_TYPE=double line river, FWA_STREAM_ORDER=stream order >=6, GBA_RAILWAY_STRUCTURE_LINES_SP=railway structure, "MANUAL FIX"=manually identified OBS, MOT_ROAD_STRUCTURE_SP=MoT structure, TRANSPORT_LINE_STRUCTURE_CODE=DRA structure}';
  comment on column bcfishpass.crossings_vw.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. Acceptable Values are: PASSABLE - Passable, POTENTIAL - Potential or partial barrier, BARRIER - Barrier, UNKNOWN - Other';
  comment on column bcfishpass.crossings_vw.pscis_road_name  IS 'PSCIS road name, taken from the PSCIS assessment data submission';
  comment on column bcfishpass.crossings_vw.pscis_stream_name  IS 'PSCIS stream name, taken from the PSCIS assessment data submission';
  comment on column bcfishpass.crossings_vw.pscis_assessment_comment  IS 'PSCIS assessment_comment, taken from the PSCIS assessment data submission';
  comment on column bcfishpass.crossings_vw.pscis_assessment_date  IS 'PSCIS assessment_date, taken from the PSCIS assessment data submission';
  comment on column bcfishpass.crossings_vw.pscis_final_score IS 'PSCIS final_score, taken from the PSCIS assessment data submission';
  comment on column bcfishpass.crossings_vw.transport_line_structured_name_1 IS 'DRA road name, taken from the nearest DRA road (within 30m)';
  comment on column bcfishpass.crossings_vw.transport_line_type_description IS 'DRA road type, taken from the nearest DRA road (within 30m)';
  comment on column bcfishpass.crossings_vw.transport_line_surface_description IS 'DRA road surface, taken from the nearest DRA road (within 30m)';
  comment on column bcfishpass.crossings_vw.ften_forest_file_id IS 'FTEN road forest_file_id value, taken from the nearest FTEN road (within 30m)';
  comment on column bcfishpass.crossings_vw.ften_road_section_id IS 'FTEN road road_section_id value, taken from the nearest FTEN road (within 30m)';
  comment on column bcfishpass.crossings_vw.ften_file_type_description IS 'FTEN road tenure type (Forest Service Road, Road Permit, etc), taken from the nearest FTEN road (within 30m)';
  comment on column bcfishpass.crossings_vw.ften_client_number IS 'FTEN road client number, taken from the nearest FTEN road (within 30m)';
  comment on column bcfishpass.crossings_vw.ften_client_name IS 'FTEN road client name, taken from the nearest FTEN road (within 30m)';
  comment on column bcfishpass.crossings_vw.ften_life_cycle_status_code IS 'FTEN road life_cycle_status_code (active or retired, pending roads are not included), taken from the nearest FTEN road (within 30m)';
  comment on column bcfishpass.crossings_vw.ften_map_label IS 'FTEN road map_label value, taken from the nearest FTEN road (within 30m)';
  comment on column bcfishpass.crossings_vw.rail_track_name IS 'Railway name, taken from nearest railway (within 25m)';
  comment on column bcfishpass.crossings_vw.rail_owner_name IS 'Railway owner name, taken from nearest railway (within 25m)';
  comment on column bcfishpass.crossings_vw.rail_operator_english_name IS 'Railway operator name, taken from nearest railway (within 25m)';;
  comment on column bcfishpass.crossings_vw.ogc_proponent IS 'OGC road tenure proponent (currently modelled crossings only, taken from OGC road that crosses the stream)';
  comment on column bcfishpass.crossings_vw.dam_name IS 'See CABD dams column: dam_name_en';
  comment on column bcfishpass.crossings_vw.dam_height IS 'See CABD dams column: dam_height';
  comment on column bcfishpass.crossings_vw.dam_owner IS 'See CABD dams column: owner';
  comment on column bcfishpass.crossings_vw.dam_use IS 'See CABD table dam_use_codes';
  comment on column bcfishpass.crossings_vw.dam_operating_status IS 'See CABD dams column dam_operating_status';
  comment on column bcfishpass.crossings_vw.utm_zone IS 'UTM ZONE is a segment of the Earths surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';
  comment on column bcfishpass.crossings_vw.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';
  comment on column bcfishpass.crossings_vw.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';
  comment on column bcfishpass.crossings_vw.linear_feature_id IS 'From BC FWA, the unique identifier for a stream segment (flow network arc)';
  comment on column bcfishpass.crossings_vw.blue_line_key IS 'From BC FWA, uniquely identifies a single flow line such that a main channel and a secondary channel with the same watershed code would have different blue line keys (the Fraser River and all side channels have different blue line keys).';
  comment on column bcfishpass.crossings_vw.watershed_key IS 'From BC FWA, a key that identifies a stream system. There is a 1:1 match between a watershed key and watershed code. The watershed key will match the blue line key for the mainstem.';
  comment on column bcfishpass.crossings_vw.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';
  comment on column bcfishpass.crossings_vw.wscode IS 'A truncated version of the BC FWA fwa_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';
  comment on column bcfishpass.crossings_vw.localcode IS 'A truncated version of the BC FWA local_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';;
  comment on column bcfishpass.crossings_vw.watershed_group_code IS 'The watershed group code associated with the feature.';
  comment on column bcfishpass.crossings_vw.gnis_stream_name IS 'The BCGNIS (BC Geographical Names Information System) name associated with the FWA stream';
  comment on column bcfishpass.crossings_vw.stream_order IS 'Order of FWA stream at point';
  comment on column bcfishpass.crossings_vw.stream_magnitude IS 'Magnitude of FWA stream at point';
  comment on column bcfishpass.crossings_vw.upstream_area_ha IS 'Cumulative area upstream of the end of the stream (as defined by linear_feature_id)';
  comment on column bcfishpass.crossings_vw.stream_order_parent IS 'Stream order of the stream into which the stream drains';
  comment on column bcfishpass.crossings_vw.stream_order_max IS 'Maximum stream order associated with the stream (as defined by blue_line_key)';
  comment on column bcfishpass.crossings_vw.map_upstream IS 'Mean annual precipitation for the watershed upstream of the stream segment (as defined by linear_feature_id)';
  comment on column bcfishpass.crossings_vw.channel_width IS 'Modelled channel width of the stream (m)';
  comment on column bcfishpass.crossings_vw.mad_m3s IS 'Modelled mean annual discharge of the stream (m3/s)';
  comment on column bcfishpass.crossings_vw.observedspp_dnstr IS 'Species codes of downstream fish observations';
  comment on column bcfishpass.crossings_vw.observedspp_upstr IS 'Species codes of upstream fish observations';
  comment on column bcfishpass.crossings_vw.crossings_dnstr IS 'aggregated_crossings_id value for all downstream crossings';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_dnstr IS 'aggregated_crossings_id value for all downstream anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_dnstr_count IS 'Count of anthropogenic downstream barriers';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_upstr IS 'aggregated_crossings_id value for all upstream anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_upstr_count IS 'Count of all upstream anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_bt_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Bull Trout';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_upstr_bt_count IS 'Count of upstream anthropogenic barriers on streams accessible to Bull Trout';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Pacific Salmon';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Pacific Salmon';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_st_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Steelhead';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_st_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Steelhead';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_wct_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to West Slope Cutthroat Trout';
  comment on column bcfishpass.crossings_vw.barriers_anthropogenic_wct_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Bull Trout';
  comment on column bcfishpass.crossings_vw.gradient IS 'Gradient of stream segment at crossing (defined by stream_segment_id)';
  comment on column bcfishpass.crossings_vw.total_network_km IS 'Total upstream length of FWA stream network (km)';
  comment on column bcfishpass.crossings_vw.total_stream_km IS 'Total upstream length of FWA streams (single and double line, km)';
  comment on column bcfishpass.crossings_vw.total_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs (ha)';
  comment on column bcfishpass.crossings_vw.total_wetland_ha IS 'Total upstream area of wetlands (ha)';
  comment on column bcfishpass.crossings_vw.total_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies (km)';
  comment on column bcfishpass.crossings_vw.total_slopeclass03_km IS 'Total upstream length of stream < 3% gradient (km)';
  comment on column bcfishpass.crossings_vw.total_slopeclass05_km IS 'Total upstream length of stream < 5% gradient (km)';
  comment on column bcfishpass.crossings_vw.total_slopeclass08_km IS 'Total upstream length of stream < 8% gradient (km)';
  comment on column bcfishpass.crossings_vw.total_slopeclass15_km IS 'Total upstream length of stream < 15% gradient (km)';
  comment on column bcfishpass.crossings_vw.total_slopeclass22_km IS 'Total upstream length of stream < 22% gradient (km)';
  comment on column bcfishpass.crossings_vw.total_slopeclass30_km IS 'Total upstream length of stream < 30% gradient (km)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams, downstream of any anthropogenic barrier  (single and double line, km)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.barriers_bt_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Bull Trout';
  comment on column bcfishpass.crossings_vw.bt_network_km IS 'Total upstream length of FWA stream network accessible to Bull Trout (km)';
  comment on column bcfishpass.crossings_vw.bt_stream_km IS 'Total upstream length of FWA streams accessible to Bull Trout (single and double line, km)';
  comment on column bcfishpass.crossings_vw.bt_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Bull Trout (ha)';
  comment on column bcfishpass.crossings_vw.bt_wetland_ha IS 'Total upstream area of wetlands accessible to Bull Trout (ha)';
  comment on column bcfishpass.crossings_vw.bt_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Bull Trout (km)';
  comment on column bcfishpass.crossings_vw.bt_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Bull Trout (km)';
  comment on column bcfishpass.crossings_vw.bt_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Bull Trout (km)';
  comment on column bcfishpass.crossings_vw.bt_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Bull Trout (km)';
  comment on column bcfishpass.crossings_vw.bt_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Bull Trout (km)';
  comment on column bcfishpass.crossings_vw.bt_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Bull Trout (km)';
  comment on column bcfishpass.crossings_vw.bt_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Bull Trout (km)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Bull Trout, downstream of any anthropogenic barrier  (single and double line, km)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Bull Trout, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Bull Trout, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.barriers_ch_cm_co_pk_sk_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Pacific Salmon';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_network_km IS 'Total upstream length of FWA stream network accessible to Pacific Salmon (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_stream_km IS 'Total upstream length of FWA streams accessible to Pacific Salmon (single and double line, km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Pacific Salmon (ha)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_wetland_ha IS 'Total upstream area of wetlands accessible to Pacific Salmon (ha)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Pacific Salmon (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Pacific Salmon (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Pacific Salmon (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Pacific Salmon (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Pacific Salmon (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Pacific Salmon (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Pacific Salmon (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Pacific Salmon, downstream of any anthropogenic barrier  (single and double line, km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Pacific Salmon, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Pacific Salmon, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.barriers_st_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Steelhead';
  comment on column bcfishpass.crossings_vw.st_network_km IS 'Total upstream length of FWA stream network accessible to Steelhead (km)';
  comment on column bcfishpass.crossings_vw.st_stream_km IS 'Total upstream length of FWA streams accessible to Steelhead (single and double line, km)';
  comment on column bcfishpass.crossings_vw.st_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Steelhead (ha)';
  comment on column bcfishpass.crossings_vw.st_wetland_ha IS 'Total upstream area of wetlands accessible to Steelhead (ha)';
  comment on column bcfishpass.crossings_vw.st_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Steelhead (km)';
  comment on column bcfishpass.crossings_vw.st_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Steelhead (km)';
  comment on column bcfishpass.crossings_vw.st_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Steelhead (km)';
  comment on column bcfishpass.crossings_vw.st_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Steelhead (km)';
  comment on column bcfishpass.crossings_vw.st_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Steelhead (km)';
  comment on column bcfishpass.crossings_vw.st_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Steelhead (km)';
  comment on column bcfishpass.crossings_vw.st_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Steelhead (km)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Steelhead, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Steelhead, downstream of any anthropogenic barrier  (single and double line, km)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Steelhead, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Steelhead, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Steelhead, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.barriers_wct_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to West Slope Cutthroat Trout';
  comment on column bcfishpass.crossings_vw.wct_network_km IS 'Total upstream length of FWA stream network accessible to West Slope Cutthroat Trout (km)';
  comment on column bcfishpass.crossings_vw.wct_stream_km IS 'Total upstream length of FWA streams accessible to West Slope Cutthroat Trout (single and double line, km)';
  comment on column bcfishpass.crossings_vw.wct_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to West Slope Cutthroat Trout (ha)';
  comment on column bcfishpass.crossings_vw.wct_wetland_ha IS 'Total upstream area of wetlands accessible to West Slope Cutthroat Trout (ha)';
  comment on column bcfishpass.crossings_vw.wct_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to West Slope Cutthroat Trout (km)';
  comment on column bcfishpass.crossings_vw.wct_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to West Slope Cutthroat Trout (km)';
  comment on column bcfishpass.crossings_vw.wct_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to West Slope Cutthroat Trout (km)';
  comment on column bcfishpass.crossings_vw.wct_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to West Slope Cutthroat Trout (km)';
  comment on column bcfishpass.crossings_vw.wct_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to West Slope Cutthroat Trout (km)';
  comment on column bcfishpass.crossings_vw.wct_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to West Slope Cutthroat Trout (km)';
  comment on column bcfishpass.crossings_vw.wct_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to West Slope Cutthroat Trout (km)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (single and double line, km)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (ha)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
  comment on column bcfishpass.crossings_vw.bt_spawning_km IS 'Upstream length of modelled/observed Bull Trout spawning';
  comment on column bcfishpass.crossings_vw.bt_rearing_km IS 'Upstream length of modelled/observed Bull Trout rearing';
  comment on column bcfishpass.crossings_vw.bt_spawningrearing_km IS 'Upstream length of modelled/observed Bull Trout spawning and/or rearing';
  comment on column bcfishpass.crossings_vw.bt_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Bull Trout spawning, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.bt_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Bull Trout rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.bt_spawningrearing_km IS 'Upstream length of modelled/observed Bull Trout spawning and/or rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.ch_spawning_km IS 'Upstream length of modelled/observed Chinook spawning';
  comment on column bcfishpass.crossings_vw.ch_rearing_km IS 'Upstream length of modelled/observed Chinook rearing';
  comment on column bcfishpass.crossings_vw.ch_spawningrearing_km IS 'Upstream length of modelled/observed Chinook spawning and/or rearing';
  comment on column bcfishpass.crossings_vw.ch_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook spawning, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.ch_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.ch_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook spawning and/or rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.cm_spawning_km IS 'Upstream length of modelled/observed Chum spawning';
  comment on column bcfishpass.crossings_vw.cm_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chum spawning, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.co_spawning_km IS 'Upstream length of modelled/observed Coho spawning';
  comment on column bcfishpass.crossings_vw.co_rearing_km IS 'Upstream length of modelled/observed Coho rearing';
  comment on column bcfishpass.crossings_vw.co_spawningrearing_km IS 'Upstream length of modelled/observed Coho spawning and/or rearing';
  comment on column bcfishpass.crossings_vw.co_rearing_ha IS 'Upstream area (wetlands) of modelled/observed Coho rearing';
  comment on column bcfishpass.crossings_vw.co_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho spawning, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.co_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.co_rearing_belowupstrbarriers_ha IS 'Upstream area (wetlands) of modelled/observed Coho rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.co_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho spawning and/or rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.pk_spawning_km IS 'Upstream length of modelled/observed Pink spawning';
  comment on column bcfishpass.crossings_vw.pk_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Pink spawning, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.sk_spawning_km IS 'Upstream length of modelled/observed Sockeye spawning';
  comment on column bcfishpass.crossings_vw.sk_rearing_km IS 'Upstream length of modelled/observed Sockeye rearing';
  comment on column bcfishpass.crossings_vw.sk_rearing_ha IS 'Upstream area (lakes) of modelled/observed Sockeye rearing';
  comment on column bcfishpass.crossings_vw.sk_spawningrearing_km IS 'Upstream length of modelled/observed Sockeye spawning and/or rearing';
  comment on column bcfishpass.crossings_vw.sk_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Sockeye spawning';
  comment on column bcfishpass.crossings_vw.sk_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Sockeye rearing';
  comment on column bcfishpass.crossings_vw.sk_rearing_belowupstrbarriers_ha IS 'Upstream area (lakes) of modelled/observed Sockeye rearing';
  comment on column bcfishpass.crossings_vw.st_spawning_km IS 'Upstream length of modelled/observed Steelhead spawning';
  comment on column bcfishpass.crossings_vw.st_rearing_km IS 'Upstream length of modelled/observed Steelhead rearing';
  comment on column bcfishpass.crossings_vw.st_spawningrearing_km IS 'Upstream length of modelled/observed Steelhead spawning and/or rearing';
  comment on column bcfishpass.crossings_vw.st_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead spawning, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.st_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.st_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead spawning and/or rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.salmon_spawningrearing_km IS 'Upstream length of modelled/observed Salmon spawning and/or rearing';
  comment on column bcfishpass.crossings_vw.salmon_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Salmon spawning and/or rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.salmonsteelhead_spawningrearing_km IS 'Upstream length of modelled/observed Salmon and/or Steelhead spawning and/or rearing';
  comment on column bcfishpass.crossings_vw.salmonsteelhead_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Salmon and/or Steelhead spawning and/or rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.wct_spawning_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning';
  comment on column bcfishpass.crossings_vw.wct_rearing_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout rearing';
  comment on column bcfishpass.crossings_vw.wct_spawningrearing_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning and/or rearing';
  comment on column bcfishpass.crossings_vw.wct_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.wct_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.wct_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning and/or rearing, downstream of any anthropogenic barriers';
  comment on column bcfishpass.crossings_vw.geom IS 'The point geometry associated with the feature';


  -- drop wcrp crossings view and any dependent objects (these are managed separately by CWF)
  DROP MATERIALIZED VIEW bcfishpass.crossings_wcrp_vw CASCADE;

  CREATE MATERIALIZED VIEW bcfishpass.crossings_wcrp_vw as

  -- find upstream crossings with wcrp 'all spawning rearing habitat' upstream
  with upstr_wcrp_barriers as materialized (
    select distinct
     ba.aggregated_crossings_id,
     h.aggregated_crossings_id as upstr_barriers,
     h.all_spawningrearing_km
    from bcfishpass.crossings_upstr_barriers_anthropogenic ba
    inner join bcfishpass.crossings_upstream_habitat_wcrp h on h.aggregated_crossings_id = any(ba.features_upstr)
    where h.all_spawningrearing_km > 0
    order by ba.aggregated_crossings_id, h.aggregated_crossings_id
  ),

  -- aggregate the upstream wcrp crossings into a list and count
  upstr_wcrp_barriers_list as (
    select
      aggregated_crossings_id,
      array_to_string(array_agg(upstr_barriers), ';') as barriers_anthropogenic_habitat_wcrp_upstr,
      coalesce(array_length(array_agg(upstr_barriers), 1), 0) as barriers_anthropogenic_habitat_wcrp_upstr_count
    from upstr_wcrp_barriers
    group by aggregated_crossings_id
    order by aggregated_crossings_id
  )

  select
    -- joining to streams based on measure can be error prone due to precision.
    -- Join to streams on linear_feature_id and keep the first result
    -- (since streams are segmented there is often >1 match)
    distinct on (c.aggregated_crossings_id)
    c.aggregated_crossings_id,
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
    c.wscode_ltree as wscode,
    c.localcode_ltree as localcode,
    c.watershed_group_code,
    c.gnis_stream_name,
    array_to_string(ad.features_dnstr, ';') as barriers_anthropogenic_dnstr,
    coalesce(array_length(ad.features_dnstr, 1), 0) as barriers_anthropogenic_dnstr_count,
    uwbl.barriers_anthropogenic_habitat_wcrp_upstr,
    uwbl.barriers_anthropogenic_habitat_wcrp_upstr_count,

    -- access models
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
    array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,

    -- habitat models
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
  from bcfishpass.crossings c
  inner join bcfishpass.wcrp_watersheds w on c.watershed_group_code = w.watershed_group_code  -- only include crossings in WCRP watersheds
  left outer join bcfishpass.crossings_dnstr_observations cdo on c.aggregated_crossings_id = cdo.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstr_observations cuo on c.aggregated_crossings_id = cuo.aggregated_crossings_id
  left outer join bcfishpass.crossings_dnstr_crossings cd on c.aggregated_crossings_id = cd.aggregated_crossings_id
  left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on c.aggregated_crossings_id = ad.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstr_barriers_anthropogenic au on c.aggregated_crossings_id = au.aggregated_crossings_id
  left outer join upstr_wcrp_barriers_list uwbl on c.aggregated_crossings_id = uwbl.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstream_habitat h on c.aggregated_crossings_id = h.aggregated_crossings_id
  left outer join bcfishpass.crossings_upstream_habitat_wcrp h_wcrp on c.aggregated_crossings_id = h_wcrp.aggregated_crossings_id
  left outer join bcfishpass.streams s on c.linear_feature_id = s.linear_feature_id
  left outer join whse_basemapping.dbm_mof_50k_grid t ON ST_Intersects(c.geom, t.geom)
  left outer join bcfishpass.wcrp_ranked_barriers r ON c.aggregated_crossings_id = r.aggregated_crossings_id
  where coalesce(c.stream_crossing_id, 0) NOT IN (199427,197789,197838,197861,197805,125961,199428) -- PSCIS crossings to exclude from CWF reporting/mapping
  order by c.aggregated_crossings_id, s.downstream_route_measure;


COMMIT;