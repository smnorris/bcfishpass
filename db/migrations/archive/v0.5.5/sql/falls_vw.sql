-- To serve falls via pgfs, recreate falls materialized view with geometry cast to geometry(Point, 3005)
-- This requires dropping and re-creating the dependent views

drop view bcfishpass.falls_not_matched_to_streams;
drop materialized view bcfishpass.falls_upstr_anadromous_vw;
drop materialized view bcfishpass.falls_vw;


create materialized view bcfishpass.falls_vw as

with cabd as (
  select
    w.cabd_id as falls_id,
    x.blue_line_key,
    st_transform(w.geom, 3005) as geom
  from cabd.waterfalls w
  left outer join bcfishpass.user_cabd_blkey_xref x on w.cabd_id = x.cabd_id
),

matched AS
(
  select
    pt.falls_id,
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
  where
    st_distance(str.geom, pt.geom) <= 65 and
    pt.blue_line_key is null

  union all

  select distinct on (falls_id) -- distinct on in case two segments are equidistant
    pt.falls_id,
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
    where pt.blue_line_key = str.blue_line_key
    and pt.blue_line_key is not null
    and str.localcode_ltree is not null
    and not str.wscode_ltree <@ '999'
    order by str.geom <-> pt.geom
    limit 1
  ) as str
  order by falls_id, distance_to_stream
),

cabd_pts as (
  select distinct on (n.falls_id)
    n.falls_id,
    n.linear_feature_id,
    n.blue_line_key,
    n.downstream_route_measure,
    n.wscode_ltree,
    n.localcode_ltree,
    n.distance_to_stream,
    n.watershed_group_code,
    cabd.fall_name_en as falls_name,
    cabd.fall_height_m as height_m,
    case
      when cabd.passability_status = 'Barrier' then true
      else false
    end as barrier_ind,
    ((st_dump(ST_Force2D(st_locatealong(n.geom, n.downstream_route_measure)))).geom)::geometry(Point, 3005) AS geom
  FROM matched n
  inner join cabd.waterfalls cabd on n.falls_id = cabd.cabd_id
  order by falls_id, distance_to_stream
)

select * from cabd_pts
union all
select
  ((((p.blue_line_key::bigint + 1) - 354087611) * 10000000) + round(p.downstream_route_measure::bigint))::text as falls_id,
  s.linear_feature_id,
  p.blue_line_key,
  p.downstream_route_measure,
  s.wscode_ltree,
  s.localcode_ltree,
  0 as distance_to_stream,
  p.watershed_group_code,
  p.falls_name as falls_name,
  p.height as height_m,
  p.barrier_ind,
  (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, p.downstream_route_measure)))).geom::geometry(Point, 3005) as geom
from bcfishpass.user_falls p
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON p.blue_line_key = s.blue_line_key AND
p.downstream_route_measure > s.downstream_route_measure - .001 AND
p.downstream_route_measure + .001 < s.upstream_route_measure;

create unique index on bcfishpass.falls_vw (falls_id);
create index on bcfishpass.falls_vw using gist (geom);

-- a view of falls that do not get matched to streams
create view bcfishpass.falls_not_matched_to_streams as
select
  a.cabd_id,
  a.fall_name_en
from cabd.waterfalls a
left outer join bcfishpass.falls_vw b
on a.cabd_id::text = b.falls_id
where b.falls_id is null
order by a.cabd_id;


-- a view of all falls, with counts of observations upstream, for salmon and steelhead
create materialized view bcfishpass.falls_upstr_anadromous_vw as
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
        1
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
        1
      )
  where o.species_code = 'ST'
  and o.observation_date > date('1990-01-01')
  group by f.falls_id
)

select
 f.falls_id,
 s1.n_sal as n_obs_salmon_since_1990,
 s2.n_st as n_obs_steelhead_since_1990
from bcfishpass.falls_vw f
left outer join upstr_sal s1 on f.falls_id = s1.falls_id
left outer join upstr_st s2 on f.falls_id = s2.falls_id;
