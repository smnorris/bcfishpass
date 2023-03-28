PSQL = psql $(DATABASE_URL) -v ON_ERROR_STOP=1 # Ensure psql stops on error
GROUPS = $(shell psql $(DATABASE_URL) -AtX -c "SELECT watershed_group_code \
	FROM whse_basemapping.fwa_watershed_groups_poly \
	ORDER BY watershed_group_code")

# download latest from s3
.make/download_archive:
	mkdir -p .make
	mkdir -p data
	wget --trust-server-names -qNP data https://bcfishpass.s3.us-west-2.amazonaws.com/modelled_stream_crossings.gpkg.zip
	unzip -qun data/modelled_stream_crossings.gpkg.zip -d data
	ogr2ogr \
		-f PostgreSQL \
		"PG:$(DATABASE_URL)" \
		-lco FID=modelled_crossing_id \
		-overwrite \
		-nln bcfishpass.modelled_stream_crossings_archive \
		data/modelled_stream_crossings.gpkg \
		modelled_stream_crossings
	rm data/modelled_stream_crossings.gpkg
	$(PSQL) -f sql/01_create_output_table.sql
	$(PSQL) -f sql/load_from_archive.sql
	rm -rf data/modelled_stream_crossings.gpkg
	touch $@

# note that while modelled crossings are loaded from archive above, we still need roads/railways etc
# for further analysis
.make/download_bcdata:
	# Get non-dra road data direct from BCGW, requesting full datasets (bcfishpass crossing scripts filter out what is needed)
	bcdata bc2pg WHSE_FOREST_TENURE.FTEN_ROAD_SECTION_LINES_SVW
	bcdata bc2pg WHSE_MINERAL_TENURE.OG_ROAD_SEGMENT_PERMIT_SP --primary_key og_road_segment_permit_id
	bcdata bc2pg WHSE_MINERAL_TENURE.OG_PETRLM_DEV_RDS_PRE06_PUB_SP --primary_key og_petrlm_dev_rd_pre06_pub_id
	bcdata bc2pg WHSE_BASEMAPPING.GBA_RAILWAY_TRACKS_SP --primary_key railway_track_id
	bcdata bc2pg WHSE_BASEMAPPING.GBA_RAILWAY_STRUCTURE_LINES_SP --primary_key RAILWAY_STRUCTURE_LINE_ID
	bcdata bc2pg WHSE_IMAGERY_AND_BASE_MAPS.MOT_ROAD_STRUCTURE_SP --primary_key HWY_STRUCTURE_CLASS_ID
	# get dra from ftp
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
	rm -rf data/dgtl_road_atlas.gdb
	touch $@

# run the overlays/analysis
.make/modelled_stream_crossings: .make/download_archive .make/download_bcdata
	$(PSQL) -f sql/01_create_output_table.sql

	# load preliminary crossings, iterating through watershed groups for each data source
	parallel $(PSQL) -f sql/02_intersect_dra.sql -v wsg={1} ::: $(GROUPS)
	parallel $(PSQL) -f sql/03_intersect_ften.sql -v wsg={1} ::: $(GROUPS)
	parallel $(PSQL) -f sql/04_intersect_ogc.sql -v wsg={1} ::: $(GROUPS)
	parallel $(PSQL) -f sql/05_intersect_ogcpre06.sql -v wsg={1} ::: $(GROUPS)
	parallel $(PSQL) -f sql/06_intersect_railway.sql -v wsg={1} ::: $(GROUPS)

	# remove duplicate crossings introduced by using multiple sources
	$(PSQL) -f sql/07_remove_duplicates.sql
	$(PSQL) -f sql/08_identify_open_bottom_structures.sql

	# assign modelled_crossing_id from previous version to ensure consistency
	$(PSQL) -f sql/09_match_archived_crossings.sql
	echo "modelled stream crossings created, run 'make .make/publish' to publish"
	touch $@

# dump to file
modelled_stream_crossings.gpkg.zip: .make/modelled_stream_crossings
	rm -f modelled_stream_crossings.gpkg*
	ogr2ogr \
		-f GPKG \
		modelled_stream_crossings.gpkg \
		"PG:$(DATABASE_URL)" \
		-nlt PointZM \
		-nln modelled_stream_crossings \
		-sql "select \
			 modelled_crossing_id, \
			 modelled_crossing_type, \
			 array_to_string(modelled_crossing_type_source, '; ') as modelled_crossing_type_source, \
			 transport_line_id, \
			 ften_road_section_lines_id, \
			 og_road_segment_permit_id, \
			 og_petrlm_dev_rd_pre06_pub_id, \
			 railway_track_id, \
			 linear_feature_id, \
			 blue_line_key, \
			 downstream_route_measure, \
			 wscode_ltree, \
			 localcode_ltree, \
			 watershed_group_code, \
			 geom \
			from bcfishpass.modelled_stream_crossings"
	zip -r modelled_stream_crossings.gpkg.zip modelled_stream_crossings.gpkg
	rm modelled_stream_crossings.gpkg

# post archive to s3 and clean up
.make/publish: modelled_stream_crossings.gpkg.zip
	aws s3 cp modelled_stream_crossings.gpkg.zip s3://bcfishpass/
	aws s3api put-object-acl --bucket bcfishpass --key modelled_stream_crossings.gpkg.zip --acl public-read
	rm -f modelled_stream_crossings.gpkg*
	$(PSQL) -c "drop table bcfishpass.modelled_stream_crossings_bk"
	touch $@