-- report on target species habitat present in WCRP watersheds
-- NOTE
-- If a barrier has another WCRP watershed upstream, the WCRP target species for that upstream watershed will be used
-- to derive the 'all species' spawning/rearing summaries within that watershed.
-- This should not generally be an issue, cross-watershed barriers are generally major dams that are out of scope for WCRP reporting


-- ---------------------------------
-- first, special handling for a few high impact crossings on side channels
-- ---------------------------------
CREATE TABLE side_channels_streams_upstr AS

-- **adding crossings**
-- For each crossing on side channel, add crossing id, blue line key and starting measure for any network position to be considered 
-- above the crossing in question. Upstream habitat on the same blkey as the crossing will automatically be included. 
WITH additional_streams AS (
  SELECT * FROM (VALUES 
    ('197665', 360869846, 0),
    ('198090', 360746107, 0),
    ('198090', 360765936, 0),
    ('203334', 360732514, 0),
    ('203323', 360613085, 0),
    ('203323', 360732514, 0)
  ) as t(aggregated_crossings_id, blue_line_key, measure)
),

-- select all stream upstream of crossings, on the same blue_line_key
same_bl AS (
  SELECT DISTINCT on (a.aggregated_crossings_id, s.segmented_stream_id) -- account for multiple entries for same xing in above query
    a.aggregated_crossings_id,
    -- s.segmented_stream_id,
    s.watershed_group_code,
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
    w.ch,
    w.co,
    w.sk,
    w.st,
    w.wct,
    s.edge_type,
    st_length(s.geom) as length_metre
  from additional_streams a
  inner join bcfishpass.crossings c on a.aggregated_crossings_id = c.aggregated_crossings_id
  inner join bcfishpass.streams s
    on c.blue_line_key = s.blue_line_key and (c.downstream_route_measure - .01) < s.downstream_route_measure
  inner join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
  inner join
    -- get distinct watershed codes to prevent double counting when the same
    -- watershed is included in multiple WCRPs. Note that this is a bit fragile,
    -- it presumes that each WCRP will target the same species within a given watershed group.
    (
      select distinct
        watershed_group_code, ch, co, sk, st, wct
      from bcfishpass.wcrp_watersheds
    ) as w on s.watershed_group_code = w.watershed_group_code
  order by aggregated_crossings_id, s.segmented_stream_id
),

-- select all stream upstream of the other provided blue_line_key/measure values
other_bl as (
 select
    a.aggregated_crossings_id,
    -- s2.segmented_stream_id,
    s1.watershed_group_code,
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
    w.ch,
    w.co,
    w.sk,
    w.st,
    w.wct,
    s2.edge_type,
    st_length(s2.geom) as length_metre
  from additional_streams a
  inner join bcfishpass.streams s1 on a.blue_line_key = s1.blue_line_key and a.measure = s1.downstream_route_measure
  inner join bcfishpass.streams s2 on fwa_upstream(
    a.blue_line_key,
    a.measure,
    s1.wscode_ltree,
    s1.localcode_ltree,
    s2.blue_line_key,
    s2.downstream_route_measure,
    s2.wscode_ltree,
    s2.localcode_ltree,
    true,
    1
  )
  inner join bcfishpass.streams_habitat_linear h on s2.segmented_stream_id = h.segmented_stream_id
  inner join
    -- get distinct watershed codes to prevent double counting when the same
    -- watershed is included in multiple WCRPs. Note that this is a bit fragile,
    -- it presumes that each WCRP will target the same species within a given watershed group.
    (
      select distinct
        watershed_group_code, ch, co, sk, st, wct
      from bcfishpass.wcrp_watersheds
    ) as w on s1.watershed_group_code = w.watershed_group_code
)

SELECT * FROM same_bl
UNION ALL
SELECT * FROM other_bl;


-- ---------------------------------
-- set total upstream habitat length
-- ---------------------------------

truncate bcfishpass.crossings_upstream_habitat_wcrp;

with upstr as materialized
(
  SELECT
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
    w.ch,
    w.co,
    w.sk,
    w.st,
    w.wct,
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
  inner join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
  inner join
    -- get distinct watershed codes to prevent double counting when the same
    -- watershed is included in multiple WCRPs. Note that this is a bit fragile,
    -- it presumes that each WCRP will target the same species within a given watershed group.
    (
      select distinct
        watershed_group_code, ch, co, sk, st, wct
      from bcfishpass.wcrp_watersheds
    ) as w on a.watershed_group_code = w.watershed_group_code
  where a.blue_line_key = a.watershed_key  -- do not report on crossings on side channels

  UNION ALL

  SELECT
    aggregated_crossings_id,
    watershed_group_code,
    spawning_ch,
    rearing_ch,
    spawning_co,
    rearing_co,
    spawning_sk,
    rearing_sk,
    spawning_st,
    rearing_st,
    spawning_wct,
    rearing_wct,
    ch,
    co,
    sk,
    st,
    wct,
    edge_type,
    length_metre
  FROM side_channels_streams_upstr
)

