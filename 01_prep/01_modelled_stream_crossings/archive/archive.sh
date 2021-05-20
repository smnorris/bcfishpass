#!/bin/bash
set -euxo pipefail

ogr2ogr \
  -f GPKG \
  modelled_stream_crossings_archive.gpkg \
  PG:"host=$PGHOST user=$PGUSER dbname=$PGDATABASE port=$PGPORT" \
  -nln modelled_stream_crossings_archive \
  -sql "SELECT modelled_crossing_id, geom FROM bcfishpass.modelled_stream_crossings"

zip -r modelled_stream_crossings_archive.gpkg.zip modelled_stream_crossings_archive.gpkg
rm modelled_stream_crossings_archive.gpkg
# publish to https://www.hillcrestgeo.ca/outgoing/fishpassage/data/bcfishpass/inputs/modelled_stream_crossings_archive.gpkg.zip