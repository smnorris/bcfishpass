#!/bin/bash
set -euxo pipefail


# download the bcgw views
bcdata bc2pg WHSE_FISH.PSCIS_ASSESSMENT_SVW
bcdata bc2pg WHSE_FISH.PSCIS_DESIGN_PROPOSAL_SVW
bcdata bc2pg WHSE_FISH.PSCIS_HABITAT_CONFIRMATION_SVW
bcdata bc2pg WHSE_FISH.PSCIS_REMEDIATION_SVW

# load the PSCIS - stream - modelled crossing lookup table
# This lookup matches PSCIS crossings to streams/modelled crossings where automated matching
# (via smallest distance or matched name) does not match correctly
# PSCIS crossings present in the lookup with no stream/modelled crossing do not get matched to a stream
psql -c "DROP TABLE IF EXISTS bcfishpass.pscis_modelledcrossings_streams_xref"
psql -c "CREATE TABLE bcfishpass.pscis_modelledcrossings_streams_xref
        (stream_crossing_id integer PRIMARY KEY,
         modelled_crossing_id integer UNIQUE,
         linear_feature_id integer,
         watershed_group_code text,
         reviewer text,
         notes text)"
psql -c "\copy bcfishpass.pscis_modelledcrossings_streams_xref FROM 'data/pscis_modelledcrossings_streams_xref.csv' delimiter ',' csv header"

# load the PSCIS fixes table, noting OBS barriers, non-accessible streams etc
psql -c "DROP TABLE IF EXISTS bcfishpass.pscis_barrier_result_fixes"
psql -c "CREATE TABLE bcfishpass.pscis_barrier_result_fixes (
         stream_crossing_id integer PRIMARY KEY,
         updated_barrier_result_code text,
         watershed_group_code text,
         reviewer text,
         notes text)"
psql -c "\copy bcfishpass.pscis_barrier_result_fixes FROM 'data/pscis_barrier_result_fixes.csv' delimiter ',' csv header"

psql -f sql/01_pscis_points_all.sql         # combine all points into single table
psql -f sql/02_pscis_events_prelim1.sql     # make preliminary matches of points to streams
psql -f sql/03_pscis_events_prelim2.sql     # refine the matches
psql -f sql/04_pscis.sql                    # make output table
psql -f sql/05_pscis_points_duplicates.sql  # note duplicates for QA

# drop the temp tables
psql -c "DROP TABLE bcfishpass.pscis_events_prelim1"
psql -c "DROP TABLE bcfishpass.pscis_events_prelim2"
