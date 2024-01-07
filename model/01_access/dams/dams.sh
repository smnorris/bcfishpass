#!/bin/bash
set -euxo pipefail

# ---------------------
# download CABD dams and match to FWA streams
# ---------------------

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
DAMS_URL="https://cabd-web.azurewebsites.net/cabd-api/features/dams?filter=province_territory_code:eq:bc&filter=use_analysis:eq:true"

# load dams
$PSQL -c "create schema if not exists cabd"
ogr2ogr -f PostgreSQL \
  "PG:$DATABASE_URL" \
  -overwrite \
  -s_srs EPSG:4326 \
  -t_srs EPSG:3005 \
  -lco GEOMETRY_NAME=geom \
  -nln cabd.dams \
  $DAMS_URL \
  OGRGeoJSON

# create bcfishpass.dams - matching the dams to streams
$PSQL -f sql/dams.sql