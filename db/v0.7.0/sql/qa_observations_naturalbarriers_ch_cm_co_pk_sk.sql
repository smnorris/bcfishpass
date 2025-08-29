-- salmon observation with modelled barriers downstream

create table bcfishpass.qa_observations_ch_cm_co_pk_sk (
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

create table bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk (
  barrier_id           text primary key,
  barrier_type         text,
  watershed_group_code text,
  observations_upstr   text,
  n_observations_upstr integer
);