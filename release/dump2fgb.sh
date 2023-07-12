#!/bin/bash

# ======================================================================
# dump2fgb.sh
# To enable simple speedy per watershed group downloads, dump bcfishpass
# outputs and key inputs to flat geobuf, overlaying with watersheds
# where watershed_group_code is not present in the data
# ======================================================================

set -euxo pipefail

PARALLEL="parallel --halt now,fail=1 --jobs 4 --no-run-if-empty"
PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")


mkdir -p fgb
$PSQL -c "create schema if not exists temp"

# -----------------------------------------
# bcfishobs.fiss_fish_obsrvtn_events_vw
# Observations linked to streams
# (no overlay with watersheds required)
# -----------------------------------------
ogr2ogr \
    -f FlatGeobuf \
    fgb/fiss_fish_obsrvtn_events_vw.fgb \
    PG:$DATABASE_URL \
    -nln fiss_fish_obsrvtn_events_vw \
    -sql "select * from bcfishobs.fiss_fish_obsrvtn_events_vw"


# -----------------------------------------
# whse_fish.fiss_obstacles_pnt_sp
# Obstacles (straight from source rather than linked to streams)
# -----------------------------------------
$PSQL -c "drop table if exists temp.fiss_obstacles_pnt_sp"
$PSQL -c "create table temp.fiss_obstacles_pnt_sp (
  fish_obstacle_point_id  numeric                  ,
  agency_id               numeric                  ,
  wbody_id                numeric                  ,
  obstacle_code           character varying(6)     ,
  obstacle_name           character varying(60)    ,
  agency_name             character varying(60)    ,
  source                  character varying(1000)  ,
  source_ref              character varying(4000)  ,
  height                  numeric                  ,
  length                  numeric                  ,
  utm_zone                numeric                  ,
  utm_easting             numeric                  ,
  utm_northing            numeric                  ,
  survey_date             date                     ,
  waterbody_identifier    character varying(9)     ,
  waterbody_type          character varying(20)    ,
  gazetted_name           character varying(30)    ,
  new_watershed_code      character varying(56)    ,
  trimmed_watershed_code  character varying(56)    ,
  acat_report_url         character varying(254)   ,
  feature_code            character varying(10)    ,
  objectid                numeric                  ,
  assessment_watershed_id integer,
  watershed_group_id      integer,
  watershed_group_code    character varying (4),
  geom                    geometry(MultiPoint,3005)
);"

$PARALLEL "echo \"insert into temp.fiss_obstacles_pnt_sp (
  fish_obstacle_point_id,
  agency_id,
  wbody_id,
  obstacle_code,
  obstacle_name,
  agency_name,
  source,
  source_ref,
  height,
  length,
  utm_zone,
  utm_easting,
  utm_northing,
  survey_date,
  waterbody_identifier,
  waterbody_type,
  gazetted_name,
  new_watershed_code,
  trimmed_watershed_code,
  acat_report_url,
  feature_code,
  objectid,
  assessment_watershed_id,
  watershed_group_id,
  watershed_group_code,
  geom
)
select
  a.fish_obstacle_point_id,
  a.agency_id,
  a.wbody_id,
  a.obstacle_code,
  a.obstacle_name,
  a.agency_name,
  a.source,
  a.source_ref,
  a.height,
  a.length,
  a.utm_zone,
  a.utm_easting,
  a.utm_northing,
  a.survey_date,
  a.waterbody_identifier,
  a.waterbody_type,
  a.gazetted_name,
  a.new_watershed_code,
  a.trimmed_watershed_code,
  a.acat_report_url,
  a.feature_code,
  a.objectid,
  b.watershed_feature_id as assessment_watershed_id,
  b.watershed_group_id,
  b.watershed_group_code,
  CASE
    WHEN ST_Coveredby(a.geom, b.geom) THEN a.geom
    ELSE st_multi(ST_Intersection(a.geom, b.geom))
  END AS geom
  from whse_fish.fiss_obstacles_pnt_sp a
  inner join whse_basemapping.fwa_assessment_watersheds_poly b
  on st_intersects(a.geom, b.geom)
  where b.watershed_group_code = :'wsg';\" \
| $PSQL -v wsg={1}" ::: $WSGS

ogr2ogr \
    -f FlatGeobuf \
    fgb/fiss_obstacles_pnt_sp.fgb \
    PG:$DATABASE_URL \
    -nln fiss_obstacles_pnt_sp \
    -sql "select * from temp.fiss_obstacles_pnt_sp"

$PSQL -c "drop table temp.fiss_obstacles_pnt_sp"    


