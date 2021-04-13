-- add modelled channel width column to streams table
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS channel_width double precision;

-- load channel width to streams table from the measured/modelled data where a model has been run
WITH cw AS
(SELECT DISTINCT
  s.wscode_ltree,
  s.localcode_ltree,
  s.linear_feature_id,
  COALESCE(cw1.channel_width_measured, cw2.channel_width_modelled) as channel_width,
  s.edge_type
FROM bcfishpass.streams s
LEFT OUTER JOIN bcfishpass.channel_width_measured cw1
ON s.wscode_ltree = cw1.wscode_ltree
AND s.localcode_ltree = cw1.localcode_ltree
LEFT OUTER JOIN bcfishpass.channel_width_modelled cw2
ON s.wscode_ltree = cw2.wscode_ltree
AND s.localcode_ltree = cw2.localcode_ltree
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
INNER JOIN bcfishpass.watershed_groups wsg
ON s.watershed_group_code = wsg.watershed_group_code
WHERE wsg.model = 'cw'
-- don't model channel width on first order streams
AND s.stream_order > 1
-- only apply channel width to rivers and streams
AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
)

UPDATE bcfishpass.streams s
SET
  channel_width = cw.channel_width
FROM cw
WHERE s.linear_feature_id = cw.linear_feature_id;