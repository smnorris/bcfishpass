-- do not drop/re-create these on db schema refresh, they are stable and we
-- do not want to re-load these data every time db schema is updated

create table if not exists bcfishpass.discharge
(
 linear_feature_id    bigint          primary key,
 watershed_group_code text            ,
 mad_mm               double precision,
 mad_m3s              double precision
);

create table if not exists bcfishpass.channel_width (
 linear_feature_id     bigint           primary key,
 channel_width_source  text             ,
 channel_width         double precision 
);