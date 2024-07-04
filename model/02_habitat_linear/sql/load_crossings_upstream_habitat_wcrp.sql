-- report on all ch/co/sk/st/wct habitat present in WCRP watersheds
-- note that this query presumes that if any of these species are present
-- in a given group, they are all of interest in the reporting

-- ** if adding a new watershed group or target species, additional per-watershed group logic may be required **
-- (for example, SHUL contains co/sk/wct - if WCT were not a target species in this watershed group, logic would be
-- required to exclude it from the 'all' computations)

truncate bcfishpass.crossings_upstream_habitat_wcrp;

-- ---------------------------------
-- report on linear habitat length upstream of barriers
-- ---------------------------------
with upstr as materialized
(
  select
    a.aggregated_crossings_id,
    a.watershed_group_code,
    h.spawning_ch,
    h.rearing_ch,
    h.spawning_co,
    h.rearing_co,
    h.spawning_sk,
    h.rearing_sk,
    h.spawning_st,
    h.rearing_st,
    h.spawning_wct,
    h.rearing_wct,
    s.edge_type,
    st_length(s.geom) as length_metre
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
  where a.watershed_group_code in ('BULK','LNIC','HORS','BOWR','QUES','CARR','ELKR')
  and a.blue_line_key = a.watershed_key  -- do not report on crossings on side channels
  -- barriers only
  and a.barrier_status in ('BARRIER', 'POTENTIAL')
)

insert into bcfishpass.crossings_upstream_habitat_wcrp
(
  aggregated_crossings_id,
  watershed_group_code,
  co_rearing_km,
  sk_rearing_km,
  all_spawning_km,
  all_rearing_km,
  all_spawningrearing_km
)
select
  s.aggregated_crossings_id,
  s.watershed_group_code,
  -- coho rearing gets 50% boost in wetlands
  round(
    (
      (
        coalesce(sum(length_metre) FILTER (WHERE s.rearing_co IS TRUE), 0) +
        coalesce(sum(length_metre * .5) FILTER (WHERE s.rearing_co IS TRUE AND edge_type = 1050), 0)
      ) / 1000
    )::numeric, 2
  ) AS co_rearing_km,

  -- all sockeye rearing gets 50% boost
  round(
    (
      (
        coalesce(sum(length_metre * 1.5) FILTER (WHERE s.rearing_sk IS TRUE), 0)
      ) / 1000
    )::numeric, 2
  ) as sk_rearing_km,

  -- all spawning
  coalesce(round(((sum(length_metre) filter (where
    s.spawning_ch is true or
    s.spawning_co is true or
    s.spawning_sk is true or
    s.spawning_st is true or
    s.spawning_wct is true) / 1000))::numeric, 2), 0) as all_spawning_km,

  -- all rearing
  round(
      (
        (
          coalesce(sum(length_metre) FILTER (
            WHERE
            s.rearing_ch IS TRUE OR
            s.rearing_st IS TRUE OR
            s.rearing_sk IS TRUE OR
            s.rearing_co IS TRUE OR
            s.rearing_wct IS TRUE
          ), 0) +
          -- add .5 coho rearing in wetlands
          coalesce(sum(length_metre * .5) FILTER (WHERE s.rearing_co IS TRUE AND s.edge_type = 1050), 0) +
          -- add .5 sockeye rearing in lakes (all of it)
          coalesce(sum(length_metre * .5) FILTER (WHERE s.spawning_sk IS TRUE), 0)
        ) / 1000)::numeric, 2
  ) as all_rearing_km,

  -- all spawning or rearing
  round(
      (
        (
          coalesce(sum(length_metre) FILTER (
            WHERE
            s.spawning_ch is true or
            s.spawning_co is true or
            s.spawning_sk is true or
            s.spawning_st is true or
            s.spawning_wct is true or
            s.rearing_ch is true or
            s.rearing_st is true or
            s.rearing_sk is true or
            s.rearing_co is true or
            s.rearing_wct is true
          ), 0) +
          -- add .5 coho rearing in wetlands
          coalesce(sum(length_metre * .5) FILTER (WHERE s.rearing_co IS TRUE AND s.edge_type = 1050), 0) +
          -- add .5 sockeye rearing in lakes (all of it)
          coalesce(sum(length_metre * .5) FILTER (WHERE s.spawning_sk IS TRUE), 0)
        ) / 1000)::numeric, 2
  ) as all_spawningrearing_km
from upstr s
group by s.watershed_group_code, s.aggregated_crossings_id
order by s.watershed_group_code, s.aggregated_crossings_id;


-- set belowupstrbarriers columns, defaulting to full amount
UPDATE bcfishpass.crossings_upstream_habitat_wcrp p
SET
  co_rearing_belowupstrbarriers_km = co_rearing_km,
  sk_rearing_belowupstrbarriers_km = sk_rearing_km,
  all_spawning_belowupstrbarriers_km = all_spawning_km,
  all_rearing_belowupstrbarriers_km = all_rearing_km,
  all_spawningrearing_belowupstrbarriers_km = all_spawningrearing_km;


-- update sum for barriers with other barriers upstream
with barriers as
(
  select
    h.aggregated_crossings_id,
    h.co_rearing_km,
    h.sk_rearing_km,
    h.all_spawning_km,
    h.all_rearing_km,
    h.all_spawningrearing_km,
    ad.features_dnstr as barriers_anthropogenic_dnstr
  from bcfishpass.crossings_upstream_habitat_wcrp h
  -- get the dnstr barrier ids
  left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on h.aggregated_crossings_id = ad.aggregated_crossings_id
),

above_upstream_barriers as
(
  select
    a.aggregated_crossings_id,
    sum(b.co_rearing_km) as co_rearing_km,
    sum(b.sk_rearing_km) as sk_rearing_km,
    sum(b.all_spawning_km) as all_spawning_km,
    sum(b.all_rearing_km) as all_rearing_km,
    sum(b.all_spawningrearing_km) as all_spawningrearing_km
  from bcfishpass.crossings_upstream_habitat_wcrp a
  inner join barriers b on a.aggregated_crossings_id = b.barriers_anthropogenic_dnstr[1]
  inner join bcfishpass.crossings c on a.aggregated_crossings_id = c.aggregated_crossings_id
  where c.blue_line_key = c.watershed_key  -- do not update crossings on side channels
  group by a.aggregated_crossings_id
)

update bcfishpass.crossings_upstream_habitat_wcrp a
SET
  co_rearing_belowupstrbarriers_km = round((a.co_rearing_km - b.co_rearing_km)::numeric, 2),
  sk_rearing_belowupstrbarriers_km = round((a.sk_rearing_km - b.sk_rearing_km)::numeric, 2),
  all_spawning_belowupstrbarriers_km = round((a.all_spawning_km - b.all_spawning_km)::numeric, 2),
  all_rearing_belowupstrbarriers_km = round((a.all_rearing_km - b.all_rearing_km)::numeric, 2),
  all_spawningrearing_belowupstrbarriers_km = round((a.all_spawningrearing_km - b.all_spawningrearing_km)::numeric, 2)
from above_upstream_barriers b
where a.aggregated_crossings_id = b.aggregated_crossings_id;