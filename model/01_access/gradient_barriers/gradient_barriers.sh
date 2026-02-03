#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

# load
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=100 -v wsg={1} ::: $WSGS