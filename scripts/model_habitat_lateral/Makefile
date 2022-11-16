.PHONY: all clean 

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1
TMP=/tmp
WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")

BOUNDS = $(shell $(PSQL) -AtX -F " " -c "select st_xmin(geom), st_ymin(geom), st_xmax(geom), st_ymax(geom) \
from ( \
  select \
    st_extent(geom) as geom \
  from whse_basemapping.fwa_watershed_groups_poly wsg \
  inner join bcfishpass.param_watersheds p \
  on wsg.watershed_group_code = p.watershed_group_code \
) as ext;")


all: .make/lateral_disconnected_rail


clean:
	$(PSQL) -c "DROP TABLE IF EXISTS whse_basemapping.cwb_floodplains_bc_area_svw"
	$(PSQL) -c "DROP TABLE IF EXISTS bcfishpass.lateral"
	rm -rf data
	rm -rf .make


.make/sources: 
	mkdir -p .make
	mkdir -p data
	# published floodplain definitions
	bcdata bc2pg WHSE_BASEMAPPING.CWB_FLOODPLAINS_BC_AREA_SVW
	touch $@


# ESA world landcover - download from S3 bucket
data/esa_bc.tif:	
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
	# merge esa tifs and warp to BC Albers, writing to compressed geotiff
	# note that extent is for all of BC
	gdalbuildvrt $(TMP)/esa_merged.vrt $(TMP)/ESA_WorldCover_10m_2020_v100_*.tif
	gdalwarp -co COMPRESS=DEFLATE \
		-co PREDICTOR=2 \
		-co NUM_THREADS=ALL_CPUS \
		-t_srs EPSG:3005 \
		-r nearest \
		-te 273287.5, 367687.5, 1870687.5, 1735887.5 \
		-tr 10 10 \
		$(TMP)/esa_merged.vrt \
		$@


# run lateral analysis for each watershed group and merge result
data/habitat_lateral.tif: .make/sources data/esa_bc.tif \
	valley_confinement.py \
	habitat_lateral.py \
	../model_habitat_linear/.make/model_habitat_linear
	# make output folder and temp data folders
	for wsg in $(WSG) ; do \
		mkdir -p data/$$wsg ; \
	done
	mkdir -p data/habitat_lateral
	# run VCA for each watershed group
	parallel python valley_confinement.py {1} -o data/{1}/valleys.tif -d data/{1} ::: $(WSG)
	# run lateral habitat model	
	parallel python habitat_lateral.py {1} -o data/habitat_lateral/habitat_lateral_{1}.tif -d data/{1} ::: $(WSG)
	# merge outputs
	python merge.py data/habitat_lateral/habitat_lateral_*.tif -o data/habitat_lateral.tif --method max --co COMPRESS=DEFLATE --co NUM_THREADS=ALL_CPUS
	# cleanup temp files
	for wsg in $(WSG) ; do \
		rm -r data/$$wsg ; \
	done
	
	
# clean up and label 
#.make/lateral_disconnected_rail: data/habitat_lateral.tif
#	$(PSQL) -f sql/lateral_disconnected_rail.sql
#	touch $@
