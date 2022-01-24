-- load observations, overwriting existing _load table
DELETE FROM bcfishpass.observations_load;

-- insert records for watersheds of interest / spp of interest
INSERT INTO bcfishpass.observations_load
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
  observation_dates,
  geom
)

-- convert the boolean species columns in wsg_species_presence into array of species presence for each wsg
-- (We could modify the input file's multiple spp columns into a single column of spp codes but current
-- design works fine and is easy to validate. Down side is that this query has to be modified if more spp
-- are added)
WITH wsg_spp AS
(
SELECT
  watershed_group_code, string_to_array(array_to_string(ARRAY[co, ch, sk, st, wct], ','),',') as species_codes
FROM (
  SELECT
    p.watershed_group_code,
    CASE WHEN p.co is true THEN 'CO' ELSE NULL END as co,
    CASE WHEN p.ch is true THEN 'CH' ELSE NULL END as ch,
    CASE WHEN p.sk is true THEN 'SK' ELSE NULL END as sk,
    CASE WHEN p.st is true THEN 'ST' ELSE NULL END as st,
    CASE WHEN p.wct is true THEN 'WCT' ELSE NULL END as wct,
    --pk
    --cm
    CASE WHEN p.bt is true THEN 'BT' ELSE NULL END as bt,
    CASE WHEN p.gr is true THEN 'GR' ELSE NULL END as gr,
    CASE WHEN p.rb is true THEN 'RB' ELSE NULL END as rb
  FROM bcfishpass.wsg_species_presence p
  ) as f
),

-- de-aggregate all distinct observation points with spp of interest within groups of interest
-- (this includes observations of other species at the same location)
unnested_obs AS
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
  FROM bcfishobs.fiss_fish_obsrvtn_events e
  INNER JOIN bcfishpass.param_watersheds g
  ON e.watershed_group_code = g.watershed_group_code
  INNER JOIN wsg_spp
  ON e.watershed_group_code = wsg_spp.watershed_group_code
  AND e.species_codes && wsg_spp.species_codes
  WHERE e.watershed_group_code = ANY(
  ARRAY(
    SELECT watershed_group_code
    FROM bcfishpass.param_watersheds
  )
)
),

-- then re-aggregate, retaining only observation records for the species of interest within group of interest
by_wsg AS
(
  SELECT
    e.fish_obsrvtn_pnt_distinct_id,
    e.linear_feature_id,
    e.blue_line_key,
    e.wscode_ltree,
    e.localcode_ltree,
    e.downstream_route_measure,
    e.watershed_group_code,
    array_agg(e.species_code) as species_codes,
    array_agg(e.observation_id) as observation_ids,
    array_agg(sp.observation_date) as observation_dates
  FROM unnested_obs e
  INNER JOIN bcfishobs.fiss_fish_obsrvtn_events_sp sp
  ON e.observation_id = sp.fish_observation_point_id
  INNER JOIN bcfishpass.param_watersheds g
  ON e.watershed_group_code = g.watershed_group_code
  WHERE e.species_code = ANY (
    ARRAY(SELECT species_code
          FROM bcfishpass.param_habitat
          )
    )
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
  e.observation_dates,
  (ST_Dump(
      ST_LocateAlong(s.geom, e.downstream_route_measure)
      )
  ).geom::geometry(PointZM, 3005) AS geom
FROM by_wsg e
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON e.linear_feature_id = s.linear_feature_id;