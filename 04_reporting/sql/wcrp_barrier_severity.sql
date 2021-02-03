WITH wcrp_types AS
(SELECT
  c.aggregated_crossings_id,
  c.watershed_group_code,
  CASE
    WHEN crossing_source = 'PSCIS' THEN 'ASSESSED'
    ELSE 'NOT ASSESSED'
  END AS assessment_status,
  CASE
    WHEN crossing_source = 'MODEL' AND barrier_status = 'PASSABLE' THEN 'MODELLED AS PASSABLE'
    WHEN crossing_source = 'MODEL' AND barrier_status = 'POTENTIAL' THEN 'MODELLED AS POTENTIAL'
    ELSE barrier_status
  END AS barrier_status,
CASE
    WHEN crossing_type = 'RAILWAY' THEN 'RAIL'
    WHEN crossing_type = 'DAM' THEN 'DAM'
    WHEN crossing_type = 'DRA, TRAIL' THEN 'TRAIL'
    WHEN crossing_type IN ('DRA, RUNWAY', 'DRA, DEMOGRAPHIC') THEN 'ROAD, DEMOGRAPHIC'
    WHEN crossing_type IN ('OIL AND GAS ROAD','DRA, RECREATION','DRA, RESOURCE/OTHER') OR crossing_type LIKE 'FTEN%' THEN 'ROAD, FOREST/OTHER'
END as wcrp_type
FROM bcfishpass.crossings c
WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
)

SELECT
  watershed_group_code,
  wcrp_type,
  assessment_status,
  barrier_status,
  count(*)
FROM wcrp_types
GROUP BY
  watershed_group_code,
  wcrp_type,
  assessment_status,
  barrier_status
ORDER BY
  watershed_group_code,
  wcrp_type,
  assessment_status,
  barrier_status