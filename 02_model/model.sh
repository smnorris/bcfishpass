#!/bin/bash
set -euxo pipefail

# First, ensure that the latest lookup data is used
# - modelled crossings fixes
psql -c "DROP TABLE IF EXISTS bcfishpass.modelled_stream_crossings_fixes"
psql -c "CREATE TABLE bcfishpass.modelled_stream_crossings_fixes (modelled_crossing_id integer, watershed_group_code text, reviewer text, structure text, notes text)"
psql -c "\copy bcfishpass.modelled_stream_crossings_fixes FROM '../01_prep/01_modelled_stream_crossings/data/modelled_stream_crossings_fixes.csv' delimiter ',' csv header"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings_fixes (modelled_crossing_id)"
# - load pscis fixes and re-run scripts matching PSCIS points to streams
cd ../01_prep/02_pscis
./pscis.sh
cd ../../02_model

# Now run model

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

# note which have observations upstream
python bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_steelhead definitebarriers_steelhead_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
python bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_salmon definitebarriers_salmon_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
python bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_wct definitebarriers_wct_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
# remove definite barriers in ELK that are below observations
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

# Create output streams table
psql -f sql/streams.sql

# Create observations table with species of interest
psql -f sql/observations.sql

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

# create a waterfalls table for evaluation, break streams at waterfalls
psql -f sql/waterfalls.sql
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.waterfalls

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
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id dnstr_barriers_anthropogenic --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_pscis stream_crossing_id dnstr_barriers_pscis --include_equivalent_measure

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
  rear_gradient_max numeric,
  rear_channel_width_max numeric,
  rear_lake_ha_min integer,
  rear_wetland_multiplier numeric,
  rear_lake_multiplier numeric
)"
psql -c "\copy bcfishpass.model_spawning_rearing_habitat FROM 'data/model_spawning_rearing_habitat.csv' delimiter ',' csv header"

# run the spawning/rearing habitat model
psql -f sql/model_habitat.sql

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
python bcfishpass.py add-downstream-ids bcfishpass.barriers_anthropogenic barriers_anthropogenic_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id dnstr_barriers_anthropogenic

# for qa, report on how much is upstream of various definite barriers and the anthropogenic barriers
python bcfishpass.py report bcfishpass.barriers_ditchflow barriers_ditchflow_id bcfishpass.barriers_ditchflow dnstr_barriers_ditchflow
python bcfishpass.py report bcfishpass.barriers_falls barriers_falls_id bcfishpass.barriers_falls dnstr_barriers_falls
python bcfishpass.py report bcfishpass.barriers_gradient_15 barriers_gradient_15_id bcfishpass.barriers_gradient_15 dnstr_barriers_gradient_15
python bcfishpass.py report bcfishpass.barriers_gradient_20 barriers_gradient_20_id bcfishpass.barriers_gradient_20 dnstr_barriers_gradient_20
python bcfishpass.py report bcfishpass.barriers_gradient_30 barriers_gradient_30_id bcfishpass.barriers_gradient_30 dnstr_barriers_gradient_30
python bcfishpass.py report bcfishpass.barriers_intermittentflow barriers_intermittentflow_id bcfishpass.barriers_intermittentflow dnstr_barriers_intermittentflow
python bcfishpass.py report bcfishpass.barriers_majordams barriers_majordams_id bcfishpass.barriers_majordams dnstr_barriers_majordams
python bcfishpass.py report bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id bcfishpass.barriers_subsurfaceflow dnstr_barriers_subsurfaceflow
python bcfishpass.py report bcfishpass.barriers_anthropogenic barriers_anthropogenic_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic

# and waterfalls that aren't considered in the model yet, just for evaluation
python bcfishpass.py add-downstream-ids bcfishpass.waterfalls falls_id bcfishpass.waterfalls falls_id dnstr_falls
python bcfishpass.py report bcfishpass.waterfalls falls_id bcfishpass.waterfalls dnstr_falls

# and also the crossings table
# but for crossings,  index it based on the barriers table - we want the downstream ids to be barriers only
# (for reporting on belowupstrbarriers columns)
python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id dnstr_crossings
python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id dnstr_barriers_anthropogenic
python bcfishpass.py report bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic

# populating the belowupstrbarriers for OBS in the crossings table requires a separate query
psql -f sql/00_report_crossings_obs_belowupstrbarriers.sql

# run report on the combined definite barrier tables
python bcfishpass.py report bcfishpass.definitebarriers_salmon definitebarriers_salmon_id bcfishpass.definitebarriers_salmon dnstr_definitebarriers_salmon_id
python bcfishpass.py report bcfishpass.definitebarriers_steelhead definitebarriers_steelhead_id bcfishpass.definitebarriers_steelhead dnstr_definitebarriers_steelhead_id
python bcfishpass.py report bcfishpass.definitebarriers_wct definitebarriers_wct_id bcfishpass.definitebarriers_wct dnstr_definitebarriers_wct_id