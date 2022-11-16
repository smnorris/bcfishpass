-- --------------
-- MANUAL HABITAT CLASSIFICATION
--
-- designate stream segments as known rearing/spawning
-- --------------
DROP TABLE IF EXISTS bcfishpass.user_habitat_classification CASCADE;
CREATE TABLE bcfishpass.user_habitat_classification
(
  blue_line_key integer,
  downstream_route_measure double precision,
  upstream_route_measure double precision CHECK (upstream_route_measure > downstream_route_measure),
  watershed_group_code varchar(4),
  species_code text,
  habitat_type text,
  habitat_ind boolean,
  reviewer_name text,
  review_date date,
  source text,
  notes text,
  PRIMARY KEY (blue_line_key, downstream_route_measure, species_code, habitat_type)
);