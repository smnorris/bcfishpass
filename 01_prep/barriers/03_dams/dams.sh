#!/bin/bash

set -euxo pipefail

tmp="${TEMP:-/tmp}"

# ---------
# download CWF dam data and match to FWA streams
# ---------
wget --trust-server-names -qNP "$tmp"  https://raw.githubusercontent.com/smnorris/bcdams/main/bcdams.geojson
ogr2ogr -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -s_srs EPSG:4326 \
  -t_srs EPSG:3005 \
  -lco GEOMETRY_NAME=geom \
  -lco FID=bcdams_id \
  -nln bcfishpass.bcdams \
  $tmp/bcdams.geojson \
  bcdams

# match the dams to streams
psql -f sql/dams.sql