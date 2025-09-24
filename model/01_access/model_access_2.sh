#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")
PARALLEL="parallel --halt now,fail=1 --jobs 4 --no-run-if-empty"


# record observations downstream
# (for convenience for field investigation and reporting, not as input into the individual models)
$PSQL -c "truncate bcfishpass.streams_upstr_observations"
$PARALLEL $PSQL -f sql/load_streams_upstr_observations.sql -v wsg={1} ::: $WSGS
$PSQL -c "truncate bcfishpass.streams_dnstr_species"
$PARALLEL $PSQL -f sql/load_streams_dnstr_species.sql -v wsg={1} ::: $WSGS

# refresh materialized view
$PSQL -f sql/load_streams_access.sql

# generate crossings access report
$PSQL -c "truncate bcfishpass.crossings_upstream_access"
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_access_01.sql -v wsg={1} ::: $WSGS
parallel --halt now,fail=1 --jobs 2 --no-run-if-empty $PSQL -f sql/load_crossings_upstream_access_02.sql -v wsg={1} ::: $WSGS

# qa reporting of salmon/steelhead observations upstream of natural barriers (and barriers downstream of observations)
# $PSQL -f sql/load_qa_observations_naturalbarriers_ch_cm_co_pk_sk.sql