INSERT INTO bcfishpass.crossings_upstream_habitat_wcrp
(
  aggregated_crossings_id,
  watershed_group_code,
  co_rearing_km,
  co_spawningrearing_km,
  sk_rearing_km,
  sk_spawningrearing_km,
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
        coalesce(sum(length_metre) FILTER (WHERE s.rearing_co > 0 AND s.co IS TRUE), 0) +
        coalesce(sum(length_metre * .5) FILTER (WHERE s.rearing_co > 0 AND s.co IS TRUE AND edge_type = 1050), 0)
      ) / 1000
    )::numeric, 2
  ) AS co_rearing_km,

  -- coho rearing gets 50% boost in wetlands
  round(
    (
      (
        coalesce(sum(length_metre) FILTER (WHERE s.spawning_co > 0  OR s.rearing_co > 0 AND s.co IS TRUE), 0) + 
        coalesce(sum(length_metre * .5) FILTER (WHERE s.rearing_co > 0 AND s.co IS TRUE AND edge_type = 1050), 0)
      ) / 1000
    )::numeric, 2
  ) AS co_spawingrearing_km,

  -- all sockeye rearing gets 50% boost
  round(
    (
      (
        coalesce(sum(length_metre * 1.5) FILTER (WHERE s.rearing_sk > 0 AND s.sk IS TRUE), 0)
      ) / 1000
    )::numeric, 2
  ) as sk_rearing_km,

  -- sockeye rearing gets 50% boost
  round(
    (
      (
        coalesce(sum(length_metre) FILTER (WHERE s.spawning_sk > 0 OR s.rearing_sk > 0 AND s.sk IS TRUE), 0) +
        coalesce(sum(length_metre * 0.5) FILTER (WHERE s.rearing_sk > 0 AND s.sk IS TRUE), 0)
      ) / 1000
    )::numeric, 2
  ) as sk_spawningrearing_km,
 
  -- all spawning
  coalesce(round(((sum(length_metre) filter (
    where
    (s.spawning_ch > 0 and s.ch is true) or
    (s.spawning_co > 0 and s.co is true) or
    (s.spawning_sk > 0 and s.sk is true) or
    (s.spawning_st > 0 and s.st is true) or
    (s.spawning_wct > 0 and s.wct is true)
  ) / 1000))::numeric, 2), 0) as all_spawning_km,

  -- all rearing
  round(
      (
        (
          coalesce(sum(length_metre) FILTER (
            WHERE
            (s.rearing_ch > 0 AND s.ch IS TRUE) OR
            (s.rearing_st > 0 AND s.st IS TRUE) OR
            (s.rearing_sk > 0 AND s.sk IS TRUE) OR
            (s.rearing_co > 0 AND s.co IS TRUE) OR
            (s.rearing_wct > 0 AND s.wct IS TRUE)
          ), 0) +
          -- add .5 coho rearing in wetlands
          coalesce(sum(length_metre * .5) FILTER (WHERE s.rearing_co > 0 AND s.co IS TRUE AND s.edge_type = 1050), 0) +
          -- add .5 sockeye rearing in lakes (all of it)
          coalesce(sum(length_metre * .5) FILTER (WHERE s.rearing_sk > 0 AND s.sk IS TRUE), 0)
        ) / 1000)::numeric, 2
  ) as all_rearing_km,

  -- all spawning or rearing
  round(
      (
        (
          coalesce(sum(length_metre) FILTER (
            WHERE
            (s.spawning_ch > 0 and s.ch is true) or
            (s.spawning_co > 0 and s.co is true) or
            (s.spawning_sk > 0 and s.sk is true) or
            (s.spawning_st > 0 and s.st is true) or
            (s.spawning_wct > 0 and s.wct is true) or
            (s.rearing_ch > 0 and s.ch is true) or
            (s.rearing_st > 0 and s.st is true) or
            (s.rearing_sk > 0 and s.sk is true) or
            (s.rearing_co > 0 and s.co is true) or
            (s.rearing_wct > 0 and s.wct is true)
          ), 0) +
          -- add .5 coho rearing in wetlands
          coalesce(sum(length_metre * .5) FILTER (WHERE s.rearing_co > 0 AND s.co IS TRUE AND s.edge_type = 1050), 0) +
          -- add .5 sockeye rearing in lakes (all of it)
          coalesce(sum(length_metre * .5) FILTER (WHERE s.rearing_sk > 0 AND s.sk IS TRUE), 0)
        ) / 1000)::numeric, 2
  ) as all_spawningrearing_km
