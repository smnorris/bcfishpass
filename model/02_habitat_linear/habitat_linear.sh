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
$PSQL -c "refresh materialized view bcfishpass.crossings_vw"

# Finished processing!
# Now add model run to log, returning the id
git_id=$(git rev-parse HEAD)
model_run_id=$($PSQL -qtAX -c "insert into bcfishpass.log (model_type, git_id) VALUES ('LINEAR', decode('$git_id', 'hex')) returning model_run_id")

# log summaries (todo - call these functions as a trigger on adding row to bcfishpass.log table rather than calling here)
$PSQL -c "insert into bcfishpass.wsg_linear_summary select $model_run_id as model_run_id, * from bcfishpass.wsg_linear_summary()"
$PSQL -c "insert into bcfishpass.wsg_crossing_summary select $model_run_id as model_run_id, * from bcfishpass.wsg_crossing_summary()"

