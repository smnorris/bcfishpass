#!/bin/bash
set -euxo pipefail

# --------
# - load source PSCIS tables
# - combine all PSCIS records into a single table
# - match to FWA streams
# - attempt to identify QA issues (duplicates)
# --------
PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

$PSQL -f sql/01_pscis_points_all.sql             # combine all points into single table
$PSQL -f sql/02_pscis_streams_150m.sql           # make preliminary matches of points to streams within 150m
$PSQL -f sql/04_pscis.sql                        # make output table
$PSQL -f sql/05_pscis_points_duplicates.sql      # note duplicates for QA
$PSQL -f sql/06_pscis_not_matched_to_streams.sql # create and load table pscis_not_matched_to_streams