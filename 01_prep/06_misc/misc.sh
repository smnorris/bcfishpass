#!/bin/bash

set -euxo pipefail

# load misc barriers
psql -f sql/misc_barriers_definite.sql
psql -c "\copy bcfishpass.misc_barriers_definite FROM 'data/misc_barriers_definite.csv' delimiter ',' csv header"

psql -f sql/misc_barriers_anthropogenic.sql
psql -c "\copy bcfishpass.misc_barriers_anthropogenic FROM 'data/misc_barriers_anthropogenic.csv' delimiter ',' csv header"

# load table listing gradient barriers for removal
psql -f sql/gradient_barriers_passable.sql
psql -c "\copy bcfishpass.gradient_barriers_passable FROM 'data/gradient_barriers_passable.csv' delimiter ',' csv header"