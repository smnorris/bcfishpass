--do not generally drop or truncate these tables - we want to retain this data
-- but note that if dropping the main log table, all other tables must also be dropped
-- (if they are not, model_id values get orphaned/duplicated, views will be incorrect)
--drop table bcfishpass.log cascade;
--drop table bcfishpass.parameters_habitat_method_log;
--drop table bcfishpass.parameters_habitat_thresholds_log;
--drop table bcfishpass.wsg_linear_summary;
--drop table bcfishpass.wsg_crossing_summary;
create table bcfishpass.log (
  model_run_id serial primary key,
  model_type text not null,
  date_completed timestamp not null default CURRENT_TIMESTAMP,
  model_version text not null,
  check (model_type in ('LINEAR','LATERAL'))
);

-- usage:
-- insert into bcfishpass.log (model_type, model_version)
-- values ('LINEAR', 'v0.1.dev5-71-gec2db00') RETURNING model_run_id;


-- log parameters used for the given model run
create table bcfishpass.parameters_habitat_method_log (
  model_run_id integer references bcfishpass.log(model_run_id),
  watershed_group_code character varying(4),
  model text
);

create table bcfishpass.parameters_habitat_thresholds_log (
 model_run_id integer references bcfishpass.log(model_run_id),
 species_code             text   ,
 spawn_gradient_max       numeric,
 spawn_channel_width_min  numeric,
 spawn_channel_width_max  numeric,
 spawn_mad_min            numeric,
 spawn_mad_max            numeric,
 rear_gradient_max        numeric,
 rear_channel_width_min   numeric,
 rear_channel_width_max   numeric,
 rear_mad_min             numeric,
 rear_mad_max             numeric,
 rear_lake_ha_min         integer
);

create table bcfishpass.wsg_linear_summary (
 model_run_id                                             integer references bcfishpass.log(model_run_id),
 watershed_group_code                                     text,
 length_total                                             numeric,
 length_potentiallyaccessible_bt                          numeric,
 length_potentiallyaccessible_bt_observed                 numeric,
 length_potentiallyaccessible_bt_accessible_a             numeric,
 length_potentiallyaccessible_bt_accessible_b             numeric,
 length_obsrvd_spawning_rearing_bt                        numeric,
 length_obsrvd_spawning_rearing_bt_accessible_a           numeric,
 length_obsrvd_spawning_rearing_bt_accessible_b           numeric,
 length_spawning_rearing_bt                               numeric,
 length_spawning_rearing_bt_accessible_a                  numeric,
 length_spawning_rearing_bt_accessible_b                  numeric,
 length_potentiallyaccessible_ch_cm_co_pk_sk              numeric,
 length_potentiallyaccessible_ch_cm_co_pk_sk_observed     numeric,
 length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a numeric,
 length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b numeric,
 length_obsrvd_spawning_rearing_ch                        numeric,
 length_obsrvd_spawning_rearing_ch_accessible_a           numeric,
 length_obsrvd_spawning_rearing_ch_accessible_b           numeric,
 length_spawning_rearing_ch                               numeric,
 length_spawning_rearing_ch_accessible_a                  numeric,
 length_spawning_rearing_ch_accessible_b                  numeric,
 length_obsrvd_spawning_rearing_cm                        numeric,
 length_obsrvd_spawning_rearing_cm_accessible_a           numeric,
 length_obsrvd_spawning_rearing_cm_accessible_b           numeric,
 length_spawning_rearing_cm                               numeric,
 length_spawning_rearing_cm_accessible_a                  numeric,
 length_spawning_rearing_cm_accessible_b                  numeric,
 length_obsrvd_spawning_rearing_co                        numeric,
 length_obsrvd_spawning_rearing_co_accessible_a           numeric,
 length_obsrvd_spawning_rearing_co_accessible_b           numeric,
 length_spawning_rearing_co                               numeric,
 length_spawning_rearing_co_accessible_a                  numeric,
 length_spawning_rearing_co_accessible_b                  numeric,
 length_obsrvd_spawning_rearing_pk                        numeric,
 length_obsrvd_spawning_rearing_pk_accessible_a           numeric,
 length_obsrvd_spawning_rearing_pk_accessible_b           numeric,
 length_spawning_rearing_pk                               numeric,
 length_spawning_rearing_pk_accessible_a                  numeric,
 length_spawning_rearing_pk_accessible_b                  numeric,
 length_obsrvd_spawning_rearing_sk                        numeric,
 length_obsrvd_spawning_rearing_sk_accessible_a           numeric,
 length_obsrvd_spawning_rearing_sk_accessible_b           numeric,
 length_spawning_rearing_sk                               numeric,
 length_spawning_rearing_sk_accessible_a                  numeric,
 length_spawning_rearing_sk_accessible_b                  numeric,
 length_potentiallyaccessible_st                          numeric,
 length_potentiallyaccessible_st_observed                 numeric,
 length_potentiallyaccessible_st_accessible_a             numeric,
 length_potentiallyaccessible_st_accessible_b             numeric,
 length_obsrvd_spawning_rearing_st                        numeric,
 length_obsrvd_spawning_rearing_st_accessible_a           numeric,
 length_obsrvd_spawning_rearing_st_accessible_b           numeric,
 length_spawning_rearing_st                               numeric,
 length_spawning_rearing_st_accessible_a                  numeric,
 length_spawning_rearing_st_accessible_b                  numeric,
 length_potentiallyaccessible_wct                         numeric,
 length_potentiallyaccessible_wct_observed                numeric,
 length_potentiallyaccessible_wct_accessible_a            numeric,
 length_potentiallyaccessible_wct_accessible_b            numeric,
 length_obsrvd_spawning_rearing_wct                       numeric,
 length_obsrvd_spawning_rearing_wct_accessible_a          numeric,
 length_obsrvd_spawning_rearing_wct_accessible_b          numeric,
 length_spawning_rearing_wct                              numeric,
 length_spawning_rearing_wct_accessible_a                 numeric,
 length_spawning_rearing_wct_accessible_b                 numeric
);

