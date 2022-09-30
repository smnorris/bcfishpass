.PHONY: all clean
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
WSG=BULK HORS


# targets are listed here to create 'static pattern rules' - so they do not get ignored as intermediate steps
# https://stackoverflow.com/questions/23964228/make-ignoring-prerequisite-that-doesnt-exist

# define the make targets that flag when the table has been built
SOURCE_BARRIERS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/barriers_*.sql))
# combine barriers into tables of per-species scenarios, these will be points at which we break the streams
MODEL_BARRIERS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/model_barriers_*.sql))
# targets for breaking streams - above model_barriers (ie natural barriers) plus anthropogenic barriers
BROKEN = $(patsubst .make/model_barriers_%, .make/broken_%, $(MODEL_BARRIERS)) .make/broken_anthropogenic .make/broken_pscis .make/broken_remediated

MODEL_ACCESS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/model_access_*.sql))

all: .make/model_access

clean: 
	rm -Rf .make
	# remove tables?

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


# -----
# LOAD PER-SPECIES BARRIER TABLES - THE POINTS AT WHICH STREAMS WILL BE SEGMENTED (BREAKPTS)
# -----
# Combine definite barriers into a single table per each species/species group being modelled
# observations are a requirement because the query 
$(MODEL_BARRIERS): .make/model_barriers_%: sql/model_barriers_%.sql \
	$(SOURCE_BARRIERS)
	$(eval BARRIERTYPE=$(subst .make/model_barriers_,,$@))
	# create table if it does not exist
	echo "SELECT bcfishpass.create_barrier_table(:'barriertype')" | $(PSQL) -v barriertype=$(BARRIERTYPE)
	# clear the table
	$(PSQL) -c "truncate bcfishpass.barriers_$(BARRIERTYPE)"	
	# load all features for given spp scenario to barrier table, for all groups listed in parameters
	parallel --no-run-if-empty $(PSQL) -f $< -v wsg={1} ::: $(WSG)
	# index downstream
	python upstr_dnstr_ids.py add-downstream-ids \
		bcfishpass.barriers_$(BARRIERTYPE) \
		barriers_$(BARRIERTYPE)_id \
		bcfishpass.barriers_$(BARRIERTYPE) \
		barriers_$(BARRIERTYPE)_id \
		barriers_$(BARRIERTYPE)_dnstr
	# remove non-minimal barriers
	echo "DELETE FROM bcfishpass.:table WHERE :id IS NOT NULL" | \
		$(PSQL) -v id=barriers_$(BARRIERTYPE)_dnstr -v table=barriers_$(BARRIERTYPE)
	# add upstream length summary to the table for QA of high impact barriers
	$(PSQL) -f sql/add_length_upstream.sql \
		-v src_table=barriers_$(BARRIERTYPE) \
		-v src_id=barriers_$(BARRIERTYPE)_id
	touch $@

# tag these tables as additional sources for breaking streams (beyond the above definite barriers)
.make/model_barriers_anthropogenic:
	touch $@
.make/model_barriers_pscis:
	touch $@
.make/model_barriers_remediated:
	touch $@

# -----
# LOAD STREAMS
# -----
.make/streams: sql/load_streams.sql
	$(PSQL) -c "truncate bcfishpass.streams"
	parallel $(PSQL) -f $< -v wsg={1} ::: $(WSG)
	$(PSQL) -c "CREATE INDEX IF NOT EXISTS streams_lfeatid_idx ON bcfishpass.streams (linear_feature_id);"
	$(PSQL) -c "CREATE INDEX IF NOT EXISTS streams_blkey_idx ON bcfishpass.streams (blue_line_key);"
	$(PSQL) -c "CREATE INDEX IF NOT EXISTS streams_wsg_idx ON bcfishpass.streams (watershed_group_code);"
	$(PSQL) -c "CREATE INDEX IF NOT EXISTS streams_wbkey_idx ON bcfishpass.streams (waterbody_key);"
	$(PSQL) -c "CREATE INDEX IF NOT EXISTS streams_wsc_gidx ON bcfishpass.streams USING GIST (wscode_ltree);"
	$(PSQL) -c "CREATE INDEX IF NOT EXISTS streams_wsc_bidx ON bcfishpass.streams USING BTREE (wscode_ltree);"
	$(PSQL) -c "CREATE INDEX IF NOT EXISTS streams_lc_gidx ON bcfishpass.streams USING GIST (localcode_ltree);"
	$(PSQL) -c "CREATE INDEX IF NOT EXISTS streams_lc_bidx ON bcfishpass.streams USING BTREE (localcode_ltree);"
	$(PSQL) -c "CREATE INDEX IF NOT EXISTS streams_geom_idx ON bcfishpass.streams USING GIST (geom);"
	$(PSQL) -c "VACUUM ANALYZE bcfishpass.streams"
	touch $@

# -----
# BREAK STREAMS
# -----
# Break streams at various barrier types and observations, plus at anthropogenic barriers
# Processing in parallel (provincially) eventually crashes the db, process one group at a time or with a modest job count
$(BROKEN): .make/broken_%: .make/model_barriers_% .make/streams
	$(eval BARRIERTYPE=$(subst .make/model_barriers_,,$<))
	parallel --jobs 4 --no-run-if-empty \
		"echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
		$(PSQL) -v wsg={1} -v point_table=barriers_$(BARRIERTYPE)" ::: $(WSG)
	# concurrent updates lock the db, process each wsg individually
	for wsg in $(WSG) ; do \
		set -e ; $(PSQL) -f sql/update_barriers_dnstr_wrapper.sql \
		-v target_table=streams \
		-v target_table_id=segmented_stream_id \
		-v barriertype=$(BARRIERTYPE) \
		-v point_table=barriers_$(BARRIERTYPE) \
		-v include_equivalents=true \
		-v wsg=$$wsg ;\
	done
	touch $@

# break streams and index at all observations (of target species)
.make/broken_observations: .make/streams
	parallel --jobs 4 --no-run-if-empty \
		$(PSQL) -f sql/break_streams_wrapper.sql \
		-v wsg={1} \
		-v point_table=$(subst .make/,,$<) ::: $(WSG)
	parallel --jobs 4 --no-run-if-empty \
		$(PSQL) -f sql/update_observations_upstr.sql \
		-v wsg={1} ::: $(WSG)
	touch $@

# -----
# PROCESS MODEL
# -----
# with all barriers and observations processed, apply each access model with corresponding query
$(MODEL_ACCESS): .make/model_access_%: sql/model_access_%.sql $(BROKEN) .make/broken_observations
	for wsg in $(WSG) ; do \
		set -e ; $(PSQL) -f $< -v wsg=$$wsg ; \
	done
	touch $@

# a single output target for root makefile
.make/model_access: $(MODEL_ACCESS)
	touch $@