-- create view of distinct observations for simpler species based queries
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