#!/bin/bash

# This script presumes:
# 1. The PGHOST, PGUSER, PGDATABASE, PGPORT environment variables are set
# 2. Password authentication for the DB is not required or password is held in .pgpass

set -euxo pipefail


# split out various barrier types into individual tables

# create table for each type of definite (not generally fixable) barrier
psql -f sql/02_barriers/01_definite/barriers_majordams.sql
psql -f sql/02_barriers/01_definite/barriers_ditchflow.sql
psql -f sql/02_barriers/01_definite/barriers_falls.sql
psql -f sql/02_barriers/01_definite/barriers_gradient_15.sql
psql -f sql/02_barriers/01_definite/barriers_gradient_20.sql
psql -f sql/02_barriers/01_definite/barriers_gradient_30.sql
psql -f sql/02_barriers/01_definite/barriers_intermittentflow.sql
psql -f sql/02_barriers/01_definite/barriers_subsurfaceflow.sql
psql -f sql/02_barriers/01_definite/barriers_other.sql


# load manual QA of modelled crossings - (modelled crossings that are either OBS or non-existent)
psql -c "DROP TABLE IF EXISTS bcfishpass.modelled_stream_crossings_fixes"
psql -c "CREATE TABLE bcfishpass.modelled_stream_crossings_fixes (modelled_crossing_id integer, watershed_group_code text, reviewer text, structure text, notes text)"
psql -c "\copy bcfishpass.modelled_stream_crossings_fixes FROM 'data/modelled_stream_crossings_fixes.csv' delimiter ',' csv header"

# create a single tables of anthropogenic barriers / potential barriers for prioritization
# (smaller dams / pscis crossings / modelled culverts / other)
psql -f sql/02_barriers/02_anthropogenic/barriers_anthropogenic.sql