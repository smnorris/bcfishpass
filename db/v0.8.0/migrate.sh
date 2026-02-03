#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# see migrate.sql for notes
$PSQL -f per_species_access_and_elevation_barriers.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"
