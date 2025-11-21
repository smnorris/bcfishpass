#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AtX -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

# --
# refresh anthropogenic barrier data (dams, pscis) and load to crossings table
# --
$PSQL -f sql/load_dams.sql
cd pscis; ./pscis.sh; cd ..

$PSQL -c "truncate bcfishpass.crossings"
for wsg in $($PSQL -AXt -c "select watershed_group_code from whse_basemapping.fwa_watershed_groups_poly");
do
	set -e ; $PSQL -f sql/load_crossings.sql -v wsg=$wsg ;
done


# --
# collect barrier sources into standard bcfishpass.barriers_<source> tables
# --
BARRIERS=("anthropogenic" "dams" "dams_hydro" "pscis")
for BARRIERTYPE in "${BARRIERS[@]}"; do
    echo $BARRIERTYPE
    # drop/create the table
    $PSQL -c "select bcfishpass.create_barrier_table('$BARRIERTYPE')"
    
    # load data to barrier table in parallel
    parallel --halt soon,fail=1 \
      $PSQL -f sql/barriers_"$BARRIERTYPE".sql -v wsg={1} ::: $WSGS

done

# ----
# for crossings table, barriers_anthropogenic, note what barriers are upstream/downstream of each other
# ----
# note all crossings downstream of a crossing
$PSQL -c "truncate bcfishpass.crossings_dnstr_crossings"
parallel --no-run-if-empty \
  "echo \"select bcfishpass.load_dnstr( \
    'bcfishpass.crossings',  \
    'aggregated_crossings_id', \
    'bcfishpass.crossings', \
    'aggregated_crossings_id', \
    'bcfishpass.crossings_dnstr_crossings', \
    'features_dnstr', \
    'false', \
    :'wsg');\" | $PSQL -v wsg={1}" ::: $WSGS

# note all anthropogenic barriers downstream of a crossing
$PSQL -c "truncate bcfishpass.crossings_dnstr_barriers_anthropogenic"
parallel --no-run-if-empty \
  "echo \"select bcfishpass.load_dnstr( \
    'bcfishpass.crossings',  \
    'aggregated_crossings_id', \
    'bcfishpass.barriers_anthropogenic', \
    'barriers_anthropogenic_id', \
    'bcfishpass.crossings_dnstr_barriers_anthropogenic', \
    'features_dnstr', \
    'false', \
    :'wsg');\" | $PSQL -v wsg={1}" ::: $WSGS

# note all anthropogenic barriers upstream of a crossing
$PSQL -c "truncate bcfishpass.crossings_upstr_barriers_anthropogenic"
parallel --no-run-if-empty \
  "echo \"select bcfishpass.load_upstr( \
    'bcfishpass.crossings',  \
    'aggregated_crossings_id', \
    'bcfishpass.barriers_anthropogenic', \
    'barriers_anthropogenic_id', \
    'bcfishpass.crossings_upstr_barriers_anthropogenic', \
    'features_upstr', \
    'false', \
    :'wsg');\" | $PSQL -v wsg={1}" ::: $WSGS

# note all anthropogenic barriers downstream of an anthropogenic barrier
$PSQL -c "truncate bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic"
parallel --no-run-if-empty \
  "echo \"select bcfishpass.load_dnstr( \
    'bcfishpass.barriers_anthropogenic',  \
    'barriers_anthropogenic_id', \
    'bcfishpass.barriers_anthropogenic', \
    'barriers_anthropogenic_id', \
    'bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic', \
    'features_dnstr', \
    'false', \
    :'wsg');\" | $PSQL -v wsg={1}" ::: $WSGS


# use max 4 concurrent jobs for subsequent steps
PARALLEL="parallel --halt now,fail=1 --jobs 4 --no-run-if-empty"

# -----
# BREAK STREAMS
# -----
# break streams at crossings 
$PARALLEL \
  "echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
  $PSQL -v wsg={1} -v point_table=crossings" ::: $WSGS

# -----
# INDEX 
# -----
# create tables holding lists of features that are downstream of individual stream segments
$PSQL -c "truncate bcfishpass.streams_dnstr_barriers";
for BARRIERTYPE in anthropogenic pscis dams dams_hydro
do
  $PARALLEL \
  "echo \"SELECT bcfishpass.load_dnstr(
      'bcfishpass.streams',
      'segmented_stream_id',
      'bcfishpass.barriers_\"$BARRIERTYPE\"',
      'barriers_\"$BARRIERTYPE\"_id',
      'bcfishpass.streams_dnstr_barriers',
      'barriers_\"$BARRIERTYPE\"_dnstr',
      'true',
      :'wsg');\" | \
  $PSQL -v wsg={1}" ::: $WSGS
done  

# also record all crossings downstream
$PSQL -c "truncate bcfishpass.streams_dnstr_crossings";
$PARALLEL \
    "echo \"SELECT bcfishpass.load_dnstr(
    'bcfishpass.streams',
    'segmented_stream_id',
    'bcfishpass.crossings',
    'aggregated_crossings_id',
    'bcfishpass.streams_dnstr_crossings',
    'crossings_dnstr',
    'true',
    :'wsg');\" | \
    $PSQL -v wsg={1}" ::: $WSGS

# record remediations/barriers downstream (for mapping remediated stream)
$PSQL -f sql/remediations_barriers.sql    # create required table
$PSQL -c "truncate bcfishpass.streams_dnstr_barriers_remediations";
$PARALLEL \
    "echo \"SELECT bcfishpass.load_dnstr(
    'bcfishpass.streams',
    'segmented_stream_id',
    'bcfishpass.barriers_remediations',
    'barriers_remediations_id',
    'bcfishpass.streams_dnstr_barriers_remediations',
    'remediations_barriers_dnstr',
    'true',
    :'wsg');\" | \
    $PSQL -v wsg={1}" ::: $WSGS


# -----
# GENERATE OUTPUT 
# -----
# load access table
$PSQL -f sql/load_streams_access.sql

# generate crossings access report
$PSQL -c "truncate bcfishpass.crossings_upstream_access"
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_access_01.sql -v wsg={1} ::: $WSGS
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_access_02.sql -v wsg={1} ::: $WSGS    