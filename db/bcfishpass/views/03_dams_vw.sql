-- reference CABD dams to FWA stream network
create materialized view bcfishpass.dams_vw as
with cabd as (
  select
    d.cabd_id as dam_id,
    st_transform(d.geom, 3005) as geom
  from cabd.dams d
  -- exclude any dam noted in user exclusion table
  left outer join bcfishpass.user_cabd_dams_exclusions x on d.cabd_id = x.cabd_id
  where x.cabd_id is null
),

nearest AS
(
  select
    pt.dam_id,
    str.linear_feature_id,
    str.blue_line_key,
    str.wscode_ltree,
    str.localcode_ltree,
    str.watershed_group_code,
    str.geom,
    st_distance(str.geom, pt.geom) as distance_to_stream,
    st_interpolatepoint(str.geom, pt.geom) as downstream_route_measure
  from cabd pt
  cross join lateral (
    select
      linear_feature_id,
      blue_line_key,
      wscode_ltree,
      localcode_ltree,
      watershed_group_code,
      geom
    from whse_basemapping.fwa_stream_networks_sp str
    where str.localcode_ltree is not null
    and not str.wscode_ltree <@ '999'
    order by str.geom <-> pt.geom
    limit 1
  ) as str
  where st_distance(str.geom, pt.geom) <= 65
),

  -- ensure only one feature returned, and interpolate the geom on the stream
cabd_pts as
(
  select distinct on (n.dam_id)
    n.dam_id,
    n.linear_feature_id,
    n.blue_line_key,
    n.downstream_route_measure,
    n.wscode_ltree,
    n.localcode_ltree,
    n.distance_to_stream,
    n.watershed_group_code,
    cabd.dam_name_en,
    cabd.height_m,
    cabd.owner,
    cabd.dam_use,
    cabd.operating_status,
    cabd.passability_status_code,

    ((st_dump(ST_Force2D(st_locatealong(n.geom, n.downstream_route_measure)))).geom)::geometry(Point, 3005) AS geom
  FROM nearest n
  inner join cabd.dams cabd on n.dam_id = cabd.cabd_id
  order by dam_id, distance_to_stream
),

-- placeholders for major USA dams not present in CABD are stored in user_barriers_anthropogenic
usa as 
(
  select
    (a.user_barrier_anthropogenic_id + 1200000000)::text as dam_id,
    s.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    0 as distance_to_stream,
    s.watershed_group_code,
    a.barrier_name,
    st_force2d((st_dump(st_locatealong(s.geom, a.downstream_route_measure))).geom) as geom
  from bcfishpass.user_barriers_anthropogenic a
  inner join whse_basemapping.fwa_stream_networks_sp s
  on a.blue_line_key = s.blue_line_key
  AND ROUND(a.downstream_route_measure::numeric) >= ROUND(s.downstream_route_measure::numeric)
  AND ROUND(a.downstream_route_measure::numeric) < ROUND(s.upstream_route_measure::numeric)
  where a.barrier_type = 'DAM'
),

dams as (
  select * from cabd_pts
  union all
  select
    dam_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    barrier_name as dam_name_en,
    null as height_m,
    null as owner,
    null as dam_use,
    null as operating_status,
    null as passability_status_code,
    geom
  from usa
),

upstr_sal as (
  select
    d.dam_id,
    count(*) as n_sal
  from dams d
  inner join bcfishpass.observations_vw o
  on fwa_upstream(
        d.blue_line_key,
        d.downstream_route_measure,
        d.wscode_ltree,
        d.localcode_ltree,
        o.blue_line_key,
        o.downstream_route_measure,
        o.wscode_ltree,
        o.localcode_ltree,
        false,
        1
      )
  where o.species_code in ('CH','CM','CO','PK','SK')
  and o.observation_date > date('1990-01-01')
  group by d.dam_id
),

upstr_st as (
  select
    d.dam_id,
    count(*) as n_st
  from dams d
  inner join bcfishpass.observations_vw o
  on fwa_upstream(
        d.blue_line_key,
        d.downstream_route_measure,
        d.wscode_ltree,
        d.localcode_ltree,
        o.blue_line_key,
        o.downstream_route_measure,
        o.wscode_ltree,
        o.localcode_ltree,
        false,
        1
      )
  where o.species_code = 'ST'
  and o.observation_date > date('1990-01-01')
  group by d.dam_id
)

select
  d.dam_id,
  d.linear_feature_id,
  d.blue_line_key,
  d.downstream_route_measure,
  d.wscode_ltree,
  d.localcode_ltree,
  d.distance_to_stream,
  d.watershed_group_code,
  d.dam_name_en,
  d.height_m,
  d.owner,
  d.dam_use,
  d.operating_status,
  d.passability_status_code,
  s1.n_sal as n_obs_salmon_since_1990,
  s2.n_st as n_obs_steelhead_since_1990,
  d.geom
from dams d
left outer join upstr_sal s1 on d.dam_id = s1.dam_id
left outer join upstr_st s2 on d.dam_id = s2.dam_id;

create unique index on bcfishpass.dams_vw (dam_id);
create index on bcfishpass.dams_vw using gist (geom);


-- note dams not matched to streams
create view bcfishpass.dams_not_matched_to_streams as
select
  a.cabd_id,
  a.dam_name_en
from cabd.dams a
left outer join bcfishpass.dams_vw b
on a.cabd_id::text = b.dam_id
where b.dam_id is null
order by a.cabd_id;
