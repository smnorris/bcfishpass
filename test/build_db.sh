#!/bin/bash
set -euxo pipefail

# ------
# Build a minimal fwapg/bcfishobs database for testing
# ------

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS="BELA\nBULK\nCOWN\nELKR\nHORS\nLNIC\nPARS\nSANJ\nVICT"       # edit here to adjust testing watersheds (could pull from parameters/example_testing/parameters_habitat_method)


# ------
# load_fwa
# ------
# load only watershed groups of interest
# wsg.txt controls what watersheds are loaded (for chunked data)

git clone https://github.com/smnorris/fwapg
cd fwapg
echo -e $WSGS > wsg.txt
make --debug=basic .make/fwa_stream_networks_sp
make --debug=basic .make/fwa_watersheds_poly
make --debug=basic .make/fwa_watershed_groups_poly
make --debug=basic .make/fwa_assessment_watersheds_poly
make --debug=basic .make/extras
make --debug=basic .make/fwa_streams_watersheds_lut
make --debug=basic .make/fwa_stream_networks_order_max
make --debug=basic .make/fwa_stream_networks_order_parent

# create waterbodies query directly rather than calling through make
# (to avoid loading all other value_added dependencies)
$PSQL -f load/value_added/fwa_waterbodies.sql

# keep the data slim - retain only in testing groups (where wsg defined)
for table in fwa_watershed_groups_poly \
  fwa_assessment_watersheds_poly \
  fwa_stream_networks_discharge \
  fwa_stream_networks_mean_annual_precip;
  do
    $PSQL -c "delete from $table where watershed_group_code not in (select distinct watershed_group_code from whse_basemapping.fwa_stream_networks_sp)";
done

$PSQL -c "delete from whse_basemapping.fwa_stream_networks_channel_width where linear_feature_id not in (select linear_feature_id from whse_basemapping.fwa_stream_networks_sp)"
$PSQL -c "delete from whse_basemapping.fwa_assessment_watersheds_lut where watershed_feature_id not in (select watershed_feature_id from whse_basemapping.fwa_assessment_watersheds_poly)"
$PSQL -c "delete from whse_basemapping.fwa_assessment_watersheds_streams_lut where assmnt_watershed_id not in (select watershed_feature_id from whse_basemapping.fwa_assessment_watersheds_poly)"
$PSQL -c "delete from whse_basemapping.fwa_waterbodies_upstream_area where linear_feature_id not in (select linear_feature_id from whse_basemapping.fwa_stream_networks_sp)"
#$PSQL -c "delete from whse_basemapping.fwa_watersheds_upstream_area where linear_feature_id not in (select linear_feature_id from whse_basemapping.fwa_stream_networks_sp)" 

cd .. ; rm -rf fwapg

# run bcfishobs
bcdata bc2pg -e -c 1 whse_fish.fiss_fish_obsrvtn_pnt_sp
git clone https://github.com/smnorris/bcfishobs.git
cd bcfishobs
$PSQL -f db/v0.2.0.sql
$PSQL -f db/v0.3.0.sql
./process.sh
cd .. ; rm -rf bcfishobs

# set up the source data schema
cd db/sources; ./migrate.sh; cd ..

# run all migration scripts present in /db
for tag in v* ;do
    cd "$tag"; ./migrate.sh; cd ..
done
cd ..

# load source data
cd jobs
./load_static
./load_monthly
./load_weekly
cd ../test

# delete data not needed for basic model (rather than editing the job files)
$PSQL -c "delete from whse_admin_boundaries.adm_indian_reserves_bands_sp;
delete from whse_admin_boundaries.adm_nr_districts_spg;
delete from whse_basemapping.bcgs_20k_grid;
delete from whse_basemapping.dbm_mof_50k_grid;
delete from whse_basemapping.nts_250k_grid;
delete from whse_basemapping.trim_cultural_lines;
delete from whse_basemapping.trim_cultural_points;
delete from whse_basemapping.trim_ebm_airfields;
delete from whse_basemapping.trim_ebm_ocean;
delete from whse_basemapping.utmg_utm_zones_sp;
delete from whse_legal_admin_boundaries.abms_municipalities_sp;
delete from whse_legal_admin_boundaries.abms_regional_districts_sp;
delete from whse_admin_boundaries.clab_indian_reserves;
delete from whse_admin_boundaries.clab_national_parks;
delete from whse_basemapping.gba_local_reg_greenspaces_sp;
delete from whse_basemapping.gns_geographical_names_sp;
delete from whse_environmental_monitoring.envcan_hydrometric_stn_sp;
delete from whse_fish.fiss_stream_sample_sites_sp;
delete from whse_forest_tenure.ften_range_poly_svw;
delete from whse_legal_admin_boundaries.abms_municipalities_sp;
delete from whse_tantalis.ta_conservancy_areas_svw;
delete from whse_tantalis.ta_park_ecores_pa_svw;
delete from whse_cadastre.pmbc_parcel_fabric_poly_svw;
"

# delete dra/ften roads/observations not in test wsg
$PSQL -c "create temporary table roads as select transport_line_id from whse_basemapping.transport_line a inner join whse_basemapping.fwa_watershed_groups_poly b on st_intersects(a.geom, b.geom);
          delete from whse_basemapping.transport_line where transport_line_id not in (select transport_line_id from roads);"
$PSQL -c "create temporary table roads as select objectid from whse_forest_tenure.ften_road_section_lines_svw a inner join whse_basemapping.fwa_watershed_groups_poly b on st_intersects(a.geom, b.geom);
          delete from whse_forest_tenure.ften_road_section_lines_svw where objectid not in (select objectid from roads);"
$PSQL -c "create temporary table roads as select og_road_segment_permit_id from whse_mineral_tenure.og_road_segment_permit_sp a inner join whse_basemapping.fwa_watershed_groups_poly b on st_intersects(a.geom, b.geom);
          delete from whse_mineral_tenure.og_road_segment_permit_sp where og_road_segment_permit_id not in (select objectid from roads);"
$PSQL -c "create temporary table obs as select fish_observation_point_id from whse_fish.fiss_fish_obsrvtn_pnt_sp a inner join whse_basemapping.fwa_watershed_groups_poly b on st_intersects(a.geom, b.geom);
          delete from whse_fish.fiss_fish_obsrvtn_pnt_sp where fish_observation_point_id  not in (select fish_observation_point_id from obs);"

# vaccum/analyze
$PSQL -c "vacuum full analyze"

# what are the biggest relations?
#https://stackoverflow.com/questions/21738408/postgresql-list-and-order-tables-by-size
$PSQL -c "ALTER DATABASE bcfishpass_test SET search_path TO public,whse_basemapping,usgs,hydrosheds"
# dump the database (~200MB)
pg_dump -Fc $DATABASE_URL > bcfishpass_test.dump
