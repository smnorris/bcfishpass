.PHONY: all env clean

GENERATED_FILES = .fwapg .bcfishobs .falls

# Ensure psql stops on error so make script stops when there is a problem
PSQL_CMD = psql -v ON_ERROR_STOP=1

# barrier load scripts
BARRIERS = falls gradient_barriers dams pscis modelled_stream_crossings misc_definite misc_anthropogenic

# Make all targets
all: $(GENERATED_FILES)

# Remove all generated targets
clean:
	rm -Rf fwapg
	rm -Rf bcfishobs
	rm -Rf $(GENERATED_FILES)

fwapg:
	git clone https://github.com/smnorris/fwapg.git

.fwapg: fwapg
	cd fwapg; make
	$(PSQL_CMD) -c "CREATE SCHEMA IF NOT EXISTS bcfishpass"
	touch $@

bcfishobs: .fwapg
	git clone https://github.com/smnorris/bcfishobs.git

.bcfishobs: bcfishobs
	cd bcfishobs; make
	touch $@


$(BARRIERS): .fwapg
	cd load/scripts/barriers/$@; ./$@.sh
	touch .$@

