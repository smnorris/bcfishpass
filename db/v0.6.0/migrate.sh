#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# drop and re-create stream views requiring updated habitat columns and dependent objects
$PSQL -f sql/01_modify_habitat_codes.sql
$PSQL -f sql/02_comments.sql
$PSQL -f sql/03_aw_linear_summary.sql

# note that this should only be run on CWF databases, others do not have WCRP schemas/tables
$PSQL -f sql/04_wcrp_initialize_rank_tables.sql


$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"