-- migrate relations in the bcfishpass database to achieve 3 things:

-- 1. remove all views that use FWA functions
--   For pg 17 and greater, fwa functions cannot effectively be used in views
--   - for views where upstr/dnstr not needed, remove the funcs & corresponding columns
--   - for views where upstr/dnstr *are* needed, redefine as tables

-- 2. reduce (or remove) cascading view dependencies
--   Nested views make maintenance/changes very awkward, if several views depend on
--   crossings_vw materialized view, crossings_vw cannot be changed without dropping
--   and recreating the dependent views
--   nevermore: https://www.cybertec-postgresql.com/en/tracking-view-dependencies-in-postgresql/

-- 3. use updated bcfishobs.observations
--   bcfishobs v0.3.0 simplifies the output table and introduces a stable key observation_key,
--   use these in bcfishpass instead of fish_observation_point_id (unstable)


-- List of views to consider
-- ------------------------------------------------------------------------------
-- x crossings_dnstr_observations_vw                          | materialized view
-- x crossings_upstr_observations_vw                          | materialized view
-- x crossings_vw                                             | materialized view
-- x crossings_wcrp_vw                                        | materialized view
-- x dams_vw                                                  | materialized view
-- x falls_upstr_anadromous_vw                                | materialized view
-- x fptwg_summary_crossings_vw                               | materialized view
-- x freshwater_fish_habitat_accessibility_model_crossings_vw | view
-- freshwater_fish_habitat_accessibility_model_vw             | view
-- x observations_vw                                          | materialized view
-- ok streams_access_vw                                       | materialized view
-- streams_habitat_known_vw                                   | materialized view
-- streams_habitat_linear_vw                                  | materialized view
-- streams_mapping_code_vw                                    | materialized view
-- wcrp_barrier_count_vw                                      | view
-- wcrp_habitat_connectivity_status_vw                        | view
-- wsg_crossing_summary_current                               | view
-- wsg_crossing_summary_diff                                  | view
-- wsg_crossing_summary_previous                              | view
-- wsg_linear_summary_current                                 | view
-- wsg_linear_summary_diff                                    | view
-- wsg_linear_summary_previous                                | view


BEGIN;

-- =================================================================
-- TEARDOWN
-- =================================================================

DROP VIEW bcfishpass.streams_bt_vw;
DROP VIEW bcfishpass.streams_ch_vw;
DROP VIEW bcfishpass.streams_cm_vw;
DROP VIEW bcfishpass.streams_co_vw;
DROP VIEW bcfishpass.streams_pk_vw;
DROP VIEW bcfishpass.streams_salmon_vw;
DROP VIEW bcfishpass.streams_sk_vw;
DROP VIEW bcfishpass.streams_st_vw;
DROP VIEW bcfishpass.streams_wct_vw;
DROP VIEW bcfishpass.streams_vw;

DROP materialized view bcfishpass.streams_mapping_code_vw;  -- recreated as table
DROP VIEW bcfishpass.wcrp_habitat_connectivity_status_vw;

DROP MATERIALIZED VIEW bcfishpass.crossings_wcrp_vw;
DROP VIEW bcfishpass.wcrp_barrier_count_vw;
DROP MATERIALIZED VIEW bcfishpass.fptwg_summary_crossings_vw;
DROP VIEW IF EXISTS bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw; -- not recreated, now in dump script
DROP VIEW bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw; -- not recreated, now lives in dump script
DROP VIEW bcfishpass.freshwater_fish_habitat_accessibility_model_vw;

DROP MATERIALIZED VIEW bcfishpass.crossings_vw;
DROP MATERIALIZED VIEW bcfishpass.crossings_upstr_barriers_per_model_vw; -- recreated as table
DROP MATERIALIZED VIEW bcfishpass.crossings_dnstr_observations_vw; -- recreated as table
DROP MATERIALIZED VIEW bcfishpass.crossings_upstr_observations_vw; -- recreated as table
DROP VIEW bcfishpass.crossings_feature_type_vw;              -- not recreated

DROP VIEW bcfishpass.dams_not_matched_to_streams;
DROP VIEW bcfishpass.falls_not_matched_to_streams;
DROP MATERIALIZED VIEW bcfishpass.falls_upstr_anadromous_vw; -- not recreated
DROP MATERIALIZED VIEW bcfishpass.dams_vw;                   -- recreated as table (plus a wrapper view)
DROP MATERIALIZED VIEW bcfishpass.falls_vw;                  -- recreated as table (plus a wrapper view)
-- DROP MATERIALIZED VIEW bcfishpass.obsrvtn_above_barriers_ch_cm_co_pk_sk_st; -- not recreated

DROP MATERIALIZED VIEW bcfishpass.streams_access_vw;         -- recreated as table
DROP MATERIALIZED VIEW bcfishpass.streams_habitat_linear_vw; -- recreated as table
DROP MATERIALIZED VIEW bcfishpass.streams_habitat_known_vw; -- recreated as table

DROP TABLE bcfishpass.streams_upstr_observations;            -- recreated with new observation key

DROP MATERIALIZED VIEW bcfishpass.observations_vw;           -- recreated as table (plus a wrapper view)



-- =================================================================
-- REBUILD
-- =================================================================
--  - in opposite order as dropped
--  - prefer tables over views where downstream views are present
--  - use new observation_key
--

-- for simplicity, make observations a direct copy of bcfishobs.observations
CREATE TABLE bcfishpass.observations (LIKE bcfishobs.observations INCLUDING ALL);

-- salmon observation with modelled barriers downstream

CREATE TABLE bcfishpass.qa_observations_ch_cm_co_pk_sk (
  observation_key             text primary key       ,
  species_code                character varying(6)   ,
  observation_date            date                   ,
  activity_code               character varying(100) ,
  activity                    character varying(300) ,
  life_stage_code             character varying(100) ,
  life_stage                  character varying(300) ,
  acat_report_url             character varying(254) ,
  agency_name                 character varying(60)  ,
  source                      character varying(1000),
  source_ref                  character varying(4000),
  watershed_group_code        character varying(4)   ,
  gradient_15_dnstr           text                   ,
  gradient_20_dnstr           text                   ,
  gradient_25_dnstr           text                   ,
  gradient_30_dnstr           text                   ,
  falls_dnstr                 text                   ,
  subsurfaceflow_dnstr        text                   ,
  gradient_15_dnstr_count     integer                ,
  gradient_20_dnstr_count     integer,
  gradient_25_dnstr_count     integer,
  gradient_30_dnstr_count     integer,
  falls_dnstr_count           integer,
  subsurfaceflow_dnstr_count  integer
);

-- natural barriers to salmon with salmon observations upstream
CREATE TABLE bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk (
  barrier_id           text primary key,
  barrier_type         text,
  watershed_group_code text,
  observations_upstr   text,
  n_observations_upstr integer
);

CREATE TABLE bcfishpass.streams_upstr_observations (
  segmented_stream_id text primary key,
  observation_key_upstr text[],
  obsrvtn_species_codes_upstr text[]
);

