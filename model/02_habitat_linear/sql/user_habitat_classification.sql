-- translate provided measures into segmented_stream_ids for easy lookup
DROP table IF EXISTS bcfishpass.habitat_user;
CREATE table bcfishpass.habitat_user AS
WITH manual_habitat_class AS
(
    SELECT
      blue_line_key,
      downstream_route_measure,
      upstream_route_measure,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_ch,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_ch,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_cm,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_cm,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_co,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_co,
      CASE
        WHEN h.species_code = 'PK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_pk,
      CASE
        WHEN h.species_code = 'PK' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_pk,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_sk,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_sk,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_st,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_st,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_wct,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_wct,
      h.reviewer_name,
      h.source,
      h.notes
    FROM bcfishpass.user_habitat_classification h
)

SELECT
  s.segmented_stream_id,
  h.spawning_ch,
  h.rearing_ch,
  h.spawning_co,
  h.rearing_co,
  h.spawning_sk,
  h.rearing_sk,
  h.spawning_st,
  h.rearing_st,
  h.spawning_wct,
  h.rearing_wct,
  h.spawning_cm,
  h.spawning_pk,
  h.reviewer_name,
  h.source,
  h.notes
FROM bcfishpass.streams s
INNER JOIN manual_habitat_class h
ON s.blue_line_key = h.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
ORDER BY s.blue_line_key, s.downstream_route_measure, h.blue_line_key;