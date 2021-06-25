.PHONY: all clean

all: data/baseflow.nc data/runoff.nc data/baseflow_yearsum_mean.nc data/runoff_yearsum_mean.nc data/discharge.nc data/discharge.tif db/discharge_load db/discharge

# table existence check from https://mojodna.net/2015/01/07/make-for-data-using-make.html
# check if table exists, run matching *sql* script if it does not
define create_table_sql
	@psql -c "\d $(subst db/,,bcfishpass.$@)" > /dev/null 2>&1 || psql -v ON_ERROR_STOP=1 -qX1f sql/$(subst db/,,$@).sql
endef

# check if table exists, run matching *shell* script if it does not
define create_table_shell
	@psql -c "\d $(subst db/,,bcfishpass.$@)" > /dev/null 2>&1 || ./$(subst db/,,$@).sh
endef

## Download baseflow from PCIC
data/baseflow.nc:
	curl -o $@ https://data.pacificclimate.org/data/hydro_model_out/allwsbc.TPS_gridded_obs_init.1945to2099.BASEFLOW.nc.nc?BASEFLOW[13149:24105][][]

## Download runoff from PCIC
data/runoff.nc:
	curl -o $@ https://data.pacificclimate.org/data/hydro_model_out/allwsbc.TPS_gridded_obs_init.1945to2099.RUNOFF.nc.nc?RUNOFF[13149:24105][][]

## Create mean annual baseflow
data/baseflow_yearsum_mean.nc: data/baseflow.nc
	cdo -O -b F64 -timmean -yearsum $^ $@

## Create mean annual runoff
data/runoff_yearsum_mean.nc: data/runoff.nc
	cdo -O -b F64 -timmean -yearsum $^ $@

## Add baseflow and runoff to create mean annual discharge (MAD)
data/discharge.nc: data/runoff_yearsum_mean.nc data/baseflow_yearsum_mean.nc
	cdo -b F64 add $^ $@

## Load watershed discharge values to postgres and manipulate in the db
db/discharge_load: data/discharge.nc
	$(call create_table_shell)

## Transfer discharge data from temp table to discharge table
db/discharge: db/discharge_load
	$(call create_table_shell)

## remove all generated files/tables
clean:
	rm -Rf data/*
	psql -c "drop table bcfishpass.discharge_load"
	psql -c "drop table bcfishpass.discharge"