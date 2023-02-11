-- tidy lateral habitat (all) slightly (don't bother simplifying/buffering/clustering)
drop table if exists bcfishpass.habitat_lateral_clean;
create table bcfishpass.habitat_lateral_clean as
  select
    row_number() over() as id, 
    value,
    geom
  from bcfishpass.habitat_lateral
  where value != 0
  and st_area(geom) > 100;
create index on bcfishpass.habitat_lateral_clean using gist (geom);

-- tidy lateral habitat isolated by rail

-- simplify and buffer
drop table if exists bcfishpass.habitat_lateral_rail1;
create table bcfishpass.habitat_lateral_rail1 
  (geom geometry(multipolygon));

insert into bcfishpass.habitat_lateral_rail1
select
  st_multi(st_makevalid(
    st_buffer(
    st_simplify(
      st_buffer(
        st_makevalid(geom), 20),
      25),
    -15
  ))) as geom  
from bcfishpass.habitat_lateral_clean
where value = 2
and st_area(geom) > 100;
create index on bcfishpass.habitat_lateral_rail1 using gist (geom);


-- cluster features > 100m2 within 50m, then merge
drop table if exists bcfishpass.habitat_lateral_rail2;
create table bcfishpass.habitat_lateral_rail2 
(cid integer,
 geom geometry(multipolygon, 3005)
);

insert into bcfishpass.habitat_lateral_rail2
 select 
   cid, 
   st_multi(st_union(geom)) as geom 
 from
 (
  select
    st_clusterdbscan(
      st_makevalid(
        st_buffer(geom, 1)), 50, 1) over() as cid,
    geom
  from bcfishpass.habitat_lateral_rail1
  where st_area(geom) > 100
 ) as f
 group by cid;


-- retain clusters > 1000m2
drop table if exists bcfishpass.habitat_lateral_rail3;
create table bcfishpass.habitat_lateral_rail3 
(id serial primary key,
  wscode_ltree ltree,
  value integer,
 geom geometry(multipolygon, 3005)
);

insert into bcfishpass.habitat_lateral_rail3 (
  wscode_ltree, 
  value, 
  geom
)
select distinct on (a.geom)
  s.wscode_ltree,
  2 as value,
  st_multi(a.geom) as geom
from bcfishpass.habitat_lateral_rail2 a
left outer join bcfishpass.streams s
on st_intersects(a.geom, s.geom)
where st_area(a.geom) > 1000
order by a.geom, wscode_ltree asc;
create index on bcfishpass.habitat_lateral_rail3 using gist (geom);


drop table bcfishpass.habitat_lateral_rail1;
drop table bcfishpass.habitat_lateral_rail2;
drop table if exists habitat_lateral_disconnected_rail;
alter table bcfishpass.habitat_lateral_rail3 rename to habitat_lateral_disconnected_rail;