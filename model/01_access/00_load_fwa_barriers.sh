#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AtX -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")
 
# --
# -- collect FWA natural barrier sources into to bcfishpass.barriers_<source>
# -- this is done in a separate job because they will rarely change - it doesn't need to be re-run on a scheduled basis
# --
NATURAL_BARRIERS=("gradient" "subsurfaceflow")
for BARRIERTYPE in "${NATURAL_BARRIERS[@]}"; do
    echo $BARRIERTYPE
    # drop/create the table
    $PSQL -c "select bcfishpass.create_barrier_table('$BARRIERTYPE')"
    
    # load data to barrier table in parallel
    parallel --halt soon,fail=1 $PSQL -f sql/barriers_"$BARRIERTYPE".sql -v wsg={1} ::: $WSGS
done