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
  count(*) as n_observations,
  array_agg(o.fish_observation_point_id) as fish_observation_point_id,
  array_agg(o.species_code) as species_codes,
  array_agg(o.observation_date) as observation_dates
from bcfishpass.dams d
inner join bcfishpass.observations_vw o on 
 fwa_upstream(
   d.blue_line_key, d.downstream_route_measure, d.wscode_ltree, d.localcode_ltree,
   o.blue_line_key, o.downstream_route_measure, o.wscode_ltree, o.localcode_ltree)
inner join cabd.dams cabd on d.dam_id = cabd.cabd_id::text and cabd.passability_status_code = 1
where o.species_code in ('CH','CM','CO','PK','SK','ST')
group by d.dam_id,
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
  end
order by dam_name_en;