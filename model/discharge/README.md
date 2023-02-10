# Discharge

To be quality fish habitat, a stream must have sufficent water, typically defined as mean annual discharge.

## PCIC discharge

While we have no comprehensive stream discharge model for BC, the [Pacific Climate Impacts Consortium](https://www.pacificclimate.org/) has modelled discharge for the Peace, Fraser and Columbia basins.
Base flow and runoff time series rasters are available in for download NetCDF and other formats [here](https://www.pacificclimate.org/data/gridded-hydrologic-model-output).

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

## Caveats

1. Discharge in cubic metres per second (`mad_m3s`) is only accurate where we have upstream area values.

*For streams with contributing areas outside of BC, this value will currently be incorrect - upstream areas are within FWA watersheds only.*

2. To speed processing, streams of order >= 8 are not included.


## Processing notes

This job takes some time to run.
On my 8 core/16 thread machine, time to process the upstream discharge for first 10 watershed groups (of 150) does not improve beyond about 5 parallel jobs:

```
10 wsg, 3 jobs      = 7m 3s
10 wsg, 5 jobs      = 6m 23s
10 wsg, 7 jobs      = 7m 9s
10 wsg, 10 jobs     = 7m 18s
10 wsg, in sequence = 10m 39s
```

### Data Citation

Pacific Climate Impacts Consortium, University of Victoria, (January 2020). VIC-GL BCCAQ CMIP5: Gridded Hydrologic Model Output.


## Alternate discharge data

For any custom/alternate discharge dataset, load discharge to table `bcfishpass.discharge` as defined above.

