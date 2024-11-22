# A minimal db for development and testing

## Create database dump file

Bootstrap database `bcfishpass_test` with latest schema, fwapg/bcfishobs, load selected data, dump to file:

    ./build_db.sh

## Test bcfishpass scripts

Run model:

    ./test.sh

## Validation

1. obviously, did all jobs complete?
2. is modelled habitat / barrier count / etc reasonably equivalent to previous output?
    
For item 2, how do we define/record previous outputs to make a comparison?  
Multiple runs in the same testing db works for local dev, and for current GHA workflows - but for a GHA workflow where a temp db is created for the build, compare file based outputs/summaries?