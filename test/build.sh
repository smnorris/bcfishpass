#!/bin/bash
set -euxo pipefail

# ------
# Build a minimal database for testing
# ------

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS="BELA\nBULK\nCOWN\nELKR\nHORS\nLNIC\nSANJ\nVICT"       # edit here to adjust testing watersheds (could pull from parameters/example_testing/parameters_habitat_method)

createdb bcfishpass_test

# setup the db schema
jobs/setup

# ------
# jobs/load_fwa
# ------
# modify fwa load job to process just watershed groups of interest
git clone https://github.com/smnorris/fwapg
cd fwapg
mkdir -p .make; touch .make/db  # db schema/functions/etc are presumed to already exist, just reload data
mkdir -p data
echo -e $WSGS > wsg.txt                                     # wsg.txt controls what watersheds are loaded (for chunked data)
make --debug=basic .make/fwa_stream_networks_sp
make --debug=basic .make/fwa_watershed_groups_poly
make --debug=basic .make/fwa_assessment_watersheds_poly
make --debug=basic .make/extras

# keep the data slim - retain only in testing groups (where wsg defined)
for table in fwa_watershed_groups_poly \
  fwa_assessment_watersheds_poly \
  fwa_stream_networks_discharge \
  fwa_stream_networks_mean_annual_precip;
  do
    $PSQL -c "delete from $table where watershed_group_code not in (select watershed_group_code from fwa_watershed_groups_poly)";
done

$PSQL -c "delete from whse_basemapping.fwa_stream_networks_channel_width where linear_feature_id not in (select linear_feature_id from whse_basemapping.fwa_stream_networks_sp)"
$PSQL -c "delete from whse_basemapping.fwa_assessment_watersheds_lut where watershed_feature_id not in (select watershed_feature_id from whse_basemapping.fwa_assessment_watersheds_poly)"
$PSQL -c "delete from whse_basemapping.fwa_assessment_watersheds_streams_lut where assmnt_watershed_id not in (select watershed_feature_id from whse_basemapping.fwa_assessment_watersheds_poly)"
$PSQL -c "delete from whse_basemapping.fwa_waterbodies_upstream_area where linear_feature_id not in (select linear_feature_id from whse_basemapping.fwa_stream_networks_sp)"
$PSQL -c "delete from whse_basemapping.fwa_watersheds_upstream_area" # just delete all of this

cd .. ; rm -rf fwapg

# load source data
jobs/load_static
jobs/load_monthly
jobs/load_weekly
jobs/load_modelled_stream_crossings

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

# delete dra/ften roads not in test wsg
$PSQL -c "create temporary table roads as select transport_line_id from whse_basemapping.transport_line a inner join whse_basemapping.fwa_watershed_groups_poly b on st_intersects(a.geom, b.geom);
          delete from whse_basemapping.transport_line where transport_line_id not in (select transport_line_id from roads);"
$PSQL -c "create temporary table roads as select objectid from whse_forest_tenure.ften_road_section_lines_svw a inner join whse_basemapping.fwa_watershed_groups_poly b on st_intersects(a.geom, b.geom);
          delete from whse_forest_tenure.ften_road_section_lines_svw where objectid not in (select objectid from roads);"
$PSQL -c "create temporary table roads as select og_road_segment_permit_id from whse_mineral_tenure.og_road_segment_permit_sp a inner join whse_basemapping.fwa_watershed_groups_poly b on st_intersects(a.geom, b.geom);
          delete from whse_mineral_tenure.og_road_segment_permit_sp where og_road_segment_permit_id not in (select objectid from roads);"

# delete modelled crossings and observations not in watersheds of interest
$PSQL -c "delete from bcfishpass.modelled_stream_crossings where watershed_group_code not in (select watershed_group_code from whse_basemapping.fwa_watershed_groups_poly)"
$PSQL -c "create temporary table obs as select fish_observation_point_id from whse_fish.fiss_fish_obsrvtn_pnt_sp a inner join whse_basemapping.fwa_watershed_groups_poly b on st_intersects(a.geom, b.geom);
          delete from whse_fish.fiss_fish_obsrvtn_pnt_sp where fish_observation_point_id  not in (select fish_observation_point_id from obs);"

# run bcfishobs
git clone git@github.com:smnorris/bcfishobs.git
cd bcfishobs
mkdir -p .make
make -t .make/setup
make -t .make/fiss_fish_obsrvtn_pnt_sp
make --debug=basic
cd .. ; rm -rf bcfishobs

# vaccum/analyze
$PSQL -c "vacuum full analyze"

# what are the biggest relations?
#https://stackoverflow.com/questions/21738408/postgresql-list-and-order-tables-by-size

# dump the database (~200MB)
pg_dump -Fc bcfishpass_test > bcfishpass_test.dump

# cleanup
psql postgres -c "drop database bcfishpass_test"
