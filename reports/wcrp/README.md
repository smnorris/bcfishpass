# WCRP specific reporting

Reports in `sql` are functions designed to be served via `pg_featureserv`

To add the functions to the database:

psql -f sql/barrier_count.sql
psql -f sql/barrier_extent.sql
psql -f sql/barrier_severity.sql
psql -f sql/watershed_connectivity_status.sql