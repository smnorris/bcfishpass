.PHONY: all qa wcrp settings test clean_barrers #clean clean_sources
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

QA_ACCESS_SCRIPTS = $(wildcard reports/access/sql/*.sql)
QA_ACCESS_OUTPUTS = $(patsubst reports/access/sql/%.sql,reports/access/%.csv,$(QA_SCRIPTS))


all: model/habitat_lateral/data/habitat_lateral.tif

# Note that clean does not remove *all* targets.
# - the database itself is untouched, scripts recreate or re-load target tables when called
# - these targets with no requirments are not cleaned, rebuild them explicitly if needed:
#   + gradient barriers
#   + modelled stream crossings
#   + precipitation
#   + channel width
#   + discharge
clean:
	rm -Rf .make
	cd model/access; make clean

# ------
# SETUP
# ------
.make/schema:
	mkdir -p .make
	$(PSQL) -c "create schema if not exists bcfishpass"
	touch $@

# create empty user data tables, load grid and utm function
.make/setup: .make/schema \
	data/sql/user.sql \
	scripts/utmzone.sql
	$(PSQL) -f data/sql/user.sql
	bcdata bc2pg WHSE_BASEMAPPING.DBM_MOF_50K_GRID
	$(PSQL) -f scripts/utmzone.sql
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
model/gradient_barriers/.make/gradient_barriers: .make/schema
	cd model/gradient_barriers; make

# ------
# DAMS
# ------
.make/dams:  model/dams/dams.sh model/dams/sql/dams.sql .make/schema
	cd model/dams; ./dams.sh
	touch $@

# ------
# MODELLED ROAD-STREAM CROSSINGS
# ------
# Load modelled crossings from archive posted to s3 (this ensures consistent modelled crossing ids for all users)
.make/modelled_stream_crossings: .make/schema
	cd model/modelled_stream_crossings; make .make/download_archive
	cd model/modelled_stream_crossings; make .make/download_bcdata # also download roads/railways for reference
	touch $@

# ------
# PSCIS STREAM CROSSINGS
# ------
.make/pscis: data/pscis_modelledcrossings_streams_xref.csv \
 	.make/modelled_stream_crossings
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

# -----
# ACCESS MODEL
# -----
# streams must be broken at user habitat classifcation lines, so 
# we need to add the data before running the access model
.make/model_access: .make/falls \
	.make/dams \
	.make/pscis \
	.make/data \
	model/gradient_barriers/.make/gradient_barriers
	cd model/access; make
	touch $@

# -----
# ACCESS MODEL QA REPORTS
# -----
$(QA_ACCESS_OUTPUTS): reports/access/%.csv: reports/access/sql/%.sql \
	model/access/.make/model_access 
	psql2csv $(DATABASE_URL) < $< > $@	


# -----
# MEAN ANNUAL PRECIPITATION
# -----
model/precipitation/.make/precip:
	cd model/precipitation ; mkdir -p .make ; ./mean_annual_precip.sh
	touch $@

# -----
# CHANNEL WIDTH
# -----
model/channel_width/.make/channel_width: .make/precipitation
	cd model/channel_width; make

# -----
# DISCHARGE
# -----
model/discharge/.make/discharge: 
	cd model/discharge; make

# -----
# LINEAR HABITAT MODEL
# -----
.make/habitat_linear: .make/model_access \
	model/channel_width/.make/channel_width \
	model/discharge/.make/discharge 
	cd model/habitat_linear; ./habitat_linear.sh
	touch $@

# -----
# CROSSING STATS
# add various columns holding upstream/downstream metrics to crossings table and barriers_anthropogenic
# -----
.make/crossing_stats: .make/habitat_linear \
	reports/crossings/sql/point_report_columns.sql \
	reports/crossings/sql/point_report.sql \
	reports/crossings/sql/point_report_obs_belowupstrbarriers.sql \
	reports/crossings/sql/all_spawningrearing_per_barrier.sql
	# todo - optimize below to write to temp tables rather than applying updates
	
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

	# count barriers upstream and downstream
	$(PSQL) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS barriers_anthropogenic_dnstr_count integer"
	$(PSQL) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS barriers_anthropogenic_upstr_count integer"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_dnstr_count IS 'A count of the barrier crossings downstream of the given crossing';"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_upstr_count IS 'A count of the barrier crossings upstream of the given crossing';"
	$(PSQL) -c "UPDATE bcfishpass.crossings SET barriers_anthropogenic_dnstr_count = array_length(barriers_anthropogenic_dnstr, 1) WHERE barriers_anthropogenic_dnstr IS NOT NULL";
	$(PSQL) -c "UPDATE bcfishpass.crossings SET barriers_anthropogenic_upstr_count = array_length(barriers_anthropogenic_upstr, 1) WHERE barriers_anthropogenic_upstr IS NOT NULL";
	
	touch $@

# -----
# LATERAL HABITAT MODEL
# -----
model/habitat_lateral/data/habitat_lateral.tif: .make/habitat_linear \
	.make/crossing_stats
	cd model/habitat_lateral; make .make/habitat_lateral

