-- note pscis crossings that we do not include in bcfishpass.pscis* and
-- bcfishpass.crossings - not matched to streams
drop table if exists bcfishpass.pscis_not_matched_to_streams;
create table bcfishpass.pscis_not_matched_to_streams (
  stream_crossing_id integer primary key,
  current_pscis_status text,
  current_barrier_result_code text,
  current_crossing_type_code text,
  current_crossing_subtype_code text,
  watershed_group_code text,
  geom geometry(point)
 );

create index on bcfishpass.pscis_not_matched_to_streams using gist (geom);


insert into bcfishpass.pscis_not_matched_to_streams (
  stream_crossing_id,
  current_pscis_status,
  current_barrier_result_code,
  current_crossing_type_code,
  current_crossing_subtype_code,
  watershed_group_code,
  geom
)
select
    a.stream_crossing_id,
    a.current_pscis_status,
    a.current_barrier_result_code,
    a.current_crossing_type_code,
    a.current_crossing_subtype_code,
    case
      when a.stream_crossing_id = 8261 then 'SALM' -- hopefully we don't get any more in the ocean and outside of all watershed groups
      else w.watershed_group_code
    end as watershed_group_code,
    --st_makepoint(st_x(a.geom), st_y(a.geom), round(b.elevation::numeric)) as geom
   a.geom
from bcfishpass.pscis_points_all a
LEFT OUTER JOIN bcfishpass.pscis b
ON a.stream_crossing_id = b.stream_crossing_id
left outer join whse_basemapping.fwa_watershed_groups_poly w
on st_intersects(a.geom, w.geom)
WHERE b.stream_crossing_id IS NULL;

-- drop intermediate table
-- drop table bcfishpass.pscis_not_matched_to_streams_elevation;