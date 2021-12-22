-- refresh the breakpoints table
DELETE FROM bcfishpass.breakpoints;

WITH streams AS
(
  SELECT * FROM bcfishpass.segmented_streams
  WHERE s.watershed_group_code = :'wsg'
)

INSERT INTO bcfishpass.breakpoints
(blue_line_key, downstream_route_measure)

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.observations b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.falls b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT
  b.blue_line_key,
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_05 b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key
AND (b.downstream_route_measure - s.downstream_route_measure) > 1
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT
  b.blue_line_key,
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_07 b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key
AND (b.downstream_route_measure - s.downstream_route_measure) > 1
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT
  b.blue_line_key,
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_10 b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key
AND (b.downstream_route_measure - s.downstream_route_measure) > 1
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_15 b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_20 b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT
  b.blue_line_key,
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_25 b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key
AND (b.downstream_route_measure - s.downstream_route_measure) > 1
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_30 b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_majordams b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_other_definite b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT
  b.blue_line_key,
  b.downstream_route_measure
FROM bcfishpass.manual_habitat_classification_endpoints b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key
AND (b.downstream_route_measure - s.downstream_route_measure) > 1
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT
  b.blue_line_key,
  b.downstream_route_measure
FROM bcfishpass.crossings b
INNER JOIN streams s
ON b.blue_line_key = s.blue_line_key
AND (b.downstream_route_measure - s.downstream_route_measure) > 1
AND (s.upstream_route_measure - b.downstream_route_measure) > 1;
