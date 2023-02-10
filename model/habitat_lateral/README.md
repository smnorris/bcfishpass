# Lateral habitat connectivity model

A model of potential off-channel/lateral Pacific Salmon spawning/rearing habitat, and areas of this lateral habitat potentially isolated by railways.


## Method

1. Collect and rasterize (10m) features defining areas of potential off-channel/lateral habitat:
    - areas modelled as 'unconfined valleys' via [VCA](valley_confinement.md)
    - waterbodies from [BC Freshwater Atlas](https://github.com/smnorris/fwapg)
    - streams ([FWA streams](https://github.com/smnorris/fwapg), buffered by stream order / parent stream order / modelled accessibility / modelled spawning-rearing habitat / seasonality)
    - mapped [historical floodplains](https://catalogue.data.gov.bc.ca/dataset/mapped-floodplains-in-bc-historical)
2. Merge sources into a single categorical 'potential lateral habitat' raster, retaining only regions connected to streams modelled as accessible
3. Remove built-up areas from potential lateral habitat (ESA land use)
4. Rasterize rail lines, breaching the railway raster at passable structures (known or modelled)
5. Find regions of potential lateral habitat isolated by rail lines

## Usage

When using the remote DEM:

    make

If using a locally stored DEM, it is possible to speed up the jobs by running in parallel.
Do this by setting environment variable `DEM10M` and telling make to run concurrent jobs:

    export DEM10M=/path/to/my/dem.tif
    make --debug=basic -j 8 data/habitat_lateral.tif &> habitat_lateral.log

## Output

    data/habitat_lateral.tif

#### Values

```
1  potential lateral habitat, connected
2  potential lateral habitat, disconnected by railway
```