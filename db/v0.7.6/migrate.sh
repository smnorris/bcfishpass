#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# barrier tables become much more dense when using 1pct intervals for gradient barriers
# speed up downstream indexing of these tables by processing load_dsntr in 
# equal size chunks (vs watershed groups) - some watershed groups are very large, aggregating
# the downstream ids for so many records takes a lot of time. Splitting in to smaller, equal
# sized chunks makes parallel processing more efficent

$PSQL -f load_dnstr_chunked.sql
$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"