# Channel width

To run:

    ./channel_width.sh

The script will:

- download FISS Stream Sample Sites
- pull measured channel width from sample sites and PSCIS assessments, average measurements along stream segments (distinct watershed codes)
- load mean annual precipitation (MAP) to db (by fundamental watershed, processed by CWF and taken from [ClimateBC](http://climatebc.ca/))
- for modelling channel width where no measurements are required, calculate MAP upstream of every stream segment


Output tables:

```
Table "bcfishpass.measured_channel_width"
          Column           |       Type       | Collation | Nullable |                                       Default
---------------------------+------------------+-----------+----------+--------------------------------------------------------------------------------------
 measured_channel_width_id | integer          |           | not null | nextval('bcfishpass.measured_channel_width_measured_channel_width_id_seq'::regclass)
 stream_sample_site_ids    | integer[]        |           |          |
 stream_crossing_ids       | integer[]        |           |          |
 wscode_ltree              | ltree            |           |          |
 localcode_ltree           | ltree            |           |          |
 watershed_group_code      | text             |           |          |
 channel_width             | double precision |           |          |
Indexes:
    "measured_channel_width_pkey" PRIMARY KEY, btree (measured_channel_width_id)
    "measured_channel_width_localcode_ltree_idx" gist (localcode_ltree)
    "measured_channel_width_localcode_ltree_idx1" btree (localcode_ltree)
    "measured_channel_width_wscode_ltree_idx" gist (wscode_ltree)
    "measured_channel_width_wscode_ltree_idx1" btree (wscode_ltree)


Table "bcfishpass.mean_annual_precip_streams"

        Column        |  Type   | Collation | Nullable |                              Default
----------------------+---------+-----------+----------+-------------------------------------------------------------------
 id                   | integer |           | not null | nextval('bcfishpass.mean_annual_precip_streams_id_seq'::regclass)
 wscode_ltree         | ltree   |           |          |
 localcode_ltree      | ltree   |           |          |
 watershed_group_code | text    |           |          |
 area                 | bigint  |           |          |
 map                  | integer |           |          |
 map_upstream         | integer |           |          |
Indexes:
    "mean_annual_precip_streams_pkey" PRIMARY KEY, btree (id)
    "mean_annual_precip_streams_localcode_ltree_idx" gist (localcode_ltree)
    "mean_annual_precip_streams_localcode_ltree_idx1" btree (localcode_ltree)
    "mean_annual_precip_streams_wscode_ltree_idx" gist (wscode_ltree)
    "mean_annual_precip_streams_wscode_ltree_idx1" btree (wscode_ltree)

```





Reference:

*Wang, T., Hamann, A., Spittlehouse, D.L., Murdock, T., 2012. ClimateWNA - High-Resolution Spatial Climate Data for Western North America. Journal of Applied Meteorology and Climatology, 51: 16-29.*


