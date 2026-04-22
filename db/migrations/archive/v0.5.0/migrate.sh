#!/bin/bash
set -euxo pipefail


PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"


$PSQL -c "create schema bcfishpass"

for sql in sql/tables/*.sql ; do
  $PSQL -f "$sql"
done

for sql in sql/views/*.sql ; do
  $PSQL -f "$sql"
done

for sql in sql/functions/*.sql ; do
  $PSQL -f "$sql"
done

# tag the database version
# note - the tag is just a reference to note the latest script applied to a given db, there is no method for downgrades
$PSQL -c "create table bcfishpass.db_version (tag text)"
$PSQL -c "insert into bcfishpass.db_version (tag) values ('${PWD##*/}')"

# note that reports are not automatically loaded to db as they may have additional setup dependencies
# load/migrate manually as required in a given environment
#for sql in sql/reports/*.sql ; do
#  $PSQL -f "$sql"
#done
