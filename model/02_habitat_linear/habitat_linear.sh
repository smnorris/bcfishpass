#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method where watershed_group_code = 'BABL'")

# add output columns
MODELS=$(ls sql/model_habitat*.sql | sed -e "s/sql\/model_habitat_//" | sed -e "s/.sql//")
for SP in $MODELS
do
  $PSQL -c "alter table bcfishpass.streams add column if not exists model_spawning_"$SP" boolean"
  $PSQL -c "alter table bcfishpass.streams add column if not exists model_rearing_"$SP" boolean"
done

# run all habitat queries per watershed group
# this could be sped up by running inserts rather than updates,
# (faster, plus allowing parallel processing), but this does not take too long
for SP in $MODELS
do
  for WSG in $WSGS
  do
	  $PSQL -f ./sql/model_habitat_$SP.sql  -v wsg=$WSG
  done
done

# apply manual/user habitat classifcation
$PSQL -f sql/user_habitat_classification.sql
