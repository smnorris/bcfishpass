select
  d.dam_id,
  cabd.dam_name_en,
  cabd.owner,
  cabd.operating_status,
  cabd.construction_year,
  cabd.dam_use,
  case
    when cabd.passability_status_code = 1 THEN 'BARRIER'
    when cabd.passability_status_code = 2 THEN 'POTENTIAL'
    when cabd.passability_status_code = 3 THEN 'PASSABLE'
    when cabd.passability_status_code = 4 THEN 'UNKNOWN'
  end AS barrier_status,
  o.fish_observation_point_id,
  o.species_code,
  o.observation_date,
  s.agency_name,
  s.source,
  s.source_ref,
  s.activity,
  s.life_stage,
  s.acat_report_url
from bcfishpass.dams d
inner join bcfishpass.observations_vw o on 
 fwa_upstream(
   d.blue_line_key, d.downstream_route_measure, d.wscode_ltree, d.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode_ltree, o.localcode_ltree)
inner join cabd.dams cabd on d.dam_id = cabd.cabd_id::text and cabd.passability_status_code = 1
inner join whse_fish.fiss_fish_obsrvtn_pnt_sp s on o.fish_observation_point_id = s.fish_observation_point_id
where o.species_code in ('CH','CM','CO','PK','SK','ST')
and dam_id not in ('7130db52-4978-42b8-99ad-11d8d65e87ae','Terzaghi Dam')
order by dam_name_en, fish_observation_point_id;



