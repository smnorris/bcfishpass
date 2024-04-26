#!/bin/bash
set -euxo pipefail

#-------
# Download modelled crossings archive, load to db
#-------

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")

# Overlay streams with roads, attempt to identify unique crossings and classify as culvert/bridge
# Note that this is only performed on primary db, other dbs only need to download the archive

# create output table
$PSQL -f sql/01_create_output_table.sql

# load preliminary crossings, iterating through watershed groups for each data source
parallel $PSQL -f sql/02_intersect_dra.sql -v wsg={1} ::: $WSGS
parallel $PSQL -f sql/03_intersect_ften.sql -v wsg={1} ::: $WSGS
parallel $PSQL -f sql/04_intersect_ogc.sql -v wsg={1} ::: $WSGS
parallel $PSQL -f sql/05_intersect_ogcpre06.sql -v wsg={1} ::: $WSGS
parallel $PSQL -f sql/06_intersect_railway.sql -v wsg={1} ::: $WSGS

# remove duplicate crossings introduced by using multiple sources
$PSQL -f sql/07_remove_duplicates.sql
$PSQL -f sql/08_identify_open_bottom_structures.sql

# assign modelled_crossing_id from previous version to ensure consistency
$PSQL -f sql/09_match_existing_crossings.sql

#$PSQL -c "DROP TABLE bcfishpass.modelled_stream_crossings_build"