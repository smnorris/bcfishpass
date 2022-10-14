with all_barriers as
(
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
  from bcfishpass.barriers_gradient_20
  where watershed_group_code = :'wsg'

  union all

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
  from bcfishpass.barriers_gradient_25
  where watershed_group_code = :'wsg'

  union all

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
  from bcfishpass.barriers_gradient_30
  where watershed_group_code = :'wsg'

  union all

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
  from bcfishpass.barriers_falls
  where watershed_group_code = :'wsg'

  union all

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
  from bcfishpass.barriers_subsurfaceflow
  where watershed_group_code = :'wsg'
),

obs as
(
  select *
  from bcfishpass.observations
  where species_codes && array['WCT'] IS TRUE
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
  where o.species_codes is null

  union all

    -- include *all* user added features, even those below wct observations
  select
      b.barrier_type,
      b.barrier_name,
      b.linear_feature_id,
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.watershed_group_code,
      b.geom
  from bcfishpass.barriers_user_definite b
  where watershed_group_code = :'wsg'
)

insert into bcfishpass.barriers_wct
(
    barriers_wct_id,
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
where watershed_group_code = any(
            array(
              select watershed_group_code
              from bcfishpass.wsg_species_presence
              where wct is true
            )
          )
on conflict do nothing;