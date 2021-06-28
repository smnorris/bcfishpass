#!/bin/bash
set -euxo pipefail

# Transfer data from load table to discharge table
# This calculates the area weighted annual average flow for each watershed (mad_mm) and coverts this to cubic m per s (m3s)

# create output table
psql -c "DROP TABLE IF EXISTS bcfishpass.discharge;
CREATE TABLE bcfishpass.discharge (
    watershed_feature_id integer,
    watershed_group_code text,
    mad_mm double precision,
    mad_m3s double precision
);"

for WSG in $(psql -AtX -P border=0,footer=no \
  -c "SELECT DISTINCT b.watershed_group_code
      FROM bcfishpass.discharge_load a
      INNER JOIN whse_basemapping.fwa_watersheds_poly b
      ON a.watershed_feature_id = b.watershed_feature_id
      ORDER BY b.watershed_group_code")
do
  echo 'Loading '$WSG
  psql -XA -v wsg=$WSG -f sql/discharge.sql
done

psql -c "ALTER TABLE bcfishpass.discharge ADD PRIMARY KEY (watershed_feature_id)"