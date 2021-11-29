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

# alter path to the data files by setting BCFISHPASS_DATA environment variable
DATAPATH="${BCFISHPASS_DATA:-../../../../data}"

tmp="${TEMP:-/tmp}"

# Archive existing FISS obstacles data just in case we want it later,
# the unique IDs aren't stable. Note that the archive is a full copy and
# will be made every time this is run on a different day
if $PSQL_CMD -c "SELECT to_regclass('whse_fish.fiss_obstacles_pnt_sp')" | grep -q 'whse_fish.fiss_obstacles_pnt_sp'; then
  DOWNLOAD_DATE=$($PSQL_CMD -tc \
    "SELECT replace(DATE(date_downloaded)::text, '-', '') \
    FROM public.bcdata \
    WHERE table_name = 'whse_fish.fiss_obstacles_pnt_sp'" \
    | sed -e 's/^[[:space:]]*//')
  # just drop existing archive for given date if it aleady exists and re-archive
  $PSQL_CMD -c "DROP TABLE IF EXISTS whse_fish.fiss_obstacles_pnt_sp_$DOWNLOAD_DATE"
  $PSQL_CMD -c "CREATE TABLE whse_fish.fiss_obstacles_pnt_sp_$DOWNLOAD_DATE AS SELECT * FROM whse_fish.fiss_obstacles_pnt_sp"
fi

# load the latest obstacles data
bcdata bc2pg WHSE_FISH.FISS_OBSTACLES_PNT_SP

# load additional (unpublished) obstacle data (provided by the Province, 2014)
wget --trust-server-names -qNP "$tmp" \
  https://hillcrestgeo.ca/outgoing/public/whse_fish/whse_fish.fiss_obstacles_unpublished.csv.zip
unzip -qjun -d "$tmp" "$tmp/whse_fish.fiss_obstacles_unpublished.csv.zip"

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
$PSQL_CMD -c "\copy bcfishpass.fiss_obstacles_unpublished FROM '$tmp/fiss_obstacles_unpublished.csv' delimiter ',' csv header"


# load lookup that controls barrier status for FISS falls
$PSQL_CMD -c "DROP TABLE IF EXISTS bcfishpass.falls_barrier_ind;"
$PSQL_CMD -c "CREATE TABLE bcfishpass.falls_barrier_ind
 (blue_line_key              integer,
 downstream_route_measure    integer,
 barrier_ind                 boolean,
 watershed_group_code        text,
 reviewer                    text,
 notes                       text)"
$PSQL_CMD -c "\copy bcfishpass.falls_barrier_ind FROM '$DATAPATH/falls/falls_barrier_ind.csv' delimiter ',' csv header"


# load other falls, from various sources (add any new falls to this table)
$PSQL_CMD -c "DROP TABLE IF EXISTS bcfishpass.falls_other"
$PSQL_CMD -c "CREATE TABLE bcfishpass.falls_other
  (
   blue_line_key integer,
   downstream_route_measure integer,
   barrier_ind boolean,
   height numeric,
   watershed_group_code text,
   source text,
   reviewer text,
   notes text,
   primary key (blue_line_key, downstream_route_measure)
   )"
$PSQL_CMD -c "\copy bcfishpass.falls_other FROM '$DATAPATH/falls/falls_other.csv' delimiter ',' csv header"

# match falls to streams, combine sources
$PSQL_CMD -f sql/falls.sql
