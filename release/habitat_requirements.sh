#!/bin/bash
set -euxo pipefail

# dump intermediate data and post to s3
# (removing need to compute discharge/channel width requrements
# enables bcfishpass processing on memory limited systems)
for table in channel_width discharge mean_annual_precip
do
    psql $DATABASE_URL -v ON_ERROR_STOP=1 --csv -c "select * from bcfishpass.$table" > $table.csv
    aws s3 cp $table.csv s3://bcfishpass/
    aws s3api put-object-acl --bucket bcfishpass --key $table.csv --acl public-read
    rm $table.csv
done