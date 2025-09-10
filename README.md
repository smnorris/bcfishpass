# bcfishpass

`bcfishpass` is a collection of scripts to create and maintain an aquatic connectivity / fish passage database for British Columbia to:

- track known barriers to fish passage (eg dams, waterfalls)
- work with assessed BC Provincial Stream Crossing Information System (PSCIS) crossings
- model potential barriers to fish passage (stream gradient, road/rail stream crossings)
- model passability/accessibility of streams based on species swimming ability
- model streams with potential for spawning and rearing activity (for select species)
- report on habitat/connectivity based indicators to support prioritization of assessment and remediation
- support mapping in office and field via a comprehensive QGIS layer file


See the [Documentation](https://smnorris.github.io/bcfishpass/) for details.

## General requirements

- bash
- GDAL
- PostgreSQL / PostGIS
- Python
- [bcdata](https://github.com/smnorris/bcdata)
- [fwapg](https://github.com/smnorris/fwapg)
- [bcfishobs](https://github.com/smnorris/bcfishobs)

## Development setup

`bcfishpass` is a collection of shell/sql/Python scripts. To download and use the latest:

    git clone https://github.com/smnorris/bcfishpass.git
    cd bcfishpass

All scripts presume the path to an existing PostGIS enabled database is defined by the environment variable `$DATABASE_URL`:

    export DATABASE_URL=postgresql://postgres@localhost:5432/bcfishpass

Install all other required tools/dependencies using your preferred package manager or via Docker.
A `conda` environment and a `Dockerfile` are provided:

#### Conda

    conda env create -f environment.yml
    conda activate bcfishpass
    jobs/<script>

#### Docker

    docker compose build
    docker compose up -d
    docker compose run --rm runner jobs/<script>

Docker is configured to write the database to `postgres-data` - even if containers are deleted, the database will be retained here.
If you have shut down Docker or the container, start it up again with this command:

    docker-compose up -d

Connect to the db from your host OS via the port specified in `docker-compose.yml`:

    psql -p 8001 -U postgres bcfishpass

Stop the containers (without deleting):

    docker compose stop

Delete the containers:

    docker compose down

To build/load/dump a small database for development/testing:

    docker compose build
    docker compose up -d
    cd test
    docker compose run --rm runner test/build_db.sh

Note that `build_db.sh` dumps all required inputs to a postgresql dump file - once it has been run once, a testing database can be quickly restored from the dump rather than loading from scratch:

    cd ..
    docker compose down           # shut down the vm
    rm -rf postgres-data          # remove the testing db data folder
    docker compose up -d          # restart docker, create_db is automatically run
    pg_restore -d $DATABASE_URL test/bcfishpass_test.dump  # call restore from local OS

Run the models on the testing watershed groups:

    docker compose run --rm runner test.sh
