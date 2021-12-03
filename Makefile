.PHONY: all clean settings

PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
DATA_FILES=$(wildcard data/*.csv)                         # find all user input data in .csv files
DATA_FILE_TARGETS=$(patsubst data/%.csv,.%,$(DATA_FILES)) # parse csv file names into .hidden make targets

# specify all make targets
GENERATED_FILES=.fwapg .bcfishobs .ddl $(DATA_FILE_TARGETS) .falls .dams .gradient_barriers .modelled_stream_crossings .pscis

GROUPS = $(shell $(PSQL_CMD) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")

# Make all targets
all: $(GENERATED_FILES)

# Remove all generated targets
clean:
	rm -Rf fwapg
	rm -Rf bcfishobs
	cd scripts/modelled_stream_crossings; make clean
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
.ddl:
	$(PSQL_CMD) -f scripts/db/sql/user_data.sql
	$(PSQL_CMD) -f scripts/db/sql/utmzone.sql
	touch $@

# ------
# LOAD USER EDITABLE DATA FILES (all csv files in /data folder)
# ------
$(DATA_FILE_TARGETS): $(DATA_FILES) .ddl
	$(PSQL_CMD) -c "DELETE FROM bcfishpass$@;"
	$(PSQL_CMD) -c "\copy bcfishpass$@ FROM 'data/$(subst .,,$@).csv' delimiter ',' csv header"
	touch $@

# ------
# LOAD PARAMETERS
# ------
.parameters: parameters/watersheds.csv parameters/habitat.csv .ddl
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.param_watersheds;"
	$(PSQL_CMD) -c "DELETE FROM bcfishpass.param_habitat;"
	$(PSQL_CMD) -c "\copy bcfishpass.param_watersheds FROM 'parameters/watersheds.csv' delimiter ',' csv header"
	$(PSQL_CMD) -c "\copy bcfishpass.param_habitat FROM 'parameters/habitat.csv' delimiter ',' csv header"
	touch $@

# ------
# FALLS
# ------
# This relatively small table can get regenerated any time source csvs have changed,
# the csv allows for adding features and it is convenient to have barrier status in the
# source falls table
.falls: .fwapg $(wildcard $(DATAPATH)/falls/*.csv)
	cd scripts/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# ------
# DAMS
# ------
# Dams are simple - no lookups required - but note that this table is a source for definite
# barriers *and* anthropogenic barriers. Delete the .dams target file if an update is required.
# (todo - consider consolidating CWF dams.geojson into the bcfishpass data folder so updates
# are easily picked up)
.dams: .fwapg
	cd scripts/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# ------
# GRADIENT BARRIERS
# ------
# Generate all gradient barriers at 5/10/15/20/25/30% thresholds.
# This takes a little while but only needs to be done once
.gradient_barriers: .fwapg
	cd scripts/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# ------
# MODELLED STREAM CROSSINGS
# ------
# Create intersection points of road/railroads and streams, the post-process to ensure
# unique crossings
.modelled_stream_crossings: .fwapg
	cd scripts/modelled_stream_crossings; make
	touch $@

# ------
# PSCIS
# ------
# PSCIS processing depends on modelled stream crosssings output being present
.pscis: .fwapg .modelled_stream_crossings
	cd scripts/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

# ------
# OBSERVATIONS
# ------
# extract FISS observations for species of interest from bcfishobs
.observations: .fwapg .bcfishobs .parameters
	$(PSQL_CMD) -f scripts/db/sql/$(subst .,,$@).sql
	touch $@

# -----
# CROSSINGS
# consolidate all dams/pscis/modelled crossings/misc anthropogenic barriers into one table
# TODO - could this be a view? It only taks ~4min to generate so probably not important.
# -----
.crossings: .pscis .modelled_stream_crossings .dams .misc_barriers_anthropogenic
	$(PSQL_CMD) -f scripts/model_access/sql/$(subst .,,$@).sql
	touch $@

# ***********************************************
# **                                           **
# **      CREATE/UPDATE ACCESS MODEL           **
# **                                           **
# ***********************************************

# above data sources are all compiled provincially
# below jobs are run for watersheds specified in parameters only

# -----
# INITIAL STREAM DATA LOAD
# -----
# what streams get loaded depends on wsg listed in parameters
.segmented_streams: .parameters
	$(PSQL_CMD) -f scripts/db/sql/segmented_streams.sql
	touch $@

# -----
# DEFINITE BARRIERS
# create table for each type of definite (not generally fixable) barrier
# (targets grouped by data source)
# -----
.defbarriers_majordams: .dams
	$(PSQL_CMD) -f scripts/model_access/sql/barriers_majordams.sql
	touch $@
.defbarriers_fwa: .parameters
	$(PSQL_CMD) -f scripts/model_access/sql/barriers_ditchflow.sql
	$(PSQL_CMD) -f scripts/model_access/sql/barriers_intermittentflow.sql
	$(PSQL_CMD) -f scripts/model_access/sql/barriers_subsurfaceflow.sql
	touch $@
.defbarriers_falls: .falls
	$(PSQL_CMD) -f scripts/model_access/sql/barriers_falls.sql
	touch $@
.defbarriers_gradient: .gradient_barriers
	$(PSQL_CMD) -f scripts/model_access/sql/barriers_gradient_15.sql
	$(PSQL_CMD) -f scripts/model_access/sql/barriers_gradient_20.sql
	$(PSQL_CMD) -f scripts/model_access/sql/barriers_gradient_30.sql
	touch $@
.defbarriers_other: .exclusions .misc_barriers_definite .pscis_barrier_result_fixes
	$(PSQL_CMD) -f scripts/model_access/sql/barriers_other_definite.sql
	touch $@
# just a catch all target for above
.definite_barriers: .defbarriers_majordams .defbarriers_fwa .defbarriers_falls .defbarriers_gradient .defbarriers_other
	touch $@


# -----
# BREAK STREAMS
# -----
# merge all point features into a single view and break streams at intersections
# note that this will only pick up breakpoints that are 1m from existing breaks in the streams,
# re-runs with minor updates will be very quick
.break_streams: .segmented_streams .observations .defbarriers_majordams .falls .defbarriers_gradient .defbarriers_other .crossings
	$(PSQL_CMD) -f scripts/model_access/sql/breakpoints_vw.sql
	parallel $(PSQL_CMD) -f scripts/model_access/sql/00_segment_streams.sql -v wsg={1} ::: $(GROUPS)
	touch $@

# ------
# Create definite barrier tables/views for ALL potential definite barriers
# (whether a feature is a barrier depends on species and parameters)
# ------
#.barriers_majordams: .dams .parameters
#	$(PSQL_CMD) -f scripts/model_access/sql/barriers_majordams.sql
#	touch $@
#.barriers_ditchflow: .parameters
#	$(PSQL_CMD) -f scripts/model_access/sql/barriers_ditchflow.sql
#	touch $@
#.barriers_falls: .falls .falls_barrier_ind .falls_other .parameters
#	$(PSQL_CMD) -f scripts/model_access/sql/barriers_falls.sql
#	touch $@
#.barriers_gradient_15: .gradient_barriers .gradient_barriers_passable .parameters
#	$(PSQL_CMD) -f scripts/model_access/sql/barriers_gradient_15.sql
#	touch $@
#.barriers_gradient_20: .gradient_barriers .gradient_barriers_passable .parameters
#	$(PSQL_CMD) -f scripts/model_access/sql/barriers_gradient_20.sql
#	touch $@
#.barriers_gradient_30: .gradient_barriers .gradient_barriers_passable .parameters
#	$(PSQL_CMD) -f scripts/model_access/sql/barriers_gradient_30.sql
#	touch $@
#.barriers_intermittentflow: .parameters
#	$(PSQL_CMD) -f sql/barriers_intermittentflow.sql
#	touch $@
#.barriers_subsurfaceflow: .parameters
#	$(PSQL_CMD) -f sql/barriers_subsurfaceflow.sql
#	touch $@
#.barriers_other_definite: .exclusions .pscis_barrier_result_fixes .misc_barriers_definite .parameters
#	$(PSQL_CMD) -f sql/barriers_other_definite.sql
#	touch $@
#
