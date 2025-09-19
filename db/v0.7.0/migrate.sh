#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# see migrate.sql for notes
$PSQL -f sql/migrate.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"

# on fptwg dbs, recreate materialized views for reporting
# $PSQL -f sql/fptwg.sql

# on cwf test, create the tracking tables
# $PSQL -f sql/wcrp_tracking/set_up_tracking_table_types.sql
# $PSQL -f sql/wcrp_tracking/combined_tracking_table.sql
