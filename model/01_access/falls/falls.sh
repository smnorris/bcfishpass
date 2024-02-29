#!/bin/bash

# ----------
# Script to:
# - load falls from various sources
# - match pts to streams
# - combine falls into bcfishpass.falls
# - identify barriers / non-barriers
# ----------

set -exo pipefail

PSQL_CMD="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# obstacles data refreshed separately (and we no longer archive, as it will soon be replace by cabd)

# Archive existing FISS obstacles data just in case we want it later,
# the unique IDs aren't stable. Note that the archive is a full copy and
# will be made every time this is run on a different day
# if $PSQL_CMD -c "SELECT to_regclass('whse_fish.fiss_obstacles_pnt_sp')" | grep -q 'whse_fish.fiss_obstacles_pnt_sp'; then
#   DOWNLOAD_DATE=$($PSQL_CMD -tc \
#     "SELECT replace(DATE(latest_download)::text, '-', '') \
#     FROM bcdata.log \
#     WHERE table_name = 'whse_fish.fiss_obstacles_pnt_sp'" \
#     | sed -e 's/^[[:space:]]*//')
#   # just drop existing archive for given date if it aleady exists and re-archive
#   $PSQL_CMD -c "DROP TABLE IF EXISTS whse_fish.fiss_obstacles_pnt_sp_$DOWNLOAD_DATE"
#   $PSQL_CMD -c "CREATE TABLE whse_fish.fiss_obstacles_pnt_sp_$DOWNLOAD_DATE AS SELECT * FROM whse_fish.fiss_obstacles_pnt_sp"
# fi
# load the latest obstacles data
# bcdata bc2pg WHSE_FISH.FISS_OBSTACLES_PNT_SP

# load additional (unpublished) obstacle data (provided by the Province, 2014)
mkdir -p data
wget --trust-server-names -qNP data \
  https://hillcrestgeo.ca/outgoing/public/whse_fish/whse_fish.fiss_obstacles_unpublished.csv.zip
unzip -qjun -d data data/whse_fish.fiss_obstacles_unpublished.csv.zip

$PSQL_CMD -c "DROP TABLE IF EXISTS bcfishpass.fiss_obstacles_unpublished;"
$PSQL_CMD -c "CREATE TABLE bcfishpass.fiss_obstacles_unpublished
 (id                 integer           ,
 featur_typ_code    character varying ,
 point_id_field     numeric           ,
 utm_zone           numeric           ,
 utm_easting        numeric           ,
 utm_northing       numeric           ,
 height             numeric           ,
 length             numeric           ,
 strsrvy_rchsrvy_id numeric           ,
 sitesrvy_id        numeric           ,
 comments           character varying)"
$PSQL_CMD -c "\copy bcfishpass.fiss_obstacles_unpublished FROM 'data/fiss_obstacles_unpublished.csv' delimiter ',' csv header"

# match falls to streams, combine sources
$PSQL_CMD -f sql/falls.sql
