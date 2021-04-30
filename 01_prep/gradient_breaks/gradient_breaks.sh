#!/bin/bash
set -euxo pipefail

# -----------
# Load gradient breaks
# -----------


time psql -t -P border=0,footer=no \
  -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly" \
  | parallel --colsep ' ' psql -f sql/gradient_breaks.sql -v wsg={1}