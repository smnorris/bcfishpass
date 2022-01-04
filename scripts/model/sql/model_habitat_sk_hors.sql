--
-- Sockeye rearing for Horsefly is cross-wsg, all rearing is in Quesnel Lake
-- Simply apply the spawing model everywhere in HORS.
--
WITH spawn AS
(
  SELECT
    s.segmented_stream_id,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN bcfishpass.param_habitat sk
  ON sk.species_code = 'SK'
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  WHERE
  (
    wsg.model = 'mad' AND
    s.gradient <= sk.spawn_gradient_max AND
    s.mad_m3s > sk.spawn_mad_min AND
    s.mad_m3s <= sk.spawn_mad_max
  )
  AND
  (wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
    (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))
  )
  AND s.watershed_group_code = 'HORS'
  AND s.access_model_ch_co_sk IS NOT NULL
)

UPDATE bcfishpass.streams s
SET spawning_model_sk = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM spawn);