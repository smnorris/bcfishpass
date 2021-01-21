-- create a table holding all distinct observation points for species of interest

DROP TABLE IF EXISTS bcfishpass.observations;
CREATE TABLE bcfishpass.observations
(
  fish_obsrvtn_pnt_distinct_id integer,
  linear_feature_id         bigint                           ,
  blue_line_key             integer                          ,
  wscode_ltree ltree                                         ,
  localcode_ltree ltree                                      ,
  downstream_route_measure  double precision                 ,
  watershed_group_code      character varying(4)             ,
  species_codes text[]                                      ,
  observation_ids int[] ,
  geom geometry(PointZM, 3005)
);

-- insert records for watersheds of interest / spp of interest
INSERT INTO bcfishpass.observations
(
  fish_obsrvtn_pnt_distinct_id,
  linear_feature_id,
  blue_line_key,
  wscode_ltree,
  localcode_ltree,
  downstream_route_measure,
  watershed_group_code,
  species_codes,
  observation_ids,
  geom
)

-- first, de-aggregate all distinct observation points with spp of interest within groups of interest
-- (this will include observations of other spp at the same point)
WITH unnested_obs AS
(
  SELECT
    e.fish_obsrvtn_pnt_distinct_id,
    e.linear_feature_id,
    e.blue_line_key,
    e.wscode_ltree,
    e.localcode_ltree,
    e.downstream_route_measure,
    e.watershed_group_code,
    unnest(e.species_codes) as species_code,
    unnest(e.obs_ids) as observation_id
  FROM whse_fish.fiss_fish_obsrvtn_events e
  INNER JOIN bcfishpass.watershed_groups g
  ON e.watershed_group_code = g.watershed_group_code
  AND g.include IS TRUE
  WHERE species_codes && ARRAY['CO','CH','SK','ST','WCT']

),

-- then re-aggregate, retaining only observation records for the species of interest within group of interest
by_wsg AS
(
  -- salmon / steelhead watersheds
  SELECT
    e.fish_obsrvtn_pnt_distinct_id,
    e.linear_feature_id,
    e.blue_line_key,
    e.wscode_ltree,
    e.localcode_ltree,
    e.downstream_route_measure,
    e.watershed_group_code,
    array_agg(e.species_code) as species_codes,
    array_agg(e.observation_id) as observation_ids
  FROM unnested_obs e
  INNER JOIN bcfishpass.watershed_groups g
  ON e.watershed_group_code = g.watershed_group_code AND
  g.include IS TRUE AND
  (g.co IS TRUE OR g.ch IS TRUE OR g.sk IS TRUE OR g.st IS TRUE)
  WHERE species_code IN ('CO','CH','SK','ST')
  GROUP BY
    e.fish_obsrvtn_pnt_distinct_id,
    e.linear_feature_id,
    e.blue_line_key,
    e.wscode_ltree,
    e.localcode_ltree,
    e.downstream_route_measure,
    e.watershed_group_code
  UNION ALL
  -- WCT
  SELECT
    e.fish_obsrvtn_pnt_distinct_id,
    e.linear_feature_id,
    e.blue_line_key,
    e.wscode_ltree,
    e.localcode_ltree,
    e.downstream_route_measure,
    e.watershed_group_code,
    array_agg(e.species_code) as species_codes,
    array_agg(e.observation_id) as observation_ids
  FROM unnested_obs e
  INNER JOIN bcfishpass.watershed_groups g
  ON e.watershed_group_code = g.watershed_group_code
  AND g.include IS TRUE
  AND g.wct IS TRUE
  WHERE species_code = 'WCT'
  GROUP BY
    e.fish_obsrvtn_pnt_distinct_id,
    e.linear_feature_id,
    e.blue_line_key,
    e.wscode_ltree,
    e.localcode_ltree,
    e.downstream_route_measure,
    e.watershed_group_code
)

-- generate geoms
SELECT
  e.fish_obsrvtn_pnt_distinct_id,
  e.linear_feature_id,
  e.blue_line_key,
  e.wscode_ltree,
  e.localcode_ltree,
  e.downstream_route_measure,
  e.watershed_group_code,
  e.species_codes,
  e.observation_ids,
  (ST_Dump(
      ST_LocateAlong(s.geom, e.downstream_route_measure)
      )
  ).geom::geometry(PointZM, 3005) AS geom
FROM by_wsg e
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON e.linear_feature_id = s.linear_feature_id;

CREATE INDEX ON bcfishpass.observations (linear_feature_id);
CREATE INDEX ON bcfishpass.observations (blue_line_key);
CREATE INDEX ON bcfishpass.observations (watershed_group_code);
CREATE INDEX ON bcfishpass.observations USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.observations USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.observations USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.observations USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.observations USING GIST (geom);