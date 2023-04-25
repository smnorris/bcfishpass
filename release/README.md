# Release

- cut data to file based releases
- archive bcfishpass database to file


## Setup

- ensure the environment variable `$DATABASE_URL` points to your database of interest
- set the environment variable `$ARCHIVE` to the location where you wish to store archive files


## Modelled road/rail/trail stream crossings

To ensure `modelled_crossing_id` values are consistent for all users, the source modelled crossings table is published to https://bcfishpass.s3.us-west-2.amazonaws.com/modelled_stream_crossings.gpkg.zip

To publish a new release:

        ./modelled_stream_crossings.sh


## Fish habitat accessibility model

Provincial access models for Salmon and Steelhead are available as https://bcfishpass.s3.us-west-2.amazonaws.com/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip

To publish a new release::
        
        ./freshwater_fish_habitat_accessibility_model.sh


## Archive

Archive the entire database to file, apending the date and commit tag date to the file name:

        pg_dump -Fc $DATABASE_URL > $ARCHIVE/bcfishpass/db/bcfishpass.$(git describe --tags --abbrev=0).$(date +%F).dump
