.PHONY: all clean
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds where watershed_group_code in ('VICT','COWN','SANJ')")


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
# with table barriers_anthropogenic created above, we can now index the crossings table,
# based anthropogenic barriers upstream/downstream (plus other crossings upstream/downstream)
.make/index_crossings: .make/barriers_anthropogenic
	python upstr_dnstr_ids.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.crossings aggregated_crossings_id crossings_dnstr
	python upstr_dnstr_ids.py add-downstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id barriers_anthropogenic_dnstr
	python upstr_dnstr_ids.py add-upstream-ids bcfishpass.crossings aggregated_crossings_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id barriers_anthropogenic_upstr
	$(PSQL) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS barriers_anthropogenic_dnstr_count integer"
	$(PSQL) -c "UPDATE bcfishpass.crossings SET barriers_anthropogenic_dnstr_count = array_length(barriers_anthropogenic_dnstr, 1) WHERE barriers_anthropogenic_dnstr IS NOT NULL";
	$(PSQL) -c "ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS barriers_anthropogenic_upstr_count integer"
	$(PSQL) -c "UPDATE bcfishpass.crossings SET barriers_anthropogenic_upstr_count = array_length(barriers_anthropogenic_upstr, 1) WHERE barriers_anthropogenic_upstr IS NOT NULL";
	# document the new columns
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.crossings_dnstr IS 'List of the aggregated_crossings_id values of crossings downstream of the given crossing, in order downstream';"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_dnstr IS 'List of the aggregated_crossings_id values of barrier crossings downstream of the given crossing, in order downstream';"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_dnstr_count IS 'A count of the barrier crossings downstream of the given crossing';"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_upstr IS 'List of the aggregated_crossings_id values of barrier crossings upstream of the given crossing';"
	$(PSQL) -c "COMMENT ON COLUMN bcfishpass.crossings.barriers_anthropogenic_upstr_count IS 'A count of the barrier crossings upstream of the given crossing';"

	# also index the barriers_anthropogenic table
	python upstr_dnstr_ids.py add-downstream-ids bcfishpass.barriers_anthropogenic barriers_anthropogenic_id bcfishpass.barriers_anthropogenic barriers_anthropogenic_id barriers_anthropogenic_dnstr
	$(PSQL) -c "VACUUM ANALYZE bcfishpass.crossings"
	$(PSQL) -c "VACUUM ANALYZE bcfishpass.barriers_anthropogenic"
	touch $@


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


# run the access model 
# (breaking streams and recording what is upstream/downstream of a given stream segment)
.make/model_access: $(MODEL_BARRIERS) 
	./model_access.sh
	touch $@