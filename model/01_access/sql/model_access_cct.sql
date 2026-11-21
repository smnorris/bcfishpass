-- Modified model_access_st.sql for Coastal Cutthroat Trout
with barriers as
(
  select
    barriers_gradient_id as barrier_id,
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
  from bcfishpass.barriers_gradient
  where watershed_group_code = :'wsg'
  and barrier_type in ('GRADIENT_20', 'GRADIENT_25', 'GRADIENT_30')
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
),
obs_upstr as
(
  select
    b.barrier_id,
    b.barrier_type,
    b.blue_line_key,
    b.downstream_route_measure,
    b.watershed_group_code,
    o.species_code as spp,
    o.observation_key as obs,
    o.observation_date as obs_dt
  from barriers b
  inner join bcfishpass.observations o
  on fwa_upstream(
        b.blue_line_key,
        b.downstream_route_measure,
        b.wscode_ltree,
        b.localcode_ltree,
        o.blue_line_key,
        o.downstream_route_measure,
        o.wscode,
        o.localcode,
        false,
        20   -- a large tolerance to discard observations at more or less the same location as the barrier (within 20m)
      )
  -- do not bother counting observations upstream of barriers that have been noted as barriers in the user control table
  left outer join bcfishpass.user_barriers_definite_control bc
  on b.blue_line_key = bc.blue_line_key and abs(b.downstream_route_measure - bc.downstream_route_measure) < 1
  where o.species_code in ('CT')
  and bc.barrier_ind is null
),
obs_upstr_n as
(
  select
    o.barrier_id,
    count(o.obs) as n_obs
  from obs_upstr o
  where o.spp in ('CT')
  group by o.barrier_id
),
barriers_filtered as (
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
  left outer join obs_upstr_n as o on b.barrier_id = o.barrier_id
  where watershed_group_code = any(
      array(
        select watershed_group_code
        from bcfishpass.wsg_species_presence
        where ct is true
      )
  )
  -- do not include gradient / falls / subsurface barriers with > 0 observations upstream
  -- but always include user added barriers
  and
    (o.n_obs is null or o.n_obs = 0)
)
insert into bcfishpass.barriers_st
(
    barriers_st_id,
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
select * from barriers_filtered
union all
select
    barriers_user_definite_id as barrier_load_id,
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
on conflict do nothing;