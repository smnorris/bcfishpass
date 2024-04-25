PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors

WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

QA_ACCESS_SCRIPTS = $(wildcard reports/access/sql/*.sql)
QA_ACCESS_OUTPUTS = $(patsubst reports/access/sql/%.sql,reports/access/%.csv,$(QA_SCRIPTS))

all: model/03_habitat_lateral/data/habitat_lateral.tif

# NOTE - db must exist and be set up
# (run /jobs/setup, load fwa and bcfishobs)

.make/parameters: parameters/*.csv
	mkdir -p .make
	$(PSQL) -c "truncate bcfishpass.parameters_habitat_method";
	$(PSQL) -c "truncate bcfishpass.parameters_habitat_thresholds";
	$(PSQL) -c "\copy bcfishpass.parameters_habitat_method FROM parameters/parameters_habitat_method.csv delimiter ',' csv header";
	$(PSQL) -c "\copy bcfishpass.parameters_habitat_thresholds FROM parameters/parameters_habitat_thresholds.csv delimiter ',' csv header";
	touch $@

.make/data: data/*.csv
	mkdir -p .make
	jobs/load_csv
	touch $@

.make/model_access: .make/data .make/parameters
	cd model/01_access; make
	touch $@

.make/habitat_linear: .make/model_access
	cd model/02_habitat_linear; make
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
	
	touch $@

# -----
# LATERAL HABITAT MODEL
# -----
model/03_habitat_lateral/data/habitat_lateral.tif: .make/habitat_linear \
	.make/crossing_stats
	cd model/habitat_lateral; make .make/habitat_lateral

