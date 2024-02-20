DROP FUNCTION IF EXISTS postgisftw.wcrp_barrier_extent(TEXT);

CREATE FUNCTION postgisftw.wcrp_barrier_extent(watershed_group_code TEXT)

-- watershed_group_code: BULK, LNIC, HORS, BOWR, QUES, CARR, ELKR

  RETURNS TABLE(
    crossing_feature_type TEXT,
    all_habitat_blocked_km numeric,
    total_habitat_km numeric,
    extent_pct numeric
  )

  LANGUAGE 'plpgsql'
  IMMUTABLE PARALLEL SAFE 

AS $$

DECLARE
   v_wsg   text := watershed_group_code;

BEGIN

RETURN query

with barriers as (
  select
    c.watershed_group_code,
    ft.crossing_feature_type,
    ROUND(SUM(h_wcrp.all_spawningrearing_belowupstrbarriers_km)::numeric, 2) as all_spawningrearing_blocked_km
  FROM bcfishpass.crossings c
  inner join bcfishpass.crossings_upstream_habitat uh using (aggregated_crossings_id)
  inner join bcfishpass.crossings_feature_type_vw ft using (aggregated_crossings_id)
  inner join bcfishpass.crossings_upstream_habitat_wcrp h_wcrp using (aggregated_crossings_id)
  WHERE c.barrier_status IN ('POTENTIAL', 'BARRIER')
  AND c.aggregated_crossings_id != '1100002536' -- don't count the Elko Dam in ELKR
  AND c.watershed_group_code = v_wsg
  GROUP BY c.watershed_group_code, ft.crossing_feature_type
  ORDER BY c.watershed_group_code, ft.crossing_feature_type
),

total AS (
  SELECT
    b.crossing_feature_type,
    b.all_spawningrearing_blocked_km,
    (SELECT all_habitat FROM postgisftw.wcrp_habitat_connectivity_status(v_wsg)) as total_habitat_km
  FROM barriers b
)

SELECT
  t.crossing_feature_type,
  t.all_spawningrearing_blocked_km,
  t.total_habitat_km,
  round((t.all_spawningrearing_blocked_km / t.total_habitat_km) * 100, 2) as extent_pct
FROM total t;

END


$$;

COMMENT ON FUNCTION postgisftw.wcrp_barrier_extent IS
'Return km of all blocked spawning and rearing by barrier type, and the percentage of
total spawning and rearing within given watershed group that this blocked habitat represents.';


REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_barrier_extent FROM public;

-- select * from postgisftw.wcrp_barrier_extent('QUES');