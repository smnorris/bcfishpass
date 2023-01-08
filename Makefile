.PHONY: all qa wcrp settings test clean_barrers #clean clean_sources
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")

QA_SCRIPTS = $(wildcard reports/qa/sql/*.sql)
QA_OUTPUTS = $(patsubst reports/qa/sql/%.sql,reports/qa/%.csv,$(QA_SCRIPTS))

WCRP_SCRIPTS = $(wildcard wcrp/reports/sql/*.sql)
WCRP_OUTPUTS = $(patsubst wcrp/reports/sql/%.sql,wcrp/reports/reports/%.csv,$(WCRP_SCRIPTS))


# Make all targets - just point to final target to make everything
all: .carto

qa: $(QA_OUTPUTS)

wcrp: $(WCRP_OUTPUTS)

# Remove model make targets
clean:
	rm -Rf .make
	cd model/access; make clean
	cd model/habitat_lateral; make clean

# ------
# SETUP
# ------
# load parameters, create user data tables
.make/setup: 
	mkdir -p .make
	# create tables for parameters and user maintained data
	$(PSQL) -f parameters/sql/parameters.sql
	$(PSQL) -f data/sql/user.sql
	# load parameters
	for csv in $(wildcard parameters/*csv) ; do \
		set -e ; ./scripts/load_csv.sh $$csv ; \
	done
	bcdata bc2pg WHSE_BASEMAPPING.DBM_MOF_50K_GRID
	touch $@

# ------
# FALLS
# ------
# This relatively small table can get regenerated any time source csvs have changed,
# the csv allows for adding features and it is convenient to have barrier status in the
# source falls table. (note that we don't use make in the falls directory because falls script
# should be called when any of the various requirements change)
.make/falls:  .make/setup \
	data/user_falls.csv \
	data/user_barriers_definite_control.csv \
	model/falls/falls.sh model/falls/sql/falls.sql
	./scripts/load_csv.sh data/user_falls.csv
	./scripts/load_csv.sh data/user_barriers_definite_control.csv
	cd model/falls; ./falls.sh
	touch $@

# ------
# GRADIENT BARRIERS
# ------
# Generate all gradient barriers at 5/10/15/20/25/30% thresholds.
model/gradient_barriers/.make/gradient_barriers: 
	cd model/gradient_barriers; make

# ------
# DAMS
# ------
.make/dams:  model/dams/dams.sh model/dams/sql/dams.sql
	cd model/dams; ./dams.sh
	touch $@

# ------
# MODELLED ROAD-STREAM CROSSINGS
# ------
# Create intersection points of road/railroads and streams, the post-process to ensure
# unique crossings
model/modelled_stream_crossings/.modelled_stream_crossings: 
	cd model/modelled_stream_crossings; make

# ------
# PSCIS STREAM CROSSINGS
# ------
.make/pscis: model/modelled_stream_crossings/.make/modelled_stream_crossings \
	data/pscis_modelledcrossings_streams_xref.csv
	./scripts/load_csv.sh data/pscis_modelledcrossings_streams_xref.csv
	cd model/pscis; ./pscis.sh
	touch $@

# -----
# LOAD DATA TABLES
# load various data/fix tables required for access model
# -----
.make/data: .make/setup \
	data/user_barriers_anthropogenic.csv \
	data/user_modelled_crossing_fixes.csv \
	data/user_pscis_barrier_status.csv \
	data/wsg_species_presence.csv \
	data/user_habitat_classification.csv
	./scripts/load_csv.sh data/user_barriers_anthropogenic.csv 
	./scripts/load_csv.sh data/user_modelled_crossing_fixes.csv
	./scripts/load_csv.sh data/user_pscis_barrier_status.csv
	./scripts/load_csv.sh data/wsg_species_presence.csv
	./scripts/load_csv.sh data/user_barriers_definite.csv
	./scripts/load_csv.sh data/user_habitat_classification.csv 
	# all stream breaking is done in access model, create required endpoints 
	# before running it
	$(PSQL) -f model/habitat_linear/sql/user_habitat_classification_endpoints.sql
	touch $@

# precip/channel width/discharge are not strictly required for access model but they
# are loaded to the initial streams table, it is easier to process them here first 
# before running access model
# -----
# MEAN ANNUAL PRECIPITATION
# -----
.make/precipitation:
	cd model/precipitation; ./mean_annual_precip.sh
	touch $@

# -----
# CHANNEL WIDTH
# -----
.model/channel_width/.make/channel_width: .make/precipitation
	cd model/channel_width; make

# -----
# DISCHARGE
# -----
model/discharge/.make/discharge: 
	cd model/discharge; make

# -----
# ACCESS MODEL
# -----
# streams must be broken at user habitat classifcation lines, so 
# we need to add the data before running the access model
model/access/.make/model_access: model/modelled_stream_crossings/.make/modelled_stream_crossings \
	.make/dams \
	.make/pscis \
	.make/data \
	model/channel_width/.make/channel_width \
	model/discharge/.make/discharge 
	cd model/access; make

# -----
# LINEAR HABITAT MODEL
# -----
.make/model_habitat_linear: model/access/.make/model_access 
	cd model/habitat_linear; ./habitat_linear.sh

# -----
# CROSSING STATS
# add various columns holding upstream/downstream metrics to crossings table and barriers_anthropogenic
# -----
.make/crossing_stats: .make/habitat_linear \
	reports/crossings/sql/point_report.sql \
	reports/crossings/sql/point_report_obs_belowupstrbarriers.sql \
	reports/crossings/sql/all_spawningrearing_per_barrier.sql
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
	$(PSQL) -f reports/crossings/sql/point_report_columns.sql \
		-v point_table=barriers_anthropogenic
	for wsg in $(WSG) ; do \
		set -e ; $(PSQL) -f reports/crossings/sql/point_report.sql \
		-v point_table=barriers_anthropogenic \
		-v point_id=barriers_anthropogenic_id \
		-v barriers_table=barriers_anthropogenic \
		-v dnstr_barriers_id=barriers_anthropogenic_dnstr \
		-v wsg=$$wsg ; \
	done
	## run report per watershed group on crossings
	$(PSQL) -f reports/crossings/sql/point_report_columns.sql \
		-v point_table=crossings
	for wsg in $(WSG) ; do \
		set -e ; $(PSQL) -f reports/crossings/sql/point_report.sql \
		-v point_table=crossings \
		-v point_id=aggregated_crossings_id \
		-v barriers_table=barriers_anthropogenic \
		-v dnstr_barriers_id=barriers_anthropogenic_dnstr \
		-v wsg=$$wsg ; \
	done
	
	# For OBS in the crossings table, report on belowupstrbarriers columns.
	# This requires a separate query 
	# (because the dnstr_barriers_anthropogenic is used in above report, 
	# and that misses the OBS of interest)
	$(PSQL) -f reports/crossings/sql/point_report_obs_belowupstrbarriers.sql

	# add habitat per barrier column to crossings table
	for wsg in $(WSG) ; do \
		psql -f reports/crossings/sql/all_spawningrearing_per_barrier.sql -v wsg=$$wsg ; \
	done
	touch $@

# -----
# LATERAL HABITAT MODEL
# -----
model/habitat_lateral/data/habitat_lateral.tif: .make/habitat_linear \
	.make/crossing_stats
	cd model/habitat_lateral; make data/habitat_lateral.tif

# -----
# ACCESS MODEL QA REPORTS
# -----
reports/qa/%.csv: reports/qa/sql/%.sql \
	model/access/.make/model_access \
	.make/habitat_linear
	psql2csv $(DATABASE_URL) < $< > $@	

# -----
# wcrp reports - dump results of each query in reports/wcrp/sql/ to csv
# -----
wcrp/reports/reports/%.csv: wcrp/reports/sql/%.sql .point_reports
	mkdir -p reports/wcrp/reports
	psql2csv $(DATABASE_URL) < $< > $@
	
# generalized streams for mapping
.carto: .point_reports
	$(PSQL) -f model/model/sql/carto.sql
	touch $@
