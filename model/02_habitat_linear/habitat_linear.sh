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
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_habitat_01.sql -v wsg={1} ::: $WSGS
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_habitat_02.sql -v wsg={1} ::: $WSGS

# with habitat processing complete, refresh materialized views
$PSQL -c "refresh materialized view bcfishpass.crossings_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_bt_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_ch_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_cm_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_co_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_pk_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_salmon_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_sk_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_st_vw"
$PSQL -c "refresh materialized view bcfishpass.streams_wct_vw"