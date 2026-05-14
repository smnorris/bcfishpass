BEGIN;

  -- note that this table doesn't exist in the standard load_crossings_upstream_habitat, data is generated in the query
  -- we retain it here for conveneince when working with barriers on FWA side channels
  DROP TABLE IF EXISTS bcfishpass.barriers_sidechannel_upstr_streams;
  CREATE TABLE bcfishpass.barriers_sidechannel_upstr_streams AS
  -- select all stream upstream of crossings, on the same blue_line_key
  WITH same_bl AS (
    SELECT DISTINCT on (a.aggregated_crossings_id, s.segmented_stream_id) -- account for multiple entries for same xing in above query
      a.aggregated_crossings_id,
      s.segmented_stream_id,
      s.watershed_group_code,
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
      w.ch,
      w.co,
      w.sk,
      w.st,
      w.wct,
      s.edge_type,
      st_length(s.geom) as length_metre
    from bcfishpass.crossings_sidechannel_upstream_startpoints a
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
      s2.segmented_stream_id,
      s1.watershed_group_code,
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
      w.ch,
      w.co,
      w.sk,
      w.st,
      w.wct,
      s2.edge_type,
      st_length(s2.geom) as length_metre
    from bcfishpass.crossings_sidechannel_upstream_startpoints a
    inner join bcfishpass.streams s1 on a.blue_line_key = s1.blue_line_key and a.downstream_route_measure = s1.downstream_route_measure
    inner join bcfishpass.streams s2 on fwa_upstream(
      a.blue_line_key,
      a.downstream_route_measure,
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


  -- note stream records with one of these side channels downstream
  DROP TABLE IF EXISTS bcfishpass.streams_dnstr_barriers_sidechannel;
  CREATE TABLE bcfishpass.streams_dnstr_barriers_sidechannel AS
  SELECT 
    segmented_stream_id,
    array_agg(aggregated_crossings_id) as barriers_anthropogenic_dnstr
  FROM bcfishpass.barriers_sidechannel_upstr_streams
  GROUP BY segmented_stream_id;


  -- find crossings upstream
  DROP TABLE IF EXISTS bcfishpass.barriers_sidechannel_upstr_barriers_anthropogenic;
  CREATE TABLE bcfishpass.barriers_sidechannel_upstr_barriers_anthropogenic AS
  WITH same_bl AS (
    SELECT DISTINCT
      a.aggregated_crossings_id,
      c2.wscode_ltree,
      c2.localcode_ltree,
      c2.downstream_route_measure,
      c2.aggregated_crossings_id as features_upstr
    from bcfishpass.crossings_sidechannel_upstream_startpoints a
    inner join bcfishpass.crossings c1 on a.aggregated_crossings_id = c1.aggregated_crossings_id
    inner join bcfishpass.crossings c2 on c1.blue_line_key = c2.blue_line_key and c1.downstream_route_measure < c2.downstream_route_measure and c2.aggregated_crossings_id != c1.aggregated_crossings_id
  ),

  -- select all crossings upstream of the other provided blue_line_key/measure values
  other_bl as (
    SELECT DISTINCT
      a.aggregated_crossings_id,
      c.wscode_ltree,
      c.localcode_ltree,
      c.downstream_route_measure,
      c.aggregated_crossings_id as feature_upstr
    from bcfishpass.crossings_sidechannel_upstream_startpoints a
    inner join bcfishpass.streams s on a.blue_line_key = s.blue_line_key and a.downstream_route_measure = s.downstream_route_measure
    inner join bcfishpass.crossings c on fwa_upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      s.wscode_ltree,
      s.localcode_ltree,
      c.blue_line_key,
      c.downstream_route_measure,
      c.wscode_ltree,
      c.localcode_ltree,
      true,
      1
    )
    inner join
      -- get distinct watershed codes to prevent double counting when the same
      -- watershed is included in multiple WCRPs. Note that this is a bit fragile,
      -- it presumes that each WCRP will target the same species within a given watershed group.
      (
        select distinct
          watershed_group_code, ch, co, sk, st, wct
        from bcfishpass.wcrp_watersheds
      ) as w on c.watershed_group_code = w.watershed_group_code
    ORDER BY
      a.aggregated_crossings_id,
      c.wscode_ltree desc,
      c.localcode_ltree desc,
      c.downstream_route_measure desc
  )

  SELECT * FROM same_bl
  UNION ALL
  SELECT * FROM other_bl
  ORDER BY aggregated_crossings_id,
  wscode_ltree desc,
  localcode_ltree desc,
  downstream_route_measure desc;

  -- reverse the above - note crossings with the side channel barrier(s) downstream
  DROP TABLE IF EXISTS bcfishpass.barriers_anthropogenic_dnstr_barriers_sidechannel;
  CREATE TABLE bcfishpass.barriers_anthropogenic_dnstr_barriers_sidechannel AS  
  
  -- select from existing barriers_anthropogenic_dnstr (with no side channel recs)
  WITH src_dnstr AS (
    SELECT a.barriers_anthropogenic_id, a.features_dnstr
    FROM bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic a
    INNER JOIN bcfishpass.barriers_sidechannel_upstr_barriers_anthropogenic b
    ON a.barriers_anthropogenic_id = b.features_upstr
  ),

  sidechannel_dnstr AS (
    SELECT 
      aggregated_crossings_id,
      array_agg(features_dnstr) filter (where features_dnstr is not null) as features_dnstr
    FROM (
      SELECT DISTINCT 
        a.features_upstr as aggregated_crossings_id, 
        a.wscode_ltree,
        a.localcode_ltree,
        a.downstream_route_measure,
        b.downstream_route_measure as measure_src, -- pull in original measure of the sidechannel point to order nested crossings on the side channel
        a.aggregated_crossings_id as features_dnstr
      FROM bcfishpass.barriers_sidechannel_upstr_barriers_anthropogenic a
      INNER JOIN bcfishpass.crossings b on a.aggregated_crossings_id = b.aggregated_crossings_id
    ORDER BY 
      features_upstr,
      wscode_ltree desc,
      localcode_ltree desc,
      downstream_route_measure desc,
      measure_src desc
    ) as f GROUP BY aggregated_crossings_id 
  )

  SELECT
   a.barriers_anthropogenic_id as aggregated_crossings_id,
   a.features_dnstr || b.features_dnstr as features_dnstr
  FROM src_dnstr a INNER JOIN sidechannel_dnstr b ON a.barriers_anthropogenic_id = b.aggregated_crossings_id;

COMMIT;