#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")

cd ..
# load/report on 100m
psql $DATABASE_URL -c "truncate bcfishpass.gradient_barriers"
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=100 -v wsg={1} ::: $WSGS
cd analysis
psql $DATABASE_URL -f sql/01_obs_max_grade_dnstr.sql
psql $DATABASE_URL -f sql/02_obs_grade_upstr.sql
psql $DATABASE_URL -f sql/03_obs_max_grade_dnstr_dist_to_ocean.sql
psql $DATABASE_URL -f sql/04_obs_dist_to_ocean.sql
psql $DATABASE_URL -f sql/05_obs_grades_dnst.sql
psql $DATABASE_URL -f sql/report_obs.sql --csv > fiss_observations_gradients_100m.csv

# load/report on 50m
cd ..
psql $DATABASE_URL -c "truncate bcfishpass.gradient_barriers"
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=50 -v wsg={1} ::: $WSGS
cd analysis
psql $DATABASE_URL -f sql/01_obs_max_grade_dnstr.sql
psql $DATABASE_URL -f sql/02_obs_grade_upstr.sql
psql $DATABASE_URL -f sql/03_obs_max_grade_dnstr_dist_to_ocean.sql
psql $DATABASE_URL -f sql/04_obs_dist_to_ocean.sql
psql $DATABASE_URL -f sql/05_obs_grades_dnst.sql
psql $DATABASE_URL -f sql/report_obs.sql --csv > fiss_observations_gradients_50m.csv

# load/report on 25m
cd ..
psql $DATABASE_URL -c "truncate bcfishpass.gradient_barriers"
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=25 -v wsg={1} ::: $WSGS
cd analysis
psql $DATABASE_URL -f sql/01_obs_max_grade_dnstr.sql
psql $DATABASE_URL -f sql/02_obs_grade_upstr.sql
psql $DATABASE_URL -f sql/03_obs_max_grade_dnstr_dist_to_ocean.sql
psql $DATABASE_URL -f sql/04_obs_dist_to_ocean.sql
psql $DATABASE_URL -f sql/05_obs_grades_dnst.sql
psql $DATABASE_URL -f sql/report_obs.sql --csv > fiss_observations_gradients_25m.csv
