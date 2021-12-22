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
    dam_id as barrier_load_id,
    'MAJOR_DAM' as barrier_type,
    d.dam_name as barrier_name,
    d.linear_feature_id,
    d.blue_line_key,
    d.downstream_route_measure,
    d.wscode_ltree,
    d.localcode_ltree,
    d.watershed_group_code,
    ST_Force2D((ST_Dump(d.geom)).geom)
FROM bcfishpass.dams d
WHERE
  d.barrier_ind = 'Y' AND
  d.hydro_dam_ind = 'Y' AND
  d.watershed_group_code = :'wsg'
ON CONFLICT DO NOTHING;