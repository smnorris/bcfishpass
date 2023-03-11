# Data replication, release, archive

- replicate data between databases
- cut data to file based releases
- archive bcfishpass database to file


## Setup

- define db services in `.pg_service.conf` as required, and ensure all databases exist and include the required extensions
- set the environment variable `$ARCHIVE` to the location where you wish to store data archives


## Replicate

Copy schemas `bcfishpass`, `bcfishobs` from source database to target database:

        ./replicate.sh <source_db_service_name> <target_db_service_name>


## Release


Dump `freshwaters_fish_habitat_accessibility_model` and associated data to file and upload to S3:
        
        ./release_access_model.sh <db_service_name>


Dump key bcfishpass tables to file for distribution:

        ./dump.sh <db_service_name>


## Archive

Dump entire database:

        pg_dump -Fc service=<db_service_name> > $ARCHIVE/bcfishpass/db/bcfishpass.$(git describe --tags --abbrev=0).$(date +%F).dump
