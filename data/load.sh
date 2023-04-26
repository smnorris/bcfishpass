#!/bin/bash
set -euxo pipefail

for table in ./*.csv; do
	psql $DATABASE_URL -v ON_ERROR_STOP=1 -c "DELETE FROM bcfishpass.$(basename -- $table .csv)";
	psql $DATABASE_URL -v ON_ERROR_STOP=1 -c "\copy bcfishpass.$(basename -- $table .csv) FROM $table delimiter ',' csv header";
done
