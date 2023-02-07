-- Create a table for visualizing where manual updates have been applied
-- and to track whether the manual classification agrees with the model output
-- (to keep the streams table somewhat simple, model outputs get overwritten by
-- manual classification in below updates)
DROP table IF EXISTS bcfishpass.user_habitat_classification_qa;
CREATE table bcfishpass.user_habitat_classification_qa AS
WITH manual_habitat_class AS
(
    SELECT
      blue_line_key,
      downstream_route_measure,
      upstream_route_measure,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS model_spawning_ch,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS model_rearing_ch,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS model_spawning_cm,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS model_rearing_cm,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS model_spawning_co,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS model_rearing_co,
      CASE
        WHEN h.species_code = 'PK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS model_spawning_pk,
      CASE
        WHEN h.species_code = 'PK' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS model_rearing_pk,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS model_spawning_sk,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS model_rearing_sk,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS model_spawning_st,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS model_rearing_st,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS model_spawning_wct,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS model_rearing_wct,
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
  s.model_spawning_ch,
  s.model_rearing_ch,
  s.model_spawning_co,
  s.model_rearing_co,
  s.model_spawning_sk,
  s.model_rearing_sk,
  s.model_spawning_st,
  s.model_rearing_st,
  s.model_spawning_wct,
  s.model_rearing_wct,
  s.model_spawning_cm, 
  s.model_spawning_pk,
  h.model_spawning_ch AS model_spawning_ch_manual,
  h.model_rearing_ch AS model_rearing_ch_manual,
  h.model_spawning_co AS model_spawning_co_manual,
  h.model_rearing_co AS model_rearing_co_manual,
  h.model_spawning_sk AS model_spawning_sk_manual,
  h.model_rearing_sk AS model_rearing_sk_manual,
  h.model_spawning_st AS model_spawning_st_manual,
  h.model_rearing_st AS model_rearing_st_manual,
  h.model_spawning_wct AS model_spawning_wct_manual,
  h.model_rearing_wct AS model_rearing_wct_manual,
  h.model_spawning_cm AS model_spawning_cm_manual,
  h.model_spawning_pk AS model_spawning_pk_manual,
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
SET model_spawning_ch = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CH'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET model_rearing_ch = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CH'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET model_spawning_co = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CO'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET model_rearing_co = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CO'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET model_spawning_sk = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'SK'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET model_rearing_sk = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'SK'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET model_spawning_st = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'ST'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET model_rearing_st = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'ST'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET model_spawning_wct = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'WCT'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET model_rearing_wct = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'WCT'
AND h.habitat_type = 'rearing';

UPDATE bcfishpass.streams s
SET model_spawning_cm = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'CM'
AND h.habitat_type = 'spawning';

UPDATE bcfishpass.streams s
SET model_spawning_pk = h.habitat_ind
FROM bcfishpass.user_habitat_classification h
WHERE s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND h.species_code = 'PK'
AND h.habitat_type = 'spawning';
