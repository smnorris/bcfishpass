#!/bin/bash

set -euxo pipefail

# load misc barriers and exclusions
psql -f sql/misc_barriers.sql

