-- view of known/observed spawning / rearing locations (from CWF/FISS/PSE) for easy ref
begin; 

  truncate bcfishpass.streams_habitat_known;

  WITH manual_habitat_class AS (
    SELECT distinct
      blue_line_key,
      downstream_route_measure,
      upstream_route_measure,
      CASE
        WHEN h.species_code = 'BT' THEN h.spawning
      END AS spawning_bt,
      CASE
        WHEN h.species_code = 'CH' THEN h.spawning
      END AS spawning_ch,
      CASE
        WHEN h.species_code = 'CM' THEN h.spawning
      END AS spawning_cm,
      CASE
        WHEN h.species_code = 'CO' THEN h.spawning
      END AS spawning_co,
      CASE
        WHEN h.species_code = 'PK' THEN h.spawning
      END AS spawning_pk,
      CASE
        WHEN h.species_code = 'SK' THEN h.spawning
      END AS spawning_sk,
      CASE
        WHEN h.species_code = 'ST' THEN h.spawning
      END AS spawning_st,
      CASE
        WHEN h.species_code = 'WCT' THEN h.spawning
      END AS spawning_wct,
      CASE
        WHEN h.species_code = 'BT' THEN h.rearing
      END AS rearing_bt,
      CASE
        WHEN h.species_code = 'CH' THEN h.rearing
      END AS rearing_ch,
      CASE
        WHEN h.species_code = 'CM' THEN h.rearing
      END AS rearing_cm,
      CASE
        WHEN h.species_code = 'CO' THEN h.rearing
      END AS rearing_co,
      CASE
        WHEN h.species_code = 'SK' THEN h.rearing
      END AS rearing_sk,
      CASE
        WHEN h.species_code = 'ST' THEN h.rearing
      END AS rearing_st,
      CASE
        WHEN h.species_code = 'WCT' THEN h.rearing
      END AS rearing_wct,
      h.reviewer_name,
      h.source,
      h.notes
    FROM bcfishpass.user_habitat_classification h
  )

  INSERT INTO bcfishpass.streams_habitat_known (
    segmented_stream_id ,
    spawning_bt         ,
    spawning_ch         ,
    spawning_cm         ,
    spawning_co         ,
    spawning_pk         ,
    spawning_sk         ,
    spawning_st         ,
    spawning_wct        ,
    rearing_bt          ,
    rearing_ch          ,
    rearing_co          ,
    rearing_sk          ,
    rearing_st          ,
    rearing_wct         
  )

  SELECT
    s.segmented_stream_id,
    -- use min() to collapse separate spawning/rearing records for one stream segment into a single row.
    -- Retaining the lowest value ensures -4 takes precedence in event of duplicate values.
    -- (this is not robust - a check should be added to ensure overlapping and conflicting records are not added)
    min(h.spawning_bt) as spawning_bt,
    min(h.spawning_ch) as spawning_ch,
    min(h.spawning_cm) as spawning_cm,
    min(h.spawning_co) as spawning_co,
    min(h.spawning_pk) as spawning_pk,
    min(h.spawning_sk) as spawning_sk,
    min(h.spawning_st) as spawning_st,
    min(h.spawning_wct) as spawning_wct,
    min(h.rearing_bt) as rearing_bt,
    min(h.rearing_ch) as rearing_ch,
    min(h.rearing_co) as rearing_co,
    min(h.rearing_sk) as rearing_sk,
    min(h.rearing_st) as rearing_st,
    min(h.rearing_wct) as rearing_wct
  FROM bcfishpass.streams s
  INNER JOIN manual_habitat_class h
  ON s.blue_line_key = h.blue_line_key
  -- note that this join works because streams are already segmented at the endpoints
  AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
  AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
  GROUP BY segmented_stream_id
  ORDER BY segmented_stream_id;

commit;      