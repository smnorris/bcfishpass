#!/bin/bash
set -euxo pipefail

tmp="${TEMP:-/tmp}"

# Script to:
# - load falls from FISS and falls.geojson,
# - match pts to streams
# - combine falls into bcfishpass.falls

# Archive existing FISS obstacles data just in case we want it later, the unique IDs aren't stable
# (only keep one archive per day, and some work could be done to ensure the archive is only done if data has changed)
# TODO - this presumes that the obstacles table is already present... will break on first run of script
DOWNLOAD_DATE=$(psql -tc "SELECT replace(DATE(date_downloaded)::text, '-', '') FROM public.bcdata WHERE table_name = 'whse_fish.fiss_obstacles_pnt_sp'" | sed -e 's/^[[:space:]]*//')
psql -c "DROP TABLE IF EXISTS whse_fish.fiss_obstacles_pnt_sp_$DOWNLOAD_DATE"
psql -c "CREATE TABLE whse_fish.fiss_obstacles_pnt_sp_$DOWNLOAD_DATE AS SELECT * FROM whse_fish.fiss_obstacles_pnt_sp"

# load the latest obstacles data
bcdata bc2pg WHSE_FISH.FISS_OBSTACLES_PNT_SP

# load additional (unpublished) obstacle data (provided by the Province, 2014)
wget --trust-server-names -qNP "$tmp" https://hillcrestgeo.ca/outgoing/public/whse_fish/whse_fish.fiss_obstacles_unpublished.csv.zip
unzip -qjun -d "$tmp" "$tmp/whse_fish.fiss_obstacles_unpublished.csv.zip"

psql -c "DROP TABLE IF EXISTS bcfishpass.fiss_obstacles_unpublished;"
psql -c "CREATE TABLE bcfishpass.fiss_obstacles_unpublished
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
psql -c "\copy bcfishpass.fiss_obstacles_unpublished FROM '$tmp/fiss_obstacles_unpublished.csv' delimiter ',' csv header"


# load lookup that controls barrier status for FISS falls
psql -c "DROP TABLE IF EXISTS bcfishpass.falls_barrier_ind;"
psql -c "CREATE TABLE bcfishpass.falls_barrier_ind
 (blue_line_key              integer,
 downstream_route_measure    integer,
 barrier_ind                 boolean,
 watershed_group_code        text,
 reviewer                    text,
 notes                       text)"
psql -c "\copy bcfishpass.falls_barrier_ind FROM 'data/falls_barrier_ind.csv' delimiter ',' csv header"


# load other falls, from various sources (add any new falls to this table)
psql -c "DROP TABLE IF EXISTS bcfishpass.falls_other"
psql -c "CREATE TABLE bcfishpass.falls_other
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
psql -c "\copy bcfishpass.falls_other FROM 'data/falls_other.csv' delimiter ',' csv header"

# match falls to streams, combine sources
psql -f sql/falls.sql
