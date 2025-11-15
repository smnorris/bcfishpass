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
  and barrier_type >= 'GRADIENT_40'
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
      barriers_elevation_id as barrier_id,
      barrier_type,
      barrier_name,
      linear_feature_id,
      blue_line_key,
      downstream_route_measure,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
  from bcfishpass.barriers_elevation
  where watershed_group_code = :'wsg'
  and barrier_type >= 'ELEVATION_1500'
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
  where o.species_code = 'SK'
  and bc.barrier_ind is null
),

obs_upstr_n as
(
  select
    o.barrier_id,
    count(o.obs) as n_obs
  from obs_upstr o
  where o.spp = 'SK'
  and o.obs_dt > date('1990-01-01')         -- only observations since 1990
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
  and h.species_code = 'SK'
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
        200       -- a v large tolerance to discard habitat that ends at more or less the same location as the barrier
      )
  group by b.barrier_id
),

barriers_filtered as (
  select
    b.barrier_id as barrier_load_id,
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
        where sk is true
      )
  )
  -- do not include gradient / falls / subsurface barriers with
  --    - > 5 observations upstream
  --    - confirmed habitat upstream
  and
        (
          -- (o.n_obs is null or o.n_obs < 5) and -- ** excluded for testing of different gradients
          h.species_codes is null
        )
)

insert into bcfishpass.barriers_sk
(
    barriers_sk_id,
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