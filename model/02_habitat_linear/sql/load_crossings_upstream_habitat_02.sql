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


-- update sum for barriers with other barriers upstream
with barriers as
(
  select
    h.aggregated_crossings_id,
    h.bt_spawning_km,
    h.bt_rearing_km,
    h.ch_spawning_km,
    h.ch_rearing_km,
    h.cm_spawning_km,
    h.co_spawning_km,
    h.co_rearing_km,
    h.pk_spawning_km,
    h.sk_spawning_km,
    h.sk_rearing_km,
    h.st_spawning_km,
    h.st_rearing_km,
    h.wct_spawning_km,
    h.wct_rearing_km,
    ad.features_dnstr as barriers_anthropogenic_dnstr
  from bcfishpass.crossings_upstream_habitat h
  -- barriers only
  inner join bcfishpass.barriers_anthropogenic b on h.aggregated_crossings_id = b.barriers_anthropogenic_id
  -- get the dnstr barrier ids
  left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on h.aggregated_crossings_id = ad.aggregated_crossings_id
),

above_upstream_barriers as
(
  select
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
  inner join barriers b on a.aggregated_crossings_id = b.barriers_anthropogenic_dnstr[1]
  inner join bcfishpass.crossings c on a.aggregated_crossings_id = c.aggregated_crossings_id
  where a.watershed_group_code = :'wsg'
  and c.blue_line_key = c.watershed_key  -- do not update crossings on side channels
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


-- update non-barriers with barrier upstream
with crossings as (
  select
    c.aggregated_crossings_id,
    c.blue_line_key,
    c.downstream_route_measure,
    c.wscode_ltree,
    c.localcode_ltree,
    c.barrier_status,
    ad.features_dnstr as barriers_anthropogenic_dnstr
  from bcfishpass.crossings c
  left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on c.aggregated_crossings_id = ad.aggregated_crossings_id
  where c.watershed_group_code = :'wsg'
  and c.barrier_status in ('PASSABLE','UNKNOWN')  -- passable features / fords only
  and c.blue_line_key = c.watershed_key           -- do not update side channels
),

above_upstr_barriers as
(
  select
    c.aggregated_crossings_id,
    sum(h.bt_spawning_km) as bt_spawning_km,
    sum(h.bt_rearing_km) as bt_rearing_km,
    sum(h.ch_spawning_km) as ch_spawning_km,
    sum(h.ch_rearing_km) as ch_rearing_km,
    sum(h.cm_spawning_km) as cm_spawning_km,
    sum(h.co_spawning_km) as co_spawning_km,
    sum(h.co_rearing_km) as co_rearing_km,
    sum(h.pk_spawning_km) as pk_spawning_km,
    sum(h.sk_spawning_km) as sk_spawning_km,
    sum(h.sk_rearing_km) as sk_rearing_km,
    sum(h.st_spawning_km) as st_spawning_km,
    sum(h.st_rearing_km) as st_rearing_km,
    sum(h.wct_spawning_km) as wct_spawning_km,
    sum(h.wct_rearing_km) as wct_rearing_km
  from crossings c
  -- join to upstream barriers
  inner join bcfishpass.barriers_anthropogenic b on
     fwa_upstream(c.blue_line_key, c.downstream_route_measure, c.wscode_ltree, c.localcode_ltree, b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree)
  left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on b.barriers_anthropogenic_id = ad.aggregated_crossings_id
  inner join bcfishpass.crossings_upstream_habitat h on b.barriers_anthropogenic_id = h.aggregated_crossings_id
  -- upstream barriers must have the same next downstream crossing as the crossing of interest (or no crossing downstream)
  where c.barriers_anthropogenic_dnstr[1] = ad.features_dnstr[1] or ad.features_dnstr is null
  group by c.aggregated_crossings_id
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
from above_upstr_barriers b
where a.aggregated_crossings_id = b.aggregated_crossings_id;