#!/bin/bash
set -euxo pipefail

bcdata bc2pg WHSE_BASEMAPPING.DBM_MOF_50K_GRID

psql $DATABASE_URL -c "create schema if not exists bcfishpass"
psql -v ON_ERROR_STOP=1 $DATABASE_URL -f sql/tables.sql

# load all functions
for sql in sql/functions/*.sql ; do
	psql $DATABASE_URL -v ON_ERROR_STOP=1 -v ON_ERROR_STOP=1 -f "$sql"
done