from upstr s
group by s.watershed_group_code, s.aggregated_crossings_id
order by s.watershed_group_code, s.aggregated_crossings_id;



-- ---------------------------------
-- set belowupstrbarriers columns
-- ---------------------------------

-- default to full amount
UPDATE bcfishpass.crossings_upstream_habitat_wcrp p
SET
  co_rearing_belowupstrbarriers_km = co_rearing_km,
  co_spawningrearing_belowupstrbarriers_km = co_spawningrearing_km,
  sk_rearing_belowupstrbarriers_km = sk_rearing_km,
  sk_spawningrearing_belowupstrbarriers_km = sk_spawningrearing_km,
  all_spawning_belowupstrbarriers_km = all_spawning_km,
  all_rearing_belowupstrbarriers_km = all_rearing_km,
  all_spawningrearing_belowupstrbarriers_km = all_spawningrearing_km;


-- now update sum for barriers with other barriers upstream
with side_channel_recs AS (
  -- **update as required** - for all side channel crossings noted in side_channels_streams_upstr above,
  -- collect all barriers upstream into this selection in format:
  -- (aggregated crossing_id of upstr crossing, array[aggregated crossing id of side channel crossing])
  -- This matches below barriers selection (list all barriers, and the ids of the crossing downstream of the barriers)
  SELECT * FROM (VALUES 
      ('197664', array['197665']),
      ('198048', array['198090']),
      ('203334', array['203323']),
      ('1001000007', array['203323']),
      ('1001000013', array['203334'])
    ) as t(barriers_anthropogenic_id, features_dnstr)
),

barriers as (
  select
    h.aggregated_crossings_id,
    h.co_rearing_km,
    h.co_spawningrearing_km,
    h.sk_rearing_km,
    h.sk_spawningrearing_km,
    h.all_spawning_km,
    h.all_rearing_km,
    h.all_spawningrearing_km,
    ad.features_dnstr as barriers_anthropogenic_dnstr
  from bcfishpass.crossings_upstream_habitat_wcrp h
  -- barriers only
  inner join bcfishpass.barriers_anthropogenic b on h.aggregated_crossings_id = b.barriers_anthropogenic_id
  -- get the dnstr barrier ids
  left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on h.aggregated_crossings_id = ad.aggregated_crossings_id

  UNION ALL

  select
      h.aggregated_crossings_id,
      h.co_rearing_km,
      h.co_spawningrearing_km,
      h.sk_rearing_km,
      h.sk_spawningrearing_km,
      h.all_spawning_km,
      h.all_rearing_km,
      h.all_spawningrearing_km,
      ad.features_dnstr as barriers_anthropogenic_dnstr
    from bcfishpass.crossings_upstream_habitat_wcrp h
    -- barriers only (should be the case anyway...)
    inner join bcfishpass.barriers_anthropogenic b on h.aggregated_crossings_id = b.barriers_anthropogenic_id
    inner join side_channel_recs ad on h.aggregated_crossings_id = ad.barriers_anthropogenic_id
),

above_upstream_barriers as
(
  select
    a.aggregated_crossings_id,
    sum(b.co_rearing_km) as co_rearing_km,
    sum(b.co_spawningrearing_km) as co_spawningrearing_km,
    sum(b.sk_rearing_km) as sk_rearing_km,
    sum(b.sk_spawningrearing_km) as sk_spawningrearing_km,
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
  co_spawningrearing_belowupstrbarriers_km = round((a.co_spawningrearing_km - b.co_spawningrearing_km)::numeric, 2),
  sk_rearing_belowupstrbarriers_km = round((a.sk_rearing_km - b.sk_rearing_km)::numeric, 2),
  sk_spawningrearing_belowupstrbarriers_km = round((a.sk_spawningrearing_km - b.sk_spawningrearing_km)::numeric, 2),
  all_spawning_belowupstrbarriers_km = round((a.all_spawning_km - b.all_spawning_km)::numeric, 2),
  all_rearing_belowupstrbarriers_km = round((a.all_rearing_km - b.all_rearing_km)::numeric, 2),
  all_spawningrearing_belowupstrbarriers_km = round((a.all_spawningrearing_km - b.all_spawningrearing_km)::numeric, 2)
from above_upstream_barriers b
where a.aggregated_crossings_id = b.aggregated_crossings_id;