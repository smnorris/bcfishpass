#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

$PSQL -f wcrp_habitat_connectivity_update.sql
$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"