#!/bin/bash
set -euxo pipefail

# create the load table
psql -c "drop table if exists bcfishpass.discharge_load"
psql -c "create table bcfishpass.discharge_load (wscode_ltree text, localcode_ltree text, watershed_group_code text, discharge numeric(7,2))"

# load all Fraser/Peace/Columbia watershed groups in parallel to temp postgres table
psql -A -t -P border=0,footer=off -c "SELECT DISTINCT watershed_group_code
      FROM whse_basemapping.fwa_assessment_watersheds_poly
      WHERE (wscode_ltree <@ '100'::ltree OR wscode_ltree <@ '300'::ltree OR wscode_ltree <@ '200'::ltree)
      ORDER BY watershed_group_code" |
parallel ./raster2fwa.sh data/discharge.tif bcfishpass.discharge_load {}
