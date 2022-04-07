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

-- LAKES
insert into bcfishpass.lateral_poly (
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
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

-- RIVERS
insert into bcfishpass.lateral_poly (
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
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

-- WETLANDS
insert into bcfishpass.lateral_poly (
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
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

-- RESERVOIRS
insert into bcfishpass.lateral_poly (
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
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

-- STREAM BUFFERS

-- buffer all <7% 'accessible' single line streams by channel width plus 30m
insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
SELECT
  2 as habitat_class,
  st_multi((st_dump(st_union(st_buffer(s.geom, (s.channel_width + 30))))).geom) as geom
FROM bcfishpass.streams s
INNER JOIN bcfishpass.lateral_studyarea sa
ON st_intersects(s.geom, sa.geom)
WHERE
  edge_type in (1000,1100,2000,2300)
  and gradient < .07
  and (access_model_ch_co_sk is not null or access_model_st is not null);

-- double buffer width for modelled potential rearing/spawning habitat (60m)
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
and p.stream_order_parent <= 4;

-- Double width again (120m) where parent stream order is large (5th and greater)
-- (this will get cut down by the slope / valley confienment modelling but we
-- want to be sure these areas are included)
insert into bcfishpass.lateral_poly (
  habitat_class,
  geom
)
SELECT
  2 as habitat_class,
  st_multi((st_dump(st_union(st_buffer(s.geom, 120)))).geom) as geom
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
 and p.stream_order_parent > 4;


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