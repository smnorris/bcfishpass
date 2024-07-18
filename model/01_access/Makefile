.PHONY: all clean
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors

# process all watershed groups listed in parameters_method
WSGS = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

# define barrier table targets
NATURAL_BARRIERS = .make/barriers_falls \
	.make/barriers_subsurfaceflow \
	.make/barriers_user_definite \
	.make/barriers_gradient
ANTH_BARRIERS = .make/barriers_anthropogenic \
	.make/barriers_dams \
	.make/barriers_dams_hydro \
	.make/barriers_pscis

# access models - combine barriers into tables of per-species scenarios
ACCESS_MODELS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/model_access_*.sql))

all: .make/access_prep

clean: 
	rm -Rf .make

# -----
# LOAD BARRIER TYPE TABLES
# -----
# Create standardized barrier tables for natural barriers
$(NATURAL_BARRIERS): sql/barriers_falls.sql \
	sql/barriers_subsurfaceflow.sql \
	sql/barriers_user_definite.sql \
	sql/barriers_gradient.sql
	mkdir -p .make
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
$(ANTH_BARRIERS): sql/barriers_anthropogenic.sql \
	sql/barriers_dams.sql \
	sql/barriers_dams_hydro.sql \
	sql/barriers_pscis.sql
	mkdir -p .make
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
# (but this is presumed to already be present)
$(ACCESS_MODELS): .make/model_access_%: sql/model_access_%.sql \
	$(NATURAL_BARRIERS)
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

# target for all
.make/access_prep: $(ACCESS_MODELS) .make/index_crossings
	touch $@
