# Release bcfishpass data

Cut a data release, copying key tables from local dev db to:

- local test db
- remote prod db(s)
- local file dump

## Setup

Requires these environment variables are set:

    $PGHOST_PROD
    $PGDATABASE_PROD
    $PGUSER_PROD

## Usage

1. Generate summary stats for release candidate (length in km of habitat etc):

        psql -f sql/totals.sql


2. Copy full bcfishpass schema from dev to test

        ./dev2test.sh


3. When ready, publish from test to prod

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