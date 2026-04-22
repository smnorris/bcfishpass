-- note that this model is currently only available in a few select watershed groups (for specific
-- project requirements and draft/evaluation purposes) - it is not included in standard reporting

create view bcfishpass.streams_ct_dv_rb_vw as
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
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_ct_dv_rb_dnstr, ';') as barriers_ct_dv_rb_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_ct_dv_rb as access,
  NULL as spawning,  -- spawning/rearing not modelled for ct/dv/rb
  NULL as rearing,
  NULL as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_ct_dv_rb > 0;