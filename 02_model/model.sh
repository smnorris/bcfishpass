#!/bin/bash
set -euxo pipefail


# -----------
# Load required functions
# -----------
psql -f sql/utmzone.sql

# -----------
# Load data (QA/fixes/latest PSCIS)
# -----------
# - modelled crossings fixes
psql -c "DROP TABLE IF EXISTS bcfishpass.modelled_stream_crossings_fixes"
psql -c "CREATE TABLE bcfishpass.modelled_stream_crossings_fixes (modelled_crossing_id integer PRIMARY KEY, structure text, watershed_group_code text, reviewer text, notes text)"
psql -c "\copy bcfishpass.modelled_stream_crossings_fixes FROM '../01_prep/01_modelled_stream_crossings/data/modelled_stream_crossings_fixes.csv' delimiter ',' csv header"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings_fixes (modelled_crossing_id)"

# - load pscis / pscis fixes and re-run scripts matching PSCIS points to streams
cd ../01_prep/02_pscis
./load.sh
./pscis.sh
cd ../../02_model

# - and falls, misc
cd ../01_prep/05_falls
./falls.sh
cd ../06_misc
./misc.sh
cd ../../02_model


# -----------
# Run model
# -----------

# Which watershed groups to process and what type of habitat model to run is encoded in watershed_groups.csv
psql -c "DROP TABLE IF EXISTS bcfishpass.watershed_groups"
psql -c "CREATE TABLE bcfishpass.watershed_groups (watershed_group_code character varying(4), watershed_group_name text, include boolean, co boolean, ch boolean, sk boolean, st boolean, wct boolean, model text, notes text)"
psql -c "\copy bcfishpass.watershed_groups FROM 'data/watershed_groups.csv' delimiter ',' csv header"

# create table for each type of definite (not generally fixable) barrier
psql -f sql/barriers_majordams.sql
psql -f sql/barriers_ditchflow.sql
psql -f sql/barriers_falls.sql
psql -f sql/barriers_gradient_15.sql
psql -f sql/barriers_gradient_20.sql
psql -f sql/barriers_gradient_30.sql
psql -f sql/barriers_intermittentflow.sql
psql -f sql/barriers_subsurfaceflow.sql
psql -f sql/barriers_other_definite.sql

# merge these into single tables per species scenario
# create tables for cartographic use, merging barriers for specific scenarios into single tables
psql -f sql/definitebarriers.sql

# Create observations table with species of interest
psql -f sql/observations.sql

# note which have observations upstream
python bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_steelhead definitebarriers_steelhead_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
python bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_salmon definitebarriers_salmon_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
python bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_wct definitebarriers_wct_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id

# remove definite barriers below observations for WCT
# *TODO*
# this assumes there are ONLY WCT observations in WCT groups - currently true...
# but may not be in the future
psql -c "DELETE FROM bcfishpass.definitebarriers_wct WHERE upstr_observation_id IS NOT NULL"

# note minimal definite barriers
python bcfishpass.py add-downstream-ids \
  bcfishpass.definitebarriers_steelhead \
  definitebarriers_steelhead_id \
  bcfishpass.definitebarriers_steelhead \
  definitebarriers_steelhead_id \
  dnstr_definitebarriers_steelhead_id
python bcfishpass.py add-downstream-ids \
  bcfishpass.definitebarriers_salmon \
  definitebarriers_salmon_id \
  bcfishpass.definitebarriers_salmon \
  definitebarriers_salmon_id \
  dnstr_definitebarriers_salmon_id
python bcfishpass.py add-downstream-ids \
  bcfishpass.definitebarriers_wct \
  definitebarriers_wct_id \
  bcfishpass.definitebarriers_wct \
  definitebarriers_wct_id \
  dnstr_definitebarriers_wct_id

# delete non-minimal definite barriers
psql -c "DELETE FROM bcfishpass.definitebarriers_salmon WHERE dnstr_definitebarriers_salmon_id IS NOT NULL"
psql -c "DELETE FROM bcfishpass.definitebarriers_steelhead WHERE dnstr_definitebarriers_steelhead_id IS NOT NULL"
psql -c "DELETE FROM bcfishpass.definitebarriers_wct WHERE dnstr_definitebarriers_wct_id IS NOT NULL"

# consolidate all stream crossings into a single table
# (pscis crossings, modelled crossings, dams)
psql -f sql/crossings.sql

