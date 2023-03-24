# bcfishpass

`bcfishpass` is a collection of scripts to create and maintain an aquatic connectivity / fish passage database for British Columbia to:

- track known barriers to fish passage (eg dams, waterfalls)
- work with BC Provincial Stream Crossing Information System (PSCIS) crossings and barriers
- model potential barriers to fish passage (stream gradient, road/rail stream crossings)
- model passability/accessibility of streams based on barriers and species swimming ability
- model streams with potential for spawning and rearing activity (for select species)
- prioritize assessment and remediation of barriers based on modelled accessibility and habitat potential

Also provided are tools for mapping features in the database:

- [basic web viewer](https://www.hillcrestgeo.ca/projects/bcfishpass/)
- comprehensive QGIS layer file


## General Methodology

`bcfishpass` is an update and extension of the BC Fish Passage Technical Working Group (FPTWG) Fish Passage modelling - the basic logic for evaluating connectivity is much the same as in previous versions.

Using the [BC Freshwater Atlas](https://github.com/smnorris/fwapg) as the mapping base:

1. Collect known 'natural' barriers to fish passage (waterfalls, subsurface flow, etc) and reference to the stream network
2. Model stream gradient barriers (where a stream slope is steeper than a given percentage for >=100m)
3. Using [Known Fish Observations referenced to streams](https://github.com/smnorris/bcfishobs), remove natural barriers from 1 and 2 that are downstream of known observation(s)
4. Using gradient barriers above the threshold of the target species swimming ability, combine all resulting natural barriers and retain only those with no barriers downstream. All stream downstream of these barriers is termed 'potentially accessible' to the target species (ie, ignoring other barriers such as insufficent flow, temperature, etc a migratory fish of the given swimming ability could potentially access all these streams if no anthropogenic barrers are present)
5. Collect anthropogenic barriers, both known (dams, PSCIS barriers) and potential (mapped road/railway FWA stream intersections, ie culverts) 
6. Prioritize anthropogenic barriers for assessment or remediation by reporting on how much potentially accessible stream is upstream of each barrier (and downstream of other anthropogenic barriers)

To improve prioritization of barriers for assessment and remediation, `bcfishpass` also includes basic 'intrinsic potential' habitat modelling for select species of interest (Bull Trout, Chinook, Chum, Coho, Pink, Sockeye, Steelhead, Westslope Cuthroat Trout). Intrinsic habitat potential (spawning and rearing) is based on:

1. Stream gradient
2. Stream discharge or stream channel width (as per data availability and user preference)
3. Various species-specific connectivitiy criteria (eg. sockeye spawn must be connected to rearing lakes)

Streams meeting the criteria for a given species are classified as spawning or rearing habitat, and the amount of potential spawning/rearing habitat disconnected by barriers is summarized.


## General requirements

- bash
- GDAL (tested with v3.6.2)
- a PostgreSQL / PostGIS database (tested with v14/v3.3.2)
- Python (tested with v3.11.0)
- [bcdata](https://github.com/smnorris/bcdata) (v0.7.6)
- [fwapg](https://github.com/smnorris/fwapg) (v0.3.1)
- [bcfishobs](https://github.com/smnorris/bcfishobs) (v0.1.0)


## Installation / Setup

`bcfishpass` is a collection of shell/sql/Python scripts - no installation is required. To download and use the latest:

    git clone https://github.com/smnorris/bcfishpass.git
    cd bcfishpass

Presuming PostgreSQL/PostGIS are already installed, the easiest way to install dependencies is likely via `conda`.
An `environment.yml` file is provided to install the required tools:

    conda env create -f environment.yml
    conda activate bcfishpass

Note that `cdo` is required for processing NetCDF discharge files, but this tool is not included in the conda environment.
Install `cdo` separately (either [from source](https://code.mpimet.mpg.de/projects/cdo/wiki/Cdo#Download-Compile-Install) or via [homebrew](https://formulae.brew.sh/formula/cdo)).

If the database you are working with does not already exist, create it:

    createdb bcfishpass

All scripts presume that the `DATABASE_URL` environment variable points to your database. For example:

    export DATABASE_URL=postgresql://postgres@localhost:5432/bcfishpass

Once the database is created, load requirements `fwapg` and `bcfishobs` as per instructions in the respective projects.

## Usage

Once you have `fwapg` and `bcfishobs` loaded to your database, `bcfishpass` processing is controlled by the `Makefile`.

To run:

    make

It is possible to build individual components of the model separately (if their dependencies are met, see the `Makefile`).
Refer to the various README files in the folders within the `model` folder for more info.


## Credits

These tools are made possible by the work and funding of the following groups:

- [BC Fish Passage Technical Working Group (FPTWG)](https://www2.gov.bc.ca/gov/content/environment/plants-animals-ecosystems/fish/aquatic-habitat-management/fish-passage)
- [Canadian Wildlife Federation (CWF)](https://cwf-fcf.org/en/explore/fish-passage/breaking-down-barriers.html)
- [Pacific Salmon Foundation (PSF)](https://psf.ca/)
- [New Graph Environment](https://www.newgraphenvironment.com/)
- [Hillcrest Geographics](https://www.hillcrestgeo.ca)

With additional funding from:

- [BC Fish and Wildlife Compensation Program (FWCP)](https://fwcp.ca/)
- [Society for Ecosystem Restoration in Northern British Columbia (SERNBC)](https://sernbc.ca/)
- [BC Salmon Restoration and Innovation Fund (BCSRIF)](https://www.dfo-mpo.gc.ca/fisheries-peches/initiatives/fish-fund-bc-fonds-peche-cb/index-eng.html)
- [Canada Nature Fund for Aquatic Species at Risk (CNFASAR)](https://www.dfo-mpo.gc.ca/species-especes/sara-lep/cnfasar-fnceap/index-eng.html)