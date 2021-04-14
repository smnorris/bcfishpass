-- add channel width column to streams table (both measured and modelled)
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS channel_width double precision;

-- first, load all *measured* channel width values to streams table where available
WITH cw AS
(SELECT DISTINCT
  s.linear_feature_id,
  c.channel_width_measured AS channel_width
FROM bcfishpass.streams s
LEFT OUTER JOIN bcfishpass.channel_width_measured c
ON s.wscode_ltree = c.wscode_ltree
AND s.localcode_ltree = c.localcode_ltree
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
-- only apply channel width to rivers and streams
AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
)

UPDATE bcfishpass.streams s
SET
  channel_width = cw.channel_width
FROM cw
WHERE s.linear_feature_id = cw.linear_feature_id;


-- now load all *modelled* channel width values to streams table
-- (note that this will not include first order streams)
WITH cw AS
(SELECT DISTINCT
  s.linear_feature_id,
  c.channel_width_modelled AS channel_width
FROM bcfishpass.streams s
LEFT OUTER JOIN bcfishpass.channel_width_modelled c
ON s.wscode_ltree = c.wscode_ltree
AND s.localcode_ltree = c.localcode_ltree
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
WHERE s.stream_order > 1
-- only apply channel width to rivers and streams
AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
-- and where there is no measure
AND s.channel_width IS NULL
)

UPDATE bcfishpass.streams s
SET
  channel_width = cw.channel_width
FROM cw
WHERE s.linear_feature_id = cw.linear_feature_id;