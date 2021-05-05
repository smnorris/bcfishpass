#!/bin/bash
set -euxo pipefail

# create the table
psql -c "DROP TABLE IF EXISTS bcfishpass.gradient_barriers"
psql -c "CREATE TABLE bcfishpass.gradient_barriers
        (
         blue_line_key             integer               ,
         downstream_route_measure  double precision      ,
         gradient_class            integer               ,
         PRIMARY KEY (blue_line_key, downstream_route_measure)
        )"

# Load as loop through watershed groups
# Only process a select few for now
for WSG in $(psql -t -P border=0,footer=no \
  -c "SELECT watershed_group_code
      FROM whse_basemapping.fwa_watershed_groups_poly
      ORDER BY watershed_group_code")
do
  psql -X -v wsg="$WSG" < sql/gradient_barriers.sql
done

psql -c "CREATE INDEX ON bcfishpass.gradient_barriers (blue_line_key)"
