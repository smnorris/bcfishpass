#!/bin/bash
set -euxo pipefail

# -----------
# Create modelled_stream_crossings
# -----------

# First, Load roads etc

# Directly download the DRA archive, it is too big to reliably request via WFS
# *** NOTE ***
# Structure of data in this archive DOES NOT MATCH structure in the BCGW !
# To avoid this issue, load data to whse_basemapping.transport_line rather than DRA_DGTL_ROAD_ATLAS_MPAR_SP
# ************
wget -N ftp://ftp.geobc.gov.bc.ca/sections/outgoing/bmgs/DRA_Public/dgtl_road_atlas.gdb.zip
unzip -qun dgtl_road_atlas.gdb.zip

ogr2ogr \
  -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -lco GEOMETRY_NAME=geom \
  -lco FID=transport_line_id \
  -nln whse_basemapping.transport_line \
  dgtl_road_atlas.gdb \
  TRANSPORT_LINE

# include the code tables
ogr2ogr \
  -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -nln whse_basemapping.transport_line_type_code \
  dgtl_road_atlas.gdb \
  TRANSPORT_LINE_TYPE_CODE

ogr2ogr \
  -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -nln whse_basemapping.transport_line_surface_code \
  dgtl_road_atlas.gdb \
  TRANSPORT_LINE_SURFACE_CODE

ogr2ogr \
  -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -nln whse_basemapping.transport_line_divided_code \
  dgtl_road_atlas.gdb \
  TRANSPORT_LINE_DIVIDED_CODE

ogr2ogr \
  -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -nln whse_basemapping.transport_line_structure_code \
  dgtl_road_atlas.gdb \
  TRANSPORT_LINE_STRUCTURE_CODE


# Get additional road data direct from BCGW, requesting full datasets (subset in crossing scripts)
bcdata bc2pg WHSE_FOREST_TENURE.FTEN_ROAD_SECTION_LINES_SVW --promote_to_multi # this table doesn't have a single primary key
bcdata bc2pg WHSE_MINERAL_TENURE.OG_ROAD_SEGMENT_PERMIT_SP --fid og_road_segment_permit_id
bcdata bc2pg WHSE_MINERAL_TENURE.OG_PETRLM_DEV_RDS_PRE06_PUB_SP --fid og_petrlm_dev_rd_pre06_pub_id
bcdata bc2pg WHSE_BASEMAPPING.GBA_RAILWAY_TRACKS_SP --fid railway_track_id
bcdata bc2pg WHSE_BASEMAPPING.GBA_RAILWAY_STRUCTURE_LINES_SP --fid RAILWAY_STRUCTURE_LINE_ID
bcdata bc2pg WHSE_IMAGERY_AND_BASE_MAPS.MOT_ROAD_STRUCTURE_SP --fid HWY_STRUCTURE_CLASS_ID


# Now create modelled road/railway - stream crossings table by intersecting various transportation
# features with FWA streams and removing duplicate crossings as best as possible

# make sure schema exists
psql -c "CREATE SCHEMA IF NOT EXISTS bcfishpass"

# create empty crossings table
psql -f sql/01_prep/02_modelled_stream_crossings/01_create_output_table.sql

# load preliminary crossings by source and watershed group
time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/01_prep/02_modelled_stream_crossings/02_intersect_dra.sql -v wsg={1}

time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/01_prep/02_modelled_stream_crossings/03_intersect_ften.sql -v wsg={1}

time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/01_prep/02_modelled_stream_crossings/04_intersect_ogc.sql -v wsg={1}

time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/01_prep/02_modelled_stream_crossings/05_intersect_ogcpre06.sql -v wsg={1}

time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/01_prep/02_modelled_stream_crossings/06_intersect_railway.sql -v wsg={1}

psql -c "CREATE INDEX ON fish_passage.modelled_stream_crossings (transport_line_id);"
psql -c "CREATE INDEX ON fish_passage.modelled_stream_crossings (ften_road_section_lines_id);"
psql -c "CREATE INDEX ON fish_passage.modelled_stream_crossings (og_road_segment_permit_id);"
psql -c "CREATE INDEX ON fish_passage.modelled_stream_crossings (og_petrlm_dev_rd_pre06_pub_id);"
psql -c "CREATE INDEX ON fish_passage.modelled_stream_crossings (railway_track_id);"
psql -c "CREATE INDEX ON fish_passage.modelled_stream_crossings (blue_line_key);"
psql -c "CREATE INDEX ON fish_passage.modelled_stream_crossings (linear_feature_id);"
psql -c "CREATE INDEX ON fish_passage.modelled_stream_crossings USING GIST (geom);"

# remove duplicate crossings introduced by using multiple sources
psql -f sql/07_remove_duplicates.sql