-- access status becomes a table, with new text observation_key column
CREATE TABLE bcfishpass.streams_access (
   segmented_stream_id           text primary key,
   barriers_anthropogenic_dnstr  text[]   ,
   barriers_pscis_dnstr          text[]   ,
   barriers_dams_dnstr           text[]   ,
   barriers_dams_hydro_dnstr     text[]   ,
   barriers_bt_dnstr             text[]   ,
   barriers_ch_cm_co_pk_sk_dnstr text[]   ,
   barriers_ct_dv_rb_dnstr       text[]   ,
   barriers_st_dnstr             text[]   ,
   barriers_wct_dnstr            text[]   ,
   access_bt                     integer  ,
   access_ch                     integer  ,
   access_cm                     integer  ,
   access_co                     integer  ,
   access_pk                     integer  ,
   access_sk                     integer  ,
   access_salmon                 integer  ,
   access_ct_dv_rb               integer  ,
   access_st                     integer  ,
   access_wct                    integer  ,
   observation_key_upstr         text[] ,
   obsrvtn_species_codes_upstr   text[]   ,
   species_codes_dnstr           text[]   ,
   crossings_dnstr               text[]   ,
   remediated_dnstr_ind          boolean  ,
   dam_dnstr_ind                 boolean  ,
   dam_hydro_dnstr_ind           boolean
);

-- they are not affected by the observation key change, but we might as well
-- switch habitat data from mvw to tables while making all these other changes
CREATE TABLE bcfishpass.streams_habitat_linear (
  segmented_stream_id text primary key,
  spawning_bt         integer ,
  spawning_ch         integer ,
  spawning_cm         integer ,
  spawning_co         integer ,
  spawning_pk         integer ,
  spawning_sk         integer ,
  spawning_st         integer ,
  spawning_wct        integer ,
  rearing_bt          integer ,
  rearing_ch          integer ,
  rearing_co          integer ,
  rearing_sk          integer ,
  rearing_st          integer ,
  rearing_wct         integer
);

CREATE TABLE bcfishpass.streams_habitat_known (
  segmented_stream_id text primary key,
  spawning_bt         boolean ,
  spawning_ch         boolean ,
  spawning_cm         boolean ,
  spawning_co         boolean ,
  spawning_pk         boolean ,
  spawning_sk         boolean ,
  spawning_st         boolean ,
  spawning_wct        boolean ,
  rearing_bt          boolean ,
  rearing_ch          boolean ,
  rearing_co          boolean ,
  rearing_sk          boolean ,
  rearing_st          boolean ,
  rearing_wct         boolean
);

CREATE TABLE bcfishpass.streams_mapping_code (
  segmented_stream_id text primary key,
  mapping_code_bt     text,
  mapping_code_ch     text,
  mapping_code_cm     text,
  mapping_code_co     text,
  mapping_code_pk     text,
  mapping_code_sk     text,
  mapping_code_st     text,
  mapping_code_wct    text,
  mapping_code_salmon text
);

-- regenerate the various streams views
CREATE VIEW bcfishpass.streams_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_bt_dnstr, ';') as barriers_bt_dnstr,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.barriers_ct_dv_rb_dnstr, ';') as barriers_ct_dv_rb_dnstr,
  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_bt,
  a.access_ch,
  a.access_cm,
  a.access_co,
  a.access_pk,
  a.access_sk,
  a.access_st,
  a.access_wct,
  a.access_salmon,
  case when a.access_bt = -9 then -9 else h.spawning_bt end as spawning_bt,
  case when a.access_ch = -9 then -9 else h.spawning_ch end as spawning_ch,
  case when a.access_cm = -9 then -9 else h.spawning_cm end as spawning_cm,
  case when a.access_co = -9 then -9 else h.spawning_co end as spawning_co,
  case when a.access_pk = -9 then -9 else h.spawning_pk end as spawning_pk,
  case when a.access_sk = -9 then -9 else h.spawning_sk end as spawning_sk,
  case when a.access_st = -9 then -9 else h.spawning_st end as spawning_st,
  case when a.access_wct = -9 then -9 else h.spawning_wct end as spawning_wct,
  case when a.access_bt = -9 then -9 else h.rearing_bt end as rearing_bt,
  case when a.access_ch = -9 then -9 else h.rearing_ch end as rearing_ch,
  case when a.access_co = -9 then -9 else h.rearing_co end as rearing_co,
  case when a.access_sk = -9 then -9 else h.rearing_sk end as rearing_sk,
  case when a.access_st = -9 then -9 else h.rearing_st end as rearing_st,
  case when a.access_wct = -9 then -9 else h.rearing_wct end as rearing_wct,
  m.mapping_code_bt,
  m.mapping_code_ch,
  m.mapping_code_cm,
  m.mapping_code_co,
  m.mapping_code_pk,
  m.mapping_code_sk,
  m.mapping_code_st,
  m.mapping_code_wct,
  m.mapping_code_salmon,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id;

-- remove dependency on streams_vw from per-species views
-- not a big deal at this point but nice if more species are added
CREATE VIEW bcfishpass.streams_bt_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_bt_dnstr, ';') as barriers_bt_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_bt as access,
  case when a.access_bt = -9 then -9 else h.spawning_bt end as spawning,
  case when a.access_bt = -9 then -9 else h.rearing_bt end as rearing,
  m.mapping_code_bt as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where a.access_bt > 0;


create view bcfishpass.streams_ch_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_ch as access,
  case when a.access_ch = -9 then -9 else h.spawning_ch end as spawning,
  case when a.access_ch = -9 then -9 else h.rearing_ch end as rearing,
  m.mapping_code_ch as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_ch > 0;


create view bcfishpass.streams_cm_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_cm as access,
  case when a.access_cm = -9 then -9 else h.spawning_cm end as spawning,
  m.mapping_code_cm as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_cm > 0;

create view bcfishpass.streams_co_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_co as access,
  case when a.access_co = -9 then -9 else h.spawning_co end as spawning,
  case when a.access_co = -9 then -9 else h.rearing_co end as rearing,
  m.mapping_code_co as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_co > 0;


create view bcfishpass.streams_pk_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_pk,
  case when a.access_pk = -9 then -9 else h.spawning_pk end as spawning,
  m.mapping_code_pk as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_pk > 0;


create view bcfishpass.streams_salmon_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_salmon as access,
  greatest(spawning_ch, spawning_cm, spawning_co, spawning_pk, spawning_sk) as spawning,
  greatest(rearing_ch, rearing_co, rearing_sk) as rearing,
  m.mapping_code_salmon as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_salmon > 0;


create view bcfishpass.streams_sk_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_sk as access,
  case when a.access_sk = -9 then -9 else h.spawning_sk end as spawning,
  case when a.access_sk = -9 then -9 else h.rearing_sk end as rearing,
  m.mapping_code_sk as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_sk > 0;

create view bcfishpass.streams_st_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_st as access,
  case when a.access_st = -9 then -9 else h.spawning_st end as spawning,
  case when a.access_st = -9 then -9 else h.rearing_st end as rearing,
  m.mapping_code_st as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_st > 0;


create view bcfishpass.streams_wct_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_wct as access,
  case when a.access_wct = -9 then -9 else h.spawning_wct end as spawning,
  case when a.access_wct = -9 then -9 else h.rearing_wct end as rearing,
  m.mapping_code_wct as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_wct > 0;


-- FPTWG view is unchanged at this point but needs to be re-created
create view bcfishpass.freshwater_fish_habitat_accessibility_model_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.downstream_route_measure,
  s.upstream_route_measure,
  s.watershed_group_code,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.feature_code,
  case
    when access_salmon = 2 then 'OBSERVED'
    when access_salmon = 1 then 'INFERRED'
    when access_salmon = 0 then 'NATURAL_BARRIER'
    else NULL
  end as model_access_salmon,
  case
    when access_st = 2 then 'OBSERVED'
    when access_st = 1 then 'INFERRED'
    when access_st = 0 then 'NATURAL_BARRIER'
    else NULL
  end as model_access_steelhead,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id;

