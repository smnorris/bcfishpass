drop view if exists bcfishpass.streams_wct_vw cascade;

create view bcfishpass.streams_wct_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree::text as wscode,
  s.localcode_ltree::text as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  s.stream_order_parent,
  s.stream_order_max,
  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.obsrvtn_upstr_wct,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  h.spawning_wct as spawning,
  h.rearing_wct as rearing,
  hk.spawning_wct as spawning_known,
  hk.rearing_wct as rearing_known,
  m.mapping_code_wct as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear_vw h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code_vw m on s.segmented_stream_id = m.segmented_stream_id
left outer join bcfishpass.streams_habitat_known_vw hk on s.segmented_stream_id = hk.segmented_stream_id
where a.barriers_wct_dnstr = array[]::text[];
