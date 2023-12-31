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
  observation_dates date[]                                   ,
  geom geometry(PointZM, 3005)
);

-- index
create index if not exists obsrvtn_linear_feature_id_idx on bcfishpass.observations (linear_feature_id);
create index if not exists obsrvtn_blue_line_key_idx on bcfishpass.observations (blue_line_key);
create index if not exists obsrvtn_watershed_group_code_idx on bcfishpass.observations (watershed_group_code);
create index if not exists obsrvtn_wsc_gidx on bcfishpass.observations using gist (wscode_ltree);
create index if not exists obsrvtn_wsc_bidx on bcfishpass.observations using btree (wscode_ltree);
create index if not exists obsrvtn_lc_gidx on bcfishpass.observations using gist (localcode_ltree);
create index if not exists obsrvtn_lc_bidx on bcfishpass.observations using btree (localcode_ltree);
create index if not exists obsrvtn_geom_idx on bcfishpass.observations using gist (geom);