-- dams becomes a table
-- don't bother including anad. observ upstr of dams, this can be a separate report
CREATE TABLE bcfishpass.dams (
 dam_id                     text   primary key   ,
 linear_feature_id          bigint               ,
 blue_line_key              integer              ,
 downstream_route_measure   double precision     ,
 wscode_ltree               ltree                ,
 localcode_ltree            ltree                ,
 distance_to_stream         double precision     ,
 watershed_group_code       character varying(4) ,
 dam_name_en                text                 ,
 height_m                   double precision     ,
 owner                      text                 ,
 dam_use                    text                 ,
 operating_status           text                 ,
 passability_status_code    integer              ,
 geom                       geometry(Point, 3005)
);
CREATE INDEX ON bcfishpass.dams using gist (geom);

-- make falls a table too
CREATE TABLE bcfishpass.falls (
 falls_id                 text  primary key    ,
 linear_feature_id        bigint               ,
 blue_line_key            integer              ,
 downstream_route_measure double precision     ,
 wscode_ltree             ltree                ,
 localcode_ltree          ltree                ,
 distance_to_stream       double precision     ,
 watershed_group_code     character varying(4) ,
 falls_name               text                 ,
 height_m                 double precision     ,
 barrier_ind              boolean              ,
 geom                     geometry(Point,3005)
);
CREATE INDEX ON bcfishpass.falls using gist (geom);


-- dams/falls not matched to streams are still views (used for qa)
CREATE VIEW bcfishpass.dams_not_matched_to_streams AS
SELECT
  a.cabd_id,
  a.dam_name_en
FROM cabd.dams a
LEFT OUTER JOIN bcfishpass.dams b
ON a.cabd_id::text = b.dam_id
WHERE b.dam_id is null
ORDER BY a.cabd_id;

-- a view of falls that do not get matched to streams
create view bcfishpass.falls_not_matched_to_streams as
select
  a.cabd_id,
  a.fall_name_en
from cabd.waterfalls a
left outer join bcfishpass.falls b
on a.cabd_id::text = b.falls_id
where b.falls_id is null
order by a.cabd_id;

-- tables for noting species upstr/dnstr of crossings
CREATE TABLE bcfishpass.crossings_upstr_observations (
  aggregated_crossings_id text primary key,
  observedspp_upstr text[]
);

CREATE TABLE bcfishpass.crossings_dnstr_observations (
  aggregated_crossings_id text primary key,
  observedspp_dnstr text[]
);

CREATE TABLE bcfishpass.crossings_upstr_barriers_per_model (
 aggregated_crossings_id       text   ,
 barriers_upstr_bt             text[] ,
 barriers_upstr_ch_cm_co_pk_sk text[] ,
 barriers_upstr_ct_dv_rb       text[] ,
 barriers_upstr_st             text[] ,
 barriers_upstr_wct            text[]
);


-- rather than create a view that defines crossing feature type, encode it
-- directly in the crossings table
ALTER TABLE bcfishpass.crossings
ADD COLUMN crossing_feature_type text;


-- use crossing_feature_type directly in wcrp views
-- wcrp barrier count
CREATE VIEW bcfishpass.wcrp_barrier_count_vw as
with model_status as (
select
   c.aggregated_crossings_id,
   case
   when
    ((h.ch_spawning_km > 0 or h.ch_rearing_km > 0) and w.ch IS TRUE) or
    ((h.co_spawning_km > 0 or h.co_rearing_km > 0) and w.co IS TRUE) or
    ((h.sk_spawning_km > 0 or h.sk_rearing_km > 0) and w.sk IS TRUE) or
    ((h.st_spawning_km > 0 or h.st_rearing_km > 0) and w.st IS TRUE) or
    ((h.wct_spawning_km > 0 or h.wct_rearing_km > 0) and w.wct IS TRUE)
   then 'HABITAT'
   when
  (w.ch IS TRUE and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) or
  (w.co IS TRUE and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) or
  (w.sk IS TRUE and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) or
  (w.st IS TRUE and cardinality(a.barriers_st_dnstr) = 0) or
  (w.wct IS TRUE and cardinality(a.barriers_wct_dnstr) = 0)
   then 'ACCESSIBLE'
   else 'NATURAL_BARRIER'
   end as model_status
FROM bcfishpass.crossings c
left outer join bcfishpass.crossings_upstream_access a
on c.aggregated_crossings_id = a.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat h
on c.aggregated_crossings_id = h.aggregated_crossings_id
left outer join bcfishpass.wcrp_watersheds w
on c.watershed_group_code = w.watershed_group_code
)

SELECT
    c.watershed_group_code,
    ms.model_status,
    c.crossing_feature_type,
    count(*) filter (where c.barrier_status = 'PASSABLE') as n_passable,
    count(*) filter (where c.barrier_status = 'BARRIER') as n_barrier,
    count(*) filter (where c.barrier_status = 'POTENTIAL') as n_potential,
    count(*) filter (where c.barrier_status = 'UNKNOWN') as n_unknown,
    count(*) as total
FROM bcfishpass.crossings c
left outer join model_status ms
on c.aggregated_crossings_id = ms.aggregated_crossings_id
-- WCRP watersheds only
inner join bcfishpass.wcrp_watersheds w on c.watershed_group_code = w.watershed_group_code
-- do not include flathead
WHERE c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
GROUP BY c.watershed_group_code, ms.model_status, crossing_feature_type
ORDER BY c.watershed_group_code, ms.model_status, crossing_feature_type;


-- wcrp crossings
CREATE MATERIALIZED VIEW bcfishpass.crossings_wcrp_vw as

-- find upstream crossings with wcrp 'all spawning rearing habitat' upstream
with upstr_wcrp_barriers as materialized (
  select distinct
   ba.aggregated_crossings_id,
   h.aggregated_crossings_id as upstr_barriers,
   h.all_spawningrearing_km
  from bcfishpass.crossings_upstr_barriers_anthropogenic ba
  inner join bcfishpass.crossings_upstream_habitat_wcrp h on h.aggregated_crossings_id = any(ba.features_upstr)
  where h.all_spawningrearing_km > 0
  order by ba.aggregated_crossings_id, h.aggregated_crossings_id
),

-- aggregate the upstream wcrp crossings into a list and count
upstr_wcrp_barriers_list as (
  select
    aggregated_crossings_id,
    array_to_string(array_agg(upstr_barriers), ';') as barriers_anthropogenic_habitat_wcrp_upstr,
    coalesce(array_length(array_agg(upstr_barriers), 1), 0) as barriers_anthropogenic_habitat_wcrp_upstr_count
  from upstr_wcrp_barriers
  group by aggregated_crossings_id
  order by aggregated_crossings_id
)

