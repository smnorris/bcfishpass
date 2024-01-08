#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.watershed_groups_access")

# create table
$PSQL -f sql/gradient_barriers.sql

# load
parallel $PSQL -f sql/gradient_barriers_load.sql -v wsg={1} ::: $WSGS