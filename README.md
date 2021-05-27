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


## Requirements

- bash (primarily tested on macOS but should work on Linux or Windows Subsystem for Linux)
- PostgreSQL/PostGIS (tested with 13.2/3.1.1, requires Postgres >= 12)
- Python >= 3.7
- [bcdata](https://github.com/smnorris/bcdata)
- a FWA database loaded via [`fwapg`](https://github.com/smnorris/fwapg) >= v0.1.1
- [bcfishobs](https://github.com/smnorris/bcfishobs) (BC fish observations and obstacles, loaded and processed)


## Installation / Setup

`bcfishpass` is a collection of shell/sql/Python scripts - no installation is required, just download the scripts:

    git clone https://github.com/smnorris/bcfishpass.git
    cd bcfishpass

Presuming PostgreSQL/PostGIS are already installed, the easiest way to install dependencies is likely via `conda`.
A `environment.yml` is provided to set up the processing environment. Edit the environment variables in this file
as required (to match your database connection) and then create/activate the environment:

    conda create -f environment.yml
    conda activate bcfpenv

Once you have an environment created and can connect to the database successfully, load the base data and fish observations using scripts in these repositories:

- [Freshwater Atlas](https://github.com/smnorris/fwapg)
- [Known Fish Observations](https://github.com/smnorris/bcfishobs)


## Usage

All data preparation scripts (`01_data`) must be run before running the final stream classification models (`02_model`).
As usage of `bcfishpass` will generally depend on study area and species of interest, improved documentation is under development.

### Data preparation

See the instructions in the various folders in [`01_prep`](01_prep) for how to run these scripts.

### Model

See the instructions in [`02_model`](02_model) for how to run the access and habitat models, creating the output `streams` and `crossings` tables for analysis and mapping.

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
