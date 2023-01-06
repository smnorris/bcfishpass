.PHONY: all clean
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")


# targets are listed here to create 'static pattern rules' - so they do not get ignored as intermediate steps
# https://stackoverflow.com/questions/23964228/make-ignoring-prerequisite-that-doesnt-exist

# define the make targets that flag when the table has been built
SOURCE_BARRIERS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/barriers_*.sql))

# combine barriers into tables of per-species scenarios, these will be points at which we break the streams
MODEL_BARRIERS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/model_barriers_*.sql))


all: .make/model_access

clean: 
	rm -Rf .make

# -----
# LOAD BARRIER TYPE TABLES
# -----
# Create standardized barrier tables, one per type of barrier. 
# Process every file that matches the pattern sql/barriers_%.sql
$(SOURCE_BARRIERS): .make/barriers_%: sql/barriers_%.sql
	mkdir -p .make
	$(eval BARRIERTYPE=$(subst .make/barriers_,,$@))
	# create the table if it does not exist
	echo "SELECT bcfishpass.create_barrier_table(:'barriertype')" | \
		$(PSQL) -v barriertype=$(BARRIERTYPE)
	# clear barrier table
	$(PSQL) -c "truncate bcfishpass.barriers_$(BARRIERTYPE)"
	# load data to barrier table in parallel
	parallel $(PSQL) -f sql/barriers_$(BARRIERTYPE).sql -v wsg={1} ::: $(WSG)
	touch $@


# ------------
# INDEX CROSSINGS
# ------------
.make/index_crossings: .make/barriers_anthropogenic
	# note all crossings downstream of a crossing
	$(PSQL) -c "drop table if exists bcfishpass.crossings_dnstr_crossings"
	$(PSQL) -c "create table bcfishpass.crossings_dnstr_crossings (aggregated_crossings_id text primary key, features_dnstr text[])"
	parallel --no-run-if-empty \
		"echo \"SELECT bcfishpass.load_dnstr( \
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
		"echo \"SELECT bcfishpass.load_dnstr( \
		    'bcfishpass.crossings',  \
		    'aggregated_crossings_id', \
		    'bcfishpass.barriers_anthropogenic', \
		    'barriers_anthropogenic_id', \
		    'bcfishpass.crossings_dnstr_barriers_anthropogenic', \
		    'features_dnstr', \
		    'false', \
		    :'wsg');\" | \
		$(PSQL) -v wsg={1}" ::: $(WSG)

	# note all anthropogenic barriers downstream of an anthropogenic barrier
	$(PSQL) -c "drop table if exists bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic"
	$(PSQL) -c "create table bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic (barriers_anthropogenic_id text primary key, features_dnstr text[])"
	parallel --no-run-if-empty \
		"echo \"SELECT bcfishpass.load_dnstr( \
		    'bcfishpass.barriers_anthropogenic',  \
		    'barriers_anthropogenic_id', \
		    'bcfishpass.barriers_anthropogenic', \
		    'barriers_anthropogenic_id', \
		    'bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic', \
		    'features_dnstr', \
		    'false', \
		    :'wsg');\" | \
		$(PSQL) -v wsg={1}" ::: $(WSG)

	# note all anthropogenic barriers upstream of a crossing
	$(PSQL) -c "drop table if exists bcfishpass.crossings_upstr_barriers_anthropogenic"
	$(PSQL) -c "create table bcfishpass.crossings_upstr_barriers_anthropogenic (aggregated_crossings_id text primary key, features_upstr text[])"
	parallel --no-run-if-empty \
		"echo \"SELECT bcfishpass.load_upstr( \
		    'bcfishpass.crossings',  \
		    'aggregated_crossings_id', \
		    'bcfishpass.barriers_anthropogenic', \
		    'barriers_anthropogenic_id', \
		    'bcfishpass.crossings_upstr_barriers_anthropogenic', \
		    'features_upstr', \
		    'false', \
		    :'wsg');\" | \
		$(PSQL) -v wsg={1}" ::: $(WSG)


# -----
# LOAD PER-SPECIES BARRIER TABLES (the points at which streams will be segmented)
# -----
# Combine definite barriers into a single table per each species/species group being modelled
# Note that observations are a requirement 
$(MODEL_BARRIERS): .make/model_barriers_%: sql/model_barriers_%.sql \
	$(SOURCE_BARRIERS) \
	../../.make/observations
	$(eval BARRIERTYPE=$(subst .make/model_barriers_,,$@))
	# create table if it does not exist
	echo "SELECT bcfishpass.create_barrier_table(:'barriertype')" | $(PSQL) -v barriertype=$(BARRIERTYPE)
	# clear the table
	$(PSQL) -c "truncate bcfishpass.barriers_$(BARRIERTYPE)"	
	# load all features for given spp scenario to barrier table, for all groups listed in parameters
	parallel --no-run-if-empty $(PSQL) -f $< -v wsg={1} ::: $(WSG)
	# index barriers downstream
	$(PSQL) -c "drop table if exists bcfishpass.barriers_$(BARRIERTYPE)_dnstr"
	$(PSQL) -c "create table bcfishpass.barriers_$(BARRIERTYPE)_dnstr (barriers_$(BARRIERTYPE)_id text primary key, features_dnstr text[])"
	parallel --no-run-if-empty \
		"echo \"SELECT bcfishpass.load_dnstr( \
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
	echo "DELETE FROM bcfishpass.:table WHERE :id IS NOT NULL" | \
		$(PSQL) -v id=barriers_$(BARRIERTYPE)_dnstr -v table=barriers_$(BARRIERTYPE)
	# add upstream length summary to the table for QA of high impact barriers
	$(PSQL) -f sql/add_length_upstream.sql \
		-v src_table=barriers_$(BARRIERTYPE) \
		-v src_id=barriers_$(BARRIERTYPE)_id
	touch $@


# run the access model 
# (breaking streams and recording what is upstream/downstream of a given stream segment)
.make/model_access: $(MODEL_BARRIERS) 
	./model_access.sh
	touch $@