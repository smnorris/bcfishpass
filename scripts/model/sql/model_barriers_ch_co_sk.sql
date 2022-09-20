delete from bcfishpass.barriers_ch_co_sk
where watershed_group_code = :'wsg';

with barriers as
(
  select
      barriers_gradient_15_id as barrier_id,
      barrier_type,
      barrier_name,
      linear_feature_id,
      blue_line_key,
      downstream_route_measure,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
  from bcfishpass.barriers_gradient_15
  where watershed_group_code = :'wsg'
  union all
  select
      barriers_gradient_20_id as barrier_id,
      barrier_type,
      barrier_name,
      linear_feature_id,
      blue_line_key,
      downstream_route_measure,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
  from bcfishpass.barriers_gradient_20
  where watershed_group_code = :'wsg'
  union all
  select
      barriers_gradient_25_id as barrier_id,
      barrier_type,
      barrier_name,
      linear_feature_id,
      blue_line_key,
      downstream_route_measure,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
  from bcfishpass.barriers_gradient_25
  where watershed_group_code = :'wsg'
  union all
  select
      barriers_gradient_30_id as barrier_id,
      barrier_type,
      barrier_name,
      linear_feature_id,
      blue_line_key,
      downstream_route_measure,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
  from bcfishpass.barriers_gradient_30
  where watershed_group_code = :'wsg'
  union all
  select
      barriers_falls_id as barrier_id,
      barrier_type,
      barrier_name,
      linear_feature_id,
      blue_line_key,
      downstream_route_measure,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
  from bcfishpass.barriers_falls
  where watershed_group_code = :'wsg'
  union all
  select
      barriers_subsurfaceflow_id as barrier_id,
      barrier_type,
      barrier_name,
      linear_feature_id,
      blue_line_key,
      downstream_route_measure,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
  from bcfishpass.barriers_subsurfaceflow
  where watershed_group_code = :'wsg'
  union all
  select
      barriers_user_definite_id as barrier_id,
      barrier_type,
      barrier_name,
      linear_feature_id,
      blue_line_key,
      downstream_route_measure,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
  from bcfishpass.barriers_user_definite
  where watershed_group_code = :'wsg'
),

obs as 
(
select distinct
  o.fish_observation_point_id,
  e.blue_line_key,
  e.downstream_route_measure,
  e.wscode_ltree,
  e.localcode_ltree,
  e.species_code,
  e.observation_date
from (
   select 
    unnest(observation_ids) as fish_observation_point_id
   from bcfishpass.observations
 ) as o
inner join bcfishobs.fiss_fish_obsrvtn_events_sp e on o.fish_observation_point_id = e.fish_observation_point_id
where e.species_code in ('CH','CM','CO','PK','SK')
),

obs_upstr_n as
(
  select
    b.barrier_id,
    count(*) as n_obs
  from barriers b
  inner join obs o
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
)


insert into bcfishpass.barriers_ch_co_sk
(
    barriers_ch_co_sk_id,
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)

select
  b.barrier_id as barrier_load_id,
  barrier_type,
  barrier_name,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
from barriers b
left outer join obs_upstr_n as o
on b.barrier_id = o.barrier_id
where watershed_group_code = any(
    array(
      select watershed_group_code
      from bcfishpass.wsg_species_presence
      where ch is true or cm is true or co is true or pk is true or sk is true 
    )
)
-- do not include gradient / falls / subsurface barriers with > 10 observations upstream
-- but always include user added barriers
and (
    o.n_obs is null or
    o.n_obs < 10 or
    b.barrier_type in ('EXCLUSION', 'PSCIS_NOT_ACCESSIBLE', 'MISC')
)
on conflict do nothing;