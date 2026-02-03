DROP TABLE IF EXISTS obs_grade_upstr;

CREATE TABLE obs_grade_upstr AS
with max_measure as (
  SELECT
    o.blue_line_key,
    o.downstream_route_measure,
    ceil(min(round(s.downstream_route_measure::numeric, 3))) as stream_min_measure,
    floor(max(round(s.upstream_route_measure::numeric, 3))) as stream_max_measure
  FROM obs_max_grade_dnstr a                 -- use only observations already joined to species presence table
  INNER JOIN bcfishobs.observations o      
  ON a.observation_key = o.observation_key
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s
  ON o.blue_line_key = s.blue_line_key
  GROUP BY 
    o.blue_line_key,
    o.downstream_route_measure
)

SELECT
  a.blue_line_key,
  a.downstream_route_measure,
  max(s1.gradient) as max_upstr_gradient_100m
FROM max_measure a
LEFT JOIN LATERAL
(
  SELECT *
  FROM
  FWA_SlopeAlongInterval(a.blue_line_key, 1, 10, a.downstream_route_measure::integer, least((a.downstream_route_measure + 100)::integer, a.stream_max_measure::integer))
) s1 ON true
WHERE (a.downstream_route_measure + 100) < a.stream_max_measure  -- do not compute for observations < 100m from end of stream
GROUP BY a.blue_line_key, a.downstream_route_measure;

ALTER TABLE obs_grade_upstr ADD primary key (blue_line_key, downstream_route_measure);