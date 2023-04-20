#!/bin/bash

set -euxo pipefail

PSQL="psql $DATABASE_URL -v ON_ERROR_STOP=1"
WSGS=$(cat wsg.txt)

# look for species models/scenarios to be processed in the sql folder,
# all files with model_access prefix
MODELS=$(ls sql/model_access*.sql | sed -e "s/sql\/model_access_//" | sed -e "s/.sql//")

# -----
# LOAD STREAMS
# -----
# clear streams table and load data from FWA
$PSQL -f sql/streams.sql
parallel $PSQL -f sql/streams_load.sql -v wsg={1} ::: $WSGS
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
$PSQL -f sql/user_habitat_classification_endpoints.sql
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
	# might as well add corresponding _dnstr column to streams table 
	$PSQL -c "alter table bcfishpass.streams add column barriers_"$BARRIERTYPE"_dnstr text[];"

done

# also record all crossings dnsr
# this is most useful for finding remediations downstream but could also
# be useful for open bottom structures?
$PSQL -c "drop table if exists bcfishpass.streams_crossings_dnstr";
$PSQL -c "create table bcfishpass.streams_crossings_dnstr (segmented_stream_id text primary key, crossings_dnstr text[])"
parallel --jobs 4 --no-run-if-empty \
    "echo \"SELECT bcfishpass.load_dnstr(
    'bcfishpass.streams',
    'segmented_stream_id',
    'bcfishpass.crossings',
    'aggregated_crossings_id',
    'bcfishpass.streams_crossings_dnstr',
    'crossings_dnstr',
    'true',
    :'wsg');\" | \
    $PSQL -v wsg={1}" ::: $WSGS
# add corresponding _dnstr column to streams table
$PSQL -c "alter table bcfishpass.streams add column crossings_dnstr text[];"


# create table holding lists of observations upstream of individual stream segments
# (this is convenience for field investigation and reporting, not an intput into the individual models)
$PSQL -c "drop table if exists bcfishpass.streams_observations_upstr"
$PSQL -c "create table bcfishpass.streams_observations_upstr (segmented_stream_id text primary key, obsrvtn_event_upstr bigint[], obsrvtn_species_codes_upstr text[])"
parallel --jobs 4 --no-run-if-empty $PSQL -f sql/streams_observations_upstr.sql -v wsg={1} ::: $WSGS
# add these columns to streams table
$PSQL -c "alter table bcfishpass.streams add column obsrvtn_event_upstr bigint[], add column obsrvtn_species_codes_upstr text[]"

# same for observations downstream
$PSQL -c "drop table if exists bcfishpass.streams_species_dnstr"
$PSQL -c "create table bcfishpass.streams_species_dnstr (segmented_stream_id text primary key, species_codes_dnstr text[])"
parallel --jobs 4 --no-run-if-empty $PSQL -f sql/streams_species_dnstr.sql -v wsg={1} ::: $WSGS
# add these columns to streams table
$PSQL -c "alter table bcfishpass.streams add column species_codes_dnstr text[]"

# now bring all access model data from _upstr _dnstr tables into streams table
$PSQL -c "drop table if exists bcfishpass.streams_model_access;"
$PSQL -c "create table bcfishpass.streams_model_access (like bcfishpass.streams including all);"
parallel $PSQL -f sql/streams_model_access.sql -v wsg={1} ::: $WSGS

# once loaded, switch new table over into bcfishpass.streams
$PSQL -c "drop table bcfishpass.streams"
$PSQL -c "alter table bcfishpass.streams_model_access rename to streams"
$PSQL -c "VACUUM ANALYZE bcfishpass.streams"

# drop the no longer needed _upstr _dnstr tables
for BARRIERTYPE in anthropogenic pscis dams dams_hydro $MODELS
do
    $PSQL -c "drop table if exists bcfishpass.streams_barriers_"$BARRIERTYPE"_dnstr";
done
$PSQL -c "drop table bcfishpass.streams_observations_upstr"
$PSQL -c "drop table bcfishpass.streams_species_dnstr"

# to be able to report on access model, there needs to be a way to differentiate
# between streams with no barrier downstream, and streams that are not modelled because
# the species is not present in the watershed group
# (simply querying on barrier_<spp>_dnstr is null does not work, values are null
# for wsg where species is not present)
# fix this by populating accessible streams with an empty array (array[]::text[])
$PSQL -f sql/access.sql
