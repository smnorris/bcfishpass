#!/bin/bash
set -euxo pipefail

# download stream sample sites and match to streams
bcdata bc2pg WHSE_FISH.FISS_STREAM_SAMPLE_SITES_SP
psql -c "CREATE INDEX ON whse_fish.fiss_stream_sample_sites_sp (new_watershed_code)"
psql -f sql/fiss_stream_sample_sites_events.sql

# create a measured_channel_width table, holding avg channel widths from sample sites / pscis
psql -f sql/measured_channel_width.sql

# for streams where no measured width is present, we model it
# to support modelling, load mean annual precip (MAP)
psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_watersheds"
psql -c "CREATE TABLE bcfishpass.mean_annual_precip_watersheds (watershed_feature_id integer, map numeric)"
psql -c "\copy bcfishpass.mean_annual_precip_watersheds FROM 'data/map.csv' delimiter ',' csv header"

# and calculate the Mean Annual Precip of the area upstream of each stream segment
psql -f sql/mean_annual_precip.sql