#!/bin/bash
set -euxo pipefail

# -----------------------------------
#
# raster2fwa.sh
#
# Find raster values at points on distinct FWA stream segments and load results to postgres.
# (distinct segment meaning distinct wscode/localcode combination)
#
# raster2fwa.sh [input raster] [output table] [watershed_group_code]
#
# -----------------------------------

# generate points on all streams of interest
psql -Xt -c "select ST_AsGeoJSON(t.*)
    from (
      select
        wscode_ltree,
        localcode_ltree,
        watershed_group_code,
        st_pointonsurface(ST_Union(geom)) as geom
      from whse_basemapping.fwa_stream_networks_sp
      where watershed_group_code = '$3'
      and localcode_ltree is not null
      group by wscode_ltree, localcode_ltree, watershed_group_code
    ) as t" |
# find raster value at each point
rio -q pointquery -r $1 2>/dev/null | \
# extract just the required properties pointquery geojson output
jq '.features[].properties | [.wscode_ltree, .localcode_ltree, .watershed_group_code, .value]' | \
# convert the json data to csv
jq -r --slurp '.[] | @csv' | \
# load csv to specified postgres table
psql -c "\copy $2 FROM STDIN delimiter ',' csv header"
