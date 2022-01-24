delete from bcfishpass.barriers_ch_co_sk
where watershed_group_code = :'wsg';

with barriers as
(
  select
      barriers_majordams_id as barrier_id,
      barrier_type,
      barrier_name,
      linear_feature_id,
      blue_line_key,
      downstream_route_measure,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
  from bcfishpass.barriers_majordams
  where watershed_group_code = :'wsg'
  union all
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

obs_upstr as
(
  select
    b.barrier_id,
    b.barrier_type,
    b.blue_line_key,
    b.downstream_route_measure,
    b.watershed_group_code,
    unnest(o.species_codes) as spp,
    unnest(o.observation_ids) as obs,
    unnest(o.observation_dates) as obs_dt
  from barriers b
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
),

obs_upstr_n as
(
  select
    barrier_id,
    count(obs) as n_obs
  from obs_upstr
  group by barrier_id
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
      where ch is true or co is true or sk is true
    )
)
-- do not include gradient / falls / subsurface barriers with > 10 observations upstream
-- but always include major dams and other user added barriers
and (
    o.n_obs is null or
    o.n_obs < 10 or
    b.barrier_type in ('MAJOR DAM', 'EXCLUSION', 'PSCIS_NOT_ACCESSIBLE', 'MISC')
)
on conflict do nothing;