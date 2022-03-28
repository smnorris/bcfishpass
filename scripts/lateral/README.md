# Lateral habitat connectivity model

An basic proof-of-concept model to:

a. identify areas of potential off-channel Pacific Salmon spawning/rearing habitat
b. identify areas of (a) isolated by railway lines
c. report on the results

The focus for this project is on areas isolated by active railway corridors, but the method can be extended to apply to any linear feature.


## Method

1. Create a rough study area polygon - ~1km buffer of active rail lines in watershed groups of known Pacific Salmon populations, within Fraser watershed
2. Identify features defining areas of potential off-channel/lateral habitat:
    + lakes/ponds
    + wetlands
    + reservoirs
    + floodplain / flat areas
    + year-round stream buffers (by stream order / parent stream order / accessibility)
    + intermittent stream buffers (by stream order / parent stream order / accessibility)
    + channel confinement definition
    + manually digitize areas from satellite imagery
3. Rasterize above features at ~10m (optionally, rasterize by probability of high habitat value or relative habitat value)
4. Merge sources into single 'potential habitat' raster
5. Remove built-up areas from potential habitat raster
6. Rasterize roads/rail lines, with gaps in feature at known/modelled OBS
7. Find 'islands' of riparian features created by roads/rail lines


## Potential data sources

- FWA waterbodies (river polygons, lakes, wetlands, reservoirs)
- FWA streams
- bcfishpass accessibility / habitat modelling
- railways
- roads
- DEM (LIDAR should be available for much of the study area)
- Land Use / Land Cover to potentially rule out built up areas
- floodplain mapping https://catalogue.data.gov.bc.ca/dataset/mapped-floodplains-in-bc-historical


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


## Notes

https://www.canlii.org/en/bc/laws/regu/bc-reg-178-2019/latest/bc-reg-178-2019.html

```
"active floodplain", in relation to a stream, means land that is

(a)adjacent to the stream,

(b)inundated by the 1 in 5 year return period flow of the stream, and


Riparian assessment area
8   (1)Subject to subsection (2), the riparian assessment area for a stream consists
of a 30 m strip on each side of the stream, measured from the stream boundary.

(2)If a stream is in a ravine, the riparian assessment area for the stream consists
of the following areas, as applicable:

(a)if the ravine is less than 60 m wide, a strip on each side of the stream that
is measured from the stream boundary to a point that is 30 m beyond the top of the
ravine bank;

(b)if the ravine is 60 or more metres wide, a strip on each side of the stream that
is measured from the stream boundary to a point that is 10 m beyond the top of the
ravine bank.

(c)capable of supporting plant species that are typical of inundated or saturated
soil conditions and distinct from plant species on freely drained upland sites adjacent
to the land;
```