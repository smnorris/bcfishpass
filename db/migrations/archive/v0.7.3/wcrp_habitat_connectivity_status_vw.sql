-- add wcrp view dropped with v0.7.0 and missed in re-creation script

BEGIN;

  create view bcfishpass.wcrp_habitat_connectivity_status_vw as
  with length_totals as
  (
  -- all spawning (ch/co/st/sk/wct) - calculation is simple, just add it up
  -- ---------------
    SELECT
      s.watershed_group_code,
      'SPAWNING' as habitat_type,
      coalesce(round((SUM(ST_Length(s.geom)) FILTER (
        WHERE
        (h.spawning_ch > 0 and w.ch IS TRUE) OR
        (h.spawning_co > 0 AND w.co IS TRUE) OR
        (h.spawning_st > 0 AND w.st IS TRUE) OR
        (h.spawning_sk > 0 AND w.sk IS TRUE) OR
        (h.spawning_wct > 0 AND w.wct IS TRUE)
      ) / 1000)::numeric, 2), 0) as total_km,

      -- spawning accessible
      coalesce(round((SUM(ST_Length(s.geom)) FILTER (
        WHERE (
          (h.spawning_ch > 0 and w.ch IS TRUE) OR
          (h.spawning_co > 0 AND w.co IS TRUE) OR
          (h.spawning_st > 0 AND w.st IS TRUE) OR
          (h.spawning_sk > 0 AND w.sk IS TRUE) OR
          (h.spawning_wct > 0 AND w.wct IS TRUE)
        )
        AND a.barriers_anthropogenic_dnstr IS NULL
      ) / 1000)::numeric, 2), 0) as accessible_km
    from bcfishpass.streams s
    inner join bcfishpass.streams_habitat_linear h using (segmented_stream_id)
    inner join bcfishpass.streams_access a using (segmented_stream_id)
    inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
    group by s.watershed_group_code

    UNION ALL

  -- REARING length
  -- --------------
  -- rearing is more complex, add an extra .5 for CO/SK rearing in wetlands/lakes respectively

    SELECT
      s.watershed_group_code,
      'REARING' as habitat_type,
      round(
        (
          (
            coalesce(SUM(ST_Length(geom)) FILTER (
              WHERE
              (h.rearing_ch > 0 AND w.ch IS TRUE) OR
              (h.rearing_st > 0 AND w.st IS TRUE) OR
              (h.rearing_sk > 0 AND w.sk IS TRUE) OR
              (h.rearing_co > 0 AND w.co IS TRUE) OR
              (h.rearing_wct > 0 AND w.wct IS TRUE)
            ), 0) +
            -- add .5 coho rearing in wetlands
            coalesce(SUM(ST_Length(s.geom) * .5) FILTER (WHERE h.rearing_co > 0 AND w.co IS TRUE AND s.edge_type = 1050), 0) +
            -- add .5 sockeye rearing in lakes (all of it)
            coalesce(SUM(ST_Length(s.geom) * .5) FILTER (WHERE h.rearing_sk > 0 AND w.sk IS TRUE), 0)
          ) / 1000)::numeric, 2
        ) AS total_km,

      -- rearing accessible
      round(
        (
          (
            coalesce(SUM(ST_Length(geom)) FILTER (
              WHERE (
                (h.rearing_ch > 0 AND w.ch IS TRUE) OR
                (h.rearing_co > 0 AND w.co IS TRUE) OR
                (h.rearing_st > 0 AND w.st IS TRUE) OR
                (h.rearing_sk > 0 AND w.sk IS TRUE) OR
                (h.rearing_wct > 0 AND w.wct IS TRUE)
              )
              AND a.barriers_anthropogenic_dnstr IS NULL
            ), 0) +
            -- add .5 coho rearing in wetlands
            coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.rearing_co > 0 AND w.co IS TRUE AND edge_type = 1050 AND barriers_anthropogenic_dnstr IS NULL), 0) +
            -- add .5 sockeye rearing in lakes (all of it)
            coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.rearing_sk > 0 AND w.sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL), 0)
          ) / 1000)::numeric, 2
      ) AS accessible_km
    from bcfishpass.streams s
    inner join bcfishpass.streams_habitat_linear h using (segmented_stream_id)
    inner join bcfishpass.streams_access a using (segmented_stream_id)
    inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
    group by s.watershed_group_code

    UNION ALL

    -- spawning or rearing - total km of habitat
    SELECT
      s.watershed_group_code,
      'ALL' as habitat_type,
      round(
      (
        (
          coalesce(SUM(ST_Length(s.geom)) FILTER (
            WHERE
              (h.spawning_ch > 0 AND w.ch IS TRUE) OR
              (h.spawning_co > 0 AND w.co IS TRUE) OR
              (h.spawning_st > 0 AND w.st IS TRUE) OR
              (h.spawning_sk > 0 AND w.sk IS TRUE) OR
              (h.spawning_wct > 0 AND w.wct IS TRUE) OR
              (h.rearing_ch > 0 AND w.ch IS TRUE) OR
              (h.rearing_co > 0 AND w.co IS TRUE) OR
              (h.rearing_st > 0 AND w.st IS TRUE) OR
              (h.rearing_sk > 0 AND w.sk IS TRUE) OR
              (h.rearing_wct > 0 AND w.wct IS TRUE)
            ), 0) +
          -- add .5 coho rearing in wetlands
          coalesce(SUM(ST_Length(s.geom) * .5) FILTER (WHERE h.rearing_co > 0 AND w.co IS TRUE AND s.edge_type = 1050), 0) +
          -- add .5 sockeye rearing in lakes (all of it)
          coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.rearing_sk > 0 AND w.sk IS TRUE), 0)
        ) / 1000)::numeric, 2
      ) AS total_km,

    -- total acccessible km
     round(
      (
        (
          coalesce(SUM(ST_Length(geom)) FILTER (
            WHERE (
              (h.spawning_ch > 0 AND w.ch IS TRUE) OR
              (h.spawning_co > 0 AND w.co IS TRUE) OR
              (h.spawning_st > 0 AND w.st IS TRUE) OR
              (h.spawning_sk > 0 AND w.sk IS TRUE) OR
              (h.spawning_wct > 0 AND w.wct IS TRUE) OR
              (h.rearing_ch > 0 AND w.ch IS TRUE) OR
              (h.rearing_co > 0 AND w.co IS TRUE) OR
              (h.rearing_st > 0 AND w.st IS TRUE) OR
              (h.rearing_sk > 0 AND w.sk IS TRUE) OR
              (h.rearing_wct > 0 AND w.wct IS TRUE)
            )
            AND a.barriers_anthropogenic_dnstr IS NULL), 0) +
          -- add .5 coho rearing in wetlands
          coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.rearing_co > 0 AND edge_type = 1050 AND a.barriers_anthropogenic_dnstr IS NULL), 0) +
          -- add .5 sockeye rearing in lakes (all of it)
          coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.rearing_sk > 0 AND a.barriers_anthropogenic_dnstr IS NULL), 0)
        ) / 1000)::numeric, 2
      ) AS accessible_km
    from bcfishpass.streams s
    inner join bcfishpass.streams_habitat_linear h using (segmented_stream_id)
    inner join bcfishpass.streams_access a using (segmented_stream_id)
    inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
    group by s.watershed_group_code

    UNION ALL

    -- Upstream of Elko Dam
    SELECT
      s.watershed_group_code,
      'UPSTREAM_ELKO' as habitat_type,
      round(
        (
          (
            coalesce(SUM(ST_Length(s.geom)) FILTER (
              WHERE
                (h.spawning_wct > 0 AND w.wct IS TRUE) OR
                (h.rearing_wct > 0 AND w.wct IS TRUE)
            ), 0)
          ) / 1000)::numeric, 2
        ) AS total_km,

    -- total acccessible km
      round(
        (
          (
            coalesce(SUM(ST_Length(geom)) FILTER (
              WHERE (
                (h.spawning_wct > 0 AND w.wct IS TRUE) OR
                (h.rearing_wct > 0 AND w.wct IS TRUE)
              )
              AND a.barriers_anthropogenic_dnstr = (select barriers_anthropogenic_dnstr
                  from bcfishpass.streams s
                  inner join bcfishpass.streams_habitat_linear h using (segmented_stream_id)
                  inner join bcfishpass.streams_access a using (segmented_stream_id)
                  where segmented_stream_id like '356570562.22912000')), 0)
      ) / 1000)::numeric, 2
      ) AS accessible_km
    from bcfishpass.streams s
    inner join bcfishpass.streams_habitat_linear h using (segmented_stream_id)
    inner join bcfishpass.streams_access a using (segmented_stream_id)
    inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
    where FWA_Upstream(356570562, 22910, 22910, '300.625474.584724'::ltree, '300.625474.584724.100997'::ltree, blue_line_key, downstream_route_measure, wscode_ltree, localcode_ltree) -- only above Elko Dam
    group by s.watershed_group_code

  UNION ALL
    -- Downstream of Elko Dam
    SELECT
      s.watershed_group_code,
      'DOWNSTREAM_ELKO' as habitat_type,
      round(
        (
          (
            coalesce(SUM(ST_Length(s.geom)) FILTER (
              WHERE
                (h.spawning_wct > 0 AND w.wct IS TRUE) OR
                (h.rearing_wct > 0 AND w.wct IS TRUE)
            ), 0)
          ) / 1000)::numeric, 2
        ) AS total_km,

    -- total acccessible km
      round(
        (
          (
            coalesce(SUM(ST_Length(geom)) FILTER (
              WHERE (
                (h.spawning_wct > 0 AND w.wct IS TRUE) OR
                (h.rearing_wct > 0 AND w.wct IS TRUE)
              )
        AND a.barriers_anthropogenic_dnstr IS NULL
        AND a.barriers_wct_dnstr = array[]::text[]
        OR a.barriers_anthropogenic_dnstr = (select distinct barriers_anthropogenic_dnstr
                            from bcfishpass.streams s
                            inner join bcfishpass.streams_habitat_linear h using (segmented_stream_id)
                            inner join bcfishpass.streams_access a using (segmented_stream_id)
                            where linear_feature_id = 706872063)), 0)
      ) / 1000)::numeric, 2
      ) AS accessible_km
    from bcfishpass.streams s
    inner join bcfishpass.streams_habitat_linear h using (segmented_stream_id)
    inner join bcfishpass.streams_access a using (segmented_stream_id)
    inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
    where wscode_ltree <@ '300.625474.584724'::ltree  -- on the elk system and not above elko dam
    AND NOT FWA_Upstream(356570562, 22910, 22910, '300.625474.584724'::ltree, '300.625474.584724.100997'::ltree, blue_line_key, downstream_route_measure, wscode_ltree, localcode_ltree)
    group by s.watershed_group_code
  )

  select
    watershed_group_code,
    habitat_type,
    total_km,
    accessible_km,
    round((accessible_km / (total_km + .0001)) * 100, 2) as pct_accessible  -- add small amt to avoid division by zero
  from length_totals
  order by watershed_group_code, habitat_type desc;

COMMIT;