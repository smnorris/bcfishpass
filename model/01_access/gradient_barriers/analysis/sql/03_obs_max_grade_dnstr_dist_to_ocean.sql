DROP TABLE IF EXISTS obs_max_grade_dnstr_dist_to_ocean;

CREATE table obs_max_grade_dnstr_dist_to_ocean AS
with max_dnstr_gradient_locations as (
SELECT DISTINCT
  a.max_gradient_id,
  gb.blue_line_key,
  gb.downstream_route_measure
FROM obs_max_grade_dnstr a
INNER JOIN bcfishpass.gradient_barriers gb
ON a.max_gradient_id = gb.gradient_barrier_id
)

SELECT
  max_gradient_id,
  distance_to_ocean as max_grade_dnstr_dist_to_ocean
FROM max_dnstr_gradient_locations l
LEFT JOIN LATERAL
(
  SELECT 
    sum(length_metre) as distance_to_ocean
  FROM
    FWA_DownstreamTrace(l.blue_line_key, l.downstream_route_measure)
) s1 ON true;


ALTER TABLE obs_max_grade_dnstr_dist_to_ocean ADD primary key (max_gradient_id);
