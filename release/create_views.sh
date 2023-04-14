#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"


# create views displaying access/habitat per species / species group
for VW in $(ls sql/views/streams_*_vw.sql)
do
  $PSQL -f $VW
done