#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# list observations upstream of falls/gradient barriers
$PSQL -f sql/qa_observations_naturalbarriers_ch_cm_co_pk_sk.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"