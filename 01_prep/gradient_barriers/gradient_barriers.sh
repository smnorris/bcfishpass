#!/bin/bash
set -euxo pipefail

# create the table
psql -c "DROP TABLE IF EXISTS bcfishpass.gradient_barriers_test"
psql -c "CREATE TABLE bcfishpass.gradient_barriers_test
        (
         blue_line_key             integer               ,
         downstream_route_measure  double precision      ,
         gradient_class            integer               ,
         UNIQUE (blue_line_key, downstream_route_measure)
        )"

# Load as loop through watershed groups
for WSG in $(psql -t -P border=0,footer=no \
  -c "SELECT watershed_group_code
      FROM whse_basemapping.fwa_watershed_groups_poly
      WHERE watershed_group_code IN ('VICT','COWN','SANJ','SQAM','LARL','KOTL','ADMS','LNIC','BULK','HORS','ELKR')
      ORDER BY watershed_group_code")
do
  psql -X -v wsg="$WSG" < sql/gradient_barriers.sql
done

psql -c "CREATE INDEX ON bcfishpass.gradient_barriers_test (blue_line_key)"
psql -c "CREATE INDEX ON bcfishpass.gradient_barriers_test (blue_line_key, downstream_route_measure)"


# for qa
# psql -c "Drop table if exists temp.gradient_barriers_test ;
#
# create table temp.gradient_barriers_test
    # (id serial primary key,
        # gradient_class integer,
        # watershed_group_code text,
        # geom geometry(point, 3005));
#
# insert into temp.gradient_barriers_test
# (gradient_class, watershed_group_code, geom)
# SELECT
 # g.gradient_class,
 # s.watershed_group_code,
 # ST_Force2D((ST_Dump(ST_Locatealong(s.geom, g.downstream_route_measure))).geom)::geometry(Point,3005) as geom
 # FROM bcfishpass.gradient_barriers_test g
# INNER JOIN whse_basemapping.fwa_stream_networks_sp s
  # ON g.blue_line_key = s.blue_line_key AND
     # g.downstream_route_measure >= s.downstream_route_measure AND
     # g.downstream_route_measure < s.upstream_route_measure
  # WHERE s.watershed_group_code in ('VICT','COWN','SANJ','SQAM','LARL','KOTL','ADMS','LNIC','BULK','HORS','ELKR');
#
# create index on temp.gradient_barriers_test USING gist (geom);"
#
