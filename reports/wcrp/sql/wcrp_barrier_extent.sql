DROP FUNCTION postgisftw.wcrp_barrier_extent(TEXT, TEXT);

CREATE FUNCTION postgisftw.wcrp_barrier_extent(watershed_group_code TEXT, barrier_type TEXT default 'ALL')
--watershed_group: watershed group codes from db e.g. HORS, BULK, etc.
--barrier_type: eg. DAM, RAIL, etc. or if you wish to choose all within watershed ... ALL
  RETURNS TABLE(
    watershed_group_cd TEXT,
    structure_type TEXT,
    all_habitat_blocked_km numeric,
    all_habitat_blocked_pct numeric
  )

  LANGUAGE 'plpgsql'
  IMMUTABLE PARALLEL SAFE 

AS $$

DECLARE
   v_wsg   text := watershed_group_code;
   v_feat  text := barrier_type;

BEGIN
IF (v_feat = 'ALL')

    then RETURN query

    -- total habitat blocked by each barrier type / SEVERITY
    with barriers as
      (
      SELECT
        c.watershed_group_code,
        c.crossing_feature_type,
        ROUND(SUM(c.ch_spawning_belowupstrbarriers_km)::numeric, 2) as ch_spawning_blocked_km,
        ROUND(SUM(c.ch_rearing_belowupstrbarriers_km)::numeric, 2) as ch_rearing_blocked_km,
        ROUND(SUM(c.co_spawning_belowupstrbarriers_km)::numeric, 2) as co_spawning_blocked_km,
        ROUND(SUM(c.co_rearing_belowupstrbarriers_km)::numeric, 2) as co_rearing_blocked_km,
        ROUND(SUM(c.sk_spawning_belowupstrbarriers_km)::numeric, 2) as sk_spawning_blocked_km,
        ROUND(SUM(c.sk_rearing_belowupstrbarriers_km)::numeric, 2) as sk_rearing_blocked_km,
        ROUND(SUM(c.st_spawning_belowupstrbarriers_km)::numeric, 2) as st_spawning_blocked_km,
        ROUND(SUM(c.st_rearing_belowupstrbarriers_km)::numeric, 2) as st_rearing_blocked_km,
        ROUND(SUM(c.all_spawning_belowupstrbarriers_km)::numeric, 2) as all_spawning_blocked_km,
        ROUND(SUM(c.all_rearing_belowupstrbarriers_km)::numeric, 2) as all_rearing_blocked_km,
        ROUND(SUM(c.all_spawningrearing_belowupstrbarriers_km)::numeric, 2) as all_spawningrearing_blocked_km
      FROM bcfishpass.crossings c
      WHERE c.barrier_status IN ('POTENTIAL', 'BARRIER')
      AND c.aggregated_crossings_id != '1100002536' -- don't count the Elko Dam in ELKR
      --AND watershed_group_code = 'HORS'
      GROUP BY
        c.watershed_group_code,
        c.crossing_feature_type
      ORDER BY
        c.watershed_group_code,
        c.crossing_feature_type
      ),

      percent AS (
        SELECT
            *,
            ROUND(n.all_spawningrearing_blocked_km*100 / nsum,2) as pct_test
            FROM barriers n
            INNER JOIN (
            SELECT b.watershed_group_code, SUM(b.all_spawningrearing_blocked_km) as nsum
            FROM barriers b
            WHERE b.all_spawningrearing_blocked_km != 0
            group by b.watershed_group_code
            ) as num USING (watershed_group_code)
            WHERE n.watershed_group_code = v_wsg
            --AND n.crossing_feature_type = feature
      )

    SELECT
        p.watershed_group_code,
        p.crossing_feature_type,
        p.all_spawningrearing_blocked_km,
        p.pct_test
    FROM percent p;

ELSE
    RETURN query


    -- total habitat blocked by each barrier type / SEVERITY
    with barriers as
      (
      SELECT
        c.watershed_group_code,
        c.crossing_feature_type,
        ROUND(SUM(c.ch_spawning_belowupstrbarriers_km)::numeric, 2) as ch_spawning_blocked_km,
        ROUND(SUM(c.ch_rearing_belowupstrbarriers_km)::numeric, 2) as ch_rearing_blocked_km,
        ROUND(SUM(c.co_spawning_belowupstrbarriers_km)::numeric, 2) as co_spawning_blocked_km,
        ROUND(SUM(c.co_rearing_belowupstrbarriers_km)::numeric, 2) as co_rearing_blocked_km,
        ROUND(SUM(c.sk_spawning_belowupstrbarriers_km)::numeric, 2) as sk_spawning_blocked_km,
        ROUND(SUM(c.sk_rearing_belowupstrbarriers_km)::numeric, 2) as sk_rearing_blocked_km,
        ROUND(SUM(c.st_spawning_belowupstrbarriers_km)::numeric, 2) as st_spawning_blocked_km,
        ROUND(SUM(c.st_rearing_belowupstrbarriers_km)::numeric, 2) as st_rearing_blocked_km,
        ROUND(SUM(c.all_spawning_belowupstrbarriers_km)::numeric, 2) as all_spawning_blocked_km,
        ROUND(SUM(c.all_rearing_belowupstrbarriers_km)::numeric, 2) as all_rearing_blocked_km,
        ROUND(SUM(c.all_spawningrearing_belowupstrbarriers_km)::numeric, 2) as all_spawningrearing_blocked_km
      FROM bcfishpass.crossings c
      WHERE c.barrier_status IN ('POTENTIAL', 'BARRIER')
      AND c.aggregated_crossings_id != '1100002536' -- don't count the Elko Dam in ELKR
      --AND watershed_group_code = 'HORS'
      GROUP BY
        c.watershed_group_code,
        c.crossing_feature_type
      ORDER BY
        c.watershed_group_code,
        c.crossing_feature_type
      ),

      percent AS (
        SELECT
            *,
            ROUND(n.all_spawningrearing_blocked_km*100 / nsum,2) as pct_test
            FROM barriers n
            INNER JOIN (
            SELECT b.watershed_group_code, SUM(b.all_spawningrearing_blocked_km) as nsum
            FROM barriers b
            WHERE b.all_spawningrearing_blocked_km != 0
            group by b.watershed_group_code
            ) as num USING (watershed_group_code)
            WHERE n.watershed_group_code = v_wsg
            AND n.crossing_feature_type = v_feat
      )

    SELECT
        p.watershed_group_code,
        p.crossing_feature_type,
        p.all_spawningrearing_blocked_km,
        p.pct_test
    FROM percent p;

END IF;

END


$$;

COMMENT ON FUNCTION postgisftw.wcrp_barrier_extent IS
'Provided is a watershed name and a crossing feature type according to the structure of bcbarriers.
The output is a percentage of the sum of the crossing feature within the watershed relative to the
sum of all crossing feature types in the watershed. ';


REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_barrier_extent FROM public;
