# Release bcfishpass data

Cut a data release, copying key tables from local dev db to:

- local test db
- remote prod db
- local file dump

## Setup

Requires these environment variables are set:

    $PGHOST_PROD
    $PGDATABASE_PROD
    $PGUSER_PROD

## Usage

1. Ensure local test db exists, plus required extensions

        psql -c "create database bcfishpass_test"
        psql $DATABASE_URL_TEST -c "create extension postgis"
        psql $DATABASE_URL_TEST -c "create extension ltree"
        psql $DATABASE_URL_TEST -c "create extension intarray"

2. Copy key output tables from local dev db to local test db

        ./dev2test.sh

3. Push `bcfishpass` schema from local test db to production db

        ./test2prod.sh

4. Dump to file:

        ./dump.sh

To be automated:

5. Upload files to server.

6. Update basic mapping app on server.

7. Tag a code release to match the data release.

8. Archive (dump to file) key input data sources associated with the release:
    - roads
    - railways
    - other?

9. Archive modelled crossings layer for use with future model runs (to preserve id values)