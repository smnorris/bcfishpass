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

-- set belowupstrbarriers columns, defaulting to full amount
UPDATE bcfishpass.crossings_upstream_habitat p
SET
  bt_spawning_belowupstrbarriers_km = bt_spawning_km,
  bt_rearing_belowupstrbarriers_km = bt_rearing_km,
  ch_spawning_belowupstrbarriers_km = ch_spawning_km,
  ch_rearing_belowupstrbarriers_km = ch_rearing_km,
  cm_spawning_belowupstrbarriers_km = cm_spawning_km,
  co_spawning_belowupstrbarriers_km = co_spawning_km,
  co_rearing_belowupstrbarriers_km = co_rearing_km,
  pk_spawning_belowupstrbarriers_km = pk_spawning_km,
  sk_spawning_belowupstrbarriers_km = sk_spawning_km,
  sk_rearing_belowupstrbarriers_km = sk_rearing_km,
  st_spawning_belowupstrbarriers_km = st_spawning_km,
  st_rearing_belowupstrbarriers_km = st_rearing_km,
  wct_spawning_belowupstrbarriers_km = wct_spawning_km,
  wct_rearing_belowupstrbarriers_km = wct_rearing_km
WHERE watershed_group_code = :'wsg';

-- reset belowupstrbarriers columns for barriers with other barriers upstream
with barriers as
(
  select a.*, c.barriers_anthropogenic_dnstr
  from bcfishpass.crossings_upstream_habitat a
  inner join bcfishpass.barriers_anthropogenic b
  on a.aggregated_crossings_id = b.barriers_anthropogenic_id
  inner join bcfishpass.crossings c
  on b.barriers_anthropogenic_id = c.aggregated_crossings_id
),

above_upstream_barriers as
(
  SELECT
    a.aggregated_crossings_id,
    sum(b.bt_spawning_km) as bt_spawning_km,
    sum(b.bt_rearing_km) as bt_rearing_km,
    sum(b.ch_spawning_km) as ch_spawning_km,
    sum(b.ch_rearing_km) as ch_rearing_km,
    sum(b.cm_spawning_km) as cm_spawning_km,
    sum(b.co_spawning_km) as co_spawning_km,
    sum(b.co_rearing_km) as co_rearing_km,
    sum(b.pk_spawning_km) as pk_spawning_km,
    sum(b.sk_spawning_km) as sk_spawning_km,
    sum(b.sk_rearing_km) as sk_rearing_km,
    sum(b.st_spawning_km) as st_spawning_km,
    sum(b.st_rearing_km) as st_rearing_km,
    sum(b.wct_spawning_km) as wct_spawning_km,
    sum(b.wct_rearing_km) as wct_rearing_km
  FROM bcfishpass.crossings_upstream_habitat a
  INNER JOIN barriers b
  ON a.aggregated_crossings_id = b.barriers_anthropogenic_dnstr[1]
  WHERE a.watershed_group_code = :'wsg'
  group by a.aggregated_crossings_id
)

update bcfishpass.crossings_upstream_habitat a
SET
  bt_spawning_belowupstrbarriers_km = round((a.bt_spawning_km - b.bt_spawning_km)::numeric, 2),
  bt_rearing_belowupstrbarriers_km = round((a.bt_rearing_km - b.bt_rearing_km)::numeric, 2),
  ch_spawning_belowupstrbarriers_km = round((a.ch_spawning_km - b.ch_spawning_km)::numeric, 2),
  ch_rearing_belowupstrbarriers_km = round((a.ch_rearing_km - b.ch_rearing_km)::numeric, 2),
  cm_spawning_belowupstrbarriers_km = round((a.cm_spawning_km - b.cm_spawning_km)::numeric, 2),
  co_spawning_belowupstrbarriers_km = round((a.co_spawning_km - b.co_spawning_km)::numeric, 2),
  co_rearing_belowupstrbarriers_km = round((a.co_rearing_km - b.co_rearing_km)::numeric, 2),
  pk_spawning_belowupstrbarriers_km = round((a.pk_spawning_km - b.pk_spawning_km)::numeric, 2),
  sk_spawning_belowupstrbarriers_km = round((a.sk_spawning_km - b.sk_spawning_km)::numeric, 2),
  sk_rearing_belowupstrbarriers_km = round((a.sk_rearing_km - b.sk_rearing_km)::numeric, 2),
  st_spawning_belowupstrbarriers_km = round((a.st_spawning_km - b.st_spawning_km)::numeric, 2),
  st_rearing_belowupstrbarriers_km = round((a.st_rearing_km - b.st_rearing_km)::numeric, 2),
  wct_spawning_belowupstrbarriers_km = round((a.wct_spawning_km - b.wct_spawning_km)::numeric, 2),
  wct_rearing_belowupstrbarriers_km = round((a.wct_rearing_km - b.wct_rearing_km)::numeric, 2)
