-- --------------
-- OBSERVATIONS
--
-- from bcfishobs, extract observations:
--   - of species of interest
--   - within watershed groups where they are confirmed to occur (filtering out bad data)
--
-- --------------

create materialized view bcfishpass.observations_vw as

-- Convert the boolean species columns in wsg_species_presence into array of species presence for each wsg
-- (We could modify the input file's multiple spp columns into a single column of spp codes but current
-- design works fine and is easy to validate. Down side is that this query must be modified when spp are added)
with wsg_spp as
(
select
  watershed_group_code, string_to_array(array_to_string(array[bt, ch, cm, co, ct, dv, gr, pk, rb, sk, st, wct], ','),',') as species_codes
from (
  select
    p.watershed_group_code,
    case when p.bt is true then 'BT' else NULL end as bt,
    case when p.ch is true then 'CH' else NULL end as ch,
    case when p.cm is true then 'CM' else NULL end as cm,
    case when p.co is true then 'CO' else NULL end as co,
    case when p.ct is true then 'CT' else NULL end as ct,
    case when p.dv is true then 'DV' else NULL end as dv,
    case when p.gr is true then 'GR' else NULL end as gr,
    case when p.pk is true then 'PK' else NULL end as pk,
    case when p.rb is true then 'RB' else NULL end as rb,
    case when p.sk is true then 'SK' else NULL end as sk,
    case when p.st is true then 'ST' else NULL end as st,
    case when p.wct is true then 'WCT' else NULL end as wct
  from bcfishpass.wsg_species_presence p
  ) as f
),

-- simplify CT species codes
species_code_remap as (
  select distinct
    species_code,
    case
      when species_code = 'CCT' then 'CT'
      when species_code = 'ACT' then 'CT'
      when species_code = 'CT/RB' then 'CT'
      else species_code
    end as species_code_remap
  from bcfishobs.fiss_fish_obsrvtn_events_vw e
),

-- filter on species code and watershed group
obs as (
  select
    e.fish_observation_point_id,
    e.fish_obsrvtn_event_id,
    e.linear_feature_id,
    e.blue_line_key,
    e.wscode_ltree,
    e.localcode_ltree,
    e.downstream_route_measure,
    e.watershed_group_code,
    r.species_code_remap as species_code,
    e.observation_date
  from bcfishobs.fiss_fish_obsrvtn_events_vw e
  inner join wsg_spp on e.watershed_group_code = wsg_spp.watershed_group_code
  inner join species_code_remap r on e.species_code = r.species_code
  and array[e.species_code]::text[] && wsg_spp.species_codes
)

-- add various other attributes from source
select
  p.fish_observation_point_id,
  p.fish_obsrvtn_event_id,
  p.linear_feature_id,
  p.blue_line_key,
  p.wscode_ltree,
  p.localcode_ltree,
  p.downstream_route_measure,
  p.watershed_group_code,
  p.species_code,
  p.observation_date,
  o.activity_code,
  o.activity,
  o.life_stage_code,
  o.life_stage,
  o.acat_report_url,
  e.geom
from obs p
inner join bcfishobs.fiss_fish_obsrvtn_events e on p.fish_obsrvtn_event_id = e.fish_obsrvtn_event_id
inner join whse_fish.fiss_fish_obsrvtn_pnt_sp o on p.fish_observation_point_id = o.fish_observation_point_id;


create unique index on bcfishpass.observations_vw (fish_observation_point_id);
create index on bcfishpass.observations_vw using gist (wscode_ltree);
create index on bcfishpass.observations_vw using btree (wscode_ltree);
create index on bcfishpass.observations_vw using gist (localcode_ltree);
create index on bcfishpass.observations_vw using btree (localcode_ltree);