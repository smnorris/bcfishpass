# Discharge

## BC

To be quality fish habitat, a stream must have sufficent water.
While we have no comprehensive stream discharge model for BC, the [Pacific Climate Impacts Consortium](https://www.pacificclimate.org/) has modelled discharge for the Peace, Fraser and Columbia basins.
Base flow and runoff time series rasters are available in for download NetCDF and other formats here https://www.pacificclimate.org/data/gridded-hydrologic-model-output.

To download PCIC base flow and runoff, combine into discharge, and load to postgres:

    make all

### Data Citation

Pacific Climate Impacts Consortium, University of Victoria, (January 2020). VIC-GL BCCAQ CMIP5: Gridded Hydrologic Model Output.


## WCRP watersheds

For select CWF WCRP watersheds, custom high resolution mean annual discharge data was provided under license by [Foundry Spatial](https://foundryspatial.com/).
If modelling the Bulkley, Horsefly or Elk watershed groups, load the Foundry discharge shapefile:

    ./foundry_discharge.sh