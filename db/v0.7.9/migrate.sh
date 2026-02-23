#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# temp fix to exclude certain PSCIS crossings from bcfishpass.crossings_wcrp_vw
$PSQL -f pscis_exclusions.sql