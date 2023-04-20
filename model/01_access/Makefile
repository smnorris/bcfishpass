.PHONY: all clean
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors

# process only watershed groups noted in wsg.txt
WSG = $(shell cat wsg.txt)

# define the make targets that flag when the table has been built
SOURCE_BARRIERS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/barriers_*.sql))

# access models - combine barriers into tables of per-species scenarios
ACCESS_MODELS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/model_access_*.sql))

# add length upstream columns to each per-species set of barriers
ADD_LENGTH_UPSTREAM = $(patsubst sql/model_access_%.sql, .make/add_length_upstream_%, $(wildcard sql/model_access_*.sql))


all: $(ADD_LENGTH_UPSTREAM)

clean: 
	rm -Rf .make


# ------
# FALLS
# ------
.make/falls:  .make/data \
	falls/falls.sh \
	falls/sql/falls.sql
	cd falls; ./falls.sh
	touch $@

# ------
# GRADIENT BARRIERS
# ------
# Generate all gradient barriers at 5/10/15/20/25/30% thresholds.
gradient_barriers/.make/gradient_barriers:
	cd gradient_barriers; make

# ------
# DAMS
# ------
.make/dams:  dams/dams.sh dams/sql/dams.sql
	cd dams; ./dams.sh
	touch $@

# ------
# MODELLED ROAD-STREAM CROSSINGS
# ------
# Load modelled crossings from archive posted to s3 (this ensures consistent modelled crossing ids for all users)
.make/modelled_stream_crossings:
	cd modelled_stream_crossings; make .make/download_archive
	cd modelled_stream_crossings; make .make/download_bcdata # also download roads/railways for reference
	touch $@

# ------
# PSCIS STREAM CROSSINGS
# ------
.make/pscis: .make/data \
 	.make/modelled_stream_crossings
	cd pscis; ./pscis.sh
	touch $@

# -----
# CROSSINGS
# -----
# combine modelled crossings, pscis, dams into bcfishpass.crossings
.make/crossings: .make/dams \
	.make/pscis \
	sql/crossings.sql
	$(PSQL) -f sql/crossings.sql
	touch $@

# -----
# OBSERVATIONS
# -----
# load observations of all spp of interest from bcfishobs to bcfishpass.observations
.make/observations: sql/observations.sql
	$(PSQL) -f $^ 
	touch $@

# -----
# LOAD BARRIER TYPE TABLES
# -----
# Create standardized barrier tables, one per type of barrier. 
# Process every file that matches the pattern sql/barriers_%.sql
$(SOURCE_BARRIERS): .make/barriers_%: sql/barriers_%.sql \
	.make/crossings \
	.make/falls \
	gradient_barriers/.make/gradient_barriers \
	.make/data
	$(eval BARRIERTYPE=$(subst .make/barriers_,,$@))
	# create the table if it does not exist
	echo "select bcfishpass.create_barrier_table(:'barriertype')" | \
		$(PSQL) -v barriertype=$(BARRIERTYPE)
	# clear barrier table
	$(PSQL) -c "truncate bcfishpass.barriers_$(BARRIERTYPE)"
	# load data to barrier table in parallel
	parallel $(PSQL) -f sql/barriers_$(BARRIERTYPE).sql -v wsg={1} ::: $(WSG)
	touch $@

