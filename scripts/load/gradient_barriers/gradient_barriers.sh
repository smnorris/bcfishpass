#!/bin/bash
set -euxo pipefail

PSQL_CMD="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# create the table
$PSQL_CMD -c "DROP TABLE IF EXISTS bcfishpass.gradient_barriers"
$PSQL_CMD -c "CREATE TABLE bcfishpass.gradient_barriers
        (
         blue_line_key             integer               ,
         downstream_route_measure  double precision      ,
         gradient_class            integer               ,
         PRIMARY KEY (blue_line_key, downstream_route_measure)
        )"

# Process and load each watershed group separately.
# Note that this processes all of BC...
# the output table (for all 5/10/15/20/25/30 breaks at 100m) is about 540MB
for WSG in $($PSQL_CMD -t -P border=0,footer=no \
  -c "SELECT watershed_group_code
      FROM whse_basemapping.fwa_watershed_groups_poly
      ORDER BY watershed_group_code")
do
  $PSQL_CMD -X -v wsg="$WSG" < sql/gradient_barriers.sql
done

$PSQL_CMD -c "CREATE INDEX ON bcfishpass.gradient_barriers (blue_line_key)"
