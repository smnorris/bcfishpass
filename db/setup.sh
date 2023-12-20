#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# load schemas, tables functions
for sql in sql/schemas/*.sql ; do
	$PSQL -f "$sql"
done

for sql in sql/tables/*.sql ; do
	$PSQL -f "$sql"
done

for sql in sql/functions/*.sql ; do
	$PSQL -f "$sql"
done

for sql in sql/views/*.sql ; do
	$PSQL -f "$sql"
done