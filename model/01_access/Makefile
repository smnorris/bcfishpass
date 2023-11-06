.PHONY: all clean
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors

# process all watershed groups
WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")

# define the make targets that flag when the table has been built
SOURCE_BARRIERS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/barriers_*.sql))

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
	.make/gradient_barriers
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
	# load all features for given spp scenario to barrier table, for all groups
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