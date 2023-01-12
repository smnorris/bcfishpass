#!/bin/bash
set -euxo pipefail


echo 'dumping crossings'
ogr2ogr \
    -f GPKG \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln crossings \
    -nlt Point \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw"

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