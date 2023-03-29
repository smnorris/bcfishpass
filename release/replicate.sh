#!/bin/bash
set -euxo pipefail

# write schemas bcfishobs/bcfishpass from source db (arg1) to target db (arg2)

psql service=$2 -c "drop schema if exists bcfishobs cascade"
psql service=$2 -c "drop schema if exists bcfishpass cascade"

pg_dump service=$1 -n bcfishobs | psql service=$2
pg_dump service=$1 -n bcfishpass | psql service=$2


# also ensure roads/railways are the same in each db to avoid confusion
psql service=$2 -c "drop table whse_basemapping.gba_railway_structure_lines_sp"
psql service=$2 -c "drop table whse_basemapping.gba_railway_tracks_sp"
psql service=$2 -c "drop table whse_basemapping.transport_line"
psql service=$2 -c "drop table whse_basemapping.transport_line_divided_code"
psql service=$2 -c "drop table whse_basemapping.transport_line_structure_code"
psql service=$2 -c "drop table whse_basemapping.transport_line_surface_code"
psql service=$2 -c "drop table whse_basemapping.transport_line_type_code"
psql service=$2 -c "drop table whse_forest_tenure.ften_road_section_lines_svw"
pg_dump service=$1 -t whse_basemapping.gba_railway_structure_lines_sp | psql service $2
pg_dump service=$1 -t whse_basemapping.gba_railway_tracks_sp | psql service $2
pg_dump service=$1 -t whse_basemapping.transport_line | psql service $2
pg_dump service=$1 -t whse_basemapping.transport_line_divided_code | psql service $2
pg_dump service=$1 -t whse_basemapping.transport_line_structure_code | psql service $2
pg_dump service=$1 -t whse_basemapping.transport_line_surface_code | psql service $2
pg_dump service=$1 -t whse_basemapping.transport_line_type_code | psql service $2
pg_dump service=$1 -t whse_forest_tenure.ften_road_section_lines_svw | psql service $2