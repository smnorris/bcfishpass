.PHONY: all clean settings

PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
DATA_FILES=$(wildcard data/*.csv)                         # find all user input data in .csv files
DATA_FILE_TARGETS=$(patsubst data/%.csv,.%,$(DATA_FILES)) # parse csv file names into .hidden make targets

# specify all make targets
GENERATED_FILES=.fwapg .bcfishobs .ddl $(DATA_FILE_TARGETS) .falls .dams .gradient_barriers .modelled_stream_crossings .pscis

# Make all targets
all: $(GENERATED_FILES)

# Remove all generated targets
clean:
	rm -Rf fwapg
	rm -Rf bcfishobs
	cd scripts/load/modelled_stream_crossings; make clean
	rm -Rf $(GENERATED_FILES)


# *********************************************************
# **                                                     **
# ** LOAD DATA FROM OTHER REPOSITORIES (fwapg/bcfishobs) **
# **                                                     **
# *********************************************************
fwapg:
	git clone https://github.com/smnorris/fwapg.git

.fwapg: fwapg
	cd fwapg; make
	touch $@

bcfishobs: .fwapg
	git clone https://github.com/smnorris/bcfishobs.git

.bcfishobs: bcfishobs
	cd bcfishobs; make
	touch $@


# ***********************************************
# **                                           **
# **      LOAD/PROCESS REQUIRED DATASETS       **
# **                                           **
# ***********************************************

# ------
# CREATE DATABASE STRUCTURE
# ------
.ddl: .fwapg
	$(PSQL_CMD) -c "CREATE SCHEMA IF NOT EXISTS bcfishpass"
	$(PSQL_CMD) -f scripts/load/data_files/sql/data_files.sql
	touch $@

# ------
# LOAD USER EDITABLE DATA FILES (all csv files in /data folder)
# ------
$(DATA_FILE_TARGETS): $(DATA_FILES) .ddl
	$(PSQL_CMD) -c "DELETE FROM bcfishpass$@;"
	$(PSQL_CMD) -c "\copy bcfishpass$@ FROM 'data/$(subst .,,$@).csv' delimiter ',' csv header"
	touch $@

# ------
# FALLS
# ------
# This relatively small table can get regenerated any time source csvs have changed,
# the csv allows for adding features and it is convenient to have barrier status in the
# source falls table
.falls: .fwapg $(wildcard $(DATAPATH)/falls/*.csv)
	cd scripts/load/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# ------
# DAMS
# ------
# Dams are simple - no lookups required - but note that this table is a source for definite
# barriers *and* anthropogenic barriers. Delete the .dams target file if an update is required.
# (todo - consider consolidating CWF dams.geojson into the bcfishpass data folder so updates
# are easily picked up)
.dams: .fwapg
	cd scripts/load/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# ------
# GRADIENT BARRIERS
# ------
# Generate all gradient barriers at 5/10/15/20/25/30% thresholds.
# This takes a little while but only needs to be done once
.gradient_barriers: .fwapg
	cd scripts/load/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# ------
# MODELLED STREAM CROSSINGS
# ------
# Create intersection points of road/railroads and streams, the post-process to ensure
# unique crossings
.modelled_stream_crossings: .fwapg
	cd scripts/load/modelled_stream_crossings; make
	touch $@

# ------
# PSCIS
# ------
# PSCIS processing depends on modelled stream crosssings output being present
.pscis: .fwapg .modelled_stream_crossings
	cd scripts/load/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@


# ***********************************************
# **                                           **
# **      CREATE/UPDATE ACCESS MODEL           **
# **                                           **
# ***********************************************
