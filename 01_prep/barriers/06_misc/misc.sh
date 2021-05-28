#!/bin/bash

set -euxo pipefail

# load misc barriers
psql -f sql/misc_barriers.sql

# load table listing gradient barriers for removal
psql -f sql/gradient_barriers_passable.sql
psql -c "\copy bcfishpass.gradient_barriers_passable FROM 'data/gradient_barriers_passable.csv' delimiter ',' csv header"