.PHONY: all clean 

# point psql to db and stop on errors
PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1

# process all of BC
GROUPS = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")

all: .make/gradient_barriers

.make/gradient_barriers: sql/gradient_barriers.sql
	mkdir -p .make
	$(PSQL) -c "DROP TABLE IF EXISTS bcfishpass.gradient_barriers"
	$(PSQL) -c "CREATE TABLE bcfishpass.gradient_barriers ( \
	 blue_line_key             integer               , \
	 downstream_route_measure  double precision      , \
	 wscode_ltree              ltree                 , \
	 localcode_ltree           ltree                 , \
	 watershed_group_code      character varying(4)  , \
	 gradient_class            integer               , \
	 PRIMARY KEY (blue_line_key, downstream_route_measure) )"
	parallel $(PSQL) -f sql/gradient_barriers.sql -v wsg={1} ::: $(GROUPS)
	$(PSQL) -c "create index if not exists grdntbr_blk_idx on bcfishpass.gradient_barriers (blue_line_key);"
	$(PSQL) -c "create index if not exists grdntbr_wsgcode_idx on bcfishpass.gradient_barriers (watershed_group_code);"
	$(PSQL) -c "create index if not exists grdntbr_wscode_gidx on bcfishpass.gradient_barriers using gist (wscode_ltree);"
	$(PSQL) -c "create index if not exists grdntbr_wscode_bidx on bcfishpass.gradient_barriers using btree (wscode_ltree);"
	$(PSQL) -c "create index if not exists grdntbr_localcode_gidx on bcfishpass.gradient_barriers using gist (localcode_ltree);"
	$(PSQL) -c "create index if not exists grdntbr_localcode_bidx on bcfishpass.gradient_barriers using btree (localcode_ltree);"
	touch $@

clean:
	rm -Rf .make
	$(PSQL) -c "DROP TABLE IF EXISTS bcfishpass.gradient_barriers"