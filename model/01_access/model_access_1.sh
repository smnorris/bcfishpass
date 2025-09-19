#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")
PARALLEL="parallel --halt now,fail=1 --jobs 4 --no-run-if-empty"

# look for species models/scenarios to be processed in the sql folder,
# all files with model_access prefix
MODELS=$(ls sql/model_access*.sql | sed -e "s/sql\/model_access_//" | sed -e "s/.sql//")

# -----
# LOAD STREAMS
# -----
# clear streams table and load data from FWA
$PSQL -c "truncate bcfishpass.streams"
$PARALLEL $PSQL -f sql/load_streams.sql -v wsg={1} ::: $WSGS
$PSQL -c "VACUUM ANALYZE bcfishpass.streams"

# -----
# BREAK STREAMS
# -----
# break at observations
$PARALLEL \
  "echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
  $PSQL -v wsg={1} -v point_table=observations" ::: $WSGS

# break at crossings 
$PARALLEL \
  "echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
  $PSQL -v wsg={1} -v point_table=crossings" ::: $WSGS

# break at natural barriers for all given species scenarios
for BARRIERTYPE in $MODELS
do
  $PARALLEL \
  "echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
  $PSQL -v wsg={1} -v point_table=barriers_$BARRIERTYPE" ::: $WSGS
done

# break streams at user habitat definition endpoints
$PSQL -f sql/user_habitat_classification_endpoints.sql
$PARALLEL \
  "echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
  $PSQL -v wsg={1} -v point_table=user_habitat_classification_endpoints" ::: $WSGS

# -----
# INDEX 
# -----
# create tables holding lists of features that are downstream of individual stream segments
$PSQL -c "truncate bcfishpass.streams_dnstr_barriers";
for BARRIERTYPE in anthropogenic pscis dams dams_hydro $MODELS
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
