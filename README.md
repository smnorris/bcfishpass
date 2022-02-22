# bcfishpass

`bcfishpass` is a set of scripts to create and maintain an aquatic connectivity / fish passage database for British Columbia to:

- track known barriers to fish passage (eg dams, waterfalls)
- work with BC Provincial Stream Crossing Information System (PSCIS) crossings and barriers
- model potential barriers to fish passage (stream gradient, road/rail stream crossings)
- model passability/accessibility of streams based on barriers and species swimming ability
- model potential habitat (spawning and rearing) for select species
- prioritize assessment and remediation of barriers based on modelled accessibility and habitat

Also provided are tools for mapping features in the database:

- comprehensive QGIS layer file
- basic MapboxGL stylesheet and web page


## General Methodology

`bcfishpass` is an update to the BC Fish Passage Technical Working Group (FPTWG) Fish Passage modelling - the basic logic for evaluating connectivity is much the same as in previous versions.

Using the [BC Freshwater Atlas](https://github.com/smnorris/fwapg) as the mapping base:

1. Collect data defining known definite/fixed barriers to fish passage (waterfalls >5m, subsurface flow, hydro dams that are not feasible to remediate) and reference to the stream network
2. Model stream gradient barriers (where a stream slope is steeper than a given percentage for >=100m)
3. Using [Known Fish Observations referenced to streams](https://github.com/smnorris/bcfishobs), override/remove barriers downstream of a known observation (where applicable)
4. Classify all streams downstream of resulting barriers as `POTENTIALLY ACCESSIBLE` (ie, ignoring other barriers such as insufficent flow, temperature, etc a migratory fish of a given swimming ability could potentially access all these streams if no anthropogenic barrers are present)
5. Collect known (dams, PSCIS crossings) and modelled (road/railway stream crossings, ie culverts) anthropogenic barriers
6. Prioritize anthropogenic barriers for assessment or remediation by reporting on how much `POTENTIALLY ACCESSIBLE` stream is upstream of each barrier (and downstream of other anthropogenic barriers)

To improve prioritization of barriers, `bcfishpass` also includes basic habitat potential modelling. Habitat potential for spawning and rearing is based on:

1. Stream gradient
2. Stream discharge / stream channel width (modelled discharge where available, modelled channel width where discharge unavailable)
3. Various species-specific connectivitiy criteria (eg. sockeye spawn must be connected to rearing lakes)

Streams meeting the criteria for a given species are classified as spawning or rearing habitat and the amount of spawning/rearing habitat upstream of barriers can be summarized for barrier prioritization.


## General requirements

- bash or similar
- GDAL (>= 3.4)
- a PostgreSQL / PostGIS database (tested with v14/v3.1)
- Python >= 3.7
- [bcdata](https://github.com/smnorris/bcdata)


## Installation / Setup

`bcfishpass` is a collection of shell/sql/Python scripts - no installation is required. To download and use the latest:

    git clone https://github.com/smnorris/bcfishpass.git
    cd bcfishpass

Presuming PostgreSQL/PostGIS are already installed, the easiest way to install dependencies is likely via `conda`.
A `environment.yml` is provided to set up the processing environment. Edit the environment variables in this file as required (to match your database connection parameters) and then create/activate the environment:

    conda env create -f environment.yml
    conda activate bcfishpass

Note that `cdo` is not currently available on `conda-forge` for ARM based Macs. If you're using an ARM based mac, comment out `cdo` in `environment.yml` and install `cdo` separately (compiling from source).

If the database you are working with does not already exist, create it:

    psql -c "CREATE DATABASE bcfishpass" postgres


## Docker

Rename `.env.docker` to `.env` and edit the ports to be exposed as required. The defaults are fine, the option is only provided to avoid conflicts in case of other Docker services running at these ports.

Download the repo, create containers, create database, load all data:

    git clone https://github.com/smnorris/bcfishpass.git
    cd bcfishpass

Edit the ports mappings as required in `.env` (to avoid conflicts with ports already in use), then build and start the services:

    docker-compose build
    docker-compose up -d
    docker-compose run --rm client psql -c "CREATE DATABASE bcfishpass" postgres
    docker-compose run --rm client make

A `postgres-data` folder is created by the database container as a volume for all postgres data.

If you have shut down Docker or the container, start it up again with this command:

    docker-compose up -d

Connect to the db and tilesev/featureserv clients from your host OS via the ports specified in `.env`:

    psql -p 8000 -U postgres fwapg
    http://localhost:7800/
    http://localhost:9000/

Delete the containers (and associated data):

    docker-compose down


## Credits

These tools are made possible by the work and funding of the following groups:

- [BC Fish Passage Technical Working Group (FPTWG)](https://www2.gov.bc.ca/gov/content/environment/plants-animals-ecosystems/fish/aquatic-habitat-management/fish-passage)
- [Canadian Wildlife Federation (CWF)](https://cwf-fcf.org/en/explore/fish-passage/breaking-down-barriers.html)
- [BC Salmon Restoration and Innovation Fund (BCSRIF)](https://www.dfo-mpo.gc.ca/fisheries-peches/initiatives/fish-fund-bc-fonds-peche-cb/index-eng.html)
- [Canada Nature Fund for Aquatic Species at Risk (CNFASAR)](https://www.dfo-mpo.gc.ca/species-especes/sara-lep/cnfasar-fnceap/index-eng.html)
- [BC Fish and Wildlife Compensation Program (FWCP)](https://fwcp.ca/)
- [Society for Ecosystem Restoration in Northern British Columbia (SERNBC)](https://sernbc.ca/)
- [New Graph Environment](https://www.newgraphenvironment.com/)
- [Hillcrest Geographics](https://www.hillcrestgeo.ca)
