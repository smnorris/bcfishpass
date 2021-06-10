#!/bin/bash
set -euxo pipefail

TMP=~/tmp

wget --trust-server-names -qNP "$TMP" http://raster.climatebc.ca/download/Normal_1981_2010MSY/Normal_1981_2010_annual.zip
unzip $TMP/Normal_1981_2010_annual.zip -d $TMP/climatebc

# resample the precip data to match DEM raster resolution (don't bother aligning for now)
gdalwarp $TMP/climatebc/map mean_annual_precip.tif -t_srs EPSG:3005 -of COG -co COMPRESS=DEFLATE -tr 25 25

# create load table
psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_wsd_load"
psql -c "CREATE TABLE bcfishpass.mean_annual_precip_wsd_load (watershed_feature_id integer, watershed_group_code text, map numeric)"

# Derive MAP per fundamental watershed from raster and load to temp load table in postgres
# Loop through watershed groups
# (rather than loading geojson of fundamental all watershed polys for BC into memory,
# this takes longer but is much more memory safe)
for WSG in $(psql -A -t -P border=0,footer=no \
  -c "SELECT watershed_group_code
      FROM whse_basemapping.fwa_watershed_groups_poly
      ORDER BY watershed_group_code")
do
  echo 'Processing '$WSG
  psql -X -t -v wsg="$WSG" <<< "SELECT
    ST_AsGeoJSON(t.*)
  FROM
    (
      SELECT
        watershed_feature_id,
        watershed_group_code,
        geom
      FROM whse_basemapping.fwa_watersheds_poly
      WHERE watershed_group_code = :'wsg'
    ) as t" | \
    parallel \
      --pipe \
      "rio -q zonalstats \
        -r mean_annual_precip.tif \
        --prefix 'map_' \
        2>/dev/null" | \
    jq '.features[].properties | [.watershed_feature_id, .watershed_group_code, .map_mean]' | \
    jq -r --slurp '.[] | @csv' | \
    psql -c "\copy bcfishpass.mean_annual_precip_wsd_load FROM STDIN delimiter ',' csv header"
done

# load unique watersheds from load table (rasterstats is generating some duplicates and I'm not sure how to fix,
# it is probably something to do with sequences vs collections)
psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_wsd"
psql -c "CREATE TABLE bcfishpass.mean_annual_precip_wsd (watershed_feature_id integer PRIMARY KEY, watershed_group_code text, map numeric)"
psql -c "INSERT INTO bcfishpass.mean_annual_precip_wsd SELECT DISTINCT * FROM bcfishpass.mean_annual_precip_wsd_load"

# drop the load table
psql -c "DROP TABLE bcfishpass.mean_annual_precip_wsd_load"

# Some watersheds are missed due to size, run them based on their centroids/pointonsurface

# recreate load table
psql -c "CREATE TABLE bcfishpass.mean_annual_precip_wsd_load (watershed_feature_id integer, watershed_group_code text, map numeric)"

# run pointquery. At 73,409 points, this is fine to run provincially and in a single process.
psql -t -c "SELECT ST_AsGeoJSON(t.*)
    FROM (
      SELECT
        a.watershed_feature_id,
        b.watershed_group_code,
        ST_PointOnSurface(b.geom) as geom
      FROM bcfishpass.mean_annual_precip_wsd a
      INNER JOIN whse_basemapping.fwa_watersheds_poly b
      ON a.watershed_feature_id = b.watershed_feature_id
      WHERE a.map IS NULL
    ) AS t" |
  rio -q pointquery -r mean_annual_precip.tif 2>/dev/null | \
  jq '.features[].properties | [.watershed_feature_id, .watershed_group_code, .value]' | \
  jq -r --slurp '.[] | @csv' | \
  psql -c "\copy bcfishpass.mean_annual_precip_wsd_load FROM STDIN delimiter ',' csv header"

psql -c "UPDATE bcfishpass.mean_annual_precip_wsd a
         SET map = l.map
         FROM bcfishpass.mean_annual_precip_wsd_load l
         WHERE a.watershed_feature_id = l.watershed_feature_id"

# drop load table again
psql -c "DROP TABLE bcfishpass.mean_annual_precip_wsd_load"

# Note that there are remaining nulls - presumably these wsds simply are not covered by the MAP grid (on border)

# Because there are streams (distinct watershed code / local code combinations) with no watershed polygon
# (mostly in rivers) and we need MAP values for these too, generate them directly with the MAP raster
# rather than joining to the watersheds. There are about 59k of these.
psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_load"
psql -c "CREATE TABLE bcfishpass.mean_annual_precip_load (wscode_ltree ltree, localcode_ltree ltree, watershed_group_code text, map numeric)"
psql -t -c "SELECT ST_AsGeoJSON(t.*)
    FROM (
    SELECT
      s.wscode_ltree,
      s.localcode_ltree,
      s.watershed_group_code,
      ST_PointOnSurface(ST_Union(s.geom)) as geom
    FROM whse_basemapping.fwa_stream_networks_sp s
    LEFT OUTER JOIN whse_basemapping.fwa_watersheds_poly w
    ON s.wscode_ltree = w.wscode_ltree AND
      s.localcode_ltree = w.localcode_ltree AND
      s.watershed_group_code = w.watershed_group_code
    WHERE
      w.wscode_ltree IS NULL AND
      s.fwa_watershed_code NOT LIKE '999%'
    GROUP BY s.wscode_ltree, s.localcode_ltree, s.watershed_group_code
    ) as t" |
  rio -q pointquery -r mean_annual_precip.tif 2>/dev/null | \
  jq '.features[].properties | [.wscode_ltree, .localcode_ltree, .watershed_group_code, .value]' | \
  jq -r --slurp '.[] | @csv' | \
  psql -c "\copy bcfishpass.mean_annual_precip_load FROM STDIN delimiter ',' csv header"


# Create the output table.
# There can be some remenant duplicates in the source data, make sure it does not get included
# by adding a unique constraint on watershed codes
psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip"
psql -c "CREATE TABLE bcfishpass.mean_annual_precip
(
  id serial primary key,
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code text,
  area bigint,
  map integer,
  map_upstream integer,
  UNIQUE (wscode_ltree, localcode_ltree)
);"

# Take data from the MAP load table, average the MAP over the stream segment
# (watershed code / local code) and insert (along with area of fundamental watershed(s) associated with
# this stream segment into the MAP table. Run the inserts per watershed group.
for WSG in $(psql -A -t -P border=0,footer=no \
  -c "SELECT watershed_group_code
      FROM whse_basemapping.fwa_watershed_groups_poly
      ORDER BY watershed_group_code")
do
  psql -f sql/map.sql -v wsg="$WSG"
done

# index the table for upstream/downstream joins
psql -c "CREATE INDEX ON bcfishpass.mean_annual_precip USING GIST (wscode_ltree);"
psql -c "CREATE INDEX ON bcfishpass.mean_annual_precip USING BTREE (wscode_ltree);"
psql -c "CREATE INDEX ON bcfishpass.mean_annual_precip USING GIST (localcode_ltree);"
psql -c "CREATE INDEX ON bcfishpass.mean_annual_precip USING BTREE (localcode_ltree);"

# now calculate area-weighted avg MAP upstream of every stream segment
# loop through watershed groups, don't bother trying to update in parallel
for WSG in $(psql -t -P border=0,footer=no \
  -c "SELECT watershed_group_code
      FROM whse_basemapping.fwa_watershed_groups_poly
      ORDER BY watershed_group_code")
do
  psql -X -v wsg="$WSG" < sql/map_upstream.sql
done

# optionally, drop the temp tables and raster
#psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_wsd"
#psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_load"
#rm mean_annual_precip.tif*