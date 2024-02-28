.PHONY: all clean 

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1
TMP=/tmp
WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method where watershed_group_code != 'ELKR'")

VALLEY_OUTPUTS = $(patsubst %, data/temp/%/valleys.tif, $(WSG)) 
LATERAL_OUTPUTS = $(patsubst %, data/temp/%/habitat_lateral.tif, $(WSG)) 

# find bounds of BC
BOUNDS = $(shell $(PSQL) -AtX -F " " -c "select st_xmin(geom), st_ymin(geom), st_xmax(geom), st_ymax(geom) \
from ( \
  select \
    st_extent(geom) as geom \
  from whse_basemapping.fwa_watershed_groups_poly wsg \
  inner join bcfishpass.parameters_habitat_method p \
  on wsg.watershed_group_code = p.watershed_group_code \
) as ext;")

all: .make/habitat_lateral

clean:
	$(PSQL) -c "DROP TABLE IF EXISTS whse_basemapping.cwb_floodplains_bc_area_svw"
	$(PSQL) -c "DROP TABLE IF EXISTS bcfishpass.habitat_lateral"
	$(PSQL) -c "DROP TABLE IF EXISTS bcfishpass.habitat_lateral_disconnected_rail"
	rm -rf data
	rm -rf .make

# load published floodplain definitions
.make/cwb_floodplains_bc_area_svw: 
	mkdir -p .make
	bcdata bc2pg -r WHSE_BASEMAPPING.CWB_FLOODPLAINS_BC_AREA_SVW
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

# run VCA for each watershed group
$(VALLEY_OUTPUTS): valley_confinement.py ../../.make/habitat_linear
	$(eval WSG=$(patsubst data/temp/%/valleys.tif,%,$@))
	mkdir -p data/temp/$(WSG)
	python valley_confinement.py $(WSG) -o $@ -d data/temp/$(WSG)

# run lateral analysis for each watershed group
$(LATERAL_OUTPUTS): $(VALLEY_OUTPUTS) habitat_lateral.py data/esa_bc.tif .make/cwb_floodplains_bc_area_svw
	$(eval WSG=$(patsubst data/temp/%/habitat_lateral.tif,%,$@))
	python habitat_lateral.py $(WSG) -o $@ -d data/temp/$(WSG)

# merge output habitat_lateral.tif for each watershed group into a single tif
data/habitat_lateral.tif: $(LATERAL_OUTPUTS)
	# something is not working here, it is only pulling the last output tif, not the entire collection
	python merge.py $(LATERAL_OUTPUTS) -o $@ --method max --co COMPRESS=DEFLATE --co NUM_THREADS=ALL_CPUS
	
# load merged habitat_lateral.tif to postgres as polygons
.make/habitat_lateral: data/habitat_lateral.tif
	$(PSQL) -c "drop table if exists bcfishpass.habitat_lateral"
	rio shapes data/habitat_lateral.tif --bidx 1 --precision 6 --collection --projected | \
  ogr2ogr \
  -f PostgreSQL \
  -s_srs EPSG:3005 \
  -t_srs EPSG:3005 \
  PG:$(DATABASE_URL) \
  -overwrite \
  -lco GEOMETRY_NAME=geom \
  -nln bcfishpass.habitat_lateral \
  /vsistdin/
	
	# clean up habitat potentially isolated by rail
	$(PSQL) -f sql/habitat_lateral.sql
	touch $@
	# cleanup temp files
	#for wsg in $(WSG) ; do \
	#	rm -r data/$$wsg ; \
	#done