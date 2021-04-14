#!/bin/bash
set -euxo pipefail

#################################
#### model spawning/rearing habitat based on gradient and modelled channel width or modelled discharge
#### Edit data/watershed_groups.csv to control which model gets run in a given watershed group
#################################

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
psql -c "\copy bcfishpass.param_habitat FROM 'data/model_spawning_rearing_habitat.csv' delimiter ',' csv header"

# load modelled (and measured) channel width to streams table
psql -f sql/load_channel_width.sql

# run ch/co/st spawning and rearing models
psql -f sql/model_habitat_spawning.sql
psql -f sql/model_habitat_rearing_1.sql  # ch/co/st rearing AND spawning streams (rearing with no connectivity analysis)
psql -f sql/model_habitat_rearing_2.sql  # ch/co/st rearing downstream of spawning
psql -f sql/model_habitat_rearing_3.sql  # ch/co/st rearing upstream of spawning

# sockeye have a different life cycle, run sockeye model separately (rearing and spawning)
psql -f sql/model_habitat_sockeye.sql
