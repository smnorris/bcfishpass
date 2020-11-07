#!/bin/bash

# This script presumes:
# 1. The PGHOST, PGUSER, PGDATABASE, PGPORT environment variables are set
# 2. Password authentication for the DB is not required or password is held in .pgpass

set -euxo pipefail


# split out various barrier types into individual tables

# create table for each type of definite (not generally fixable) barrier
psql -f sql/02_barriers/01_definite/barriers_dams_major.sql
psql -f sql/02_barriers/01_definite/barriers_ditchflow.sql
psql -f sql/02_barriers/01_definite/barriers_falls.sql
psql -f sql/02_barriers/01_definite/barriers_gradient_15.sql
psql -f sql/02_barriers/01_definite/barriers_gradient_20.sql
psql -f sql/02_barriers/01_definite/barriers_gradient_30.sql
psql -f sql/02_barriers/01_definite/barriers_intermittent.sql
psql -f sql/02_barriers/01_definite/barriers_subsurfaceflow.sql

# create tables for each type anthropogenic barriers for prioritization
# (smaller dams / pscis crossings / modelled culverts / other)
psql -f sql/02_barriers/02_dams/barriers_dams_minor.sql