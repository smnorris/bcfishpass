#!/bin/bash
set -euxo pipefail

# --------
# - load source PSCIS tables
# - combine all PSCIS records into a single table
# - match to FWA streams
# - attempt to identify QA issues (duplicates)
# --------
PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# download the public views from DataBC
bcdata bc2pg WHSE_FISH.PSCIS_ASSESSMENT_SVW
bcdata bc2pg WHSE_FISH.PSCIS_DESIGN_PROPOSAL_SVW
bcdata bc2pg WHSE_FISH.PSCIS_HABITAT_CONFIRMATION_SVW
bcdata bc2pg WHSE_FISH.PSCIS_REMEDIATION_SVW

$PSQL -f sql/01_pscis_points_all.sql         # combine all points into single table
$PSQL -f sql/02_pscis_streams_150m.sql       # make preliminary matches of points to streams within 150m
$PSQL -f sql/04_pscis.sql                    # make output table
$PSQL -f sql/05_pscis_points_duplicates.sql  # note duplicates for QA

# todo - get elevation of pscis points not matched to streams
# (requires download of large extent of DEM and setting env var $BCDEM, not included for now)
# $PSQL -c "drop table if exists bcfishpass.pscis_not_matched_to_streams_elevation"
# $PSQL -c "create table bcfishpass.pscis_not_matched_to_streams_elevation (stream_crossing_id integer, elevation double precision)"
# $PSQL -t -c "SELECT
#     json_build_object(
#       'type', 'FeatureCollection',
#       'features', json_agg(ST_AsGeoJSON(t.*)::json)
#     )
#     FROM (
#       SELECT
#         a.stream_crossing_id,
#         a.geom
#       FROM bcfishpass.pscis_points_all a
#       LEFT OUTER JOIN bcfishpass.pscis b
#       ON a.stream_crossing_id = b.stream_crossing_id
#       WHERE b.stream_crossing_id IS NULL
#     ) AS t" |
#   rio -q pointquery -r $BCDEM | \
#   jq '.features[].properties | [.stream_crossing_id, .value]' | \
#   jq -r --slurp '.[] | @csv' | \
#   $PSQL -c "\copy bcfishpass.pscis_not_matched_to_streams_elevation FROM STDIN delimiter ',' csv"

# create and load table pscis_not_matched_to_streams
$PSQL -f sql/06_pscis_not_matched_to_streams.sql