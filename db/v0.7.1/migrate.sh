#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

$PSQL -f v0.7.1.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"
