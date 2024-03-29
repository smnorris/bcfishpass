.PHONY: all clean
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors

# watershed groups to process are defined by bcfishpass.watershed_groups_access
WSGS = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.watershed_groups_access")

# define barrier table targets
NATURAL_BARRIERS = .make/barriers_falls \
	.make/barriers_subsurfaceflow \
	.make/barriers_user_definite \
	.make/barriers_gradient_05 \
	.make/barriers_gradient_10 \
	.make/barriers_gradient_15 \
	.make/barriers_gradient_20 \
	.make/barriers_gradient_25 \
	.make/barriers_gradient_30
ANTH_BARRIERS = .make/barriers_anthropogenic \
	.make/barriers_dams \
	.make/barriers_dams_hydro \
	.make/barriers_pscis

# access models - combine barriers into tables of per-species scenarios
ACCESS_MODELS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/model_access_*.sql))

all: .make/qa

clean: 
	rm -Rf .make

clean_natural:
	rm -f $(NATURAL_BARRIERS)
	rm -f .make/model_access*
	rm -f .make/qa

clean_access:
	rm -f .make/model_access*
	rm -f .make/qa

clean_anth:
	rm -f .make/crossings
	rm -f .make/dams
	rm -f .make/pscis
	rm -f $(ANTH_BARRIERS)
	rm -f .make/index_crossings
	rm -f .make/model_access_prep
	rm -f .make/model_access
	rm -f .make/qa

# for access model processing that is per-watershed group, use just watershed groups noted in parameters file
# (for testing only)
test:
	$(PSQL) -c "truncate bcfishpass.watershed_groups_access"
	$(PSQL) -c "insert into bcfishpass.watershed_groups_access select watershed_group_code from bcfishpass.parameters_habitat_method"

# revert to processing all watershed groups
full:
	$(PSQL) -c "truncate bcfishpass.watershed_groups_access"
	$(PSQL) -c "insert into bcfishpass.watershed_groups_access select watershed_group_code from whse_basemapping.fwa_watershed_groups_poly"

# ------
# FALLS
# ------
.make/falls: falls/falls.sh \
	falls/sql/falls.sql
	mkdir -p .make
	cd falls; ./falls.sh
	touch $@

# ready to go but not currently used
.make/cabd_waterfalls:
	mkdir -p .make
	$(PSQL) -c "truncate cabd.waterfalls"
	ogr2ogr -f PostgreSQL \
	  "PG:$(DATABASE_URL)" \
	  -append \
	  -nln cabd.waterfalls \
	  "https://cabd-web.azurewebsites.net/cabd-api/features/waterfalls?filter=province_territory_code:eq:bc&filter=use_analysis:eq:true" \
	  OGRGeoJSON
	$(PSQL) -c "refresh materialized view bcfishpass.falls_vw"
	$(PSQL) -c "refresh materialized view bcfishpass.falls_upstr_anadromous_vw"
	touch $@

# ------
# GRADIENT BARRIERS
# ------
# Generate all gradient barriers at 5/10/15/20/25/30% thresholds.
.make/gradient_barriers:
	cd gradient_barriers; ./gradient_barriers.sh
	touch $@

# ------
# DAMS
# ------
.make/dams:
	mkdir -p .make
	$(PSQL) -c "truncate cabd.dams"
	ogr2ogr -f PostgreSQL \
	  "PG:$(DATABASE_URL)" \
	  -append \
	  -nln cabd.dams \
	  "https://cabd-web.azurewebsites.net/cabd-api/features/dams?filter=province_territory_code:eq:bc&filter=use_analysis:eq:true" \
	  OGRGeoJSON
	$(PSQL) -c "refresh materialized view bcfishpass.dams_vw"
	touch $@

# ------
# MODELLED ROAD-STREAM CROSSINGS
# ------
# Load modelled crossings from archive posted to s3 (this ensures consistent modelled crossing ids for all users)
.make/modelled_stream_crossings:
	mkdir -p .make
	cd modelled_stream_crossings; make .make/download_archive
	touch $@

# ------
# PSCIS STREAM CROSSINGS
# ------
.make/pscis: .make/modelled_stream_crossings
	mkdir -p .make
	cd pscis; ./pscis.sh
	touch $@


