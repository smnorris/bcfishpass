PSQL = psql $(DATABASE_URL) -v ON_ERROR_STOP=1 # Ensure psql stops on error
WSGS = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.watershed_groups_access")

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

# run the overlays/analysis
.make/modelled_stream_crossings: .make/download_archive .make/download_bcdata
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
	echo "new modelled stream crossings created, see bcfishpass/release for loading to s3"
	touch $@