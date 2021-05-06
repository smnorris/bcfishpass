#!/bin/bash
set -euxo pipefail

# create the table
psql -c "DROP TABLE IF EXISTS bcfishpass.manual_habitat_classification"
psql -c "CREATE TABLE bcfishpass.manual_habitat_classification
  (blue_line_key integer,
  downstream_route_measure double precision,
  upstream_route_measure double precision,
  species_code text,
  habitat_type text,
  habitat_ind boolean,
  reviewer text,
  watershed_group_code varchar(4),
  source text,
  notes text,
  PRIMARY KEY (blue_line_key, downstream_route_measure,species_code,habitat_type))"

# load the data
psql -c "\copy bcfishpass.manual_habitat_classification FROM 'data/manual_habitat_classification.csv' delimiter ',' csv header"
