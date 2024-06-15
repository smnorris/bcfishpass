#!/bin/bash
set -euxo pipefail

DATABASE_URL=postgresql://postgres@localhost:5432/bcfishpass_test
PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

createdb bcfishpass_test
$PSQL -c "ALTER DATABASE bcfishpass_test SET search_path TO public,whse_basemapping,usgs,hydrosheds"
pg_restore -d bcfishpass_test bcfishpass_test.dump

# drop the existing schema and postgisftw.wcrp functions from test db
$PSQL -c "drop schema bcfishpass cascade"
$PSQL -c "drop function postgisftw.wcrp_barrier_count"
$PSQL -c "drop function postgisftw.wcrp_barrier_extent"
$PSQL -c "drop function postgisftw.wcrp_barrier_severity"
$PSQL -c "drop function postgisftw.wcrp_habitat_connectivity_status"


# run all migration scripts present in /db
cd ../db
for tag in v* ;do
    cd "$tag"; ./migrate.sh; cd ..
done
cd ..

# load parameters and run jobs
cp parameters/example_testing/*csv parameters
jobs/load_csv
jobs/load_modelled_stream_crossings
$PSQL -c "delete from bcfishpass.modelled_stream_crossings where watershed_group_code not in (select watershed_group_code from whse_basemapping.fwa_watershed_groups_poly)"
jobs/model_gradient_barriers
jobs/model_prep
jobs/model_run

cd test