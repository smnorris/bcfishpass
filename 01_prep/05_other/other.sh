#!/bin/bash

set -euxo pipefail

# load additional falls

psql -c "CREATE SCHEMA IF NOT EXISTS cwf"
ogr2ogr -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -s_srs EPSG:4326 \
  -t_srs EPSG:3005 \
  -lco GEOMETRY_NAME=geom \
  -nln cwf.waterfalls_additional \
  data/falls.geojson \
  falls

# match the dams to streams
psql -f sql/cwf_waterfalls_additional.sql

# load misc barriers
psql -f sql/misc_barriers.sql
psql -c "\copy bcfishpass.misc_barriers FROM 'data/misc_barriers.csv' delimiter ',' csv header"