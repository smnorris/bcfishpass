#!/bin/bash
set -euxo pipefail

# ===============================
# load bcfishpass from test/staging database to prod database for use by pg_tileserv, pg_featureserv
# ===============================

# create ssh tunnel and forward the port https://gist.github.com/scy/6781836
ssh -o ExitOnForwardFailure=yes -L 63333:localhost:5432 -f $PGHOST_PROD sleep 10

# load all bcfishpass tables present in test db to prod db
# (this is not the full set of dev tables, just those that make sense to publish)
psql -h localhost -p 63333 $PGDATABASE_PROD -U snorris -c "DROP SCHEMA IF EXISTS bcfishpass CASCADE"
pg_dump -n bcfishpass bcfishpass_test | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD

# clear proprietary Foundry discharge data before re-granting permissions
psql -h localhost -p 63333 $PGDATABSE_PROD -U PGUSER_PROD -c "UPDATE bcfishpass.streams SET mad_m3s = 0 WHERE watershed_group_code IN ('BULK','HORS','ELKR');"

# re-grant tileserver permissions (because we recreate the schema above)
psql -h localhost -U $PGUSER_PROD -p 63333 -c "GRANT USAGE ON SCHEMA bcfishpass TO tileserver" $PGDATABASE_PROD
psql -h localhost -U $PGUSER_PROD -p 63333 -c "GRANT SELECT ON ALL TABLES IN SCHEMA bcfishpass TO tileserver" $PGDATABASE_PROD
psql -h localhost -U $PGUSER_PROD -p 63333 -c "ALTER DEFAULT PRIVILEGES IN SCHEMA bcfishpass GRANT SELECT ON TABLES TO tileserver" $PGDATABASE_PROD