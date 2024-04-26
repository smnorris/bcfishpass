# A minimal db for development and testing

## Create dump file

Bootstrap a database, load only selected data, dump to file:

    export DATABASE_URL=postgresql://postgres@localhost:5432/bcfishpass_test
    createdb bcfishpass_test
    ./build.sh


## Testing usage

Create database and load data:

    createdb bcfishpass_test
    $PSQL -c "ALTER DATABASE bcfishpass_test SET search_path TO public,whse_basemapping,usgs,hydrosheds"
    pg_restore -d bcfishpass_test bcfishpass_test.dump  # ignore errors, the ltree/fwa_upstream queries and related views work once loaded

Run the model:

    export DATABASE_URL=postgresql://postgres@localhost:5432/bcfishpass_test
    cp parameters/example_testing/*csv parameters
    jobs/load_csv
	jobs/model_prep
	jobs/model_run


## Validation

1. obviously, did all jobs complete?
2. is modelled habitat / barrier count / etc reasonably equivalent to previous output?
    
For item 2, how do we define/record previous outputs to make a comparison?  
Multiple runs in the same testing db works for local dev, and for current GHA workflows - but for a GHA workflow where a temp db is created for the build, compare file based outputs/summaries?