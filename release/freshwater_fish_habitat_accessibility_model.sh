#!/bin/bash
set -euxo pipefail

# refresh the views
psql $DATABASE_URL -v ON_ERROR_STOP=1 -f sql/freshwater_fish_habitat_accessibility_model.sql

rm -r freshwater_fish_habitat_accessibility_MODEL.gpkg*

echo 'dumping crossings'
ogr2ogr \
    -f GPKG \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln crossings \
    -nlt Point \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw"


echo 'dumping barriers_salmon'
ogr2ogr \
    -f GPKG \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln barriers_salmon \
    -nlt Point \
    -sql "select 
			 barriers_ch_cm_co_pk_sk_id,
			 barrier_type,
			 barrier_name,
			 linear_feature_id,
			 blue_line_key,
			 watershed_key,
			 downstream_route_measure,
			 wscode_ltree as wscode,
			 localcode_ltree as localcode,
			 watershed_group_code,
			 total_network_km,
			 geom
  		  from bcfishpass.barriers_ch_cm_co_pk_sk"


echo 'dumping barriers_steelhead'
ogr2ogr \
    -f GPKG \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln barriers_steelhead \
    -nlt Point \
    -sql "select 
			 barriers_st_id,
			 barrier_type,
			 barrier_name,
			 linear_feature_id,
			 blue_line_key,
			 watershed_key,
			 downstream_route_measure,
			 wscode_ltree as wscode,
			 localcode_ltree as localcode,
			 watershed_group_code,
			 total_network_km,
			 geom
  		  from bcfishpass.barriers_st"

echo 'dumping salmon'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln model_access_salmon \
    -nlt LineString \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_salmon_vw"

echo 'dumping steelhead'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln model_access_steelhead \
    -nlt LineString \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_steelhead_vw"

echo 'dumping observations'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln observations \
    -nlt Point \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw"   

echo 'dump to MODEL.gpkg complete'    

# zip and remove uncompressed file
zip -r freshwater_fish_habitat_accessibility_MODEL.gpkg.zip freshwater_fish_habitat_accessibility_MODEL.gpkg
rm freshwater_fish_habitat_accessibility_MODEL.gpkg

# send to s3
aws s3 cp freshwater_fish_habitat_accessibility_MODEL.gpkg.zip s3://bcfishpass/
# open it up
aws s3api put-object-acl --bucket bcfishpass --key freshwater_fish_habitat_accessibility_MODEL.gpkg.zip --acl public-read