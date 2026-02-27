#!/bin/bash
set -euxo pipefail

# if test db is dumped to file, restore from dump as required
# pg_restore -Cd $DATABASE_URL bcfishpass_test.dump

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
# $PSQL -c "ALTER DATABASE bcfishpass_test SET search_path TO public,whse_basemapping,usgs,hydrosheds"

# load parameters/data
cp parameters/example_testing/*csv parameters
jobs/load_csv
jobs/load_modelled_stream_crossings

# run bcfishpass model 
# note that load_gradient_barriers processes all watershed groups present in
# whse_basemapping.fwa_watershed_groups_poly. To process a subset, either edit script
# jobs/load_gradient_barriers or drop polygons from the watershed groups table. 
# (models are processed just in groups listed in parameters/example_testing/habitat_method.csv)
jobs/load_gradient_barriers
jobs/model_01_prep
jobs/model_02_access_natural
jobs/model_03_access_anthropgenic
jobs/model_04_habitat_linear