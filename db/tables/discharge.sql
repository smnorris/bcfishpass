drop table if exists bcfishpass.discharge;
create table bcfishpass.discharge
(
 linear_feature_id    bigint          primary key,
 watershed_group_code text            ,
 mad_mm               double precision,
 mad_m3s              double precision
);