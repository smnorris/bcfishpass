#!/bin/bash
set -euxo pipefail

# dump master modelled stream crossings (for id stability)
# to file and publish to s3
rm -f modelled_stream_crossings.gpkg*
ogr2ogr \
	-f GPKG \
	modelled_stream_crossings.gpkg \
	PG:$DATABASE_URL \
	-nlt PointZM \
	-nln modelled_stream_crossings \
	-sql "select \
		 modelled_crossing_id, \
		 modelled_crossing_type, \
		 array_to_string(modelled_crossing_type_source, '; ') as modelled_crossing_type_source, \
		 transport_line_id, \
		 ften_road_section_lines_id, \
		 og_road_segment_permit_id, \
		 og_petrlm_dev_rd_pre06_pub_id, \
		 railway_track_id, \
		 linear_feature_id, \
		 blue_line_key, \
		 downstream_route_measure, \
		 wscode_ltree, \
		 localcode_ltree, \
		 watershed_group_code, \
		 geom \
		from bcfishpass.modelled_stream_crossings"
zip -r modelled_stream_crossings.gpkg.zip modelled_stream_crossings.gpkg
rm modelled_stream_crossings.gpkg


aws s3 cp modelled_stream_crossings.gpkg.zip s3://bcfishpass/
# in case the file is corrupted, also create a backup copy
aws s3 cp modelled_stream_crossings.gpkg.zip s3://bcfishpass/modelled_stream_crossings.gpkg.zip.$(date +%F)
aws s3api put-object-acl --bucket bcfishpass --key modelled_stream_crossings.gpkg.zip --acl public-read
rm -f modelled_stream_crossings.gpkg*

echo "Latest modelled crossings data now available at:"
echo "https://bcfishpass.s3.us-west-2.amazonaws.com/modelled_stream_crossings.gpkg.zip"