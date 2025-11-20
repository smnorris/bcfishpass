#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# barrier tables become much more dense when using 1pct intervals for gradient barriers
# speed up loads to these tables by making them unlogged.
# removing indexes and constraints would also help

$PSQL -f unlogged_barrier_tables.sql
$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"