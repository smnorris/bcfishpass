#!/bin/bash
set -euxo pipefail

echo "On systems supporting CWF WCRP reporting, add join_tracking_table_crossings_view.sql"
echo "psql $DATABASE_URL -f sql/join_tracking_table_crossings_view.sql"

# note version
psql $DATABASE_URL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"