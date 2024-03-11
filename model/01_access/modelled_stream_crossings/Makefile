PSQL = psql $(DATABASE_URL) -v ON_ERROR_STOP=1
WSGS = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")

# download latest from s3
.make/download_archive:
	mkdir -p .make
	mkdir -p data
	curl \
	  -o data/modelled_stream_crossings.gpkg.zip \
	  https://bcfishpass.s3.us-west-2.amazonaws.com/modelled_stream_crossings.gpkg.zip
	unzip -qun data/modelled_stream_crossings.gpkg.zip -d data
	ogr2ogr \
		-f PostgreSQL \
		"PG:$(DATABASE_URL)" \
		-overwrite \
		-nln bcfishpass.modelled_stream_crossings_archive \
		data/modelled_stream_crossings.gpkg \
		modelled_stream_crossings
	rm data/modelled_stream_crossings.gpkg
	$(PSQL) -f sql/01_create_output_table.sql
	$(PSQL) -f sql/load_from_archive.sql
	rm -rf data/modelled_stream_crossings.gpkg
	touch $@

# run the overlays/analysis
# (this is only done on primary db, other dbs just need to grab the archive)
.make/modelled_stream_crossings: .make/download_archive
	$(PSQL) -f sql/01_create_output_table.sql

	# load preliminary crossings, iterating through watershed groups for each data source
	parallel $(PSQL) -f sql/02_intersect_dra.sql -v wsg={1} ::: $(WSGS)
	parallel $(PSQL) -f sql/03_intersect_ften.sql -v wsg={1} ::: $(WSGS)
	parallel $(PSQL) -f sql/04_intersect_ogc.sql -v wsg={1} ::: $(WSGS)
	parallel $(PSQL) -f sql/05_intersect_ogcpre06.sql -v wsg={1} ::: $(WSGS)
	parallel $(PSQL) -f sql/06_intersect_railway.sql -v wsg={1} ::: $(WSGS)

	# remove duplicate crossings introduced by using multiple sources
	$(PSQL) -f sql/07_remove_duplicates.sql
	$(PSQL) -f sql/08_identify_open_bottom_structures.sql

	# assign modelled_crossing_id from previous version to ensure consistency
	$(PSQL) -f sql/09_match_archived_crossings.sql
	touch $@

	# dump to file
	ogr2ogr \
		-f GPKG \
		modelled_stream_crossings.gpkg.zip \
		PG:$DATABASE_URL \
		-nlt PointZM \
		-nln modelled_stream_crossings \
		-FID modelled_crossing_id \
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

	#aws s3 cp modelled_stream_crossings.gpkg.zip s3://bcfishpass/modelled_stream_crossings.gpkg.zip
	echo "Latest modelled crossings data now available at:"
	echo "https://bcfishpass.s3.us-west-2.amazonaws.com/modelled_stream_crossings.gpkg.zip"