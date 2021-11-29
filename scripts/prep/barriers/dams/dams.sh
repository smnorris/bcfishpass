#!/bin/bash

set -euxo pipefail

tmp="${TEMP:-/tmp}"

# alter path to the data files by setting BCFISHPASS_DATA environment variable
DATAPATH="${BCFISHPASS_DATA:-../../../../data}"

PSQL_CMD="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# ---------
# download CWF dam data and match to FWA streams
# ---------
wget --trust-server-names -qNP "$tmp"  https://raw.githubusercontent.com/smnorris/bcdams/main/bcdams.geojson
ogr2ogr -f PostgreSQL \
  "PG:$DATABASE_URL" \
  -overwrite \
  -s_srs EPSG:4326 \
  -t_srs EPSG:3005 \
  -lco GEOMETRY_NAME=geom \
  -lco FID=bcdams_id \
  -nln bcfishpass.cwf_bcdams \
  $tmp/bcdams.geojson \
  bcdams

# match the dams to streams
$PSQL_CMD -f sql/dams.sql