-- Add habitat per barrier column to crossings table, excluding Elko dam from calculations.

ALTER TABLE bcfishpass.crossings ADD COLUMN IF NOT EXISTS all_spawningrearing_per_barrier double precision DEFAULT 0;

COMMENT ON COLUMN bcfishpass.crossings.all_spawningrearing_per_barrier IS 'If the given barrier and all barriers downstream were remediated, the amount of connected spawning/rearing habitat that would be added, per barrier. (ie the sum of all_spawningrearing_belowupstrbarriers_km for all barriers, divided by n barriers)';

WITH summary AS
(
    SELECT 
      a.aggregated_crossings_id,
      ROUND((SUM(b.all_spawningrearing_belowupstrbarriers_km) / (COALESCE(array_length(a.dnstr_barriers_anthropogenic - array[1100001508], 1), 0) + 1))::numeric, 2) as all_spawningrearing_per_barrier
    FROM bcfishpass.crossings a 
    INNER JOIN bcfishpass.crossings b
    ON FWA_Downstream(a.blue_line_key, a.downstream_route_measure, a.wscode_ltree, a.localcode_ltree, b.blue_line_key, b.downstream_route_measure, b.wscode_ltree, b.localcode_ltree, true)
    AND a.watershed_group_code = b.watershed_group_code
    WHERE b.barrier_status IN ('BARRIER','POTENTIAL')
    AND b.aggregated_crossings_id != 1100001508
    AND a.all_spawningrearing_belowupstrbarriers_km != 0
    GROUP BY a.aggregated_crossings_id
)

UPDATE bcfishpass.crossings a
SET all_spawningrearing_per_barrier = b.all_spawningrearing_per_barrier
FROM summary b
WHERE a.aggregated_crossings_id = b.aggregated_crossings_id;

