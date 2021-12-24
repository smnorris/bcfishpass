#!/bin/bash
set -euxo pipefail

$PSQL_CMD='psql $DATABASE_URL'
# calculate channel width - measured / mapped / modelled

# --------
# MEASURED
# --------
# First, download stream sample sites and match to streams
bcdata bc2pg WHSE_FISH.FISS_STREAM_SAMPLE_SITES_SP
$PSQL_CMD -c "CREATE INDEX ON whse_fish.fiss_stream_sample_sites_sp (new_watershed_code)"
$PSQL_CMD -f sql/fiss_stream_sample_sites_events.sql

# Now load the measured channel widths where we have them, averaging measurements on the same stream
# NOTE - this presumes PSCIS data is already loaded
$PSQL_CMD -f sql/channel_width_measured.sql


# --------
# MAPPED
# --------
$PSQL_CMD -c "DROP TABLE IF EXISTS bcfishpass.channel_width_mapped;"
$PSQL_CMD -c "CREATE TABLE bcfishpass.channel_width_mapped
(
  linear_feature_id bigint,
  watershed_group_code text,
  channel_width_mapped numeric,
  cw_stddev numeric,
  UNIQUE (linear_feature_id)
);"
# load each watershed group seperately, in parallel
time $PSQL_CMD -t -P border=0,footer=no \
-c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly ORDER BY watershed_group_code" \
    | parallel $PSQL_CMD -f sql/channel_width_mapped.sql -v wsg={1}
$PSQL_CMD -c "CREATE INDEX ON bcfishpass.channel_width_mapped (linear_feature_id)"


# --------
# Build report on measured and mapped data points to be used for generating the model
# --------

# get bec and ecosection data and optimize it for quicker point in poly queries
bc2pg WHSE_TERRESTRIAL_ECOLOGY.ERC_ECOSECTIONS_SP --promote_to_multi
bc2pg WHSE_FOREST_VEGETATION.BEC_BIOGEOCLIMATIC_POLY --promote_to_multi
#$PSQL_CMD -f sql/load_bec_eco.sql

# report on measured/mapped CW data and dump to file
$PSQL_CMD -f sql/channel_width_analysis.sql
psql2csv $DATABASE_URL "SELECT * FROM bcfishpass.channel_width_analysis" > channel_width_analysis.csv

# --------
# MODELLED
# --------
# run the model as a single query, it doesn't take too long to process
time $PSQL_CMD -f sql/channel_width_modelled.sql