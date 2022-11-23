#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds where watershed_group_code")

$PSQL -c "VACUUM ANALYZE bcfishpass.streams"

# run all habitat queries per watershed group
for QUERY in ./sql/model_habitat_*.sql 
do
  for WSG in $WSGS
  do 
	  $PSQL -f $QUERY -v wsg=$WSG 
  done
done
	
# override the model where specified by manual_habitat_classification, 
# requires first creating endpoints & breaking the streams
$PSQL -f sql/user_habitat_classification_endpoints.sql

# execute per group
for WSG in $WSGS 
do 
	$PSQL -f ../model_access/sql/break_streams_wrapper.sql \
		-v wsg=$WSG \
	  -v point_table=user_habitat_classification_endpoints
done
$PSQL -f sql/user_habitat_classification.sql
