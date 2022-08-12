# Valley confinement

An adaptation of the USDA's [Valley Confinement Algorithm (VCA)](https://www.fs.fed.us/rm/boise/AWAE/projects/valley_confinement.shtml) using BC's Freshwater Atlas and DEM. Output is used as an input to the fish habitat model.

## Resources

- the [Lanscape Scale Valley Confinement Algorithm](https://www.fs.fed.us/rm/pubs/rmrs_gtr321.pdf) publication
- USDA [script and toolbox ](https://www.fs.fed.us/rm/boise/AWAE/projects/valley_confinement/downloads/VCA_Toolbox.zip) (ESRI/ArcPy)
- blueGeo open source [VCA implementation](https://github.com/bluegeo/bluegeo) (grass/gdal/scipy/skimage)
- ESI (now TerrainWorks) [Programs for DEM Analysis](http://www.fsl.orst.edu/clams/download/pubs/miller_DEM_Programs_2003.pdf) (Miller 2003)
- visualization of [processing in Netmap](http://www.netmaptools.org/Pages/NetMapHelp/mapping_floodplains_valley_floors.htm?mw=NDg4&st=MQ==&sct=MTgwMC41&ms=AAAAAAA=)
- and more: https://terrainworks.com/intrinsic-potential-ip-fish-habitat-modeling-read

The code in this repository is primarily taken directly from the blueGeo adaptation of the USDA VCA and adapted/simplified for use with data widely available in BC.

## Usage



## valley-floor width 

From Miller 2003

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
> 



