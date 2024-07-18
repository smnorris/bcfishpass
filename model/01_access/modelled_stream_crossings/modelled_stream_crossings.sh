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

# load new data to primary table
$PSQL -c "truncate bcfishpass.modelled_stream_crossings;
INSERT INTO bcfishpass.modelled_stream_crossings (
  modelled_crossing_id,
  modelled_crossing_type,
  modelled_crossing_type_source,
  transport_line_id,
  ften_road_section_lines_id,
  og_road_segment_permit_id,
  og_petrlm_dev_rd_pre06_pub_id,
  railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
)
select
  modelled_crossing_id,
  modelled_crossing_type,
  modelled_crossing_type_source,
  transport_line_id,
  ften_road_section_lines_id,
  og_road_segment_permit_id,
  og_petrlm_dev_rd_pre06_pub_id,
  railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
from bcfishpass.modelled_stream_crossings_output"

# cleanup
$PSQL -c "DROP TABLE bcfishpass.modelled_stream_crossings_build"
$PSQL -c "DROP TABLE bcfishpass.modelled_stream_crossings_output"