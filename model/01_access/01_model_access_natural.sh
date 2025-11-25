#!/bin/bash
set -euxo pipefail

# Check if arguments were provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 model1 model2 ..."
    exit 1
fi
MODELS=("$@")
echo "Processing models: ${MODELS[@]}"

# non-fwa natural barriers to process
NATURAL_BARRIERS=("falls" "user_definite")

# groups to process comes from the db
WSGS=($(psql "$DATABASE_URL" -t -A -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method"))

# shortcut to psql
PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# --
# -- refresh observations and falls
# --
$PSQL -f sql/load_observations.sql
$PSQL -f sql/load_falls.sql

# --
# -- collect natural barrier sources that tend to change into to bcfishpass.barriers_<source>
# -- (reasonably constant FWA natural barriers are loaded separately)
# --
for BARRIERTYPE in "${NATURAL_BARRIERS[@]}"; do
    # drop/create the table
    $PSQL -c "select bcfishpass.create_barrier_table('$BARRIERTYPE')"

    # load data to barrier table in parallel
    parallel --halt soon,fail=1 $PSQL -f sql/barriers_"$BARRIERTYPE".sql -v wsg={1} ::: "${WSGS[@]}"
done

# --
# -- then collect the source natural barriers in to per-species barrier tables, defining naturally accessible stream
# --
for MODEL in ${MODELS[@]}; do

  # drop/create the table
  $PSQL -c "select bcfishpass.create_barrier_table('$MODEL')"

  # load all features for given model to barrier table, for all groups
  parallel --no-run-if-empty $PSQL -f sql/model_access_$MODEL.sql -v wsg={1} ::: "${WSGS[@]}"

  # index barriers downstream, processing in 50k chunks (instead of usual watershed group chunks)
  CHUNK_SIZE=50000
  TOTAL_ROWS=$($PSQL -t -c "SELECT COUNT(*) FROM bcfishpass.barriers_${MODEL}")
  N_CHUNKS=$(((TOTAL_ROWS + CHUNK_SIZE - 1) / CHUNK_SIZE))
  # calculate the exact offset values by multiplying n_chunks * chunk_size
  OFFSETS=$(seq 0 $((N_CHUNKS - 1)) | awk -v chunk_size=$CHUNK_SIZE '{print $1 * chunk_size}')

  echo "Processing ${TOTAL_ROWS} rows in bcfishpass.barriers${MODEL} in ${N_CHUNKS}"
  # load to temp unlogged table with no indexes so postres does not have to think
  $PSQL -c "drop table if exists bcfishpass.barriers_${MODEL}_dnstr"
  $PSQL -c "create unlogged table bcfishpass.barriers_${MODEL}_dnstr (barriers_${MODEL}_id text, features_dnstr text[])"
  parallel --no-run-if-empty \
      "echo \"select bcfishpass.load_dnstr_chunked( \
          'bcfishpass.barriers_${MODEL}',  \
          'barriers_${MODEL}_id', \
          'bcfishpass.barriers_${MODEL}',  \
          'barriers_${MODEL}_id', \
          'bcfishpass.barriers_${MODEL}_dnstr', \
          'features_dnstr', \
          'false', \
          ${CHUNK_SIZE}, \
          :offset);\" | psql \"$DATABASE_URL\" -v offset={}" ::: $OFFSETS

  # set pk
  $PSQL -c "alter table bcfishpass.barriers_${MODEL}_dnstr add primary key (barriers_${MODEL}_id);"

  # remove non-minimal barriers
  echo "delete from bcfishpass.:table1 a \
      using bcfishpass.:table2 b \
      where a.:id = b.:id;" | \
    $PSQL -v id=barriers_${MODEL}_id -v table1=barriers_${MODEL} -v table2=barriers_${MODEL}_dnstr
  $PSQL -c "alter table bcfishpass.barriers_${MODEL} set logged"

  # drop the temp _dnstr table
  $PSQL -c "drop table bcfishpass.barriers_${MODEL}_dnstr"

  # note how much stream is upstream of the barriers
  $PSQL -f sql/add_length_upstream.sql -v src_id=barriers_${MODEL}_id -v src_table=barriers_${MODEL}

done


# -----
# LOAD STREAMS
# -----
# clear streams table and load data from FWA
$PSQL -c "truncate bcfishpass.streams"
parallel --halt now,fail=1 --jobs 4 --no-run-if-empty \
  $PSQL -f sql/load_streams.sql -v wsg={1} ::: "${WSGS[@]}"

$PSQL -c "VACUUM ANALYZE bcfishpass.streams"

# --
# LOAD CROSSINGS
# --
# stream segmentation must be completed before indexing natural barriers, so 
# refresh anthropogenic barrier data (dams, pscis) and load to crossings table
$PSQL -f sql/load_dams.sql
cd pscis; ./pscis.sh; cd ..

$PSQL -c "truncate bcfishpass.crossings"
for wsg in $($PSQL -AXt -c "select watershed_group_code from whse_basemapping.fwa_watershed_groups_poly");
do
  set -e ; $PSQL -f sql/load_crossings.sql -v wsg=$wsg ;
done


# -----
# BREAK STREAMS
# -----
# break at observations
parallel --halt now,fail=1 --jobs 4 --no-run-if-empty "
  $PSQL -c \"
  SELECT bcfishpass.break_streams('observations', '{1}');\"
" ::: "${WSGS[@]}"

# break at natural barriers for all given species scenarios
parallel --halt now,fail=1 --jobs 4 --no-run-if-empty "
  $PSQL -c \"
  SELECT bcfishpass.break_streams('barriers_{1}', '{2}');\"
" ::: ${MODELS[@]} ::: "${WSGS[@]}"

# break streams at user habitat definition endpoints
$PSQL -f sql/user_habitat_classification_endpoints.sql
parallel --halt now,fail=1 --jobs 4 --no-run-if-empty "
  $PSQL -c \"
  SELECT bcfishpass.break_streams('user_habitat_classification_endpoints', '{1}');\"
" ::: "${WSGS[@]}"

# break streams at crossings 
parallel --halt now,fail=1 --jobs 4 --no-run-if-empty "
  $PSQL -c \"
  SELECT bcfishpass.break_streams('crossings', '{1}');\" 
" ::: "${WSGS[@]}"


# -----
# INDEX
# -----
# load table listing barriers that are downstream of individual stream segments
$PSQL -c "truncate bcfishpass.streams_dnstr_barriers";
run_query() {
    local model=$1
    local group=$2
    psql "$DATABASE_URL" -c "
    SELECT bcfishpass.load_dnstr(
      'bcfishpass.streams',
      'segmented_stream_id',
      'bcfishpass.barriers_${model}',
      'barriers_${model}_id',
      'bcfishpass.streams_dnstr_barriers',
      'barriers_${model}_dnstr',
      'true',
      '${group}'
    );"
}
export -f run_query
parallel --halt now,fail=1 --no-run-if-empty run_query {1} {2} ::: "${MODELS[@]}" ::: "${WSGS[@]}"

# record observations downstream
# (for convenience for field investigation and reporting, not as input into the individual models)
$PSQL -c "truncate bcfishpass.streams_upstr_observations"
parallel --halt now,fail=1 --jobs 4 --no-run-if-empty \
  $PSQL -f sql/load_streams_upstr_observations.sql -v wsg={1} ::: "${WSGS[@]}"

$PSQL -c "truncate bcfishpass.streams_dnstr_species"
parallel --halt now,fail=1 --jobs 4 --no-run-if-empty \
  $PSQL -f sql/load_streams_dnstr_species.sql -v wsg={1} ::: "${WSGS[@]}"