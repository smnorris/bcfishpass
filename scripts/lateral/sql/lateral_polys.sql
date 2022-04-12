-- create potential habitat polygons
--  - FWA waterbodies
--  - variable FWA stream buffers, depending on gradient, channel width, parent order
--  - mapped floodplains

drop table if exists bcfishpass.lateral_poly;

create table bcfishpass.lateral_poly (
  id serial primary key,
  habitat_class integer,
  geom geometry(multipolygon, 3005)
);


-- rivers/lakes/wetlands/reservoirs - existing poly features are class 1
insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
select
  1 as habitat_class,
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_lakes_poly as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
select
  1 as habitat_class,
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_rivers_poly as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
select
  1 as habitat_class,
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_wetlands_poly as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
select
  1 as habitat_class,
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_manmade_waterbodies_poly as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

-- STREAM BUFFERS

-- buffer all <7% 'accessible' single line streams by channel width plus 20m
insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
SELECT
  2 as habitat_class,
  st_multi((st_dump(st_union(st_buffer(s.geom, (s.channel_width + 20))))).geom) as geom
FROM bcfishpass.streams s
INNER JOIN bcfishpass.lateral_studyarea sa
ON st_intersects(s.geom, sa.geom)
WHERE
  edge_type in (1000,1100,2000,2300)
  and gradient < .07
  and (access_model_ch_co_sk is not null or access_model_st is not null);

-- slightly larger buffer for modelled habitat
insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
SELECT
  2 as habitat_class,
  st_multi((st_dump(st_union(st_buffer(s.geom, 30)))).geom) as geom
FROM bcfishpass.streams s
INNER JOIN bcfishpass.lateral_studyarea sa
ON st_intersects(s.geom, sa.geom)
INNER JOIN whse_basemapping.fwa_stream_order_parent p
ON s.blue_line_key = p.blue_line_key
WHERE
  edge_type in (1000,1100,2000,2300)
  and (
    spawning_model_ch is true or
    spawning_model_co is true or
    spawning_model_sk is true or
    spawning_model_st is true or
    spawning_model_wct is true or
    rearing_model_ch is true or
    rearing_model_co is true or
    rearing_model_sk is true or
    rearing_model_st is true or
    rearing_model_wct is true
  )
and p.stream_order_parent <= 5;

-- bigger buffer again for very flat streams with parent order > 5
insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
SELECT
  2 as habitat_class,
  st_multi((st_dump(st_union(st_buffer(s.geom, 60)))).geom) as geom
FROM bcfishpass.streams s
INNER JOIN bcfishpass.lateral_studyarea sa
ON st_intersects(s.geom, sa.geom)
INNER JOIN whse_basemapping.fwa_stream_order_parent p
ON s.blue_line_key = p.blue_line_key
WHERE
  edge_type in (1000,1100,2000,2300)
  and (
    spawning_model_ch is true or
    spawning_model_co is true or
    spawning_model_sk is true or
    spawning_model_st is true or
    spawning_model_wct is true or
    rearing_model_ch is true or
    rearing_model_co is true or
    rearing_model_sk is true or
    rearing_model_st is true or
    rearing_model_wct is true
  )
 and p.stream_order_parent > 5
 and s.gradient <= .01;


-- call floodplains class 3
insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
select
  3 as habitat_class,
  case
    when ST_CoveredBy(wb.geom, sa.geom) then st_multi(wb.geom)
    else st_multi(st_intersection(wb.geom, sa.geom)) end as geom
from whse_basemapping.cwb_floodplains_bc_area_svw as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);


-- create 'habitat' polygons for connectivity analysis as class 4
insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
select
  4 as habitat_class,
  st_multi((st_dump(st_union(st_buffer(s.geom, 30)))).geom) as geom
from bcfishpass.streams s
inner join bcfishpass.lateral_studyarea sa
on st_intersects(s.geom, sa.geom)
where (
    spawning_model_ch is true or
    spawning_model_co is true or
    spawning_model_sk is true or
    spawning_model_st is true or
    spawning_model_wct is true or
    rearing_model_ch is true or
    rearing_model_co is true or
    rearing_model_sk is true or
    rearing_model_st is true or
    rearing_model_wct is true
  ) or (stream_order >= 7 AND (access_model_st LIKE '%ACCESSIBLE%' OR access_model_ch_co_sk like '%ACCESSIBLE%')) ;

-- create 'habitat' polygons that are not below rail barriers for connectivity analysis as class 5
insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
with xings as
(
  select *
  from bcfishpass.crossings
  where
    crossing_feature_type = 'RAIL'
    and barrier_status in ('BARRIER', 'POTENTIAL')
    and (access_model_ch_co_sk is not null or access_model_st is not null)
)

-- extract potential habitat streams with no *rail* barriers downstream
select
  5 as habitat_class,
  st_multi((st_dump(st_union(st_buffer(s.geom, 30, 'endcap=flat join=round')))).geom) as geom
from bcfishpass.streams s
inner join bcfishpass.lateral_studyarea sa
on st_intersects(s.geom, sa.geom)
left outer join xings b
on FWA_Downstream(
      s.blue_line_key,
      s.downstream_route_measure,
      s.wscode_ltree,
      s.localcode_ltree,
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      true,
      1
    )
where
(s.access_model_st LIKE '%ACCESSIBLE%' OR s.access_model_ch_co_sk like '%ACCESSIBLE%')
and ((
    s.spawning_model_ch is true or
    s.spawning_model_co is true or
    s.spawning_model_sk is true or
    s.spawning_model_st is true or
    s.spawning_model_wct is true or
    s.rearing_model_ch is true or
    s.rearing_model_co is true or
    s.rearing_model_sk is true or
    s.rearing_model_st is true or
    s.rearing_model_wct is true
  ) or s.stream_order >= 7
)
and b.aggregated_crossings_id is null;