# -----
# LOAD PER-SPECIES BARRIER TABLES 
# -----
# Combine all potential definite/natural barriers into a single table per each species/species 
# group being modelled, then retain only the records with no other records downstream (ie, only
# the lowest in the system)
# Note that observations are a requirement because they can be used to cancel natural barriers
$(ACCESS_MODELS): .make/model_access_%: sql/model_access_%.sql \
	$(SOURCE_BARRIERS) \
	.make/observations
	$(eval BARRIERTYPE=$(subst .make/model_access_,,$@))
	# create table if it does not exist
	echo "select bcfishpass.create_barrier_table(:'barriertype')" | $(PSQL) -v barriertype=$(BARRIERTYPE)
	# clear the table
	$(PSQL) -c "truncate bcfishpass.barriers_$(BARRIERTYPE)"	
	# load all features for given spp scenario to barrier table, for all groups listed in parameters
	parallel --no-run-if-empty $(PSQL) -f $< -v wsg={1} ::: $(WSG)
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
		$(PSQL) -v wsg={1}" ::: $(WSG)
	# remove non-minimal barriers
	echo "delete from bcfishpass.:table1 a \
		  using bcfishpass.:table2 b \
		  where a.:id = b.:id;" | \
		$(PSQL) -v id=barriers_$(BARRIERTYPE)_id -v table1=barriers_$(BARRIERTYPE) -v table2=barriers_$(BARRIERTYPE)_dnstr
	# drop the temp _dnstr table
	$(PSQL) -c "drop table bcfishpass.barriers_$(BARRIERTYPE)_dnstr"
	touch $@

# ------------
# INDEX CROSSINGS
# ------------
# for crossings table, barriers_anthropogenic, note what barriers are upstream/downstream of each other
.make/index_crossings: .make/barriers_anthropogenic
	# note all crossings downstream of a crossing
	$(PSQL) -c "drop table if exists bcfishpass.crossings_dnstr_crossings"
	$(PSQL) -c "create table bcfishpass.crossings_dnstr_crossings (aggregated_crossings_id text primary key, features_dnstr text[])"
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
		$(PSQL) -v wsg={1}" ::: $(WSG)

	# note all anthropogenic barriers downstream of a crossing
	$(PSQL) -c "drop table if exists bcfishpass.crossings_dnstr_barriers_anthropogenic"
	$(PSQL) -c "create table bcfishpass.crossings_dnstr_barriers_anthropogenic (aggregated_crossings_id text primary key, features_dnstr text[])"
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
		$(PSQL) -v wsg={1}" ::: $(WSG)

	# note all anthropogenic barriers upstream of a crossing
	$(PSQL) -c "drop table if exists bcfishpass.crossings_upstr_barriers_anthropogenic"
	$(PSQL) -c "create table bcfishpass.crossings_upstr_barriers_anthropogenic (aggregated_crossings_id text primary key, features_upstr text[])"
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
		$(PSQL) -v wsg={1}" ::: $(WSG)

	# note all anthropogenic barriers downstream of an anthropogenic barrier
	$(PSQL) -c "drop table if exists bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic"
	$(PSQL) -c "create table bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic (barriers_anthropogenic_id text primary key, features_dnstr text[])"
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
		$(PSQL) -v wsg={1}" ::: $(WSG)

	# load data from _dnstr _upstr lookups back into the main tables, drop the lookups
	$(PSQL) -f sql/index_crossings.sql
	touch $@

# run the access model 
# (breaking streams and recording what is upstream/downstream of a given stream segment)
.make/model_access: $(ACCESS_MODELS) .make/index_crossings
	./model_access.sh
	touch $@

# for quick id and QA of high impact natural barriers,
# add total upstream length column to each model_access_<spp> table
$(ADD_LENGTH_UPSTREAM): .make/add_length_upstream_%: sql/model_access_%.sql .make/model_access sql/add_length_upstream.sql
	$(eval SPP=$(subst .make/add_length_upstream_,,$@))
	$(PSQL) -f sql/add_length_upstream.sql \
		-v src_table=barriers_$(SPP) \
		-v src_id=barriers_$(SPP)_id
	touch $@

# -----
# QA REPORTS
# -----
$(QA_ACCESS_OUTPUTS): reports/access/%.csv: reports/access/sql/%.sql \
	model/access/.make/model_access
	psql2csv $(DATABASE_URL) < $< > $@

# just a target to build all access reports
.make/model_access_reports: $(QA_ACCESS_OUTPUTS)
	touch $@