# -----
# CROSSINGS
# -----
# combine modelled crossings, pscis, dams into bcfishpass.crossings
.make/crossings: .make/dams \
	.make/pscis \
	sql/load_crossings.sql
	$(PSQL) -c "truncate bcfishpass.crossings"
	# load crossings in series, parallel inserts can be confounded by locks
	for wsg in $(WSGS) ; do \
		set -e ; $(PSQL) -f sql/load_crossings.sql -v wsg=$$wsg ; \
	done
	touch $@

# -----
# OBSERVATIONS
# -----
# load observations of all spp of interest from bcfishobs to bcfishpass.observations
.make/observations: sql/load_observations.sql
	$(PSQL) -f $^ 
	touch $@

# -----
# LOAD BARRIER TYPE TABLES
# -----
# Create standardized barrier tables for natural barriers
$(NATURAL_BARRIERS): sql/barriers_falls.sql \
	sql/barriers_subsurfaceflow.sql \
	sql/barriers_user_definite.sql \
	sql/barriers_gradient_05.sql \
	sql/barriers_gradient_10.sql \
	sql/barriers_gradient_15.sql \
	sql/barriers_gradient_20.sql \
	sql/barriers_gradient_25.sql \
	sql/barriers_gradient_30.sql \
	.make/falls \
	.make/gradient_barriers
	$(eval BARRIERTYPE=$(subst .make/barriers_,,$@))
	# create the table if it does not exist
	echo "select bcfishpass.create_barrier_table(:'barriertype')" | \
		$(PSQL) -v barriertype=$(BARRIERTYPE)
	# clear barrier table
	$(PSQL) -c "truncate bcfishpass.barriers_$(BARRIERTYPE)"
	# load data to barrier table in parallel
	parallel $(PSQL) -f sql/barriers_$(BARRIERTYPE).sql -v wsg={1} ::: $(WSGS)
	touch $@

# Create standardized barrier tables for anthropogenic barriers
$(ANTH_BARRIERS): .make/crossings \
	sql/barriers_anthropogenic.sql \
	sql/barriers_dams.sql \
	sql/barriers_dams_hydro.sql \
	sql/barriers_pscis.sql
	$(eval BARRIERTYPE=$(subst .make/barriers_,,$@))
	# create the table if it does not exist
	echo "select bcfishpass.create_barrier_table(:'barriertype')" | \
		$(PSQL) -v barriertype=$(BARRIERTYPE)
	# clear barrier table
	$(PSQL) -c "truncate bcfishpass.barriers_$(BARRIERTYPE)"
	# load data to barrier table in parallel
	parallel $(PSQL) -f sql/barriers_$(BARRIERTYPE).sql -v wsg={1} ::: $(WSGS)
	touch $@

# -----
# LOAD PER-SPECIES BARRIER TABLES 
# -----
# Combine all potential definite/natural barriers into a single table per each species/species 
# group being modelled, then retain only the records with no other records downstream (ie, only
# the lowest in the system)
# Note that observations are a requirement because they can be used to cancel natural barriers
$(ACCESS_MODELS): .make/model_access_%: sql/model_access_%.sql \
	$(NATURAL_BARRIERS) \
	.make/observations
	$(eval BARRIERTYPE=$(subst .make/model_access_,,$@))
	# create table if it does not exist
	echo "select bcfishpass.create_barrier_table(:'barriertype')" | $(PSQL) -v barriertype=$(BARRIERTYPE)
	# clear the table
	$(PSQL) -c "truncate bcfishpass.barriers_$(BARRIERTYPE)"	
	# load all features for given spp scenario to barrier table, for all groups
	parallel --no-run-if-empty $(PSQL) -f $< -v wsg={1} ::: $(WSGS)
	# index barriers downstream
	$(PSQL) -c "drop table if exists bcfishpass.barriers_$(BARRIERTYPE)_dnstr"
	$(PSQL) -c "create table bcfishpass.barriers_$(BARRIERTYPE)_dnstr (barriers_$(BARRIERTYPE)_id text primary key, features_dnstr text[])"
	parallel --no-run-if-empty \
		"echo \"select bcfishpass.load_dnstr( \
		    'bcfishpass.barriers_$(BARRIERTYPE)',  \
		    'barriers_$(BARRIERTYPE)_id', \
		    'bcfishpass.barriers_$(BARRIERTYPE)',  \
		    'barriers_$(BARRIERTYPE)_id', \
		    'bcfishpass.barriers_$(BARRIERTYPE)_dnstr', \
		    'features_dnstr', \
		    'false', \
		    :'wsg');\" | \
		$(PSQL) -v wsg={1}" ::: $(WSGS)
	# remove non-minimal barriers
	echo "delete from bcfishpass.:table1 a \
		  using bcfishpass.:table2 b \
		  where a.:id = b.:id;" | \
		$(PSQL) -v id=barriers_$(BARRIERTYPE)_id -v table1=barriers_$(BARRIERTYPE) -v table2=barriers_$(BARRIERTYPE)_dnstr
	# drop the temp _dnstr table
	$(PSQL) -c "drop table bcfishpass.barriers_$(BARRIERTYPE)_dnstr"
	# note how much stream is upstream of the barriers
	$(PSQL) -f sql/add_length_upstream.sql -v src_id=barriers_$(BARRIERTYPE)_id -v src_table=barriers_$(BARRIERTYPE)
	touch $@

