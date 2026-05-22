#!/usr/bin/env bash
set -euo pipefail

# required schemas
echo "CREATE SCHEMA IF NOT EXISTS whse_admin_boundaries;
CREATE SCHEMA IF NOT EXISTS whse_cadastre;
CREATE SCHEMA IF NOT EXISTS whse_fish;
CREATE SCHEMA IF NOT EXISTS whse_forest_tenure;
CREATE SCHEMA IF NOT EXISTS whse_imagery_and_base_maps;
CREATE SCHEMA IF NOT EXISTS whse_legal_admin_boundaries;
CREATE SCHEMA IF NOT EXISTS whse_mineral_tenure;
CREATE SCHEMA IF NOT EXISTS whse_tantalis;
CREATE SCHEMA IF NOT EXISTS bcdata;" > schema.sql

# required tables not loaded via fwapg
pg_dump $DATABASE_URL \
  --schema-only \
  --no-privileges \
  --no-owner \
  --table=whse_admin_boundaries.adm_indian_reserves_bands_sp \
  --table=whse_admin_boundaries.adm_nr_districts_spg \
  --table=whse_admin_boundaries.clab_indian_reserves \
  --table=whse_admin_boundaries.clab_national_parks \
  --table=whse_admin_boundaries.fadm_designated_areas \
  --table=whse_admin_boundaries.fadm_tfl_all_sp \
  --table=whse_basemapping.dbm_mof_50k_grid \
  --table=whse_basemapping.gba_railway_tracks_sp \
  --table=whse_basemapping.gba_local_reg_greenspaces_sp \
  --table=whse_basemapping.transport_line_divided_code \
  --table=whse_basemapping.transport_line_structure_code \
  --table=whse_basemapping.transport_line_surface_code \
  --table=whse_basemapping.transport_line_type_code \
  --table=whse_basemapping.transport_line \
  --table=whse_cadastre.pmbc_parcel_fabric_poly_svw \
  --table=whse_fish.fiss_fish_obsrvtn_pnt_sp \
  --table=whse_fish.pscis_assessment_svw \
  --table=whse_fish.pscis_design_proposal_svw \
  --table=whse_fish.pscis_habitat_confirmation_svw \
  --table=whse_fish.pscis_remediation_svw \
  --table=whse_fish.species_cd \
  --table=whse_fish.wdic_waterbodies \
  --table=whse_forest_tenure.ften_range_poly_svw \
  --table=whse_forest_tenure.ften_road_section_lines_svw \
  --table=whse_imagery_and_base_maps.mot_road_structure_sp \
  --table=whse_legal_admin_boundaries.abms_municipalities_sp \
  --table=whse_legal_admin_boundaries.abms_regional_districts_sp \
  --table=whse_mineral_tenure.og_road_segment_permit_sp \
  --table=whse_mineral_tenure.og_petrlm_dev_rds_pre06_pub_sp \
  --table=whse_tantalis.ta_conservancy_areas_svw \
  --table=whse_tantalis.ta_crown_tenures_svw \
  --table=whse_tantalis.ta_park_ecores_pa_svw >> schema.sql
  
# application schemas
pg_dump $DATABASE_URL \
  --schema-only \
  --no-privileges \
  --no-owner \
  --schema=bcfishobs \
  --schema=cabd \
  --schema=bcfishpass >> schema.sql

# Append current version so migrate.sh knows where to start
CURRENT_TAG=$(psql "$DATABASE_URL" --no-psqlrc -t -A -c \
  "SELECT tag FROM bcfishpass.db_version ORDER BY applied_at DESC LIMIT 1;")

cat >> schema.sql <<-SQL

-- db version, appended at dump time
INSERT INTO bcfishpass.db_version (tag, applied_at) VALUES ('${CURRENT_TAG}', now());
SQL