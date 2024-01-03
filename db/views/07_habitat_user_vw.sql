-- translate provided measures into segmented_stream_ids for easy lookup
DROP view IF EXISTS bcfishpass.habitat_user_vw;
CREATE view bcfishpass.habitat_user_vw AS
WITH manual_habitat_class AS
(
    SELECT distinct
      blue_line_key,
      downstream_route_measure,
      upstream_route_measure,
      CASE
        WHEN h.species_code = 'BT' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_bt,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_ch,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_cm,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_co,
      CASE
        WHEN h.species_code = 'PK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_pk,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_sk,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_st,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_wct,
      CASE
        WHEN h.species_code = 'BT' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_bt,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_ch,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_cm,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_co,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_sk,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_st,
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
  -- use bool_or to collapse separate spawning/rearing records for one stream segment into a single row
  bool_or(h.spawning_bt) as spawning_bt,
  bool_or(h.spawning_ch) as spawning_ch,
  bool_or(h.spawning_cm) as spawning_cm,
  bool_or(h.spawning_co) as spawning_co,
  bool_or(h.spawning_pk) as spawning_pk,
  bool_or(h.spawning_sk) as spawning_sk,
  bool_or(h.spawning_st) as spawning_st,
  bool_or(h.spawning_wct) as spawning_wct,
  bool_or(h.rearing_bt) as rearing_bt,
  bool_or(h.rearing_ch) as rearing_ch,
  bool_or(h.rearing_co) as rearing_co,
  bool_or(h.rearing_sk) as rearing_sk,
  bool_or(h.rearing_st) as rearing_st,
  bool_or(h.rearing_wct) as rearing_wct
FROM bcfishpass.streams s
INNER JOIN manual_habitat_class h
ON s.blue_line_key = h.blue_line_key
-- note that this join works because streams are already segmented at the endpoints
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
GROUP BY segmented_stream_id
ORDER BY segmented_stream_id;