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
  and barrier_type in ('GRADIENT_25', 'GRADIENT_30')

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

-- BT observations, plus salmon/steelhead
-- (any features passable by salmon/steehead should also be passable by BT)
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
  where o.species_code in ('BT','CH','CM','CO','PK','SK','ST')
),

obs_upstr_n as
(
  select
    o.barrier_id,
    count(o.obs) as n_obs
  from obs_upstr o
  where o.spp in ('BT','CH','CM','CO','PK','SK','ST')
  group by o.barrier_id
),

-- exclude barriers belown known spawning/rearing habitat
habitat as (
  select
    h.blue_line_key,
    h.upstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    h.watershed_group_code,
    h.species_code
  from bcfishpass.user_habitat_classification h
  inner join whse_basemapping.fwa_stream_networks_sp s
  ON s.blue_line_key = h.blue_line_key
  and round(h.upstream_route_measure::numeric) >= round(s.downstream_route_measure::numeric)
  and round(h.upstream_route_measure::numeric) <= round(s.upstream_route_measure::numeric)
  where h.habitat_ind is true
  and h.species_code in ('BT','CH','CM','CO','PK','SK','ST')
  and s.watershed_group_code = :'wsg'
),

hab_upstr as
(
  select
    b.barrier_id,
    array_agg(species_code) as species_codes
  from barriers b
  inner join habitat h
  on fwa_upstream(
        b.blue_line_key,
        b.downstream_route_measure,
        b.wscode_ltree,
        b.localcode_ltree,
        h.blue_line_key,
        h.upstream_route_measure,
        h.wscode_ltree,
        h.localcode_ltree,
        false,
        200       -- a large tolerance to discard habitat that ends at more or less the same location as the barrier
      )
  group by b.barrier_id
),


barriers_filtered as (
  select
    b.barrier_id,
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
  from barriers b
  left outer join obs_upstr_n as o on b.barrier_id = o.barrier_id
  left outer join hab_upstr h on b.barrier_id = h.barrier_id
  where watershed_group_code = any(
      array(
        select watershed_group_code
        from bcfishpass.wsg_species_presence
        where bt is true
      )
  )
  -- do not include barriers with
  --    - any BT (or salmon/steelhead) observation upstream
  --    - confirmed BT (or salmon/steelhead) habitat upstream
  and
        (
          (o.n_obs is null or o.n_obs < 1) and
          h.species_codes is null
        )
)

insert into bcfishpass.barriers_bt
(
    barriers_bt_id,
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
-- include *all* user added features, even those below observations
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