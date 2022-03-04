# Channel width

Modelled channel width can be used as an input to model spawning/rearing habitat (combined with stream gradient - and potentially with valley confinement).

Most channel width predictors are available in the FWA, but we also need Mean Annual Precip, run scripts in ../precipitation first.


## Channel width

Channel width is derived via three methods:

- mapped: we can derive the width of FWA river polygons (measuring the width between banks at 10% intervals and averaging the result)
- measured: field measurements of channel width are available from FISS and PSCIS (averaging measurements where more than one is available for the same stream)
- modelled: calculate the modelled channel width based on upstream area and mean annual precipitation

To run these calculations and load the data:

    ./channel_width.sh


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

Table "bcfishpass.channel_width_mapped"
        Column        |       Type       | Collation | Nullable | Default
----------------------+------------------+-----------+----------+---------
 linear_feature_id    | bigint           |           | not null |
 watershed_group_code | text             |           |          |
 channel_width_mapped | double precision |           |          |
Indexes:
    "channel_width_mapped_pkey" PRIMARY KEY, btree (linear_feature_id)


Table "bcfishpass.channel_width_measured"
         Column         |       Type       | Collation | Nullable |                                   Default
------------------------+------------------+-----------+----------+-----------------------------------------------------------------------------
 channel_width_id       | integer          |           | not null | nextval('bcfishpass.channel_width_measured_channel_width_id_seq'::regclass)
 stream_sample_site_ids | integer[]        |           |          |
 stream_crossing_ids    | integer[]        |           |          |
 wscode_ltree           | ltree            |           |          |
 localcode_ltree        | ltree            |           |          |
 watershed_group_code   | text             |           |          |
 channel_width_measured | double precision |           |          |

Indexes:
    "channel_width_measured_pkey" PRIMARY KEY, btree (channel_width_id)
    "channel_width_measured_wscode_ltree_localcode_ltree_key" UNIQUE CONSTRAINT, btree (wscode_ltree, localcode_ltree)
    "channel_width_measured_localcode_ltree_idx" gist (localcode_ltree)
    "channel_width_measured_localcode_ltree_idx1" btree (localcode_ltree)
    "channel_width_measured_wscode_ltree_idx" gist (wscode_ltree)
    "channel_width_measured_wscode_ltree_idx1" btree (wscode_ltree)


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


## References

- Wang, T., Hamann, A., Spittlehouse, D.L., Murdock, T., 2012. *ClimateWNA - High-Resolution Spatial Climate Data for Western North America*. Journal of Applied Meteorology and Climatology, 51: 16-29.*

- Thorley and Irvine 2021 [*Channel Width 2021*](https://github.com/NewGraphEnvironment/fish_passage_bulkley_2020_reporting/blob/master/docs/channel-width-21.pdf)