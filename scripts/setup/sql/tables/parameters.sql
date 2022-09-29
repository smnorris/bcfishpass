-- --------------
-- PARAMETERS - HABITAT PER SPECIES
--
-- define various spawning/rearing thresholds for species to be modelled
-- --------------
DROP TABLE IF EXISTS bcfishpass.param_habitat;
CREATE TABLE bcfishpass.param_habitat (
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

-- --------------
-- PARAMETERS - WATERSHEDS TO PROCESS
--
-- specify which watersheds to include, what species to include, and what habitat model to use
-- --------------
DROP TABLE IF EXISTS bcfishpass.param_watersheds;
CREATE TABLE bcfishpass.param_watersheds
(
  watershed_group_code character varying(4),
  model text
);