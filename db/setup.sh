#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# load schemas, tables functions
for sql in schemas/*.sql ; do
  $PSQL -f "$sql"
done

for sql in tables/*.sql ; do
  $PSQL -f "$sql"
done

for sql in views/*.sql ; do
  $PSQL -f "$sql"
done

for sql in functions/*.sql ; do
  $PSQL -f "$sql"
done