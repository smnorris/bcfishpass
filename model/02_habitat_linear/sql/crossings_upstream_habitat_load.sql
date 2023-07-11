-- ---------------------------------
-- report on linear habitat length upstream of crossings
-- ---------------------------------
with upstr as materialized
(
  select
    a.aggregated_crossings_id,
    a.watershed_group_code,
    s.model_spawning_bt,
    s.model_rearing_bt,
    s.model_spawning_ch,
    s.model_rearing_ch,
    s.model_spawning_cm,
    s.model_spawning_co,
    s.model_rearing_co,
    s.model_spawning_pk,
    s.model_spawning_sk,
    s.model_rearing_sk,
    s.model_spawning_st,
    s.model_rearing_st,
    s.model_spawning_wct,
    s.model_rearing_wct,
    s.geom
  from bcfishpass.crossings a
  left outer join bcfishpass.streams s
  on fwa_upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      s.blue_line_key,
      s.downstream_route_measure,
      s.wscode_ltree,
      s.localcode_ltree,
      true,
      1
     )
  where a.watershed_group_code = :'wsg'
  and a.blue_line_key = a.watershed_key  -- do not report on crossings on side channels
)

insert into bcfishpass.crossings_upstream_habitat
(
  aggregated_crossings_id,
  watershed_group_code,
  bt_spawning_km,
  bt_rearing_km,
  ch_spawning_km,
  ch_rearing_km,
  cm_spawning_km,
  co_spawning_km,
  co_rearing_km,
  pk_spawning_km,
  sk_spawning_km,
  sk_rearing_km,
  st_spawning_km,
  st_rearing_km,
  wct_spawning_km,
  wct_rearing_km
)
select
  s.aggregated_crossings_id,
  s.watershed_group_code,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_spawning_bt is true) / 1000))::numeric, 2), 0) as bt_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_rearing_bt is true) / 1000))::numeric, 2), 0) as bt_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_spawning_ch is true) / 1000))::numeric, 2), 0) as ch_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_rearing_ch is true) / 1000))::numeric, 2), 0) as ch_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_spawning_cm is true) / 1000))::numeric, 2), 0) as cm_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_spawning_co is true) / 1000))::numeric, 2), 0) as co_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_rearing_co is true) / 1000))::numeric, 2), 0) as co_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_spawning_pk is true) / 1000))::numeric, 2), 0) as pk_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_spawning_sk is true) / 1000))::numeric, 2), 0) as sk_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_rearing_sk is true) / 1000))::numeric, 2), 0) as sk_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_spawning_st is true) / 1000))::numeric, 2), 0) as st_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_rearing_st is true) / 1000))::numeric, 2), 0) as st_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_spawning_wct is true) / 1000))::numeric, 2), 0) as wct_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.model_rearing_wct is true) / 1000))::numeric, 2), 0) as wct_rearing_km
from upstr s
group by s.aggregated_crossings_id, s.watershed_group_code;