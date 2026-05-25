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

  -- With list of streams having these barriers downstream collected above, update the access table accordingly
  -- ***NOTES***
  -- - ASSUMES ANY/ALL CROSSING RECORDS IN SIDECHANNEL WORKAROUND TABLE ARE PSCIS BARRIERS
  -- - ASSUMES NO OTHER ANTHROPOGENIC BARRIERS ARE PRESENT DOWNSTREAM OF THE GIVEN PSCIS BARRIER 
  --  (the side channel crossing is appended to the end of the barrier downstream list)
  -- - does not update crossings_dnstr (this may already hold the crossing of interest)
  -- - does not update remediated_dnst_ind 
  UPDATE bcfishpass.streams_access a
  SET
    barriers_anthropogenic_dnstr = CASE
      WHEN a.barriers_anthropogenic_dnstr IS NULL AND b.barriers_anthropogenic_dnstr IS NULL THEN NULL
      ELSE COALESCE(a.barriers_anthropogenic_dnstr, '{}') || COALESCE(b.barriers_anthropogenic_dnstr, '{}')
    END,
    barriers_pscis_dnstr = CASE
      WHEN a.barriers_pscis_dnstr IS NULL AND b.barriers_anthropogenic_dnstr IS NULL THEN NULL
      ELSE COALESCE(a.barriers_pscis_dnstr, '{}') || COALESCE(b.barriers_anthropogenic_dnstr, '{}')
    END
  FROM bcfishpass.streams_dnstr_barriers_sidechannel b
  WHERE a.segmented_stream_id = b.segmented_stream_id;


 -- update crossings_dnstr_barriers_anthropogenic, adding the side channel barriers where needed
 -- note that only barriers get updated/inserted
 -- truncate bcfishpass.crossings_dnstr_barriers_anthropogenic;
 -- insert into bcfishpass.crossings_dnstr_barriers_anthropogenic select * from temp.crossings_dnstr_barriers_anthropogenic_bk;
 -- same bl (will only be other crossings on the same side channel)
 WITH same_bl AS (
    SELECT DISTINCT on (a.aggregated_crossings_id, c2.aggregated_crossings_id)
      
      c2.aggregated_crossings_id,
      a.aggregated_crossings_id as dnstr
    from bcfishpass.crossings_sidechannel_upstream_startpoints a
    inner join bcfishpass.crossings c on a.aggregated_crossings_id = c.aggregated_crossings_id
    inner join bcfishpass.crossings c2
      on c.blue_line_key = c2.blue_line_key and (c.downstream_route_measure - .01) < c2.downstream_route_measure
    where a.aggregated_crossings_id != c2.aggregated_crossings_id
    order by a.aggregated_crossings_id, c2.aggregated_crossings_id, c2.downstream_route_measure desc
  ),

  -- upstream on different bl - ie, non sidechannel
  other_bl as (
   select
      b.barriers_anthropogenic_id as aggregated_crossings_id,
      a.aggregated_crossings_id as dnstr
    from bcfishpass.crossings_sidechannel_upstream_startpoints a
    inner join bcfishpass.streams s1 on a.blue_line_key = s1.blue_line_key and a.downstream_route_measure = s1.downstream_route_measure
    inner join bcfishpass.crossings c on a.aggregated_crossings_id = c.aggregated_crossings_id -- get measure of side channel barrier so we can order correctly
    inner join bcfishpass.barriers_anthropogenic b on fwa_upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      s1.wscode_ltree,
      s1.localcode_ltree,
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      true,
      1
    )
    order by b.barriers_anthropogenic_id, c.downstream_route_measure desc
  ),

  to_upsert as (
    select 
        aggregated_crossings_id,
        array_agg(dnstr) as features_dnstr
      from 
      (
        SELECT * FROM same_bl
        UNION ALL
        SELECT * FROM other_bl
      ) as f
    group by aggregated_crossings_id
  )

 INSERT INTO bcfishpass.crossings_dnstr_barriers_anthropogenic (aggregated_crossings_id, features_dnstr)
 SELECT 
   aggregated_crossings_id, 
   features_dnstr
 from to_upsert
 ON CONFLICT (aggregated_crossings_id)
 DO UPDATE SET features_dnstr = bcfishpass.crossings_dnstr_barriers_anthropogenic.features_dnstr||EXCLUDED.features_dnstr;


-- do the same for crossings_upstr_barriers_anthropogenic
 -- same bl (will only be other crossings on the same side channel)
 WITH same_bl AS (
    SELECT DISTINCT on (a.aggregated_crossings_id, c2.aggregated_crossings_id)
      a.aggregated_crossings_id,
      c2.aggregated_crossings_id as upstr
      
    from bcfishpass.crossings_sidechannel_upstream_startpoints a
    inner join bcfishpass.crossings c on a.aggregated_crossings_id = c.aggregated_crossings_id
    inner join bcfishpass.crossings c2
      on c.blue_line_key = c2.blue_line_key and (c.downstream_route_measure - .01) < c2.downstream_route_measure
    where a.aggregated_crossings_id != c2.aggregated_crossings_id
    order by a.aggregated_crossings_id, c2.aggregated_crossings_id, c2.downstream_route_measure
  ),

  -- upstream on different bl - ie, non sidechannel
  other_bl as (
   select
      a.aggregated_crossings_id,
      c.barriers_anthropogenic_id as upstr
    from bcfishpass.crossings_sidechannel_upstream_startpoints a
    inner join bcfishpass.streams s1 on a.blue_line_key = s1.blue_line_key and a.downstream_route_measure = s1.downstream_route_measure
    inner join bcfishpass.barriers_anthropogenic c on fwa_upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      s1.wscode_ltree,
      s1.localcode_ltree,
      c.blue_line_key,
      c.downstream_route_measure,
      c.wscode_ltree,
      c.localcode_ltree,
      true,
      1
    )
  ),

  upstr as (
      SELECT * FROM same_bl
      UNION ALL
      SELECT * FROM other_bl
  )

  INSERT INTO bcfishpass.crossings_upstr_barriers_anthropogenic
  (aggregated_crossings_id, features_upstr)
  select aggregated_crossings_id, array_agg(upstr) as features_upstr
  from upstr
  group by aggregated_crossings_id
  order by aggregated_crossings_id
  ON CONFLICT (aggregated_crossings_id)
  DO UPDATE SET features_upstr = EXCLUDED.features_upstr;


COMMIT;