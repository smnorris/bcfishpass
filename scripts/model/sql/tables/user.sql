-- create data tables for user submitted corrections/overrides of model outputs

-- --------------
-- EXCLUSIONS
--
-- do not model stream above these points. Examples:
-- - streams that do not exist, areas not to be reported on
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.exclusions
(
    blue_line_key integer,
    downstream_route_measure double precision,
    barrier_name text,
    watershed_group_code text,
    reviewer text,
    notes text,
    primary key (blue_line_key, downstream_route_measure)
);

-- --------------
-- FALLS BARRIER IND
--
-- lookup that controls barrier status for FISS falls
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.falls_barrier_ind
(
  blue_line_key              integer,
  downstream_route_measure    integer,
  barrier_ind                 boolean,
  watershed_group_code        text,
  reviewer                    text,
  notes                       text,
  primary key (blue_line_key, downstream_route_measure)
);

-- --------------
-- FALLS OTHER
--
-- additional falls, from various sources
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.falls_other
(
  blue_line_key integer,
  downstream_route_measure integer,
  barrier_ind boolean,
  height numeric,
  watershed_group_code text,
  source text,
  reviewer text,
  notes text,
  primary key (blue_line_key, downstream_route_measure)
 );

-- --------------
-- GRADIENT BARRIERS - PASSABLE
--
-- table to control removal of barriers that are result of FWA data errors
-- or have been shown to pass fish
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.gradient_barriers_passable
(
  blue_line_key integer,
  downstream_route_measure double precision,
  watershed_group_code text,
  reviewer text,
  notes text,
  PRIMARY KEY (blue_line_key, downstream_route_measure)
);

-- --------------
-- MANUAL HABITAT CLASSIFICATION
--
-- designate stream segments as known rearing/spawning
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.manual_habitat_classification
(
  blue_line_key integer,
  downstream_route_measure double precision,
  upstream_route_measure double precision CHECK (upstream_route_measure > downstream_route_measure),
  species_code text,
  habitat_type text,
  habitat_ind boolean,
  reviewer text,
  watershed_group_code varchar(4),
  source text,
  notes text,
  PRIMARY KEY (blue_line_key, downstream_route_measure,species_code, habitat_type)
);

-- --------------
-- MISC, ANTHROPOGENIC
--
-- user input misc anthropogenic barriers that do not fit in other tables (eg weirs)
-- Note that we want simple integer unique ids for all anthropogenic barriers that remain constant.
-- So do not autogenerate, maintain them in the csv manually for now
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.misc_barriers_anthropogenic
(
    misc_barrier_anthropogenic_id integer primary key,
    blue_line_key integer,
    downstream_route_measure double precision,
    barrier_type text,
    barrier_name text,
    watershed_group_code text,
    reviewer text,
    notes text,
    UNIQUE (blue_line_key, downstream_route_measure)
);

-- --------------
-- MISC, DEFINITE
--
-- user input misc definite barriers (ie, natural, non-falls barriers)
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.misc_barriers_definite
(
    blue_line_key integer,
    downstream_route_measure double precision,
    barrier_name text,
    watershed_group_code text,
    reviewer text,
    notes text,
    PRIMARY KEY (blue_line_key, downstream_route_measure)
);

-- --------------
-- MODELLED STREAM CROSSING FIXES
--
-- user defined override for modelled crossings that are either OBS or non-existent
-- note that this table uses modelled_crossing_id as identifier rather than blkey/measure
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.modelled_stream_crossings_fixes
(
  modelled_crossing_id integer,
  reviewer text,
  watershed_group_code text,
  structure text,
  notes text
);
CREATE INDEX ON bcfishpass.modelled_stream_crossings_fixes (modelled_crossing_id);

-- --------------
-- PSCIS MODELLED CROSSINGS XREF
--
-- This lookup matches PSCIS crossings to streams/modelled crossings where automated matching
-- (via smallest distance or matched name) does not match correctly
-- ***PSCIS crossings present in the lookup with no stream/modelled crossing do not get matched to a stream***
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.pscis_modelledcrossings_streams_xref
(
  stream_crossing_id integer PRIMARY KEY,
  modelled_crossing_id integer UNIQUE,
  linear_feature_id integer,
  watershed_group_code text,
  reviewer text,
  notes text
);

-- --------------
-- PSCIS BARRIER RESULT FIXES
--
-- manual override of PSCIS status - notes OBS barriers, non-accessible streams etc
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.pscis_barrier_result_fixes
(
  stream_crossing_id integer PRIMARY KEY,
  updated_barrier_result_code text,
  watershed_group_code text,
  reviewer text,
  notes text
);

-- --------------
-- SPECIES PRESENCE BY WATERSHED GROUP
--
-- presence/absence of target species within all BC watershed groups
-- SOURCE - CWF WCRP project area scoping (2020)
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.wsg_species_presence
(
  watershed_group_code varchar(4),
  ch boolean,
  co boolean,
  sk boolean,
  st boolean,
  wct boolean,
  bt boolean,
  gr boolean,
  rb boolean,
  notes text
);