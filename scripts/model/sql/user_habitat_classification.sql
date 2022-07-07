-- Create a table for visualizing where manual updates have been applied
-- and to track whether the manual classification agrees with the model output
-- (to keep the streams table somewhat simple, model outputs get overwritten by
-- manual classification in below updates)
DROP MATERIALIZED VIEW IF EXISTS bcfishpass.user_habitat_classification_svw;
CREATE MATERIALIZED VIEW bcfishpass.user_habitat_classification_svw AS
WITH manual_habitat_class AS
(
    SELECT
      blue_line_key,
      downstream_route_measure,
      upstream_route_measure,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_ch,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_ch,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_cm,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_cm,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_co,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_co,
      CASE
        WHEN h.species_code = 'PK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_pk,
      CASE
        WHEN h.species_code = 'PK' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_pk,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_sk,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_sk,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_st,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_st,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_model_wct,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_model_wct,
      h.reviewer_name,
      h.source,
      h.notes
    FROM bcfishpass.user_habitat_classification h
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
  s.spawning_model_ch,
  s.rearing_model_ch,
  s.spawning_model_co,
  s.rearing_model_co,
  s.spawning_model_sk,
  s.rearing_model_sk,
  s.spawning_model_st,
  s.rearing_model_st,
  s.spawning_model_wct,
  s.rearing_model_wct,
  s.spawning_model_cm, 
  s.spawning_model_pk,
  h.spawning_model_ch AS spawning_model_ch_manual,
  h.rearing_model_ch AS rearing_model_ch_manual,
  h.spawning_model_co AS spawning_model_co_manual,
  h.rearing_model_co AS rearing_model_co_manual,
  h.spawning_model_sk AS spawning_model_sk_manual,
  h.rearing_model_sk AS rearing_model_sk_manual,
  h.spawning_model_st AS spawning_model_st_manual,
  h.rearing_model_st AS rearing_model_st_manual,
  h.spawning_model_wct AS spawning_model_wct_manual,
  h.rearing_model_wct AS rearing_model_wct_manual,
  h.spawning_model_cm AS spawning_model_cm_manual,
  h.spawning_model_pk AS spawning_model_pk_manual,
  h.reviewer_name,
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
SET spawning_model_ch = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CH'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_ch = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CH'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET spawning_model_co = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CO'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_co = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CO'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET spawning_model_sk = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'SK'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_sk = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'SK'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET spawning_model_st = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'ST'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_st = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'ST'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET spawning_model_wct = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'WCT'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET rearing_model_wct = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'WCT'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET spawning_model_cm = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CM'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET spawning_model_pk = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'PK'
AND h.habitat_type = 'spawning';