# ------------
# INDEX CROSSINGS
# ------------
# for crossings table, barriers_anthropogenic, note what barriers are upstream/downstream of each other
.make/index_crossings: $(ANTH_BARRIERS)
	# note all crossings downstream of a crossing
	$(PSQL) -c "truncate bcfishpass.crossings_dnstr_crossings"
	parallel --no-run-if-empty \
		"echo \"select bcfishpass.load_dnstr( \
		    'bcfishpass.crossings',  \
		    'aggregated_crossings_id', \
		    'bcfishpass.crossings', \
		    'aggregated_crossings_id', \
		    'bcfishpass.crossings_dnstr_crossings', \
		    'features_dnstr', \
		    'false', \
		    :'wsg');\" | \
		$(PSQL) -v wsg={1}" ::: $(WSGS)

	# note all anthropogenic barriers downstream of a crossing
	$(PSQL) -c "truncate bcfishpass.crossings_dnstr_barriers_anthropogenic"
	parallel --no-run-if-empty \
		"echo \"select bcfishpass.load_dnstr( \
		    'bcfishpass.crossings',  \
		    'aggregated_crossings_id', \
		    'bcfishpass.barriers_anthropogenic', \
		    'barriers_anthropogenic_id', \
		    'bcfishpass.crossings_dnstr_barriers_anthropogenic', \
		    'features_dnstr', \
		    'false', \
		    :'wsg');\" | \
		$(PSQL) -v wsg={1}" ::: $(WSGS)

	# note all anthropogenic barriers upstream of a crossing
	$(PSQL) -c "truncate bcfishpass.crossings_upstr_barriers_anthropogenic"
	parallel --no-run-if-empty \
		"echo \"select bcfishpass.load_upstr( \
		    'bcfishpass.crossings',  \
		    'aggregated_crossings_id', \
		    'bcfishpass.barriers_anthropogenic', \
		    'barriers_anthropogenic_id', \
		    'bcfishpass.crossings_upstr_barriers_anthropogenic', \
		    'features_upstr', \
		    'false', \
		    :'wsg');\" | \
		$(PSQL) -v wsg={1}" ::: $(WSGS)

	# note all anthropogenic barriers downstream of an anthropogenic barrier
	$(PSQL) -c "truncate bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic"
	parallel --no-run-if-empty \
		"echo \"select bcfishpass.load_dnstr( \
		    'bcfishpass.barriers_anthropogenic',  \
		    'barriers_anthropogenic_id', \
		    'bcfishpass.barriers_anthropogenic', \
		    'barriers_anthropogenic_id', \
		    'bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic', \
		    'features_dnstr', \
		    'false', \
		    :'wsg');\" | \
		$(PSQL) -v wsg={1}" ::: $(WSGS)

	touch $@

# intermediate target for proessing all of above, but not the model_access script
.make/model_access_prep: $(ACCESS_MODELS) .make/index_crossings
	touch $@

# run the access model
# (breaking streams and recording what is upstream/downstream of a given stream segment)
.make/model_access: .make/model_access_prep
	./model_access_1.sh
	./model_access_2.sh
	touch $@

.make/qa: .make/model_access
	cd qa; ./qa.sh
	touch $@