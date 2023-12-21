-- ---------------------------------
-- report on linear habitat length upstream of crossings
-- ---------------------------------
with upstr as materialized
(
  select
    a.aggregated_crossings_id,
    a.watershed_group_code,
    h.spawning_bt,
    h.rearing_bt,
    h.spawning_ch,
    h.rearing_ch,
    h.spawning_cm,
    h.spawning_co,
    h.rearing_co,
    h.spawning_pk,
    h.spawning_sk,
    h.rearing_sk,
    h.spawning_st,
    h.rearing_st,
    h.spawning_wct,
    h.rearing_wct,
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
  inner join bcfishpass.streams_habitat_linear_vw h on s.segmented_stream_id = h.segmented_stream_id
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
  coalesce(round(((sum(st_length(s.geom)) filter (where s.spawning_bt is true) / 1000))::numeric, 2), 0) as bt_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.rearing_bt is true) / 1000))::numeric, 2), 0) as bt_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.spawning_ch is true) / 1000))::numeric, 2), 0) as ch_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.rearing_ch is true) / 1000))::numeric, 2), 0) as ch_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.spawning_cm is true) / 1000))::numeric, 2), 0) as cm_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.spawning_co is true) / 1000))::numeric, 2), 0) as co_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.rearing_co is true) / 1000))::numeric, 2), 0) as co_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.spawning_pk is true) / 1000))::numeric, 2), 0) as pk_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.spawning_sk is true) / 1000))::numeric, 2), 0) as sk_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.rearing_sk is true) / 1000))::numeric, 2), 0) as sk_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.spawning_st is true) / 1000))::numeric, 2), 0) as st_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.rearing_st is true) / 1000))::numeric, 2), 0) as st_rearing_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.spawning_wct is true) / 1000))::numeric, 2), 0) as wct_spawning_km,
  coalesce(round(((sum(st_length(s.geom)) filter (where s.rearing_wct is true) / 1000))::numeric, 2), 0) as wct_rearing_km
from upstr s
group by s.aggregated_crossings_id, s.watershed_group_code;