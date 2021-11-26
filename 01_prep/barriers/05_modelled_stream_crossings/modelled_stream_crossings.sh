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

# download modelled crossings archive (to extract exising IDs, they need to remain consistent)
wget https://www.hillcrestgeo.ca/outgoing/fishpassage/data/bcfishpass/inputs/modelled_stream_crossings_archive.gpkg.zip
unzip modelled_stream_crossings_archive.gpkg.zip
ogr2ogr \
  -f PostgreSQL \
  "PG:host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -overwrite \
  -nln bcfishpass.modelled_stream_crossings_archive \
  modelled_stream_crossings_archive.gpkg \
  modelled_stream_crossings_archive
rm modelled_stream_crossings_archive.gpkg.zip
rm modelled_stream_crossings_archive.gpkg

# Now create modelled road/railway - stream crossings table by intersecting various transportation
# features with FWA streams and removing duplicate crossings as best as possible

# create empty crossings table
psql -f sql/01_create_output_table.sql

# load preliminary crossings by source and watershed group
time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/02_intersect_dra.sql -v wsg={1}

time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/03_intersect_ften.sql -v wsg={1}

time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/04_intersect_ogc.sql -v wsg={1}

time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/05_intersect_ogcpre06.sql -v wsg={1}

time psql -t -P border=0,footer=no \
-c "SELECT ''''||watershed_group_code||'''' FROM whse_basemapping.fwa_watershed_groups_poly" \
    | sed -e '$d' \
    | parallel --colsep ' ' psql -f sql/06_intersect_railway.sql -v wsg={1}

psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (transport_line_id);"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (ften_road_section_lines_id);"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (og_road_segment_permit_id);"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (og_petrlm_dev_rd_pre06_pub_id);"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (railway_track_id);"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (blue_line_key);"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (linear_feature_id);"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING GIST (geom);"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING GIST (wscode_ltree)"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING BTREE (wscode_ltree)"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING GIST (localcode_ltree)"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING BTREE (localcode_ltree)"

# remove duplicate crossings introduced by using multiple sources
psql -f sql/07_remove_duplicates.sql

psql -f sql/08_identify_open_bottom_structures.sql

# assign modelled_crossing_id from previous version to ensure consistency
psql -f sql/09_match_archived_crossings.sql

# load manual QA of modelled crossings - (modelled crossings that are either OBS or non-existent)
psql -c "DROP TABLE IF EXISTS bcfishpass.modelled_stream_crossings_fixes"
psql -c "CREATE TABLE bcfishpass.modelled_stream_crossings_fixes (
          modelled_crossing_id integer,
          reviewer text,
          watershed_group_code text,
          structure text,
          notes text)"
psql -c "\copy bcfishpass.modelled_stream_crossings_fixes FROM 'data/modelled_stream_crossings_fixes.csv' delimiter ',' csv header"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings_fixes (modelled_crossing_id)"