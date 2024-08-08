#!/bin/bash
set -euxo pipefail


psql $DATABASE_URL -f sql/modelled_crossing_office_review_date.sql

psql $DATABASE_URL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"