-- views for qa spot checks

-- 100 random natural salmon barriers with >1km stream upstream
drop view if exists bcfishpass.barriers_ch_cm_co_pk_sk_qa_100random;
create materialized view bcfishpass.barriers_ch_cm_co_pk_sk_qa_100random as
select * from (
  select * from bcfishpass.barriers_ch_cm_co_pk_sk
  where total_network_km > 1
  order by random()
  limit 100
) as f
order by total_network_km desc;

-- 100 random natural steelhead barriers with >1km stream upstream
drop view if exists bcfishpass.barriers_st_qa_100random;
create materialized view bcfishpass.barriers_st_qa_100random as
select * from
(
  select * from bcfishpass.barriers_st
  where total_network_km > 1
  order by random()
  limit 100
) as f
order by total_network_km desc;