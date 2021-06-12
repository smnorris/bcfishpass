#!/bin/bash
set -euxo pipefail

# load the raster to the db
psql -c "DROP TABLE IF EXISTS bcfishpass.discharge_raster"
raster2pgsql data/discharge.tif bcfishpass.discharge_raster | psql

# create the load table
psql -c "drop table if exists bcfishpass.discharge_load"
psql -c "create table bcfishpass.discharge_load (watershed_feature_id integer primary key, discharge_mm double precision);"

# load all Fraser/Peace/Columbia watershed groups in parallel to temp postgres table
psql -A -t -P border=0,footer=off -c "SELECT DISTINCT watershed_group_code
      FROM whse_basemapping.fwa_assessment_watersheds_poly
      WHERE (wscode_ltree <@ '100'::ltree OR wscode_ltree <@ '300'::ltree OR wscode_ltree <@ '200'::ltree)
      ORDER BY watershed_group_code" |
parallel psql -XA -v wsg={} -f sql/discharge_load.sql
