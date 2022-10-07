-- de-aggregate observations
with obs as
(
select distinct
  o.fish_observation_point_id,
  e.blue_line_key,
  e.downstream_route_measure,
  e.wscode_ltree,
  e.localcode_ltree,
  e.species_code,
  e.observation_date
from (
   select 
    unnest(observation_ids) as fish_observation_point_id
   from bcfishpass.observations
 ) as o
inner join bcfishobs.fiss_fish_obsrvtn_events_sp e on o.fish_observation_point_id = e.fish_observation_point_id
where e.species_code in ('CH','CM','CO','PK','SK','ST')
)


select
d.dam_id,
cabd.dam_name_en as dam_name,
cabd.owner as dam_owner,    
cabd.operating_status as dam_operating_status,
cabd.construction_year,
  case
  when cabd.passability_status_code = 1 THEN 'BARRIER'
  when cabd.passability_status_code = 2 THEN 'POTENTIAL'
  when cabd.passability_status_code = 3 THEN 'PASSABLE'
  when cabd.passability_status_code = 4 THEN 'UNKNOWN'
end AS barrier_status,
o.fish_observation_point_id,
o.species_code,
o.observation_date
from bcfishpass.dams d
inner join obs o
on fwa_upstream(
d.blue_line_key, d.downstream_route_measure, d.wscode_ltree, d.localcode_ltree,
o.blue_line_key, o.downstream_route_measure, o.wscode_ltree, o.localcode_ltree)
inner join cabd.dams cabd on d.dam_id = cabd.cabd_id
--inner join bcfishobs.fiss_fish_obsrvtn_events_vw e on o.fish_obsrvtn_event_id = e.fish_obsrvtn_event_id
where cabd.dam_use = 'Hydroelectricity'
and dam_id != 'e8e4bd88-c3c9-407c-a7a0-15c6c51704fd' -- this dam is mistakenly snapped to the Fraser
order by dam_name, species_code, observation_date;