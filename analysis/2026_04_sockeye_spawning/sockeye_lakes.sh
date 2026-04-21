# create table temp.sockeye_lakes, lks > 2km2 and/or identified as sockeye CU
psql $DATABASE_URL -f sockeye_lakes.sql  

# create table holding sockeye observations upstream of these lakes
psql $DATABASE_URL -f sockeye_pts.sql

# for each observation, note all potential rearing lakes downstream
psql $DATABASE_URL -c "drop table if exists temp.sockeye_pts_lakes_dnstr; create table temp.sockeye_pts_lakes_dnstr (observation_key text, features_dnstr text[])"
psql $DATABASE_URL -c "select bcfishpass.load_dnstr_chunked(
	'temp.sockeye_pts'::text, 
	'observation_key'::text, 
	'temp.sockeye_lakes'::text, 
	'waterbody_key'::text, 
	'temp.sockeye_pts_lakes_dnstr'::text,
	'features_dnstr'::text, 
	'false'::text, 
	2000, 
	0)"

# create a table of traces from the observations of interest to the next sockeye rearing lake downstream
psql $DATABASE_URL -f sockeye_pts_lakes_traces.sql

ogr2ogr \
  -f GPKG \
  sockeye_lakes.gpkg.zip \
  PG:$DATABASE_URL \
  -sql "select * from temp.sockeye_lakes" \
  -nln sockeye_lakes

ogr2ogr \
  -f GPKG \
  sockeye_pts.gpkg.zip \
  PG:$DATABASE_URL \
  -sql "select * from temp.sockeye_pts" \
  -nln sockeye_pts    

ogr2ogr \
  -f GPKG \
  sockeye_dnstr_traces.gpkg.zip \
  PG:$DATABASE_URL \
  -sql "select * from temp.sockeye_pts_lake_traces" \
  -nln sockeye_dnstr_traces


psql $DATABASE_URL -c "SELECT observation_key, waterbody_key, round((sum(st_length(geom)) / 1000)::numeric, 2) as length_km from temp.sockeye_pts_lake_traces group by observation_key, waterbody_key" --csv > sockeye_dnstr_trace_lengths.csv