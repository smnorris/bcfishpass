drop table if exists bcfishpass.lateral_sources;
create table bcfishpass.lateral_sources ( 
  id serial primary key, 
  code text, 
  geom geometry(multipolygon, 3005)
);
    
-- ----------------------------------------
-- studyarea
-- watershed group of interest
-- ----------------------------------------
insert into bcfishpass.lateral_sources (code, geom)
select 
  'study_area', 
  geom 
from whse_basemapping.fwa_watershed_groups_poly wsg
where wsg.watershed_group_code = :wsg;
                

-- ----------------------------------------
-- floodplain
-- cwb floodplain
-- ----------------------------------------
insert into bcfishpass.lateral_sources (code, geom)    
select
  'floodplain',
  case
    when ST_CoveredBy(a.geom, wsg.geom) then st_multi(a.geom)
    else st_multi(st_intersection(a.geom, wsg.geom)) end as geom
from whse_basemapping.cwb_floodplains_bc_area_svw a
inner join whse_basemapping.fwa_watershed_groups_poly wsg
on st_intersects(a.geom, wsg.geom)
where wsg.watershed_group_code = :wsg;
    

-- ----------------------------------------
-- waterbodies
-- lakes/rivers/wetlands/reservoirs buffered by 30m
-- ----------------------------------------
insert into bcfishpass.lateral_sources (code, geom)    
select
  'waterbodies',
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_lakes_poly as wb
where watershed_group_code = :wsg
union all
select
  'waterbodies',
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_rivers_poly as wb
where watershed_group_code = :wsg
union all
select
  'waterbodies',
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_wetlands_poly as wb
where watershed_group_code = :wsg
union all
select
  'waterbodies',
  st_multi(st_buffer(wb.geom, 30)) as geom
from whse_basemapping.fwa_manmade_waterbodies_poly as wb
where watershed_group_code = :wsg;
    
    
-- ----------------------------------------
-- sidechannels
-- 1st order side channels on major systems, buffered by 60m
-- ----------------------------------------    
insert into bcfishpass.lateral_sources (code, geom)    
select
  'sidechannels',
   st_multi((st_dump(st_union(st_buffer(s.geom, 60)))).geom) as geom
from bcfishpass.streams s
where
  s.watershed_group_code = :wsg and
  s.edge_type in (1000,1100,2000,2300) and
  (
    s.barriers_ch_cm_co_pk_sk_dnstr is null or
    s.barriers_st_dnstr is null
  ) and
  s.stream_order_parent > 5 and
  s.gradient <= .01 and
  s.blue_line_key != s.watershed_key and
  s.stream_order = 1;
    

-- ----------------------------------------
-- spawning_rearing
-- streams modelled as potential spawn/rear, buffered by 30m
-- ----------------------------------------   
insert into bcfishpass.lateral_sources (code, geom)    
select
  'spawning_rearing',
  st_multi((st_dump(st_union(st_buffer(s.geom, 30)))).geom) as geom
from bcfishpass.streams s
where
s.watershed_group_code = :wsg and
 (
  (
    (
      barriers_st_dnstr is null or
      barriers_ch_cm_co_pk_sk_dnstr is null
    )
    and stream_order >= 7
  )
  or
  (
    (
    model_spawning_ch is true or
    model_spawning_co is true or
    model_spawning_sk is true or
    model_spawning_st is true or
    model_spawning_pk is true or
    model_spawning_cm is true or
    model_rearing_ch is true or
    model_rearing_co is true or
    model_rearing_sk is true or
    model_rearing_st is true
    )
    and
    (
      stream_order >= 3 or
      stream_order_parent >= 5
    )
  )
);


-- ----------------------------------------
-- accessible
-- all accessible/potentially accessible streams buffered by 20m plus channel width
-- ----------------------------------------
insert into bcfishpass.lateral_sources (code, geom)    
select
  'accessible',
  st_multi(
    (st_dump(
      st_union(
        st_buffer(s.geom, coalesce(s.channel_width, 0) + 20)
      )
    )).geom
  ) as geom
from bcfishpass.streams s
where
  watershed_group_code = :wsg and
  edge_type in (1000,1100,2000,2300) and
  (
    barriers_ch_cm_co_pk_sk_dnstr is null or
    barriers_st_dnstr is null
  );

-- ----------------------------------------
-- rail
-- rail lines buffered by 30m
-- ----------------------------------------
insert into bcfishpass.lateral_sources (code, geom)    
select
  'rail',
  st_multi(st_buffer(r.geom, 25)) as geom
from whse_basemapping.gba_railway_tracks_sp r
inner join whse_basemapping.fwa_watershed_groups_poly wsg
on st_intersects(r.geom, wsg.geom)
where wsg.watershed_group_code = :wsg;
    
    
-- ----------------------------------------
-- rail_bridges
-- buffered by 30m for breaching rail raster
-- ----------------------------------------
insert into bcfishpass.lateral_sources (code, geom)    
select
  'rail_bridges',
  st_multi(st_buffer(geom, 30)) as geom
from bcfishpass.crossings
where crossing_feature_type = 'RAIL'
and barrier_status NOT IN ('POTENTIAL','BARRIER')
and crossing_type_code != 'CBS'
and watershed_group_code = :wsg;


-- ----------------------------------------
-- accessible_below_rail
-- accessible streams below railways
-- ----------------------------------------
with xings as
(
  select *
  from bcfishpass.crossings
  where
    crossing_feature_type = 'RAIL' and
    (barriers_ch_cm_co_pk_sk_dnstr is null or barriers_st_dnstr is null) and
    (
      barrier_status in ('BARRIER', 'POTENTIAL') -- typical barriers
      or crossing_type_code = 'CBS'              -- for floodplain connectivity, any CBS can be a barrier
    ) and
    blue_line_key = watershed_key                -- do not include barriers on side channels
)

insert into bcfishpass.lateral_sources (code, geom)    
select
  'accessible_below_rail',
  -- raster generated by these polys is what gets cut by rail raster,
  -- use flat endcap to ensure that the cut is done properly
  st_multi((st_dump(st_union(st_buffer(s.geom, 30, 'endcap=flat join=round')))).geom) as geom
from bcfishpass.streams s
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
s.watershed_group_code = :wsg and
(s.barriers_st_dnstr is not null OR s.barriers_ch_cm_co_pk_sk_dnstr is not null)
--and
--(
--  (
--    s.model_spawning_ch is true or
--    s.model_spawning_co is true or
--    s.model_spawning_sk is true or
--    s.model_spawning_st is true or
--    s.model_spawning_pk is true or
--    s.model_spawning_cm is true or
--    s.model_rearing_ch is true or
--    s.model_rearing_co is true or
--    s.model_rearing_sk is true or
--    s.model_rearing_st is true
--  )
--  or s.stream_order >= 7
--)
and b.aggregated_crossings_id is null

-- Do not include streams above barriers in side channels
-- along bulkley river. These are not possible to model with existing
-- wscode based upstream/downstream FWA queries. A spatial recursive connectivity
-- query would likely do the job.
and s.segmented_stream_id not in
  ('360221853.179537',
    '360221853.427070',
    '360532191.0',
    '360532191.24216',
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