DROP TABLE IF EXISTS obs_dist_to_ocean;

CREATE table obs_dist_to_ocean AS 
with obs as (
  SELECT DISTINCT
    o.blue_line_key,
    o.downstream_route_measure
  FROM obs_max_grade_dnstr a
  INNER JOIN bcfishobs.observations o
  ON a.observation_key = o.observation_key
)

SELECT
  blue_line_key,
  downstream_route_measure,
  distance_to_ocean as obs_dist_to_ocean
FROM obs l
LEFT JOIN LATERAL
(
  SELECT 
    sum(length_metre) as distance_to_ocean
  FROM
    FWA_DownstreamTrace(l.blue_line_key, l.downstream_route_measure)
) s1 ON true;


ALTER TABLE obs_dist_to_ocean ADD primary key (blue_line_key, downstream_route_measure);
