#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")

mkdir -p data

# direct download links do not seem to be available at this time
# go to https://climatebc.ca/SpatialData and download MAP for 1991-2020 to /data
#wget --trust-server-names -qNP ~/tmp http://raster.climatebc.ca/download/Normal_1981_2010MSY/Normal_1981_2010_annual.zip
#unzip ~/tmp/Normal_1981_2010_annual.zip -d ~/tmp/climatebc

# resample the precip data to match DEM raster resolution (but no need to align)
gdalwarp data/MAP.tif data/map_25m.tif -t_srs EPSG:3005 -of COG -co COMPRESS=DEFLATE -tr 25 25

# ----------
# Derive MAP per fundamental watershed poly
# ----------
$PSQL -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_wsd_load_poly"
$PSQL -c "CREATE TABLE bcfishpass.mean_annual_precip_wsd_load_poly (watershed_feature_id integer, watershed_group_code text, map numeric)"

# Loop through watershed groups
# (rather than loading geojson of all fundamental watershed polys for BC into memory,
# this takes longer but is much more memory safe)
for WSG in $WSGS
do
  echo 'Processing '$WSG
  $PSQL -X -t -v wsg="$WSG" <<< "SELECT
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
        -r data/map_25m.tif \
        --prefix 'map_' \
        2>/dev/null" | \
    jq '.features[].properties | [.watershed_feature_id, .watershed_group_code, .map_mean]' | \
    jq -r --slurp '.[] | @csv' | \
    $PSQL -c "\copy bcfishpass.mean_annual_precip_wsd_load_poly FROM STDIN delimiter ',' csv header"
done

# load unique watersheds from load table (rasterstats is generating some duplicates and I'm not sure how to fix,
# it is probably something to do with sequences vs collections)
$PSQL -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_wsd"
$PSQL -c "CREATE TABLE bcfishpass.mean_annual_precip_wsd (watershed_feature_id integer PRIMARY KEY, watershed_group_code text, map numeric)"
$PSQL -c "INSERT INTO bcfishpass.mean_annual_precip_wsd SELECT DISTINCT * FROM bcfishpass.mean_annual_precip_wsd_load"


# ----------
# Derive MAP per fundamental watershed for centroids of watershed polys missed with above step (due to small size)
# ----------
$PSQL -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_wsd_load_pt"
$PSQL -c "CREATE TABLE bcfishpass.mean_annual_precip_wsd_load_pt (watershed_feature_id integer, watershed_group_code text, map numeric)"

# run pointquery. At 73,409 points, this is fine to run provincially and in a single process.
$PSQL -t -c "SELECT ST_AsGeoJSON(t.*)
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
  rio -q pointquery -r data/map_25m.tif 2>/dev/null | \
  jq '.features[].properties | [.watershed_feature_id, .watershed_group_code, .value]' | \
  jq -r --slurp '.[] | @csv' | \
  $PSQL -c "\copy bcfishpass.mean_annual_precip_wsd_load_pt FROM STDIN delimiter ',' csv header"

$PSQL -c "UPDATE bcfishpass.mean_annual_precip_wsd a
         SET map = l.map
         FROM bcfishpass.mean_annual_precip_wsd_load_pt l
         WHERE a.watershed_feature_id = l.watershed_feature_id"


# ----------
# Derive MAP for streams without an associated fundamental watershed poly (matching ws codes) 
# (these are mostly in rivers)
# ----------
#  Process these my getting MAP of at pointonsurface of the stream geometry (there are about 59k of these)
$PSQL -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_load"
$PSQL -c "CREATE TABLE bcfishpass.mean_annual_precip_load (wscode_ltree ltree, localcode_ltree ltree, watershed_group_code text, map numeric)"
$PSQL -t -c "SELECT ST_AsGeoJSON(t.*)
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
  rio -q pointquery -r data/map_25m.tif 2>/dev/null | \
  jq '.features[].properties | [.wscode_ltree, .localcode_ltree, .watershed_group_code, .value]' | \
  jq -r --slurp '.[] | @csv' | \
  $PSQL -c "\copy bcfishpass.mean_annual_precip_load FROM STDIN delimiter ',' csv header"


# ----------
# Create the output table.
# ----------
# There can be some remenant duplicates in the source data, make sure it does not get included
# by adding a unique constraint on watershed codes
$PSQL -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip"
$PSQL -c "CREATE TABLE bcfishpass.mean_annual_precip
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
for WSG in $WSGS
do
  $PSQL -f sql/map.sql -v wsg="$WSG"
done

# index the table for upstream/downstream joins
$PSQL -c "CREATE INDEX ON bcfishpass.mean_annual_precip USING GIST (wscode_ltree);"
$PSQL -c "CREATE INDEX ON bcfishpass.mean_annual_precip USING BTREE (wscode_ltree);"
$PSQL -c "CREATE INDEX ON bcfishpass.mean_annual_precip USING GIST (localcode_ltree);"
$PSQL -c "CREATE INDEX ON bcfishpass.mean_annual_precip USING BTREE (localcode_ltree);"

# now calculate area-weighted avg MAP upstream of every stream segment
# loop through watershed groups, don't bother trying to update in parallel
for WSG in $WSGS
do
  $PSQL -X -v wsg="$WSG" < sql/map_upstream.sql
done

# optionally, drop the temp tables and raster
#$PSQL -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_wsd"
#$PSQL -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_load_pt"
#$PSQL -c "DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_load_poly"
#rm data/map_25m.tif*