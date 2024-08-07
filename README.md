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
- GDAL (tested with v3.6)
- a PostgreSQL / PostGIS database (tested with v14/v3.3)
- Python (tested with v3.11.0)
- [bcdata](https://github.com/smnorris/bcdata)
- [fwapg](https://github.com/smnorris/fwapg)
- [bcfishobs](https://github.com/smnorris/bcfishobs)

## Setup / Usage

`bcfishpass` is a collection of shell/sql/Python scripts. To download and use the latest:

    git clone https://github.com/smnorris/bcfishpass.git
    cd bcfishpass

Install required tools using your preferred method. For local development, `conda` can be simplest:

    conda env create -f environment.yml
    conda activate bcfishpass

A Docker image is also provided:

    docker pull ghcr.io/smnorris/bcfishpass:main

If the database you are working with does not already exist, create it:

    createdb bcfishpass

All scripts presume that the `DATABASE_URL` environment variable points to your database. For example:

    export DATABASE_URL=postgresql://postgres@localhost:5432/bcfishpass

Load FWA:

    git clone https://github.com/smnorris/fwapg
    cd fwapg
    make --debug=basic

Load/run `bcfishobs`:

    git clone git@github.com:smnorris/bcfishobs.git
    cd bcfishobs
    make --debug=basic

Create db schema:

    jobs/db_setup

Load source data:

    jobs/load_static                     
    jobs/load_monthly
    jobs/load_weekly
    jobs/load_modelled_stream_crossings

Run the model:

    jobs/model_stream_crossings    # (optionally - this is only needs to be run on the primary provincial bcfishpass database)
    jobs/model_prep
    jobs/model_run

# Backups

Backup strategies will vary but it can be useful to dump the entire database to file.  
This appends the date and commit tag date to the file name:

        pg_dump -Fc $DATABASE_URL > bcfishpass.$(git describe --tags --abbrev=0).$(date +%F).dump    