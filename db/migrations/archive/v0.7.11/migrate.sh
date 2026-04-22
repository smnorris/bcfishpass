#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# this orphaned view should have been dropped in a previous migration
$PSQL -c "DROP MATERIALIZED VIEW IF EXISTS bcfishpass.fptwg_summary_observations_vw;"

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"