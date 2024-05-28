#!/bin/bash
set -euxo pipefail

DATABASE_URL=postgresql://postgres@localhost:5432/bcfishpass_test
PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

createdb bcfishpass_test
$PSQL -c "ALTER DATABASE bcfishpass_test SET search_path TO public,whse_basemapping,usgs,hydrosheds"
pg_restore -d bcfishpass_test bcfishpass_test.dump

# jobs are called from project root folder
cd ..

cp parameters/example_testing/*csv parameters

# setup bcfishpass schema, but not the reporting views
for sql in db/bcfishpass/tables/*.sql ; do
  $PSQL -f "$sql"
done

for sql in db/bcfishpass/views/*.sql ; do
  $PSQL -f "$sql"
done

for sql in db/bcfishpass/functions/*.sql ; do
  $PSQL -f "$sql"
done

jobs/load_csv
jobs/load_modelled_stream_crossings
$PSQL -c "delete from bcfishpass.modelled_stream_crossings where watershed_group_code not in (select watershed_group_code from whse_basemapping.fwa_watershed_groups_poly)"
jobs/model_gradient_barriers
jobs/model_prep
jobs/model_run

cd test