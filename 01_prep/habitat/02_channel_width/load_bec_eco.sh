#!/bin/bash
set -euxo pipefail

bc2pg WHSE_TERRESTRIAL_ECOLOGY.ERC_ECOSECTIONS_SP --promote_to_multi
bc2pg WHSE_FOREST_VEGETATION.BEC_BIOGEOCLIMATIC_POLY --promote_to_multi
psql -f sql/load_bec_eco.sql
