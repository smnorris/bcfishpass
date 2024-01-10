#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")


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

# generate report of habitat length upstream of all crossings
$PSQL -c "truncate bcfishpass.crossings_upstream_habitat"
# load data in parallel
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_habitat_01.sql -v wsg={1} ::: $WSGS
# run updates (for _belowupstrbarriers_ columns) sequentially
for wsg in $WSGS
do
    $PSQL -f sql/load_crossings_upstream_habitat_02.sql -v wsg=$wsg
done

# with linear model processing complete, refresh materialized views
$PSQL -c "refresh materialized view bcfishpass.crossings_upstr_barriers_per_model_vw"
$PSQL -c "refresh materialized view bcfishpass.crossings_upstr_observations_vw"
$PSQL -c "refresh materialized view bcfishpass.crossings_dnstr_observations_vw"
$PSQL -c "refresh materialized view bcfishpass.crossings_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_habitat_known_vw"

# Finished processing!
# Now add model run to log, returning the id
# note that below logging could be done in db with triggers/functions but this works fine for now
model_version=$(git describe)
model_run_id=$($PSQL -qtAX -c "insert into bcfishpass.log (model_type, model_version) VALUES ('LINEAR', '$model_version') returning model_run_id")

# log parameters
$PSQL -c "insert into bcfishpass.parameters_habitat_method_log
          (model_run_id, watershed_group_code, model)
          select $model_run_id, watershed_group_code, model from bcfishpass.parameters_habitat_method;"

$PSQL -c "insert into bcfishpass.parameters_habitat_thresholds_log (
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
$PSQL -c "insert into bcfishpass.wsg_linear_summary select $model_run_id as model_run_id, * from bcfishpass.wsg_linear_summary()"
$PSQL -c "insert into bcfishpass.wsg_crossing_summary select $model_run_id as model_run_id, * from bcfishpass.wsg_crossing_summary()"

