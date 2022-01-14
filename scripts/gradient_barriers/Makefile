.PHONY: all clean 

# point psql to db and stop on errors
PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1

# process all of BC
GROUPS = $(shell $(PSQL_CMD) -AtX -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")

all: .gradient_barriers

.gradient_barriers: sql/gradient_barriers.sql
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass.gradient_barriers"
	$(PSQL_CMD) -c "CREATE TABLE bcfishpass.gradient_barriers ( \
	 blue_line_key             integer               , \
	 downstream_route_measure  double precision      , \
	 wscode_ltree              ltree                 , \
	 localcode_ltree           ltree                 , \
	 watershed_group_code      character varying(4)  , \
	 gradient_class            integer               , \
	 PRIMARY KEY (blue_line_key, downstream_route_measure) )"
	parallel $(PSQL_CMD) -f sql/gradient_barriers.sql -v wsg={1} ::: $(GROUPS)
	$(PSQL_CMD) -c "create index if not exists grdntbr_blk_idx on bcfishpass.gradient_barriers (blue_line_key);"
	$(PSQL_CMD) -c "create index if not exists grdntbr_wsgcode_idx on bcfishpass.gradient_barriers (watershed_group_code);"
	$(PSQL_CMD) -c "create index if not exists grdntbr_wscode_gidx on bcfishpass.gradient_barriers using gist (wscode_ltree);"
	$(PSQL_CMD) -c "create index if not exists grdntbr_wscode_bidx on bcfishpass.gradient_barriers using btree (wscode_ltree);"
	$(PSQL_CMD) -c "create index if not exists grdntbr_localcode_gidx on bcfishpass.gradient_barriers using gist (localcode_ltree);"
	$(PSQL_CMD) -c "create index if not exists grdntbr_localcode_bidx on bcfishpass.gradient_barriers using btree (localcode_ltree);"
	touch $@

clean:
	rm -Rf .gradient_barriers
	$(PSQL_CMD) -c "DROP TABLE IF EXISTS bcfishpass.gradient_barriers"