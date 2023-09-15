# Release

- cut data to file based releases
- archive bcfishpass database to file


## Setup

Ensure the environment variable `$DATABASE_URL` points to the database of interest


## Fish habitat accessibility model

Provincial access models for Salmon and Steelhead and additional supporting datasets are published to [freshwater_fish_habitat_accessibility_MODEL.gpkg.zip](https://bcfishpass.s3.us-west-2.amazonaws.com/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip), see [the data dictionary](https://smnorris.github.io/bcfishpass/06_data_dictionary.html) for a full list of tables and columns included.

To publish a new release:
        
        ./freshwater_fish_habitat_accessibility_model.sh


## Modelled road/rail/trail stream crossings

To ensure `modelled_crossing_id` values are consistent for users choosing to run bcfishpass scripts themselves, the master modelled crossings table is published to [modelled_stream_crossings.gpkg.zip](https://bcfishpass.s3.us-west-2.amazonaws.com/modelled_stream_crossings.gpkg.zip)

To publish a new release:

        ./modelled_stream_crossings.sh


## Archive

Archive the entire database to file in folder `$ARCHIVE/bcfishpass/db`, apending the date and commit tag date to the file name:

        mkdir -p $ARCHIVE/bcfishpass/db
        pg_dump -Fc $DATABASE_URL > $ARCHIVE/bcfishpass/db/bcfishpass.$(git describe --tags --abbrev=0).$(date +%F).dump