# from the crossings table, pull out crossings that are barriers / potential barriers
# (smaller dams / pscis crossings / modelled culverts / other)
# this query also creates a temp table holding only PSCIS barriers - just
# so we can visulize streams that are upstream of *confirmed* barriers
psql -f sql/barriers_anthropogenic.sql

# create a temp table holding all remediated PSCIS crossings so we can report on remediated streams
psql -f sql/remediated.sql

# Create output streams table
psql -f sql/streams.sql

# break streams at observations
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.observations

# break streams at barriers (that are not already at end of stream lines, ditchflow, intermittentflow, subsurfaceflow)
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.barriers_falls
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.barriers_gradient_15
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.barriers_gradient_20
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.barriers_gradient_30
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.barriers_majordams
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.barriers_other_definite

# break at all pscis crossings, modelled crossings, dams (including OBS and non barriers)
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.crossings

# break streams at all falls, not just those already identified as barriers
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.falls_events_sp

# add column tracking upstream observations
python bcfishpass.py add-upstream-ids bcfishpass.streams segmented_stream_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id

# add columns tracking downstream barriers
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_gradient_15 barriers_gradient_15_id dnstr_barriers_gradient_15 --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_gradient_20 barriers_gradient_20_id dnstr_barriers_gradient_20 --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_gradient_30 barriers_gradient_30_id dnstr_barriers_gradient_30 --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_ditchflow barriers_ditchflow_id dnstr_barriers_ditchflow --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_falls barriers_falls_id dnstr_barriers_falls --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_intermittentflow barriers_intermittentflow_id dnstr_barriers_intermittentflow --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_majordams barriers_majordams_id dnstr_barriers_majordams --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_other_definite barriers_other_definite_id dnstr_barriers_other_definite --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id dnstr_barriers_subsurfaceflow --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_anthropogenic aggregated_crossings_id dnstr_barriers_anthropogenic --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_pscis stream_crossing_id dnstr_barriers_pscis --include_equivalent_measure

# and a column for tracking downstream remediations
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.remediated aggregated_crossings_id dnstr_remediated --include_equivalent_measure

# for ELKR, use the combined definite barriers table for modelling
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.definitebarriers_wct definitebarriers_wct_id dnstr_barriers_wct --include_equivalent_measure

# drop the temp pscis barrier table to avoid confusion
psql -c "DROP TABLE IF EXISTS bcfishpass.barriers_pscis"

# classify streams per accessibility model based on the upstream / downstream features processed above
psql -f sql/model_access.sql

# classify streams per salmon habitat model
# load the habitat model lookup
psql -c "DROP TABLE IF EXISTS bcfishpass.model_spawning_rearing_habitat"
psql -c "CREATE TABLE bcfishpass.model_spawning_rearing_habitat (
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
psql -c "\copy bcfishpass.model_spawning_rearing_habitat FROM 'data/model_spawning_rearing_habitat.csv' delimiter ',' csv header"

# load channel width to streams
psql -f sql/model_channel_width.sql

# run spawning/rearing models
# Note that the different models feed into the same columns in the stream table (ie <spawn/rear>_model_<species>)
# Edit data/watershed_groups.csv to control which model gets run in a given watershed group

# run ch/co/st spawning and rearing models
psql -f sql/model_habitat_spawning.sql
psql -f sql/model_habitat_rearing_1.sql  # ch/co/st rearing AND spawning streams (rearing with no connectivity analysis)
psql -f sql/model_habitat_rearing_2.sql  # ch/co/st rearing downstream of spawning
psql -f sql/model_habitat_rearing_3.sql  # ch/co/st rearing upstream of spawning

# sockeye have a different life cycle, run sockeye model separately (rearing and spawning)
psql -f sql/model_habitat_sockeye.sql

# create generalized copy of streams for visualization
psql -f sql/carto.sql

