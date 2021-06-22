#!/bin/bash
set -euxo pipefail

# calculate channel width - measured / mapped / modelled

# --------
# MEASURED
# --------
# First, download stream sample sites and match to streams
bcdata bc2pg WHSE_FISH.FISS_STREAM_SAMPLE_SITES_SP
psql -c "CREATE INDEX ON whse_fish.fiss_stream_sample_sites_sp (new_watershed_code)"
psql -f sql/fiss_stream_sample_sites_events.sql

# Now load the measured channel widths where we have them, averaging measurements on the same stream
# NOTE - this presumes PSCIS data is already loaded
psql -f sql/channel_width_measured.sql


# --------
# MAPPED
# --------
psql -c "DROP TABLE IF EXISTS bcfishpass.channel_width_mapped;"
psql -c "CREATE TABLE bcfishpass.channel_width_mapped
(
  linear_feature_id bigint,
  blue_line_key integer,
  downstream_route_measure integer,
  watershed_group_code text,
  channel_width_mapped double precision,
  geom geometry(PointZM,3005)
  UNIQUE (linear_feature_id, downstream_route_measure)
);"
# load each watershed group seperately, in parallel
time psql -t -P border=0,footer=no \
-c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly ORDER BY watershed_group_code" \
    | parallel psql -f sql/channel_width_mapped.sql -v wsg={1}
psql -c "CREATE INDEX ON bcfishpass.channel_width_mapped (linear_feature_id)"


# --------
# MODELLED
# --------
# run the model as a single query, it doesn't take too long to process
time psql -f sql/channel_width_modelled.sql