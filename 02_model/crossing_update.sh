#!/bin/bash
set -euxo pipefail

# Definite barriers rarely change but PSCIS and modelled crosings and their lookups get modifications often.
# To speed up iterative changes, use this script as a guide for quicker updates to outputs - it re-runs only
# required portions of the model for PSCIS changes and fixes/changes to these files:

#  - modelled_stream_crossins_fixes.csv
#  - pscis_modelledcrossings_streams_xref.csv
#  - pscis_barrier_result_fixes.csv


# reload modelled crossing QA
psql -c "DROP TABLE IF EXISTS bcfishpass.modelled_stream_crossings_fixes"
psql -c "CREATE TABLE bcfishpass.modelled_stream_crossings_fixes (modelled_crossing_id integer, watershed_group_code text, reviewer text, structure text, notes text)"
psql -c "\copy bcfishpass.modelled_stream_crossings_fixes FROM '../01_prep/01_modelled_stream_crossings/data/modelled_stream_crossings_fixes.csv' delimiter ',' csv header"
psql -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings_fixes (modelled_crossing_id)"

# re-run PSCIS scripts (don't bother re-downloading data)
cd ../01_prep/02_pscis
./pscis.sh
cd ../../02_model

# re-create crossings table, anth barriers table
psql -f sql/crossings.sql
psql -f sql/barriers_anthropogenic.sql

# probably not necessary, but just in case there are fresh pscis crossings
python bcfishpass.py segment-streams bcfishpass.streams bcfishpass.crossings

# re-code the streams
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id dnstr_barriers_anthropogenic --include_equivalent_measure
python bcfishpass.py add-downstream-ids bcfishpass.streams segmented_stream_id bcfishpass.barriers_pscis stream_crossing_id dnstr_barriers_pscis --include_equivalent_measure

# re-run model classification
psql -f sql/model.sql


# ----------
# everything below this has to be run before publication but is not necessary for iterative QA of model output
# ----------
python bcfishpass.py add-downstream-ids bcfishpass.barriers_anthropogenic barriers_anthropogenic_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id dnstr_barriers_anthropogenic
python bcfishpass.py report bcfishpass.barriers_ditchflow barriers_ditchflow_id bcfishpass.barriers_ditchflow dnstr_barriers_ditchflow
python bcfishpass.py report bcfishpass.barriers_falls barriers_falls_id bcfishpass.barriers_falls dnstr_barriers_falls
python bcfishpass.py report bcfishpass.barriers_gradient_15 barriers_gradient_15_id bcfishpass.barriers_gradient_15 dnstr_barriers_gradient_15
python bcfishpass.py report bcfishpass.barriers_gradient_20 barriers_gradient_20_id bcfishpass.barriers_gradient_20 dnstr_barriers_gradient_20
python bcfishpass.py report bcfishpass.barriers_gradient_30 barriers_gradient_30_id bcfishpass.barriers_gradient_30 dnstr_barriers_gradient_30
python bcfishpass.py report bcfishpass.barriers_intermittentflow barriers_intermittentflow_id bcfishpass.barriers_intermittentflow dnstr_barriers_intermittentflow
python bcfishpass.py report bcfishpass.barriers_majordams barriers_majordams_id bcfishpass.barriers_majordams dnstr_barriers_majordams
python bcfishpass.py report bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id bcfishpass.barriers_subsurfaceflow dnstr_barriers_subsurfaceflow
python bcfishpass.py report bcfishpass.barriers_anthropogenic barriers_anthropogenic_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic
python bcfishpass.py report bcfishpass.waterfalls falls_id bcfishpass.waterfalls dnstr_falls
python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id dnstr_crossings
python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id dnstr_barriers_anthropogenic
python bcfishpass.py report bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic
psql -f sql/00_report_crossings_obs_belowupstrbarriers.sql
python bcfishpass.py report bcfishpass.definitebarriers_salmon definitebarriers_salmon_id bcfishpass.definitebarriers_salmon dnstr_definitebarriers_salmon_id
python bcfishpass.py report bcfishpass.definitebarriers_steelhead definitebarriers_steelhead_id bcfishpass.definitebarriers_steelhead dnstr_definitebarriers_steelhead_id
python bcfishpass.py report bcfishpass.definitebarriers_wct definitebarriers_wct_id bcfishpass.definitebarriers_wct dnstr_definitebarriers_wct_id