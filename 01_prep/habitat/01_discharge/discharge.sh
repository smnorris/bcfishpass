#!/bin/bash
set -euxo pipefail

# Transfer per-watershed discharge data to per-stream

# create output bcfishpass.discharge table
psql -c "DROP TABLE IF EXISTS bcfishpass.discharge;
CREATE TABLE bcfishpass.discharge (
    linear_feature_id integer,
    watershed_group_code text,
    mad_mm double precision,
    mad_m3s double precision
);"

for WSG in $(psql -AtX -P border=0,footer=no \
  -c "SELECT DISTINCT b.watershed_group_code FROM bcfishpass.discharge_wsd")
do
  echo 'Loading '$WSG
  psql -XA -v wsg=$WSG -f sql/discharge.sql
done

psql -c "ALTER TABLE bcfishpass.discharge_wsd ADD PRIMARY KEY (watershed_feature_id)"