-- --------------
-- OBSERVATIONS
--
-- extract observations for species of interest from bcfishobs
-- --------------
DROP TABLE IF EXISTS bcfishpass.observations cascade;

CREATE TABLE bcfishpass.observations
(
  fish_obsrvtn_event_id bigint primary key,
  linear_feature_id         bigint                           ,
  blue_line_key             integer                          ,
  wscode_ltree ltree                                         ,
  localcode_ltree ltree                                      ,
  downstream_route_measure  double precision                 ,
  watershed_group_code      character varying(4)             ,
  species_codes text[]                                       ,
  observation_ids int[]                                      ,
  observation_dates date[]                                    ,
  geom geometry(PointZM, 3005)
);


-- insert records for watersheds of interest / spp of interest
INSERT INTO bcfishpass.observations
(
  fish_obsrvtn_event_id,
  linear_feature_id,
  blue_line_key,
  wscode_ltree,
  localcode_ltree,
  downstream_route_measure,
  watershed_group_code,
  species_codes,
  observation_ids,
  observation_dates,
  geom
)

-- Convert the boolean species columns in wsg_species_presence into array of species presence for each wsg
-- (We could modify the input file's multiple spp columns into a single column of spp codes but current
-- design works fine and is easy to validate. Down side is that this query must be modified when spp are added)
WITH wsg_spp AS
(
SELECT
  watershed_group_code, string_to_array(array_to_string(ARRAY[bt, ch, cm, co, ct, dv, gr, pk, rb, sk, st, wct], ','),',') as species_codes
FROM (
  SELECT
    p.watershed_group_code,
    CASE WHEN p.bt is true THEN 'BT' ELSE NULL END as bt,
    CASE WHEN p.ch is true THEN 'CH' ELSE NULL END as ch,
    CASE WHEN p.cm is true THEN 'CM' ELSE NULL END as cm,
    CASE WHEN p.co is true THEN 'CO' ELSE NULL END as co,
    CASE WHEN p.ct is true THEN 'CT' ELSE NULL END as ct,
    CASE WHEN p.dv is true THEN 'DV' ELSE NULL END as dv,
    CASE WHEN p.gr is true THEN 'GR' ELSE NULL END as gr,
    CASE WHEN p.pk is true THEN 'PK' ELSE NULL END as pk,
    CASE WHEN p.rb is true THEN 'RB' ELSE NULL END as rb,
    CASE WHEN p.sk is true THEN 'SK' ELSE NULL END as sk,
    CASE WHEN p.st is true THEN 'ST' ELSE NULL END as st,
    CASE WHEN p.wct is true THEN 'WCT' ELSE NULL END as wct
  FROM bcfishpass.wsg_species_presence p
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

-- extract observations of species of interest, 
-- within watershed groups where they are noted to occur
-- - discarding observations outside of those groups
-- - TODO - discard observations noted to be of suspect quality in data/user_observations_qa.csv
obs as (
  SELECT
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
  FROM bcfishobs.fiss_fish_obsrvtn_events_vw e
  INNER JOIN wsg_spp ON e.watershed_group_code = wsg_spp.watershed_group_code
  inner join species_code_remap r on e.species_code = r.species_code
  AND array[e.species_code]::text[] && wsg_spp.species_codes
)

SELECT
  p.fish_obsrvtn_event_id,
  p.linear_feature_id,
  p.blue_line_key,
  p.wscode_ltree,
  p.localcode_ltree,
  p.downstream_route_measure,
  p.watershed_group_code,
  array_agg(p.species_code) as species_codes,
  array_agg(p.fish_observation_point_id) as observation_ids,
  array_agg(p.observation_date) as observation_dates,
  e.geom
FROM obs p
INNER JOIN bcfishobs.fiss_fish_obsrvtn_events e
ON p.fish_obsrvtn_event_id = e.fish_obsrvtn_event_id
GROUP BY p.fish_obsrvtn_event_id,
  p.linear_feature_id,
  p.blue_line_key,
  p.wscode_ltree,
  p.localcode_ltree,
  p.downstream_route_measure,
  p.watershed_group_code,
  e.geom;

-- index
create index if not exists obsrvtn_linear_feature_id_idx on bcfishpass.observations (linear_feature_id);
create index if not exists obsrvtn_blue_line_key_idx on bcfishpass.observations (blue_line_key);
create index if not exists obsrvtn_watershed_group_code_idx on bcfishpass.observations (watershed_group_code);
create index if not exists obsrvtn_wsc_gidx on bcfishpass.observations using gist (wscode_ltree);
create index if not exists obsrvtn_wsc_bidx on bcfishpass.observations using btree (wscode_ltree);
create index if not exists obsrvtn_lc_gidx on bcfishpass.observations using gist (localcode_ltree);
create index if not exists obsrvtn_lc_bidx on bcfishpass.observations using btree (localcode_ltree);
create index if not exists obsrvtn_geom_idx on bcfishpass.observations using gist (geom);


-- create view of distinct observations for simpler species based queries
drop materialized view if exists bcfishpass.observations_vw cascade;
create materialized view bcfishpass.observations_vw as

with unnested as
(select
    unnest(observation_ids) as fish_observation_point_id,
    unnest(species_codes) as species_code,
    unnest(observation_dates) as observation_date,
    fish_obsrvtn_event_id,
    linear_feature_id,
    blue_line_key,
    wscode_ltree,
    localcode_ltree,
    downstream_route_measure,
    watershed_group_code,
    geom
from bcfishpass.observations)
select 
  u.fish_observation_point_id,
  u.fish_obsrvtn_event_id,
  u.linear_feature_id,
  u.blue_line_key,
  u.wscode_ltree,
  u.localcode_ltree,
  u.downstream_route_measure,
  u.watershed_group_code,
  u.species_code,
  u.observation_date,
  o.activity_code,
  o.activity,
  o.life_stage_code,
  o.life_stage,
  o.acat_report_url,
  u.geom
from unnested u
inner join whse_fish.fiss_fish_obsrvtn_pnt_sp o
on u.fish_observation_point_id = o.fish_observation_point_id;

create unique index on bcfishpass.observations_vw (fish_observation_point_id);
create index on bcfishpass.observations_vw using gist (wscode_ltree);
create index on bcfishpass.observations_vw using btree (wscode_ltree);
create index on bcfishpass.observations_vw using gist (localcode_ltree);
create index on bcfishpass.observations_vw using btree (localcode_ltree);