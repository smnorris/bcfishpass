#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM whse_basemapping.fwa_watershed_groups_poly")

cd ..

# load gradients to various bcfishpass.gradient_barriers_<length> tables
$PSQL -c "truncate bcfishpass.gradient_barriers"
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=100 -v wsg={1} ::: $WSGS
$PSQL -c "drop table if exists bcfishpass.gradient_barriers_100; 
  create table bcfishpass.gradient_barriers_100 as 
   select 
   	  *, 
   	  100 as method, 
   	  whse_basemapping.fwa_locatealong(blue_line_key, downstream_route_measure) as geom 
   from bcfishpass.gradient_barriers"


$PSQL -c "truncate bcfishpass.gradient_barriers"
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=50 -v wsg={1} ::: $WSGS
$PSQL -c "drop table if exists bcfishpass.gradient_barriers_50; 
  create table bcfishpass.gradient_barriers_50 as 
   select 
      *, 
      50 as method, 
      whse_basemapping.fwa_locatealong(blue_line_key, downstream_route_measure) as geom 
   from bcfishpass.gradient_barriers"


$PSQL -c "truncate bcfishpass.gradient_barriers"
parallel $PSQL -f sql/gradient_barriers_load.sql -v grade_dist=25 -v wsg={1} ::: $WSGS
$PSQL -c "drop table if exists bcfishpass.gradient_barriers_25; 
  create table bcfishpass.gradient_barriers_25 as 
   select 
      *, 
      25 as method, 
      whse_basemapping.fwa_locatealong(blue_line_key, downstream_route_measure) as geom 
   from bcfishpass.gradient_barriers"

# index output tables
$PSQL -c "alter table bcfishpass.gradient_barriers_100 add PRIMARY KEY (gradient_barrier_id);
create index on bcfishpass.gradient_barriers_100 using btree (blue_line_key);
create index on bcfishpass.gradient_barriers_100 using btree (localcode_ltree);
create index on bcfishpass.gradient_barriers_100 using gist (localcode_ltree);
create index on bcfishpass.gradient_barriers_100 using btree (watershed_group_code);
create index on bcfishpass.gradient_barriers_100 using btree (wscode_ltree);
create index on bcfishpass.gradient_barriers_100 using gist (wscode_ltree)
create index on bcfishpass.gradient_barriers_100 using gist (geom);"

$PSQL -c "alter table bcfishpass.gradient_barriers_50 add PRIMARY KEY (gradient_barrier_id);
create index on bcfishpass.gradient_barriers_50 using btree (blue_line_key);
create index on bcfishpass.gradient_barriers_50 using btree (localcode_ltree);
create index on bcfishpass.gradient_barriers_50 using gist (localcode_ltree);
create index on bcfishpass.gradient_barriers_50 using btree (watershed_group_code);
create index on bcfishpass.gradient_barriers_50 using btree (wscode_ltree);
create index on bcfishpass.gradient_barriers_50 using gist (wscode_ltree)
create index on bcfishpass.gradient_barriers_50 using gist (geom);"

$PSQL -c "alter table bcfishpass.gradient_barriers_25 add PRIMARY KEY (gradient_barrier_id);
create index on bcfishpass.gradient_barriers_25 using btree (blue_line_key);
create index on bcfishpass.gradient_barriers_25 using btree (localcode_ltree);
create index on bcfishpass.gradient_barriers_25 using gist (localcode_ltree);
create index on bcfishpass.gradient_barriers_25 using btree (watershed_group_code);
create index on bcfishpass.gradient_barriers_25 using btree (wscode_ltree);
create index on bcfishpass.gradient_barriers_25 using gist (wscode_ltree);
create index on bcfishpass.gradient_barriers_25 using gist (geom);"


# report
cd analysis
$PSQL -f sql/observations_max_gradients_downstream.sql
$PSQL -c "select * from observations_max_gradients_downstream_vw" > observations_max_gradients_downstream.csv


# also report on distinct locations
$PSQL -c "SELECT 
  array_length(array_agg(o.observation_key), 1) as n_observations,
  o.species_code,
  o.blue_line_key,
  o.downstream_route_measure,
  o.watershed_group_code,
  mg100.stream_order,
  mg100.elevation,
  mg100.max_gradient_id as dnstr_max_grade_100_id,
    mg100.max_gradient as dnstr_max_grade_100,
    round((do100.max_grade_dnstr_dist_to_ocean / 1000)::numeric, 2) as dnstr_max_grade_100_dist_to_ocean_km,
    mg50.max_gradient_id as dnstr_max_grade_50_id,
    mg50.max_gradient as dnstr_max_grade_50,
    round((do50.max_grade_dnstr_dist_to_ocean / 1000)::numeric, 2) as dnstr_max_grade_50_dist_to_ocean_km,
    mg25.max_gradient_id as dnstr_max_grade_id,
    mg25.max_gradient as dnstr_max_grade_25,
    round((do25.max_grade_dnstr_dist_to_ocean / 1000)::numeric, 2) as dnstr_max_grade_25_dist_to_ocean_km
