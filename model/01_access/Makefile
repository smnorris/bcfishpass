.PHONY: all clean
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors

# process all watershed groups
WSGS = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")
# test with just watershed groups noted in param (misses cross-wsg barreriers)
#WSGS = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

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

# SOURCE_BARRIERS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/barriers_*.sql))

# access models - combine barriers into tables of per-species scenarios
ACCESS_MODELS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/model_access_*.sql))


all: .make/qa

clean: 
	rm -Rf .make


# ------
# FALLS
# ------
.make/falls: falls/falls.sh \
	falls/sql/falls.sql
	mkdir -p .make
	cd falls; ./falls.sh
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
.make/dams:  dams/dams.sh dams/sql/dams.sql
	mkdir -p .make
	cd dams; ./dams.sh
	touch $@

# ------
# MODELLED ROAD-STREAM CROSSINGS
# ------
# Load modelled crossings from archive posted to s3 (this ensures consistent modelled crossing ids for all users)
.make/modelled_stream_crossings:
	mkdir -p .make
	cd modelled_stream_crossings; make .make/download_archive
	cd modelled_stream_crossings; make .make/download_bcdata # also download roads/railways for reference
	touch $@

# ------
# PSCIS STREAM CROSSINGS
# ------
.make/pscis: .make/modelled_stream_crossings
	mkdir -p .make
	cd pscis; ./pscis.sh
	touch $@

# ------
# map tile index
# ------
.make/dbm_mof_50k_grid:
	mkdir -p .make
	bcdata bc2pg WHSE_BASEMAPPING.DBM_MOF_50K_GRID
	touch $@

# -----
# CROSSINGS
# -----
# combine modelled crossings, pscis, dams into bcfishpass.crossings
.make/crossings: .make/dams \
	.make/pscis \
	.make/dbm_mof_50k_grid \
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

# -------------------------------------------------------------------------------------
# download pre-computed precip/discharge/channel width and load to db
# (required for inclusion in bcfishpass.streams)
# this can be removed with fix of #344, or at least moving this download into fwapg
# -------------------------------------------------------------------------------------
.make/data:
	mkdir -p data
	wget -qNP data https://bcfishpass.s3.us-west-2.amazonaws.com/channel_width.csv
	wget -qNP data https://bcfishpass.s3.us-west-2.amazonaws.com/mean_annual_precip.csv
	wget -qNP data https://bcfishpass.s3.us-west-2.amazonaws.com/discharge.csv
	$(PSQL) -f sql/load_map_mad_cw.sql
	# because we are downloading these files rather than building from scratch,
	# create the make targets so habitat script does not try and build
	mkdir -p ../02_habitat_linear/precipitation/.make
	touch ../02_habitat_linear/precipitation/.make/precip
	mkdir -p ../02_habitat_linear/channel_width/.make
	touch ../02_habitat_linear/channel_width/.make/channel_width
	mkdir -p ../02_habitat_linear/discharge/.make
	touch ../02_habitat_linear/discharge/.make/discharge
	touch $@
# -------------------------------------------------------------------------------------

# intermediate target for proessing all of above, but not the model_access script
.make/model_access_prep: $(ACCESS_MODELS) .make/index_crossings .make/data
	touch $@

# run the access model
# (breaking streams and recording what is upstream/downstream of a given stream segment)
.make/model_access: .make/model_access_prep
	./model_access.sh
	touch $@

.make/qa: .make/model_access
	cd qa; ./qa.sh
	touch $@