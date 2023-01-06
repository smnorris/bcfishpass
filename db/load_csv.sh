#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# load specified csv to postgres
$PSQL -c "DELETE FROM bcfishpass.$(basename -- $1 .csv)"
$PSQL -c "\copy bcfishpass.$(basename -- $1 .csv) FROM $1 delimiter ',' csv header"