.PHONY: all clean

PSQL=psql $(DATABASE_URL) -v ON_ERROR_STOP=1          # point psql to db and stop on errors
WSG = $(shell $(PSQL) -AtX -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

all: .make/habitat_linear

# -----
# MEAN ANNUAL PRECIPITATION
# -----
precipitation/.make/precip:
	cd precipitation ; mkdir -p .make ; ./mean_annual_precip.sh
	touch $@

# -----
# CHANNEL WIDTH
# -----
channel_width/.make/channel_width: precipitation/.make/precip
	cd channel_width; make

# -----
# DISCHARGE
# -----
discharge/.make/discharge: precipitation/.make/precip
	cd discharge; make

# -----
# LINEAR HABITAT MODEL
# -----
.make/habitat_linear: channel_width/.make/channel_width \
	discharge/.make/discharge
	mkdir -p .make
	./habitat_linear.sh
	touch $@