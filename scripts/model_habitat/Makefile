.PHONY: all clean

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")


all: .make/model_habitat

clean:
	rm -rf .make

.make/model_habitat:
	# first, ensure the spatial index gets used, 
	# spatial clustering in rearing queries is basically non-functional without it
	$(PSQL) -c "VACUUM ANALYZE bcfishpass.streams"

	# run per-species models per watershed group
	for wsg in $(WSG) ; do \
		set -e ; $(PSQL) -f sql/model_habitat_bt.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f sql/model_habitat_ch.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f sql/model_habitat_co.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f sql/model_habitat_sk.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f sql/model_habitat_st.sql -v wsg=$$wsg ; \
		set -e ; $(PSQL) -f sql/model_habitat_wct.sql -v wsg=$$wsg ; \
	done

	# override the model where specified by manual_habitat_classification, requires first creating endpoints & breaking the streams
	$(PSQL) -f sql/user_habitat_classification_endpoints.sql
	for wsg in $(WSG) ; do \
		set -e ; $(PSQL) -f ../model_access/sql/break_streams_wrapper.sql -v wsg=$$wsg -v point_table=user_habitat_classification_endpoints ; \
	done
	$(PSQL) -f sql/user_habitat_classification.sql
	touch $@