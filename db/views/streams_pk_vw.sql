drop view if exists bcfishpass.streams_pk_vw;
create or replace view bcfishpass.streams_pk_vw as
with obs as
(
 select
   segmented_stream_id,
   array_to_string(array_agg(spp), ';') as obsrvtn_species_codes_upstr
   from (
    select segmented_stream_id,
      unnest(obsrvtn_species_codes_upstr) as spp
    from bcfishpass.streams s
  ) as f
  where spp = 'PK'
  group by segmented_stream_id
)
select
  s.segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  wscode_ltree::text as wscode,
  localcode_ltree::text as localcode,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  map_upstream,
  channel_width,
  mad_m3s,
  stream_order_parent,
  stream_order_max,
  array_to_string(barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(crossings_dnstr, ';') as crossings_dnstr,
  o.obsrvtn_species_codes_upstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  model_spawning_pk as spawning,
  null as rearing,
  mapping_code_pk as mapping_code,
  geom
from bcfishpass.streams s
left outer join obs o on s.segmented_stream_id = o.segmented_stream_id
where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[];
