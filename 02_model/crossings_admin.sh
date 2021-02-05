#!/bin/bash
set -euxo pipefail

# =================
# Get various admin layers, add admin info to crossings table so we can infer a bit more about ownership
# =================

# -------------------------------------------------
# These sources are straightforward to download via WFS
# -------------------------------------------------
bcdata bc2pg whse_legal_admin_boundaries.abms_regional_districts_sp
bcdata bc2pg whse_legal_admin_boundaries.abms_municipalities_sp
bcdata bc2pg whse_admin_boundaries.adm_indian_reserves_bands_sp
bcdata bc2pg whse_admin_boundaries.clab_national_parks
bcdata bc2pg whse_tantalis.ta_park_ecores_pa_svw
bcdata bc2pg whse_admin_boundaries.adm_nr_districts_sp


# -------------------------------------------------
# PMBC parcel fabric is a bit big for consistent WFS
# -------------------------------------------------
# download to tmp
TMP=~/tmp
wget --trust-server-names -qNP "$TMP" https://pub.data.gov.bc.ca/datasets/4cf233c2-f020-4f7a-9b87-1923252fbc24/pmbc_parcel_fabric_poly_svw.zip
unzip $TMP/pmbc_parcel_fabric_poly_svw.zip -d $TMP

# load to pg
psql -c "CREATE SCHEMA IF NOT EXISTS whse_cadastre"
ogr2ogr \
   -progress \
   --config PG_USE_COPY YES \
   -t_srs EPSG:3005 \
   -dim XY \
   -f PostgreSQL \
   PG:"$PGOGR" \
   -overwrite \
   -lco GEOMETRY_NAME=geom \
   -lco FID=PARCEL_FABRIC_POLY_ID \
   -nln whse_cadastre.pmbc_parcel_fabric_poly_svw \
   $TMP/pmbc_parcel_fabric_poly_svw.gdb \
   pmbc_parcel_fabric_poly_svw

# cleanup
rm $TMP/pmbc_parcel_fabric_poly_svw.zip
rm -r $TMP/pmbc_parcel_fabric_poly_svw.gdb


# -------------------------------------------------
# Run the overlays
# -------------------------------------------------
psql -f sql/crossings_admin.sql