# -----------------------------------------
# whse_forest_tenure.ften_road_section_lines_svw
# FTEN roads
# -----------------------------------------
$PSQL -c "drop table if exists temp.ften_road_section_lines_svw"
$PSQL -c "create table temp.ften_road_section_lines_svw (
 forest_file_id            character varying(10)          ,
 road_section_id           character varying(30)          ,
 feature_class_skey        numeric                        ,
 road_section_name         character varying(100)         ,
 road_section_length       numeric                        ,
 retirement_date           date                           ,
 section_width             numeric                        ,
 feature_length            numeric                        ,
 amendment_id              numeric                        ,
 file_status_code          character varying(3)           ,
 file_type_code            character varying(3)           ,
 file_type_description     character varying(120)         ,
 geographic_district_code  character varying(6)           ,
 geographic_district_name  character varying(100)         ,
 award_date                date                           ,
 expiry_date               date                           ,
 client_number             character varying(8)           ,
 client_location_code      character varying(2)           ,
 client_name               character varying(91)          ,
 location                  character varying(120)         ,
 life_cycle_status_code    character varying(10)          ,
 map_label                 character varying(41)          ,
 objectid                  numeric                        ,
 assessment_watershed_id integer                          ,
 watershed_group_id integer                               ,
 watershed_group_code character varying (4)               ,
 geom                      geometry(MultiLineString,3005)
);"

$PARALLEL "echo \"insert into temp.ften_road_section_lines_svw (
 forest_file_id,
 road_section_id,
 feature_class_skey,
 road_section_name,
 road_section_length,
 retirement_date,
 section_width,
 feature_length,
 amendment_id,
 file_status_code,
 file_type_code,
 file_type_description,
 geographic_district_code,
 geographic_district_name,
 award_date,
 expiry_date,
 client_number,
 client_location_code,
 client_name,
 location,
 life_cycle_status_code,
 map_label,
 objectid,
 assessment_watershed_id,
 watershed_group_id,
 watershed_group_code,
 geom
)
with lines as (
select
  a.objectid,
  b.watershed_feature_id as assessment_watershed_id,
  b.watershed_group_id,
  b.watershed_group_code,
  CASE
    WHEN ST_Coveredby(a.geom, b.geom) THEN a.geom
  ELSE
    ST_Intersection(a.geom, b.geom)
  END AS geom
  from whse_forest_tenure.ften_road_section_lines_svw a
  inner join whse_basemapping.fwa_assessment_watersheds_poly b
  on st_intersects(a.geom, b.geom)
  where b.watershed_group_code = :'wsg'
),
cleaned as (
  select objectid,
  assessment_watershed_id,
  watershed_group_id,
  watershed_group_code,
  st_multi((st_dump(geom)).geom) as geom
  from lines
)
SELECT
  a.forest_file_id,
  a.road_section_id,
  a.feature_class_skey,
  a.road_section_name,
  a.road_section_length,
  a.retirement_date,
  a.section_width,
  a.feature_length,
  a.amendment_id,
  a.file_status_code,
  a.file_type_code,
  a.file_type_description,
  a.geographic_district_code,
  a.geographic_district_name,
  a.award_date,
  a.expiry_date,
  a.client_number,
  a.client_location_code,
  a.client_name,
  a.location,
  a.life_cycle_status_code,
  a.map_label,
  a.objectid,
   b.assessment_watershed_id,
  b.watershed_group_id,
  b.watershed_group_code,
  b.geom
  from whse_forest_tenure.ften_road_section_lines_svw a
  inner join cleaned b
  on st_intersects(a.geom, b.geom)
  where st_dimension(b.geom) = 1;\" \
| $PSQL -v wsg={1}" ::: $WSGS

ogr2ogr \
    -f FlatGeobuf \
    fgb/ften_road_section_lines_svw.fgb \
    PG:$DATABASE_URL \
    -nln ften_road_section_lines_svw \
    -sql "select * from temp.ften_road_section_lines_svw"

$PSQL -c "drop table temp.ften_road_section_lines_svw"


