-- set up testing database
create extension postgis;
create extension ltree;
create extension intarray;
create extension postgis_raster;


-- to reduce data duplication, create fdws for base data
create extension postgres_fdw;

create schema if not exists whse_admin_boundaries;
create schema if not exists whse_basemapping;
create schema if not exists whse_cadastre;
create schema if not exists whse_environmental_monitoring;
create schema if not exists whse_fish;
create schema if not exists whse_forest_tenure;
create schema if not exists whse_forest_vegetation;
create schema if not exists whse_imagery_and_base_maps;
create schema if not exists whse_legal_admin_boundaries;
create schema if not exists whse_mineral_tenure;
create schema if not exists whse_tantalis;
create schema if not exists whse_terrestrial_ecology;
create schema if not exists whse_water_management;

create server bcfishpass_dev
foreign data wrapper postgres_fdw
options (host 'localhost', dbname 'bcfishpass');

create user mapping for postgres
server bcfishpass_dev
options (user 'postgres', password 'postgres');

import foreign schema whse_admin_boundaries from server bcfishpass_dev into whse_admin_boundaries;
import foreign schema whse_basemapping from server bcfishpass_dev into whse_basemapping;
import foreign schema whse_cadastre from server bcfishpass_dev into whse_cadastre;
import foreign schema whse_environmental_monitoring from server bcfishpass_dev into whse_environmental_monitoring;
import foreign schema whse_fish from server bcfishpass_dev into whse_fish;
import foreign schema whse_forest_tenure from server bcfishpass_dev into whse_forest_tenure;
import foreign schema whse_forest_vegetation from server bcfishpass_dev into whse_forest_vegetation;
import foreign schema whse_imagery_and_base_maps from server bcfishpass_dev into whse_imagery_and_base_maps;
import foreign schema whse_legal_admin_boundaries from server bcfishpass_dev into whse_legal_admin_boundaries;
import foreign schema whse_mineral_tenure from server bcfishpass_dev into whse_mineral_tenure;
import foreign schema whse_tantalis from server bcfishpass_dev into whse_tantalis;
import foreign schema whse_terrestrial_ecology from server bcfishpass_dev into whse_terrestrial_ecology;
import foreign schema whse_water_management from server bcfishpass_dev into whse_water_management;