from bcfishpass.observations o
inner join obs_max_grade_dnstr_100 mg100 on o.observation_key = mg100.observation_key
inner join obs_max_grade_dnstr_50 mg50 on mg100.observation_key = mg50.observation_key
inner join obs_max_grade_dnstr_25 mg25 on mg100.observation_key = mg25.observation_key
LEFT OUTER JOIN obs_max_grade_dnstr_dist_to_ocean_100 do100 ON mg100.max_gradient_id = do100.max_gradient_id
LEFT OUTER JOIN obs_max_grade_dnstr_dist_to_ocean_50 do50 ON mg50.max_gradient_id = do50.max_gradient_id
LEFT OUTER JOIN obs_max_grade_dnstr_dist_to_ocean_25 do25 ON mg25.max_gradient_id = do25.max_gradient_id
where o.species_code in ('CH','CM','CO','PK','SK')
GROUP BY
  o.species_code,
  o.blue_line_key,
  o.downstream_route_measure,
  o.watershed_group_code,
  mg100.stream_order,
  mg100.elevation,
  dnstr_max_grade_100_id,
  dnstr_max_grade_100,
  dnstr_max_grade_100_dist_to_ocean_km,
  dnstr_max_grade_50_id,
  dnstr_max_grade_50,
  dnstr_max_grade_50_dist_to_ocean_km,
  dnstr_max_grade_id,
  dnstr_max_grade_25,
  dnstr_max_grade_25_dist_to_ocean_km;" --csv > salmon_uniqueobslocation_max_gradients_downstream.csv


$PSQL -c "SELECT 
  array_length(array_agg(o.observation_key), 1) as n_observations,
  o.species_code,
  o.blue_line_key,
  o.downstream_route_measure,
  mg100.stream_order,
  mg100.elevation,
  CASE
      WHEN o.life_stage ilike '%ADULT%' then true
      WHEN o.life_stage ilike '%ADULT%' is false then false
      WHEN o.life_stage is null then NULL
  END AS adult,
  o.watershed_group_code,
  mg100.max_gradient_id as dnstr_max_grade_100_id,
    mg100.max_gradient as dnstr_max_grade_100,
    round((do100.max_grade_dnstr_dist_to_ocean / 1000)::numeric, 2) as dnstr_max_grade_100_dist_to_ocean_km,
    mg50.max_gradient_id as dnstr_max_grade_50_id,
    mg50.max_gradient as dnstr_max_grade_50,
    round((do50.max_grade_dnstr_dist_to_ocean / 1000)::numeric, 2) as dnstr_max_grade_50_dist_to_ocean_km,
    mg25.max_gradient_id as dnstr_max_grade_id,
    mg25.max_gradient as dnstr_max_grade_25,
    round((do25.max_grade_dnstr_dist_to_ocean / 1000)::numeric, 2) as dnstr_max_grade_25_dist_to_ocean_km
from bcfishpass.observations o
inner join obs_max_grade_dnstr_100 mg100 on o.observation_key = mg100.observation_key
inner join obs_max_grade_dnstr_50 mg50 on mg100.observation_key = mg50.observation_key
inner join obs_max_grade_dnstr_25 mg25 on mg100.observation_key = mg25.observation_key
LEFT OUTER JOIN obs_max_grade_dnstr_dist_to_ocean_100 do100 ON mg100.max_gradient_id = do100.max_gradient_id
LEFT OUTER JOIN obs_max_grade_dnstr_dist_to_ocean_50 do50 ON mg50.max_gradient_id = do50.max_gradient_id
LEFT OUTER JOIN obs_max_grade_dnstr_dist_to_ocean_25 do25 ON mg25.max_gradient_id = do25.max_gradient_id
where o.species_code ='ST'
GROUP BY
  o.species_code,
  o.blue_line_key,
  o.downstream_route_measure,
  o.watershed_group_code,
  mg100.stream_order,
  mg100.elevation,
  adult,
  dnstr_max_grade_100_id,
  dnstr_max_grade_100,
  dnstr_max_grade_100_dist_to_ocean_km,
  dnstr_max_grade_50_id,
  dnstr_max_grade_50,
  dnstr_max_grade_50_dist_to_ocean_km,
  dnstr_max_grade_id,
  dnstr_max_grade_25,
  dnstr_max_grade_25_dist_to_ocean_km;" --csv > steelhead_uniqueobslocation_max_gradients_downstream.csv