.PHONY: all clean

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
#WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")
WSG=BULK HORS LNIC ELKR

SPP = $(patsubst sql/%.sql, .make/%, $(wildcard sql/model_habitat_*.sql))

all: .make/model_habitat_linear

clean:
	rm -rf .make

# ensure indexes are warm and ready, habitat connectivity queries are far too slow without them.
.make/streams: 
	mkdir -p .make
	$(PSQL) -c "VACUUM ANALYZE bcfishpass.streams"
	touch $@

# run per-species habitat queries
$(SPP): .make/model_habitat_%: sql/model_habitat_%.sql .make/streams
	$(eval SPP=$(subst .make/model_habitat_,,$@))
	for wsg in $(WSG) ; do \
		set -e ; $(PSQL) -f sql/model_habitat_$(SPP).sql -v wsg=$$wsg ; \
	done
	touch $@

# override the model where specified by manual_habitat_classification, requires first creating endpoints & breaking the streams
.make/model_habitat_linear: $(SPP)
	$(PSQL) -f sql/user_habitat_classification_endpoints.sql
	for wsg in $(WSG) ; do \
		set -e ; $(PSQL) -f ../model_access/sql/break_streams_wrapper.sql -v wsg=$$wsg -v point_table=user_habitat_classification_endpoints ; \
	done
	$(PSQL) -f sql/user_habitat_classification.sql
	touch $@