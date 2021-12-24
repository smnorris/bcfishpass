-- treat manual habitat classification endpoints as barriers so updates are easily found,
-- and streams get broken automatically at these points
INSERT INTO bcfishpass.barrier_load
(
    barrier_load_id,
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
  (src.watershed_group_id * 100000) + row_number() over() as barrier_load_id,
  'MANUAL_HABITAT' as barrier_type,
  NULL as barrier_name,
  src.linear_feature_id,
  src.blue_line_key,
  src.downstream_route_measure,
  src.wscode_ltree,
  src.localcode_ltree,
  src.watershed_group_code,
  src.geom
FROM (
SELECT
  s.linear_feature_id,
  h.blue_line_key,
  h.downstream_route_measure,
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_id,
  s.watershed_group_code,
  ST_Force2D((ST_Dump(ST_Locatealong(s.geom, h.downstream_route_measure))).geom)::geometry(Point,3005) as geom
FROM bcfishpass.manual_habitat_classification h
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON h.blue_line_key = s.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) <= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) > ROUND(h.downstream_route_measure::numeric)
WHERE h.watershed_group_code = :'wsg'
UNION
SELECT
  s.linear_feature_id,
  h.blue_line_key,
  h.downstream_route_measure,
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_id,
  s.watershed_group_code,
  ST_Force2D((ST_Dump(ST_Locatealong(s.geom, h.downstream_route_measure))).geom)::geometry(Point,3005) as geom
FROM bcfishpass.manual_habitat_classification h
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON h.blue_line_key = s.blue_line_key
AND ROUND(s.downstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) > ROUND(h.upstream_route_measure::numeric)
WHERE h.watershed_group_code = :'wsg'
) as src
ON CONFLICT DO NOTHING;





