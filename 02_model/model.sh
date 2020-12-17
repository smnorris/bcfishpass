#!/bin/bash
set -euxo pipefail


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

# drop the temp pscis barrier table to avoid confusion
psql -c "DROP TABLE IF EXISTS bcfishpass.barriers_pscis"

# classify streams per accessibility model based on the upstream / downstream features processed above
psql -f sql/model.sql

# add downstream ids to barrier tables too - handy for reporting
python bcfishpass.py add-downstream-ids bcfishpass.barriers_falls barriers_falls_id bcfishpass.barriers_falls barriers_falls_id dnstr_barriers_falls_id
python bcfishpass.py add-downstream-ids bcfishpass.barriers_gradient_15 barriers_gradient_15_id bcfishpass.barriers_gradient_15 barriers_gradient_15_id dnstr_barriers_gradient_15_id
python bcfishpass.py add-downstream-ids bcfishpass.barriers_gradient_20 barriers_gradient_20_id bcfishpass.barriers_gradient_20 barriers_gradient_20_id dnstr_barriers_gradient_20_id
python bcfishpass.py add-downstream-ids bcfishpass.barriers_gradient_30 barriers_gradient_30_id bcfishpass.barriers_gradient_30 barriers_gradient_30_id dnstr_barriers_gradient_30_id
python bcfishpass.py add-downstream-ids bcfishpass.barriers_majordams barriers_majordams_id bcfishpass.barriers_majordams barriers_majordams_id dnstr_barriers_majordams_id
python bcfishpass.py add-downstream-ids bcfishpass.barriers_other_definite barriers_other_definite_id bcfishpass.barriers_other_definite barriers_other_definite_id dnstr_barriers_other_definite_id
python bcfishpass.py add-downstream-ids bcfishpass.barriers_intermittentflow barriers_intermittentflow_id bcfishpass.barriers_intermittentflow barriers_intermittentflow_id dnstr_barriers_intermittentflow_id
python bcfishpass.py add-downstream-ids bcfishpass.barriers_ditchflow barriers_ditchflow_id bcfishpass.barriers_ditchflow barriers_ditchflow_id dnstr_barriers_ditchflow_id
python bcfishpass.py add-downstream-ids bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id dnstr_barriers_subsurfaceflow_id
python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id dnstr_aggregated_crossing_id
python bcfishpass.py add-downstream-ids bcfishpass.barriers_anthropogenic barriers_anthropogenic_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id dnstr_barriers_anthropogenic_id

# for qa, report on how much is upstream of various definite barriers
python bcfishpass.py report bcfishpass.barriers_ditchflow barriers_ditchflow_id
python bcfishpass.py report bcfishpass.barriers_falls barriers_falls_id
python bcfishpass.py report bcfishpass.barriers_gradient_15 barriers_gradient_15_id
python bcfishpass.py report bcfishpass.barriers_gradient_20 barriers_gradient_20_id
python bcfishpass.py report bcfishpass.barriers_gradient_30 barriers_gradient_30_id
python bcfishpass.py report bcfishpass.barriers_intermittentflow barriers_intermittentflow_id
python bcfishpass.py report bcfishpass.barriers_majordams barriers_majordams_id
python bcfishpass.py report bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id

# and waterfalls
python bcfishpass.py add-downstream-ids bcfishpass.waterfalls falls_id bcfishpass.waterfalls falls_id dnstr_falls_id
python bcfishpass.py report bcfishpass.waterfalls falls_id

# and the crossings table
python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id dnstr_aggregated_crossings_id
python bcfishpass.py report bcfishpass.crossings aggregated_crossings_id

# create tables for cartographic use, merging barriers for specific scenarios into single tables
psql -f sql/carto.sql

# index these tables
python bcfishpass.py add-downstream-ids \
  bcfishpass.carto_barriers_definite_steelhead \
  carto_barriers_definite_steelhead_id \
  bcfishpass.carto_barriers_definite_steelhead \
  carto_barriers_definite_steelhead_id \
  dnstr_carto_barriers_definite_steelhead_id
python bcfishpass.py add-downstream-ids \
  bcfishpass.carto_barriers_definite_wct \
  carto_barriers_definite_wct_id \
  bcfishpass.carto_barriers_definite_wct \
  carto_barriers_definite_wct_id \
  dnstr_carto_barriers_definite_wct_id
python bcfishpass.py add-downstream-ids \
  bcfishpass.carto_barriers_definite_salmon \
  carto_barriers_definite_salmon_id \
  bcfishpass.carto_barriers_definite_salmon \
  carto_barriers_definite_salmon_id \
  dnstr_carto_barriers_definite_salmon_id

# delete non-minimal points
psql -c "DELETE FROM bcfishpass.carto_barriers_definite_salmon WHERE dnstr_carto_barriers_definite_salmon_id IS NOT NULL"
psql -c "DELETE FROM bcfishpass.carto_barriers_definite_steelhead WHERE dnstr_carto_barriers_definite_steelhead_id IS NOT NULL"
psql -c "DELETE FROM bcfishpass.carto_barriers_definite_wct WHERE dnstr_carto_barriers_definite_wct_id IS NOT NULL"

# run report on the carto tables
python bcfishpass.py report bcfishpass.carto_barriers_definite_steelhead carto_barriers_definite_steelhead_id
python bcfishpass.py report bcfishpass.carto_barriers_definite_salmon carto_barriers_definite_salmon_id
python bcfishpass.py report bcfishpass.carto_barriers_definite_wct carto_barriers_definite_wct_id