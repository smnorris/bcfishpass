#!/bin/bash
set -euxo pipefail

# update crossings_vw
psql $DATABASE_URL -f sql/modelled_crossing_office_review_date.sql

# FWCP
psql $DATABASE_URL -f ../v0.5.0/sql/views/fptwg_freshwater_fish_habitat_accessibility_model.sql
psql $DATABASE_URL -f ../v0.5.0/sql/reports/fptwg_assmt_wsd_summary_vw.sql

# CWF
psql $DATABASE_URL -f sql/auto_rank.sql

# note version
psql $DATABASE_URL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"