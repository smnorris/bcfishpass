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

## Post-Export Table Operations
First, connect to the local postgres database

    psql -U <username> -d <database-name>

Drop unused columns

    BEGIN;
    ALTER TABLE <table-name> DROP COLUMN barriers_bt_dnstr, 
    DROP COLUMN barriers_ch_cm_co_pk_sk_dnstr, 
    DROP COLUMN barriers_ct_dv_rb_dnstr, 
    DROP COLUMN barriers_wct_dnstr, 
    DROP COLUMN access_bt, 
    DROP COLUMN access_ch, 
    DROP COLUMN access_cm, 
    DROP COLUMN access_co, 
    DROP COLUMN access_pk, 
    DROP COLUMN access_wct, 
    DROP COLUMN access_salmon, 
    DROP COLUMN access_sk;
    ALTER TABLE <table-name> DROP COLUMN spawning_bt, 
    DROP COLUMN spawning_ch, 
    DROP COLUMN spawning_cm, 
    DROP COLUMN spawning_co, 
    DROP COLUMN spawning_pk, 
    DROP COLUMN spawning_sk, 
    DROP COLUMN spawning_st, 
    DROP COLUMN spawning_wct, 
    DROP COLUMN rearing_bt, 
    DROP COLUMN rearing_ch, 
    DROP COLUMN rearing_co, 
    DROP COLUMN rearing_sk, 
    DROP COLUMN rearing_st, 
    DROP COLUMN rearing_wct, 
    DROP COLUMN mapping_code_bt, 
    DROP COLUMN mapping_code_ch, 
    DROP COLUMN mapping_code_cm, 
    DROP COLUMN mapping_code_co, 
    DROP COLUMN mapping_code_pk, 
    DROP COLUMN mapping_code_sk, 
    DROP COLUMN mapping_code_st,
    DROP COLUMN mapping_code_wct,
    DROP COLUMN mapping_code_salmon; 
    COMMIT;

RENAME access_st column

    BEGIN;
    ALTER TABLE <table-name> RENAME COLUMN barriers_st_dnstr TO barriers_dnstr;
    ALTER TABLE <table-name> RENAME COLUMN access_st TO stream_access_code;
    COMMIT;

Add and calculate stream_access_desc column

    BEGIN;
    ALTER TABLE <table-name> ADD stream_access_desc text;
    UPDATE <table-name>
    SET stream_access_desc = CASE
    WHEN stream_access_code=1 THEN 'Modelled Accessible'
    WHEN stream_access_code=2 THEN 'Observed Accessible'
    WHEN stream_access_code=0 THEN 'Natural barrier downstream - not fish habitat'
    WHEN stream_access_code=-9 THEN 'Not modelled - no fish observations in watershed'
    END;
    COMMIT;
