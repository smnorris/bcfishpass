#!/bin/bash
set -euxo pipefail

# load the raster to the db
psql -c "DROP TABLE IF EXISTS bcfishpass.discharge_raster"
raster2pgsql data/discharge.nc bcfishpass.discharge_raster -s 4326 | psql

# create the load table
psql -c "drop table if exists bcfishpass.discharge_load"
psql -c "create table bcfishpass.discharge_load (watershed_feature_id integer primary key, discharge_mm double precision);"

# load all PCIC study area watershed groups in parallel to temp postgres table
psql -AtX -P border=0,footer=off -c "SELECT DISTINCT watershed_group_code
      FROM whse_basemapping.fwa_assessment_watersheds_poly
      WHERE (wscode_ltree <@ '100'::ltree OR wscode_ltree <@ '300'::ltree OR wscode_ltree <@ '200'::ltree)
      ORDER BY watershed_group_code" |
parallel psql -XA -v wsg={} -f sql/discharge_load.sql
