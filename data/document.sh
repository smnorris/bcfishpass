#!/bin/bash

# document the various data and fix tables
# usage: ./document.sh > README.md
echo "# Data and fix table reference"
echo -en '\n'

# value added tables
for table in cabd_additions \
  cabd_blkey_xref \
  cabd_exclusions \
  cabd_passability_status_updates \
  observation_exclusions \

do
    echo "## $table"
    echo -en '\n'
    psql $DATABASE_URL -AtX -P border=0,footer=no -c "\dt+ bcfishpass.$table" | awk -F"|" '{print $8}'
    echo -en '\n'
    echo "| Column | Type | Description |"
    echo "|--------|------|-------------|"
    psql $DATABASE_URL -AtX -P border=0,footer=no -c "\d+ bcfishpass.$table" | awk -F"|" '{ print "| `"$1"` | `"$2"` | "$9" |"}'
    echo -en '\n'
done