-- check steelhead barriers with ST observations and salmon observations
select
  b.barriers_st_id,
  b.barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code,
  count(*) as n_observations,
  array_agg(o.fish_observation_point_id) as fish_observation_point_id,
  array_agg(o.species_code) as species_codes,
  array_agg(o.observation_date) as observation_dates
from bcfishpass.barriers_st b
inner join bcfishpass.observations_vw o on
 fwa_upstream(
   b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode_ltree, o.localcode_ltree)
where o.species_code in ('CH','CM','CO','PK','SK','ST')
group by b.barriers_st_id,
  b.barrier_type,
  b.blue_line_key,
  b.downstream_route_measure,
  b.watershed_group_code
order by barriers_st_id;