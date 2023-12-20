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

-- loaded from user_habitat_classification, overrides above modelled habitat
drop table if exists bcfishpass.habitat_linear_user cascade;
create table bcfishpass.habitat_linear_user (
  segmented_stream_id text primary key,
  spawning_bt boolean,
  spawning_ch boolean,
  spawning_cm boolean,
  spawning_co boolean,
  spawning_pk boolean,
  spawning_sk boolean,
  spawning_st boolean,
  spawning_wct boolean,
  rearing_bt boolean,
  rearing_ch boolean,
  rearing_co boolean,
  rearing_sk boolean,
  rearing_st boolean,
  rearing_wct boolean
);