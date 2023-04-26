#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"


# create views displaying access/habitat per species / species group
for query in $(ls sql/*.sql)
do
  $PSQL --csv -f $query > $(basename $query .sql).csv
done