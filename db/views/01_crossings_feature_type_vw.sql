-- crossing feature type
drop view if exists bcfishpass.crossings_feature_type_vw;
create view bcfishpass.crossings_feature_type_vw as
select
  aggregated_crossings_id,
  case 
    when crossing_subtype_code = 'WEIR' then 'WEIR'
    when crossing_subtype_code = 'DAM' then 'DAM'
    -- RAIL, pscis crossings within 50m of rail line and with RAIL in the road name
    when 
      rail_owner_name is not null
      and aggregated_crossings_id in (
        select 
          aggregated_crossings_id
        from bcfishpass.crossings c
        inner join whse_basemapping.gba_railway_tracks_sp r
        on st_dwithin(c.geom, r.geom, 50)
        where crossing_source = 'PSCIS'
        and upper(pscis_road_name) like '%RAIL%' and upper(pscis_road_name) not like '%TRAIL%'
      ) 
    then 'RAIL'
    -- RAIL, pscis crossings within 10m of rail line
    when 
      rail_owner_name is not null
      and aggregated_crossings_id in (
        select 
          aggregated_crossings_id
        from bcfishpass.crossings c
        inner join whse_basemapping.gba_railway_tracks_sp r
        on st_dwithin(c.geom, r.geom, 10)
        where crossing_source = 'PSCIS'
      )
    then 'RAIL'
    -- modelled rail crossings
    when 
      rail_owner_name is not null
      and crossing_source = 'MODELLED CROSSINGS'
    then 'RAIL'
    -- tenured roads
    when 
      ften_forest_file_id is not NULL OR
      ogc_proponent is not NULL
    then 'ROAD, RESOURCE/OTHER'
    -- demographic roads
    when
      transport_line_type_description IN (
        'Road alleyway',
        'Road arterial major',
        'Road arterial minor',
        'Road collector major',
        'Road collector minor',
        'Road freeway',
        'Road highway major',
        'Road highway minor',
        'Road lane',
        'Road local',
        'Private driveway demographic',
        'Road pedestrian mall',
        'Road runway non-demographic',
        'Road recreation demographic',
        'Road ramp',
        'Road restricted',
        'Road strata',
        'Road service',
        'Road yield lane'
      )
    then 'ROAD, DEMOGRAPHIC'
    -- trails
    when
      upper(transport_line_type_description) LIKE 'TRAIL%'
    then 'TRAIL'
    -- everything else (DRA)
    when
      transport_line_type_description is not NULL
    then 'ROAD, RESOURCE/OTHER'
    -- in the absence of any of the above info, assume a PSCIS crossing is on a resource/other road    
    when 
      stream_crossing_id is not NULL
    then 'ROAD, RESOURCE/OTHER'
  end as crossing_feature_type
from bcfishpass.crossings;