-- Habitat model parameters (that can be modified by user)

-- --------------
-- method
-- specify which watersheds to include, which habitat model to use
-- --------------
create table bcfishpass.parameters_habitat_method
(
  watershed_group_code character varying(4),
  model text
);

-- --------------
-- thresholds
-- define various spawning/rearing thresholds for species to be modelled
-- --------------
create table bcfishpass.parameters_habitat_thresholds (
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
  rear_lake_ha_min integer
);

-- --------------
-- list of watershed groups to process in access model/crossings
-- --------------
create table bcfishpass.watershed_groups_access (
  watershed_group_code character varying(4)
);
-- and default to all watershed groups
insert into bcfishpass.watershed_groups_access
  select watershed_group_code from whse_basemapping.fwa_watershed_groups_poly;