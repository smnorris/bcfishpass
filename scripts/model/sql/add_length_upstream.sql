-- ensure column does not already exist in table
alter table bcfishpass.:src_table drop column if exists total_network_km;

-- create empty copy of table
drop table if exists bcfishpass.tmp;
create table bcfishpass.tmp (like bcfishpass.:src_table including all);

-- add new column
alter table bcfishpass.tmp add column total_network_km double precision DEFAULT 0;

-- populate new temp table with existing data plus total_network_km column
with upstr_length as
(
  select
  a.:src_id,
  coalesce(round((sum(st_length(s.geom)::numeric) / 1000), 2), 0) as total_network_km
  from bcfishpass.:src_table a
  left outer join bcfishpass.streams s
  on fwa_upstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    true,
    1
   )
  group by a.:src_id
)
insert into bcfishpass.tmp
select
  a.*,
  ul.total_network_km
from bcfishpass.:src_table a
inner join upstr_length ul on a.:src_id = ul.:src_id;

-- do the switcheroo
drop table bcfishpass.:src_table;
alter table bcfishpass.tmp rename to :src_table;