#!/bin/bash
set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"

# upgrade to bcfishobs v0.3.0 (bcfishobs.observations, with stable pk observation_key)
# This requires dropping all relations that contain fish_observation_point_id,
# and recreating the relations with observation_key
$PSQL -f sql/observations.sql

# list observations upstream of falls/gradient barriers
$PSQL -f sql/qa_observations_naturalbarriers_ch_cm_co_pk_sk.sql


$PSQL -c "update bcfishpass.db_version set tag = '${PWD##*/}'"