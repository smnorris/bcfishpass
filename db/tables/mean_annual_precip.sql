drop table bcfishpass.mean_annual_precip;
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
