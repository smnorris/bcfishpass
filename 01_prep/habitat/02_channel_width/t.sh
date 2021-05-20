#!/bin/bash
set -euxo pipefail

TMP=~/tmp


for WSG in $(psql -t -P border=0,footer=no \
  -c "SELECT watershed_group_code
      FROM whse_basemapping.fwa_watershed_groups_poly
      ORDER BY watershed_group_code")
do
  psql -X -v wsg:"$WSG" < sql/map_upstream.sql
done