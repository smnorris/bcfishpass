WITH wcrp_types AS
(SELECT
  c.aggregated_crossings_id,
  c.watershed_group_code,
  CASE
    WHEN crossing_source = 'PSCIS' THEN 'ASSESSED'
    ELSE 'NOT ASSESSED'
  END AS assessment_status,
  CASE
    WHEN crossing_source = 'MODELLED CROSSINGS' AND barrier_status = 'PASSABLE' THEN 'MODELLED AS PASSABLE' -- barrier status comes from model and QA, us it rather than crossing
    WHEN crossing_source = 'MODELLED CROSSINGS' AND barrier_status = 'POTENTIAL' THEN 'MODELLED AS POTENTIAL'
    ELSE barrier_status
  END AS barrier_status,
  wcrp_barrier_type,
  -- note whether crossings is on accessible stream according to model used in given watershed
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct
FROM bcfishpass.crossings c
WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
ORDER BY watershed_group_code, watershed_group_code,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct,
  wcrp_barrier_type,
  assessment_status,
  barrier_status
)

SELECT
  watershed_group_code,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct,
  wcrp_barrier_type,
  assessment_status,
  barrier_status,
  count(*)
FROM wcrp_types
GROUP BY
  watershed_group_code,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct,
  wcrp_barrier_type,
  assessment_status,
  barrier_status
ORDER BY
  watershed_group_code,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct,
  wcrp_barrier_type,
  assessment_status,
  barrier_status