select
  -- joining to streams based on measure can be error prone due to precision.
  -- Join to streams on linear_feature_id and keep the first result
  -- (since streams are segmented there is often >1 match)
  distinct on (c.aggregated_crossings_id)
  c.aggregated_crossings_id,
  c.modelled_crossing_id,
  c.crossing_source,
  c.crossing_feature_type,
  c.pscis_status,
  c.crossing_type_code,
  c.crossing_subtype_code,
  c.barrier_status,
  c.pscis_road_name,
  c.pscis_stream_name,
  c.pscis_assessment_comment,
  c.pscis_assessment_date,
  c.transport_line_structured_name_1,
  c.rail_track_name,
  c.dam_name,
  c.dam_height,
  c.dam_owner,
  c.dam_use,
  c.dam_operating_status,
  c.utm_zone,
  c.utm_easting,
  c.utm_northing,
  c.blue_line_key,
  c.downstream_route_measure,
  c.wscode_ltree as wscode,
  c.localcode_ltree as localcode,
  c.watershed_group_code,
  c.gnis_stream_name,
  array_to_string(ad.features_dnstr, ';') as barriers_anthropogenic_dnstr,
  coalesce(array_length(ad.features_dnstr, 1), 0) as barriers_anthropogenic_dnstr_count,
  uwbl.barriers_anthropogenic_habitat_wcrp_upstr,
  uwbl.barriers_anthropogenic_habitat_wcrp_upstr_count,

  -- access models
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,

  -- habitat models
  h.ch_spawning_km,
  h.ch_rearing_km,
  h.ch_spawning_belowupstrbarriers_km,
  h.ch_rearing_belowupstrbarriers_km,
  h.cm_spawning_km,
  h.cm_spawning_belowupstrbarriers_km,
  h.co_spawning_km,
  h_wcrp.co_rearing_km,
  h.co_rearing_ha,
  h.co_spawning_belowupstrbarriers_km,
  h_wcrp.co_rearing_belowupstrbarriers_km,
  h.co_rearing_belowupstrbarriers_ha,
  h.pk_spawning_km,
  h.pk_spawning_belowupstrbarriers_km,
  h.sk_spawning_km,
  h_wcrp.sk_rearing_km,
  h.sk_rearing_ha,
  h.sk_spawning_belowupstrbarriers_km,
  h_wcrp.sk_rearing_belowupstrbarriers_km,
  h.sk_rearing_belowupstrbarriers_ha,
  h.st_spawning_km,
  h.st_rearing_km,
  h.st_spawning_belowupstrbarriers_km,
  h.st_rearing_belowupstrbarriers_km,
  h.wct_spawning_km,
  h.wct_rearing_km,
  h.wct_spawning_belowupstrbarriers_km,
  h.wct_rearing_belowupstrbarriers_km,
  h_wcrp.all_spawning_km,
  h_wcrp.all_spawning_belowupstrbarriers_km,
  h_wcrp.all_rearing_km,
  h_wcrp.all_rearing_belowupstrbarriers_km,
  h_wcrp.all_spawningrearing_km,
  h_wcrp.all_spawningrearing_belowupstrbarriers_km,
  r.set_id,
  r.total_hab_gain_set,
  r.num_barriers_set,
  r.avg_gain_per_barrier,
  r.dnstr_set_ids,
  r.rank_avg_gain_per_barrier,
  r.rank_avg_gain_tiered,
  r.rank_total_upstr_hab,
  r.rank_combined,
  r.tier_combined,
  c.geom
from bcfishpass.crossings c
inner join bcfishpass.wcrp_watersheds w on c.watershed_group_code = w.watershed_group_code  -- only include crossings in WCRP watersheds
left outer join bcfishpass.crossings_dnstr_observations cdo on c.aggregated_crossings_id = cdo.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_observations cuo on c.aggregated_crossings_id = cuo.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_crossings cd on c.aggregated_crossings_id = cd.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on c.aggregated_crossings_id = ad.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_anthropogenic au on c.aggregated_crossings_id = au.aggregated_crossings_id
left outer join upstr_wcrp_barriers_list uwbl on c.aggregated_crossings_id = uwbl.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat h on c.aggregated_crossings_id = h.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat_wcrp h_wcrp on c.aggregated_crossings_id = h_wcrp.aggregated_crossings_id
left outer join bcfishpass.streams s on c.linear_feature_id = s.linear_feature_id
left outer join whse_basemapping.dbm_mof_50k_grid t ON ST_Intersects(c.geom, t.geom)
left outer join bcfishpass.wcrp_ranked_barriers r ON c.aggregated_crossings_id = r.aggregated_crossings_id
order by c.aggregated_crossings_id, s.downstream_route_measure;



-- rebuild the primary crossings materialized view

