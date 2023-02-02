#!/bin/bash
set -euxo pipefail

# ===============================
# load key bcfishpass outputs from local dev bcfishpass db to local bcfishpass_test db
# ===============================

# Clean out existing data
psql -c "drop database bcfishpass_test"
psql -c "create database bcfishpass_test"

psql bcfishpass_test -f sql/bcfishpass_test.sql

# Copy everything from dev db bcfishpass schema to test db
# A full copy is probably overkill but can be a handy backup if dev
# ever needs to be restored
pg_dump -n bcfishobs | psql bcfishpass_test
pg_dump -n cabd | psql bcfishpass_test
pg_dump -n bcfishpass | psql bcfishpass_test

# drop raster table
psql bcfishpass_test -c "drop table if exists bcfishpass.discharge01_raster"
