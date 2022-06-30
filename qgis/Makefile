# ----------
# Download general base map data required for bcfishpass qgis layer
# Script presumes $DATABASE_URL is pointing to postgres db of interest
# ----------

.PHONY: all clean

# point psql to db and stop on errors
PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1         

# basic tables that can be downloaded provincially
BASIC_TABLES = WHSE_ADMIN_BOUNDARIES.CLAB_INDIAN_RESERVES \
	WHSE_ADMIN_BOUNDARIES.CLAB_NATIONAL_PARKS \
	WHSE_BASEMAPPING.BCGS_20K_GRID \
	WHSE_BASEMAPPING.GBA_TRANSMISSION_LINES_SP \
	WHSE_BASEMAPPING.GNS_GEOGRAPHICAL_NAMES_SP \
	WHSE_BASEMAPPING.DBM_MOF_50K_GRID \
	WHSE_BASEMAPPING.TRIM_EBM_OCEAN \
	WHSE_BASEMAPPING.UTMG_UTM_ZONES_SP \
	WHSE_ENVIRONMENTAL_MONITORING.ENVCAN_HYDROMETRIC_STN_SP \
	WHSE_LEGAL_ADMIN_BOUNDARIES.ABMS_MUNICIPALITIES_SP \
	WHSE_TANTALIS.TA_PARK_ECORES_PA_SVW \
	WHSE_FOREST_TENURE.FTEN_RANGE_POLY_SVW
BASIC_TARGETS = $(addprefix .make/, $(BASIC_TABLES))

# find 250k tiles present in control file
TILES = $(shell cat tctr_tiles.txt)
TILE_TARGETS = $(addprefix .make/TCTR_, $(TILES))

GENERATED_FILES = $(BASIC_TARGETS) \
	.make/WHSE_BASEMAPPING.TRIM_CONTOUR_LINES \
	$(TILE_TARGETS) \
	.make/TCTR \
	.make/WHSE_FOREST_VEGETATION.VEG_COMP_LYR_R1_POLY \
	.make/WHSE_CADASTRE.PMBC_PARCEL_FABRIC_POLY_SVW

# temp folder
TMP=/tmp

all: $(GENERATED_FILES)

$(BASIC_TARGETS):
	mkdir -p .make
	bcdata bc2pg $(subst .make/,,$@)
	touch $@

.make/WHSE_BASEMAPPING.TRIM_CONTOUR_LINES:
	mkdir -p .make
	$(PSQL_CMD) -c "drop table if exists whse_basemapping.trim_contour_lines"
	$(PSQL_CMD) -c "create table whse_basemapping.trim_contour_lines ( \
	ogc_fid       integer                        , \
	objectid      integer                        , \
	fcode         character varying(10)          , \
	elevation     integer                        , \
	admit_year    smallint                       , \
	admit_mnth    smallint                       , \
	admit_day     smallint                       , \
	asrc_year     smallint                       , \
	asrc_mnth     smallint                       , \
	asrc_day      smallint                       , \
	admit_rfc     character varying(30)          , \
	admit_srel    character varying(10)          , \
	admit_rkey    character varying(10)          , \
	retir_year    smallint                       , \
	retir_mnth    smallint                       , \
	retir_day     smallint                       , \
	rsrc_year     smallint                       , \
	rsrc_mnth     smallint                       , \
	rsrc_day      smallint                       , \
	retir_rfc     character varying(30)          , \
	retir_srel    character varying(10)          , \
	retir_rkey    character varying(10)          , \
	x_level       character varying(10)          , \
	x_reason      character varying(2)           , \
	x_supplier    character varying(45)          , \
	x_capture     character varying(15)          , \
	x_accuracy    smallint                       , \
	bcgs_tile     character varying(7)           , \
	source_id     character varying(52)          , \
	geometry_len  double precision               , \
	shape_length  double precision               , \
	geom          geometry(MultiLineString,3005) )"
	touch $@

