DROP FUNCTION postgisftw.wcrp_barrier_extent(TEXT, TEXT);

CREATE FUNCTION postgisftw.wcrp_barrier_extent(watershed_group TEXT, barrier_type TEXT)
--watershed_group: watershed group codes from db e.g. HORS, BULK, etc.
--barrier_type: eg. DAM, RAIL, etc. or if you wish to choose all within watershed ... ALL
  RETURNS TABLE(
    watershed TEXT,
    structure_type TEXT,
    all_habitat_blocked_km numeric,
    all_habitat_blocked_pct numeric
  )

  LANGUAGE 'plpgsql'
  IMMUTABLE PARALLEL SAFE 

AS $$

DECLARE
   v_water   text := watershed_group;
   v_feat  text := barrier_type;

BEGIN
IF (v_feat = 'ALL')

    then RETURN query

    -- total habitat blocked by each barrier type / SEVERITY
    with barriers as
      (
      SELECT
        watershed_group_code,
        crossing_feature_type,
        ROUND(SUM(ch_spawning_belowupstrbarriers_km)::numeric, 2) as ch_spawning_blocked_km,
        ROUND(SUM(ch_rearing_belowupstrbarriers_km)::numeric, 2) as ch_rearing_blocked_km,
        ROUND(SUM(co_spawning_belowupstrbarriers_km)::numeric, 2) as co_spawning_blocked_km,
        ROUND(SUM(co_rearing_belowupstrbarriers_km)::numeric, 2) as co_rearing_blocked_km,
        ROUND(SUM(sk_spawning_belowupstrbarriers_km)::numeric, 2) as sk_spawning_blocked_km,
        ROUND(SUM(sk_rearing_belowupstrbarriers_km)::numeric, 2) as sk_rearing_blocked_km,
        ROUND(SUM(st_spawning_belowupstrbarriers_km)::numeric, 2) as st_spawning_blocked_km,
        ROUND(SUM(st_rearing_belowupstrbarriers_km)::numeric, 2) as st_rearing_blocked_km,
        ROUND(SUM(all_spawning_belowupstrbarriers_km)::numeric, 2) as all_spawning_blocked_km,
        ROUND(SUM(all_rearing_belowupstrbarriers_km)::numeric, 2) as all_rearing_blocked_km,
        ROUND(SUM(all_spawningrearing_belowupstrbarriers_km)::numeric, 2) as all_spawningrearing_blocked_km
      FROM bcfishpass.crossings
      WHERE barrier_status IN ('POTENTIAL', 'BARRIER')
      AND aggregated_crossings_id != 1100002536 -- don't count the Elko Dam in ELKR
      --AND watershed_group_code = 'HORS'
      GROUP BY
        watershed_group_code,
        crossing_feature_type
      ORDER BY
        watershed_group_code,
        crossing_feature_type
      ),

      percent AS (
        SELECT
            *,
            ROUND(n.all_spawningrearing_blocked_km*100 / nsum,2) as pct_test
            FROM barriers n
            INNER JOIN(
            SELECT watershed_group_code, SUM(all_spawningrearing_blocked_km) as nsum
            FROM barriers
            WHERE all_spawningrearing_blocked_km != 0
            group by watershed_group_code
            )as num USING (watershed_group_code)
            WHERE n.watershed_group_code = v_water
            --AND n.crossing_feature_type = feature
      )

    SELECT
        watershed_group_code,
        crossing_feature_type,
        all_spawningrearing_blocked_km,
        pct_test
    FROM percent;

ELSE
    RETURN query


    -- total habitat blocked by each barrier type / SEVERITY
    with barriers as
      (
      SELECT
        watershed_group_code,
        crossing_feature_type,
        ROUND(SUM(ch_spawning_belowupstrbarriers_km)::numeric, 2) as ch_spawning_blocked_km,
        ROUND(SUM(ch_rearing_belowupstrbarriers_km)::numeric, 2) as ch_rearing_blocked_km,
        ROUND(SUM(co_spawning_belowupstrbarriers_km)::numeric, 2) as co_spawning_blocked_km,
        ROUND(SUM(co_rearing_belowupstrbarriers_km)::numeric, 2) as co_rearing_blocked_km,
        ROUND(SUM(sk_spawning_belowupstrbarriers_km)::numeric, 2) as sk_spawning_blocked_km,
        ROUND(SUM(sk_rearing_belowupstrbarriers_km)::numeric, 2) as sk_rearing_blocked_km,
        ROUND(SUM(st_spawning_belowupstrbarriers_km)::numeric, 2) as st_spawning_blocked_km,
        ROUND(SUM(st_rearing_belowupstrbarriers_km)::numeric, 2) as st_rearing_blocked_km,
        ROUND(SUM(all_spawning_belowupstrbarriers_km)::numeric, 2) as all_spawning_blocked_km,
        ROUND(SUM(all_rearing_belowupstrbarriers_km)::numeric, 2) as all_rearing_blocked_km,
        ROUND(SUM(all_spawningrearing_belowupstrbarriers_km)::numeric, 2) as all_spawningrearing_blocked_km
      FROM bcfishpass.crossings
      WHERE barrier_status IN ('POTENTIAL', 'BARRIER')
      AND aggregated_crossings_id != 1100002536 -- don't count the Elko Dam in ELKR
      --AND watershed_group_code = 'HORS'
      GROUP BY
        watershed_group_code,
        crossing_feature_type
      ORDER BY
        watershed_group_code,
        crossing_feature_type
      ),

      percent AS (
        SELECT
            *,
            ROUND(n.all_spawningrearing_blocked_km*100 / nsum,2) as pct_test
            FROM barriers n
            INNER JOIN(
            SELECT watershed_group_code, SUM(all_spawningrearing_blocked_km) as nsum
            FROM barriers
            WHERE all_spawningrearing_blocked_km != 0
            group by watershed_group_code
            )as num USING (watershed_group_code)
            WHERE n.watershed_group_code = v_water
            AND n.crossing_feature_type = v_feat
      )

    SELECT
        watershed_group_code,
        crossing_feature_type,
        all_spawningrearing_blocked_km,
        pct_test
    FROM percent;

END IF;

END


$$;

COMMENT ON FUNCTION postgisftw.wcrp_barrier_extent IS
'Provided is a watershed name and a crossing feature type according to the structure of bcbarriers.
The output is a percentage of the sum of the crossing feature within the watershed relative to the
sum of all crossing feature types in the watershed. ';
