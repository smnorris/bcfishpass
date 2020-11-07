#!/bin/bash

set -euxo pipefail

tmp="${TEMP:-/tmp}"

# ---------
# download CWF dam data and match to FWA streams
# ---------

wget --trust-server-names -qNP "$tmp"  https://raw.githubusercontent.com/smnorris/bcdams/main/bcdams.geojson
psql -c "CREATE SCHEMA IF NOT EXISTS cwf"
ogr2ogr -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -s_srs EPSG:4326 \
  -t_srs EPSG:3005 \
  -lco GEOMETRY_NAME=geom \
  -lco FID=bcdams_id \
  -nln cwf.bcdams \
  $tmp/bcdams.geojson \
  bcdams

# match the dams to streams
psql -f barriers/01_definite/sql/bcdams_events.sql