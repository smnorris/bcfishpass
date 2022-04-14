-- Create potential lateral habitat polygons
--  - FWA waterbodies
--  - mapped floodplains
--  - variable width stream buffers based on modelled access/habitat

-- load all features into a single table with 'code' category,
-- the raster processing script pulls out individual components as needed

drop table if exists bcfishpass.lateral_poly;

create table bcfishpass.lateral_poly (
  id serial primary key,
  code integer,
  geom geometry(multipolygon, 3005)
);

-- ----------------------------------------
-- STUDY AREA - class 0
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
select
  0 as code,
  st_multi(geom) as geom
from bcfishpass.lateral_studyarea;


-- ----------------------------------------
-- FWA WATERBODIES - class 1
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
select
  1 as code,
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_lakes_poly as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

insert into bcfishpass.lateral_poly (
  code,
  geom
)
select
  1 as code,
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_rivers_poly as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

insert into bcfishpass.lateral_poly (
  code,
  geom
)
select
  1 as code,
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_wetlands_poly as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);

insert into bcfishpass.lateral_poly (
  code,
  geom
)
select
  1 as code,
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_manmade_waterbodies_poly as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);


-- ----------------------------------------
-- FLOODPLAIN - class 2
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
select
  2 as code,
  case
    when ST_CoveredBy(wb.geom, sa.geom) then st_multi(wb.geom)
    else st_multi(st_intersection(wb.geom, sa.geom)) end as geom
from whse_basemapping.cwb_floodplains_bc_area_svw as wb
inner join bcfishpass.lateral_studyarea as sa
on st_intersects(wb.geom, sa.geom);


-- ----------------------------------------
-- CLASS 3, 60M STREAM BUFFER
-- SIDE CHANNEL, ORDER = 1, PARENT ORDER > 5, GRADIENT <= 1%
-- key streams - they are missed by spawn/rear model because they are side-channels,
-- but are likely to be key refugia
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
SELECT
  3 as code,
  st_multi((st_dump(st_union(st_buffer(s.geom, 60)))).geom) as geom
FROM bcfishpass.streams s
INNER JOIN bcfishpass.lateral_studyarea sa
ON st_intersects(s.geom, sa.geom)
INNER JOIN whse_basemapping.fwa_stream_order_parent p
ON s.blue_line_key = p.blue_line_key
WHERE
  s.edge_type in (1000,1100,2000,2300) and
  (
    s.access_model_ch_co_sk is not null or
    s.access_model_st is not null
  ) and
  p.stream_order_parent > 5 and
  s.gradient <= .01 and
  s.blue_line_key != s.watershed_key and
  s.stream_order = 1;

-- ----------------------------------------
-- CLASS 4, 30M STREAM BUFFER
-- ALL POTENTIAL SPAWN/REAR (OR ACCESSIBLE ORDER >= 7)
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
SELECT
  4 as code,
  st_multi((st_dump(st_union(st_buffer(s.geom, 30)))).geom) as geom
FROM bcfishpass.streams s
INNER JOIN bcfishpass.lateral_studyarea sa
ON st_intersects(s.geom, sa.geom)
INNER JOIN whse_basemapping.fwa_stream_order_parent p
ON s.blue_line_key = p.blue_line_key
WHERE
  (
    (
      access_model_st is not null or
      access_model_ch_co_sk is not null
    )
    and stream_order >= 7
  )
  or
  (
    spawning_model_ch is true or
    spawning_model_co is true or
    spawning_model_sk is true or
    spawning_model_st is true or
    rearing_model_ch is true or
    rearing_model_co is true or
    rearing_model_sk is true or
    rearing_model_st is true
  );

-- ----------------------------------------
-- CLASS 5, 20M STREAM BUFFER (PLUS CHANNEL WIDTH)
-- ALL <4% 'ACCESSIBLE' SINGLE LINE STREAMS
-- (not enough flow to be modelled as spawning/rearing habitat)
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
SELECT
  5 as code,
  st_multi((st_dump(st_union(st_buffer(s.geom, (s.channel_width + 20))))).geom) as geom
FROM bcfishpass.streams s
INNER JOIN bcfishpass.lateral_studyarea sa
ON st_intersects(s.geom, sa.geom)
WHERE
  edge_type in (1000,1100,2000,2300)
  and gradient < .04
  and
  (
    access_model_ch_co_sk is not null or
    access_model_st is not null
  );


-- above features are all 'potential lateral habitat',
-- below features are needed for connectivity analyis

-- ----------------------------------------
-- CLASS 6, 30m BUFFERS
-- GENERATE 'HABITAT' POLYGONS NOT UPSTREAM OF RAIL BARRIERS,
-- ie 'ACCESSIBLE' HABITAT (IGNORING ROAD BARRIERS), AREAS CONNECTED TO THESE
-- ARE NOT FRAGMENTED BY RAIL
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
with xings as
(
  select *
  from bcfishpass.crossings
  where
    crossing_feature_type = 'RAIL' and
    (access_model_ch_co_sk is not null or access_model_st is not null) and
    (
      barrier_status in ('BARRIER', 'POTENTIAL') -- typical barriers
      or crossing_type_code = 'CBS'              -- for floodplain connectivity, any CBS can be a barrier
    ) and
    blue_line_key = watershed_key                -- do not include barriers on side channels
)

select
  6 as code,
  -- raster generated by these polys is what gets cut by rail raster,
  -- use flat endcap to ensure that the cut is done properly
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
(s.access_model_st is not null OR s.access_model_ch_co_sk is not null)
and
(
  (
    s.spawning_model_ch is true or
    s.spawning_model_co is true or
    s.spawning_model_sk is true or
    s.spawning_model_st is true or
    s.rearing_model_ch is true or
    s.rearing_model_co is true or
    s.rearing_model_sk is true or
    s.rearing_model_st is true
  )
  or s.stream_order >= 7
)
and b.aggregated_crossings_id is null

-- Do not include streams above barriers in side channels
-- along bulkley river. These are not possible to model with existing
-- wscode based upstream/downstream FWA queries. A spatial recursive connectivity
-- query would likely do the job.
and s.segmented_stream_id not in
  ('360221853.179537',
    '360221853.427070'
    '360532191.0'
    '360532191.24216'
    '360648877.0',
    '360648877.16211',
    '360648877.173000',
    '360648877.665000',
    '360648877.697000'
  )
and s.blue_line_key not in (
  360869846,
  360840276,
  360237077,
  360236038,
  360222808,
  360235811,
  360746107
  )
and s.wscode_ltree <@ '400.431358.785328'::ltree is false;


-- ----------------------------------------
-- RAILWAY
-- 25m buffer for connectivity analysis
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
select
  7 as code,
  st_multi(st_buffer(geom, 25)) as geom
from whse_basemapping.gba_railway_tracks_sp;

-- ----------------------------------------
-- RAIL BRIDGES
-- for breaching the rail raster
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
select
  8 as code,
  st_multi(st_buffer(geom, 30)) as geom
from bcfishpass.crossings
where crossing_feature_type = 'RAIL'
and barrier_status NOT IN ('POTENTIAL','BARRIER')
and crossing_type_code != 'CBS';

-- ----------------------------------------
-- URBAN AREAS FROM BTM
-- ----------------------------------------
insert into bcfishpass.lateral_poly (
  code,
  geom
)
select
  9 as code,
  st_multi(geom) as geom
from whse_basemapping.btm_present_land_use_v1_svw
where present_land_use_label = 'Urban';