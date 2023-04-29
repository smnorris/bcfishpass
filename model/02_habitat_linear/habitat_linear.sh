#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")
MODELS=$(ls sql/habitat*.sql | sed -e "s/sql\/habitat_//" | sed -e "s/.sql//")

# run all habitat queries per watershed group
for SP in $MODELS
do
  $PSQL -c "drop table if exists bcfishpass.habitat_"$SP
  $PSQL -c "create table bcfishpass.habitat_"$SP" (segmented_stream_id text primary key, spawning boolean, rearing boolean)"
  parallel $PSQL -f sql/habitat_$SP.sql -v wsg={1} ::: $WSGS
done

# horsefly sockeye have their own model due to trans-watershed group spawning/rearing effects
# (this is highly likely to be present elsewhere but has not been investigated)
psql -f sql/horsefly_sk.sql

# translate user habitat classifcation measures into stream ids
$PSQL -f sql/user_habitat_classification.sql

## create output views
#for VW in $(ls sql/views/streams_*_vw.sql)
#do
#  $PSQL -f $VW
#done


