#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# rename/clean up cabd fix tables and permit additions/exlusions/barrier status updates
$PSQL -f cabd_fix_tables.sql
$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"