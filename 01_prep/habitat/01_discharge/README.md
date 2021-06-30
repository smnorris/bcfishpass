# Discharge

To be quality fish habitat, a stream must have sufficent water, typically defined as mean annual discharge.

## PCIC discharge

While we have no comprehensive stream discharge model for BC, the [Pacific Climate Impacts Consortium](https://www.pacificclimate.org/) has modelled discharge for the Peace, Fraser and Columbia basins.
Base flow and runoff time series rasters are available in for download NetCDF and other formats [here]https://www.pacificclimate.org/data/gridded-hydrologic-model-output.

To download PCIC base flow and runoff, combine into discharge, and load to postgres:

    make all

## Output table


                           Table "bcfishpass.discharge"
            Column        |       Type       | Collation | Nullable | Default
    ----------------------+------------------+-----------+----------+---------
     linear_feature_id    | integer          |           |          |
     watershed_group_code | text             |           |          |
     mad_mm               | double precision |           |          |
     mad_m3s              | double precision |           |          |



### Data Citation

Pacific Climate Impacts Consortium, University of Victoria, (January 2020). VIC-GL BCCAQ CMIP5: Gridded Hydrologic Model Output.


## Alternate discharge data

For any custom/alternate discharge dataset, load discharge to table `bcfishpass.discharge` as defined above.

For CWF WCRP watersheds, custom high resolution mean annual discharge data was provided under license by [Foundry Spatial](https://foundryspatial.com/). Load scripts are available [here](https://github.com/smnorris/cwf_wcrp_discharge).