# -----------------------------------------
# whse_basemapping.transport_line
# DRA roads
# -----------------------------------------
$PSQL -c "drop table if exists temp.transport_line"
$PSQL -c "create table temp.transport_line (
  id serial primary key,
  transport_line_id              integer                  not null ,
  capture_date                   timestamp with time zone          ,
  deactivation_date              timestamp with time zone          ,
  transport_line_type_code       character varying(3)     not null ,
  transport_line_type_description text,
  transport_line_surface_code    character varying(1)     not null ,
  transport_line_surface_description text,
  transport_line_divided_code    character varying(1)     not null ,
  travel_direction_code          character varying(1)     not null ,
  transport_line_structure_code  character varying(1)              ,
  speed_limit                    smallint                 not null ,
  left_number_of_lanes           smallint                 not null ,
  right_number_of_lanes          smallint                 not null ,
  total_number_of_lanes          smallint                 not null ,
  under_construction_ind         character varying(1)     not null ,
  virtual_ind                    character varying(1)     not null ,
  disaster_route_ind             character varying(1)     not null ,
  truck_route_ind                character varying(1)     not null ,
  structured_name_1              character varying(100)            ,
  structured_name_2              character varying(100)            ,
  structured_name_3              character varying(100)            ,
  structured_name_4              character varying(100)            ,
  structured_name_5              character varying(100)            ,
  structured_name_6              character varying(100)            ,
  structured_name_7              character varying(100)            ,
  highway_route_1                character varying(5)              ,
  highway_route_2                character varying(5)              ,
  highway_route_3                character varying(5)              ,
  highway_exit_number            character varying(5)              ,
  industry_name_1                character varying(255)            ,
  industry_name_2                character varying(255)            ,
  industry_name_3                character varying(255)            ,
  ministry_of_transport_name     character varying(255)            ,
  integration_notes              character varying(4000)           ,
  excluded_rules                 character varying(4000)           ,
  demographic_ind                character varying(1)     not null ,
  assessment_watershed_id integer,
  watershed_group_id integer,
  watershed_group_code character varying (4),
  geom                          geometry(MultiLineStringZ,3005)
);"

$PARALLEL "echo \"insert into temp.transport_line (
  transport_line_id,
  capture_date,
  deactivation_date,
  transport_line_type_code,
  transport_line_type_description   ,
  transport_line_surface_code,
  transport_line_surface_description,
  transport_line_divided_code,
  travel_direction_code,
  transport_line_structure_code,
  speed_limit,
  left_number_of_lanes,
  right_number_of_lanes,
  total_number_of_lanes,
  under_construction_ind,
  virtual_ind,
  disaster_route_ind,
  truck_route_ind,
  structured_name_1,
  structured_name_2,
  structured_name_3,
  structured_name_4,
  structured_name_5,
  structured_name_6,
  structured_name_7,
  highway_route_1,
  highway_route_2,
  highway_route_3,
  highway_exit_number,
  industry_name_1,
  industry_name_2,
  industry_name_3,
  ministry_of_transport_name,
  integration_notes,
  excluded_rules,
  demographic_ind,
  assessment_watershed_id,
  watershed_group_id,
  watershed_group_code,
  geom)
with lines as (
select
  a.transport_line_id,
  b.watershed_feature_id as assessment_watershed_id,
  b.watershed_group_id,
  b.watershed_group_code,
  CASE
    WHEN ST_Coveredby(a.geom, b.geom) THEN a.geom
  ELSE
    ST_Intersection(a.geom, b.geom)
  END AS geom
  from whse_basemapping.transport_line a
  inner join whse_basemapping.fwa_assessment_watersheds_poly b
  on st_intersects(a.geom, b.geom)
  where b.watershed_group_code = :'wsg'
),
cleaned as (
  select transport_line_id,
  assessment_watershed_id,
  watershed_group_id,
  watershed_group_code,
  st_multi((st_dump(geom)).geom) as geom
  from lines
)

select
  a.transport_line_id,
  a.capture_date,
  a.deactivation_date,
  a.transport_line_type_code,
  dratype.description         as transport_line_type_description   ,
  a.transport_line_surface_code,
  drasurface.description      as transport_line_surface_description,
  a.transport_line_divided_code,
  a.travel_direction_code,
  a.transport_line_structure_code,
  a.speed_limit,
  a.left_number_of_lanes,
  a.right_number_of_lanes,
  a.total_number_of_lanes,
  a.under_construction_ind,
  a.virtual_ind,
  a.disaster_route_ind,
  a.truck_route_ind,
  a.structured_name_1,
  a.structured_name_2,
  a.structured_name_3,
  a.structured_name_4,
  a.structured_name_5,
  a.structured_name_6,
  a.structured_name_7,
  a.highway_route_1,
  a.highway_route_2,
  a.highway_route_3,
  a.highway_exit_number,
  a.industry_name_1,
  a.industry_name_2,
  a.industry_name_3,
  a.ministry_of_transport_name,
  a.integration_notes,
  a.excluded_rules,
  a.demographic_ind,
  b.assessment_watershed_id,
  b.watershed_group_id,
  b.watershed_group_code,
  b.geom
from whse_basemapping.transport_line a
inner join cleaned b
on a.transport_line_id = b.transport_line_id
left outer join whse_basemapping.transport_line_type_code dratype
on a.transport_line_type_code = dratype.transport_line_type_code
left outer join whse_basemapping.transport_line_surface_code drasurface
on a.transport_line_surface_code = drasurface.transport_line_surface_code
where st_dimension(b.geom) = 1;\" \
| $PSQL -v wsg={1}" ::: $WSGS

ogr2ogr \
    -f FlatGeobuf \
    fgb/transport_line.fgb \
    PG:$DATABASE_URL \
    -nln transport_line \
    -sql "select * from temp.transport_line"

$PSQL -c "drop table temp.transport_line"