create materialized view bcfishpass.crossings_vw as
select
  -- joining to streams based on measure can be error prone due to precision.
  -- Join to streams on linear_feature_id and keep the first result
  -- (since streams are segmented there is often >1 match)
  distinct on (c.aggregated_crossings_id)
  c.aggregated_crossings_id,
  c.stream_crossing_id,
  c.dam_id,
  c.user_barrier_anthropogenic_id,
  c.modelled_crossing_id,
  c.crossing_source,
  c.crossing_feature_type,
  c.pscis_status,
  c.crossing_type_code,
  c.crossing_subtype_code,
  array_to_string(c.modelled_crossing_type_source, ';') as modelled_crossing_type_source,
  c.barrier_status,
  c.pscis_road_name,
  c.pscis_stream_name,
  c.pscis_assessment_comment,
  c.pscis_assessment_date,
  c.pscis_final_score,
  c.transport_line_structured_name_1,
  c.transport_line_type_description,
  c.transport_line_surface_description,
  c.ften_forest_file_id,
  c.ften_road_section_id,
  c.ften_file_type_description,
  c.ften_client_number,
  c.ften_client_name,
  c.ften_life_cycle_status_code,
  c.ften_map_label,
  c.rail_track_name,
  c.rail_owner_name,
  c.rail_operator_english_name,
  c.ogc_proponent,
  c.dam_name,
  c.dam_height,
  c.dam_owner,
  c.dam_use,
  c.dam_operating_status,
  c.utm_zone,
  c.utm_easting,
  c.utm_northing,
  t.map_tile_display_name as dbm_mof_50k_grid,
  c.linear_feature_id,
  c.blue_line_key,
  c.watershed_key,
  c.downstream_route_measure,
  c.wscode_ltree as wscode,
  c.localcode_ltree as localcode,
  c.watershed_group_code,
  c.gnis_stream_name,
  c.stream_order,
  c.stream_magnitude,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(cdo.observedspp_dnstr, ';') as observedspp_dnstr,
  array_to_string(cuo.observedspp_upstr, ';') as observedspp_upstr,
  array_to_string(cd.features_dnstr, ';') as crossings_dnstr,
  array_to_string(ad.features_dnstr, ';') as barriers_anthropogenic_dnstr,
  coalesce(array_length(ad.features_dnstr, 1), 0) as barriers_anthropogenic_dnstr_count,
  array_to_string(au.features_upstr, ';') as barriers_anthropogenic_upstr,
  coalesce(array_length(au.features_upstr, 1), 0) as barriers_anthropogenic_upstr_count,
  array_to_string(aum.barriers_upstr_bt, ';') as barriers_anthropogenic_bt_upstr,
  coalesce(array_length(aum.barriers_upstr_bt, 1), 0) as barriers_anthropogenic_upstr_bt_count,
  array_to_string(aum.barriers_upstr_ch_cm_co_pk_sk, ';') as barriers_anthropogenic_ch_cm_co_pk_sk_upstr,
  coalesce(array_length(aum.barriers_upstr_ch_cm_co_pk_sk, 1), 0) as barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count,
  array_to_string(aum.barriers_upstr_st, ';') as barriers_anthropogenic_st_upstr,
  coalesce(array_length(aum.barriers_upstr_st, 1), 0) as barriers_anthropogenic_st_upstr_count,
  array_to_string(aum.barriers_upstr_wct, ';') as barriers_anthropogenic_wct_upstr,
  coalesce(array_length(aum.barriers_upstr_wct, 1), 0) as barriers_anthropogenic_wct_upstr_count,
  a.gradient,
  a.total_network_km,
  a.total_stream_km,
  a.total_lakereservoir_ha,
  a.total_wetland_ha,
  a.total_slopeclass03_waterbodies_km,
  a.total_slopeclass03_km,
  a.total_slopeclass05_km,
  a.total_slopeclass08_km,
  a.total_slopeclass15_km,
  a.total_slopeclass22_km,
  a.total_slopeclass30_km,
  a.total_belowupstrbarriers_network_km,
  a.total_belowupstrbarriers_stream_km,
  a.total_belowupstrbarriers_lakereservoir_ha,
  a.total_belowupstrbarriers_wetland_ha,
  a.total_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.total_belowupstrbarriers_slopeclass03_km,
  a.total_belowupstrbarriers_slopeclass05_km,
  a.total_belowupstrbarriers_slopeclass08_km,
  a.total_belowupstrbarriers_slopeclass15_km,
  a.total_belowupstrbarriers_slopeclass22_km,
  a.total_belowupstrbarriers_slopeclass30_km,

  -- access models
  array_to_string(a.barriers_bt_dnstr, ';') as barriers_bt_dnstr,
  a.bt_network_km,
  a.bt_stream_km,
  a.bt_lakereservoir_ha,
  a.bt_wetland_ha,
  a.bt_slopeclass03_waterbodies_km,
  a.bt_slopeclass03_km,
  a.bt_slopeclass05_km,
  a.bt_slopeclass08_km,
  a.bt_slopeclass15_km,
  a.bt_slopeclass22_km,
  a.bt_slopeclass30_km,
  a.bt_belowupstrbarriers_network_km,
  a.bt_belowupstrbarriers_stream_km,
  a.bt_belowupstrbarriers_lakereservoir_ha,
  a.bt_belowupstrbarriers_wetland_ha,
  a.bt_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.bt_belowupstrbarriers_slopeclass03_km,
  a.bt_belowupstrbarriers_slopeclass05_km,
  a.bt_belowupstrbarriers_slopeclass08_km,
  a.bt_belowupstrbarriers_slopeclass15_km,
  a.bt_belowupstrbarriers_slopeclass22_km,
  a.bt_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  a.ch_cm_co_pk_sk_network_km,
  a.ch_cm_co_pk_sk_stream_km,
  a.ch_cm_co_pk_sk_lakereservoir_ha,
  a.ch_cm_co_pk_sk_wetland_ha,
  a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
  a.ch_cm_co_pk_sk_slopeclass03_km,
  a.ch_cm_co_pk_sk_slopeclass05_km,
  a.ch_cm_co_pk_sk_slopeclass08_km,
  a.ch_cm_co_pk_sk_slopeclass15_km,
  a.ch_cm_co_pk_sk_slopeclass22_km,
  a.ch_cm_co_pk_sk_slopeclass30_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
  a.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  a.st_network_km,
  a.st_stream_km,
  a.st_lakereservoir_ha,
  a.st_wetland_ha,
  a.st_slopeclass03_waterbodies_km,
  a.st_slopeclass03_km,
  a.st_slopeclass05_km,
  a.st_slopeclass08_km,
  a.st_slopeclass15_km,
  a.st_slopeclass22_km,
  a.st_slopeclass30_km,
  a.st_belowupstrbarriers_network_km,
  a.st_belowupstrbarriers_stream_km,
  a.st_belowupstrbarriers_lakereservoir_ha,
  a.st_belowupstrbarriers_wetland_ha,
  a.st_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.st_belowupstrbarriers_slopeclass03_km,
  a.st_belowupstrbarriers_slopeclass05_km,
  a.st_belowupstrbarriers_slopeclass08_km,
  a.st_belowupstrbarriers_slopeclass15_km,
  a.st_belowupstrbarriers_slopeclass22_km,
  a.st_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
  a.wct_network_km,
  a.wct_stream_km,
  a.wct_lakereservoir_ha,
  a.wct_wetland_ha,
  a.wct_slopeclass03_waterbodies_km,
  a.wct_slopeclass03_km,
  a.wct_slopeclass05_km,
  a.wct_slopeclass08_km,
  a.wct_slopeclass15_km,
  a.wct_slopeclass22_km,
  a.wct_slopeclass30_km,
  a.wct_belowupstrbarriers_network_km,
  a.wct_belowupstrbarriers_stream_km,
  a.wct_belowupstrbarriers_lakereservoir_ha,
  a.wct_belowupstrbarriers_wetland_ha,
  a.wct_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.wct_belowupstrbarriers_slopeclass03_km,
  a.wct_belowupstrbarriers_slopeclass05_km,
  a.wct_belowupstrbarriers_slopeclass08_km,
  a.wct_belowupstrbarriers_slopeclass15_km,
  a.wct_belowupstrbarriers_slopeclass22_km,
  a.wct_belowupstrbarriers_slopeclass30_km,

  -- habitat models
  h.bt_spawning_km,
  h.bt_rearing_km,
  h.bt_spawning_belowupstrbarriers_km,
  h.bt_rearing_belowupstrbarriers_km,
  h.ch_spawning_km,
  h.ch_rearing_km,
  h.ch_spawning_belowupstrbarriers_km,
  h.ch_rearing_belowupstrbarriers_km,
  h.cm_spawning_km,
  h.cm_spawning_belowupstrbarriers_km,
  h.co_spawning_km,
  h.co_rearing_km,
  h.co_rearing_ha,
  h.co_spawning_belowupstrbarriers_km,
  h.co_rearing_belowupstrbarriers_km,
  h.co_rearing_belowupstrbarriers_ha,
  h.pk_spawning_km,
  h.pk_spawning_belowupstrbarriers_km,
  h.sk_spawning_km,
  h.sk_rearing_km,
  h.sk_rearing_ha,
  h.sk_spawning_belowupstrbarriers_km,
  h.sk_rearing_belowupstrbarriers_km,
  h.sk_rearing_belowupstrbarriers_ha,
  h.st_spawning_km,
  h.st_rearing_km,
  h.st_spawning_belowupstrbarriers_km,
  h.st_rearing_belowupstrbarriers_km,
  h.wct_spawning_km,
  h.wct_rearing_km,
  h.wct_spawning_belowupstrbarriers_km,
  h.wct_rearing_belowupstrbarriers_km,
  c.geom
from bcfishpass.crossings c
left outer join bcfishpass.crossings_dnstr_observations cdo on c.aggregated_crossings_id = cdo.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_observations cuo on c.aggregated_crossings_id = cuo.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_crossings cd on c.aggregated_crossings_id = cd.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on c.aggregated_crossings_id = ad.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_anthropogenic au on c.aggregated_crossings_id = au.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_per_model aum on c.aggregated_crossings_id = aum.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat h on c.aggregated_crossings_id = h.aggregated_crossings_id
left outer join bcfishpass.streams s on c.linear_feature_id = s.linear_feature_id
left outer join whse_basemapping.dbm_mof_50k_grid t ON ST_Intersects(c.geom, t.geom)
order by c.aggregated_crossings_id, s.downstream_route_measure;

create unique index on bcfishpass.crossings_vw (aggregated_crossings_id);
create index on bcfishpass.crossings_vw using gist (geom);

