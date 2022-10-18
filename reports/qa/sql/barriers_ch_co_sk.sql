with obs_upstr as
(
  select
    b.barriers_ch_co_sk_id as barrier_id,
    b.barrier_type,
    b.blue_line_key,
    b.downstream_route_measure,
    b.watershed_group_code,
    unnest(o.species_codes) as spp,
    unnest(o.observation_ids) as obs,
    unnest(o.observation_dates) as obs_dt
  from bcfishpass.barriers_ch_co_sk b
  inner join bcfishpass.observations o
  on fwa_upstream(
        b.blue_line_key,
        b.downstream_route_measure,
        b.wscode_ltree,
        b.localcode_ltree,
        o.blue_line_key,
        o.downstream_route_measure,
        o.wscode_ltree,
        o.localcode_ltree,
        false,
        1
      )
    and b.watershed_group_code = o.watershed_group_code
  where o.species_codes && array['CH','CO','SK']
)

select
  barrier_id,
  barrier_type,
  blue_line_key,
  downstream_route_measure,
  watershed_group_code,
  count(obs) as n_observations,
  array_agg(obs) as observation_ids,
  array_agg(spp) as species_codes,
  array_agg(obs_dt) as observation_dates
from obs_upstr
group by
  barrier_id,
  barrier_type,
  blue_line_key,
  downstream_route_measure,
  watershed_group_code
order by count(obs) desc;