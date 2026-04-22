#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# $PSQL -f db_version.sql
$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}', applied_at='2026-04-22'"
