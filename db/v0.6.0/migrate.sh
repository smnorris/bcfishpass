#!/bin/bash
set -euxo pipefail


psql $DATABASE_URL -f sql/01_stream_views.sql
psql $DATABASE_URL -f sql/02_comments.sql
psql $DATABASE_URL -f sql/03_aw_linear_summary.sql


psql $DATABASE_URL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"