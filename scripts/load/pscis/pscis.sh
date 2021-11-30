#!/bin/bash
set -euxo pipefail

# --------
# - load source PSCIS tables
# - combine all PSCIS records into a single table
# - match to FWA streams
# - attempt to identify QA issues (duplicates)
# --------

PSQL_CMD="psql $DATABASE_URL -v ON_ERROR_STOP=1"
DATAPATH="${BCFISHPASS_DATA:-../../../../data}"

# download the public views from DataBC
bcdata bc2pg WHSE_FISH.PSCIS_ASSESSMENT_SVW
bcdata bc2pg WHSE_FISH.PSCIS_DESIGN_PROPOSAL_SVW
bcdata bc2pg WHSE_FISH.PSCIS_HABITAT_CONFIRMATION_SVW
bcdata bc2pg WHSE_FISH.PSCIS_REMEDIATION_SVW

$PSQL_CMD -f sql/01_pscis_points_all.sql         # combine all points into single table
$PSQL_CMD -f sql/02_pscis_events_prelim1.sql     # make preliminary matches of points to streams
$PSQL_CMD -f sql/03_pscis_events_prelim2.sql     # refine the matches
$PSQL_CMD -f sql/04_pscis.sql                    # make output table
$PSQL_CMD -f sql/05_pscis_points_duplicates.sql  # note duplicates for QA

# drop the temp tables
$PSQL_CMD -c "DROP TABLE bcfishpass.pscis_events_prelim1"
$PSQL_CMD -c "DROP TABLE bcfishpass.pscis_events_prelim2"
