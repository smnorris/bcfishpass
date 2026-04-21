-- create a trace from each sockeye observation downstream to the lake of interest
-- (but not including the network within the lake)

drop table if exists temp.sockeye_pts_lake_traces;

create table temp.sockeye_pts_lake_traces as
with trace as (
select
  o.observation_key,
  l.waterbody_key,
  f.waterbody_key as trace_wbkey,
  f.geom
from temp.sockeye_pts o
inner join temp.sockeye_pts_lakes_dnstr d on o.observation_key = d.observation_key
inner join temp.sockeye_lakes l on d.features_dnstr[1] = l.waterbody_key::text
join lateral   
  fwa_networktrace(
    o.blue_line_key,
    o.downstream_route_measure,
    l.blue_line_key,
    l.downstream_route_measure
  ) as f on true
)

select 
  observation_key,
  waterbody_key,
  st_force2d(st_multi(st_union(st_linemerge(geom))))::geometry(Multilinestring) as geom
from trace
where waterbody_key != coalesce(trace_wbkey, 0)
group by observation_key, waterbody_key;