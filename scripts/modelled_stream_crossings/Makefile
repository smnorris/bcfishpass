.PHONY: all

PSQL_CMD = psql $(DATABASE_URL) -v ON_ERROR_STOP=1 # Ensure psql stops on error
GROUPS = $(shell psql $(DATABASE_URL) -AtX -c "SELECT watershed_group_code \
	FROM whse_basemapping.fwa_watershed_groups_poly \
	ORDER BY watershed_group_code")

all: .roads .load_archive .modelled_stream_crossings

# Directly download the DRA archive, it is too big to reliably request via WFS
# *** NOTE ***
# Structure of data in this archive DOES NOT MATCH structure in the BCGW !
# To avoid this issue, load data to whse_basemapping.transport_line rather than DRA_DGTL_ROAD_ATLAS_MPAR_SP
.make/roads:
	mkdir -p data
	mkdir -p .make
	wget --trust-server-names -qNP data ftp://ftp.geobc.gov.bc.ca/sections/outgoing/bmgs/DRA_Public/dgtl_road_atlas.gdb.zip
	unzip -qun data/dgtl_road_atlas.gdb.zip -d data
	ogr2ogr \
		-f PostgreSQL \
		"PG:$(DATABASE_URL)" \
		-overwrite \
		-lco GEOMETRY_NAME=geom \
		-lco FID=transport_line_id \
		-nln whse_basemapping.transport_line \
		data/dgtl_road_atlas.gdb \
		TRANSPORT_LINE
	# load the code tables
	ogr2ogr \
		-f PostgreSQL \
		"PG:$(DATABASE_URL)" \
		-overwrite \
		-nln whse_basemapping.transport_line_type_code \
		data/dgtl_road_atlas.gdb \
		TRANSPORT_LINE_TYPE_CODE
	ogr2ogr \
		-f PostgreSQL \
		"PG:$(DATABASE_URL)" \
		-overwrite \
		-nln whse_basemapping.transport_line_surface_code \
		data/dgtl_road_atlas.gdb \
		TRANSPORT_LINE_SURFACE_CODE
	ogr2ogr \
		-f PostgreSQL \
		"PG:$(DATABASE_URL)" \
		-overwrite \
		-nln whse_basemapping.transport_line_divided_code \
		data/dgtl_road_atlas.gdb \
		TRANSPORT_LINE_DIVIDED_CODE
	ogr2ogr \
		-f PostgreSQL \
		"PG:$(DATABASE_URL)" \
		-overwrite \
		-nln whse_basemapping.transport_line_structure_code \
		data/dgtl_road_atlas.gdb \
		TRANSPORT_LINE_STRUCTURE_CODE

	# Get additional road data direct from BCGW, requesting full datasets (bcfishpass crossing scripts filter out what is needed)
	bcdata bc2pg WHSE_FOREST_TENURE.FTEN_ROAD_SECTION_LINES_SVW
	bcdata bc2pg WHSE_MINERAL_TENURE.OG_ROAD_SEGMENT_PERMIT_SP --primary_key og_road_segment_permit_id
	bcdata bc2pg WHSE_MINERAL_TENURE.OG_PETRLM_DEV_RDS_PRE06_PUB_SP --primary_key og_petrlm_dev_rd_pre06_pub_id
	bcdata bc2pg WHSE_BASEMAPPING.GBA_RAILWAY_TRACKS_SP --primary_key railway_track_id
	bcdata bc2pg WHSE_BASEMAPPING.GBA_RAILWAY_STRUCTURE_LINES_SP --primary_key RAILWAY_STRUCTURE_LINE_ID
	bcdata bc2pg WHSE_IMAGERY_AND_BASE_MAPS.MOT_ROAD_STRUCTURE_SP --primary_key HWY_STRUCTURE_CLASS_ID
	touch $@

# download modelled crossings archive (to extract exising IDs, they need to remain consistent)
.make/load_archive:
	mkdir -p .make
	wget --trust-server-names -qNP data https://www.hillcrestgeo.ca/outgoing/fishpassage/data/bcfishpass/inputs/modelled_stream_crossings_archive.gpkg.zip
	unzip -qun data/modelled_stream_crossings_archive.gpkg.zip -d data
	ogr2ogr \
		-f PostgreSQL \
		"PG:$(DATABASE_URL)" \
		-overwrite \
		-progress \
		-nln bcfishpass.modelled_stream_crossings_archive \
		data/modelled_stream_crossings_archive.gpkg \
		modelled_stream_crossings_archive
	touch $@

# run the overlays/analysis
.make/modelled_stream_crossings: .roads .load_archive
	$(PSQL_CMD) -f sql/01_create_output_table.sql

	# load preliminary crossings, iterating through watershed groups for each data source
	parallel $(PSQL_CMD) -f sql/02_intersect_dra.sql -v wsg={1} ::: $(GROUPS)
	parallel $(PSQL_CMD) -f sql/03_intersect_ften.sql -v wsg={1} ::: $(GROUPS)
	parallel $(PSQL_CMD) -f sql/04_intersect_ogc.sql -v wsg={1} ::: $(GROUPS)
	parallel $(PSQL_CMD) -f sql/05_intersect_ogcpre06.sql -v wsg={1} ::: $(GROUPS)
	parallel $(PSQL_CMD) -f sql/06_intersect_railway.sql -v wsg={1} ::: $(GROUPS)

	# create indexes
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (transport_line_id);"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (ften_road_section_lines_id);"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (og_road_segment_permit_id);"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (og_petrlm_dev_rd_pre06_pub_id);"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (railway_track_id);"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (blue_line_key);"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings (linear_feature_id);"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING GIST (geom);"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING GIST (wscode_ltree)"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING BTREE (wscode_ltree)"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING GIST (localcode_ltree)"
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.modelled_stream_crossings USING BTREE (localcode_ltree)"

	# remove duplicate crossings introduced by using multiple sources
	$(PSQL_CMD) -f sql/07_remove_duplicates.sql
	$(PSQL_CMD) -f sql/08_identify_open_bottom_structures.sql

	# assign modelled_crossing_id from previous version to ensure consistency
	$(PSQL_CMD) -f sql/09_match_archived_crossings.sql
	echo "modelled stream crossings created, run 'make modelled_stream_crossings_archive.gpkg.zip' to create a new archive"
	touch $@

# dump new data to a fresh archive
modelled_stream_crossings_archive.gpkg.zip: .modelled_stream_crossings
	ogr2ogr \
		-f GPKG \
		modelled_stream_crossings_archive.gpkg \
		"PG:($DATABASE_URL)" \
		-nln modelled_stream_crossings_archive \
		-sql "SELECT modelled_crossing_id, geom FROM bcfishpass.modelled_stream_crossings"
	zip -r $@ modelled_stream_crossings_archive.gpkg
	rm modelled_stream_crossings_archive.gpkg
	echo "publish modelled_stream_crossings_archive.gpkg.zip to https://www.hillcrestgeo.ca/outgoing/fishpassage/data/bcfishpass/inputs/"