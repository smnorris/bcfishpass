DROP TABLE IF EXISTS obs_max_grade_dnstr_100;

CREATE TABLE obs_max_grade_dnstr_100 AS
  SELECT DISTINCT ON (a.observation_key)
    a.observation_key,
    a.species_code,
    a.watershed_group_code,
    s.stream_order,
    round(st_z(a.geom)) as elevation,
    g.gradient_barrier_id max_gradient_id,
    g.gradient_class as max_gradient
  FROM bcfishpass.observations a
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s ON a.linear_feature_id = s.linear_feature_id
  LEFT OUTER JOIN bcfishpass.gradient_barriers_100 g
  ON FWA_Downstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode,
      a.localcode,
      g.blue_line_key,
      g.downstream_route_measure,
      g.wscode_ltree,
      g.localcode_ltree,
      False
  )
  WHERE 
    a.species_code in ('CH','CM','CO','PK','SK','ST')
    and a.release is null
  ORDER BY
    a.observation_key,
    g.gradient_class desc,
    g.wscode_ltree desc,
    g.downstream_route_measure desc;

ALTER TABLE obs_max_grade_dnstr_100 ADD primary key (observation_key);


DROP TABLE IF EXISTS obs_max_grade_dnstr_50;

CREATE TABLE obs_max_grade_dnstr_50 AS
  SELECT DISTINCT ON (a.observation_key)
    a.observation_key,
    a.species_code,
    a.watershed_group_code,
    s.stream_order,
    round(st_z(a.geom)) as elevation,
    g.gradient_barrier_id max_gradient_id,
    g.gradient_class as max_gradient
  FROM bcfishpass.observations a
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s ON a.linear_feature_id = s.linear_feature_id
  LEFT OUTER JOIN bcfishpass.gradient_barriers_50 g
  ON FWA_Downstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode,
      a.localcode,
      g.blue_line_key,
      g.downstream_route_measure,
      g.wscode_ltree,
      g.localcode_ltree,
      False
  )
  WHERE 
    a.species_code in ('CH','CM','CO','PK','SK','ST')
    and a.release is null
  ORDER BY
    a.observation_key,
    g.gradient_class desc,
    g.wscode_ltree desc,
    g.downstream_route_measure desc;

ALTER TABLE obs_max_grade_dnstr_50 ADD primary key (observation_key);


DROP TABLE IF EXISTS obs_max_grade_dnstr_25;


CREATE TABLE obs_max_grade_dnstr_25 AS
  SELECT DISTINCT ON (a.observation_key)
    a.observation_key,
    a.species_code,
    a.watershed_group_code,
    s.stream_order,
    round(st_z(a.geom)) as elevation,
    g.gradient_barrier_id max_gradient_id,
    g.gradient_class as max_gradient
  FROM bcfishpass.observations a
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s ON a.linear_feature_id = s.linear_feature_id
  LEFT OUTER JOIN bcfishpass.gradient_barriers_25 g
  ON FWA_Downstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode,
      a.localcode,
      g.blue_line_key,
      g.downstream_route_measure,
      g.wscode_ltree,
      g.localcode_ltree,
      False
  )
    WHERE 
    a.species_code in ('CH','CM','CO','PK','SK','ST')
    and a.release is null
  ORDER BY
    a.observation_key,
    g.gradient_class desc,
    g.wscode_ltree desc,
    g.downstream_route_measure desc;

ALTER TABLE obs_max_grade_dnstr_25 ADD primary key (observation_key);




DROP TABLE IF EXISTS obs_max_grade_dnstr_dist_to_ocean_100;

CREATE table obs_max_grade_dnstr_dist_to_ocean_100 AS
with max_dnstr_gradient_locations as (
SELECT DISTINCT
  a.max_gradient_id,
  gb.blue_line_key,
  gb.downstream_route_measure
FROM obs_max_grade_dnstr_100 a
INNER JOIN bcfishpass.gradient_barriers_100 gb
ON a.max_gradient_id = gb.gradient_barrier_id
)

SELECT
  max_gradient_id,
  coalesce(distance_to_ocean, 0) as max_grade_dnstr_dist_to_ocean
FROM max_dnstr_gradient_locations l
LEFT JOIN LATERAL
(
  SELECT 
    sum(length_metre) as distance_to_ocean
  FROM
    FWA_DownstreamTrace(l.blue_line_key, l.downstream_route_measure)
) s1 ON true;


ALTER TABLE obs_max_grade_dnstr_dist_to_ocean_100 ADD primary key (max_gradient_id);



DROP TABLE IF EXISTS obs_max_grade_dnstr_dist_to_ocean_50;

CREATE table obs_max_grade_dnstr_dist_to_ocean_50 AS
with max_dnstr_gradient_locations as (
SELECT DISTINCT
  a.max_gradient_id,
  gb.blue_line_key,
  gb.downstream_route_measure
FROM obs_max_grade_dnstr_50 a
INNER JOIN bcfishpass.gradient_barriers_50 gb
ON a.max_gradient_id = gb.gradient_barrier_id
)

SELECT
  max_gradient_id,
  coalesce(distance_to_ocean, 0) as max_grade_dnstr_dist_to_ocean
FROM max_dnstr_gradient_locations l
LEFT JOIN LATERAL
(
  SELECT 
    sum(length_metre) as distance_to_ocean
  FROM
    FWA_DownstreamTrace(l.blue_line_key, l.downstream_route_measure)
) s1 ON true;


ALTER TABLE obs_max_grade_dnstr_dist_to_ocean_50 ADD primary key (max_gradient_id);


DROP TABLE IF EXISTS obs_max_grade_dnstr_dist_to_ocean_25;

CREATE table obs_max_grade_dnstr_dist_to_ocean_25 AS
with max_dnstr_gradient_locations as (
SELECT DISTINCT
  a.max_gradient_id,
  gb.blue_line_key,
  gb.downstream_route_measure
FROM obs_max_grade_dnstr_25 a
INNER JOIN bcfishpass.gradient_barriers_25 gb
ON a.max_gradient_id = gb.gradient_barrier_id
)

SELECT
  max_gradient_id,
  coalesce(distance_to_ocean, 0) as max_grade_dnstr_dist_to_ocean
FROM max_dnstr_gradient_locations l
LEFT JOIN LATERAL
(
  SELECT 
    sum(length_metre) as distance_to_ocean
  FROM
    FWA_DownstreamTrace(l.blue_line_key, l.downstream_route_measure)
) s1 ON true;


ALTER TABLE obs_max_grade_dnstr_dist_to_ocean_25 ADD primary key (max_gradient_id);


-- summarize all the above to a single view
drop view if exists bcfishpass.observations_max_gradients_downstream_vw;
create view bcfishpass.observations_max_gradients_downstream_vw as
select
    o.observation_key,
    o.species_code,
    o.life_stage,
    CASE
      WHEN o.life_stage ilike '%ADULT%' then true
      WHEN o.life_stage ilike '%ADULT%' is false then false
      WHEN o.life_stage is null then NULL
    END AS adult,
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
LEFT OUTER JOIN obs_max_grade_dnstr_dist_to_ocean_25 do25 ON mg25.max_gradient_id = do25.max_gradient_id;
