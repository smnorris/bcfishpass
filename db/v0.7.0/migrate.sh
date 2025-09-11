#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# see migrate.sql for notes
$PSQL -f sql/migrate.sql

# on fptwg dbs, recreate materialized views for reporting
# $PSQL -f sql/fptwg.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"