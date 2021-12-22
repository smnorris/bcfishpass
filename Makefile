.PHONY: all settings #clean clean_sources

PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
GROUPS_PARAM = $(shell $(PSQL_CMD) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")
GROUPS_REFRESH = $(shell cat .barriers_* .observations | sort | uniq)
GENERATED_FILES=.fwapg .bcfishobs .schema \
	.falls .dams .pscis_load .crossings .manual_habitat_classification_endpoints \
	.segmented_streams .observations .observations_upstr .break_streams .model_access

BARRIERS = $(patsubst scripts/model/sql/barriers_%.sql, %, $(wildcard scripts/model/sql/barriers_*.sql))

# Make all targets - just point to final target to make everything
all: .model_access

settings:
	echo BARRIERS: $(BARRIERS)

# Remove make targets not in root folder
clean_sources:
	rm -Rf fwapg
	rm -Rf bcfishobs
	cd scripts/modelled_stream_crossings; make clean

# Remove model make targets
clean:
	rm -Rf $(GENERATED_FILES)
	rm -Rf $(wildcard .barriers_*)
	rm -Rf $(wildcard .dnstr_barriers_*_vw)
	rm -Rf $(patsubst data/%.csv,.%,$(wildcard data/*csv))


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
# CREATE REQUIRED FUNCTIONS AND (EMPTY) TABLES
# ------
.schema: $(wildcard scripts/model/sql/tables/*sql) $(wildcard scripts/model/sql/functions/*sql)
	$(PSQL_CMD) -c "CREATE SCHEMA IF NOT EXISTS bcfishpass"
	$(PSQL_CMD) -f scripts/model/sql/functions/create_barrier_table.sql
	$(PSQL_CMD) -f scripts/model/sql/functions/refresh_barriers.sql
	$(PSQL_CMD) -f scripts/model/sql/functions/refresh_barriers_dnstr.sql
	$(PSQL_CMD) -f scripts/model/sql/functions/utmzone.sql
	$(PSQL_CMD) -f scripts/model/sql/functions/wsg_to_refresh.sql
	$(PSQL_CMD) -f scripts/model/sql/tables/access.sql
	$(PSQL_CMD) -f scripts/model/sql/tables/parameters.sql
	$(PSQL_CMD) -f scripts/model/sql/tables/user.sql
	touch $@

# ------
# LOAD USER EDITABLE DATA FILES (all csv files in /data folder)
# ------
.%: data/%.csv .schema
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.$(patsubst data/%.csv, %, $<)"
	$(PSQL_CMD) -c "\copy bcfishpass$@ FROM '$<' delimiter ',' csv header"
	touch $@

# ------
# LOAD PARAMETERS
# ------
.param_%: parameters/%.csv .schema
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.$(patsubst parameters/%.csv, param_%, $<)"
	$(PSQL_CMD) -c "\copy bcfishpass.$(patsubst parameters/%.csv, param_%, $<) FROM '$<' delimiter ',' csv header"
	touch $@

# ------
# FALLS
# ------
# This relatively small table can get regenerated any time source csvs have changed,
# the csv allows for adding features and it is convenient to have barrier status in the
# source falls table
.barriersource_falls: .fwapg .falls_barrier_ind .falls_other scripts/falls/falls.sh scripts/falls/sql/falls.sql .schema
	cd scripts/falls; ./falls.sh
	touch $@

# ------
# DAMS
# ------
# Dams are simple - no lookups required - but note that this table is a source for definite
# barriers *and* anthropogenic barriers. Delete the .dams target file if an update is required.
# (todo - consider consolidating CWF dams.geojson into the bcfishpass data folder so updates
# are easily picked up)
.barriersource_majordams: .fwapg scripts/dams/dams.sh scripts/dams/sql/dams.sql .schema
	cd scripts/dams; ./dams.sh
	touch $@

# ------
# GRADIENT BARRIERS
# ------
# Generate all gradient barriers at 5/10/15/20/25/30% thresholds.
# Todo - consider including only watershed groups listed in parameters
scripts/gradient_barriers/.gradient_barriers: .fwapg .schema
	cd scripts/gradient_barriers; make

# ------
# MODELLED STREAM CROSSINGS
# ------
# Create intersection points of road/railroads and streams, the post-process to ensure
# unique crossings
scripts/modelled_stream_crossings/.modelled_stream_crossings: .fwapg .schema
	cd scripts/modelled_stream_crossings; make
	touch $@

# ------
# PSCIS
# ------
# PSCIS processing depends on modelled stream crosssings output being present
.pscis_load: scripts/modelled_stream_crossings/.modelled_stream_crossings
	cd scripts/pscis; ./pscis.sh
	touch $@

# -----
# CROSSINGS
# consolidate all dams/pscis/modelled crossings/misc anthropogenic barriers into one table
# -----
.crossings: scripts/model/sql/load_crossings.sql .pscis_load .barriersource_majordams .misc_barriers_anthropogenic .modelled_stream_crossings_fixes
	$(PSQL_CMD) -f $<
	touch $@
	# also touch additional targets for barrier/remediated tables that come directly from crossings table
	touch .barriersource_anthropogenic
	touch .barriersource_pscis
	touch .barriersource_remediated

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
.segmented_streams: .param_watersheds .fwapg scripts/model/sql/load_segmented_streams.sql
	# load in parallel (doing the entire load as a single insert is extremely slow for large study areas)
	parallel $(PSQL_CMD) -f scripts/model/sql/load_segmented_streams.sql -v wsg={1} ::: $(GROUPS_PARAM)
	# index after load because faster
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
# create barrier tables, load data, create (empty) views listing barriers of given type downstream of each stream
# -----
# other_definite barriers depends on these user tables being loaded, create the linkage here
.barriersource_other_definite: .exclusions .misc_barriers_definite .pscis_barrier_result_fixes
	touch $@
# subsurface flow barrier type only depends on fwa
.barriersource_subsurfaceflow: .fwapg
	touch $@
# all gradient barrier tables have the same two dependencies
.barriersource_gradient_05: scripts/gradient_barriers/.gradient_barriers .gradient_barriers_passable
	touch $@
.barriersource_gradient_07: scripts/gradient_barriers/.gradient_barriers .gradient_barriers_passable
	touch $@
.barriersource_gradient_10: scripts/gradient_barriers/.gradient_barriers .gradient_barriers_passable
	touch $@
.barriersource_gradient_15: scripts/gradient_barriers/.gradient_barriers .gradient_barriers_passable
	touch $@
.barriersource_gradient_20: scripts/gradient_barriers/.gradient_barriers .gradient_barriers_passable
	touch $@
.barriersource_gradient_25: scripts/gradient_barriers/.gradient_barriers .gradient_barriers_passable
	touch $@
.barriersource_gradient_30: scripts/gradient_barriers/.gradient_barriers .gradient_barriers_passable
	touch $@
# for every .barriersource file, create/load barrier table and barrier _dnstr tables,
# and load/refresh the barrier table for for watershed group(s) where data has had a change
.barriers_%: .barriersource_% .param_watersheds
	echo "SELECT bcfishpass.create_barrier_table(:'barriertype')" | $(PSQL_CMD) -v barriertype=$(subst .barriers_,,$@)
	# clear barrier load table
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.barrier_load"
	# load all features in study area for given barrier type to barrier_load table
	parallel $(PSQL_CMD) -f scripts/model/sql/$(subst .,,$@).sql -v wsg={1} ::: $(GROUPS_PARAM)
	# find watershed groups requiring updates and write list to file
	echo "select * from bcfishpass.wsg_to_refresh('barrier_load', '$(subst .,,$@)')" | $(PSQL_CMD) -AtX > $@_wsg
	# load above noted watershed groups to barrier table
	# note that the wrapper query sql file is not needed, the file is just simpler than figuring out make/parallel quoting
	parallel -a $@_wsg --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/refresh_barriers_wrapper.sql -v wsg={1} -v barriertype=$(subst .barriers_,,$@)
	mv $@_wsg $@

# ------
# OBSERVATIONS
# ------
# extract FISS observations for species of interest from bcfishobs,
# create empty view relating streams to upstream observations
# TODO - add user table dependency for excluding bad observation data
.observations: scripts/model/sql/load_observations.sql .param_watersheds .param_habitat .bcfishobs .wsg_species_presence
	# first, load *all* observation data to _load table
	$(PSQL_CMD) -f $<
	# find watershed groups with changed observation data
	echo "select * from bcfishpass.wsg_to_refresh('observations_load', '$(subst .,,$@)')" | $(PSQL_CMD) -AtX > $@_wsg
	parallel -a $@_wsg --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/refresh_observations.sql -v wsg={1}
	mv $@_wsg $@


# -----
# BREAK STREAMS
# -----
# merge all point features into a single table and break streams at intersections
# note that this will only pick up breakpoints that are 1m from existing breaks in the streams,
# re-runs with minor updates will be very quick
.break_streams:  $(patsubst %, .barriers_%, $(BARRIERS)) .segmented_streams .observations \
	.manual_habitat_classification_endpoints scripts/model/sql/breakpoints.sql scripts/model/sql/break_streams.sql
	# Stream breaking query as currently written locks when run in parallel, just iterate through groups.
	# (this is probably just an issue with the primary key sequence not being able to keep up/getting locked)
	for wsg in $(GROUPS_REFRESH) ; do \
		$(PSQL_CMD) -v wsg=$$wsg -f scripts/model/sql/breakpoints.sql; \
		$(PSQL_CMD) -v wsg=$$wsg -f scripts/model/sql/break_streams.sql ; \
	done
	touch $@

# -----
# BARRIERS_DNSTR TABLES - INDEX BARRIERS DOWNSTREAM
# -----
.barriersdnstr_%: .barriers_% .break_streams
	# updated watershed groups to barrier _dnstr table.
	# note that the wrapper query sql file is not needed a file seems simpler than figuring out make/parallel quoting
	parallel -a $< --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/refresh_barriers_wrapper.sql -v wsg={1} -v barriertype=$(subst .barriers_,,$<)
	touch $@

# -----
# OBSERVATIONS_UPSTR - INDEX OBSERVATIONS UPSTREAM
# -----
.observations_upstr: .observations .break_streams
	# note that the wrapper query sql file is not needed a file seems simpler than figuring out make/parallel quoting
	parallel -a $< --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/refresh_observations.sql -v wsg={1}
	touch $@

# -----
# RUN ACCESS MODEL QUERY
# -----
# load/refresh materialized views that hold lists of downstream barriers for each stream
.model_access: $(wildcard .barriersdnstr*) .observations_upstr
	$(PSQL_CMD) -f scripts/model/sql/model_access.sql
	touch $@

#.crossings_report:
# index barriers_anthropogenic and crossings based on upstream/downstream crossings
#cd scripts/model ; python bcfishpass.py add-downstream-ids bcfishpass.barriers_anthropogenic aggregated_crossings_id bcfishpass.barriers_anthropogenic aggregated_crossings_id dnstr_barriers_anthropogenic
#cd scripts/model ; python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id dnstr_crossings
#cd scripts/model ; python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic aggregated_crossings_id dnstr_barriers_anthropogenic
#cd scripts/model ; python bcfishpass.py add-upstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic aggregated_crossings_id upstr_barriers_anthropogenic

# document these new columns in the crossings table
#$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_crossings IS 'List of the aggregated_crossings_id values of crossings downstream of the given crossing, in order downstream';"
#$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_barriers_anthropogenic IS 'List of the aggregated_crossings_id values of barrier crossings downstream of the given crossing, in order downstream';"
#$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.upstr_barriers_anthropogenic IS 'List of the aggregated_crossings_id values of barrier crossings upstream of the given crossing';"
#$(PSQL_CMD) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS dnstr_barriers_anthropogenic_count integer"
#$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.dnstr_barriers_anthropogenic_count IS 'A count of the barrier crossings downstream of the given crossing';"
#$(PSQL_CMD) -c "UPDATE bcfishpass.crossings SET dnstr_barriers_anthropogenic_count = array_length(dnstr_barriers_anthropogenic, 1) WHERE dnstr_barriers_anthropogenic IS NOT NULL";


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
	cd scripts/model ; bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_steelhead definitebarriers_steelhead_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
	cd scripts/model ; bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_salmon definitebarriers_salmon_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id
	cd scripts/model ; bcfishpass.py add-upstream-ids bcfishpass.definitebarriers_wct definitebarriers_wct_id bcfishpass.observations fish_obsrvtn_pnt_distinct_id upstr_observation_id

	# remove definite barriers below WCT observations
	# TODO - this should be done for any resident spp being modelled
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.definitebarriers_wct WHERE upstr_observation_id IS NOT NULL AND barrier_type NOT IN ('EXCLUSION')"

	# note minimal definite barriers
	cd scripts/model ; python bcfishpass.py add-downstream-ids \
	  bcfishpass.definitebarriers_steelhead \
	  definitebarriers_steelhead_id \
	  bcfishpass.definitebarriers_steelhead \
	  definitebarriers_steelhead_id \
	  dnstr_definitebarriers_steelhead_id
	cd scripts/model ; python bcfishpass.py add-downstream-ids \
	  bcfishpass.definitebarriers_salmon \
	  definitebarriers_salmon_id \
	  bcfishpass.definitebarriers_salmon \
	  definitebarriers_salmon_id \
	  dnstr_definitebarriers_salmon_id
	cd scripts/model ; python bcfishpass.py add-downstream-ids \
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
	$(PSQL_CMD) -f scripts/model/sql/carto.sql

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