comment on column bcfishpass.crossings_vw.aggregated_crossings_id IS 'unique identifier for crossing, generated from stream_crossing_id, modelled_crossing_id + 1000000000, user_barrier_anthropogenic_id + 1200000000, cabd_id';
comment on column bcfishpass.crossings_vw.stream_crossing_id IS 'PSCIS stream crossing unique identifier';
comment on column bcfishpass.crossings_vw.dam_id IS 'BC Dams unique identifier';
comment on column bcfishpass.crossings_vw.user_barrier_anthropogenic_id IS 'User added misc anthropogenic barriers unique identifier';
comment on column bcfishpass.crossings_vw.modelled_crossing_id IS 'Modelled crossing unique identifier';
comment on column bcfishpass.crossings_vw.crossing_source IS 'Data source for the crossing, one of: {PSCIS,MODELLED CROSSINGS,CABD,MISC BARRIERS}';
comment on column bcfishpass.crossings_vw.pscis_status IS 'From PSCIS, the current_pscis_status of the crossing, one of: {ASSESSED,HABITAT CONFIRMATION,DESIGN,REMEDIATED}';
comment on column bcfishpass.crossings_vw.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. Acceptable types are: OBS = Open Bottom Structure CBS = Closed Bottom Structure OTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';
comment on column bcfishpass.crossings_vw.crossing_subtype_code IS 'Further definition of the type of crossing, one of {BRIDGE,CRTBOX,DAM,FORD,OVAL,PIPEARCH,ROUND,WEIR,WOODBOX,NULL}';
comment on column bcfishpass.crossings_vw.modelled_crossing_type_source IS 'List of sources that indicate if a modelled crossing is open bottom, Acceptable values are: FWA_EDGE_TYPE=double line river, FWA_STREAM_ORDER=stream order >=6, GBA_RAILWAY_STRUCTURE_LINES_SP=railway structure, "MANUAL FIX"=manually identified OBS, MOT_ROAD_STRUCTURE_SP=MoT structure, TRANSPORT_LINE_STRUCTURE_CODE=DRA structure}';
comment on column bcfishpass.crossings_vw.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. Acceptable Values are: PASSABLE - Passable, POTENTIAL - Potential or partial barrier, BARRIER - Barrier, UNKNOWN - Other';
comment on column bcfishpass.crossings_vw.pscis_road_name  IS 'PSCIS road name, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings_vw.pscis_stream_name  IS 'PSCIS stream name, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings_vw.pscis_assessment_comment  IS 'PSCIS assessment_comment, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings_vw.pscis_assessment_date  IS 'PSCIS assessment_date, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings_vw.pscis_final_score IS 'PSCIS final_score, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings_vw.transport_line_structured_name_1 IS 'DRA road name, taken from the nearest DRA road (within 30m)';
comment on column bcfishpass.crossings_vw.transport_line_type_description IS 'DRA road type, taken from the nearest DRA road (within 30m)';
comment on column bcfishpass.crossings_vw.transport_line_surface_description IS 'DRA road surface, taken from the nearest DRA road (within 30m)';
comment on column bcfishpass.crossings_vw.ften_forest_file_id IS 'FTEN road forest_file_id value, taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings_vw.ften_road_section_id IS 'FTEN road road_section_id value, taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings_vw.ften_file_type_description IS 'FTEN road tenure type (Forest Service Road, Road Permit, etc), taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings_vw.ften_client_number IS 'FTEN road client number, taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings_vw.ften_client_name IS 'FTEN road client name, taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings_vw.ften_life_cycle_status_code IS 'FTEN road life_cycle_status_code (active or retired, pending roads are not included), taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings_vw.ften_map_label IS 'FTEN road map_label value, taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings_vw.rail_track_name IS 'Railway name, taken from nearest railway (within 25m)';
comment on column bcfishpass.crossings_vw.rail_owner_name IS 'Railway owner name, taken from nearest railway (within 25m)';
comment on column bcfishpass.crossings_vw.rail_operator_english_name IS 'Railway operator name, taken from nearest railway (within 25m)';;
comment on column bcfishpass.crossings_vw.ogc_proponent IS 'OGC road tenure proponent (currently modelled crossings only, taken from OGC road that crosses the stream)';
comment on column bcfishpass.crossings_vw.dam_name IS 'See CABD dams column: dam_name_en';
comment on column bcfishpass.crossings_vw.dam_height IS 'See CABD dams column: dam_height';
comment on column bcfishpass.crossings_vw.dam_owner IS 'See CABD dams column: owner';
comment on column bcfishpass.crossings_vw.dam_use IS 'See CABD table dam_use_codes';
comment on column bcfishpass.crossings_vw.dam_operating_status IS 'See CABD dams column dam_operating_status';
comment on column bcfishpass.crossings_vw.utm_zone IS 'UTM ZONE is a segment of the Earths surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';
comment on column bcfishpass.crossings_vw.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';
comment on column bcfishpass.crossings_vw.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';
comment on column bcfishpass.crossings_vw.linear_feature_id IS 'From BC FWA, the unique identifier for a stream segment (flow network arc)';
comment on column bcfishpass.crossings_vw.blue_line_key IS 'From BC FWA, uniquely identifies a single flow line such that a main channel and a secondary channel with the same watershed code would have different blue line keys (the Fraser River and all side channels have different blue line keys).';
comment on column bcfishpass.crossings_vw.watershed_key IS 'From BC FWA, a key that identifies a stream system. There is a 1:1 match between a watershed key and watershed code. The watershed key will match the blue line key for the mainstem.';
comment on column bcfishpass.crossings_vw.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';
comment on column bcfishpass.crossings_vw.wscode IS 'A truncated version of the BC FWA fwa_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';
comment on column bcfishpass.crossings_vw.localcode IS 'A truncated version of the BC FWA local_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';;
comment on column bcfishpass.crossings_vw.watershed_group_code IS 'The watershed group code associated with the feature.';
comment on column bcfishpass.crossings_vw.gnis_stream_name IS 'The BCGNIS (BC Geographical Names Information System) name associated with the FWA stream';
comment on column bcfishpass.crossings_vw.stream_order IS 'Order of FWA stream at point';
comment on column bcfishpass.crossings_vw.stream_magnitude IS 'Magnitude of FWA stream at point';
comment on column bcfishpass.crossings_vw.upstream_area_ha IS 'Cumulative area upstream of the end of the stream (as defined by linear_feature_id)';
comment on column bcfishpass.crossings_vw.stream_order_parent IS 'Stream order of the stream into which the stream drains';
comment on column bcfishpass.crossings_vw.stream_order_max IS 'Maximum stream order associated with the stream (as defined by blue_line_key)';
comment on column bcfishpass.crossings_vw.map_upstream IS 'Mean annual precipitation for the watershed upstream of the stream segment (as defined by linear_feature_id)';
comment on column bcfishpass.crossings_vw.channel_width IS 'Modelled channel width of the stream (m)';
comment on column bcfishpass.crossings_vw.mad_m3s IS 'Modelled mean annual discharge of the stream (m3/s)';
comment on column bcfishpass.crossings_vw.observedspp_dnstr IS 'Species codes of downstream fish observations';
comment on column bcfishpass.crossings_vw.observedspp_upstr IS 'Species codes of upstream fish observations';
comment on column bcfishpass.crossings_vw.crossings_dnstr IS 'aggregated_crossings_id value for all downstream crossings';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_dnstr IS 'aggregated_crossings_id value for all downstream anthropogenic barriers';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_dnstr_count IS 'Count of anthropogenic downstream barriers';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_upstr IS 'aggregated_crossings_id value for all upstream anthropogenic barriers';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_upstr_count IS 'Count of all upstream anthropogenic barriers';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_bt_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Bull Trout';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_upstr_bt_count IS 'Count of upstream anthropogenic barriers on streams accessible to Bull Trout';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Pacific Salmon';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Pacific Salmon';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_st_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Steelhead';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_st_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Steelhead';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_wct_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to West Slope Cutthroat Trout';
comment on column bcfishpass.crossings_vw.barriers_anthropogenic_wct_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Bull Trout';
comment on column bcfishpass.crossings_vw.gradient IS 'Gradient of stream segment at crossing (defined by stream_segment_id)';
comment on column bcfishpass.crossings_vw.total_network_km IS 'Total upstream length of FWA stream network (km)';
comment on column bcfishpass.crossings_vw.total_stream_km IS 'Total upstream length of FWA streams (single and double line, km)';
comment on column bcfishpass.crossings_vw.total_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs (ha)';
comment on column bcfishpass.crossings_vw.total_wetland_ha IS 'Total upstream area of wetlands (ha)';
comment on column bcfishpass.crossings_vw.total_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies (km)';
comment on column bcfishpass.crossings_vw.total_slopeclass03_km IS 'Total upstream length of stream < 3% gradient (km)';
comment on column bcfishpass.crossings_vw.total_slopeclass05_km IS 'Total upstream length of stream < 5% gradient (km)';
comment on column bcfishpass.crossings_vw.total_slopeclass08_km IS 'Total upstream length of stream < 8% gradient (km)';
comment on column bcfishpass.crossings_vw.total_slopeclass15_km IS 'Total upstream length of stream < 15% gradient (km)';
comment on column bcfishpass.crossings_vw.total_slopeclass22_km IS 'Total upstream length of stream < 22% gradient (km)';
comment on column bcfishpass.crossings_vw.total_slopeclass30_km IS 'Total upstream length of stream < 30% gradient (km)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams, downstream of any anthropogenic barrier  (single and double line, km)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.barriers_bt_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Bull Trout';
comment on column bcfishpass.crossings_vw.bt_network_km IS 'Total upstream length of FWA stream network accessible to Bull Trout (km)';
comment on column bcfishpass.crossings_vw.bt_stream_km IS 'Total upstream length of FWA streams accessible to Bull Trout (single and double line, km)';
comment on column bcfishpass.crossings_vw.bt_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Bull Trout (ha)';
comment on column bcfishpass.crossings_vw.bt_wetland_ha IS 'Total upstream area of wetlands accessible to Bull Trout (ha)';
comment on column bcfishpass.crossings_vw.bt_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Bull Trout (km)';
comment on column bcfishpass.crossings_vw.bt_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Bull Trout (km)';
comment on column bcfishpass.crossings_vw.bt_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Bull Trout (km)';
comment on column bcfishpass.crossings_vw.bt_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Bull Trout (km)';
comment on column bcfishpass.crossings_vw.bt_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Bull Trout (km)';
comment on column bcfishpass.crossings_vw.bt_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Bull Trout (km)';
comment on column bcfishpass.crossings_vw.bt_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Bull Trout (km)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Bull Trout, downstream of any anthropogenic barrier  (single and double line, km)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Bull Trout, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Bull Trout, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.barriers_ch_cm_co_pk_sk_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Pacific Salmon';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_network_km IS 'Total upstream length of FWA stream network accessible to Pacific Salmon (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_stream_km IS 'Total upstream length of FWA streams accessible to Pacific Salmon (single and double line, km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Pacific Salmon (ha)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_wetland_ha IS 'Total upstream area of wetlands accessible to Pacific Salmon (ha)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Pacific Salmon (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Pacific Salmon (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Pacific Salmon (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Pacific Salmon (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Pacific Salmon (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Pacific Salmon (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Pacific Salmon (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Pacific Salmon, downstream of any anthropogenic barrier  (single and double line, km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Pacific Salmon, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Pacific Salmon, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.barriers_st_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Steelhead';
comment on column bcfishpass.crossings_vw.st_network_km IS 'Total upstream length of FWA stream network accessible to Steelhead (km)';
comment on column bcfishpass.crossings_vw.st_stream_km IS 'Total upstream length of FWA streams accessible to Steelhead (single and double line, km)';
comment on column bcfishpass.crossings_vw.st_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Steelhead (ha)';
comment on column bcfishpass.crossings_vw.st_wetland_ha IS 'Total upstream area of wetlands accessible to Steelhead (ha)';
comment on column bcfishpass.crossings_vw.st_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Steelhead (km)';
comment on column bcfishpass.crossings_vw.st_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Steelhead (km)';
comment on column bcfishpass.crossings_vw.st_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Steelhead (km)';
comment on column bcfishpass.crossings_vw.st_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Steelhead (km)';
comment on column bcfishpass.crossings_vw.st_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Steelhead (km)';
comment on column bcfishpass.crossings_vw.st_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Steelhead (km)';
comment on column bcfishpass.crossings_vw.st_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Steelhead (km)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Steelhead, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Steelhead, downstream of any anthropogenic barrier  (single and double line, km)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Steelhead, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Steelhead, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Steelhead, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.barriers_wct_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to West Slope Cutthroat Trout';
comment on column bcfishpass.crossings_vw.wct_network_km IS 'Total upstream length of FWA stream network accessible to West Slope Cutthroat Trout (km)';
comment on column bcfishpass.crossings_vw.wct_stream_km IS 'Total upstream length of FWA streams accessible to West Slope Cutthroat Trout (single and double line, km)';
comment on column bcfishpass.crossings_vw.wct_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to West Slope Cutthroat Trout (ha)';
comment on column bcfishpass.crossings_vw.wct_wetland_ha IS 'Total upstream area of wetlands accessible to West Slope Cutthroat Trout (ha)';
comment on column bcfishpass.crossings_vw.wct_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to West Slope Cutthroat Trout (km)';
comment on column bcfishpass.crossings_vw.wct_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to West Slope Cutthroat Trout (km)';
comment on column bcfishpass.crossings_vw.wct_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to West Slope Cutthroat Trout (km)';
comment on column bcfishpass.crossings_vw.wct_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to West Slope Cutthroat Trout (km)';
comment on column bcfishpass.crossings_vw.wct_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to West Slope Cutthroat Trout (km)';
comment on column bcfishpass.crossings_vw.wct_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to West Slope Cutthroat Trout (km)';
comment on column bcfishpass.crossings_vw.wct_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to West Slope Cutthroat Trout (km)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (single and double line, km)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (ha)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';
comment on column bcfishpass.crossings_vw.bt_spawning_km IS 'Upstream length of modelled/observed Bull Trout spawning';
comment on column bcfishpass.crossings_vw.bt_rearing_km IS 'Upstream length of modelled/observed Bull Trout Rearing';
comment on column bcfishpass.crossings_vw.bt_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Bull Trout spawning, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.bt_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Bull Trout rearing, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.ch_spawning_km IS 'Upstream length of modelled/observed Chinook spawning';
comment on column bcfishpass.crossings_vw.ch_rearing_km IS 'Upstream length of modelled/observed Chinook Rearing';
comment on column bcfishpass.crossings_vw.ch_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook spawning, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.ch_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook rearing, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.cm_spawning_km IS 'Upstream length of modelled/observed Chum spawning';
comment on column bcfishpass.crossings_vw.cm_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chum spawning, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.co_spawning_km IS 'Upstream length of modelled/observed Coho spawning';
comment on column bcfishpass.crossings_vw.co_rearing_km IS 'Upstream length of modelled/observed Coho rearing';
comment on column bcfishpass.crossings_vw.co_rearing_ha IS 'Upstream area (wetlands) of modelled/observed Coho rearing';
comment on column bcfishpass.crossings_vw.co_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho spawning, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.co_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho rearing, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.co_rearing_belowupstrbarriers_ha IS 'Upstream area (wetlands) of modelled/observed Coho rearing, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.pk_spawning_km IS 'Upstream length of modelled/observed Pink spawning';
comment on column bcfishpass.crossings_vw.pk_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Pink spawning, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.sk_spawning_km IS 'Upstream length of modelled/observed Sockeye spawning';
comment on column bcfishpass.crossings_vw.sk_rearing_km IS 'Upstream length of modelled/observed Sockeye rearing';
comment on column bcfishpass.crossings_vw.sk_rearing_ha IS 'Upstream area (lakes) of modelled/observed Sockeye rearing';
comment on column bcfishpass.crossings_vw.sk_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Sockeye spawning';
comment on column bcfishpass.crossings_vw.sk_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Sockeye rearing';
comment on column bcfishpass.crossings_vw.sk_rearing_belowupstrbarriers_ha IS 'Upstream area (lakes) of modelled/observed Sockeye rearing';
comment on column bcfishpass.crossings_vw.st_spawning_km IS 'Upstream length of modelled/observed Steelhead spawning';
comment on column bcfishpass.crossings_vw.st_rearing_km IS 'Upstream length of modelled/observed Steelhead Rearing';
comment on column bcfishpass.crossings_vw.st_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead spawning, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.st_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead rearing, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.wct_spawning_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning';
comment on column bcfishpass.crossings_vw.wct_rearing_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout Rearing';
comment on column bcfishpass.crossings_vw.wct_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.wct_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout rearing, downstream of any anthropogenic barriers';
comment on column bcfishpass.crossings_vw.geom IS 'The point geometry associated with the feature';


-- count of crossings per assessment watershed, taken directly from source tables
CREATE MATERIALIZED VIEW bcfishpass.fptwg_summary_crossings_vw as
select
  l.assmnt_watershed_id as watershed_feature_id,
  count(*) as n_crossings_total,
  count(*) filter (where crossing_feature_type = 'DAM') as n_dam,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'PASSABLE') as n_dam_passable,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'POTENTIAL') as n_dam_potential,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'UNKNOWN') as n_dam_unknown,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER') as n_dam_barrier,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER' and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) as n_dam_barrier_salmon,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER' and cardinality(a.barriers_st_dnstr) = 0) as n_dam_barrier_steelhead,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'ASSESSED') as n_pscisassessment,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'HABITAT CONFIRMATION') as n_pscisconfirmation,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'DESIGN') as n_pscisdesign,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'REMEDIATED') as n_pscisremediation,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'PASSABLE') as n_pscis_passable,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'POTENTIAL') as n_pscis_potential,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'UNKNOWN') as n_pscis_unknown,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER') as n_pscis_barrier,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER' and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) as n_pscis_barrier_salmon,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER' and cardinality(a.barriers_st_dnstr) = 0) as n_pscis_barrier_steelhead,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS') as n_modelledxings,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'PASSABLE') as n_modelledxings_passable,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'POTENTIAL') as n_modelledxings_potential,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'UNKNOWN') as n_modelledxings_unknown,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER') as n_modelledxings_barrier,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER' and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) as n_modelledxings_barrier_salmon,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER' and cardinality(a.barriers_st_dnstr) = 0) as n_modelledxings_barrier_steelhead,
  count(*) filter (where crossing_source = 'MISC BARRIERS') as n_miscbarriers,
  count(*) filter (where crossing_source = 'MISC BARRIERS' and barrier_status = 'BARRIER' and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) as n_miscbarriers_barrier_salmon,
  count(*) filter (where crossing_source = 'MISC BARRIERS' and barrier_status = 'BARRIER' and cardinality(a.barriers_st_dnstr) = 0) as n_miscbarriers_barrier_steelhead
from bcfishpass.crossings c
left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
inner join whse_basemapping.fwa_assessment_watersheds_streams_lut l on c.linear_feature_id = l.linear_feature_id
group by l.assmnt_watershed_id;
create index on bcfishpass.fptwg_summary_crossings_vw (watershed_feature_id);

-- for easier backwards compatability
create view bcfishpass.dams_vw as select * from bcfishpass.dams;
create view bcfishpass.falls_vw as select * from bcfishpass.falls;
create view bcfishpass.observations_vw as select * from bcfishpass.observations;


--
-- additional fptwg assessment watershed summaries
-- these two views are not currently used anywhere but were requested by fptwg
--
create materialized view bcfishpass.fptwg_summary_observations_vw as
select
  l.assmnt_watershed_id as watershed_feature_id,
  count(*) as n_fishobservations,
  array_agg(distinct o.species_code order by o.species_code) as speciesobserved,
  array_length(array_agg(distinct o.species_code order by o.species_code), 1) as n_speciesobserved,
  count(*) filter (where o.species_code in ('CH','CM','CO','PK','SK')) as n_salmonobservations,
  count(*) filter (where o.species_code = 'ST') as n_steelheadobservations,
  count(*) filter (where o.species_code in ('ACT', 'ADV', 'CCT', 'CH', 'CM', 'CO', 'EU', 'GSG', 'PK', 'PL', 'RL', 'SK', 'ST', 'WSG')) as n_anadromousobservations
from bcfishpass.observations o
inner join whse_basemapping.fwa_assessment_watersheds_streams_lut l on o.linear_feature_id = l.linear_feature_id
group by l.assmnt_watershed_id;
create index on bcfishpass.fptwg_summary_observations_vw (watershed_feature_id);

create materialized view bcfishpass.fptwg_summary_roads_vw as
with roads as (
  select
    w.watershed_feature_id,
    case when
      c.description IN (
        'Road alleyway',
        'Road arterial major',
        'Road arterial minor',
        'Road collector major',
        'Road collector minor',
        'Road freeway',
        'Road highway major',
        'Road highway minor',
        'Road lane',
        'Road local',
        'Private driveway demographic',
        'Road pedestrian mall',
        'Road runway non-demographic',
        'Road recreation demographic',
        'Road ramp',
        'Road restricted',
        'Road strata',
        'Road service',
        'Road yield lane'
      )
      then 'ROAD, DEMOGRAPHIC'
      when upper(c.description) LIKE 'TRAIL%' then 'TRAIL'
      when c.description is not NULL then 'ROAD, RESOURCE/OTHER'
    end as road_type,
    case
      when st_coveredby(r.geom, w.geom) then r.geom
    else
      st_intersection(r.geom, w.geom)
    end as geom
  from whse_basemapping.fwa_assessment_watersheds_poly w
  inner join whse_basemapping.transport_line r on st_intersects(w.geom, r.geom)
  inner join whse_basemapping.transport_line_type_code c on r.transport_line_type_code = c.transport_line_type_code
  where r.transport_line_type_code NOT IN ('F','FP','FR','T','TR','TS','RP','RWA')      -- exclude trails other than demographic and all ferry/water
  and r.transport_line_surface_code != 'D'                                              -- exclude decomissioned roads
  and coalesce(r.transport_line_structure_code, '') != 'T'                              -- exclude tunnels

  UNION ALL

  select
    w.watershed_feature_id,
    'RAIL' as road_type,
    case
      when st_coveredby(r.geom, w.geom) then r.geom
    else
      st_intersection(r.geom, w.geom)
    end as geom
  from whse_basemapping.fwa_assessment_watersheds_poly w
  inner join whse_basemapping.gba_railway_tracks_sp r on st_intersects(w.geom, r.geom)
  WHERE r.track_classification not in ('Ferry Route', 'Yard', 'Siding')   -- do we want to exclude yard/siding from this linear summary? this is the query for modelled xings
)

select
  watershed_feature_id,
  sum(st_length(geom)) filter (where road_type = 'RAIL') as length_rail,
  sum(st_length(geom)) filter (where road_type = 'ROAD, RESOURCE/OTHER') as length_resourceroad,
  sum(st_length(geom)) filter (where road_type = 'ROAD, DEMOGRAPHIC') as length_demographicroad,
  sum(st_length(geom)) filter (where road_type = 'TRAIL') as length_trail
from roads
where st_dimension(geom) = 1
group by watershed_feature_id;
create index on bcfishpass.fptwg_summary_roads_vw (watershed_feature_id);


COMMIT;