#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AtX -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

# --
# -- refresh observations and falls
# -- 
$PSQL -f sql/load_observations.sql
$PSQL -f sql/load_falls.sql
 
# --
# -- collect natural barrier sources that tend to change into to bcfishpass.barriers_<source>
# -- (reasonably constant FWA natural barriers are loaded separately)
# --
NATURAL_BARRIERS=("falls" "user_definite")
for BARRIERTYPE in "${NATURAL_BARRIERS[@]}"; do
    
    # drop/create the table
    $PSQL -c "select bcfishpass.create_barrier_table('$BARRIERTYPE')"
    
    # load data to barrier table in parallel
    parallel --halt soon,fail=1 $PSQL -f sql/barriers_"$BARRIERTYPE".sql -v wsg={1} ::: $WSGS
done

# --
# -- then collect the source natural barriers in to per-species barrier tables, defining naturally accessible stream
# --

MODELS=$(ls sql/model_access*.sql | sed -e "s/sql\/model_access_//" | sed -e "s/.sql//")
for SPP in $MODELS; do
  
  # drop/create the table
  $PSQL -c "select bcfishpass.create_barrier_table('$SPP')"

  # load all features for given spp scenario to barrier table, for all groups
  parallel --no-run-if-empty $PSQL -f sql/model_access_$SPP.sql -v wsg={1} ::: $WSGS

  # index barriers downstream, processing in 50k chunks (instead of usual watershed group chunks)
  CHUNK_SIZE=50000
  TOTAL_ROWS=$($PSQL -t -c "SELECT COUNT(*) FROM bcfishpass.barriers_${SPP}")
  N_CHUNKS=$(((TOTAL_ROWS + CHUNK_SIZE - 1) / CHUNK_SIZE))
  # calculate the exact offset values by multiplying n_chunks * chunk_size
  OFFSETS=$(seq 0 $((N_CHUNKS - 1)) | awk -v chunk_size=$CHUNK_SIZE '{print $1 * chunk_size}') 

  echo "Processing ${TOTAL_ROWS} rows in bcfishpass.barriers${SPP} in ${N_CHUNKS}"
  # load to temp unlogged table with no indexes so postres does not have to think
  $PSQL -c "drop table if exists bcfishpass.barriers_${SPP}_dnstr"
  $PSQL -c "create unlogged table bcfishpass.barriers_${SPP}_dnstr (barriers_${SPP}_id text, features_dnstr text[])"
  parallel --no-run-if-empty \
      "echo \"select bcfishpass.load_dnstr_chunked( \
          'bcfishpass.barriers_${SPP}',  \
          'barriers_${SPP}_id', \
          'bcfishpass.barriers_${SPP}',  \
          'barriers_${SPP}_id', \
          'bcfishpass.barriers_${SPP}_dnstr', \
          'features_dnstr', \
          'false', \
          ${CHUNK_SIZE}, \
          :offset);\" | psql \"$DATABASE_URL\" -v offset={}" ::: $OFFSETS

  # set pk 
  $PSQL -c "alter table bcfishpass.barriers_${SPP}_dnstr add primary key (barriers_${SPP}_id);"

  # remove non-minimal barriers
  echo "delete from bcfishpass.:table1 a \
      using bcfishpass.:table2 b \
      where a.:id = b.:id;" | \
    $PSQL -v id=barriers_${SPP}_id -v table1=barriers_${SPP} -v table2=barriers_${SPP}_dnstr
  $PSQL -c "alter table bcfishpass.barriers_${SPP} set logged"

  # drop the temp _dnstr table
  $PSQL -c "drop table bcfishpass.barriers_${SPP}_dnstr"

  # note how much stream is upstream of the barriers
  $PSQL -f sql/add_length_upstream.sql -v src_id=barriers_${SPP}_id -v src_table=barriers_${SPP}

done


# use max 4 concurrent jobs for subsequent steps
PARALLEL="parallel --halt now,fail=1 --jobs 4 --no-run-if-empty"

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
for BARRIERTYPE in $MODELS
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


# record observations downstream
# (for convenience for field investigation and reporting, not as input into the individual models)
$PSQL -c "truncate bcfishpass.streams_upstr_observations"
$PARALLEL $PSQL -f sql/load_streams_upstr_observations.sql -v wsg={1} ::: $WSGS
$PSQL -c "truncate bcfishpass.streams_dnstr_species"
$PARALLEL $PSQL -f sql/load_streams_dnstr_species.sql -v wsg={1} ::: $WSGS