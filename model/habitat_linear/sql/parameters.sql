-- --------------
-- method
-- specify which watersheds to include, which habitat model to use
-- --------------
DROP TABLE IF EXISTS bcfishpass.parameters_habitat_method;
CREATE TABLE bcfishpass.parameters_habitat_method
(
  watershed_group_code character varying(4),
  model text
);

-- --------------
-- thresholds
-- define various spawning/rearing thresholds for species to be modelled
-- --------------
DROP TABLE IF EXISTS bcfishpass.parameters_habitat_thresholds;
CREATE TABLE bcfishpass.parameters_habitat_thresholds (
  species_code text,
  spawn_gradient_max numeric,
  spawn_channel_width_min numeric,
  spawn_channel_width_max numeric,
  spawn_mad_min numeric,
  spawn_mad_max numeric,
  rear_gradient_max numeric,
  rear_channel_width_min numeric,
  rear_channel_width_max numeric,
  rear_mad_min numeric,
  rear_mad_max numeric,
  rear_lake_ha_min integer,
  rear_wetland_multiplier numeric,
  rear_lake_multiplier numeric
);