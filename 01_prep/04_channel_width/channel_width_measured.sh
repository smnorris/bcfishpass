#!/bin/bash
set -euxo pipefail

# download stream sample sites and match to streams
bcdata bc2pg WHSE_FISH.FISS_STREAM_SAMPLE_SITES_SP
psql -c "CREATE INDEX ON whse_fish.fiss_stream_sample_sites_sp (new_watershed_code)"
psql -f sql/fiss_stream_sample_sites_events.sql

# load the measured channel widths where we have them,
# and add various parameters used to model predicted channel width
psql -f sql/channel_width_measured.sql
