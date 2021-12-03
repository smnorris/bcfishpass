CREATE OR REPLACE VIEW bcfishpass.breakpoints_vw AS 

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.observations b
INNER JOIN bcfishpass.segmented_streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.falls b
INNER JOIN bcfishpass.segmented_streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_15 b
INNER JOIN bcfishpass.segmented_streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_20 b
INNER JOIN bcfishpass.segmented_streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_gradient_30 b
INNER JOIN bcfishpass.segmented_streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_majordams b
INNER JOIN bcfishpass.segmented_streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1

UNION

SELECT 
  b.blue_line_key, 
  b.downstream_route_measure
FROM bcfishpass.barriers_other_definite b
INNER JOIN bcfishpass.segmented_streams s
ON b.blue_line_key = s.blue_line_key 
AND (b.downstream_route_measure - s.downstream_route_measure) > 1 
AND (s.upstream_route_measure - b.downstream_route_measure) > 1;