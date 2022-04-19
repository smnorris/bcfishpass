.PHONY: all clean 

PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1
TMP=/tmp

all: .make/lateral_disconnected_rail

.make/sources:
	mkdir -p .make
	bcdata bc2pg WHSE_BASEMAPPING.CWB_FLOODPLAINS_BC_AREA_SVW
	bcdata bc2pg WHSE_BASEMAPPING.BCGS_20K_GRID
	bcdata bc2pg WHSE_BASEMAPPING.BTM_PRESENT_LAND_USE_V1_SVW
	touch $@

.make/lateral_polys: .make/sources sql/studyarea.sql sql/lateral_polys.sql
	$(PSQL_CMD) -f sql/studyarea.sql
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

# run lateral analysis, writing output lateral.tif
data/lateral.tif: data/slope.tif .make/lateral_polys data/esa_bc.tif lateral.py
	python lateral.py data/slope.tif -o $@ --temp_path temp_tifs
	# clean up lateral potential table
	$(PSQL_CMD) -c "create table bcfishpass.lateral_potential2 as \
		select raster_val, st_subdivide(geometry) as geom \
		from bcfishpass.lateral_potential \
		where raster_val = 1; \
		drop table bcfishpass.lateral_potential; \
		alter table bcfishpass.lateral_potential2 rename to lateral_potential;"

# above loads to postgres all lateral polys disconnected by rail
# clean up and label here
.make/lateral_disconnected_rail: data/lateral.tif
	$(PSQL_CMD) -f sql/lateral_disconnected_rail.sql
	touch $@

clean:
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS whse_basemapping.cwb_floodplains_bc_area_svw"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS whse_basemapping.bcgs_20k_grid"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass.lateral_studyarea"
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass.lateral_polys"
	rm -rf data
	rm -rf .make