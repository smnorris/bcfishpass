.PHONY: all qa wcrp settings test clean_barrers #clean clean_sources
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors

#WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly ORDER BY watershed_group_code")
#WSG_PARAM = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")

# watersheds for testing
WSG_TEST = BULK #ELKR HORS BULK LNIC #VICT LFRA QUES CARR UFRA MORK PARS COWN
WSG=$(WSG_TEST)
WSG_PARAM=$(WSG_TEST)

# each type of barrier is stored in its own table, as defined by these files
BARRIERS = $(patsubst scripts/model_access/sql/barriers_%.sql, %, $(wildcard scripts/model_access/sql/barriers_*.sql))
# define the make targets that flag when the table has been built
BARRIER_TABLES = $(patsubst scripts/model_access/sql/%.sql, .make/%, $(wildcard scripts/model_access/sql/barriers_*.sql))


# features to process as anthropogenic barriers (obv pscis and remediated are not barriers but it is convenient to pretend they are for processing)
BARRIERS_ANTHROPOGENIC = anthropogenic pscis remediated
# all potential definite barriers
BARRIERS_DEFINITE = $(filter-out $(ANTH_BARRIERS), $(BARRIERS))
BARRIERS_DEFINITE_TARGETS = $(patsubst scripts/model_access/sql/%.sql, .make/%, $(BARRIERS_DEFINITE))

# definite barriers collected into per-species access model tables
SPPGROUPS = $(patsubst scripts/model/sql/model_barriers_%.sql, %, $(wildcard scripts/model/sql/model_barriers_*.sql))

BROKEN_ANTHROPOGENIC = $(patsubst %,.make/broken_%,$(ANTH_BARRIERS))
BROKEN_SPPGROUPS = $(patsubst %,.make/broken_%,$(SPPGROUPS))
BROKEN = $(BROKEN_SPPGROUPS) $(BROKEN_ANTHROPOGENIC) .make/broken_observations

