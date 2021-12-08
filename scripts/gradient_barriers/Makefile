.PHONY: all clean 

# point psql to db and stop on errors
PSQL_CMD=psql $(DATABASE_URL) -v ON_ERROR_STOP=1

# process all of BC
GROUPS = $(shell $(PSQL_CMD) -AtX -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")

all: .gradient_barriers

.gradient_barriers:
	$(PSQL_CMD) -c "CREATE TABLE bcfishpass.gradient_barriers ( \
	 blue_line_key             integer               , \
	 downstream_route_measure  double precision      , \
	 gradient_class            integer               , \
	 PRIMARY KEY (blue_line_key, downstream_route_measure) )"
	parallel $(PSQL_CMD) -f sql/gradient_barriers.sql -v wsg={1} ::: $(GROUPS)
	$(PSQL_CMD) -c "CREATE INDEX ON bcfishpass.gradient_barriers (blue_line_key)"
	touch $@

clean:
	$(PSQL_CMD) -c "DROP TABLE bcfishpass.gradient_barriers"
	rm .gradient_barriers