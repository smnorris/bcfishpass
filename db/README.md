# db setup / migrations

Create database schema. Note that some internal bcfishpass tables are created by scripts in /model and not defined here.

## Usage

If starting from scratch (an empty database, apart from FWA and bcfishobs), build source data schemas then run all bcfishpass migrations:

	cd sources; ./migrate.sh; cd ..
	for tag in v* ;do
	    cd "$tag"; ./migrate.sh; cd ..
	done

Or apply db migrations as required:

	cd v<tag>; ./migrate.sh

Note that the /sources folder is only separate from the tagged scripts to make setup of the testing database simple - db schema changes to source data can be applied in subsequent migrations.

## Creating migrations	

1. Add a new folder with incremented version tag
2. Within new folder, add sql file(s) as required and a `migrate.sh` script that executes all required sql

Currently, no migration tooling is used and only one way migrations are supported.
Note that tools like `squitch`, `flyway` or `alembic` could be used to make migrations safer.


## dump schema

Rather than applying all migrations, restoring from a dump works well. To create the dump:

	pg_dump -Osx --schema bcfishpass -d bcfishpass -p 5432 -U <user> > bcfishpass_v<version>.sql

And restore:

    cat bcfishpass_v<version>.sql | psql $DATABASE_URL

Ensure that a record is added that notes the version:

	psql $DATABASE_URL -c "insert into bcfishpass.db_version (tab) values ("<version");"