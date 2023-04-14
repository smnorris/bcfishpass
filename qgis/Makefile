# ----------
# Download general base map data required for bcfishpass qgis layer
# Script presumes $DATABASE_URL is pointing to postgres db of interest
# ----------

.PHONY: all clean

# point psql to db and stop on errors
PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1         

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
	WHSE_TANTALIS.TA_CONSERVANCY_AREAS_SVW \
	WHSE_FOREST_TENURE.FTEN_RANGE_POLY_SVW \
	WHSE_FISH.FISS_STREAM_SAMPLE_SITES_SP
BASIC_TARGETS = $(addprefix .make/, $(BASIC_TABLES))

# find 250k tiles present in control file
TILES = $(shell cat tctr_tiles.txt)
TILE_TARGETS = $(addprefix .make/TCTR_, $(TILES))

GENERATED_FILES = $(BASIC_TARGETS) \
	.make/WHSE_BASEMAPPING.TRIM_CONTOUR_LINES \
	$(TILE_TARGETS) \
	.make/TCTR \
	.make/WHSE_FOREST_VEGETATION.VEG_COMP_LYR_R1_POLY \
	.make/WHSE_CADASTRE.PMBC_PARCEL_FABRIC_POLY_SVW \
	.make/WHSE_FOREST_TENURE.FTEN_RANGE_POLY_CARTO_VW

# temp folder
TMP=/tmp

all: $(GENERATED_FILES)

.make/WHSE_ADMIN_BOUNDARIES.CLAB_INDIAN_RESERVES:
	bcdata bc2pg $(subst .make/,,$@) -k clab_id
	touch $@

.make/WHSE_ADMIN_BOUNDARIES.CLAB_NATIONAL_PARKS:
	bcdata bc2pg $(subst .make/,,$@) -k national_park_id
	touch $@

.make/WHSE_BASEMAPPING.BCGS_20K_GRID:
	bcdata bc2pg $(subst .make/,,$@) -k map_tile
	touch $@

.make/WHSE_BASEMAPPING.GBA_TRANSMISSION_LINES_SP:
	bcdata bc2pg $(subst .make/,,$@) -k transmission_line_id
	touch $@

.make/WHSE_BASEMAPPING.GNS_GEOGRAPHICAL_NAMES_SP:
	bcdata bc2pg $(subst .make/,,$@) -k geographical_name_id
	touch $@

.make/WHSE_BASEMAPPING.DBM_MOF_50K_GRID:
	bcdata bc2pg $(subst .make/,,$@) -k map_tile
	touch $@

.make/WHSE_BASEMAPPING.TRIM_EBM_OCEAN:
	bcdata bc2pg $(subst .make/,,$@) -k objectid
	# as with contours, for some reason qgis picks up fcode as pk when accessing via fdw
	$(PSQL) -c "drop table if exists whse_basemapping.trim_ebm_ocean_tmp"
	$(PSQL) -c "create table whse_basemapping.trim_ebm_ocean_tmp ( \
		objectid integer primary key, \
		fcode character varying(10), \
		feature_type character varying(30), \
		geom geometry(MultiPolygon,3005))"
	$(PSQL) -c "insert into whse_basemapping.trim_ebm_ocean_tmp \
		select objectid, fcode, feature_type, geom \
		from whse_basemapping.trim_ebm_ocean;"
	$(PSQL) -c "create index on whse_basemapping.trim_ebm_ocean_tmp using gist (geom)"
	$(PSQL) -c "drop table whse_basemapping.trim_ebm_ocean"
	$(PSQL) -c "alter table whse_basemapping.trim_ebm_ocean_tmp rename to trim_ebm_ocean"
	touch $@

.make/WHSE_BASEMAPPING.UTMG_UTM_ZONES_SP:
	bcdata bc2pg $(subst .make/,,$@) -k utm_zone
	touch $@

.make/WHSE_ENVIRONMENTAL_MONITORING.ENVCAN_HYDROMETRIC_STN_SP:
	bcdata bc2pg $(subst .make/,,$@) -k hydrometric_station_id
	touch $@

.make/WHSE_LEGAL_ADMIN_BOUNDARIES.ABMS_MUNICIPALITIES_SP:
	bcdata bc2pg $(subst .make/,,$@) -k lgl_admin_area_id
	touch $@

.make/WHSE_TANTALIS.TA_PARK_ECORES_PA_SVW:
	bcdata bc2pg $(subst .make/,,$@) -k admin_area_sid
	touch $@

.make/WHSE_TANTALIS.TA_CONSERVANCY_AREAS_SVW:
	bcdata bc2pg $(subst .make/,,$@) -k admin_area_sid
	touch $@

