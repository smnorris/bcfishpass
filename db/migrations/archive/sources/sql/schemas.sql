-- create schemas not created by fwapg scripts
-- bcfishobs/whse_fish schemas are conditionally created 
-- (in case bcfishobs scripts have already been run in the db)
create schema bcdata;
create schema if not exists bcfishobs;
create schema cabd;
create schema whse_admin_boundaries;
create schema whse_cadastre;
create schema whse_environmental_monitoring;
create schema if not exists whse_fish;
create schema whse_forest_tenure;
create schema whse_forest_vegetation;
create schema whse_imagery_and_base_maps;
create schema whse_legal_admin_boundaries;
create schema whse_mineral_tenure;
create schema whse_tantalis;