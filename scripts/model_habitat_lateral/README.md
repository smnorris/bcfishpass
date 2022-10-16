# Lateral habitat connectivity model

An basic proof-of-concept model to:

1. identify areas of potential off-channel Pacific Salmon spawning/rearing habitat
2. identify areas of (a) isolated by railway lines
3. report on the results

These scripts attempt to quantify lateral habitat isolated by active railway corridors, but the method could be extended to apply to any linear feature.


## Method

1. Create a study area polygon  (currently a ~1km buffer of active rail lines in watershed groups of known Pacific Salmon populations, within Fraser watershed)
2. Collect features defining areas of potential off-channel/lateral habitat:
    - waterbodies from [BC Freshwater Atlas](https://github.com/smnorris/fwapg)
    - streams ([FWA streams](https://github.com/smnorris/fwapg), buffered by stream order / parent stream order / `bcfishpass` accessibility or IP habitat / seasonality)
    - mapped [historical floodplains](https://catalogue.data.gov.bc.ca/dataset/mapped-floodplains-in-bc-historical)
    - additional potential floodplain (slope, or potentially a channel confinement model)
    - wet/riparian areas manually digitized from satellite imagery
3. Rasterize above features at ~10m
4. Merge sources into a single categorical 'riparian' raster
5. Remove built-up areas from riparian raster (BTM, DRA roads, ESA land use, other LU/LC dataset?)
6. Rasterize roads/rail lines, with gaps in feature at known/modelled OBS
7. Find 'islands' of isolated riparian features created by roads/rail lines


## Tools

- postgresql/postgis
- rasterio
- numpy
- scikit-image (see https://github.com/smnorris/becmodel/blob/master/becmodel/main.py for similar techniques)
- https://github.com/bluegeo/bluegeo / https://github.com/bluegeo/hydro-tools for channel confinement model


## Gaps / challenges

- BC DEM resolution may not be enough for good definition of 'flat'?
- is 'flat' and/or DEM analysis of channel area enough? Are there other data sources defining riparian influence?
    + forest cover (broadleaf/mixed/non-treed/open-sparse treed)
    + BEC
    + existing riparian mapping?
    + existing wetland mapping?
- defining connectivity


## Background

From BC's [Riparian Areas Protection Act](https://www.canlii.org/en/bc/laws/regu/bc-reg-178-2019/latest/bc-reg-178-2019.html), definitions of active floodplain and riparian assessment area are useful guides for our ad-hoc buffering of streams:


### Active floodplain
> In relation to a stream, means land that is

>(a) adjacent to the stream,  

>(b) inundated by the 1 in 5 year return period flow of the stream, and

>(c) capable of supporting plant species that are typical of inundated or saturated soil conditions and distinct from plant species on freely drained upland sites adjacent to the land;


### Riparian assessment area
>(1) Subject to subsection (2), the riparian assessment area for a stream consists of a 30 m strip on each side of the stream, measured from the stream boundary.

> (2) If a stream is in a ravine, the riparian assessment area for the stream consists of the following areas, as applicable:

> (a) if the ravine is less than 60 m wide, a strip on each side of the stream that is measured from the stream boundary to a point that is 30 m beyond the top of the ravine bank;

> (b) if the ravine is 60 or more metres wide, a strip on each side of the stream that is measured from the stream boundary to a point that is 10 m beyond the top of the ravine bank.