# WCRP specific reporting

Reports in `sql` are functions designed to be served via `pg_featureserv`

To add the functions to the database:

psql -f sql/wcrp_barrier_count.sql
psql -f sql/wcrp_barrier_extent.sql
psql -f sql/wcrp_barrier_severity.sql
psql -f sql/wcrp_watershed_connectivity_status.sql