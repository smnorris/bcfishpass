#!/bin/bash

# ---------------------
# download CABD dams and match to FWA streams
# ---------------------

set -euxo pipefail

PSQL_CMD="psql $DATABASE_URL -v ON_ERROR_STOP=1"

$PSQL_CMD -c "create schema if not exists cabd"

# load dams
ogr2ogr -f PostgreSQL \
  "PG:$DATABASE_URL" \
  -overwrite \
  -s_srs EPSG:4326 \
  -t_srs EPSG:3005 \
  -lco GEOMETRY_NAME=geom \
  -nln cabd.dams \
  "https://cabd-web.azurewebsites.net/cabd-api/features/dams?filter=province_territory_code:eq:bc&filter=use_analysis:eq:true" \
  OGRGeoJSON

$PSQL_CMD -c "alter table cabd.dams alter column cabd_id type uuid using cabd_id::uuid"

# create bcfishpass.dams - matching the dams to streams
$PSQL_CMD -f sql/dams.sql

# report on dams that do not get matched to FWA streams
psql2csv $DATABASE_URL "select
  a.cabd_id,
  a.dam_name_en
from cabd.dams a
left join bcfishpass.dams b
on a.cabd_id = b.dam_id
where b.dam_id is null
order by a.cabd_id;" > dams_not_matched_to_streams.csv