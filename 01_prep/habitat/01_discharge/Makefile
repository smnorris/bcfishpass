.PHONY: all clean

all: data/baseflow.nc data/runoff.nc data/baseflow_yearsum_mean.nc data/runoff_yearsum_mean.nc data/discharge.nc data/discharge.tif data/.discharge_load data/.discharge_upstream

# table existence check from https://mojodna.net/2015/01/07/make-for-data-using-make.html
# check if table exists, run matching *shell* script if it does not
define create_table_shell
	@psql -c "\d $(subst db/,,bcfishpass.$@)" > /dev/null 2>&1 || psql -v ON_ERROR_STOP=1 -qX1f sql/$(subst db/,,$@).sql
endef

# check if table exists, run matching *sql* script if it does not
define create_table_sql
	@psql -c "\d $(subst db/,,bcfishpass.$@)" > /dev/null 2>&1 || ./$(subst db/,,sql/$@.sh)
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
data/discharge.nc: data/runoff_yearsum_mean.nc data/baseflow_yearsum_mean.nc # TODO - sum 26 bi-weekly mean baseflow/runoff files
	cdo -b F64 add $^ $@

## Convert MAD netcdf to BC Albers GeoTiff
data/discharge.tif: data/discharge.nc
	gdalwarp -s_srs EPSG:4326 -t_srs EPSG:3005 -co COMPRESS=DEFLATE -co NUM_THREADS=ALL_CPUS $^ $@

## Load watershed discharge values to postgres and manipulate in the db
db/discharge_load: data/discharge.tif
	$(call create_table_shell)

## Transfer discharge data from temp table to discharge table
db/discharge: db/discharge_load
	$(call create_table_shell)

## remove all generated files
clean:
	rm -Rf data/*

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')