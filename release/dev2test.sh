#!/bin/bash
set -euxo pipefail

# ===============================
# load key bcfishpass outputs from local dev bcfishpass db to local bcfishpass_test db
# ===============================

# clean out existing data
psql bcfishpass_test -c "drop schema if exists bcfishpass cascade"
psql bcfishpass_test -c "create schema bcfishpass"

# load minimal set of tables for replication
pg_dump -t bcfishpass.barriers_bt | psql bcfishpass_test
pg_dump -t bcfishpass.barriers_ch_co_sk | psql bcfishpass_test
pg_dump -t bcfishpass.barriers_ch_co_sk_b | psql bcfishpass_test
pg_dump -t bcfishpass.barriers_pk | psql bcfishpass_test
pg_dump -t bcfishpass.barriers_st | psql bcfishpass_test
pg_dump -t bcfishpass.barriers_wct | psql bcfishpass_test
pg_dump -t bcfishpass.crossings | psql bcfishpass_test
pg_dump -t bcfishpass.observations | psql bcfishpass_test
pg_dump -t bcfishpass.pscis_not_matched_to_streams | psql bcfishpass_test
pg_dump -t bcfishpass.streams | psql bcfishpass_test
pg_dump -t bcfishpass.carto_streams_large | psql bcfishpass_test