# Download contours per 250k tile
$(TILE_TARGETS): .make/WHSE_BASEMAPPING.TRIM_CONTOUR_LINES
	# to handle interrupted downloads, delete any existing features for given tile
	$(PSQL_CMD) -c "delete from whse_basemapping.trim_contour_lines where bcgs_tile like '$(subst TCTR_,,$@)%'"
	bcdata bc2pg WHSE_BASEMAPPING.TRIM_CONTOUR_LINES \
		--append \
		--fid OBJECTID \
		--promote_to_multi \
		--query "BCGS_TILE LIKE '$(subst .make/TCTR_,,$@)%'"
	touch $@

# empty target for downloading all contours
.make/TCTR: .make/WHSE_BASEMAPPING.TRIM_CONTOUR_LINES $(TILE_TARGETS)
	touch $@

# download veg .gdb, load and index
.make/WHSE_FOREST_VEGETATION.VEG_COMP_LYR_R1_POLY:
	mkdir -p .make
	$(PSQL_CMD) -c "CREATE SCHEMA IF NOT EXISTS whse_forest_vegetation"
	wget --trust-server-names -qNP $(TMP) https://pub.data.gov.bc.ca/datasets/02dba161-fdb7-48ae-a4bb-bd6ef017c36d/current/VEG_COMP_LYR_R1_POLY_2021.gdb.zip
	ogr2ogr \
	   -progress \
	   --config PG_USE_COPY YES \
	   -t_srs EPSG:3005 \
	   -dim XY \
	   -f PostgreSQL \
	   PG:$(DATABASE_URL) \
	   -overwrite \
	   -lco GEOMETRY_NAME=geom \
	   -lco SPATIAL_INDEX=NONE \
	   -lco FID=FEATURE_ID \
	   -lco FID64=TRUE \
	   -nln whse_forest_vegetation.veg_comp_lyr_r1_poly \
	   $(TMP)/VEG_COMP_LYR_R1_POLY_2021.gdb.zip \
	   VEG_COMP_LYR_R1_POLY
	$(PSQL_CMD) -c "CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (for_mgmt_land_base_ind); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (inventory_standard_cd); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (non_productive_descriptor_cd); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (species_pct_1); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (species_cd_1); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (site_index); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_1); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_2); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_3); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_4); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_5); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (map_id); \
	   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING GIST (geom);" 
	touch $@	

.make/WHSE_CADASTRE.PMBC_PARCEL_FABRIC_POLY_SVW:
	mkdir -p .make
	# rename downloaded file so ogr can read without unzipping
	wget --trust-server-names -qN \
		-O $(TMP)/pmbc_parcel_fabric_poly_svw.gdb.zip \
		https://pub.data.gov.bc.ca/datasets/4cf233c2-f020-4f7a-9b87-1923252fbc24/pmbc_parcel_fabric_poly_svw.zip
	$(PSQL_CMD) -c "CREATE SCHEMA IF NOT EXISTS whse_cadastre"
	# load to pg
	ogr2ogr \
	   -progress \
	   --config PG_USE_COPY YES \
	   -t_srs EPSG:3005 \
	   -dim XY \
	   -f PostgreSQL \
	   PG:$(DATABASE_URL) \
	   -overwrite \
	   -lco GEOMETRY_NAME=geom \
	   -lco FID=PARCEL_FABRIC_POLY_ID \
	   -nln whse_cadastre.pmbc_parcel_fabric_poly_svw \
	   $(TMP)/pmbc_parcel_fabric_poly_svw.gdb.zip \
	   pmbc_parcel_fabric_poly_svw
	touch $@

clean:
	rm -f $(GENERATED_FILES)
	# drop all target tables
	for table in $(BASIC_TABLES) \
		WHSE_BASEMAPPING.TRIM_CONTOUR_LINES \
		WHSE_FOREST_VEGETATION.VEG_COMP_LYR_R1_POLY \
		WHSE_CADASTRE.PMBC_PARCEL_FABRIC_POLY_SVW ; do \
		$(PSQL_CMD) -c "DROP TABLE IF EXISTS "$$table ;\
	done
