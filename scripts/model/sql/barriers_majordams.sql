DELETE FROM bcfishpass.barriers_majordams;
INSERT INTO bcfishpass.barriers_majordams
(
    barriers_majordams_id,
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
    dam_id as barriers_majordams_id,
    'MAJOR_DAM' as barrier_type,
    d.dam_name as barrier_name,
    d.linear_feature_id,
    d.blue_line_key,
    d.downstream_route_measure,
    d.wscode_ltree,
    d.localcode_ltree,
    d.watershed_group_code,
    ST_Force2D((st_Dump(d.geom)).geom)
FROM bcfishpass.dams d
INNER JOIN bcfishpass.param_watersheds g
ON d.watershed_group_code = g.watershed_group_code
WHERE d.barrier_ind = 'Y'
AND d.hydro_dam_ind = 'Y'
ON CONFLICT DO NOTHING;