#!/bin/bash
set -euxo pipefail


# batch process valley confinemnt for all watersheds in bcfishpass.param_watersheds
WSG=`psql $DATABASE_URL -AtX -c "SELECT watershed_group_code FROM bcfishpass.param_watersheds"`


for wsg in $WSG 
do
	mkdir -p data/$wsg
	mkdir -p valleys
	# keep temp data on hand for QA
	python valley_confinement.py $wsg -o valleys/$wsg.tif -d data/$wsg -cfg valley_confinement.cfg
done
	
# merge the output valley rasters
python merge.py valleys/*tif --method max -co COMPRESS=DEFLATE -co NUM_THREADS=5 valleys.tif 

# delete the temp data
rm -rf valleys
rm -rf data