QA_SCRIPTS = $(wildcard scripts/qa/sql/*.sql)
QA_OUTPUTS = $(patsubst scripts/qa/sql/%.sql,qa/%.csv,$(QA_SCRIPTS))

WCRP_SCRIPTS = $(wildcard wcrp/reports/sql/*.sql)
WCRP_OUTPUTS = $(patsubst wcrp/reports/sql/%.sql,wcrp/reports/reports/%.csv,$(WCRP_SCRIPTS))

# which watershed groups to be refreshed are defined by reading target file of barrier creation recipies
# wsg_to_refresh_def is all wsg that have been refreshed by individual definite barrier tables, plus observations,
# this defines which watersheds to break with spp group definite barriers
#WSG_TO_REFRESH_DEF = $(shell cat $(patsubst %,.barriers_%,$(DEF_BARRIERS)) .observations | sort | uniq)
# if running a new spp scenario with no changes to individual source barrier tables, override above with this:
WSG_TO_REFRESH_DEF = $(WSG_PARAM)
# wsg_to_refresh is anywhere that a change has taken place (definite plus anthropogenic and observations),
# this defines where to run the model updates
WSG_TO_REFRESH = $(shell cat $(patsubst %,.barriers_%,$(BARRIERS)) .observations | sort | uniq)


# Make all targets - just point to final target to make everything
all: .carto

qa: $(QA_OUTPUTS)

wcrp: $(WCRP_OUTPUTS)

settings:
	echo BARRIERS: $(BARRIERS)
	echo ANTH_BARRIERS: $(ANTH_BARRIERS)
	echo DEF_BARRIERS: $(DEF_BARRIERS)
	echo SPP_BARRIERS: $(SPP_BARRIERS)
	echo BARRIERS_BROKEN: $(BARRIERS_BROKEN)


# remove all barrier tables/targets
clean_barriers:
	rm -Rf $(wildcard .make/barriers_*)
	for barriertype in $(BARRIERS) ; do \
		echo "DROP TABLE IF EXISTS bcfishpass.:table" | $(PSQL) -v table=barriers_$$barriertype ; \
	done

# remove all access model tables/targets
clean_access:
	rm -Rf $(wildcard .make/broken_*)
	rm -Rf $(wildcard .make/breakpts_*)
	rm -rf .make/update_access
	for barriertype in $(SPPGROUPS) ; do \
		echo "DROP TABLE IF EXISTS bcfishpass.:table" | $(PSQL) -v table=barriers_$$barriertype ; \
	done

# Remove model make targets
clean:
	rm -Rf .make


# ======
# NATURAL BARRIERS
# ======
# ------
# Falls
# ------
# This relatively small table can get regenerated any time source csvs have changed,
# the csv allows for adding features and it is convenient to have barrier status in the
# source falls table. (note that we don't use make in the falls directory because falls script
# should be called when any of the various requirements change)
.make/falls:  data/user_falls.csv data/user_barriers_definite_control.csv scripts/falls/falls.sh scripts/falls/sql/falls.sql
	./scripts/misc/load_csv.sh data/user_falls.csv
	./scripts/misc/load_csv.sh data/user_barriers_definite_control.csv
	cd scripts/falls; ./falls.sh
	touch $@

# ------
# Gradient barriers
# ------
# Generate all gradient barriers at 5/10/15/20/25/30% thresholds.
scripts/gradient_barriers/.make/gradient_barriers: 
	cd scripts/gradient_barriers; make


# ======
# ANTHROPOGENIC BARRIERS
# ======
# ------
# Dams
# ------
.make/dams:  scripts/dams/dams.sh scripts/dams/sql/dams.sql
	cd scripts/dams; ./dams.sh
	touch $@

# ------
# Modelled road-stream crossings
# ------
# Create intersection points of road/railroads and streams, the post-process to ensure
# unique crossings
scripts/modelled_stream_crossings/.modelled_stream_crossings: 
	cd scripts/modelled_stream_crossings; make

# ------
# PSCIS stream crossings
# ------
.make/pscis: scripts/modelled_stream_crossings/.make/modelled_stream_crossings \
	data/pscis_modelledcrossings_streams_xref.csv
	./scripts/misc/load_csv.sh data/pscis_modelledcrossings_streams_xref.csv
	cd scripts/pscis; ./pscis.sh
	touch $@

# ------
# ACCESS MODEL SETUP - load functions, create empty tables
# ------
.make/access_setup: $(wildcard scripts/model_access/sql/functions/*sql) \
	$(wildcard scripts/model_access/sql/tables/*sql) 
	mkdir -p .make
	for sql in $^ ; do \
		$(PSQL) -f $$sql ; \
	done
	touch $@

# -- load parameters
.make/parameters:  $(wildcard parameters/*csv) 
	./scripts/misc/load_csv.sh $<
	touch $@

# -- required by crossings script
.make/dbm_mof_50k_grid:
	bcdata bc2pg WHSE_BASEMAPPING.DBM_MOF_50K_GRID
	touch $@	

# -----
# CROSSINGS TABLE
# consolidate all dams/pscis/modelled crossings/misc anthropogenic barriers into one table
# -----
.make/crossings: scripts/model_access/sql/load_crossings.sql \
	.make/access_setup \
	.make/dbm_mof_50k_grid \
	scripts/modelled_stream_crossings/.make/modelled_stream_crossings \
	.make/dams \
	data/user_barriers_anthropogenic.csv \
	data/user_modelled_crossing_fixes.csv \
	data/user_pscis_barrier_status.csv \
	.make/pscis \
	./scripts/misc/load_csv.sh data/user_barriers_anthropogenic.csv \
	./scripts/misc/load_csv.sh data/user_modelled_crossing_fixes.csv \
	./scripts/misc/load_csv.sh data/user_pscis_barrier_status.csv
	$(PSQL) -c "truncate bcfishpass.crossings"
	$(PSQL) -f $<
	touch $@

# ------
# OBSERVATIONS
# ------
# extract FISS observations for species of interest within study area from bcfishobs
.make/observations: scripts/observations/sql/observations.sql data/wsg_species_presence.csv
	./scripts/misc/load_csv.sh data/wsg_species_presence.csv
	$(PSQL) -f scripts/observations/sql/observations.sql
	touch $@

# ------
# USER PROVIDED DEFINITE BARRIERS
# ------
# (other barriers are included as requirements just to ensure all barrier source data is ready to go at this point)
.make/barrier_sources: data/user_barriers_definite.csv \
	.make/falls \
	scripts/gradient_barriers/.make/gradient_barriers \
	.make/crossings \
	.make/streams
	./scripts/misc/load_csv.sh $<
	touch $@

# -----
# MEAN ANNUAL PRECIPITATION
# -----
scripts/precipitation/.map:
	cd scripts/precipitation; ./mean_annual_precip.sh
	touch $@

# -----
# CHANNEL WIDTH
# -----
.scripts/channel_width/.make/channel_width: scripts/precipitation/.map
	cd scripts/channel_width; make

# -----
# DISCHARGE
# -----
scripts/discharge/.make/discharge: 
	cd scripts/discharge; make

# -----
# ACCESS MODEL
# -----
scripts/model_access/.make/model_access: .make/parameters  \
	scripts/channel_width/.make/channel_width \
	scripts/discharge/.make/discharge
	cd scripts/model_access; make


.index_crossings: .make/barriers_anthropogenic
	# index crossings table based on upstream/downstream crossings
	cd scripts/model ; python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id crossings_dnstr
	cd scripts/model ; python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id barriers_anthropogenic_dnstr
	cd scripts/model ; python bcfishpass.py add-upstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id barriers_anthropogenic_upstr
	$(PSQL) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS barriers_anthropogenic_dnstr_count integer"
	$(PSQL) -c "UPDATE bcfishpass.crossings SET barriers_anthropogenic_dnstr_count = array_length(barriers_anthropogenic_dnstr, 1) WHERE barriers_anthropogenic_dnstr IS NOT NULL";
	$(PSQL) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS barriers_anthropogenic_upstr_count integer"
	$(PSQL) -c "UPDATE bcfishpass.crossings SET barriers_anthropogenic_upstr_count = array_length(barriers_anthropogenic_upstr, 1) WHERE barriers_anthropogenic_upstr IS NOT NULL";
	# document these new columns
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.crossings_dnstr IS 'List of the aggregated_crossings_id values of crossings downstream of the given crossing, in order downstream';"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_dnstr IS 'List of the aggregated_crossings_id values of barrier crossings downstream of the given crossing, in order downstream';"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_dnstr_count IS 'A count of the barrier crossings downstream of the given crossing';"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_upstr IS 'List of the aggregated_crossings_id values of barrier crossings upstream of the given crossing';"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_upstr_count IS 'A count of the barrier crossings upstream of the given crossing';"

	# also index barriers_anthropogenic
	cd scripts/model; python bcfishpass.py add-downstream-ids bcfishpass.barriers_anthropogenic barriers_anthropogenic_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id barriers_anthropogenic_dnstr
	$(PSQL) -c "VACUUM ANALYZE bcfishpass.crossings"
	$(PSQL) -c "VACUUM ANALYZE bcfishpass.barriers_anthropogenic"
	touch $@

# run qa queries
qa/%.csv: scripts/qa/sql/%.sql .update_access
	mkdir -p qa
	psql2csv $(DATABASE_URL) < $< > $@



# ***********************************************
# **                                           **
# **      CREATE/UPDATE HABITAT MODEL          **
# **                                           **
# ***********************************************


# -----
# RUN HABITAT MODEL
# -----
.model_habitat: .update_access .user_habitat_classification .param_habitat
	# first, ensure the spatial index gets used, 
	# spatial clustering in rearing queries is basically non-functional without it
	$(PSQL) -c "VACUUM ANALYZE bcfishpass.streams"
	
	# run per-species models
	#cat .wsg_to_refresh | sort | uniq | parallel --jobs 4 --no-run-if-empty $(PSQL) -f scripts/model/sql/model_habitat_rearing_1.sql -v wsg={1}
	for wsg in $(WSG_PARAM) ; do \
		set -e ; $(PSQL) -f scripts/model/sql/model_habitat_bt.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f scripts/model/sql/model_habitat_ch.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f scripts/model/sql/model_habitat_cm.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f scripts/model/sql/model_habitat_co.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f scripts/model/sql/model_habitat_pk.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f scripts/model/sql/model_habitat_sk.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f scripts/model/sql/model_habitat_st.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f scripts/model/sql/model_habitat_wct.sql -v wsg=$$wsg ; \
	done

	# override the model where specified by manual_habitat_classification, requires first creating endpoints & breaking the streams
	$(PSQL) -f scripts/model/sql/user_habitat_classification_endpoints.sql
	for wsg in $(WSG_PARAM) ; do \
		set -e ; $(PSQL) -f scripts/model/sql/break_streams_wrapper.sql -v wsg=$$wsg -v point_table=user_habitat_classification_endpoints ; \
	done
	$(PSQL) -f scripts/model/sql/user_habitat_classification.sql
	touch $@

# -----
# REPORT - ADD VARIOUS UPSTR/DNSTR SUMMARY COLUMNS, CREATE SUMMARY REPORTS
# -----
.point_reports: .model_habitat .index_crossings \
	scripts/model/sql/point_report.sql \
	scripts/model/sql/point_report_obs_belowupstrbarriers.sql \
	scripts/model/sql/all_spawningrearing_per_barrier.sql
	# todo:
	# below per wsg loops could be run in parallel if we write to temp
	# (per wsg) tables rather than applying updates to provincial table (can't
	# apply this many updates in parallel to the same table without hitting
	# locking/concurrency issues, even though each update is for distinct
	# records)
	# below takes ~45min to run as is. Running in parallel on 8 core machine
	# may bring this to under 15min or less. Even if the parallelization benefit
	# is not linear, running inserts rather than updates may also help
	# significantly. If all can be run as inserts (unlikely), time could
	# approach sub 5min on 8 core machine

	# run report per watershed group on barriers_anthropogenic
	$(PSQL) -f scripts/model/sql/point_report_columns.sql \
		-v point_table=barriers_anthropogenic
	for wsg in $(WSG_PARAM) ; do \
		set -e ; $(PSQL) -f scripts/model/sql/point_report.sql \
		-v point_table=barriers_anthropogenic \
		-v point_id=barriers_anthropogenic_id \
		-v barriers_table=barriers_anthropogenic \
		-v dnstr_barriers_id=barriers_anthropogenic_dnstr \
		-v wsg=$$wsg ; \
	done
	## run report per watershed group on crossings
	$(PSQL) -f scripts/model/sql/point_report_columns.sql \
		-v point_table=crossings
	for wsg in $(WSG_PARAM) ; do \
		set -e ; $(PSQL) -f scripts/model/sql/point_report.sql \
		-v point_table=crossings \
		-v point_id=aggregated_crossings_id \
		-v barriers_table=barriers_anthropogenic \
		-v dnstr_barriers_id=barriers_anthropogenic_dnstr \
		-v wsg=$$wsg ; \
	done
	
	# For OBS in the crossings table, report on belowupstrbarriers columns.
	# This requires a separate query # (because the dnstr_barriers_anthropogenic is used in above report, 
	# and that misses the OBS of interest)
	$(PSQL) -f scripts/model/sql/point_report_obs_belowupstrbarriers.sql

	# add habitat per barrier column to crossings table
	for wsg in $(WSG_PARAM) ; do \
		psql -f scripts/model/sql/all_spawningrearing_per_barrier.sql -v wsg=$$wsg ; \
	done
	touch $@

# ***********************************************
# **                                           **
# **      REPORTING/MAPPING/MISC               **
# **                                           **
# ***********************************************

# generalized streams for mapping
.carto: .point_reports
	$(PSQL) -f scripts/model/sql/carto.sql
	touch $@

# wcrp reports - dump results of each query in reports/wcrp/sql/ to csv
wcrp/reports/reports/%.csv: wcrp/reports/sql/%.sql .point_reports
	mkdir -p reports/wcrp/reports
	psql2csv $(DATABASE_URL) < $< > $@
	
scripts/lateral/data/lateral.tif: .point_reports
	cd scripts/lateral; rm .make/lateral_polys; make
