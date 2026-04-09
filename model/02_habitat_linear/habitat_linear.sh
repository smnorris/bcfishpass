#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

# load known habitat
$PSQL -f sql/load_habitat_known.sql

# run all habitat queries per watershed group
for sql in sql/load_habitat_linear_*.sql
do
  sp=$(echo $sql | sed -e "s/sql\/load_habitat_linear_//" | sed -e "s/.sql//")
  $PSQL -c "truncate bcfishpass.habitat_linear_"$sp
  parallel --halt now,fail=1 --no-run-if-empty $PSQL -f $sql -v wsg={1} ::: $WSGS
done

# horsefly sockeye have their own model due to trans-watershed group spawning/rearing effects
# (this is highly likely to be present elsewhere but has not been investigated)
$PSQL -f sql/horsefly_sk.sql

# with linear model processing complete, consolidate per secies tables to single table
$PSQL -f sql/load_habitat_linear.sql

# and load the mapping code table
$PSQL -f sql/load_streams_mapping_code.sql

# generate report of habitat length upstream of all crossings
$PSQL -c "truncate bcfishpass.crossings_upstream_habitat"
# load data in parallel
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_habitat_01.sql -v wsg={1} ::: $WSGS
# run updates (for _belowupstrbarriers_ columns) sequentially
for wsg in $WSGS
do
    $PSQL -f sql/load_crossings_upstream_habitat_02.sql -v wsg=$wsg
done

# load wcrp specific upstream habitat summaries (co/sk 1.5x factors, 'all_species' columns)
$PSQL -f sql/load_crossings_upstream_habitat_wcrp.sql

# refresh crossings views
#$PSQL -c "refresh materialized view bcfishpass.crossings_admin"  # generate admin as needed for now, this query is too resource intensive
$PSQL -c "refresh materialized view bcfishpass.crossings_wcrp_vw"
$PSQL -c "refresh materialized view bcfishpass.crossings_vw"

# Finished processing!
# Now add model run to log, returning the id
# note that below logging could be done in db with triggers/functions but this works fine for now
model_version=$(git describe)
model_run_id=$($PSQL -qtAX -c "insert into bcfishpass.log (model_type, model_version) VALUES ('LINEAR', '$model_version') returning model_run_id")

# log parameters
$PSQL -c "insert into bcfishpass.log_parameters_habitat_method
          (model_run_id, watershed_group_code, model)
          select $model_run_id, watershed_group_code, model from bcfishpass.parameters_habitat_method;"

$PSQL -c "insert into bcfishpass.log_parameters_habitat_thresholds (
          model_run_id            ,
          species_code            ,
          spawn_gradient_max      ,
          spawn_channel_width_min ,
          spawn_channel_width_max ,
          spawn_mad_min           ,
          spawn_mad_max           ,
          rear_gradient_max       ,
          rear_channel_width_min  ,
          rear_channel_width_max  ,
          rear_mad_min            ,
          rear_mad_max            ,
          rear_lake_ha_min
        )
        select
         $model_run_id,
         species_code,
         spawn_gradient_max,
         spawn_channel_width_min,
         spawn_channel_width_max,
         spawn_mad_min,
         spawn_mad_max,
         rear_gradient_max,
         rear_channel_width_min,
         rear_channel_width_max,
         rear_mad_min,
         rear_mad_max,
         rear_lake_ha_min
        from bcfishpass.parameters_habitat_thresholds;"

# log summaries
$PSQL -c "insert into bcfishpass.log_aw_linear_summary select $model_run_id as model_run_id, * from bcfishpass.aw_linear_summary()"
$PSQL -c "insert into bcfishpass.log_wsg_crossing_summary select $model_run_id as model_run_id, * from bcfishpass.wsg_crossing_summary()"

# log primary data sources associated with the model run
# todo - add FWA and bcfishobs file versions
$PSQL -c "insert into bcfishpass.log_objectstorage (
    model_run_id,
    object_name,
    version_id,
    etag
  )
  select
    $model_run_id as model_run_id,
    object_name,
    version_id,
    etag
  from bcfishpass.log_replication
  where object_name in (
   'whse_basemapping.gba_railway_structure_lines_sp',
   'whse_basemapping.gba_railway_tracks_sp',
   'whse_basemapping.transport_line',
   'whse_fish.fiss_fish_obsrvtn_pnt_sp',
   'whse_fish.pscis_assessment_svw',
   'whse_fish.pscis_design_proposal_svw',
   'whse_fish.pscis_habitat_confirmation_svw',
   'whse_fish.pscis_remediation_svw',
   'whse_forest_tenure.ften_road_section_lines_svw',
   'whse_imagery_and_base_maps.mot_road_structure_sp',
   'whse_mineral_tenure.og_petrlm_dev_rds_pre06_pub_sp',
   'whse_mineral_tenure.og_road_segment_permit_sp'
)"