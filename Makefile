.PHONY: all qa wcrp settings test clean_barrers #clean clean_sources
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors


WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")
# watersheds for testing
#WSG=BULK HORS LNIC ELKR


QA_SCRIPTS = $(wildcard scripts/qa/sql/*.sql)
QA_OUTPUTS = $(patsubst scripts/qa/sql/%.sql,qa/%.csv,$(QA_SCRIPTS))

WCRP_SCRIPTS = $(wildcard wcrp/reports/sql/*.sql)
WCRP_OUTPUTS = $(patsubst wcrp/reports/sql/%.sql,wcrp/reports/reports/%.csv,$(WCRP_SCRIPTS))


# Make all targets - just point to final target to make everything
all: .carto

qa: $(QA_OUTPUTS)

wcrp: $(WCRP_OUTPUTS)


# Remove model make targets
clean:
	rm -Rf .make
	cd scripts/model_access; rm -rf .make
	cd scripts/model_habitat; rm -rf .make


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
	mkdir -p .make
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
# SETUP - setup db for access model etc, create empty tables, load parameters
# ------
.make/setup: $(wildcard scripts/model_access/sql/functions/*sql) \
	$(wildcard scripts/model_access/sql/tables/*sql) 
	mkdir -p .make
	for sql in $^ ; do \
		set -e ; $(PSQL) -f $$sql ; \
	done	
	for csv in $(wildcard parameters/*csv) ; do \
		set -e ; ./scripts/misc/load_csv.sh $$csv ; \
	done
	bcdata bc2pg WHSE_BASEMAPPING.DBM_MOF_50K_GRID
	touch $@

# -----
# CROSSINGS TABLE
# consolidate all dams/pscis/modelled crossings/misc anthropogenic barriers into one table
# -----
.make/crossings: scripts/model_access/sql/load_crossings.sql \
	.make/setup \
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
.make/observations: scripts/observations/sql/observations.sql data/wsg_species_presence.csv .make/setup
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
	.make/crossings
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
scripts/model_access/.make/model_access: .make/barrier_sources  \
	.make/observations  \
	scripts/channel_width/.make/channel_width \
	scripts/discharge/.make/discharge
	cd scripts/model_access; make

# -----
# HABITAT MODEL
# -----
scripts/model_habitat_linear/.make/model_habitat_linear: data/user_habitat_classification.csv \
	scripts/model_access/.make/model_access
	./scripts/misc/load_csv.sh $< # load manual habitat classification
	cd scripts/model_habitat_linear; make

# run qa queries
qa/%.csv: scripts/qa/sql/%.sql .update_access
	mkdir -p qa
	psql2csv $(DATABASE_URL) < $< > $@


# -----
# REPORT - ADD VARIOUS UPSTR/DNSTR SUMMARY COLUMNS, CREATE SUMMARY REPORTS
# -----
.point_reports: scripts/model_habitat/.make/model_habitat \
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
	for wsg in $(WSG) ; do \
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
	for wsg in $(WSG) ; do \
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
	for wsg in $(WSG) ; do \
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
