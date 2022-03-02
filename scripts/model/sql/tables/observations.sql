-- --------------
-- OBSERVATIONS_LOAD
--
-- initial load target for all latest observation data
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.observations_load
(
  fish_obsrvtn_pnt_distinct_id integer primary key,
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

-- --------------
-- OBSERVATIONS
--
-- observation data to be used in model
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.observations
(
  fish_obsrvtn_pnt_distinct_id integer primary key,
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

CREATE INDEX IF NOT EXISTS obsrvtn_linear_feature_id_idx ON bcfishpass.observations (linear_feature_id);
CREATE INDEX IF NOT EXISTS obsrvtn_blue_line_key_idx ON bcfishpass.observations (blue_line_key);
CREATE INDEX IF NOT EXISTS obsrvtn_watershed_group_code_idx ON bcfishpass.observations (watershed_group_code);
CREATE INDEX IF NOT EXISTS obsrvtn_wsc_gidx ON bcfishpass.observations USING GIST (wscode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_wsc_bidx ON bcfishpass.observations USING BTREE (wscode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_lc_gidx ON bcfishpass.observations USING GIST (localcode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_lc_bidx ON bcfishpass.observations USING BTREE (localcode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_geom_idx ON bcfishpass.observations USING GIST (geom);
