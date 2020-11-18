#!/bin/bash
set -euxo pipefail

# -----------
# PSCIS
# -----------
bcdata bc2pg WHSE_FISH.PSCIS_ASSESSMENT_SVW
bcdata bc2pg WHSE_FISH.PSCIS_DESIGN_PROPOSAL_SVW
bcdata bc2pg WHSE_FISH.PSCIS_HABITAT_CONFIRMATION_SVW
bcdata bc2pg WHSE_FISH.PSCIS_REMEDIATION_SVW

# load the CWF generated PSCIS - stream - modelled crossing lookup table
# this matches all PSCIS crossings (as of July 2020) to streams/modelled crossings where possible
# null values indicate that the PSCIS crossing does not match to a FWA stream
psql -c "DROP TABLE IF EXISTS bcfishpass.pscis_modelledcrossings_streams_xref"
psql -c "CREATE TABLE bcfishpass.pscis_modelledcrossings_streams_xref (stream_crossing_id integer primary key, modelled_crossing_id integer, linear_feature_id integer)"
psql -c "\copy bcfishpass.pscis_modelledcrossings_streams_xref FROM 'data/pscis_modelledcrossings_streams_xref.csv' delimiter ',' csv header"


psql -f sql/01_prep/02_pscis/01_pscis_points_all.sql
psql -f sql/01_prep/02_pscis/02_pscis_events_prelim1.sql
psql -f sql/01_prep/02_pscis/03_pscis_events_prelim2.sql
psql -f sql/01_prep/02_pscis/04_pscis_model_match_pts.sql
psql -f sql/01_prep/02_pscis/05_pscis_events_prelim3.sql
psql -f sql/01_prep/02_pscis/06_pscis_events.sql
psql -f sql/01_prep/02_pscis/07_pscis_points_duplicates.sql
psql -f sql/01_prep/02_pscis/08_cleanup.sql