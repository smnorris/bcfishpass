-- total potential habitat blocked by each barrier type
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
GROUP BY
  watershed_group_code,
  crossing_feature_type
ORDER BY
  watershed_group_code,
  crossing_feature_type