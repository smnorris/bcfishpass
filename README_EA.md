# Setting up bcfishpass for the first time using WSL
All commands are executed in Ubuntu

## Clone the repo

    git clone https://github.com/emarmitage/bcfishpass.git
    cd bcfishpass

## Docker quickstart

Clone the repository as above, then build and start the containers:

    docker compose build
    docker compose up -d

Create the database schema and load FWA and other required data (this takes some time):

    docker compose run --rm runner bash -lc 'test/build_db.sh'

To run the habitat models on watershed groups specified in `parameters/example_testing`:

    docker compose run --rm runner bash -lc 'test/test.sh'

## Explore DB

See db tables:

    docker compose exec db psql -U postgres -d bcfishpass_test
    \dt *.*
    \q (to quit)

See db views:

    docker compose exec db psql -U postgres -d bcfishpass_test
    \dv *.*
    \q (to quit)    

Count the records for a given table:

    docker compose exec db psql -U postgres -d bcfishpass_test
    SELECT COUNT(*) FROM <TABLE_NAME>;
    \q

See table/view schema and data: 

    docker compose exec db psql -U postgres -d bcfishpass_test
    \d+ <TABLE_NAME>
    \q
    SELECT * FROM <TABLE_NAME> LIMIT 10;

## Export data from DB in docker container to WSL localhost
Check if bcfishpass exists in local db:

    sudo -u postgres psql
    \l
    \q

OR

    sudo -u postgres psql -d bcfishpass
    \q

If local db does not exist, create it and install the required extensions:

    sudo -u postgres createdb <LOCAL_DB_NAME>
    sudo -u postgres psql <LOCAL_DB_NAME> -c "CREATE EXTENSION postgis;"
    sudo -u postgres psql <LOCAL_DB_NAME> -c "CREATE EXTENSION ltree;"

Make yourself the owner:

    sudo -u postgres psql -c "ALTER DATABASE <LOCAL_DB_NAME> OWNER TO <USERNAME>;"

### Export Views
Create a table in docker db from the view object:

    docker compose run --rm runner bash -lc '
    psql "$DATABASE_URL" -c "
    CREATE TABLE public.<DESTINATION_TABLE_NAME> AS
    SELECT *
    FROM bcfishpass.<VIEW_OBJECT_NAME>;"'

Dump the files outside the docker container:

    docker compose run --rm runner bash -lc '
    pg_dump "$DATABASE_URL" \
        --table=public.<TABLE_NAME> \
        --format=custom
    ' > <DUMP_FILE_NAME>.dump

Restore the dump file to local db:

    pg_restore \
        --dbname=<LOCAL_DB_NAME> \
        --no-owner \
        --no-privileges \
    <DUMP_FILE_NAME>.dump

Verify that the table exists in your local db:

    psql <LOCAL_DB_NAME> -c "\dt public.*"

You can now connect to the db and view the data in PGAdmin, QGIS. You may need to set a password on the db and find the WSL IP address to connect to the db. 



