# A minimal db for development and testing

## Create database dump file

Bootstrap database `bcfishpass_test` with fwapg, the latest bcfishpass schema, load selected data:

    ./build_db.sh

## Run bcfishpass model

Run model:

    ./test.sh

## Validation

1. obviously, did all jobs complete?
2. is modelled habitat / barrier count / etc reasonably equivalent to previous output? (see bcfishpass.log_* tables and views)