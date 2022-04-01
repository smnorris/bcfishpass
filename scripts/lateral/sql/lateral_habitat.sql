-- create rough study area, a 1 km buffer of rail lines within Fraser and Skeena,
-- partitioned by bcgs 20k tiles

drop table if exists bcfishpass.lat_study_area;

create table bcfishpass.lat_study_area
(
  id serial primary key,
  map_tile text,
 geom geometry(multipolygon, 3005)
);

insert into bcfishpass.lat_study_area (map_tile, geom)

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


-- cut FWA waterbody features to study area
-- call this "class 1" for now

-- rivers/lakes/wetlands/reservoirs
drop table if exists bcfishpass.lat_potential_habitat_1;

create table bcfishpass.lat_potential_habitat_1 (
  id serial primary key,
  habitat_class integer,
  geom geometry(multipolygon, 3005)
);

-- cut waterbodies to study area
-- LAKES
insert into bcfishpass.lat_potential_habitat_1 (
  habitat_class,
  geom
)
select
  1 as habitat_class,
  case
    when st_coveredby(wb.geom, sa.geom) then st_multi(wb.geom)
    else st_multi(st_intersection(wb.geom, sa.geom))
  end as geom
from whse_basemapping.fwa_lakes_poly as wb
inner join bcfishpass.lat_study_area as sa
on st_intersects(wb.geom, sa.geom);

-- RIVERS
insert into bcfishpass.lat_potential_habitat_1 (
  habitat_class,
  geom
)
select
  1 as habitat_class,
  case
    when st_coveredby(wb.geom, sa.geom) then st_multi(wb.geom)
    else st_multi(st_intersection(wb.geom, sa.geom))
  end as geom
from whse_basemapping.fwa_rivers_poly as wb
inner join bcfishpass.lat_study_area as sa
on st_intersects(wb.geom, sa.geom);

-- WETLANDS
insert into bcfishpass.lat_potential_habitat_1 (
  habitat_class,
  geom
)
select
  1 as habitat_class,
  case
    when ST_CoveredBy(wb.geom, sa.geom) then st_multi(wb.geom)
    else st_multi(st_intersection(wb.geom, sa.geom))
  end as geom
from whse_basemapping.fwa_wetlands_poly as wb
inner join bcfishpass.lat_study_area as sa
on st_intersects(wb.geom, sa.geom);

-- RESERVOIRS
insert into bcfishpass.lat_potential_habitat_1 (
  habitat_class,
  geom
)
select
  1 as habitat_class,
  case
    when st_coveredby(wb.geom, sa.geom) then st_multi(wb.geom)
    else st_multi(st_intersection(wb.geom, sa.geom))
  end as geom
from whse_basemapping.fwa_manmade_waterbodies_poly as wb
inner join bcfishpass.lat_study_area as sa
on st_intersects(wb.geom, sa.geom);


-- STREAMS (JUST A COPY OF LINEAR MODELLING)
drop table if exists bcfishpass.lat_streams;
create table bcfishpass.lat_streams as
select distinct
  segmented_stream_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  edge_type,
  waterbody_key,
  stream_order,
  stream_magnitude,
  gradient,
  access_model_ch_co_sk,
  spawning_model_ch,
  spawning_model_co,
  spawning_model_sk,
  spawning_model_st,
  rearing_model_ch,
  rearing_model_co,
  rearing_model_sk,
  rearing_model_st,
  case
    when st_coveredby(wb.geom, sa.geom) then st_multi(wb.geom)
    else st_multi(st_intersection(wb.geom, sa.geom))
  end as geom
from bcfishpass.streams as wb
inner join bcfishpass.lat_study_area as sa
on st_intersects(wb.geom, sa.geom);


drop table if exists bcfishpass.lat_potential_habitat_2;
create table bcfishpass.lat_potential_habitat_2 (
  id serial primary key,
  habitat_class integer,
  geom geometry(multipolygon, 3005)
);

-- buffer single line streams by 30m where slope is low and on modelled habitat
insert into bcfishpass.lat_potential_habitat_2 (
  habitat_class,
  geom
)
SELECT
  2 as habitat_class,
  st_multi((st_dump(st_union(st_buffer(s.geom, 30)))).geom) as geom
FROM bcfishpass.lat_streams s
inner join bcfishpass.channel_width cw
on s.linear_feature_id = cw.linear_feature_id
WHERE edge_type in (1000,1100,2000,2300)
and access_model_ch_co_sk is not null
and gradient < .07;

-- call floodplains class 3
drop table if exists bcfishpass.lat_potential_habitat_3;
create table bcfishpass.lat_potential_habitat_3 (
  id serial primary key,
  habitat_class integer,
  geom geometry(multipolygon, 3005)
);

insert into bcfishpass.lat_potential_habitat_3 (
  habitat_class, geom
)
select
  3 as habitat_class,
  case
    when ST_CoveredBy(wb.geom, sa.geom) then st_multi(wb.geom)
    else st_multi(st_intersection(wb.geom, sa.geom)) end as geom
from whse_basemapping.cwb_floodplains_bc_area_svw as wb
inner join bcfishpass.lat_study_area as sa
on st_intersects(wb.geom, sa.geom);