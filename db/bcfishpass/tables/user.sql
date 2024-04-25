-- User submitted additions/corrections/overrides to access model

-- --------------
-- PSCIS MODELLED CROSSINGS XREF
--
-- This lookup matches PSCIS crossings to streams/modelled crossings where automated matching
-- (via smallest distance or matched name) does not match correctly
-- ***PSCIS crossings present in the lookup with no stream/modelled crossing do not get matched to a stream***
-- --------------
create table bcfishpass.pscis_modelledcrossings_streams_xref
(
  stream_crossing_id integer PRIMARY KEY,
  modelled_crossing_id integer UNIQUE,
  linear_feature_id integer,
  watershed_group_code varchar(4),
  reviewer text,
  notes text
);


-- --------------
-- MISC, ANTHROPOGENIC
--
-- user input misc anthropogenic barriers that do not fit in other tables (eg weirs)
-- Note that we want simple integer unique ids for all anthropogenic barriers that remain constant.
-- So do not autogenerate, maintain them in the csv manually for now
-- --------------
create table bcfishpass.user_barriers_anthropogenic
(
    user_barrier_anthropogenic_id integer PRIMARY KEY,
    blue_line_key integer,
    downstream_route_measure double precision,
    barrier_type text,
    barrier_name text,
    watershed_group_code varchar(4),
    reviewer_name text,
    review_date date,
    source text,
    notes text,
    UNIQUE (blue_line_key, downstream_route_measure)
);


-- --------------
-- USER_BARRIERS_DEFINITE
--
-- User added Non-falls definite barrers (exclusions, misc, other)
-- --------------
create table bcfishpass.user_barriers_definite
(
    barrier_type text,
    barrier_name text,
    blue_line_key integer,
    downstream_route_measure double precision,
    watershed_group_code varchar(4),
    reviewer_name text,
    review_date date,
    source text,
    notes text,
    primary key (blue_line_key, downstream_route_measure)
);


-- --------------
-- USER_BARRIERS_DEFINITE_CONTROL
--
-- Modify barrier status of natural features (waterfalls, gradient barriers, subsurface flow)
-- --------------
create table bcfishpass.user_barriers_definite_control
(
  blue_line_key integer,
  downstream_route_measure integer,
  barrier_type text,
  barrier_ind boolean,
  watershed_group_code text,
  reviewer_name text,
  review_date date,
  source text,
  notes text,
  primary key (blue_line_key, downstream_route_measure)
);

-- --------------
-- USER CABD EXCLUSIONS
--
-- ids of cabd dams to exclude
-- --------------
create table bcfishpass.user_cabd_dams_exclusions (
  cabd_id       text,
  reviewer_name text,
  review_date   date,
  source        text,
  notes         text,
  primary key (cabd_id)
);

-- --------------
-- USER FALLS
--
-- additional falls, from various sources
-- (not grouped in with user_barriers_definite because tracking non-barrier falls is useful)
-- --------------
create table bcfishpass.user_falls
(
  falls_name text,
  height numeric,
  barrier_ind boolean,
  blue_line_key integer,
  downstream_route_measure integer,
  watershed_group_code varchar(4),
  reviewer_name text,
  review_date date,
  source text,
  notes text,
  primary key (blue_line_key, downstream_route_measure)
 );


-- --------------
-- MANUAL HABITAT CLASSIFICATION
--
-- designate stream segments as known rearing/spawning
-- --------------
create table bcfishpass.user_habitat_classification
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
  PRIMARY KEY (blue_line_key, downstream_route_measure, upstream_route_measure, species_code, habitat_type)
);


-- --------------
-- MODELLED CROSSING FIXES
--
-- user defined override for modelled crossings that are either OBS or non-existent
-- note that this table uses modelled_crossing_id as identifier rather than blkey/measure
-- --------------
create table bcfishpass.user_modelled_crossing_fixes
(
  modelled_crossing_id integer,
  structure text,
  watershed_group_code varchar(4),
  reviewer_name text,
  review_date date,
  source text,
  notes text
);
create index on bcfishpass.user_modelled_crossing_fixes (modelled_crossing_id);


-- todo - add user_observations_qa.csv here


-- --------------
-- PSCIS BARRIER STATUS CHANGES
--
-- manual override of PSCIS status
-- --------------
create table bcfishpass.user_pscis_barrier_status
(
  stream_crossing_id integer PRIMARY KEY,
  user_barrier_status text,
  watershed_group_code varchar(4),
  reviewer_name text,
  reviewer_date date,
  notes text
);


-- --------------
-- SPECIES PRESENCE BY WATERSHED GROUP
--
-- presence/absence of target species within all BC watershed groups
-- SOURCE - CWF WCRP project area scoping (2020)
-- --------------
create table bcfishpass.wsg_species_presence
(
  watershed_group_code varchar(4),
  bt boolean,
  ch boolean,
  cm boolean,
  co boolean,
  ct boolean,
  dv boolean,
  gr boolean,
  pk boolean,
  rb boolean,
  sk boolean,
  st boolean,
  wct boolean,
  notes text
);


-- --------------------
-- KNOWN SOCKEYE LAKES
--
-- include waterbody_poly_id in this table if a given lake is/was known to support sockeye
-- source DFO conservation units via PSF
-- --------------------
create table bcfishpass.dfo_known_sockeye_lakes (
  waterbody_poly_id integer primary key
);
