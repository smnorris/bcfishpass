#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# enable exclusion of individual fish observation records based on QA
$PSQL -f observation_exclusions.sql

# update observation/natural barrier qa tables
$PSQL -f barrier_observation_qa.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"