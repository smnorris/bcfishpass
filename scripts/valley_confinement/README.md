# Floodplains

Define unconfined valleys (ie, floodplains) as inputs to:

- lateral habitat modelling
- fish habitat modelling intrinsic potential parameter 'valley-width ratio'

The valley definition script is a adaptation of the USDA's [Valley Confinement Algorithm (VCA)](https://www.fs.fed.us/rm/boise/AWAE/projects/valley_confinement.shtml) using BC's Freshwater Atlas and DEM. The bulk of the code is taken directly from an [existing adaptation of the VCA by Devin Cairns](https://github.com/bluegeo/bluegeo).


## Usage

For a given watershed group, generate an 'unconfined valley' polygon layer and a valley-width ratio for each stream segment:

    python valley_confinement.py <watershed_group_code>


## Method

Valleys defined by this script are derived primarily as described by [Nagel et al, 2014](https://www.fs.fed.us/rm/pubs/rmrs_gtr321.pdf), using the following inputs and parameters. To generate relatively precise width distances, all processing is done with 10m resolution rasters (the BC DEM is upsampled and linearly interpolated from the source 25m resolution).


### 1. Ground slope
Ground slope is generated from the upsampled BC DEM. Only cell values less than the user-defined slope criteria will be included in the output unconfined valley bottom layer (default 9%)

### 2. Slope cost distance 
The cost at each cell is computed as the cell size multiplied by the cell slope (percent). As distance from the stream channel increases, the accumulated product of slope and distance are computed. In wide unconfined valleys with relatively low ground slope values, the slope cost distance measure increases gradually, whereas in confined valleys with steep side slopes the value increases rapidly. Only cells with a value less than the `cost_threshold` parameter are included in the output valley definitions (default 2500).

### 3. Flood factor
Using the DEM, valleys are “flooded” to a specific height above the elevation of the channel. The height of the flood is equal to the predicted bankfull depth multiplied by a flood factor (default 9). Bankfull depth is predicted as `bankfull_width**0.607 * 0.145` (Hall, 2007). Bankfull width is as defined by the `channel_width` model, or alternatively as `(contributing area**0.280) * 0.196 * mean annual precipitation` (as used in the source VCA). Stream segments are defined by the Freshwater Atlas.

### 4. Maximum valley width
This parameter confines the valley extent to a maximum distance from the stream segment. Note that the width parameter includes the entire valley width on both sides of the stream (default 2000m).

### 5. Contributing area / parent stream order
Only streams meeting at least one of these conditions are processed:

- sufficent upstream contributing area (>=1000 ha) 
- drain directly into streams of order >=4

### 6. Access model status
Only streams with no known non-anthropogenic barriers (ie falls, gradient barriers) downstream are processed.

### 7. Valley area
Only contiguous areas above this size threshold are retained (default 0.5ha).


## Resources / References

- the [Lanscape Scale Valley Confinement Algorithm](https://www.fs.fed.us/rm/pubs/rmrs_gtr321.pdf) publication
- USDA [script and toolbox ](https://www.fs.fed.us/rm/boise/AWAE/projects/valley_confinement/downloads/VCA_Toolbox.zip) (ESRI/ArcPy)
- blueGeo open source [VCA implementation](https://github.com/bluegeo/bluegeo) (grass/gdal/scipy/skimage)
- ESI (now TerrainWorks) [Programs for DEM Analysis](http://www.fsl.orst.edu/clams/download/pubs/miller_DEM_Programs_2003.pdf) (Miller 2003)
- visualization of [processing in Netmap](http://www.netmaptools.org/Pages/NetMapHelp/mapping_floodplains_valley_floors.htm?mw=NDg4&st=MQ==&sct=MTgwMC41&ms=AAAAAAA=)
- Terrainworks [updates](https://terrainworks.com/intrinsic-potential-ip-fish-habitat-modeling-read)


From Miller 2003:

> Width of the valley floor is estimated as the length of a transect that intersects 
> the valley walls at a specified height above the channel. Since the orientation 
> of the valley is unknown, transect orientation is varied to find that which 
> provides the minimum length. The height above the channel is specified as a 
> number of estimated bank-full depths. The number of bank-full depths is 
> determined by the parameter vh, specified in the parameters.dat file. The 
> appropriate value is probably dependent on the quality of the DEMs and may vary 
> regionally. Preliminary analyses using data from the Oregon Coast Range indicate 
> that a value for vh of 2.5 works well, although larger values (up to 20) have 
> been found to work better elsewhere.
> 
> Bank-full depth is estimated as a function of drainage area as
> Hbf = depth_coefficient_1*Adepth_coefficient_2
> 
> where Hbf is bank-full depth and A is drainage area in square kilometers. 
> The two coefficients are specified in parameters.dat. Elevations are linearly 
> interpolated between DEM points. The accuracy of these estimated widths is 
> directly dependent on the resolution and accuracy of the DEM.
> 
> An estimated valley-floor width is obtained for every channel pixel, one for 
> each side of the channel. Since there are occasionally some pixels where this 
> strategy fails – the transect may be incorrectly oriented at tributary junctions, 
> for example – I then check for outliers in the estimated width over a centered 
> window that spans 10 pixels. Any values exceeding 2.5 times the median are 
> considered in error and are replaced by a linear fit through the remaining 
> points. The resulting widths are then averaged over the length of the reach.

