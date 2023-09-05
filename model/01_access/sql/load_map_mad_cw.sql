-- load pre-computed precip/discharge/channel width from file

# drop table if exists bcfishpass.discharge;          # can't drop this, streams_vw requires discharge

create table if not exists bcfishpass.discharge
(
 linear_feature_id    bigint          primary key,
 watershed_group_code text            ,
 mad_mm               double precision,
 mad_m3s              double precision
);
truncate bcfishpass.discharge;
\copy bcfishpass.discharge FROM data/discharge.csv delimiter ',' csv header;


drop table if exists bcfishpass.mean_annual_precip;  # as above, can't drop this

create table if not exists bcfishpass.mean_annual_precip (
 id                    integer primary key,
 wscode_ltree          ltree  ,
 localcode_ltree       ltree  ,
 watershed_group_code  text   ,
 area                  bigint ,
 map                   integer,
 map_upstream          integer 
);
truncate bcfishpass.mean_annual_precip;
create index on bcfishpass.mean_annual_precip using gist (localcode_ltree);
create index on bcfishpass.mean_annual_precip using btree (localcode_ltree);
create index on bcfishpass.mean_annual_precip using gist (wscode_ltree);
create index on bcfishpass.mean_annual_precip using btree (wscode_ltree);

\copy bcfishpass.mean_annual_precip FROM data/mean_annual_precip.csv delimiter ',' csv header;


# drop table if exists bcfishpass.channel_width;     # can't drop this

create table if not exists bcfishpass.channel_width (
 linear_feature_id     bigint           primary key,
 channel_width_source  text             ,
 channel_width         double precision 
);
truncate bcfishpass.channel_width;
\copy bcfishpass.channel_width FROM data/channel_width.csv delimiter ',' csv header;