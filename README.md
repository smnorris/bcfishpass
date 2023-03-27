# bcfishpass

`bcfishpass` is a collection of scripts to create and maintain an aquatic connectivity / fish passage database for British Columbia to:

- track known barriers to fish passage (eg dams, waterfalls)
- work with assessed BC Provincial Stream Crossing Information System (PSCIS) crossings
- model potential barriers to fish passage (stream gradient, road/rail stream crossings)
- model passability/accessibility of streams based on species swimming ability
- model streams with potential for spawning and rearing activity (for select species)
- report on habitat/connectivity based indicators to support prioritization of assessment and remediation

Also provided are tools for mapping features in the database:

- [basic web viewer](https://www.hillcrestgeo.ca/projects/bcfishpass/)
- comprehensive QGIS layer file


## General requirements

- bash
- GDAL (tested with v3.6.2)
- a PostgreSQL / PostGIS database (tested with v14/v3.3.2)
- Python (tested with v3.11.0)
- [bcdata](https://github.com/smnorris/bcdata) (v0.7.6)
- [fwapg](https://github.com/smnorris/fwapg) (v0.4.0)
- [bcfishobs](https://github.com/smnorris/bcfishobs) (v0.1.1)


## Setup

`bcfishpass` is a collection of shell/sql/Python scripts. To download and use the latest:

    git clone https://github.com/smnorris/bcfishpass.git
    cd bcfishpass

Presuming PostgreSQL/PostGIS are already installed, the easiest way to install dependencies is likely via `conda`.
An `environment.yml` file is provided to install the required tools:

    conda env create -f environment.yml
    conda activate bcfishpass

Note that `cdo` is required for processing NetCDF discharge files, but this tool is not currently included in the conda environment.
If processing discharge based habitat models, install `cdo` separately:

- `conda install cdo` (if your system supports this, this may not work on ARM based Macs) 
- `brew install cdo` 
- install from [from source](https://code.mpimet.mpg.de/projects/cdo/wiki/Cdo#Download-Compile-Install)

If the database you are working with does not already exist, create it:

    createdb bcfishpass

All scripts presume that the `DATABASE_URL` environment variable points to your database. For example:

    export DATABASE_URL=postgresql://postgres@localhost:5432/bcfishpass

Once the database is created, load requirements `fwapg` and `bcfishobs` as per instructions in the respective projects.


## Usage

Once you have `fwapg` and `bcfishobs` loaded to your database, `bcfishpass` processing is controlled by the `Makefile`.

To run all models (access, linear habitat, lateral habitat):

    make

Note that it is possible (and often preferred) to build components of the modelling separately. 
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
- BC Ministry of Transportation and Infrastructure