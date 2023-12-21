#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")


# run all habitat queries per watershed group
for sql in sql/load_habitat_linear_co.sql
do
  sp=$(echo $sql | sed -e "s/sql\/load_habitat_linear_//" | sed -e "s/.sql//")
  $PSQL -c "truncate bcfishpass.habitat_linear_"$sp
  parallel --halt now,fail=1 --no-run-if-empty $PSQL -f $sql -v wsg={1} ::: $WSGS
done

# horsefly sockeye have their own model due to trans-watershed group spawning/rearing effects
# (this is highly likely to be present elsewhere but has not been investigated)
$PSQL -f sql/horsefly_sk.sql

# translate user habitat classifcation referencing from measures to stream segment ids
$PSQL -f sql/user_habitat_classification.sql

# generate report of habitat length upstream of all crossings
$PSQL -c "truncate bcfishpass.crossings_upstream_habitat"
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_habitat_01.sql -v wsg={1} ::: $WSGS
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_habitat_02.sql -v wsg={1} ::: $WSGS

# refresh materialized views?