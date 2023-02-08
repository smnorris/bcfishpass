# Mean annual precipitation 

ClimateBC mean annual precipitation (MAP) referenced to FWA watersheds and streams

## Method

1. Manually download ClimateBC .tif file from [Climate BC](https://climatebc.ca/SpatialData), choose `Historical normals`, `Annual`, `Normal_1991-2020` and download `MAP` to `data` folder
2. Overlay ClimateBC raster with fundamental watersheds, deriving MAP for each fundamental watershed
3. Calculate average (area-weighted) upstream MAP for each distinct watershed code / local code combination 

The output table can be joined to streams or points on the FWA watershed network.

## Usage

To download, process and generate mean annual precipitation for each stream segment:

    ./mean_annual_precip.sh

## Output

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

## References

- Wang, T., Hamann, A., Spittlehouse, D.L., Murdock, T., 2012. *ClimateWNA - High-Resolution Spatial Climate Data for Western North America*. Journal of Applied Meteorology and Climatology, 51: 16-29.*
