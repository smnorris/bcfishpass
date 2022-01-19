.PHONY: all qa settings test clean_barrers #clean clean_sources
.SECONDARY:  # do not delete intermediate targets

PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
WSG = $(shell $(PSQL_CMD) -AtX -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")
WSG_PARAM = $(shell $(PSQL_CMD) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")
WSG_TEST = HORS BULK LNIC ELKR
WSG_RAIL = BBAR BONP BRID BULK CHWK COTR DEAD DRIR FRAN FRCN GRNL HARR KISP KLUM LCHL LFRA LILL LKEL LNIC LNTH LSAL LSKE LTRE MIDR MORK MORR MUSK NARC NECR QUES SAJR SALR SETN SHUL STHM STUL SUST TABR TAKL THOM TWAC UFRA UNTH USHU UTRE WILL
WSG_NON_RAIL = ADMS ALBN ATNA BABL BABR BARR BELA BLAR BOWR BRKS CAMB CARR CHES CHIL CHIR CLAY CLWR COMX COWN DOGC ELKR EUCH EUCL GLAR GOLD GRAI GUIC HERR HOLB HOMA HORS INKR JENR JERV KEEC KHTZ KINR KITL KITR KLIN KNIG KSHR KTSU KUMR LBIR LCHR LDEN LISR LNAR LRDO LSTR MAHD MBNK MCGR MESC MFRA MORI MSKE MSTR NAHR NAKR NASC NASR NAZR NBNK NECL NEVI NICL NIEL NIMP OKAN OWIK PARK PARS PORI SALM SANJ SEYM SHER SQAM STIR STUR SWIR TAHR TAHS TASR TATR TAYR TESR TOBA TSAY TSIT UBIR UCHR UJER UNAR UNUR USKE USTK VICT WORC ZYMO
GENERATED_FILES=.fwapg .bcfishobs .schema \
	.falls .dams .pscis_load .crossings .manual_habitat_classification_endpoints \
	.streams .observations .observations_upstr .model_access

BARRIERS = $(patsubst scripts/model/sql/barriers_%.sql, %, $(wildcard scripts/model/sql/barriers_*.sql))
# features to process as anthropogenic barriers (obv pscis and remediated are not barriers but it is convenient to pretend they are for processing)
ANTH_BARRIERS = anthropogenic pscis remediated
# all potential definite barriers
DEF_BARRIERS = $(filter-out $(ANTH_BARRIERS), $(BARRIERS))
# definite barriers collected into per-species tables
SPECIES_GROUPS = $(patsubst scripts/model/sql/definitebarriers_%.sql, %, $(wildcard scripts/model/sql/definitebarriers_*.sql))
BARRIERS_BROKEN = $(patsubst %,.broken_%,$(ANTH_BARRIERS)) $(patsubst %,.broken_%,$(SPECIES_GROUPS))

QA_SCRIPTS = $(wildcard scripts/qa/sql/*.sql)
QA_OUTPUTS = $(patsubst scripts/qa/sql/%.sql,qa/%.csv,$(QA_SCRIPTS))


# Make all targets - just point to final target to make everything
all: .model_access

qa: $(QA_OUTPUTS)

settings:
	echo BARRIERS: $(BARRIERS)
	echo ANTH_BARRIERS: $(ANTH_BARRIERS)
	echo DEF_BARRIERS: $(DEF_BARRIERS)
	echo SPP_BARRIERS: $(SPP_BARRIERS)
	echo BARRIERS_BROKEN: $(BARRIERS_BROKEN)

# Remove make targets not in root folder
clean_sources:
	rm -Rf fwapg
	rm -Rf bcfishobs
	cd scripts/modelled_stream_crossings; make clean

clean_barriers:
	rm -Rf $(wildcard .barriers_*)
	rm -Rf $(wildcard .xbarriers_*)
	for barriertype in $(BARRIERS) ; do \
		echo "DROP TABLE IF EXISTS bcfishpass.:table" | $(PSQL_CMD) -v table=barriers_$$barriertype ; \
	done
	for barriertype in $(SPECIES_GROUPS) ; do \
		echo "DROP TABLE IF EXISTS bcfishpass.:table" | $(PSQL_CMD) -v table=barriers_$$barriertype ; \
	done


# Remove model make targets
clean:
	rm -Rf $(GENERATED_FILES)
	rm -Rf $(wildcard .barriers_*)


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
# CREATE SCHEMA, ADD FUNCTIONS, CREATE EMPTY TABLES AND LOAD MAPPING GRID
# ------
.schema: $(wildcard scripts/model/sql/tables/*sql) $(wildcard scripts/model/sql/functions/*sql)
	$(PSQL_CMD) -c "CREATE SCHEMA IF NOT EXISTS bcfishpass"
	for sql in $^ ; do \
		$(PSQL_CMD) -f $$sql ; \
	done
	touch $@

.tiles: .schema
	bcdata bc2pg WHSE_BASEMAPPING.DBM_MOF_50K_GRID
	touch $@

# ------
# LOAD USER EDITABLE DATA FILES (all csv files in /data folder)
# ------
.%: data/%.csv .schema
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.$(patsubst data/%.csv,%,$<)"
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
.falls: .fwapg .falls_other scripts/falls/falls.sh scripts/falls/sql/falls.sql .schema
	cd scripts/falls; ./falls.sh
	touch $@

# ------
# DAMS
# ------
# Dams are simple - no lookups required - but note that this table is a source for definite
# barriers *and* anthropogenic barriers. Delete the .dams target file if an update is required.
# (todo - consider consolidating CWF dams.geojson into the bcfishpass data folder so updates
# are easily picked up)
.dams: .fwapg scripts/dams/dams.sh scripts/dams/sql/dams.sql .schema
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
.pscis_load: scripts/modelled_stream_crossings/.modelled_stream_crossings .pscis_modelledcrossings_streams_xref
	cd scripts/pscis; ./pscis.sh
	touch $@

# -----
# CROSSINGS
# consolidate all dams/pscis/modelled crossings/misc anthropogenic barriers into one table
# -----
.crossings: scripts/model/sql/crossings.sql .tiles \
	.misc_barriers_anthropogenic \
	.modelled_stream_crossings_fixes \
	.pscis_barrier_result_fixes \
	.pscis_load \
	.barriersource_majordams
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.crossings"
	$(PSQL_CMD) -f $<
	touch $@

# -----
# MODEL CHANNEL WIDTH
# -----
.channel_width: .fwapg
	cd scripts/channel_width; ./mean_annual_precip.sh
	cd scripts/channel_width; ./channel_width.sh
	touch $@

# -----
# MODEL DISCHARGE
# -----
scripts/discharge/.discharge: .fwapg
	cd scripts/discharge; make

# -----
# INITIAL PROVINCIAL STREAM DATA LOAD
# (channel width and discharge are required as they are loaded directly to this table)
# -----
.streams: .param_watersheds .fwapg scripts/model/sql/tables/streams.sql .channel_width scripts/discharge/.discharge
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass.streams"
	$(PSQL_CMD) -f scripts/model/sql/tables/streams.sql
	parallel $(PSQL_CMD) -f scripts/model/sql/load_streams.sql -v wsg={1} ::: $(WSG_PARAM)
	$(PSQL_CMD) -c "CREATE INDEX IF NOT EXISTS streams_lfeatid_idx ON bcfishpass.streams (linear_feature_id);"
	$(PSQL_CMD) -c "CREATE INDEX IF NOT EXISTS streams_blkey_idx ON bcfishpass.streams (blue_line_key);"
	$(PSQL_CMD) -c "CREATE INDEX IF NOT EXISTS streams_wsg_idx ON bcfishpass.streams (watershed_group_code);"
	$(PSQL_CMD) -c "CREATE INDEX IF NOT EXISTS streams_wbkey_idx ON bcfishpass.streams (waterbody_key);"
	$(PSQL_CMD) -c "CREATE INDEX IF NOT EXISTS streams_wsc_gidx ON bcfishpass.streams USING GIST (wscode_ltree);"
	$(PSQL_CMD) -c "CREATE INDEX IF NOT EXISTS streams_wsc_bidx ON bcfishpass.streams USING BTREE (wscode_ltree);"
	$(PSQL_CMD) -c "CREATE INDEX IF NOT EXISTS streams_lc_gidx ON bcfishpass.streams USING GIST (localcode_ltree);"
	$(PSQL_CMD) -c "CREATE INDEX IF NOT EXISTS streams_lc_bidx ON bcfishpass.streams USING BTREE (localcode_ltree);"
	$(PSQL_CMD) -c "CREATE INDEX IF NOT EXISTS streams_geom_idx ON bcfishpass.streams USING GIST (geom);"
	touch $@


# ***********************************************
# **                                           **
# **      CREATE/UPDATE ACCESS MODEL           **
# **                                           **
# ***********************************************

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
	echo "select * from bcfishpass.wsg_to_refresh('observations_load', '$(subst .,,$@)')" | $(PSQL_CMD) -AtX > .torefresh_observations
	parallel -a .torefresh_observations --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/refresh_observations.sql -v wsg={1}
	cat .torefresh_observations >> .wsg_to_refresh
	mv .torefresh_observations $@

# -----
# BARRIER TABLES
# create barrier tables, load data, create (empty) views listing barriers of given type downstream of each stream
# -----
.barriersource_majordams: .dams
	touch $@
.barriersource_falls: .falls .falls_barrier_ind
	touch $@
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
# other_definite barriers depends on these user tables being loaded, create the linkage here
.barriersource_other_definite: .exclusions .misc_barriers_definite .pscis_barrier_result_fixes
	touch $@
# subsurface flow barrier type only depends on fwa
.barriersource_subsurfaceflow: .fwapg
	touch $@
.barriersource_anthropogenic: .crossings
	touch $@
.barriersource_pscis: .crossings
	touch $@
.barriersource_remediated: .crossings
	touch $@

# for every .barriersource file, create barrier table
# and load/refresh the barrier table for for watershed group(s) where data has had a change
.barriers_%: .barriersource_% .param_watersheds
	echo "SELECT bcfishpass.create_barrier_tables(:'barriertype')" | $(PSQL_CMD) -v barriertype=$(subst .barriers_,,$@)
	# clear barrier load table
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.barrier_load"
	# load all features for given barrier type to barrier_load table
	parallel $(PSQL_CMD) -f scripts/model/sql/$(subst .,,$@).sql -v wsg={1} ::: $(WSG)
	# find watershed groups requiring updates and write list to file
	echo "select * from bcfishpass.wsg_to_refresh('barrier_load', '$(subst .,,$@)')" | $(PSQL_CMD) -AtX >  $(subst .barriers_,.torefresh_,$@)
	# load above noted watershed groups to barrier table
	# note that the wrapper query sql file is not needed, the file is just simpler than figuring out make/parallel quoting
	parallel -a $(subst .barriers_,.torefresh_,$@) --no-run-if-empty \
		$(PSQL_CMD) -f scripts/model/sql/refresh_barriers_wrapper.sql \
		-v wsg={1} \
		-v barriertype=$(subst .barriers_,,$@)
	# append list of watershed groups to refresh for given barrier type to list of all groups to refresh for all barrier types
	cat $(subst .barriers_,.torefresh_,$@) >> .wsg_to_refresh
	# create target
	mv $(subst .barriers_,.torefresh_,$@) $@

# tag anthropogenic barriers as barriers for breaking streams (xbarriers_ prefix)
$(patsubst %, .xbarriers_%, $(ANTH_BARRIERS)): .xbarriers_%: .barriers_%
	cp $(subst .x,.,$@) $@

# for each species/species group being modelled, combine definite barriers into a single table for that species/species group
.xbarriers_%: scripts/model/sql/definitebarriers_%.sql $(patsubst %,.barriers_%,$(DEF_BARRIERS)) .observations
	# create barrier table if it does not already exist
	echo "SELECT bcfishpass.create_barrier_tables(:'barriertype')" | $(PSQL_CMD) -v barriertype=$(subst .xbarriers_,,$@)
	# clear barrier load table
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.barrier_load"
	# load all features for given spp scenario to barrier_load table
	cat .wsg_to_refresh | sort | uniq | parallel --no-run-if-empty $(PSQL_CMD) -f $< -v wsg={1}
	cat .wsg_to_refresh | sort | uniq | parallel --no-run-if-empty \
		$(PSQL_CMD) -f scripts/model/sql/refresh_barriers_wrapper.sql \
		-v wsg={1} \
		-v barriertype=$(subst .xbarriers_,,$@)
	# index downstream. bcfishpass.py indexes the entire table rather than the watershed groups required,
	# but works well despite this redundancy - running updates is far too slow. Fastest might be to create
	# individual tables for each watershed group to be processed and work on them in parallel
	cd scripts/model ; python bcfishpass.py add-downstream-ids bcfishpass.$(subst .x,,$@) $(subst .x,,$@)_id bcfishpass.$(subst .x,,$@) $(subst .x,,$@)_id $(subst .x,,$@)_dnstr
	echo "DELETE FROM bcfishpass.:table WHERE :id IS NOT NULL" | $(PSQL_CMD) -v id=$(subst .x,,$@)_dnstr -v table=$(subst .x,,$@)
	touch $@

# -----
# BREAK STREAMS
# -----
# break at various barrier types and observations
# NOTE - to ensure that make generates targets made with this wild card pattern, a 'static pattern rule' is required
# https://stackoverflow.com/questions/23964228/make-ignoring-prerequisite-that-doesnt-exist
# NOTE2 - processing in parallel (provincially) eventually crashes the db, process one group at a time or with a
# modest job count
# break streams and index
$(BARRIERS_BROKEN): .broken_%: .xbarriers_% .streams
	cat .wsg_to_refresh | sort | uniq | parallel --jobs 4 --no-run-if-empty \
		$(PSQL_CMD) -f scripts/model/sql/break_streams_wrapper.sql \
		-v wsg={1} -v point_table=$(subst .x,,$<)
	#cat .wsg_to_refresh | sort | uniq | parallel -a $< --jobs 4 --no-run-if-empty \
	# concurrent updates locks the db, process wsg individually
	for wsg in $(shell cat .wsg_to_refresh | sort | uniq) ; do \
		$(PSQL_CMD) -f scripts/model/sql/update_barriers_dnstr_wrapper.sql \
		-v target_table=streams \
		-v target_table_id=segmented_stream_id \
		-v barriertype=$(subst .broken_,,$@) \
		-v point_table=$(subst .broken_,barriers_,$@) \
		-v include_equivalents=true \
		-v wsg=$$wsg ;\
	done
	touch $@

# break streams and index at all observations (of target species)
.broken_observations: .observations .streams
	parallel -a $< --jobs 4 --no-run-if-empty  $(PSQL_CMD) -f scripts/model/sql/break_streams_wrapper.sql -v wsg={1} -v point_table=$(subst .,,$<)
	parallel -a $< --jobs 4 --no-run-if-empty  $(PSQL_CMD) -f scripts/model/sql/update_observations_upstr.sql -v wsg={1}
	touch $@

# once all barriers and observations are processed, update the access model values
.model_access: $(BARRIERS_BROKEN) .broken_observations
	for wsg in $(shell cat .wsg_to_refresh | sort | uniq) ; do \
		$(PSQL_CMD) -f scripts/model/sql/update_access.sql -v wsg=$$wsg ; \
	done
	touch $@

.index_crossings: .barriers_anthropogenic
	# index crossings table based on upstream/downstream crossings
	cd scripts/model ; python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id crossings_dnstr
	cd scripts/model ; python bcfishpass.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id barriers_anthropogenic_dnstr
	cd scripts/model ; python bcfishpass.py add-upstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id barriers_anthropogenic_upstr
	$(PSQL_CMD) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS barriers_anthropogenic_dnstr_count integer"
	$(PSQL_CMD) -c "UPDATE bcfishpass.crossings SET barriers_anthropogenic_dnstr_count = array_length(barriers_anthropogenic_dnstr, 1) WHERE barriers_anthropogenic_dnstr IS NOT NULL";
	$(PSQL_CMD) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS barriers_anthropogenic_upstr_count integer"
	$(PSQL_CMD) -c "UPDATE bcfishpass.crossings SET barriers_anthropogenic_upstr_count = array_length(barriers_anthropogenic_dnstr, 1) WHERE barriers_anthropogenic_upstr IS NOT NULL";
	# document these new columns
	$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.crossings_dnstr IS 'List of the aggregated_crossings_id values of crossings downstream of the given crossing, in order downstream';"
	$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_dnstr IS 'List of the aggregated_crossings_id values of barrier crossings downstream of the given crossing, in order downstream';"
	$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_dnstr_count IS 'A count of the barrier crossings downstream of the given crossing';"
	$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_upstr IS 'List of the aggregated_crossings_id values of barrier crossings upstream of the given crossing';"
	$(PSQL_CMD) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_upstr_count IS 'A count of the barrier crossings upstream of the given crossing';"


# run qa queries
qa/%.csv: scripts/qa/sql/%.sql .model_access
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
.model_habitat: .model_access
	# spawning model is relatively simple, requires just one query
	for wsg in $(WSG_TEST) ; do \
		$(PSQL_CMD) -f scripts/model/sql/model_habitat_spawning.sql -v wsg=$$wsg ; \
	done

	# rearing requires several queries
	# first, find all potential rearing streams
	#cat .wsg_to_refresh | sort | uniq | parallel --jobs 4 --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/model_habitat_rearing_1.sql -v wsg={1}
	parallel --jobs 4 --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/model_habitat_rearing_1.sql -v wsg={1} ::: $(WSG_TEST)

	# then find subset of rearing downstream of spawning
	#cat .wsg_to_refresh | sort | uniq | parallel --jobs 4 --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/model_habitat_rearing_2.sql -v wsg={1}
	parallel --jobs 4 --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/model_habitat_rearing_2.sql -v wsg={1} ::: $(WSG_TEST)

	# and finally find subset of rearing upstream of spawning
	#cat .wsg_to_refresh | sort | uniq | parallel --jobs 4 --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/model_habitat_rearing_3.sql -v wsg={1}
	parallel --jobs 4 --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/model_habitat_rearing_3.sql -v wsg={1} ::: $(WSG_TEST)

	# SK spawning/rearing modelling is separate because of different life cycle (lake requirement)
	#cat .wsg_to_refresh | sort | uniq | parallel --jobs 4 --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/model_habitat_sk.sql
	parallel --jobs 4 --no-run-if-empty $(PSQL_CMD) -f scripts/model/sql/model_habitat_sk.sql ::: $(WSG_TEST)

	# plus SK can be watershed specific, run for horsefly
	$(PSQL_CMD) -f scripts/model/model_habitat_sk_hors.sql

	# override the model where specified by manual_habitat_classification, requires first creating endpoints & breaking the streams
	$(PSQL_CMD) -f scripts/model/sql/manual_habitat_classification_endpoints.sql
	$(PSQL_CMD) -f scripts/model/sql/break_streams_wrapper.sql -v wsg={1} -v point_table=manual_habitat_classification_endpoints
	$(PSQL_CMD) -f scripts/model/sql/manual_habitat_classification.sql
	touch $@


# -----
# VARIOUS VIEWS FOR VIZ
# -----
# todo - currently tables but could likely be views
.views: .model_access


	# run report on the combined definite barrier tables
	python bcfishpass.py report bcfishpass.definitebarriers_ch_co_sk definitebarriers_ch_co_sk_id bcfishpass.definitebarriers_ch_co_sk dnstr_definitebarriers_ch_co_sk_id
	python bcfishpass.py report bcfishpass.definitebarriers_st definitebarriers_st_id bcfishpass.definitebarriers_st dnstr_definitebarriers_st_id
	python bcfishpass.py report bcfishpass.definitebarriers_wct definitebarriers_wct_id bcfishpass.definitebarriers_wct dnstr_definitebarriers_wct_id

	# generalized streams
	$(PSQL_CMD) -f scripts/model/sql/carto.sql

	touch $@

# -----
# REPORT - ADD VARIOUS UPSTR/DNSTR SUMMARY COLUMNS, CREATE SUMMARY REPORTS
# -----
.test_reports:
	# add reporting columns to tables
	$(PSQL_CMD) -f scripts/model/sql/test_point_report1.sql -v wsg={1} -v point_table=barriers_anthropogenic
	# run report per watershed group on barriers_anthropogenic
	#for wsg in $(WSG_RAIL) ; do \
	#	$(PSQL_CMD) -f scripts/model/sql/test_point_report2.sql \
	#	-v point_table=barriers_anthropogenic \
	#	-v point_id=barriers_anthropogenic_id \
	#	-v barriers_table=barriers_anthropogenic \
	#	-v dnstr_barriers_id=barriers_anthropogenic_dnstr \
	#	-v wsg=$$wsg ; \
	#done
	# run report per watershed group on crossings
	$(PSQL_CMD) -f scripts/model/sql/test_point_report1.sql -v wsg={1} -v point_table=crossings
	for wsg in $(WSG_PARAM) ; do \
		$(PSQL_CMD) -f scripts/model/sql/test_point_report2.sql \
		-v point_table=crossings \
		-v point_id=aggregated_crossings_id \
		-v barriers_table=barriers_anthropogenic \
		-v dnstr_barriers_id=barriers_anthropogenic_dnstr \
		-v wsg=$$wsg ; \
	done
	touch .test_reports

.reports: .model_access .index_crossings
	# report on how much is upstream of various definite barriers
	cd scripts/model ; python bcfishpass.py report bcfishpass.barriers_falls barriers_falls_id bcfishpass.barriers_falls dnstr_barriers_falls
	cd scripts/model ; python bcfishpass.py report bcfishpass.barriers_gradient_15 barriers_gradient_15_id bcfishpass.barriers_gradient_15 dnstr_barriers_gradient_15
	cd scripts/model ; python bcfishpass.py report bcfishpass.barriers_gradient_20 barriers_gradient_20_id bcfishpass.barriers_gradient_20 dnstr_barriers_gradient_20
	cd scripts/model ; python bcfishpass.py report bcfishpass.barriers_gradient_30 barriers_gradient_30_id bcfishpass.barriers_gradient_30 dnstr_barriers_gradient_30
	cd scripts/model ; python bcfishpass.py report bcfishpass.barriers_majordams barriers_majordams_id bcfishpass.barriers_majordams dnstr_barriers_majordams
	cd scripts/model ; python bcfishpass.py report bcfishpass.barriers_subsurfaceflow barriers_subsurfaceflow_id bcfishpass.barriers_subsurfaceflow dnstr_barriers_subsurfaceflow

	# run the report on the crossings table (requires processing both tables)
	python bcfishpass.py report bcfishpass.barriers_anthropogenic barriers_anthropogenic_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic
	python bcfishpass.py report bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic dnstr_barriers_anthropogenic

	# add habitat per barrier column to crossings table
	# this could potentially be included in the report.sql and added to all barrier tables, but it is only required for the
	psql -f sql/all_spawningrearing_per_barrier.sql

	# populating the belowupstrbarriers for OBS in the crossings table requires a separate query
	# (because the dnstr_barriers_anthropogenic is used in above report, and that misses the OBS of interest)
	psql -f sql/report_crossings_obs_belowupstrbarriers.sql

	touch $@



scripts/lateral/.lateral: .model_access
	cd scripts/lateral; make
