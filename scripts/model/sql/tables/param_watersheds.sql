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