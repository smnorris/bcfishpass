-- reference CABD dams to FWA stream network

drop materialized view if exists bcfishpass.dams_vw cascade;

create materialized view bcfishpass.dams_vw as

with cabd as (
  select
    cabd_id as dam_id,
    st_transform(geom, 3005) as geom
  from cabd.dams
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
)

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
from usa;


create unique index on bcfishpass.dams_vw (dam_id);
create index on bcfishpass.dams_vw (linear_feature_id);
create index on bcfishpass.dams_vw (blue_line_key);
create index on bcfishpass.dams_vw (watershed_group_code);
create index on bcfishpass.dams_vw using gist (wscode_ltree);
create index on bcfishpass.dams_vw using btree (wscode_ltree);
create index on bcfishpass.dams_vw using gist (localcode_ltree);
create index on bcfishpass.dams_vw using btree (localcode_ltree);
create index on bcfishpass.dams_vw using gist (geom);

drop view if exists bcfishpass.dams_not_matched_to_streams;
create view bcfishpass.dams_not_matched_to_streams as
select
  a.cabd_id,
  a.dam_name_en
from cabd.dams a
left outer join bcfishpass.dams_vw b
on a.cabd_id::text = b.dam_id
where b.dam_id is null
order by a.cabd_id;