.PHONY: all clean settings

PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
DATA_FILES=$(wildcard data/*.csv)                         # find all user input data in .csv files
DATA_FILE_TARGETS=$(patsubst data/%.csv,.%,$(DATA_FILES)) # parse csv file names into .hidden make targets

# specify all make targets
GENERATED_FILES=.fwapg .bcfishobs .ddl \
	$(DATA_FILE_TARGETS) \
	.falls .dams .gradient_barriers .modelled_stream_crossings .pscis .crossings \
	.manual_habitat_classification_endpoints .segmented_streams \
	.barriers_majordams .barriers_fwa .barriers_falls .barriers_gradient .barriers_other .barriers_anthropogenic \
	.observations .break_streams .model_access
#.channel_width .discharge .model_habitat .views .reports

GROUPS = $(shell $(PSQL_CMD) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")

# Make all targets
all: $(GENERATED_FILES)

# Remove all generated targets
clean:
	rm -Rf fwapg
	rm -Rf bcfishobs
	cd scripts/modelled_stream_crossings; make clean
	rm -Rf $(GENERATED_FILES)


# *********************************************************
# **                                                     **
# ** LOAD DATA FROM OTHER REPOSITORIES (fwapg/bcfishobs) **
# **                                                     **
# *********************************************************
fwapg:
	git clone https://github.com/smnorris/fwapg.git

.fwapg: fwapg
	cd fwapg; make
	touch $@

bcfishobs: .fwapg
	git clone https://github.com/smnorris/bcfishobs.git

.bcfishobs: bcfishobs
	cd bcfishobs; make
	touch $@


# ***********************************************
# **                                           **
# **      LOAD/PROCESS REQUIRED DATASETS       **
# **                                           **
# ***********************************************

# ------
# CREATE DATABASE STRUCTURE
# ------
.ddl: scripts/db/sql/user_data.sql scripts/db/sql/utmzone.sql
	$(PSQL_CMD) -c "CREATE SCHEMA IF NOT EXISTS bcfishpass"
	$(PSQL_CMD) -f scripts/db/sql/user_data.sql
	$(PSQL_CMD) -f scripts/db/sql/utmzone.sql
	touch $@

# ------
# LOAD USER EDITABLE DATA FILES (all csv files in /data folder)
# ------
$(DATA_FILE_TARGETS): $(DATA_FILES) .ddl
	$(PSQL_CMD) -c "DELETE FROM bcfishpass$@;"
	$(PSQL_CMD) -c "\copy bcfishpass$@ FROM 'data/$(subst .,,$@).csv' delimiter ',' csv header"
	touch $@

# ------
# LOAD PARAMETERS
# ------
.parameters: parameters/watersheds.csv parameters/habitat.csv .ddl
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.param_watersheds;"
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.param_habitat;"
	$(PSQL_CMD) -c "\copy bcfishpass.param_watersheds FROM 'parameters/watersheds.csv' delimiter ',' csv header"
	$(PSQL_CMD) -c "\copy bcfishpass.param_habitat FROM 'parameters/habitat.csv' delimiter ',' csv header"
	touch $@

# ------
# FALLS
# ------
# This relatively small table can get regenerated any time source csvs have changed,
# the csv allows for adding features and it is convenient to have barrier status in the
# source falls table
.falls: .fwapg $(wildcard $(DATAPATH)/falls/*.csv) scripts/falls/falls.sh scripts/falls/sql/falls.sql
	cd scripts/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# ------
# DAMS
# ------
# Dams are simple - no lookups required - but note that this table is a source for definite
# barriers *and* anthropogenic barriers. Delete the .dams target file if an update is required.
# (todo - consider consolidating CWF dams.geojson into the bcfishpass data folder so updates
# are easily picked up)
.dams: .fwapg scripts/dams/dams.sh scripts/dams/sql/dams.sql
	cd scripts/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# ------
# GRADIENT BARRIERS
# ------
# Generate all gradient barriers at 5/10/15/20/25/30% thresholds.
# Todo - consider including only watershed groups listed in parameters
.gradient_barriers: .fwapg scripts/gradient_barriers/gradient_barriers.sh scripts/gradient_barriers/sql/gradient_barriers.sql
	cd scripts/modelled_stream_crossings; make
	touch $@

# ------
# MODELLED STREAM CROSSINGS
# ------
# Create intersection points of road/railroads and streams, the post-process to ensure
# unique crossings
.modelled_stream_crossings: .fwapg scripts/modelled_stream_crossings/Makefile $(wildcard scripts/modelled_stream_crossings/sql/*.sql)
	cd scripts/modelled_stream_crossings; make
	touch $@

# ------
# PSCIS
# ------
# PSCIS processing depends on modelled stream crosssings output being present
.pscis: .fwapg .modelled_stream_crossings scripts/pscis/pscis.sh $(wildcard scripts/pscis/sql/*.sql)
	cd scripts/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# -----
# CROSSINGS
# consolidate all dams/pscis/modelled crossings/misc anthropogenic barriers into one table
# TODO - could this be a view? It only taks ~4min to generate so probably not important.
# -----
.crossings: .pscis .modelled_stream_crossings .dams .misc_barriers_anthropogenic scripts/model/sql/crossings.sql
	$(PSQL_CMD) -f scripts/model/sql/$(subst .,,$@).sql
	touch $@

# -----
# MANUAL HABITAT CLASSIFICATION ENDPOINTS
# spawning/rearing habitat can be identified via this user table,
# but we generate endpoints from lines for stream splitting
# -----
.manual_habitat_classification_endpoints: .manual_habitat_classification scripts/model/sql/manual_habitat_classification_endpoints.sql
	$(PSQL_CMD) -f scripts/model/sql/$(subst .,,$@).sql
	touch $@

# ***********************************************
# **                                           **
# **      CREATE/UPDATE ACCESS MODEL           **
# **                                           **
# ***********************************************

# above data sources are all compiled provincially
# below jobs/extracts are run for watersheds specified in parameters only

# -----
# INITIAL STREAM DATA LOAD
# -----
# what streams get loaded depends on wsg listed in parameters
.segmented_streams: .parameters scripts/db/sql/segmented_streams.sql
	# create empty table
	$(PSQL_CMD) -f scripts/db/sql/$(subst .,,$@).sql
	# load in parallel (doing the entire load as a single insert is extremely slow for large study areas)
	parallel $(PSQL_CMD) -f scripts/db/sql/load_segmented_streams.sql -v wsg={1} ::: $(GROUPS)
	# index
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.segmented_streams (linear_feature_id); \
		CREATE INDEX ON bcfishpass.segmented_streams (blue_line_key); \
		CREATE INDEX ON bcfishpass.segmented_streams (watershed_group_code); \
		CREATE INDEX ON bcfishpass.segmented_streams (waterbody_key); \
		CREATE INDEX ON bcfishpass.segmented_streams USING GIST (wscode_ltree); \
		CREATE INDEX ON bcfishpass.segmented_streams USING BTREE (wscode_ltree); \
		CREATE INDEX ON bcfishpass.segmented_streams USING GIST (localcode_ltree); \
		CREATE INDEX ON bcfishpass.segmented_streams USING BTREE (localcode_ltree); \
		CREATE INDEX ON bcfishpass.segmented_streams USING GIST (geom);"
	touch $@

# -----
# BARRIER TABLES
# create table for each type of definite (not generally fixable) barrier,
# plus potential/assessed barriers from crossings table
# -----
.barriers_majordams: .dams .parameters scripts/model/sql/barriers_majordams.sql
	$(PSQL_CMD) -f scripts/model/sql/$(subst .,,$@).sql
	touch $@
.barriers_fwa: .parameters scripts/model/sql/barriers_ditchflow.sql scripts/model/sql/barriers_intermittentflow.sql scripts/model/sql/barriers_subsurfaceflow.sql
	$(PSQL_CMD) -f scripts/model/sql/barriers_ditchflow.sql
	$(PSQL_CMD) -f scripts/model/sql/barriers_intermittentflow.sql
	$(PSQL_CMD) -f scripts/model/sql/barriers_subsurfaceflow.sql
	touch $@
.barriers_falls: .falls .parameters scripts/model/sql/barriers_falls.sql
	$(PSQL_CMD) -f scripts/model/sql/$(subst .,,$@).sql
	touch $@
.barriers_gradient: .gradient_barriers .parameters scripts/model/sql/barriers_gradient_15.sql scripts/model/sql/barriers_gradient_20.sql scripts/model/sql/barriers_gradient_30.sql
	$(PSQL_CMD) -f scripts/model/sql/barriers_gradient_15.sql
	$(PSQL_CMD) -f scripts/model/sql/barriers_gradient_20.sql
	$(PSQL_CMD) -f scripts/model/sql/barriers_gradient_30.sql
	touch $@
.barriers_other: .exclusions .misc_barriers_definite .pscis_barrier_result_fixes .parameters scripts/model/sql/barriers_other_definite.sql
	$(PSQL_CMD) -f scripts/model/sql/barriers_other_definite.sql
	touch $@
.barriers_anthropogenic: .crossings scripts/model/sql/barriers_anthropogenic.sql scripts/model/sql/barriers_pscis.sql scripts/model/sql/remediated.sql
	# barriers/potential barriers subset of crossings table
	$(PSQL_CMD) -f scripts/model/sql/$(subst .,,$@).sql
	# pscis subsets for visualization
	$(PSQL_CMD) -f scripts/model/sql/barriers_pscis.sql
	$(PSQL_CMD) -f scripts/model/sql/remediated.sql

	# index barriers_anthropogenic and crossings based on upstream/downstream crossings
	python bcfishpass.py add-downstream-ids bcfishpass.barriers_anthropogenic aggregated_crossings_id bcfishpass.barriers_anthropogenic aggregated_crossings_id dnstr_barriers_anthropogenic
	python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id dnstr_crossings
	python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic aggregated_crossings_id dnstr_barriers_anthropogenic
	python bcfishpass.py add-upstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic aggregated_crossings_id upstr_barriers_anthropogenic

	# document these new columns in the crossings table
	$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_crossings IS 'List of the aggregated_crossings_id values of crossings downstream of the given crossing, in order downstream';"
	$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_barriers_anthropogenic IS 'List of the aggregated_crossings_id values of barrier crossings downstream of the given crossing, in order downstream';"
	$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.upstr_barriers_anthropogenic IS 'List of the aggregated_crossings_id values of barrier crossings upstream of the given crossing';"
	$(PSQL_CMD) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS dnstr_barriers_anthropogenic_count integer"
	$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_barriers_anthropogenic_count IS 'A count of the barrier crossings downstream of the given crossing';"
	$(PSQL_CMD) -c "UPDATE bcfishpass.crossings SET dnstr_barriers_anthropogenic_count = array_length(dnstr_barriers_anthropogenic, 1) WHERE dnstr_barriers_anthropogenic IS NOT NULL";
	touch $@

# ------
# OBSERVATIONS
# ------
# extract FISS observations for species of interest from bcfishobs
.observations: .fwapg .bcfishobs .parameters scripts/model/sql/observations.sql
	$(PSQL_CMD) -f scripts/model/sql/$(subst .,,$@).sql
	touch $@

# -----
# BREAK STREAMS
# -----
# merge all point features into a single view and break streams at intersections
# note that this will only pick up breakpoints that are 1m from existing breaks in the streams,
# re-runs with minor updates will be very quick
.break_streams: .segmented_streams .observations .barriers_majordams .barriers_falls .barriers_gradient .barriers_other .crossings .manual_habitat_classification_endpoints scripts/model/sql/breakpoints.sql scripts/model/sql/00_segment_streams.sql
	$(PSQL_CMD) -f scripts/model/sql/breakpoints.sql
	parallel $(PSQL_CMD) -f scripts/model/sql/00_segment_streams.sql -v wsg={1} ::: $(GROUPS)
	touch $@

# -----
# RUN ACCESS MODEL
# -----
# add column to various tables indexing relative position of features
# TODO - this is relatively slow. There should be a decent way to either:
#     - create views holding required columns directly
#     - run the add-up/downstream-ids script for first pass (it isn't that slow),
#       but only applying updates where new features are added
.model_access: .break_streams scripts/model/sql/model_access.sql
	cd scripts/model_access ; python bcfishpass.py add-upstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_gradient_15 barriers_gradient_15_id dnstr_barriers_gradient_15 --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_gradient_20 barriers_gradient_20_id dnstr_barriers_gradient_20 --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_gradient_30 barriers_gradient_30_id dnstr_barriers_gradient_30 --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_ditchflow barriers_ditchflow_id dnstr_barriers_ditchflow --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_falls barriers_falls_id dnstr_barriers_falls --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_intermittentflow barriers_intermittentflow_id dnstr_barriers_intermittentflow --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_majordams barriers_majordams_id dnstr_barriers_majordams --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_other_definite barriers_other_definite_id dnstr_barriers_other_definite --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id dnstr_barriers_subsurfaceflow --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_anthropogenic aggregated_crossings_id dnstr_barriers_anthropogenic --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.barriers_pscis stream_crossing_id dnstr_barriers_pscis --include_equivalent_measure
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids bcfishpass.segmented_streams segmented_stream_id bcfishpass.remediated aggregated_crossings_id dnstr_remediated --include_equivalent_measure
	$(PSQL_CMD) -f scripts/model/sql/model_access.sql
	touch $@


# ***********************************************
# **                                           **
# **      CREATE/UPDATE HABITAT MODEL          **
# **                                           **
# ***********************************************

# -----
# MODEL CHANNEL WIDTH
# -----
# todo - create makefile for cw model
.channel_width: .fwapg
	cd scripts/channel_width; ./mean_annual_precip.sh
	cd scripts/channel_width; ./channel_width.sh
	touch $@

# -----
# MODEL DISCHARGE
# -----
.discharge: .fwapg
	cd scripts/discharge; make
	touch $@

# -----
# RUN HABITAT MODEL
# -----
.model_habitat: .model_access
	# load cw/discharge directly into the streams table
	$(PSQL_CMD) -f scripts/model/load_channel_width.sql
	$(PSQL_CMD) -f scripts/model/load_discharge.sql

	# spawning model is relatively simple, run in a single query
	$(PSQL_CMD) -f scripts/model/model_habitat_spawning.sql

	# Rearing requires several queries for CO/CH/WCT
	$(PSQL_CMD) -f scripts/model/model_habitat_rearing_1.sql # find all potential rearing streams
	time $(PSQL_CMD) -t -P border=0,footer=no \    # find subset of rearing that is downstream of spawning
	-c "SELECT watershed_group_code FROM bcfishpass.param_watersheds ORDER BY watershed_group_code" \
	    | parallel $(PSQL_CMD) -f scripts/model/model_habitat_rearing_2.sql -v wsg={1}
	$(PSQL_CMD) -f scripts/model/model_habitat_rearing_3.sql # find subset of rearing that is upstream of spawning

	# And a separate rearing query for SK because of different life cycle (lake requirement)
	$(PSQL_CMD) -f scripts/model/model_habitat_sockeye.sql

	# override the model where specified by manual_habitat_classification
	$(PSQL_CMD) -f scripts/model/manual_habitat_classification.sql
	touch $@


# -----
# VARIOUS VIEWS FOR VIZ
# -----
# todo - currently tables but could likely be views
.views: .model_habitat
	$(PSQL_CMD) -f scripts/model/sql/definitebarriers.sql
	cd scripts/model_access ; bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_steelhead definitebarriers_steelhead_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
	cd scripts/model_access ; bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_salmon definitebarriers_salmon_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
	cd scripts/model_access ; bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_wct definitebarriers_wct_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id

	# remove definite barriers below WCT observations
	# TODO - this should be done for any resident spp being modelled
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.definitebarriers_wct WHERE upstr_observation_id IS NOT NULL AND barrier_type NOT IN ('EXCLUSION')"

	# note minimal definite barriers
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids \
	  bcfishpass.definitebarriers_steelhead \
	  definitebarriers_steelhead_id \
	  bcfishpass.definitebarriers_steelhead \
	  definitebarriers_steelhead_id \
	  dnstr_definitebarriers_steelhead_id
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids \
	  bcfishpass.definitebarriers_salmon \
	  definitebarriers_salmon_id \
	  bcfishpass.definitebarriers_salmon \
	  definitebarriers_salmon_id \
	  dnstr_definitebarriers_salmon_id
	cd scripts/model_access ; python bcfishpass.py add-downstream-ids \
	  bcfishpass.definitebarriers_wct \
	  definitebarriers_wct_id \
	  bcfishpass.definitebarriers_wct \
	  definitebarriers_wct_id \
	  dnstr_definitebarriers_wct_id

	# delete non-minimal definite barriers
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.definitebarriers_salmon WHERE dnstr_definitebarriers_salmon_id IS NOT NULL"
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.definitebarriers_steelhead WHERE dnstr_definitebarriers_steelhead_id IS NOT NULL"
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.definitebarriers_wct WHERE dnstr_definitebarriers_wct_id IS NOT NULL"

	# run report on the combined definite barrier tables
	python bcfishpass.py report bcfishpass.definitebarriers_salmon definitebarriers_salmon_id bcfishpass.definitebarriers_salmon dnstr_definitebarriers_salmon_id
	python bcfishpass.py report bcfishpass.definitebarriers_steelhead definitebarriers_steelhead_id bcfishpass.definitebarriers_steelhead dnstr_definitebarriers_steelhead_id
	python bcfishpass.py report bcfishpass.definitebarriers_wct definitebarriers_wct_id bcfishpass.definitebarriers_wct dnstr_definitebarriers_wct_id

	# generalized streams
	$(PSQL_CMD) -f scripts/db/sql/carto.sql

	touch $@

# -----
# REPORT - ADD VARIOUS UPSTR/DNSTR SUMMARY COLUMNS, CREATE SUMMARY REPORTS
# -----
.reports: .model_habitat
	# For qa, report on how much is upstream of various definite barriers
	python bcfishpass.py report bcfishpass.barriers_ditchflow barriers_ditchflow_id bcfishpass.barriers_ditchflow dnstr_barriers_ditchflow
	python bcfishpass.py report bcfishpass.barriers_falls barriers_falls_id bcfishpass.barriers_falls dnstr_barriers_falls
	python bcfishpass.py report bcfishpass.barriers_gradient_15 barriers_gradient_15_id bcfishpass.barriers_gradient_15 dnstr_barriers_gradient_15
	python bcfishpass.py report bcfishpass.barriers_gradient_20 barriers_gradient_20_id bcfishpass.barriers_gradient_20 dnstr_barriers_gradient_20
	python bcfishpass.py report bcfishpass.barriers_gradient_30 barriers_gradient_30_id bcfishpass.barriers_gradient_30 dnstr_barriers_gradient_30
	python bcfishpass.py report bcfishpass.barriers_intermittentflow barriers_intermittentflow_id bcfishpass.barriers_intermittentflow dnstr_barriers_intermittentflow
	python bcfishpass.py report bcfishpass.barriers_majordams barriers_majordams_id bcfishpass.barriers_majordams dnstr_barriers_majordams
	python bcfishpass.py report bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id bcfishpass.barriers_subsurfaceflow dnstr_barriers_subsurfaceflow

	# and run the report (requires processing both tables)
	python bcfishpass.py report bcfishpass.barriers_anthropogenic aggregated_crossings_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic
	python bcfishpass.py report bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic

	# add habitat per barrier column to crossings table
	# this could potentially be included in the report.sql and added to all barrier tables, but it is only required for the
	psql -f sql/all_spawningrearing_per_barrier.sql

	# populating the belowupstrbarriers for OBS in the crossings table requires a separate query
	# (because the dnstr_barriers_anthropogenic is used in above report, and that misses the OBS of interest)
	psql -f sql/00_report_crossings_obs_belowupstrbarriers.sql

	touch $@