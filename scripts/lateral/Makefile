.PHONY: all clean 

PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1

all: .make/sources .make/lateral

.make/sources:
	mkdir -p .make
	bcdata bc2pg WHSE_BASEMAPPING.CWB_FLOODPLAINS_BC_AREA_SVW
	bcdata bc2pg WHSE_BASEMAPPING.BCGS_20K_GRID
	touch $@

.make/lateral: .make/sources
	$(PSQL_CMD) -f sql/lateral_habitat.sql
	touch $@

clean:
	rm -Rf .gradient_barriers
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass_lat.study_area"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass_lat.waterbodies"