#!/bin/bash
set -euxo pipefail

# add wcrp name column to wcrp table
psql $DATABASE_URL -v ON_ERROR_STOP=1 -c "alter table bcfishpass.wcrp_watersheds add column wcrp varchar(32);"

# add wcrp tracking views
echo "On systems supporting CWF WCRP reporting, add join_tracking_table_crossings_view.sql"
echo "psql $DATABASE_URL -v ON_ERROR_STOP=1 -f sql/join_tracking_table_crossings_view.sql"

# note version
psql $DATABASE_URL -v ON_ERROR_STOP=1 -c "update bcfishpass.db_version set tag = '${PWD##*/}'"