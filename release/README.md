# Data replication and release

- replicate key `bcfishpass` data from local dev db to local staging db
- replicate key `bcfishpass` data from local staging db to remote db
- cut data from chosen db to file based release


## Setup

Define db services in `.pg_service.conf` as required.
Ensure all databases exist and include the required extensions.

For example, to set up a staging db that reduces data duplication by using a fdw pointing to bcgw datasets on the dev db:

        psql service=bcfishpass -c "create database bcfishpass_staging"
        psql service=staging -f sql/staging_setup.sql


## Scripts

#### `replicate.sh`

Dump schemas `bcfishpass`, `bcfishobs` from source database to target database:

        ./replicate.sh <source_db_service_name> <target_db_service_name>


#### `release_access_model.sh`

Dump `freshwaters_fish_habitat_accessibility_model` and associated data to file and upload to S3:
        
        ./release_access_model.sh <source_db_service_name>


#### `dump.sh`

Dump key bcfishpass tables to file for distribution:

        ./dump.sh <source_db_service_name>


#### `archive.sh`

Dump database to postgres custom format:

        ./archive.sh <source_db_service_name>

Script dumps archive to `$BCFISHPASS_ARCHIVES/bcfishpass_<yyyy-mm-dd>`.
When appropriate, manually replace the date stamp in the file name with the bcfishpass release tag.