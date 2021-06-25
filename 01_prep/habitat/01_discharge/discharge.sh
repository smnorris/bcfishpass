#!/bin/bash
set -euxo pipefail

# create output table
psql -c "drop table if exists bcfishpass.discharge;

  create table bcfishpass.discharge (
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    area bigint,
    discharge numeric,
    discharge_upstream numeric,
    primary key (wscode_ltree, localcode_ltree)
  );"

# transfer data from load table to discharge table
# Calculate area-weighted avg discharge upstream of every stream segment
# loop through watershed groups, don't bother trying to update in parallel
for WSG in $(psql -A -t -P border=0,footer=no \
  -c "select distinct b.watershed_group_code
      from bcfishpass.discharge_load a
      inner join whse_basemapping.fwa_watersheds_poly b
      on a.watershed_feature_id = b.watershed_feature_id
      order by b.watershed_group_code")
do
  psql -X -v wsg="$WSG" < sql/discharge.sql
done

psql -c "create index on bcfishpass.discharge using gist (wscode_ltree);"
psql -c "create index on bcfishpass.discharge using btree (wscode_ltree);"
psql -c "create index on bcfishpass.discharge using gist (localcode_ltree);"
psql -c "create index on bcfishpass.discharge using btree (localcode_ltree);"
