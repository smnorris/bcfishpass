#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

$PSQL -f user_crossings_misc.sql
$PSQL -f spawningrearing_per_species.sql
$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"