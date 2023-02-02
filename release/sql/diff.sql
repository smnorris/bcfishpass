with dates as (
  select distinct date_processed 
  from bcfishpass.totals
  order by date_processed desc 
  limit 2
),

latest as (
  select * from bcfishpass.totals
  where date_processed = (select date_processed from dates order by date_processed desc limit 1)
),

previous as (
  select * from bcfishpass.totals
  where date_processed = (select date_processed from dates order by date_processed desc limit 1 offset 1)
)


select 
  a.watershed_group_code,
  a.total_network_km,  
  abs(a.ch_co_sk_network_km - b.ch_co_sk_network_km) as ch_co_sk_network_km_diff,
  round(((a.ch_co_sk_network_km - b.ch_co_sk_network_km) / (a.ch_co_sk_network_km + 1) * 100)::numeric, 2) as ch_co_sk_network_km_diff_pct,
  (a.st_network_km - b.st_network_km) as st_network_km_diff,
  round(((a.st_network_km - b.st_network_km) / (a.st_network_km + 1) * 100)::numeric, 2) as st_network_km_diff_pct,
  (a.wct_network_km - b.wct_network_km) as wct_network_km_diff,
  round(((a.wct_network_km - b.wct_network_km) / (a.wct_network_km + 1) * 100)::numeric, 2) as wct_network_km_diff_pct,
  (a.ch_spawning_km - b.ch_spawning_km) as ch_spawning_km_diff,
  round(((a.ch_spawning_km - b.ch_spawning_km) / (a.ch_spawning_km + 1) * 100)::numeric, 2) as ch_spawning_km_diff_pct,
  (a.ch_rearing_km - b.ch_rearing_km) as ch_rearing_km_diff,
  round(((a.ch_rearing_km - b.ch_rearing_km) / (a.ch_rearing_km + 1) * 100)::numeric, 2) as ch_rearing_km_diff_pct,
  (a.co_spawning_km - b.co_spawning_km) as co_spawning_km_diff,
  round(((a.co_spawning_km - b.co_spawning_km) / (a.co_spawning_km + 1) * 100)::numeric, 2) as co_spawning_km_diff_pct,
  (a.co_rearing_km - b.co_rearing_km) as co_rearing_km_diff,
  round(((a.co_rearing_km - b.co_rearing_km) / (a.co_rearing_km + 1) * 100)::numeric, 2) as co_rearing_km_diff_pct,
  (a.sk_spawning_km - b.sk_spawning_km) as sk_spawning_km_diff,
  round(((a.sk_spawning_km - b.sk_spawning_km) / (a.sk_spawning_km + 1) * 100)::numeric, 2) as sk_spawning_km_diff_pct,
  (a.sk_rearing_km - b.sk_rearing_km) as sk_rearing_km_diff,
  round(((a.sk_rearing_km - b.sk_rearing_km) / (a.sk_rearing_km + 1) * 100)::numeric, 2) as sk_rearing_km_diff_pct,
  (a.st_spawning_km - b.st_spawning_km) as st_spawning_km_diff,
  round(((a.st_spawning_km - b.st_spawning_km) / (a.st_spawning_km + 1) * 100)::numeric, 2) as st_spawning_km_diff_pct,
  (a.st_rearing_km - b.st_rearing_km) as st_rearing_km_diff,
  round(((a.st_rearing_km - b.st_rearing_km) / (a.st_rearing_km + 1) * 100)::numeric, 2) as st_rearing_km_diff_pct,
  (a.wct_spawning_km - b.wct_spawning_km) as wct_spawning_km_diff,
  round(((a.wct_spawning_km - b.wct_spawning_km) / (a.wct_spawning_km + 1) * 100)::numeric, 2) as wct_spawning_km_diff_pct,
  (a.wct_rearing_km - b.wct_rearing_km) as wct_rearing_km_diff,
  round(((a.wct_rearing_km - b.wct_rearing_km) / (a.wct_rearing_km + 1) * 100)::numeric, 2) as wct_rearing_km_diff_pct,
  (a.cm_spawning_km - b.cm_spawning_km) as cm_spawning_km_diff,
  round(((a.cm_spawning_km - b.cm_spawning_km) / (a.cm_spawning_km + 1) * 100)::numeric, 2) as cm_spawning_km_diff_pct,
  (a.pk_spawning_km - b.pk_spawning_km) as pk_spawning_km_diff,
  round(((a.pk_spawning_km - b.pk_spawning_km) / (a.pk_spawning_km + 1) * 100)::numeric, 2) as pk_spawning_km_diff_pct,
  (a.all_spawning_km - b.all_spawning_km) as all_spawning_km_diff,
  round(((a.all_spawning_km - b.all_spawning_km) / (a.all_spawning_km + 1) * 100)::numeric, 2) as all_spawning_km_diff_pct,
  (a.all_rearing_km - b.all_rearing_km) as all_rearing_km_diff,
  round(((a.all_rearing_km - b.all_rearing_km) / (a.all_rearing_km + 1) * 100)::numeric, 2) as all_rearing_km_diff_pct,
  (a.all_spawningrearing_km - b.all_spawningrearing_km) as all_spawningrearing_km_diff,
  (a.all_spawningrearing_km - b.all_spawningrearing_km) / (a.all_spawningrearing_km + 1) as all_spawningrearing_km_diff_pct,
  
  a.ch_co_sk_network_km as ch_co_sk_network_km_a,
  a.st_network_km as st_network_km_a,
  a.wct_network_km as wct_network_km_a,
  a.ch_spawning_km as ch_spawning_km_a,
  a.ch_rearing_km as ch_rearing_km_a,
  a.co_spawning_km as co_spawning_km_a,
  a.co_rearing_km as co_rearing_km_a,
  a.sk_spawning_km as sk_spawning_km_a,
  a.sk_rearing_km as sk_rearing_km_a,
  a.st_spawning_km as st_spawning_km_a,
  a.st_rearing_km as st_rearing_km_a,
  a.wct_spawning_km as wct_spawning_km_a,
  a.wct_rearing_km as wct_rearing_km_a,
  a.cm_spawning_km as cm_spawning_km_a,
  a.pk_spawning_km as pk_spawning_km_a,
  a.all_spawning_km as all_spawning_km_a,
  a.all_rearing_km as all_rearing_km_a,
  a.all_spawningrearing_km as all_spawningrearing_km_a,
  
  b.ch_co_sk_network_km as ch_co_sk_network_km_b,
  b.st_network_km as st_network_km_b,
  b.wct_network_km as wct_network_km_b,
  b.ch_spawning_km as ch_spawning_km_b,
  b.ch_rearing_km as ch_rearing_km_b,
  b.co_spawning_km as co_spawning_km_b,
  b.co_rearing_km as co_rearing_km_b,
  b.sk_spawning_km as sk_spawning_km_b,
  b.sk_rearing_km as sk_rearing_km_b,
  b.st_spawning_km as st_spawning_km_b,
  b.st_rearing_km as st_rearing_km_b,
  b.wct_spawning_km as wct_spawning_km_b,
  b.wct_rearing_km as wct_rearing_km_b,
  b.cm_spawning_km as cm_spawning_km_b,
  b.pk_spawning_km as pk_spawning_km_b,
  b.all_spawning_km as all_spawning_km_b,
  b.all_rearing_km as all_rearing_km_b,
  b.all_spawningrearing_km as all_spawningrearing_km_b
from latest a  
full outer join previous b 
on a.watershed_group_code = b.watershed_group_code;