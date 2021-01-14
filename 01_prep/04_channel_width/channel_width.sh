#!/bin/bash
set -euxo pipefail

# for streams where no measured width is present, we model it
# to support modelling, load mean annual precip (MAP)
psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_watersheds"
psql -c "CREATE TABLE bcfishpass.mean_annual_precip_watersheds (watershed_feature_id integer, map numeric)"
psql -c "\copy bcfishpass.mean_annual_precip_watersheds FROM 'data/map.csv' delimiter ',' csv header"

# and calculate the Mean Annual Precip of the area upstream of each stream segment
psql -f sql/mean_annual_precip.sql

# download stream sample sites and match to streams
bcdata bc2pg WHSE_FISH.FISS_STREAM_SAMPLE_SITES_SP
psql -c "CREATE INDEX ON whse_fish.fiss_stream_sample_sites_sp (new_watershed_code)"
psql -f sql/fiss_stream_sample_sites_events.sql

# model all channel widths
psql -f sql/modelled_channel_width.sql

# load the measured channel widths where we have them
psql -f sql/measured_channel_width.sql


