# Channel width

Modelled channel width can be used as an input to model spawning/rearin habitat (combined with stream gradient and potentially with valley confinement).

Most channel width predictors are available in the FWA, but we also need Mean Annual Precip

## Mean annual precipitation

Mean annual precipitation (MAP) is taken from ClimateBC, using the [1981-2010 climate normal grid](http://raster.climatebc.ca/download/Normal_1981_2010MSY/Normal_1981_2010_annual.zip).  MAP is derived for each fundamental watershed, and an area-weighted average upstream MAP is calculated for each stream segment.

To generate mean annual precipitation:

    ./mean_annual_precip.sh

## Channel width model

To create a best-fit model for predicting channel width, we:
- extract measured channel width values from PSCIS and FISS
- find the values of the various channel width predictors at these locations
- provide this data to R scripts for finding the best fit

To run this and create the output table for input to R `bcfishpass.channel_width_measured`:

    ./channel_width_measured.sh

Once the channel width model parameters have been determined in R, encoded the parameters directly in [`sql/channel_width_modelled.sql`](`sql/channel_width_modelled.sql) - currently a different model is derived for each watershed group. Once models for all groups are added, model channel width on all streams by calling the script:

    psql -f sql/channel_width_modelled.sql


## Output tables

```
Table "bcfishpass.mean_annual_precip"
        Column        |  Type   | Collation | Nullable |                          Default
----------------------+---------+-----------+----------+-----------------------------------------------------------
 id                   | integer |           | not null | nextval('bcfishpass.mean_annual_precip_id_seq'::regclass)
 wscode_ltree         | ltree   |           |          |
 localcode_ltree      | ltree   |           |          |
 watershed_group_code | text    |           |          |
 area                 | bigint  |           |          |
 map                  | integer |           |          |
 map_upstream         | integer |           |          |
Indexes:
    "mean_annual_precip_pkey" PRIMARY KEY, btree (id)
    "mean_annual_precip_wscode_ltree_localcode_ltree_key" UNIQUE CONSTRAINT, btree (wscode_ltree, localcode_ltree)
    "mean_annual_precip_localcode_ltree_idx" gist (localcode_ltree)
    "mean_annual_precip_localcode_ltree_idx1" btree (localcode_ltree)
    "mean_annual_precip_wscode_ltree_idx" gist (wscode_ltree)
    "mean_annual_precip_wscode_ltree_idx1" btree (wscode_ltree)
```
```
Table "bcfishpass.channel_width_measured"
         Column         |       Type       | Collation | Nullable |                                   Default
------------------------+------------------+-----------+----------+-----------------------------------------------------------------------------
 channel_width_id       | integer          |           | not null | nextval('bcfishpass.channel_width_measured_channel_width_id_seq'::regclass)
 stream_sample_site_ids | integer[]        |           |          |
 stream_crossing_ids    | integer[]        |           |          |
 wscode_ltree           | ltree            |           |          |
 localcode_ltree        | ltree            |           |          |
 watershed_group_code   | text             |           |          |
 stream_order           | integer          |           |          |
 stream_magnitude       | integer          |           |          |
 upstream_area_ha       | double precision |           |          |
 upstream_lake_ha       | double precision |           |          |
 upstream_reservoir_ha  | double precision |           |          |
 upstream_wetland_ha    | double precision |           |          |
 channel_width_measured | double precision |           |          |
 map                    | integer          |           |          |
Indexes:
    "channel_width_measured_pkey" PRIMARY KEY, btree (channel_width_id)
    "channel_width_measured_wscode_ltree_localcode_ltree_key" UNIQUE CONSTRAINT, btree (wscode_ltree, localcode_ltree)
    "channel_width_measured_localcode_ltree_idx" gist (localcode_ltree)
    "channel_width_measured_localcode_ltree_idx1" btree (localcode_ltree)
    "channel_width_measured_wscode_ltree_idx" gist (wscode_ltree)
    "channel_width_measured_wscode_ltree_idx1" btree (wscode_ltree)
```

```
Table "bcfishpass.channel_width_modelled"
         Column         |       Type       | Collation | Nullable |                                   Default
------------------------+------------------+-----------+----------+-----------------------------------------------------------------------------
 channel_width_id       | integer          |           | not null | nextval('bcfishpass.channel_width_modelled_channel_width_id_seq'::regclass)
 wscode_ltree           | ltree            |           |          |
 localcode_ltree        | ltree            |           |          |
 watershed_group_code   | text             |           |          |
 channel_width_modelled | double precision |           |          |
Indexes:
    "channel_width_modelled_pkey" PRIMARY KEY, btree (channel_width_id)
    "channel_width_modelled_wscode_ltree_localcode_ltree_key" UNIQUE CONSTRAINT, btree (wscode_ltree, localcode_ltree)
    "channel_width_modelled_localcode_ltree_idx" gist (localcode_ltree)
    "channel_width_modelled_localcode_ltree_idx1" btree (localcode_ltree)
    "channel_width_modelled_wscode_ltree_idx" gist (wscode_ltree)
    "channel_width_modelled_wscode_ltree_idx1" btree (wscode_ltree)
    ```



Reference:

*Wang, T., Hamann, A., Spittlehouse, D.L., Murdock, T., 2012. ClimateWNA - High-Resolution Spatial Climate Data for Western North America. Journal of Applied Meteorology and Climatology, 51: 16-29.*


