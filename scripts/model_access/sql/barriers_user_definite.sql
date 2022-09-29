INSERT INTO bcfishpass.barrier_load
(
    barrier_load_id,
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    watershed_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)

SELECT
    ((((a.blue_line_key::bigint + 1) - 354087611) * 10000000) + round(a.downstream_route_measure::bigint))::text as barrier_load_id,
    a.barrier_type,
    a.barrier_name,
    s.linear_feature_id,
    a.blue_line_key,
    s.watershed_key,
    a.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_Force2D(postgisftw.FWA_LocateAlong(a.blue_line_key, a.downstream_route_measure))
FROM bcfishpass.user_barriers_definite a
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON a.blue_line_key = s.blue_line_key AND
   a.downstream_route_measure > s.downstream_route_measure - .001 AND
   a.downstream_route_measure + .001 < s.upstream_route_measure
WHERE s.watershed_group_code = :'wsg'
ON CONFLICT DO NOTHING;


