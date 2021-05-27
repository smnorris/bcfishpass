-- Create a view for visualizing where manual updates have been applied
-- and to track whether the manual classification agrees with the model output
-- (to keep the streams table somewhat simple, model outputs get overwritten by
-- manual classification in below updates)
DROP MATERIALIZED VIEW IF EXISTS bcfishpass.manual_habitat_classification_svw;
CREATE MATERIALIZED VIEW bcfishpass.manual_habitat_classification_svw AS
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
      END AS rearing_model_wct,
      h.reviewer,
      h.source,
      h.notes
    FROM bcfishpass.manual_habitat_classification h
)

SELECT
  s.segmented_stream_id,
  s.linear_feature_id,
  s.blue_line_key,
  s.downstream_route_measure,
  s.upstream_route_measure,
  s.watershed_group_code,
  s.wscode_ltree,
  s.localcode_ltree,
  s.spawning_model_chinook,
  s.rearing_model_chinook,
  s.spawning_model_coho,
  s.rearing_model_coho,
  s.spawning_model_sockeye,
  s.rearing_model_sockeye,
  s.spawning_model_steelhead,
  s.rearing_model_steelhead,
  s.spawning_model_wct,
  s.rearing_model_wct,
  h.spawning_model_chinook AS spawning_model_chinook_manual,
  h.rearing_model_chinook AS rearing_model_chinook_manual,
  h.spawning_model_coho AS spawning_model_coho_manual,
  h.rearing_model_coho AS rearing_model_coho_manual,
  h.spawning_model_sockeye AS spawning_model_sockeye_manual,
  h.rearing_model_sockeye AS rearing_model_sockeye_manual,
  h.spawning_model_steelhead AS spawning_model_steelhead_manual,
  h.rearing_model_steelhead AS rearing_model_steelhead_manual,
  h.spawning_model_wct AS spawning_model_wct_manual,
  h.rearing_model_wct AS rearing_model_wct_manual,
  h.reviewer,
  h.source,
  h.notes,
  s.geom
FROM bcfishpass.streams s
INNER JOIN manual_habitat_class h
ON s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
ORDER BY s.blue_line_key, s.downstream_route_measure, h.blue_line_key;



-- Apply the manual habitat classifications to the streams table.
-- Because we are conditionally updating many columns, updates are most easily applied
-- per species/habitat type
UPDATE bcfishpass.streams s
SET spawning_model_chinook = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CH'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_chinook = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CH'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET spawning_model_coho = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CO'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_coho = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CO'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET spawning_model_sockeye = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'SK'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_sockeye = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'SK'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET spawning_model_steelhead = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'ST'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_steelhead = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'ST'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET spawning_model_wct = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'WCT'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_wct = h.habitat_ind
FROM bcfishpass.manual_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'WCT'
AND h.habitat_type = 'rearing';
