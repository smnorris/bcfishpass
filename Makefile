.PHONY: all env clean

GENERATED_FILES = .fwapg .bcfishobs .falls

# Make all targets
all: $(GENERATED_FILES)

# Remove all generated targets
clean:
	rm -Rf fwapg
	rm -Rf bcfishobs
	rm -Rf $(GENERATED_FILES)

.fwapg:
	git clone https://github.com/smnorris/fwapg.git
	cd fwapg; make
	touch $@

.bcfishobs: .fwapg
	git clone https://github.com/smnorris/bcfishobs.git
	cd bcfishobs; make
	touch $@

.falls: .bcfishobs .fwapg
	./scripts/prep/barriers/falls/falls.sh
	touch $@

.gradient_barriers:
	./scripts/prep/barriers/gradient_barriers/gradient_barriers.sh
	touch $@