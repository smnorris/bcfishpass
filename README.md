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

## Setup

`bcfishpass` is a collection of shell/sql/Python scripts. To download and use the latest:

    git clone https://github.com/smnorris/bcfishpass.git
    cd bcfishpass

If running the scripts on your host OS, install required tools/dependencies using your preferred package manager.
See the `Dockerfile` for the list of tools required. Note that all scripts presume the path to an existing PostGIS 
enabled database is defined by the environment variable `$DATABASE_URL`:

    export DATABASE_URL=postgresql://postgres@localhost:5432/bcfishpass

#### Docker 

Clone the repository as above, start the containers:

    docker compose up -d

Load FWA and other required data:

    docker compose run --rm runner jobs/setup

Docker is configured to write the database to `postgres-data` - even if containers are deleted, the database will be retained here.
If you have shut down Docker or the container, start it up again with the same `up` command:

    docker-compose up -d

Connect to the db from clients on your host OS (eg psql/QGIS/PgAdmin/etc) via `localhost` and `port=8000` (or as specified in `.env` like this: 

    psql postgresql://postgres@localhost:8000/fwapg
    psql -p 8000 -U postgres fwapg                     # shorter

To run default habitat models on the watershed groups specified in `parameters/example_testing`:

    docker compose run --rm runner jobs/test

Drop in to the docker container to interactively run scripts as needed:

    docker compose run -it --rm runner bash
    