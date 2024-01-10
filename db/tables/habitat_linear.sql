drop table if exists bcfishpass.habitat_linear_bt cascade;
create table bcfishpass.habitat_linear_bt (
  segmented_stream_id text primary key, 
  spawning boolean, 
  rearing boolean
);

drop table if exists bcfishpass.habitat_linear_ch cascade;
create table bcfishpass.habitat_linear_ch (
  segmented_stream_id text primary key, 
  spawning boolean, 
  rearing boolean
);

drop table if exists bcfishpass.habitat_linear_cm cascade;
create table bcfishpass.habitat_linear_cm (
  segmented_stream_id text primary key, 
  spawning boolean
);

drop table if exists bcfishpass.habitat_linear_co cascade;
create table bcfishpass.habitat_linear_co (
  segmented_stream_id text primary key, 
  spawning boolean, 
  rearing boolean
);

drop table if exists bcfishpass.habitat_linear_pk cascade;
create table bcfishpass.habitat_linear_pk (
  segmented_stream_id text primary key, 
  spawning boolean
);

drop table if exists bcfishpass.habitat_linear_sk cascade;
create table bcfishpass.habitat_linear_sk (
  segmented_stream_id text primary key, 
  spawning boolean,
  rearing boolean
);

drop table if exists bcfishpass.habitat_linear_st cascade;
create table bcfishpass.habitat_linear_st (
  segmented_stream_id text primary key,
  spawning boolean,
  rearing boolean
);

drop table if exists bcfishpass.habitat_linear_wct cascade;
create table bcfishpass.habitat_linear_wct (
  segmented_stream_id text primary key, 
  spawning boolean,
  rearing boolean
);