create table bcfishpass.wsg_crossing_summary (
  model_run_id                          integer references bcfishpass.log(model_run_id),
  watershed_group_code                  text,
  crossing_feature_type                 text,
  n_crossings_total                     integer,
  n_passable_total                      integer,
  n_barriers_total                      integer,
  n_potential_total                     integer,
  n_unknown_total                       integer,
  n_barriers_accessible_bt              integer,
  n_potential_accessible_bt             integer,
  n_unknown_accessible_bt               integer,
  n_barriers_accessible_ch_cm_co_pk_sk  integer,
  n_potential_accessible_ch_cm_co_pk_sk integer,
  n_unknown_accessible_ch_cm_co_pk_sk   integer,
  n_barriers_accessible_st              integer,
  n_potential_accessible_st             integer,
  n_unknown_accessible_st               integer,
  n_barriers_accessible_wct             integer,
  n_potential_accessible_wct            integer,
  n_unknown_accessible_wct              integer,
  n_barriers_habitat_bt                 integer,
  n_potential_habitat_bt                integer,
  n_unknown_habitat_bt                  integer,
  n_barriers_habitat_ch                 integer,
  n_potential_habitat_ch                integer,
  n_unknown_habitat_ch                  integer,
  n_barriers_habitat_cm                 integer,
  n_potential_habitat_cm                integer,
  n_unknown_habitat_cm                  integer,
  n_barriers_habitat_co                 integer,
  n_potential_habitat_co                integer,
  n_unknown_habitat_co                  integer,
  n_barriers_habitat_pk                 integer,
  n_potential_habitat_pk                integer,
  n_unknown_habitat_pk                  integer,
  n_barriers_habitat_sk                 integer,
  n_potential_habitat_sk                integer,
  n_unknown_habitat_sk                  integer,
  n_barriers_habitat_salmon             integer,
  n_potential_habitat_salmon            integer,
  n_unknown_habitat_salmon              integer,
  n_barriers_habitat_st                 integer,
  n_potential_habitat_st                integer,
  n_unknown_habitat_st                  integer,
  n_barriers_habitat_wct                integer,
  n_potential_habitat_wct               integer,
  n_unknown_habitat_wct                 integer
);