from above_upstream_barriers b
where a.aggregated_crossings_id = b.aggregated_crossings_id;


-- and calculating belowupstrbarriers for passable features with barriers upstream
with barriers as
(
  select
    a.*,
    c.blue_line_key,
    c.downstream_route_measure,
    c.wscode_ltree,
    c.localcode_ltree,
    c.barriers_anthropogenic_dnstr
  from bcfishpass.crossings_upstream_habitat a
  inner join bcfishpass.barriers_anthropogenic b
  on a.aggregated_crossings_id = b.barriers_anthropogenic_id
  inner join bcfishpass.crossings c
  on b.barriers_anthropogenic_id = c.aggregated_crossings_id
),

above_upstream_barriers as
(
  SELECT
    a.aggregated_crossings_id,
    sum(b.bt_spawning_km) as bt_spawning_km,
    sum(b.bt_rearing_km) as bt_rearing_km,
    sum(b.ch_spawning_km) as ch_spawning_km,
    sum(b.ch_rearing_km) as ch_rearing_km,
    sum(b.cm_spawning_km) as cm_spawning_km,
    sum(b.co_spawning_km) as co_spawning_km,
    sum(b.co_rearing_km) as co_rearing_km,
    sum(b.pk_spawning_km) as pk_spawning_km,
    sum(b.sk_spawning_km) as sk_spawning_km,
    sum(b.sk_rearing_km) as sk_rearing_km,
    sum(b.st_spawning_km) as st_spawning_km,
    sum(b.st_rearing_km) as st_rearing_km,
    sum(b.wct_spawning_km) as wct_spawning_km,
    sum(b.wct_rearing_km) as wct_rearing_km
  from bcfishpass.crossings_upstream_habitat a
  inner join bcfishpass.crossings c on a.aggregated_crossings_id = c.aggregated_crossings_id  -- join to crossings to get barrier status and barriers downstream of given crossing
  -- barriers are upstream of given crossing
  left outer join barriers b on
     fwa_upstream(c.blue_line_key, c.downstream_route_measure, c.wscode_ltree, c.localcode_ltree, b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree)
    -- barriers upstream have same downstream barrier id (or no barriers downstream)
    and (c.barriers_anthropogenic_dnstr[1] = b.barriers_anthropogenic_dnstr[1]
        or b.barriers_anthropogenic_dnstr is null
        )
  where a.watershed_group_code = :'wsg'
  and c.barrier_status in ('PASSABLE','UNKNOWN')  -- passable features / fords only
  group by a.aggregated_crossings_id
)

update bcfishpass.crossings_upstream_habitat a
set
  bt_spawning_belowupstrbarriers_km = round((a.bt_spawning_km - b.bt_spawning_km)::numeric, 2),
  bt_rearing_belowupstrbarriers_km = round((a.bt_rearing_km - b.bt_rearing_km)::numeric, 2),
  ch_spawning_belowupstrbarriers_km = round((a.ch_spawning_km - b.ch_spawning_km)::numeric, 2),
  ch_rearing_belowupstrbarriers_km = round((a.ch_rearing_km - b.ch_rearing_km)::numeric, 2),
  cm_spawning_belowupstrbarriers_km = round((a.cm_spawning_km - b.cm_spawning_km)::numeric, 2),
  co_spawning_belowupstrbarriers_km = round((a.co_spawning_km - b.co_spawning_km)::numeric, 2),
  co_rearing_belowupstrbarriers_km = round((a.co_rearing_km - b.co_rearing_km)::numeric, 2),
  pk_spawning_belowupstrbarriers_km = round((a.pk_spawning_km - b.pk_spawning_km)::numeric, 2),
  sk_spawning_belowupstrbarriers_km = round((a.sk_spawning_km - b.sk_spawning_km)::numeric, 2),
  sk_rearing_belowupstrbarriers_km = round((a.sk_rearing_km - b.sk_rearing_km)::numeric, 2),
  st_spawning_belowupstrbarriers_km = round((a.st_spawning_km - b.st_spawning_km)::numeric, 2),
  st_rearing_belowupstrbarriers_km = round((a.st_rearing_km - b.st_rearing_km)::numeric, 2),
  wct_spawning_belowupstrbarriers_km = round((a.wct_spawning_km - b.wct_spawning_km)::numeric, 2),
  wct_rearing_belowupstrbarriers_km = round((a.wct_rearing_km - b.wct_rearing_km)::numeric, 2)
from above_upstream_barriers b
where a.aggregated_crossings_id = b.aggregated_crossings_id;