-- a view of all falls, with counts of observations upstream, for salmon and steelhead
--drop materialized view bcfishpass.falls_upstr_anadromous_vw;
--create materialized view bcfishpass.falls_upstr_observations_vw as

with upstr_sal as (
  select
    f.falls_id,
    count(*) as n_sal
  from bcfishpass.falls_vw f
  inner join bcfishpass.observations_vw o
  on fwa_upstream(
        f.blue_line_key,
        f.downstream_route_measure,
        f.wscode_ltree,
        f.localcode_ltree,
        o.blue_line_key,
        o.downstream_route_measure,
        o.wscode_ltree,
        o.localcode_ltree,
        false,
        20
      )
  where o.species_code in ('CH','CM','CO','PK','SK')
  and o.observation_date > date('1990-01-01')
  group by f.falls_id
),

upstr_st as (
  select
    f.falls_id,
    count(*) as n_st
  from bcfishpass.falls_vw f
  inner join bcfishpass.observations_vw o
  on fwa_upstream(
        f.blue_line_key,
        f.downstream_route_measure,
        f.wscode_ltree,
        f.localcode_ltree,
        o.blue_line_key,
        o.downstream_route_measure,
        o.wscode_ltree,
        o.localcode_ltree,
        false,
        20
      )
  where o.species_code = 'ST'
  and o.observation_date > date('1990-01-01')
  group by f.falls_id
),

upstr_bt as (
  select
    f.falls_id,
    count(*) as n_bt
  from bcfishpass.falls_vw f
  inner join bcfishpass.observations_vw o
  on fwa_upstream(
        f.blue_line_key,
        f.downstream_route_measure,
        f.wscode_ltree,
        f.localcode_ltree,
        o.blue_line_key,
        o.downstream_route_measure,
        o.wscode_ltree,
        o.localcode_ltree,
        false,
        20
      )
  where o.species_code = 'BT'
  and o.observation_date > date('1990-01-01')
  group by f.falls_id
),

counts as (
select
 f.falls_id,
 f.falls_name,
 f.height_m,
 f.barrier_ind,
 coalesce(salmon.n_sal, 0) as n_obs_salmon_since_1990,
 coalesce(st.n_st, 0) as n_obs_steelhead_since_1990,
 coalesce(bt.n_bt, 0) as n_obs_bulltrout_since_1990
from bcfishpass.falls_vw f
left outer join upstr_sal salmon on f.falls_id = salmon.falls_id
left outer join upstr_st st on f.falls_id = st.falls_id
left outer join upstr_bt bt on f.falls_id = bt.falls_id
where f.barrier_ind is true
)

select *
from counts
where
n_obs_salmon_since_1990 > 0 or
n_obs_steelhead_since_1990 > 0 or
n_obs_bulltrout_since_1990 > 0;