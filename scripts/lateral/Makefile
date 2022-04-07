.PHONY: all clean 

PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1

all: .make/sources .make/studyarea .make/lateral_polys data/dem.tif data/slope.tif

.make/sources:
	mkdir -p .make
	bcdata bc2pg WHSE_BASEMAPPING.CWB_FLOODPLAINS_BC_AREA_SVW
	bcdata bc2pg WHSE_BASEMAPPING.BCGS_20K_GRID
	touch $@

data/studyarea.tif: .make/sources
	$(PSQL_CMD) -f sql/studyarea.sql
	# rasterize, writing to data/studyarea.tif

.make/lateral_polys: .make/sources .make/studyarea sql/lateral_polys.sql
	$(PSQL_CMD) -f sql/lateral_polys.sql
	touch $@

data/dem.tif:
	mkdir -p data
	bcdata dem --bounds "728158 446751 1542259 1263164" --align -o $@

data/slope.tif: data/dem.tif
	gdaldem slope data/dem.tif $@ -p -co COMPRESS=DEFLATE


clean:
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS whse_basemapping.cwb_floodplains_bc_area_svw"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS whse_basemapping.bcgs_20k_grid"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass.lateral_studyarea"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass.lateral_polys"
	rm -rf data
	rm -rf .make