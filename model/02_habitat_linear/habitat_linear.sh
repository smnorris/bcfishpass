#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")
# run all habitat queries per watershed group
for sql in sql/habitat*.sql
do
  sp=$(echo $sql | sed -e "s/sql\/habitat_//" | sed -e "s/.sql//")
  $PSQL -c "drop table if exists bcfishpass.habitat_"$sp
  $PSQL -c "create table bcfishpass.habitat_"$sp" (segmented_stream_id text primary key, spawning boolean, rearing boolean)"
  parallel $PSQL -f sql/habitat_$sp.sql -v wsg={1} ::: $WSGS
done

# horsefly sockeye have their own model due to trans-watershed group spawning/rearing effects
# (this is highly likely to be present elsewhere but has not been investigated)
psql -f sql/horsefly_sk.sql

# translate user habitat classifcation referencing from measures to stream segment ids
$PSQL -f sql/user_habitat_classification.sql

# load habitat outputs into streams table by copying to new table
$PSQL -c "drop table if exists bcfishpass.streams_model_habitat"
$PSQL -c "create table bcfishpass.streams_model_habitat (like bcfishpass.streams including all);"
$PSQL -c "alter table bcfishpass.streams_model_habitat

 add column if not exists model_spawning_bt     boolean,
 add column if not exists model_spawning_ch     boolean,
 add column if not exists model_spawning_cm     boolean,
 add column if not exists model_spawning_co     boolean,
 add column if not exists model_spawning_pk     boolean,
 add column if not exists model_spawning_sk     boolean,
 add column if not exists model_spawning_st     boolean,
 add column if not exists model_spawning_wct    boolean,
 add column if not exists model_rearing_bt      boolean,
 add column if not exists model_rearing_ch      boolean,
 add column if not exists model_rearing_co      boolean,
 add column if not exists model_rearing_sk      boolean,
 add column if not exists model_rearing_st      boolean,
 add column if not exists model_rearing_wct     boolean,
 add column if not exists mapping_code_bt     text,
 add column if not exists mapping_code_ch     text,
 add column if not exists mapping_code_cm     text,
 add column if not exists mapping_code_co     text,
 add column if not exists mapping_code_pk     text,
 add column if not exists mapping_code_sk     text,
 add column if not exists mapping_code_st     text,
 add column if not exists mapping_code_wct    text,
 add column if not exists mapping_code_salmon    text"
parallel $PSQL -f sql/streams_model_habitat.sql -v wsg={1} ::: $WSGS
# switch back to streams table
$PSQL -c "drop table bcfishpass.streams cascade"
$PSQL -c "alter table bcfishpass.streams_model_habitat rename to streams"
$PSQL -c "VACUUM ANALYZE bcfishpass.streams"

# drop the no longer needed habitat_ tables
for sql in sql/habitat*.sql
do
  sp=$(echo $sql | sed -e "s/sql\/habitat_//" | sed -e "s/.sql//")
  $PSQL -c 'drop table if exists bcfishpass.habitat_'$sp
done

# generate report of habitat length upstream of all crossings
$PSQL -f sql/crossings_upstream_habitat.sql
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/crossings_upstream_habitat_load.sql -v wsg={1} ::: $WSGS
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/crossings_upstream_habitat_update.sql -v wsg={1} ::: $WSGS

# create output views
for vw in sql/views/*_vw.sql
do
  $PSQL -f $vw
done

