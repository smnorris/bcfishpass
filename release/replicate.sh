#!/bin/bash
set -euxo pipefail

# write schemas bcfishobs/bcfishpass from source db (arg1) to target db (arg2)

# note that any views dependent on fwa functions cannot currently be replicated to a db that links to FWA data through a FDW
# see fwapg issue: https://github.com/smnorris/fwapg/issues/132

psql service=$2 -c "drop schema if exists bcfishobs cascade"
psql service=$2 -c "drop schema if exists bcfishpass cascade"

pg_dump service=$1 -n bcfishobs | psql service=$2
pg_dump service=$1 -n bcfishpass | psql service=$2
