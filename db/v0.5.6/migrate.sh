#!/bin/bash
set -euxo pipefail


psql $DATABASE_URL -f sql/wcrp_habitat_connectivity_status_vw.sql

psql $DATABASE_URL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"