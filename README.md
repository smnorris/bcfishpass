# bcfishpass

Scripts to prioritize assessment/remediation of potential barriers to fish passage, based primarily on stream gradient.

## Background

Generate a simple model of aquatic habitat connectivity by identifying natural barriers to fish passage (plus hydro dams that are not feasible to remediate) and classifying all streams not upstream of these barriers as *'potentially accessible'*.

On potentially accessible streams, identify known barriers and additional anthropogenic features (primarily road/railway stream crossings, ie culverts) that are potentially barriers. To prioritize these features for assessment or remediation, we can report on how much modelled potentially accessible aquatic habitat the barriers may obstruct.

The model can be refined with known fish observations. Depending on the modelling scenario, all aquatic habitat downstream of a given fish observation can be classified as *'observed accessbile'*, overriding any downstream barriers.


### 1. Generate potentially accessible aquatic habitat

Using the BC Freshwater Atlas as the base for analysis, these 'definite' barrier features are located on the stream network:

- segments of >100m linear stream that are steeper than the user provided gradient threshold(s) based on swimming ability of species of interest (eg 15, 20, 25, 30)
- major dams
- waterfalls >5m
- points corresponding to other natural stream characteristics that are potential barriers to fish passage (eg subsurface flow, intermittent flow, ditch flow)

All aquatic habitat downstream of these points is classified as potentially accessible to fish.  In the absence of any addtional anthropogenic barriers, anadramous species should be able to access all aquatic habitat below these definite barriers. Note that the definite barriers can be customized - for example, not all intermittent flows are barriers to fish passage.

### 2. Generate observed accessible aquatic habitat

Fish observation points from [bcfishobs](https://github.com/smnorris/bcfishobs) are loaded and stream segments below fish observations are identified. A user can then choose a species (or group of species) of interest and either classify all aquatic habitat downstream of observations of this species as observed accessible, or simply note that downstream definite barriers do not in fact restrict passage to this species.

### 3. Locate/generate anthropogenic barriers (culverts, dams, other)

Anthropogenic barriers to fish passage (with potential for remediation) such as non-hydro dams and PSCIS crossings are referenced to the stream network. Locations of culverts are modelled by intersecting the stream network and roads/railways.  We then prioritize these barriers and potential barriers for assessment or remediation by reporting on how much potentially accessible aquatic habitat each barrier may block.

### 4. Generate an output

Based on the above features, we can define potentially accessible / potentially constrained aquatic habitat for different species and/or different regional scenarios.


## Requirements

- Postgresql/PostGIS (tested with 12.4/3.0.2)
- Python >= 3.7
- [bcdata](https://github.com/smnorris/bcdata) (requires `GDAL`/`geopandas`/`rasterio`)
- a FWA database loaded via [`fwapg`](https://github.com/smnorris/fwapg) >= v0.1.1
- [bcfishobs](https://github.com/smnorris/bcfishobs) (BC fish observations and obstacles, loaded and processed)
- gradient barrier points at 15/20/30 percent (data available from FPTWG on request)


## Installation / Setup

Presuming PostgreSQL/PostGIS and Python/`pip` and `conda` are already installed to your system, setup could look something like this:

    conda create -n bcfp
    conda activate bcfp
    conda config --env --add channels conda-forge
    conda config --env --set channel_priority strict
    conda install gdal
    conda install geopandas
    conda install rasterio
    pip3 install bcdata
    # download fwapg, load BC FWA
    # download bcfishobs, load BC fish observations and obstacles
    # load gradient barriers to database
    git clone https://github.com/smnorris/bcfishpass.git
    cd bcfishpass

### Environment variables

As with `fwapg` and `bcfishobs`, scripts depend on several environment variables that point to the postgres database:

    export PGHOST=localhost
    export PGPORT=5432
    export PGDATABASE=mydb
    export PGUSER=postgres
    # put these together
    export DATABASE_URL='postgresql://'$PGUSER'@'$PGHOST':'$PGPORT'/'$PGDATABASE
    # and a OGR compatible string
    export PGOGR='host=localhost user=postgres dbname=mydb password=mypwd port=5432'


## Prep data

#### Create modelled road-stream crossings

    cd 01_prep/01_modelled_stream_crossings
    ./modelled_stream_crossings.sh

For details, see [modelled stream crossings](01_prep/01_modelled_stream_crossings).

#### Clean PSCIS crossings and reference to stream network

    cd 01_prep/02_pscis
    ./pscis.sh

For details, see [PSCIS](01_prep/02_pscis).

#### Load CWF dams and reference to stream network

    cd 01_prep/03_dams
    ./dams.sh

For details, see [dams](01_prep/03_dams).


## Run model

    cd 02_model
    ./model.sh

For details, see [model](02_model).




