drop table if exists bcfishpass.channel_width;
create table if not exists bcfishpass.channel_width (
 linear_feature_id     bigint           primary key,
 channel_width_source  text             ,
 channel_width         double precision 
);