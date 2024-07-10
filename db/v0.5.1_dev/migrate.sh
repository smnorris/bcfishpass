#!/bin/bash
set -euxo pipefail


PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
