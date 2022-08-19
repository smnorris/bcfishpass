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
    dam_id::text as barrier_load_id,
    'MAJOR_DAM' as barrier_type,
    d.dam_name as barrier_name,
    d.linear_feature_id,
    d.blue_line_key,
    s.watershed_key,
    d.downstream_route_measure,
    d.wscode_ltree,
    d.localcode_ltree,
    d.watershed_group_code,
    ST_Force2D((ST_Dump(d.geom)).geom)
FROM bcfishpass.crossings d
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON d.linear_feature_id = s.linear_feature_id
WHERE
  d.barrier_status in ('BARRIER', 'POTENTIAL') and
  d.dam_use = 'Hydroelectricity' AND
  d.watershed_group_code = :'wsg'
ON CONFLICT DO NOTHING;