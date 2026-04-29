-- report on target species habitat present in WCRP watersheds
-- NOTE
-- If a barrier has another WCRP watershed upstream, the WCRP target species for that upstream watershed will be used
-- to derive the 'all species' spawning/rearing summaries within that watershed.
-- This should not generally be an issue, cross-watershed barriers are generally major dams that are out of scope for WCRP reporting

BEGIN;

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
    FROM bcfishpass.barriers_sidechannel_upstr_streams
  )

  INSERT INTO bcfishpass.crossings_upstream_habitat_wcrp
  (
    aggregated_crossings_id,
    watershed_group_code,
    ch_spawning_km,
    ch_rearing_km,
    ch_spawningrearing_km,
    co_spawning_km,
    co_rearing_km,
    co_spawningrearing_km,
    sk_spawning_km,
    sk_rearing_km,
    sk_spawningrearing_km,
    st_spawning_km,
    st_rearing_km,
    st_spawningrearing_km,
    wct_spawning_km,
    wct_rearing_km,
    wct_spawningrearing_km,
    all_spawning_km,
    all_rearing_km,
    all_spawningrearing_km
  )
  select
    s.aggregated_crossings_id,
    s.watershed_group_code,
    
    -- *CHINOOK
    coalesce(((sum(length_metre) filter (where s.spawning_ch > 0) / 1000))::numeric, 0) as ch_spawning_km,
    coalesce(((sum(length_metre) filter (where s.rearing_ch > 0) / 1000))::numeric, 0) as ch_rearing_km,
    coalesce(((sum(length_metre) filter (where s.spawning_ch > 0 OR s.rearing_ch > 0) / 1000))::numeric, 0) as ch_spawningrearing_km,

    -- *COHO
    coalesce(((sum(length_metre) filter (where s.spawning_co > 0) / 1000))::numeric, 0) as co_spawning_km,
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

    -- *SOCKEYE
    coalesce(((sum(length_metre) filter (where s.spawning_sk > 0) / 1000))::numeric, 0) as sk_spawning_km,
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
   
    -- *STEELHEAD
    coalesce(((sum(length_metre) filter (where s.spawning_st > 0) / 1000))::numeric, 0) as st_spawning_km,
    coalesce(((sum(length_metre) filter (where s.rearing_st > 0) / 1000))::numeric, 0) as st_rearing_km,
    coalesce(((sum(length_metre) filter (where s.spawning_st > 0 OR s.rearing_st > 0) / 1000))::numeric, 0) as st_spawningrearing_km,
    
    -- *WCT
    coalesce(((sum(length_metre) filter (where s.spawning_wct > 0) / 1000))::numeric, 0) as wct_spawning_km,
    coalesce(((sum(length_metre) filter (where s.rearing_wct > 0) / 1000))::numeric, 0) as wct_rearing_km,
    coalesce(((sum(length_metre) filter (where s.spawning_wct > 0 OR s.rearing_wct > 0) / 1000))::numeric, 0) as wct_spawningrearing_km,

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
    ch_spawning_belowupstrbarriers_km = ch_spawning_km,
    ch_rearing_belowupstrbarriers_km = ch_rearing_km,
    ch_spawningrearing_belowupstrbarriers_km = ch_spawningrearing_km,

    co_spawning_belowupstrbarriers_km = co_spawning_km,
    co_rearing_belowupstrbarriers_km = co_rearing_km,
    co_spawningrearing_belowupstrbarriers_km = co_spawningrearing_km,
    
    sk_spawning_belowupstrbarriers_km = sk_spawning_km,
    sk_rearing_belowupstrbarriers_km = sk_rearing_km,
    sk_spawningrearing_belowupstrbarriers_km = sk_spawningrearing_km,
    
    st_spawning_belowupstrbarriers_km = st_spawning_km,
    st_rearing_belowupstrbarriers_km = st_rearing_km,
    st_spawningrearing_belowupstrbarriers_km = st_spawningrearing_km,
    
    wct_spawning_belowupstrbarriers_km = wct_spawning_km,
    wct_rearing_belowupstrbarriers_km = wct_rearing_km,
    wct_spawningrearing_belowupstrbarriers_km = wct_spawningrearing_km,

    all_spawning_belowupstrbarriers_km = all_spawning_km,
    all_rearing_belowupstrbarriers_km = all_rearing_km,
    all_spawningrearing_belowupstrbarriers_km = all_spawningrearing_km;

  
  -- ------------------
  -- now update sum for barriers with other barriers upstream
  -- ------------------
  
  with dnstr_barriers_anthropogenic AS (

    -- update crossings_dnstr_barriers_anthropogenic with the side channel barriers
    SELECT
      aggregated_crossings_id,
      features_dnstr
    FROM bcfishpass.barriers_anthropogenic_dnstr_barriers_sidechannel AS b

    UNION ALL

    SELECT 
      aggregated_crossings_id, 
      features_dnstr
    FROM bcfishpass.crossings_dnstr_barriers_anthropogenic AS a
    WHERE NOT EXISTS (
      SELECT 1 FROM bcfishpass.barriers_anthropogenic_dnstr_barriers_sidechannel AS b
      WHERE b.aggregated_crossings_id = a.aggregated_crossings_id
    )
  ),

  barriers as (
    select
      h.aggregated_crossings_id,
      h.ch_spawning_km,
      h.ch_rearing_km,
      h.ch_spawningrearing_km,
      h.co_spawning_km,
      h.co_rearing_km,
      h.co_spawningrearing_km,
      h.sk_spawning_km,
      h.sk_rearing_km,
      h.sk_spawningrearing_km,
      h.st_spawning_km,
      h.st_rearing_km,
      h.st_spawningrearing_km,
      h.wct_spawning_km,
      h.wct_rearing_km,
      h.wct_spawningrearing_km,
      h.all_spawning_km,
      h.all_rearing_km,
      h.all_spawningrearing_km,
      ad.features_dnstr as barriers_anthropogenic_dnstr
    from bcfishpass.crossings_upstream_habitat_wcrp h
    -- barriers only
    inner join bcfishpass.barriers_anthropogenic b on h.aggregated_crossings_id = b.barriers_anthropogenic_id
    -- get the dnstr barrier ids
    left outer join dnstr_barriers_anthropogenic ad on h.aggregated_crossings_id = ad.aggregated_crossings_id
  ),

  above_upstream_barriers as
  (
    select
      a.aggregated_crossings_id,
      sum(b.ch_spawning_km) as ch_spawning_km,
      sum(b.ch_rearing_km) as ch_rearing_km,
      sum(b.ch_spawningrearing_km) as ch_spawningrearing_km,
      sum(b.co_spawning_km) as co_spawning_km,
      sum(b.co_rearing_km) as co_rearing_km,
      sum(b.co_spawningrearing_km) as co_spawningrearing_km,
      sum(b.sk_spawning_km) as sk_spawning_km,
      sum(b.sk_rearing_km) as sk_rearing_km,
      sum(b.sk_spawningrearing_km) as sk_spawningrearing_km,
      sum(b.st_spawning_km) as st_spawning_km,
      sum(b.st_rearing_km) as st_rearing_km,
      sum(b.st_spawningrearing_km) as st_spawningrearing_km,
      sum(b.wct_spawning_km) as wct_spawning_km,
      sum(b.wct_rearing_km) as wct_rearing_km,
      sum(b.wct_spawningrearing_km) as wct_spawningrearing_km,
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
    ch_spawning_belowupstrbarriers_km = round((a.ch_spawning_km - b.ch_spawning_km)::numeric, 2),
    ch_rearing_belowupstrbarriers_km = round((a.ch_rearing_km - b.ch_rearing_km)::numeric, 2),
    ch_spawningrearing_belowupstrbarriers_km = round((a.ch_spawningrearing_km - b.ch_spawningrearing_km)::numeric, 2),
    co_spawning_belowupstrbarriers_km = round((a.co_spawning_km - b.co_spawning_km)::numeric, 2),
    co_rearing_belowupstrbarriers_km = round((a.co_rearing_km - b.co_rearing_km)::numeric, 2),
    co_spawningrearing_belowupstrbarriers_km = round((a.co_spawningrearing_km - b.co_spawningrearing_km)::numeric, 2),
    sk_spawning_belowupstrbarriers_km = round((a.sk_spawning_km - b.sk_spawning_km)::numeric, 2),
    sk_rearing_belowupstrbarriers_km = round((a.sk_rearing_km - b.sk_rearing_km)::numeric, 2),
    sk_spawningrearing_belowupstrbarriers_km = round((a.sk_spawningrearing_km - b.sk_spawningrearing_km)::numeric, 2),
    st_spawning_belowupstrbarriers_km = round((a.st_spawning_km - b.st_spawning_km)::numeric, 2),
    st_rearing_belowupstrbarriers_km = round((a.st_rearing_km - b.st_rearing_km)::numeric, 2),
    st_spawningrearing_belowupstrbarriers_km = round((a.st_spawningrearing_km - b.st_spawningrearing_km)::numeric, 2),
    wct_spawning_belowupstrbarriers_km = round((a.wct_spawning_km - b.wct_spawning_km)::numeric, 2),
    wct_rearing_belowupstrbarriers_km = round((a.wct_rearing_km - b.wct_rearing_km)::numeric, 2),
    wct_spawningrearing_belowupstrbarriers_km = round((a.wct_spawningrearing_km - b.wct_spawningrearing_km)::numeric, 2),
    all_spawning_belowupstrbarriers_km = round((a.all_spawning_km - b.all_spawning_km)::numeric, 2),
    all_rearing_belowupstrbarriers_km = round((a.all_rearing_km - b.all_rearing_km)::numeric, 2),
    all_spawningrearing_belowupstrbarriers_km = round((a.all_spawningrearing_km - b.all_spawningrearing_km)::numeric, 2)
  from above_upstream_barriers b
  where a.aggregated_crossings_id = b.aggregated_crossings_id;

COMMIT;  