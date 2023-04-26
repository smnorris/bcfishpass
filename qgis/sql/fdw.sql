-- if loading base data not required for bcfishpass modelling into a more general db (for other
-- uses/to avoid duplication), import them via FDW for easy use with a bcfishpass db connection

create extension if not exists postgis;
create extension if not exists ltree;
create extension if not exists intarray;
create extension if not exists postgres_fdw;

drop server if exists bcdata cascade;
create server bcdata
foreign data wrapper postgres_fdw
options (host 'localhost', dbname 'bcdata', extensions 'ltree, postgis, intarray');

create user mapping for postgres
server bcdata
options (user 'postgres', password 'postgres');

-- remote whse_basemapping tables
create schema if not exists whse_basemapping;
import foreign schema whse_basemapping limit to (
  bcgs_20k_grid,
  gba_transmission_lines_sp,
  gns_geographical_names_sp,
  trim_contour_lines,
  trim_ebm_ocean,
  utmg_utm_zones_sp
)
from server bcdata into whse_basemapping;

-- remote whse_fish tables
create schema if not exists whse_fish;
import foreign schema whse_fish limit to (
  fiss_stream_sample_sites_sp
)
from server bcdata into whse_fish;

-- remote whse_forest_tenure tables
import foreign schema whse_forest_tenure limit to (
  ften_range_poly_svw,
  ften_range_poly_carto_vw
)
from server bcdata into whse_forest_tenure;

-- remote schemas
create schema if not exists whse_admin_boundaries;
create schema if not exists whse_cadastre;
create schema if not exists whse_environmental_monitoring;
create schema if not exists whse_forest_tenure;
create schema if not exists whse_forest_vegetation;
create schema if not exists whse_legal_admin_boundaries;
create schema if not exists whse_tantalis;

import foreign schema whse_admin_boundaries from server bcdata into whse_admin_boundaries;
import foreign schema whse_cadastre from server bcdata into whse_cadastre;
import foreign schema whse_environmental_monitoring from server bcdata into whse_environmental_monitoring;
import foreign schema whse_forest_vegetation from server bcdata into whse_forest_vegetation;
import foreign schema whse_legal_admin_boundaries from server bcdata into whse_legal_admin_boundaries;
import foreign schema whse_tantalis from server bcdata into whse_tantalis;