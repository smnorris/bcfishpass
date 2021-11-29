.PHONY: all env clean

# Ensure psql stops on error so make script stops when there is a problem
PSQL_CMD = psql $(DATABASE_URL) -v ON_ERROR_STOP=1

# barrier targets
BARRIERS = .dams .falls .pscis

GENERATED_FILES = .fwapg .bcfishobs $(BARRIERS)
#.gradient_barriers .dams .pscis .modelled_stream_crossings .misc_definite .misc_anthropogenic

# Make all targets
all: $(GENERATED_FILES)

# Remove all generated targets
clean:
	rm -Rf fwapg
	rm -Rf bcfishobs
	rm -Rf $(GENERATED_FILES)


# load fwapg and bcfishobs by downloading the separate code
# and running the individual makefiles
fwapg:
	git clone https://github.com/smnorris/fwapg.git

.fwapg: fwapg
	cd fwapg; make
	touch $@

bcfishobs: .fwapg
	git clone https://github.com/smnorris/bcfishobs.git

.bcfishobs: bcfishobs
	cd bcfishobs; make
	touch $@


$(BARRIERS): .fwapg
	$(PSQL_CMD) -c "CREATE SCHEMA IF NOT EXISTS bcfishpass" # make sure schema exists before starting
	cd scripts/prep/barriers/$(subst .,,$@); ./$(subst .,,$@).sh
	touch $@

