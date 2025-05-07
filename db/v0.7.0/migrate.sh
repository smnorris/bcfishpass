#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# use bcfishobs v0.3.0 (bcfishobs.observations)
# Observations are included in many objects, they must be dropped/recreated
$PSQL -f sql/observations.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"