## Model lateral habitat (DRAFT)

A raster based model is used to roughly approximate floodplains and off-channel habitat, quantify the level of potential fragmentation by road-stream crossings, and identify areas for potential field assessment.

Note that the current model was developed for the [Rail effects on Salmon report](https://cwf-fcf.org/en/resources/research-papers/BC_report_formatted_final.pdf) and currently only considers watersheds within that study area (having Pacific Salmon / Steelhead and railway lines), and only models habitat fragmentation caused by rail crossings. See this report for more details.

Three general sources of potential floodplain/off-channel habitat data are combined:

#### 1. Unconfined valleys 

The valley confinement algorithm (VCA) extracts unconfined valleys from an analysis of the digital elevation model and stream channels within a given area. The `bcfishpass` implementation is taken directly from [scripts by Devin Cairns/BlueGeo](https://github.com/bluegeo/bluegeo), an adaptation of the VCA method [published by the USDA](https://www.fs.usda.gov/rm/boise/AWAE/projects/valley_confinement.shtml). See the [valley confinement README](https://github.com/smnorris/bcfishpass/blob/main/model/03_habitat_lateral/valley_confinement.md) for more info.

#### 2. FWA waterbodies and streams

Streams are selected and buffered using this criteria:


60m: side channels (first order tributaries to rivers of order >=5, with gradient <= 0.01 and modelled as potentially accessible to Pacific salmon and Steelhead)

30m: stream modelled as spawning/rearing for Pacific salmon and Steelhead

20m (plus modelled channel width): stream modelled as potentially accessible for Pacific salmon and Steelhead

These stream buffers are combined with lakes, wetlands, rivers, reservoirs and merged into a single layer

#### 3. Mapped historical floodplains

Historical floodplains are downloaded from the [BC Data Catalogue](https://catalogue.data.gov.bc.ca/dataset/mapped-floodplains-in-bc-historical). 

### Processing

1. The three sources noted above are combined into an initial floodplain raster layer

2. The floodplain raster is refined to exclude regions with no connectivity to stream segments modelled as spawning/rearing habitat (i.e., a region of floodplain must touch or be connected to spawning or rearing habitat to be included)

3. Areas mapped as urban in the 10m resolution [European Space Agency Land Cover](https://esa-worldcover.org/en) are excluded (unlikely to provide suitable habitat regardless of connectivity)

4. All of the Fraser Valley downstream of Agassiz is excluded (drainage and land use in this area is too modified for these methods to produce reasonable results)

The resulting area is described as "lateral habitat". Fragmentation of lateral habitat by rail crossings is then modelled with these steps:

1. Rasterize rail lines corridors (25m buffer of railway vectors)

2. Breach resulting railway corridor raster at locations of known open bottom structures (note that the rail corridor raster is not breached at locations of closed bottom structures known/assessed as be passable as these structures may hold back sediments, have major effects on floodplain functionality, or be impassible under high-flow conditions when floodplain access typically occurs)

3. Using the `morphology.label` tool in the [scikit image processing library](https://scikit-image.org/docs/stable/api/skimage.morphology.html#skimage.morphology.labelLateral), identify lateral habitat connected to rivers/streams and habitat that has been disconnected by the railway corridor raster
