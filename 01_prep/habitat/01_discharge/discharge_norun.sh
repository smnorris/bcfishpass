#!/bin/bash
set -euxo pipefail

# Load discharge data
# Discharge data provided by Foundry Spatial under agreement with CWF - for CWF use only.

# Note that discharge is provided as a watershed shapefile - we need to convert this to discharge per *stream* feature

psql -c "CREATE SCHEMA IF NOT EXISTS foundry"
psql -c "DROP TABLE IF EXISTS foundry.fwa_streams_mad"
psql -c "CREATE TABLE foundry.fwa_streams_mad
(
    linear_feature_id bigint primary key,
    watershed_group_code character varying(4),
    mad_m3s double precision
)"


