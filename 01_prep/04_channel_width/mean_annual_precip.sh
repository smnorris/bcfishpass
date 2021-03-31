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

# derive map and load to postgres, in the load table
psql -t -c "SELECT
  ST_AsGeoJSON(t.*)
FROM
  (
    SELECT
      watershed_feature_id,
      watershed_group_code,
      geom
    FROM whse_basemapping.fwa_watersheds_poly
  ) as t" | \
  parallel \
    --pipe \
    "rio -q zonalstats \
      -r mean_annual_precip.tif \
      --prefix 'map_'" | \
  jq '.features[].properties | {watershed_feature_id: .watershed_feature_id, watershed_group_code: .watershed_group_code, map: .map_mean}' | \
  jq --slurp . | \
  in2csv -f json |
  psql -c "\copy bcfishpass.mean_annual_precip_wsd_load FROM STDIN delimiter ',' csv header"

# load unique watersheds from load table (rasterstats is generating some duplicates and I'm not sure how to fix,
# it is probably something to do with sequences vs collections)
psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_wsd"
psql -c "CREATE TABLE bcfishpass.mean_annual_precip_wsd (watershed_feature_id integer PRIMARY KEY, watershed_group_code text, map numeric)"
psql -c "INSERT INTO bcfishpass.mean_annual_precip_wsd SELECT DISTINCT * FROM bcfishpass.mean_annual_precip_wsd_load"

# drop the load table
psql -c "DROP TABLE bcfishpass.mean_annual_precip_wsd_load"

# How many watershed polygons get missed? Only about 1% (768/72450) for BULK/LNIC/HORS/ELKR/MORR
# But we can run those watersheds based on their centroids/pointonsurface

# recreate load table
psql -c "CREATE TABLE bcfishpass.mean_annual_precip_wsd_load (watershed_feature_id integer, watershed_group_code text, map numeric)"

# run pointquery
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
  rio -q pointquery -r mean_annual_precip.tif | \
  jq '.features[].properties | {watershed_feature_id: .watershed_feature_id, watershed_group_code: .watershed_group_code, map: .value}' | \
  jq --slurp . | \
  in2csv -f json |
  psql -c "\copy bcfishpass.mean_annual_precip_wsd_load FROM STDIN delimiter ',' csv header"

psql -c "UPDATE bcfishpass.mean_annual_precip_wsd a
         SET map = l.map
         FROM bcfishpass.mean_annual_precip_wsd_load l
         WHERE a.watershed_feature_id = l.watershed_feature_id"

# drop load table again
psql -c "DROP TABLE bcfishpass.mean_annual_precip_wsd_load"

# there are remaining nulls (n=12) - presumably these wsds just are not covered by the grid (on border)

# Because there are streams (distinct watershed code / local code combinations) with no watershed polygon
# (mostly in rivers) and we need MAP values for these too, generate them directly with the MAP raster
# rather than joining to the watersheds
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
  rio -q pointquery -r mean_annual_precip.tif | \
  jq '.features[].properties | {wscode_ltree: .wscode_ltree, localcode_ltree: .localcode_ltree, watershed_group_code: .watershed_group_code, map: .value}' | \
  jq --slurp . | \
  in2csv -f json |
  psql -c "\copy bcfishpass.mean_annual_precip_load FROM STDIN delimiter ',' csv header"

# finally, call sql that combines everything and calculates area-weighted avg MAP upstream of every stream segment
psql -f sql/mean_annual_precip.sql

# optionally, drop the temp tables and raster
#psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_wsd"
#psql -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_load"
#rm mean_annual_precip.tif*