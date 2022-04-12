.PHONY: all clean 

PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1
TMP=/tmp

all: .make/sources .make/studyarea .make/lateral_polys data/dem.tif data/slope.tif

.make/sources:
	mkdir -p .make
	bcdata bc2pg WHSE_BASEMAPPING.CWB_FLOODPLAINS_BC_AREA_SVW
	bcdata bc2pg WHSE_BASEMAPPING.BCGS_20K_GRID
	bcdata bc2pg WHSE_BASEMAPPING.BTM_PRESENT_LAND_USE_V1_SVW
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

# land cover from ESA
data/esa_bc.tif:
	# Download BC tiles of ESA world landcover from S3 bucket
	# warp data to BC Albers, writing to compressed geotiff
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N54W123_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N54W123_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N57W120_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N57W120_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N51W126_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N51W126_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N57W138_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N57W138_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N54W132_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N54W132_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N48W117_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N48W117_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N57W141_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N57W141_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N48W120_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N48W120_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N51W135_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N51W135_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N51W120_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N51W120_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N48W132_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N48W132_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N54W129_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N54W129_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N54W135_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N54W135_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N57W135_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N57W135_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N57W129_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N57W129_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N51W129_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N51W129_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N48W129_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N48W129_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N54W120_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N54W120_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N54W126_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N54W126_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N51W123_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N51W123_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N51W132_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N51W132_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N57W126_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N57W126_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N57W132_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N57W132_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N51W117_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N51W117_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N48W123_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N48W123_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N57W123_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N57W123_Map.tif --no-sign-request
	aws s3 cp s3://esa-worldcover/v100/2020/map/ESA_WorldCover_10m_2020_v100_N48W126_Map.tif \
		$(TMP)/ESA_WorldCover_10m_2020_v100_N48W126_Map.tif --no-sign-request
	gdalbuildvrt $(TMP)/esa_merged.vrt $(TMP)/ESA_WorldCover_10m_2020_v100_*.tif
	gdalwarp -co COMPRESS=DEFLATE \
		-co PREDICTOR=2 \
		-co NUM_THREADS=ALL_CPUS \
		-t_srs EPSG:3005 \
		-r nearest \
		-te "728087.5, 446687.5, 1542387.5, 1263287.5" \
		-tr 25 25 \
		$(TMP)/esa_merged.vrt \
		$@

# rasterize study area, various polygons, merge into single raster
data/lateral.tif: slope.tif .make/lateral_polys
	python lateral.py


clean:
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS whse_basemapping.cwb_floodplains_bc_area_svw"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS whse_basemapping.bcgs_20k_grid"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass.lateral_studyarea"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass.lateral_polys"
	rm -rf data
	rm -rf .make