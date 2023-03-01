-- CCIRA specific resident species model

with all_barriers as
(
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
),

-- exclude barriers belown known observations and known spawning/rearing habitat 
obs as
(
  select *
  from bcfishpass.observations
  -- include bt as equivalent to dv for this model
  where species_codes && array['BT','DV','CT','RB'] is true
),

-- known habitat to any species will be accessible to these species.
habitat as (
  select 
    s.blue_line_key, 
    s.downstream_route_measure, 
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    h.species_code
  from bcfishpass.user_habitat_classification h
  inner join whse_basemapping.fwa_stream_networks_sp s
  ON s.blue_line_key = h.blue_line_key
  and round(s.downstream_route_measure::numeric) >= round(h.downstream_route_measure::numeric)
  and round(s.upstream_route_measure::numeric) <= round(h.upstream_route_measure::numeric)
  where h.habitat_ind is true
  and s.watershed_group_code = :'wsg'
),

hab_upstr as
(
  select
    b.barrier_id,
    array_agg(h.species_code) as species_codes
  from all_barriers b
  inner join habitat h
  on fwa_upstream(
        b.blue_line_key,
        b.downstream_route_measure,
        b.wscode_ltree,
        b.localcode_ltree,
        h.blue_line_key,
        h.downstream_route_measure,
        h.wscode_ltree,
        h.localcode_ltree,
        false,
        1
      )
  group by b.barrier_id
),

barriers as
(
  select distinct
    b.barrier_type,
    b.barrier_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.geom
  from all_barriers b
  left outer join obs o
  on fwa_upstream(
        b.blue_line_key,
        b.downstream_route_measure,
        b.wscode_ltree,
        b.localcode_ltree,
        o.blue_line_key,
        o.downstream_route_measure,
        o.wscode_ltree,
        o.localcode_ltree,
        False,
        1
      )
  left outer join hab_upstr h on b.barrier_id = h.barrier_id
  where o.species_codes is null
  and h.species_codes is null
  
  union all

    -- include *all* user added features, even those below bt observations
  select
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
)

insert into bcfishpass.barriers_dv_ct_rb
(
    barriers_dv_ct_rb_id,
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
-- add a primary key guaranteed to be unique provincially (presuming unique blkey/measure values within 1m)
select
  (((blue_line_key::bigint + 1) - 354087611) * 10000000) + round(downstream_route_measure::bigint) as barrier_load_id,
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
-- include only ccira watershed groups
where watershed_group_code in 
('ATNA','BELA','KHTZ','KITL','KLIN','KTSU','LDEN','LRDO','NASC','NECL','NIEL','OWIK','UEUT') 
on conflict do nothing;