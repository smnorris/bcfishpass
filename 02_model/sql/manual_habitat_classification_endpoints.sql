DROP TABLE IF EXISTS bcfishpass.manual_habitat_classification_endpoints;

CREATE TABLE bcfishpass.manual_habitat_classification_endpoints
  (
    blue_line_key integer,
    downstream_route_measure double precision,
    linear_feature_id bigint,
    PRIMARY KEY(blue_line_key, downstream_route_measure)
  );

INSERT INTO bcfishpass.manual_habitat_classification_endpoints
(blue_line_key,
downstream_route_measure,
linear_feature_id)

SELECT
  h.blue_line_key,
  h.downstream_route_measure,
  s.linear_feature_id
FROM bcfishpass.manual_habitat_classification h
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON h.blue_line_key = s.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) <= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) > ROUND(h.downstream_route_measure::numeric)
UNION
SELECT
  h.blue_line_key,
  h.upstream_route_measure as downstream_route_measure,
  s.linear_feature_id
FROM bcfishpass.manual_habitat_classification h
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON h.blue_line_key = s.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) > ROUND(h.upstream_route_measure::numeric);
