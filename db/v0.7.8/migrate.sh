#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# document the cabd fix tables
$PSQL -f cabd_fix_table_comments.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"