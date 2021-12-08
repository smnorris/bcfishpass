-- for stream visualization, we also want to create a table of pscis confirmed barriers only,
-- so we can see which streams are upstream of CONFIRMED barriers.
DELETE FROM bcfishpass.barriers_pscis;
INSERT INTO bcfishpass.barriers_pscis
(
    stream_crossing_id,
    barrier_status,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    stream_crossing_id,
    barrier_status,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_anthropogenic
WHERE stream_crossing_id IS NOT NULL;
