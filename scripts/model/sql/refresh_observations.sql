DELETE FROM bcfishpass.observations WHERE watershed_group_code = :'wsg';

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
SELECT 
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
FROM bcfishpass.observations_load
WHERE watershed_group_code = :'wsg';