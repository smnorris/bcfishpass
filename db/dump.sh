#!/usr/bin/env bash
set -euo pipefail


# required tables
pg_dump $DATABASE_URL \
  --schema-only \
  --no-privileges \
  --no-owner \
  --table=whse_basemapping.dbm_mof_50k_grid \
  --table=whse_basemapping.gba_railway_tracks_sp \
  --table=whse_basemapping.transport_line_divided_code \
  --table=whse_basemapping.gba_local_reg_greenspaces_sp \
  --table=whse_basemapping.transport_line_structure_code \
  --table=whse_basemapping.transport_line_surface_code \
  --table=whse_basemapping.transport_line_type_code \
  --table=whse_basemapping.transport_line \
  --table=whse_mineral_tenure.og_road_segment_permit_sp \
  --table=whse_mineral_tenure.og_petrlm_dev_rds_pre06_pub_sp \
  --table=whse_imagery_and_base_maps.mot_road_structure_sp > schema.sql

# other bc whse schemas
pg_dump $DATABASE_URL \
  --schema-only \
  --no-privileges \
  --no-owner \
  --schema=whse_admin_boundaries \
  --schema=whse_cadastre \
  --schema=whse_legal_admin_boundaries \
  --schema=whse_admin_boundaries \
  --schema=whse_tantalis \
  --schema=whse_forest_tenure \
  --schema=whse_fish \
  --schema=whse_forest_vegetation >> schema.sql
  
# application schemas
pg_dump $DATABASE_URL \
  --schema-only \
  --no-privileges \
  --no-owner \
  --schema=bcdata \
  --schema=bcfishobs \
  --schema=cabd \
  --schema=bcfishpass >> schema.sql