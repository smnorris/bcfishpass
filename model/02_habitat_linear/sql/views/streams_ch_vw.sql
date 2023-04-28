-- create per species views

create or replace view bcfishpass.streams_ch_vw as
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
  array_to_string(s.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(s.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(s.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(s.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(s.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(s.crossings_dnstr, ';') as crossings_dnstr,
  array_to_string(s.obsrvtn_event_upstr, ';') as obsrvtn_event_upstr,
  array_to_string(s.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  s.remediated_dnstr,
  h.spawning,
  h.rearing,
  array_to_string(array[
  case
    when
      s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning is null and
      h.rearing is null
    then 'ACCESS'
    when h.spawning is not null
    then 'SPAWN'
    when
      h.spawning is null and
      h.rearing is not null
    then 'REAR'
  end,
  case
    when s.remediated_dnstr is true then 'REMEDIATED'     -- this must be first condition as others below can also be true
    when s.barriers_anthropogenic_dnstr is null then 'NONE'    -- no barriers dnstr
    when s.barriers_anthropogenic_dnstr is not null and   -- modelled barrier dnstr
      s.barriers_pscis_dnstr is null and
      s.barriers_dams_dnstr is null and
      s.barriers_dams_hydro_dnstr is null then 'MODELLED'
    when s.barriers_anthropogenic_dnstr is not null and   -- pscis barrier dnstr
      s.barriers_pscis_dnstr is not null and
      s.barriers_dams_dnstr is null and
      s.barriers_dams_hydro_dnstr is null then 'ASSESSED'
    when s.barriers_anthropogenic_dnstr is not null and   -- dam barrier dnstr
      s.barriers_dams_dnstr is not null and
      s.barriers_dams_hydro_dnstr is null then 'DAM'
    when s.barriers_anthropogenic_dnstr is not null and   -- hydro dam barrier dnstr
      s.barriers_dams_hydro_dnstr is not null then 'HYDRO'
  end,
  case
    when s.feature_code = 'GA24850150' then 'INTERMITTENT'
    else NULL
  end], ';') as map_symbol_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.model_habitat_ch h on s.segmented_stream_id = h.segmented_stream_id
where s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[];
