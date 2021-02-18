#!/bin/bash
set -euxo pipefail

# Script to:
# - load falls from FISS and falls.geojson,
# - match pts to streams
# - combine falls into bcfishpass.falls

# Archive existing FISS obstacles data just in case we want it later, the unique IDs aren't stable
# (only keep one archive per day, and some work could be done to ensure the archive is only done if data has changed)
DOWNLOAD_DATE=$(psql -tc "SELECT replace(DATE(date_downloaded)::text, '-', '') FROM public.bcdata WHERE table_name = 'whse_fish.fiss_obstacles_pnt_sp'" | sed -e 's/^[[:space:]]*//')
psql -c "DROP TABLE IF EXISTS whse_fish.fiss_obstacles_pnt_sp_$DOWNLOAD_DATE"
psql -c "CREATE TABLE whse_fish.fiss_obstacles_pnt_sp_$DOWNLOAD_DATE AS SELECT * FROM whse_fish.fiss_obstacles_pnt_sp"

# load the latest obstacles data
bcdata bc2pg WHSE_FISH.FISS_OBSTACLES_PNT_SP

# load additional (unpublished) obstacle data (provided by the Province, 2014)
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
psql -c "\copy bcfishpass.fiss_obstacles_unpublished FROM 'data/fiss_obstacles_unpublished.csv' delimiter ',' csv header"

# load lookup that controls barrier status for FISS falls
psql -c "DROP TABLE IF EXISTS bcfishpass.falls_fiss_barrier_ind;"
psql -c "CREATE TABLE bcfishpass.falls_fiss_barrier_ind
 (blue_line_key              integer,
 downstream_route_measure    integer,
 barrier_ind                 boolean)"
psql -c "\copy bcfishpass.falls_fiss_barrier_ind FROM 'data/falls_fiss_barrier_ind.csv' delimiter ',' csv header"


# load other falls, from various sources (add any new falls to this table)
# (World Waterfall Database, CanVec, FISS (these are presumably duplicates), Irvine 2020)
ogr2ogr -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -s_srs EPSG:4326 \
  -t_srs EPSG:3005 \
  -nln bcfishpass.falls_other \
  -lco GEOMETRY_NAME=geom \
  data/falls_other.geojson
psql -c "ALTER TABLE bcfishpass.falls_other DROP COLUMN ogc_fid"
psql -c "ALTER TABLE bcfishpass.falls_other ADD PRIMARY KEY (falls_other_id)"

# match falls to streams, combine sources
psql -f sql/falls.sql


