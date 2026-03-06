#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# enable logging of relevant inputs and outputs from/to object storage
# tables link model id (and thus commit hash) to objects/versions
$PSQL -f log_objectstorage.sql

$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"