.make/WHSE_FOREST_TENURE.FTEN_RANGE_POLY_SVW:
	$(PSQL) -c "drop table if exists whse_forest_tenure.ften_range_poly_svw cascade" # in case view exists
	bcdata bc2pg $(subst .make/,,$@) -k objectid
	# as with trim features, qgis is looking at the first column for pk - despite it being defined as objectid
	$(PSQL) -c "create table whse_forest_tenure.ften_range_poly_svw_tmp (\
	 objectid                  integer primary key         , \
	 forest_file_id            character varying(10)       , \
	 map_block_id              character varying(10)       , \
	 map_label                 character varying(21)       , \
	 client_number             character varying(8)        , \
	 client_location_code      character varying(2)        , \
	 client_name               character varying(91)       , \
	 file_type_code            character varying(3)        , \
	 authorized_use            numeric                     , \
	 total_annual_use          numeric                     , \
	 feature_area              numeric                     , \
	 feature_perimeter         numeric                     , \
	 area_ha                   numeric                     , \
	 sum_tenure_active_area_ha numeric                     , \
	 file_status_code          character varying(3)        , \
	 life_cycle_status_code    character varying(10)       , \
	 retirement_date           date                        , \
	 calendar_year             numeric                     , \
	 admin_district_code       character varying(6)        , \
	 admin_district_name       character varying(100)      , \
	 feature_class_skey        numeric                     , \
	 geom                      geometry(MultiPolygon,3005) ) "
	 $(PSQL) -c "insert into whse_forest_tenure.ften_range_poly_svw_tmp \
	 select \
	   objectid, \
	   forest_file_id, \
	   map_block_id, \
	   map_label, \
	   client_number, \
	   client_location_code, \
	   client_name, \
	   file_type_code, \
	   authorized_use, \
	   total_annual_use, \
	   feature_area, \
	   feature_perimeter, \
	   area_ha, \
	   sum_tenure_active_area_ha, \
	   file_status_code, \
	   life_cycle_status_code, \
	   retirement_date, \
	   calendar_year, \
	   admin_district_code, \
	   admin_district_name, \
	   feature_class_skey, \
	   geom \
	 from whse_forest_tenure.ften_range_poly_svw"
	$(PSQL) -c "create index on whse_forest_tenure.ften_range_poly_svw_tmp using gist (geom)"
	$(PSQL) -c "drop table whse_forest_tenure.ften_range_poly_svw"
	$(PSQL) -c "alter table whse_forest_tenure.ften_range_poly_svw_tmp rename to ften_range_poly_svw"
	touch $@

.make/WHSE_FISH.FISS_STREAM_SAMPLE_SITES_SP:
	bcdata bc2pg $(subst .make/,,$@) -k stream_sample_site_id
	touch $@

.make/WHSE_BASEMAPPING.TRIM_CONTOUR_LINES:
	mkdir -p .make
	bcdata bc2pg whse_basemapping.trim_contour_lines --schema_only
	$(PSQL) -c "create index on whse_basemapping.trim_contour_lines (bcgs_tile);"
	touch $@

# Download contours per 250k tile
$(TILE_TARGETS): .make/WHSE_BASEMAPPING.TRIM_CONTOUR_LINES
	# to handle interrupted downloads, delete any existing features for given tile
	$(PSQL) -c "delete from whse_basemapping.trim_contour_lines where bcgs_tile like '$(subst TCTR_,,$@)%'"
	bcdata bc2pg WHSE_BASEMAPPING.TRIM_CONTOUR_LINES \
		--append \
		--query "BCGS_TILE LIKE '$(subst .make/TCTR_,,$@)%'"
	touch $@

# final contour table
# (dropping unneeded columns and making sure the pk is first column - qgis does not seem to be
# picking up the right pk if the table is accessed via fdw)
.make/TCTR: $(TILE_TARGETS)
	$(PSQL) -c "drop table if exists whse_basemapping.trim_contour_lines_tmp;"
	$(PSQL) -c "create table whse_basemapping.trim_contour_lines_tmp \
	( objectid   bigint  primary key           , \
	 source_id   character varying(52)         , \
	 fcode       character varying(10)         , \
	 elevation   numeric                       , \
	 bcgs_tile   character varying(7)          , \
	 geom        geometry(MultiLineString,3005) \
	);"
	$(PSQL) -c "insert into whse_basemapping.trim_contour_lines_tmp \
		select \
		  objectid, \
		  source_id, \
		  fcode, \
		  elevation, \
		  bcgs_tile, \
		  geom \
		from whse_basemapping.trim_contour_lines;"
	$(PSQL) -c "create index on whse_basemapping.trim_contour_lines_tmp using gist (geom);"
	$(PSQL) -c "create index on whse_basemapping.trim_contour_lines_tmp (bcgs_tile);"
	$(PSQL) -c "drop table whse_basemapping.trim_contour_lines;"
	$(PSQL) -c "alter table whse_basemapping.trim_contour_lines_tmp rename to trim_contour_lines;"

	touch $@

# download veg .gdb, load and index
.make/WHSE_FOREST_VEGETATION.VEG_COMP_LYR_R1_POLY:
	mkdir -p .make
	$(PSQL) -c "CREATE SCHEMA IF NOT EXISTS whse_forest_vegetation"
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
	$(PSQL) -c "CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (for_mgmt_land_base_ind); \
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
	$(PSQL) -c "CREATE SCHEMA IF NOT EXISTS whse_cadastre"
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

# create a non-overlapping range tenure layer
.make/WHSE_FOREST_TENURE.FTEN_RANGE_POLY_CARTO_VW: .make/WHSE_FOREST_TENURE.FTEN_RANGE_POLY_SVW
	$(PSQL) -f sql/ften_range_poly_carto_vw.sql
	touch $@

clean:
	rm -f $(GENERATED_FILES)
	# drop all target tables
	for table in $(BASIC_TABLES) \
		WHSE_BASEMAPPING.TRIM_CONTOUR_LINES \
		WHSE_FOREST_VEGETATION.VEG_COMP_LYR_R1_POLY \
		WHSE_CADASTRE.PMBC_PARCEL_FABRIC_POLY_SVW ; do \
		$(PSQL) -c "DROP TABLE IF EXISTS "$$table ;\
	done
