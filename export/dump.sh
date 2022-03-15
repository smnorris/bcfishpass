#!/bin/bash
set -euxo pipefail

#rm -r outputs       # remove existing dump
mkdir -p outputs    # make fresh dump folder

# dump crossings
ogr2ogr \
    -f GPKG \
    outputs/bcfishpass.gpkg \
    PG:$DATABASE_URL \
    -nln crossings \
    -sql "select
    aggregated_crossings_id,
    stream_crossing_id,
    dam_id,
    user_barrier_anthropogenic_id,
    modelled_crossing_id,
    crossing_source,
    crossing_feature_type,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    array_to_string(modelled_crossing_type_source,';') as modelled_crossing_type_source,
    barrier_status,
    pscis_road_name,
    pscis_stream_name,
    pscis_assessment_comment,
    pscis_assessment_date,
    pscis_final_score,
    transport_line_structured_name_1,
    transport_line_type_description,
    transport_line_surface_description,
    ften_forest_file_id,
    ften_file_type_description,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,
    rail_track_name,
    rail_owner_name,
    rail_operator_english_name,
    ogc_proponent,
    dam_name,
    dam_owner,
    utm_zone,
    utm_easting,
    utm_northing,
    dbm_mof_50k_grid,
    linear_feature_id,
    blue_line_key,
    watershed_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    gnis_stream_name,
    stream_order,
    stream_magnitude,
    watershed_upstr_ha,
    array_to_string(observedspp_dnstr, ';') as observedspp_dnstr,
    array_to_string(observedspp_upstr, ';') as observedspp_upstr,
    array_to_string(crossings_dnstr, ';') as crossings_dnstr,
    array_to_string(barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
    array_to_string(barriers_anthropogenic_upstr, ';') as barriers_anthropogenic_upstr,
    barriers_anthropogenic_dnstr_count,
    barriers_anthropogenic_upstr_count,
    gradient,
    total_network_km,
    total_stream_km,
    total_lakereservoir_ha,
    total_wetland_ha,
    total_slopeclass03_waterbodies_km,
    total_slopeclass03_km,
    total_slopeclass05_km,
    total_slopeclass08_km,
    total_slopeclass15_km,
    total_slopeclass22_km,
    total_slopeclass30_km,
    total_belowupstrbarriers_network_km,
    total_belowupstrbarriers_stream_km,
    total_belowupstrbarriers_lakereservoir_ha,
    total_belowupstrbarriers_wetland_ha,
    total_belowupstrbarriers_slopeclass03_waterbodies_km,
    total_belowupstrbarriers_slopeclass03_km,
    total_belowupstrbarriers_slopeclass05_km,
    total_belowupstrbarriers_slopeclass08_km,
    total_belowupstrbarriers_slopeclass15_km,
    total_belowupstrbarriers_slopeclass22_km,
    total_belowupstrbarriers_slopeclass30_km,
    access_model_ch_co_sk,
    ch_co_sk_network_km,
    ch_co_sk_stream_km,
    ch_co_sk_lakereservoir_ha,
    ch_co_sk_wetland_ha,
    ch_co_sk_slopeclass03_waterbodies_km,
    ch_co_sk_slopeclass03_km,
    ch_co_sk_slopeclass05_km,
    ch_co_sk_slopeclass08_km,
    ch_co_sk_slopeclass15_km,
    ch_co_sk_slopeclass22_km,
    ch_co_sk_slopeclass30_km,
    ch_co_sk_belowupstrbarriers_network_km,
    ch_co_sk_belowupstrbarriers_stream_km,
    ch_co_sk_belowupstrbarriers_lakereservoir_ha,
    ch_co_sk_belowupstrbarriers_wetland_ha,
    ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
    ch_co_sk_belowupstrbarriers_slopeclass03_km,
    ch_co_sk_belowupstrbarriers_slopeclass05_km,
    ch_co_sk_belowupstrbarriers_slopeclass08_km,
    ch_co_sk_belowupstrbarriers_slopeclass15_km,
    ch_co_sk_belowupstrbarriers_slopeclass22_km,
    ch_co_sk_belowupstrbarriers_slopeclass30_km,
    access_model_st,
    st_network_km,
    st_stream_km,
    st_lakereservoir_ha,
    st_wetland_ha,
    st_slopeclass03_waterbodies_km,
    st_slopeclass03_km,
    st_slopeclass05_km,
    st_slopeclass08_km,
    st_slopeclass15_km,
    st_slopeclass22_km,
    st_slopeclass30_km,
    st_belowupstrbarriers_network_km,
    st_belowupstrbarriers_stream_km,
    st_belowupstrbarriers_lakereservoir_ha,
    st_belowupstrbarriers_wetland_ha,
    st_belowupstrbarriers_slopeclass03_waterbodies_km,
    st_belowupstrbarriers_slopeclass03_km,
    st_belowupstrbarriers_slopeclass05_km,
    st_belowupstrbarriers_slopeclass08_km,
    st_belowupstrbarriers_slopeclass15_km,
    st_belowupstrbarriers_slopeclass22_km,
    st_belowupstrbarriers_slopeclass30_km,
    access_model_wct,
    wct_network_km,
    wct_stream_km,
    wct_lakereservoir_ha,
    wct_wetland_ha,
    wct_slopeclass03_waterbodies_km,
    wct_slopeclass03_km,
    wct_slopeclass05_km,
    wct_slopeclass08_km,
    wct_slopeclass15_km,
    wct_slopeclass22_km,
    wct_slopeclass30_km,
    wct_belowupstrbarriers_network_km,
    wct_belowupstrbarriers_stream_km,
    wct_belowupstrbarriers_lakereservoir_ha,
    wct_belowupstrbarriers_wetland_ha,
    wct_belowupstrbarriers_slopeclass03_waterbodies_km,
    wct_belowupstrbarriers_slopeclass03_km,
    wct_belowupstrbarriers_slopeclass05_km,
    wct_belowupstrbarriers_slopeclass08_km,
    wct_belowupstrbarriers_slopeclass15_km,
    wct_belowupstrbarriers_slopeclass22_km,
    wct_belowupstrbarriers_slopeclass30_km,
    ch_spawning_km,
    ch_rearing_km,
    ch_spawning_belowupstrbarriers_km,
    ch_rearing_belowupstrbarriers_km,
    co_spawning_km,
    co_rearing_km,
    co_rearing_ha,
    co_spawning_belowupstrbarriers_km,
    co_rearing_belowupstrbarriers_km,
    co_rearing_belowupstrbarriers_ha,
    sk_spawning_km,
    sk_rearing_km,
    sk_rearing_ha,
    sk_spawning_belowupstrbarriers_km,
    sk_rearing_belowupstrbarriers_km,
    sk_rearing_belowupstrbarriers_ha,
    st_spawning_km,
    st_rearing_km,
    st_spawning_belowupstrbarriers_km,
    st_rearing_belowupstrbarriers_km,
    wct_spawning_km,
    wct_rearing_km,
    wct_spawning_belowupstrbarriers_km,
    wct_rearing_belowupstrbarriers_km,
    all_spawning_km,
    all_spawning_belowupstrbarriers_km,
    all_rearing_km,
    all_rearing_belowupstrbarriers_km,
    all_spawningrearing_km,
    all_spawningrearing_belowupstrbarriers_km,
    wct_betweenbarriers_network_km,
    wct_spawning_betweenbarriers_km,
    wct_rearing_betweenbarriers_km,
    wct_spawningrearing_betweenbarriers_km,
    all_spawningrearing_per_barrier,
    geom
    from bcfishpass.crossings"

# pscis not matched to streams
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    outputs/bcfishpass.gpkg \
    PG:$DATABASE_URL \
    -nln pscis_not_matched_to_streams \
    -sql "select * from bcfishpass.pscis_not_matched_to_streams_vw"

# dump streams
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    outputs/bcfishpass.gpkg \
    PG:$DATABASE_URL \
    -nln streams \
    -sql "SELECT segmented_stream_id,
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
     gnis_name,
     stream_order,
     stream_magnitude,
     gradient,
     feature_code,
     upstream_route_measure,
     upstream_area_ha,
     map_upstream,
     channel_width,
     null as mad_m3s,
     array_to_string(barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
     array_to_string(barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
     array_to_string(barriers_remediated_dnstr, ';') as barriers_remediated_dnstr,
     array_to_string(barriers_ch_co_sk_dnstr, ';') as barriers_ch_co_sk_dnstr,
     array_to_string(barriers_ch_co_sk_b_dnstr, ';') as barriers_ch_co_sk_b_dnstr,
     array_to_string(barriers_st_dnstr, ';') as barriers_st_dnstr,
     array_to_string(barriers_pk_dnstr, ';') as barriers_pk_dnstr,
     array_to_string(barriers_cm_dnstr, ';') as barriers_cm_dnstr,
     array_to_string(barriers_bt_dnstr, ';') as barriers_bt_dnstr,
     array_to_string(barriers_wct_dnstr, ';') as barriers_wct_dnstr,
     array_to_string(barriers_gr_dnstr, ';') as barriers_gr_dnstr,
     array_to_string(barriers_rb_dnstr, ';') as barriers_rb_dnstr,
     array_to_string(obsrvtn_pnt_distinct_upstr, ';') as obsrvtn_pnt_distinct_upstr,
     array_to_string(obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
     access_model_ch_co_sk,
     access_model_st,
     access_model_wct,
     access_model_bt,
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
     from bcfishpass.streams"

#zip -Dr outputs/bcfishpass.gpkg.zip outputs/bcfishpass.gpkg
#rm outputs/bcfishpass.gpkg

# dump column descriptions for each table
psql2csv "SELECT a.attname As column_name,  d.description
FROM pg_class As c
INNER JOIN pg_attribute As a ON c.oid = a.attrelid
LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace
LEFT JOIN pg_description As d ON (d.objoid = c.oid AND d.objsubid = a.attnum)
WHERE  c.relkind IN('r', 'v') AND  n.nspname = 'bcfishpass' AND c.relname = 'crossings'
AND a.attname not in ('cmax','cmin','tableoid','xmax','xmin','ctid','geom');" > outputs/bcfishpass_crossings_column_descriptions.csv

psql2csv "SELECT a.attname As column_name,  d.description
FROM pg_class As c
INNER JOIN pg_attribute As a ON c.oid = a.attrelid
LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace
LEFT JOIN pg_description As d ON (d.objoid = c.oid AND d.objsubid = a.attnum)
WHERE  c.relkind IN('r', 'v') AND  n.nspname = 'bcfishpass' AND c.relname = 'streams'
AND a.attname not in ('cmax','cmin','tableoid','xmax','xmin','ctid','geom');" > outputs/bcfishpass_streams_column_descriptions.csv
