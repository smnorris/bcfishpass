#!/bin/bash
set -euxo pipefail

# dump gradient barriers to csv on s3
echo 'dump gradient barriers table to csv'
psql $DATABASE_URL --csv -c "select
    blue_line_key,
    downstream_route_measure,
    wscode_ltree as wscode,
    localcode_ltree as localcode,
    watershed_group_code,
    gradient_class
    from bcfishpass.gradient_barriers b
    where gradient_class in (5, 10, 15, 20, 25, 30)" | gzip | aws s3 cp - s3://bcfishpass/gradient_barriers.csv.gz

aws s3api put-object-acl --bucket bcfishpass --key gradient_barriers.csv.gz --acl public-read
