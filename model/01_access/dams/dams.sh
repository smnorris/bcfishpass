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

# report on dams that do not get matched to FWA streams
psql --csv -c "select
  a.cabd_id,
  a.dam_name_en
from cabd.dams a
left join bcfishpass.dams b
on a.cabd_id = b.dam_id
where b.dam_id is null
order by a.cabd_id;" > dams_not_matched_to_streams.csv