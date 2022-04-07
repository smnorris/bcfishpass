-- create a rough study area, a 1 km buffer of rail lines within Fraser and Skeena,
-- partitioned by bcgs 20k tiles

drop table if exists bcfishpass.lateral_studyarea;

create table bcfishpass.lateral_studyarea
(
  id serial primary key,
  map_tile text,
 geom geometry(multipolygon, 3005)
);

insert into bcfishpass.lateral_studyarea (map_tile, geom)

with buf as
(
  select
    st_makepolygon(
      st_exteriorring((st_dump(st_union(st_buffer(r.geom, 2000)))).geom)
      ) as geom
  from whse_basemapping.gba_railway_tracks_sp r
  inner join whse_basemapping.fwa_watershed_groups_poly wsg
  on st_intersects(r.geom, wsg.geom)
  where wsg.watershed_group_code in
  ('BBAR','BONP','BRID','BULK','CHWK','COTR','DEAD','DRIR','FRAN','FRCN','GRNL','HARR','KISP','KLUM','LCHL','LFRA','LILL','LKEL','LNIC','LNTH','LSAL','LSKE','LTRE','MIDR','MORK','MORR','MUSK','NARC','NECR','QUES','SAJR','SALR','SETN','SHUL','STHM','STUL','SUST','TABR','TAKL','THOM','TWAC','UFRA','UNTH','USHU','UTRE','WILL')
  and track_classification != 'Ferry Route'
)

select
  g.map_tile,
  ST_Multi(ST_Intersection(buf.geom, g.geom))AS geom
from buf
inner join whse_basemapping.bcgs_20k_grid g
on st_intersects(buf.geom, g.geom);

create index on bcfishpass.lateral_studyarea using gist (geom);