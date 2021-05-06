WITH manual_habitat_class AS
(
    SELECT
      blue_line_key,
      downstream_route_measure,
      upstream_route_measure,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_chinook,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_chinook,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_coho,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_coho,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_sockeye,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_sockeye,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_steelhead,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_steelhead,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_wct,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_wct
    FROM bcfishpass.manual_habitat_classification h
)

SELECT
  s.segmented_stream_id,
  s.blue_line_key as blue_line_key_s,
  ROUND(s.downstream_route_measure::numeric, 2) as downstream_route_measure_s,
  ROUND(s.upstream_route_measure::numeric, 2) as upstream_route_measure_s,
  h.blue_line_key as blue_line_key_h,
  ROUND(h.downstream_route_measure::numeric, 2) as downstream_route_measure_h,
  ROUND(h.upstream_route_measure::numeric, 2) as upstream_route_measure_h,
  h.spawning_model_chinook,
  h.rearing_model_chinook,
  h.spawning_model_coho,
  h.rearing_model_coho,
  h.spawning_model_sockeye,
  h.rearing_model_sockeye,
  h.spawning_model_steelhead,
  h.rearing_model_steelhead,
  h.spawning_model_wct,
  h.rearing_model_wct
FROM bcfishpass.streams s
FULL OUTER JOIN manual_habitat_class h
ON s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
ORDER BY s.blue_line_key, s.downstream_route_measure, h.blue_line_key