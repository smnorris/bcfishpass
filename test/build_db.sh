#!/bin/bash
set -euxo pipefail

# ------
# Build a bcfishpass database for testing
# - all data required for habitat modelling is loaded (including the full FWA)
# - various extra land use / admin / etc data used for mapping/reporting are not loaded
# ------

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS="BELA\nBULK\nCOWN\nELKR\nHORS\nLNIC\nPARS\nSANJ\nVICT"       # edit here to adjust testing watersheds (could pull from parameters/example_testing/parameters_habitat_method)

# ------
# load FWA and associated data
# ------
git clone https://github.com/smnorris/fwapg
cd fwapg
cd db && ./create.sh && cd ..
./load.sh
cd .. ; rm -rf fwapg

# ------
# load schemas for various other sources
# ------
cd db/sources; ./migrate.sh; cd ..

# ------
# load latest bcfishpass schema
# ------
# show version of the bcfishpass schema
aws s3api get-object-tagging --bucket bchamp --key bcfishpass.sql --no-sign-request 
# load the schema
curl https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass.sql | psql $DATABASE_URL

# ------
# load species codes, required for bcfishpass table constraints
# ------
$PSQL -c "\copy whse_fish.species_cd FROM PROGRAM 'curl -s https://raw.githubusercontent.com/smnorris/fishbc/master/data-raw/whse_fish_species_cd/whse_fish_species_cd.csv' delimiter ',' csv header"

cd jobs
./load_monthly
./load_weekly
./load_observations

# vaccum/analyze
$PSQL -c "vacuum full analyze"

$PSQL -c "ALTER DATABASE bcfishpass_test SET search_path TO public,whse_basemapping,usgs,hydrosheds"

# optionally, dump to local file for quicker re-creation of db as needed (vs reload of FWA)
# pg_dump -Fc $DATABASE_URL > bcfishpass_test.dump
