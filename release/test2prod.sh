#!/bin/bash
set -euxo pipefail

# ===============================
# load bcfishpass from test/staging database to prod database for use by pg_tileserv, pg_featureserv
# ===============================

# create ssh tunnel and forward the port https://gist.github.com/scy/6781836
ssh -o ExitOnForwardFailure=yes -L 63333:localhost:5432 -f $PGHOST_PROD sleep 10

# clear existing bcfishpass tables from prod
psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD -c "DROP SCHEMA IF EXISTS bcfishpass CASCADE"

# load selected tables from test to prod.
pg_dump bcfishpass_test -t bcfishpass.barriers_bt | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.barriers_ch_co_sk | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.barriers_ch_co_sk_b | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.barriers_pk | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.barriers_st | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.barriers_wct | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.crossings | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.observations | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.pscis_not_matched_to_streams | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.streams | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD
pg_dump bcfishpass_test -t bcfishpass.carto_streams_large | psql -h localhost -p 63333 $PGDATABASE_PROD -U $PGUSER_PROD

# clear proprietary Foundry discharge data before re-granting permissions
psql -h localhost -p 63333 $PGDATABSE_PROD -U $PGUSER_PROD -c "UPDATE bcfishpass.streams SET mad_m3s = 0 WHERE watershed_group_code IN ('BULK','HORS','ELKR');"

# re-grant tileserver permissions (because we recreate the schema above)
psql -h localhost -U $PGUSER_PROD -p 63333 -c "GRANT USAGE ON SCHEMA bcfishpass TO tileserver" $PGDATABASE_PROD
psql -h localhost -U $PGUSER_PROD -p 63333 -c "GRANT SELECT ON ALL TABLES IN SCHEMA bcfishpass TO tileserver" $PGDATABASE_PROD
psql -h localhost -U $PGUSER_PROD -p 63333 -c "ALTER DEFAULT PRIVILEGES IN SCHEMA bcfishpass GRANT SELECT ON TABLES TO tileserver" $PGDATABASE_PROD