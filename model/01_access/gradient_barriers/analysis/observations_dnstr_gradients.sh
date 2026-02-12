#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

cd ..

# load gradients to various bcfishpass.gradient_barriers_<length> tables
psql $DATABASE_URL -c "truncate bcfishpass.gradient_barriers"
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=100 -v wsg={1} ::: $WSGS
psql $DATABASE_URL -c "create table bcfishpass.gradient_barriers_100 as select * from bcfishpass.gradient_barriers"

psql $DATABASE_URL -c "truncate bcfishpass.gradient_barriers"
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=50 -v wsg={1} ::: $WSGS
psql $DATABASE_URL -c "create table bcfishpass.gradient_barriers_50 as select * from bcfishpass.gradient_barriers"

psql $DATABASE_URL -c "truncate bcfishpass.gradient_barriers"
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=25 -v wsg={1} ::: $WSGS
psql $DATABASE_URL -c "create table bcfishpass.gradient_barriers_25 as select * from bcfishpass.gradient_barriers"

# report
cd analysis
psql $DATABASE_URL -f sql/compare_gradients_25_50_100m.sql --csv > fiss_observations_gradients_25_50_100.csv
