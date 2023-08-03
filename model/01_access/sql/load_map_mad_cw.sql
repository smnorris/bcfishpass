-- load pre-computed precip/discharge/channel width from file

drop table if exists bcfishpass.discharge;

create table bcfishpass.discharge
(
 linear_feature_id    bigint          primary key,
 watershed_group_code text            ,
 mad_mm               double precision,
 mad_m3s              double precision
);

\copy bcfishpass.discharge FROM data/discharge.csv delimiter ',' csv header;


drop table if exists bcfishpass.mean_annual_precip;

create table bcfishpass.mean_annual_precip (
 id                    integer primary key,
 wscode_ltree          ltree  ,
 localcode_ltree       ltree  ,
 watershed_group_code  text   ,
 area                  bigint ,
 map                   integer,
 map_upstream          integer 
);

create index on bcfishpass.mean_annual_precip using gist (localcode_ltree);
create index on bcfishpass.mean_annual_precip using btree (localcode_ltree);
create index on bcfishpass.mean_annual_precip using gist (wscode_ltree);
create index on bcfishpass.mean_annual_precip using btree (wscode_ltree);

\copy bcfishpass.mean_annual_precip FROM data/mean_annual_precip.csv delimiter ',' csv header;


drop table if exists bcfishpass.channel_width;

create table bcfishpass.channel_width (
 linear_feature_id     bigint           primary key,
 channel_width_source  text             ,
 channel_width         double precision 
);

\copy bcfishpass.channel_width FROM data/channel_width.csv delimiter ',' csv header;