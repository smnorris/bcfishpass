DROP TABLE IF EXISTS bcfishpass.user_habitat_classification_endpoints;

CREATE TABLE bcfishpass.user_habitat_classification_endpoints
  (
    blue_line_key integer,
    downstream_route_measure double precision,
    linear_feature_id bigint,
    watershed_group_code character varying(4),
    PRIMARY KEY(blue_line_key, downstream_route_measure)
  );

INSERT INTO bcfishpass.user_habitat_classification_endpoints
(
  blue_line_key,
  downstream_route_measure,
  linear_feature_id,
  watershed_group_code
)

SELECT
   h.blue_line_key
  ,h.downstream_route_measure
  ,s.linear_feature_id
  ,s.watershed_group_code
FROM bcfishpass.user_habitat_classification h
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON h.blue_line_key = s.blue_line_key
AND ROUND(s.downstream_route_measure::numeric, 4) <= ROUND(h.downstream_route_measure::numeric, 4)
AND ROUND(s.upstream_route_measure::numeric, 4) > ROUND(h.downstream_route_measure::numeric, 4)
UNION
SELECT
  h.blue_line_key,
  h.upstream_route_measure as downstream_route_measure,
  s.linear_feature_id,
  s.watershed_group_code
FROM bcfishpass.user_habitat_classification h
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON h.blue_line_key = s.blue_line_key
AND ROUND(s.downstream_route_measure::numeric, 4) <= ROUND(h.upstream_route_measure::numeric, 4)
AND ROUND(s.upstream_route_measure::numeric, 4) > ROUND(h.upstream_route_measure::numeric, 4)
on conflict do nothing;  -- the same blkey/measure may exist for different species, discard duplicates
