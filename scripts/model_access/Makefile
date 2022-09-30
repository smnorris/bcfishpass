.PHONY: all
.SECONDARY:  # do not delete intermediate targets

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
WSG=BULK HORS


# targets are listed here to create 'static pattern rules' - so they do not get ignored as intermediate steps
# https://stackoverflow.com/questions/23964228/make-ignoring-prerequisite-that-doesnt-exist

# define the make targets that flag when the table has been built
BARRIERS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/barriers_*.sql))
# combine barriers into tables of per-species scenarios, these will be points at which we break the streams
BREAKPTS = $(patsubst sql/%.sql, .make/%, $(wildcard sql/breakpts_*.sql))


all: $(BARRIERS) $(BREAKPTS)

# -----
# LOAD BARRIER TYPE TABLES
# -----
# Create standardized barrier tables, one per type of barrier. 
# Process every file that matches the pattern sql/barriers_%.sql
$(BARRIERS): .make/barriers_%: sql/barriers_%.sql
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
$(BREAKPTS): .make/breakpts_%: sql/breakpts_%.sql \
	$(BARRIERS)
	$(eval BARRIERTYPE=$(subst .make/breakpts_,,$@))
	# create table if it does not exist
	echo "SELECT bcfishpass.create_barrier_table(:'barriertype')" | $(PSQL) -v barriertype=$(BARRIERTYPE)
	# clear the table
	$(PSQL) -c "truncate bcfishpass.barriers_$(BARRIERTYPE)"	
	# load all features for given spp scenario to barrier table, for all groups listed in parameters
	parallel --no-run-if-empty $(PSQL) -f $< -v wsg={1} ::: $(WSG)
	# index downstream
	python bcfishpass.py add-downstream-ids \
		bcfishpass.barriers_$(BARRIERTYPE) barriers_$(BARRIERTYPE)_id bcfishpass.barriers_$(BARRIERTYPE) barriers_$(BARRIERTYPE)_id barriers_$(BARRIERTYPE)_dnstr
	# remove non-minimal barriers
	echo "DELETE FROM bcfishpass.:table WHERE :id IS NOT NULL" | \
		$(PSQL) -v id=barriers_$(BARRIERTYPE)_dnstr -v table=barriers_$(BARRIERTYPE)
	# add upstream length summary to the table for QA of high impact barriers
	$(PSQL) -f sql/add_length_upstream.sql \
		-v src_table=barriers_$(BARRIERTYPE) \
		-v src_id=barriers_$(BARRIERTYPE)_id
	touch $@