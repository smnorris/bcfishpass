-- create per species views

drop view if exists bcfishpass.map_pk_vw;

create view bcfishpass.map_pk_vw as
with status_codes as (
select 
  segmented_stream_id,
  case 
    -- migratory
    when 
      barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      model_spawning_pk is null
    then 'ACCESS' 
    -- potential spawning
    when model_spawning_pk is not null
    then 'SPAWN'
  end as habitat_status,
  case 
    when barriers_anthropogenic_dnstr is null then 'NONE'    -- no barriers dnstr
    when barriers_anthropogenic_dnstr is not null and   -- modelled barrier dnstr
      barriers_pscis_dnstr is null and
      barriers_dams_dnstr is null and 
      barriers_dams_hydro_dnstr is null then 'MODELLED'
    when barriers_anthropogenic_dnstr is not null and   -- pscis barrier dnstr
      barriers_pscis_dnstr is not null and
      barriers_dams_dnstr is null and 
      barriers_dams_hydro_dnstr is null then 'ASSESSED'
    when barriers_anthropogenic_dnstr is not null and   -- dam barrier dnstr
      barriers_dams_dnstr is not null and 
      barriers_dams_hydro_dnstr is null then 'DAM'
    when barriers_anthropogenic_dnstr is not null and   -- hydro dam barrier dnstr
      barriers_dams_hydro_dnstr is not null then 'HYDRO'
  end as anthropogenic_barrier_status,
  case 
    when feature_code = 'GA24850150' then 'INTERMITTENT' 
    else NULL
  end as intermittent_status
from bcfishpass.streams 
)

select
  a.segmented_stream_id,
  a.linear_feature_id,
  a.edge_type,
  a.blue_line_key,
  a.watershed_key,
  a.watershed_group_code,
  a.downstream_route_measure,
  a.length_metre,
  a.waterbody_key,
  a.wscode_ltree as wscode,
  a.localcode_ltree as localcode,
  a.gnis_name,
  a.stream_order,
  a.stream_magnitude,
  a.gradient,
  a.feature_code,
  a.upstream_route_measure,
  a.upstream_area_ha,
  cw.channel_width,
  mad.mad_m3s,
  a.stream_order_parent,
  a.stream_order_max,
  a.barriers_anthropogenic_dnstr,
  a.barriers_pscis_dnstr,
  a.barriers_dams_dnstr,
  a.barriers_dams_hydro_dnstr,
  a.barriers_ch_cm_co_pk_sk_dnstr,
  a.crossings_dnstr,
  a.obsrvtn_event_upstr,
  a.obsrvtn_species_codes_upstr,
  a.remediated_dnstr,
  a.model_spawning_ch,
  a.model_rearing_ch,
  a.model_spawning_cm,
  a.model_rearing_cm,
  a.model_spawning_co,
  a.model_rearing_co,
  a.model_spawning_pk,
  a.model_rearing_pk,
  a.model_spawning_sk,
  a.model_rearing_sk,
  array_to_string(array[b.habitat_status, b.anthropogenic_barrier_status, b.intermittent_status], ';') as map_symbol_code,
  a.geom
from bcfishpass.streams a
inner join status_codes b on a.segmented_stream_id = b.segmented_stream_id
left outer join bcfishpass.discharge mad on a.linear_feature_id = mad.linear_feature_id
left outer join bcfishpass.channel_width cw on a.linear_feature_id = cw.linear_feature_id
where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[];
