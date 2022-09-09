#!/bin/bash
set -euxo pipefail

# --------
# - load source PSCIS tables
# - combine all PSCIS records into a single table
# - match to FWA streams
# - attempt to identify QA issues (duplicates)
# --------
PSQL_CMD="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# download the public views from DataBC
#bcdata bc2pg WHSE_FISH.PSCIS_ASSESSMENT_SVW
#bcdata bc2pg WHSE_FISH.PSCIS_DESIGN_PROPOSAL_SVW
#bcdata bc2pg WHSE_FISH.PSCIS_HABITAT_CONFIRMATION_SVW
#bcdata bc2pg WHSE_FISH.PSCIS_REMEDIATION_SVW

$PSQL_CMD -f sql/01_pscis_points_all.sql         # combine all points into single table
$PSQL_CMD -f sql/02_pscis_streams_150m.sql       # make preliminary matches of points to streams within 150m
$PSQL_CMD -f sql/04_pscis.sql                    # make output table
$PSQL_CMD -f sql/05_pscis_points_duplicates.sql  # note duplicates for QA
