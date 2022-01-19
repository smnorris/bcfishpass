-- EXCLUSIONS (insert first as they take priority)
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
    (((a.blue_line_key::bigint + 1) - 354087611) * 10000000) + round(a.downstream_route_measure::bigint) as barrier_load_id,
    'EXCLUSION' as barrier_type,
    a.barrier_name,
    s.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_Force2D(postgisftw.FWA_LocateAlong(a.blue_line_key, a.downstream_route_measure))
FROM bcfishpass.exclusions a
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON a.blue_line_key = s.blue_line_key AND
   a.downstream_route_measure > s.downstream_route_measure - .001 AND
   a.downstream_route_measure + .001 < s.upstream_route_measure
WHERE s.watershed_group_code = :'wsg'
ON CONFLICT DO NOTHING;


-- PSCIS NOT ACCESSIBLE
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
    (((e.blue_line_key::bigint + 1) - 354087611) * 10000000) + round(e.downstream_route_measure::bigint) as barrier_load_id,
    'PSCIS_NOT_ACCESSIBLE',
    NULL as barrier_name,
    e.linear_feature_id,
    e.blue_line_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    e.geom
FROM bcfishpass.pscis e
INNER JOIN bcfishpass.pscis_barrier_result_fixes f
ON e.stream_crossing_id = f.stream_crossing_id
INNER JOIN whse_basemapping.fwa_watershed_groups_poly g
ON e.watershed_group_code = g.watershed_group_code
WHERE f.updated_barrier_result_code = 'NOT ACCESSIBLE'
AND e.watershed_group_code = :'wsg'
ORDER BY e.stream_crossing_id
ON CONFLICT DO NOTHING;


-- MISC
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
    (((a.blue_line_key::bigint + 1) - 354087611) * 10000000) + round(a.downstream_route_measure::bigint) as barrier_load_id,
    'MISC' as barrier_type,
    a.barrier_name,
    s.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_Force2D(postgisftw.FWA_LocateAlong(a.blue_line_key, a.downstream_route_measure))
FROM bcfishpass.misc_barriers_definite a
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON a.blue_line_key = s.blue_line_key AND
   a.downstream_route_measure > s.downstream_route_measure - .001 AND
   a.downstream_route_measure + .001 < s.upstream_route_measure
WHERE s.watershed_group_code = :'wsg'
ON CONFLICT DO NOTHING;
