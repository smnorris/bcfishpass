#!/bin/bash
set -euxo pipefail

# restore from dump as required
# pg_restore -Cd $DATABASE_URL bcfishpass_test.dump

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
$PSQL -c "ALTER DATABASE bcfishpass_test SET search_path TO public,whse_basemapping,usgs,hydrosheds"

# test any migrations

# load parameters/data
cd ..

cp parameters/example_testing/*csv parameters
jobs/load_csv
jobs/load_modelled_stream_crossings

# remove crossings not in watersheds of interest
$PSQL -c "delete from bcfishpass.modelled_stream_crossings
          where watershed_group_code not in (
            select
              watershed_group_code
            from whse_basemapping.fwa_watershed_groups_poly
          )"

# run bcfishpass model scripts
jobs/model_gradient_barriers
jobs/model_prep
jobs/model_run

cd test