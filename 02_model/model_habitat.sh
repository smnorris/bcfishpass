#!/bin/bash
set -euxo pipefail

#################################
# Model spawning/rearing habitat based on gradient and channel width / discharge
# (plus create some QA tables, cartographic streams layer, run reports)
#################################

PARAMETERS_DIR="${1:-parameters}"

# load table that defines the parameters for spawning/rearing
psql -c "DROP TABLE IF EXISTS bcfishpass.param_habitat"
psql -c "CREATE TABLE bcfishpass.param_habitat (
  species_code text,
  spawn_gradient_max numeric,
  spawn_channel_width_min numeric,
  spawn_channel_width_max numeric,
  spawn_mad_min numeric,
  spawn_mad_max numeric,
  rear_gradient_max numeric,
  rear_channel_width_max numeric,
  rear_mad_min numeric,
  rear_mad_max numeric,
  rear_lake_ha_min integer,
  rear_wetland_multiplier numeric,
  rear_lake_multiplier numeric
)"
psql -c "\copy bcfishpass.param_habitat FROM '$PARAMETERS_DIR/param_habitat.csv' delimiter ',' csv header"

# load modelled (and measured) channel width to streams table
psql -f sql/load_channel_width.sql

# run ch/co/st spawning and rearing models
psql -f sql/model_habitat_spawning.sql
psql -f sql/model_habitat_rearing_1.sql  # ch/co/st rearing AND spawning streams (rearing with no connectivity analysis)
psql -f sql/model_habitat_rearing_2.sql  # ch/co/st rearing downstream of spawning
psql -f sql/model_habitat_rearing_3.sql  # ch/co/st rearing upstream of spawning

# sockeye have a different life cycle, run sockeye model separately (rearing and spawning)
psql -f sql/model_habitat_sockeye.sql


# Create generalized copy of streams for visualization
psql -f sql/carto.sql

# For qa, report on how much is upstream of various definite barriers and the anthropogenic barriers
python bcfishpass.py report bcfishpass.barriers_ditchflow barriers_ditchflow_id bcfishpass.barriers_ditchflow dnstr_barriers_ditchflow
python bcfishpass.py report bcfishpass.barriers_falls barriers_falls_id bcfishpass.barriers_falls dnstr_barriers_falls
python bcfishpass.py report bcfishpass.barriers_gradient_15 barriers_gradient_15_id bcfishpass.barriers_gradient_15 dnstr_barriers_gradient_15
python bcfishpass.py report bcfishpass.barriers_gradient_20 barriers_gradient_20_id bcfishpass.barriers_gradient_20 dnstr_barriers_gradient_20
python bcfishpass.py report bcfishpass.barriers_gradient_30 barriers_gradient_30_id bcfishpass.barriers_gradient_30 dnstr_barriers_gradient_30
python bcfishpass.py report bcfishpass.barriers_intermittentflow barriers_intermittentflow_id bcfishpass.barriers_intermittentflow dnstr_barriers_intermittentflow
python bcfishpass.py report bcfishpass.barriers_majordams barriers_majordams_id bcfishpass.barriers_majordams dnstr_barriers_majordams
python bcfishpass.py report bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id bcfishpass.barriers_subsurfaceflow dnstr_barriers_subsurfaceflow
python bcfishpass.py report bcfishpass.barriers_anthropogenic aggregated_crossings_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic

# and run the report
python bcfishpass.py report bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic

# document these two new columns in the crossings table
psql -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_crossings IS 'List of the aggregated_crossings_id values of crossings downstream of the given crossing, in order downstream';"
psql -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_barriers_anthropogenic IS 'List of the aggregated_crossings_id values of barrier crossings downstream of the given crossing, in order downstream';"

# also note the number of barriers downstream, just a count of values in dnstr_barriers_anthropogenic
psql -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS dnstr_barriers_anthropogenic_count integer"
psql -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_barriers_anthropogenic_count IS 'A count of the barrier crossings downstream of the given crossing';"
psql -c "UPDATE bcfishpass.crossings SET dnstr_barriers_anthropogenic_count = array_length(dnstr_barriers_anthropogenic, 1) WHERE dnstr_barriers_anthropogenic IS NOT NULL";

# populating the belowupstrbarriers for OBS in the crossings table requires a separate query
# (because the dnstr_barriers_anthropogenic is used in above report, and that misses the OBS of interest)
psql -f sql/00_report_crossings_obs_belowupstrbarriers.sql

# run report on the combined definite barrier tables
python bcfishpass.py report bcfishpass.definitebarriers_salmon definitebarriers_salmon_id bcfishpass.definitebarriers_salmon dnstr_definitebarriers_salmon_id
python bcfishpass.py report bcfishpass.definitebarriers_steelhead definitebarriers_steelhead_id bcfishpass.definitebarriers_steelhead dnstr_definitebarriers_steelhead_id
python bcfishpass.py report bcfishpass.definitebarriers_wct definitebarriers_wct_id bcfishpass.definitebarriers_wct dnstr_definitebarriers_wct_id

# call summary reports - just to be sure that they sync with any commits without having to remember to call it separately
cd ../04_reporting
./report.sh
cd ../02_model