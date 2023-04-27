#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.parameters_habitat_method")
MODELS=$(ls sql/test_model_habitat*.sql | sed -e "s/sql\/test_model_habitat_//" | sed -e "s/.sql//")

# run all habitat queries per watershed group
# could perhaps be run in parallel rather than looping:
# eg - parallel $PSQL -f sql/test_model_habitat_$SP.sql -v wsg={1} ::: $WSGS
# testing coho model on 'BULK','ELKR','LNIC','BOWR','QUES','CARR','LNTH','MORR','PARS','VICT':
# - parallel : ~25s
# - loop     : ~33s
for SP in $MODELS
do
  $PSQL -c "drop table if exists bcfishpass.model_habitat_"$SP
  $PSQL -c "create table bcfishpass.model_habitat_"$SP" (segmented_stream_id text primary key, spawning boolean, rearing boolean)"
  for WSG in $WSGS
  do
    $PSQL -f sql/test_model_habitat_$SP.sql -v wsg=$WSG
  done
done

## apply manual/user habitat classifcation
#$PSQL -f sql/user_habitat_classification.sql
#
## create per-species views
#for VW in $(ls sql/views/streams_*_vw.sql)
#do
#  $PSQL -f $VW
#done