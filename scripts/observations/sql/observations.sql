-- --------------
-- OBSERVATIONS
--
-- extract observations for species of interest from bcfishobs
-- --------------
DROP TABLE IF EXISTS bcfishpass.observations;

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
  watershed_group_code, string_to_array(array_to_string(ARRAY[ch, co, cm, pk, sk, st, wct, bt, gr, rb], ','),',') as species_codes
FROM (
  SELECT
    p.watershed_group_code,
    CASE WHEN p.ch is true THEN 'CH' ELSE NULL END as ch,
    CASE WHEN p.co is true THEN 'CO' ELSE NULL END as co,
    CASE WHEN p.cm is true THEN 'CM' ELSE NULL END as cm,
    CASE WHEN p.pk is true THEN 'PK' ELSE NULL END as pk,
    CASE WHEN p.sk is true THEN 'SK' ELSE NULL END as sk,
    CASE WHEN p.st is true THEN 'ST' ELSE NULL END as st,
    CASE WHEN p.wct is true THEN 'WCT' ELSE NULL END as wct,
    CASE WHEN p.bt is true THEN 'BT' ELSE NULL END as bt,
    CASE WHEN p.gr is true THEN 'GR' ELSE NULL END as gr,
    CASE WHEN p.rb is true THEN 'RB' ELSE NULL END as rb
  FROM bcfishpass.wsg_species_presence p
  ) as f
),

-- extract observations of species of interest, 
-- within watershed groups where they are noted to occur
-- (discarding observations outside of those groups)
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
    e.species_code,
    e.observation_date
  FROM bcfishobs.fiss_fish_obsrvtn_events_vw e
  INNER JOIN wsg_spp
  ON e.watershed_group_code = wsg_spp.watershed_group_code
  AND array[e.species_code]::text[] && wsg_spp.species_codes
)

-- aggregate, get distinct geom point
SELECT
  e.fish_obsrvtn_event_id,
  e.linear_feature_id,
  e.blue_line_key,
  e.wscode_ltree,
  e.localcode_ltree,
  e.downstream_route_measure,
  e.watershed_group_code,
  array_agg(e.species_code) as species_codes,
  array_agg(e.fish_observation_point_id) as observation_ids,
  array_agg(e.observation_date) as observation_dates,
  vw.geom
FROM obs e
INNER JOIN bcfishobs.fiss_fish_obsrvtn_events_vw vw
ON e.fish_obsrvtn_event_id = vw.fish_obsrvtn_event_id
GROUP BY e.fish_obsrvtn_event_id,
  e.linear_feature_id,
  e.blue_line_key,
  e.wscode_ltree,
  e.localcode_ltree,
  e.downstream_route_measure,
  e.watershed_group_code,
  vw.geom;

-- index
CREATE INDEX IF NOT EXISTS obsrvtn_linear_feature_id_idx ON bcfishpass.observations (linear_feature_id);
CREATE INDEX IF NOT EXISTS obsrvtn_blue_line_key_idx ON bcfishpass.observations (blue_line_key);
CREATE INDEX IF NOT EXISTS obsrvtn_watershed_group_code_idx ON bcfishpass.observations (watershed_group_code);
CREATE INDEX IF NOT EXISTS obsrvtn_wsc_gidx ON bcfishpass.observations USING GIST (wscode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_wsc_bidx ON bcfishpass.observations USING BTREE (wscode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_lc_gidx ON bcfishpass.observations USING GIST (localcode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_lc_bidx ON bcfishpass.observations USING BTREE (localcode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_geom_idx ON bcfishpass.observations USING GIST (geom);
