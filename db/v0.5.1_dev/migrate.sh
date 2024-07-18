#!/bin/bash
set -euxo pipefail



psql $DATABASE_URL -f sql/wcrp_crossings_vw.sql