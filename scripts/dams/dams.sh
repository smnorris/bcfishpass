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
  "https://cabd-web.azurewebsites.net/cabd-api/features/dams?filter=province_territory_code:eq:bc" \
  OGRGeoJSON

# load dam code tables
$PSQL_CMD -c "drop table if exists cabd.dam_use_codes"
$PSQL_CMD -c "create table cabd.dam_use_codes (code smallint, name character varying(32), description text)"
curl "https://cabd-web.azurewebsites.net/cabd-api/features/types/dams?properties" |
    jq -r '.attributes[] | select( ."id" | contains("use_code")) | .values[] | [.value, .name, .description] | @csv' | $PSQL_CMD -c "\copy cabd.dam_use_codes FROM STDIN delimiter ',' csv"


# create bcfishpass.dams - matching the dams to streams
$PSQL_CMD -f sql/dams.sql

# report on unmatched features
psql2csv $DATABASE_URL "select
  a.cabd_id,
  a.dam_name_en
from cabd.dams a
left join bcfishpass.dams b
on a.cabd_id = b.dam_id
where b.dam_id is null;" > unmatched_dams.csv