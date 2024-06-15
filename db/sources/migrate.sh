#!/bin/bash
set -euxo pipefail


PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# create required schemas
$PSQL -f sql/schemas.sql

# define cabd
$PSQL -f sql/cabd.sql

# define dra
$PSQL -f sql/whse_basemapping.transport_line.sql

# create whse tables as specified by bcdc api, using bc2pg
for table in whse_admin_boundaries.clab_indian_reserves \
    whse_admin_boundaries.clab_national_parks \
    whse_admin_boundaries.adm_nr_districts_spg \
    whse_admin_boundaries.adm_indian_reserves_bands_sp \
    whse_basemapping.bcgs_20k_grid \
    whse_basemapping.cwb_floodplains_bc_area_svw \
    whse_basemapping.dbm_mof_50k_grid \
    whse_basemapping.gba_local_reg_greenspaces_sp \
    whse_basemapping.gba_railway_structure_lines_sp \
    whse_basemapping.gba_railway_tracks_sp \
    whse_basemapping.gba_transmission_lines_sp \
    whse_basemapping.gns_geographical_names_sp \
    whse_basemapping.nts_250k_grid \
    whse_basemapping.trim_cultural_lines \
    whse_basemapping.trim_cultural_points \
    whse_basemapping.trim_ebm_airfields \
    whse_basemapping.trim_ebm_ocean \
    whse_basemapping.utmg_utm_zones_sp \
    whse_cadastre.pmbc_parcel_fabric_poly_svw \
    whse_environmental_monitoring.envcan_hydrometric_stn_sp \
    whse_fish.fiss_obstacles_pnt_sp \
    whse_fish.fiss_stream_sample_sites_sp \
    whse_fish.pscis_assessment_svw \
    whse_fish.pscis_assessment_svw \
    whse_fish.pscis_design_proposal_svw \
    whse_fish.pscis_habitat_confirmation_svw \
    whse_fish.pscis_remediation_svw \
    whse_forest_tenure.ften_range_poly_svw \
    whse_forest_tenure.ften_road_section_lines_svw \
    whse_forest_vegetation.veg_comp_lyr_r1_poly \
    whse_imagery_and_base_maps.mot_road_structure_sp \
    whse_legal_admin_boundaries.abms_municipalities_sp \
    whse_legal_admin_boundaries.abms_regional_districts_sp \
    whse_mineral_tenure.og_petrlm_dev_rds_pre06_pub_sp \
    whse_mineral_tenure.og_road_segment_permit_sp \
    whse_tantalis.ta_conservancy_areas_svw \
    whse_tantalis.ta_park_ecores_pa_svw
do
    bcdata bc2pg -e -c 1 $table
done

# additional indexes for veg
$PSQL -c \
  "CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (for_mgmt_land_base_ind); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (inventory_standard_cd); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (non_productive_descriptor_cd); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (species_pct_1); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (species_cd_1); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (site_index); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_1); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_2); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_3); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_4); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (bclcs_level_5); \
   CREATE INDEX ON whse_forest_vegetation.veg_comp_lyr_r1_poly (map_id);"

# create additional views on source data
$PSQL -f sql/bcdata.ften_range_poly_carto_vw.sql
$PSQL -f sql/bcdata.parks.sql
