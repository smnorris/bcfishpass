#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$($PSQL -AXt -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds")

# look for species models/scenarios to be processed in the sql folder,
# all files with model_barriers prefix
MODELS=$(ls sql/model_barriers*.sql | sed -e "s/sql\/model_barriers_//" | sed -e "s/.sql//")

# -----
# LOAD STREAMS
# -----
# clear streams table and load data from FWA
$PSQL -c "truncate bcfishpass.streams"
parallel $PSQL -f sql/load_streams.sql -v wsg={1} ::: $WSGS
$PSQL -c "VACUUM ANALYZE bcfishpass.streams"


# -----
# BREAK STREAMS
# -----
# break at observations
parallel --jobs 4 --no-run-if-empty \
	"echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
	$PSQL -v wsg={1} -v point_table=observations" ::: $WSGS

# break at crossings 
parallel --jobs 4 --no-run-if-empty \
	"echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
	$PSQL -v wsg={1} -v point_table=crossings" ::: $WSGS

# break at natural barriers for all given species scenarios
for BARRIERTYPE in $MODELS
do
	parallel --jobs 4 --no-run-if-empty \
		"echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
		$PSQL -v wsg={1} -v point_table=barriers_$BARRIERTYPE" ::: $WSGS 
done

# break streams at user habitat definition endpoints
parallel --jobs 4 --no-run-if-empty \
		"echo \"SELECT bcfishpass.break_streams(:'point_table', :'wsg');\" | \
		$PSQL -v wsg={1} -v point_table=user_habitat_classification_endpoints" ::: $WSGS 

# -----
# INDEX 
# -----
# create tables holding lists of features that are downstream of individual stream segments
for BARRIERTYPE in anthropogenic pscis dams dams_hydro $MODELS
do
	$PSQL -c "drop table if exists bcfishpass.streams_barriers_"$BARRIERTYPE"_dnstr";
	$PSQL -c "create table bcfishpass.streams_barriers_"$BARRIERTYPE"_dnstr (segmented_stream_id text primary key, barriers_"$BARRIERTYPE"_dnstr text[])"
	parallel --jobs 4 --no-run-if-empty \
		"echo \"SELECT bcfishpass.load_dnstr(
		    'bcfishpass.streams', 
		    'segmented_stream_id', 
		    'bcfishpass.barriers_\"$BARRIERTYPE\"',
		    'barriers_\"$BARRIERTYPE\"_id', 
		    'bcfishpass.streams_barriers_\"$BARRIERTYPE\"_dnstr',
		    'barriers_\"$BARRIERTYPE\"_dnstr',
		    'true',
		    :'wsg');\" | \
		$PSQL -v wsg={1}" ::: $WSGS
done
# bring index tables into fresh streams table 
# (writing to new tables is much faster than processing updates)

$PSQL -f sql/model_access_output.sql



# create table holding lists of observations upstream of individual stream segments
# (this is convenience for field investigation and reporting, not an intput into the individual models)
$PSQL -c "drop table if exists bcfishpass.observations_upstr"
$PSQL -c "create table bcfishpass.observations_upstr (segmented_stream_id text primary key, obsrvtn_event_upstr bigint[], obsrvtn_species_codes_upstr text[])"
parallel --jobs 4 --no-run-if-empty $PSQL -f sql/observations_upstr.sql -v wsg={1} ::: $WSGS
