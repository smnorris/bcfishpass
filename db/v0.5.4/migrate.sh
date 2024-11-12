#!/bin/bash
set -euxo pipefail

# update DRA table
psql $DATABASE_URL -v ON_ERROR_STOP=1 -f sql/dra.sql

# note version
psql $DATABASE_URL -v ON_ERROR_STOP=1 -c "update bcfishpass.db_version set tag = '${PWD##*/}'"