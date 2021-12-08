-- extract remediated crossings from the crossings table for reporting/visualization
-- insert all remediated crossings from aggregated crossings table
-- no additonal logic required
DELETE FROM bcfishpass.barriers_remediated;
INSERT INTO bcfishpass.barriers_remediated
(
    aggregated_crossings_id,
    stream_crossing_id,
    dam_id,
    modelled_crossing_id,
    crossing_source,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    modelled_crossing_type_source,
    barrier_status,
    wcrp_barrier_type,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    aggregated_crossings_id,
    stream_crossing_id,
    dam_id,
    modelled_crossing_id,
    crossing_source,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    modelled_crossing_type_source,
    barrier_status,
    wcrp_barrier_type,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    c.watershed_group_code as watershed_group_code,
    c.geom as geom
FROM bcfishpass.crossings c
-- only include crossings that are still passable, in theory something may have failed after a remediation
WHERE
  pscis_status = 'REMEDIATED' AND
  barrier_status = 'PASSABLE' AND
  c.watershed_group_code = ANY(
    ARRAY(
      SELECT watershed_group_code
      FROM bcfishpass.param_watersheds
    )
  )
ON CONFLICT DO NOTHING;