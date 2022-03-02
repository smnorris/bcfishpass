-- Calculate "Barrier Severity" as
-- "the % of each barrier type that are barriers/potential barriers (out of those that have been assessed)"
-- (with further restriction that the barriers be on potentially accessible streams)

WITH totals AS
(
  SELECT
  watershed_group_code,
  crossing_feature_type,
  count(*) as n_total
FROM bcfishpass.crossings
WHERE watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
-- do not include flathead in ELKR
AND wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
AND (stream_crossing_id IS NOT NULL OR dam_id IS NOT NULL)
AND (access_model_ch_co_sk IS NOT NULL
    OR
    access_model_st IS NOT NULL
    OR
    access_model_wct IS NOT NULL
    )
GROUP BY watershed_group_code, crossing_feature_type
ORDER BY watershed_group_code, crossing_feature_type
),

barrier_potential AS
(
SELECT
  watershed_group_code,
  crossing_feature_type,
  count(*) as n_barrier
FROM bcfishpass.crossings
WHERE watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
AND wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
AND (stream_crossing_id IS NOT NULL OR dam_id IS NOT NULL)
AND barrier_status in ('BARRIER', 'POTENTIAL')
AND (access_model_ch_co_sk IS NOT NULL
    OR
    access_model_st IS NOT NULL
    OR
    access_model_wct IS NOT NULL
    )
GROUP BY watershed_group_code, crossing_feature_type
)

SELECT
  t.watershed_group_code,
  t.crossing_feature_type,
  COALESCE(b.n_barrier, 0) as n_assessed_barrier,
  t.n_total as n_assessed_total,
  ROUND((COALESCE(b.n_barrier, 0) * 100)::numeric / t.n_total, 1) AS pct_assessed_barriers
FROM totals t
LEFT OUTER JOIN barrier_potential b
ON t.watershed_group_code = b.watershed_group_code
AND t.crossing_feature_type = b.crossing_feature_type


