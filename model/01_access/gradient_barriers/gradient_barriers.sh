#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")

# create table
$PSQL -f sql/gradient_barriers.sql

# load from dumped csv
$PSQL -c "\copy bcfishpass.gradient_barriers FROM PROGRAM 'curl https://bcfishpass.s3.us-west-2.amazonaws.com/gradient_barriers.csv.gz | \
  gunzip' delimiter ',' csv header"

# alternatively, re-process
#parallel $PSQL -f sql/gradient_barriers_load.sql -v wsg={1} ::: $WSGS