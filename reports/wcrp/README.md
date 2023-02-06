# WCRP specific reporting

Reports in `sql` are functions designed to be served via `pg_featureserv`

## Add functions to the database

    psql -f sql/wcrp_barrier_count.sql
    psql -f sql/wcrp_barrier_extent.sql
    psql -f sql/wcrp_barrier_severity.sql
    psql -f sql/wcrp_watershed_connectivity_status.sql


## Ensure things are working as expected

    psql -c "select postgisftw.wcrp_barrier_count('HORS')"
    psql -c "select postgisftw.wcrp_barrier_extent('HORS')"
    psql -c "select postgisftw.wcrp_barrier_severity('HORS')"
    psql -c "select postgisftw.wcrp_watershed_connectivity_status('HORS')"