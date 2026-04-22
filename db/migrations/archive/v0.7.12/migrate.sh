#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# enable reporting on bull trout in wcrps
$PSQL -f bt_wcrp.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"