# add downstream ids to barrier tables too - handy for reporting
python bcfishpass.py add-downstream-ids bcfishpass.barriers_falls barriers_falls_id bcfishpass.barriers_falls barriers_falls_id dnstr_barriers_falls
python bcfishpass.py add-downstream-ids bcfishpass.barriers_gradient_15 barriers_gradient_15_id bcfishpass.barriers_gradient_15 barriers_gradient_15_id dnstr_barriers_gradient_15
python bcfishpass.py add-downstream-ids bcfishpass.barriers_gradient_20 barriers_gradient_20_id bcfishpass.barriers_gradient_20 barriers_gradient_20_id dnstr_barriers_gradient_20
python bcfishpass.py add-downstream-ids bcfishpass.barriers_gradient_30 barriers_gradient_30_id bcfishpass.barriers_gradient_30 barriers_gradient_30_id dnstr_barriers_gradient_30
python bcfishpass.py add-downstream-ids bcfishpass.barriers_majordams barriers_majordams_id bcfishpass.barriers_majordams barriers_majordams_id dnstr_barriers_majordams
python bcfishpass.py add-downstream-ids bcfishpass.barriers_other_definite barriers_other_definite_id bcfishpass.barriers_other_definite barriers_other_definite_id dnstr_barriers_other_definite
python bcfishpass.py add-downstream-ids bcfishpass.barriers_intermittentflow barriers_intermittentflow_id bcfishpass.barriers_intermittentflow barriers_intermittentflow_id dnstr_barriers_intermittentflow
python bcfishpass.py add-downstream-ids bcfishpass.barriers_ditchflow barriers_ditchflow_id bcfishpass.barriers_ditchflow barriers_ditchflow_id dnstr_barriers_ditchflow
python bcfishpass.py add-downstream-ids bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id dnstr_barriers_subsurfaceflow
python bcfishpass.py add-downstream-ids bcfishpass.barriers_anthropogenic aggregated_crossings_id bcfishpass.barriers_anthropogenic aggregated_crossings_id dnstr_barriers_anthropogenic

# for qa, report on how much is upstream of various definite barriers and the anthropogenic barriers
python bcfishpass.py report bcfishpass.barriers_ditchflow barriers_ditchflow_id bcfishpass.barriers_ditchflow dnstr_barriers_ditchflow
python bcfishpass.py report bcfishpass.barriers_falls barriers_falls_id bcfishpass.barriers_falls dnstr_barriers_falls
python bcfishpass.py report bcfishpass.barriers_gradient_15 barriers_gradient_15_id bcfishpass.barriers_gradient_15 dnstr_barriers_gradient_15
python bcfishpass.py report bcfishpass.barriers_gradient_20 barriers_gradient_20_id bcfishpass.barriers_gradient_20 dnstr_barriers_gradient_20
python bcfishpass.py report bcfishpass.barriers_gradient_30 barriers_gradient_30_id bcfishpass.barriers_gradient_30 dnstr_barriers_gradient_30
python bcfishpass.py report bcfishpass.barriers_intermittentflow barriers_intermittentflow_id bcfishpass.barriers_intermittentflow dnstr_barriers_intermittentflow
python bcfishpass.py report bcfishpass.barriers_majordams barriers_majordams_id bcfishpass.barriers_majordams dnstr_barriers_majordams
python bcfishpass.py report bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id bcfishpass.barriers_subsurfaceflow dnstr_barriers_subsurfaceflow
python bcfishpass.py report bcfishpass.barriers_anthropogenic aggregated_crossings_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic

# and waterfalls that aren't considered in the model yet, just for evaluation
#python bcfishpass.py add-downstream-ids bcfishpass.falls_events_sp falls_event_id bcfishpass.falls_events_sp falls_event_id dnstr_falls
#python bcfishpass.py report bcfishpass.falls_events_sp falls_event_id bcfishpass.falls_events_sp dnstr_falls

# now process the crossings table
# For crossings,  index it based on the barriers table - we want the downstream ids to be barriers only
# (for reporting on belowupstrbarriers columns)
python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id dnstr_crossings
python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic aggregated_crossings_id dnstr_barriers_anthropogenic
# note barriers upstream
python bcfishpass.py add-upstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic aggregated_crossings_id upstr_barriers_anthropogenic
# and run the report
python bcfishpass.py report bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic

# document these two new columns in the crossings table
psql -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_crossings IS 'List of the aggregated_crossings_id values of crossings downstream of the given crossing, in order downstream';"
psql -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_barriers_anthropogenic IS 'List of the aggregated_crossings_id values of barrier crossings downstream of the given crossing, in order downstream';"

# also note the number of barriers downstream, just a count of values in dnstr_barriers_anthropogenic
psql -c "ALTER TABLE bcfishpass.crossings ADD COLUMN dnstr_barriers_anthropogenic_count integer"
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
