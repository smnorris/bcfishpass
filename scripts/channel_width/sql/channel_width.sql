-- first, load all *measured* channel width values to streams table where available
DROP TABLE IF EXISTS bcfishpass.channel_width;

CREATE TABLE IF NOT EXISTS bcfishpass.channel_width
(
  linear_feature_id bigint,
  channel_width double precision
);

WITH cwmeas AS
(
  SELECT DISTINCT
    s.linear_feature_id,
    c.channel_width_measured AS cw
  FROM whse_basemapping.fwa_stream_networks_sp s
  INNER JOIN bcfishpass.param_watersheds pw ON s.watershed_group_code = pw.watershed_group_code
  LEFT OUTER JOIN bcfishpass.channel_width_measured c
    ON s.wscode_ltree = c.wscode_ltree
    AND s.localcode_ltree = c.localcode_ltree
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
    ON s.waterbody_key = wb.waterbody_key
    -- only apply channel width to rivers and streams
    AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
),

cwmap AS 
(
  SELECT
  a.linear_feature_id,
  ROUND(avg(a.channel_width_mapped)::numeric, 2) as cw
FROM bcfishpass.channel_width_mapped a
INNER JOIN bcfishpass.param_watersheds pw ON a.watershed_group_code = pw.watershed_group_code
GROUP BY a.linear_feature_id
),

cwmodel AS
(
  SELECT DISTINCT
    s.linear_feature_id,
    c.channel_width_modelled AS cw
  FROM whse_basemapping.fwa_stream_networks_sp s
  INNER JOIN bcfishpass.param_watersheds pw ON s.watershed_group_code = pw.watershed_group_code
  LEFT OUTER JOIN bcfishpass.channel_width_modelled c
    ON s.wscode_ltree = c.wscode_ltree
    AND s.localcode_ltree = c.localcode_ltree
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
    ON s.waterbody_key = wb.waterbody_key
    WHERE s.stream_order > 1
  -- only apply channel width to rivers and streams
    AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
)

INSERT INTO bcfishpass.channel_width 
(linear_feature_id, channel_width)

SELECT
  s.linear_feature_id,
  COALESCE(cwmeas.cw, cwmap.cw, cwmodel.cw)
FROM whse_basemapping.fwa_stream_networks_sp s 
INNER JOIN bcfishpass.param_watersheds pw ON s.watershed_group_code = pw.watershed_group_code
LEFT OUTER JOIN cwmeas ON s.linear_feature_id = cwmeas.linear_feature_id
LEFT OUTER JOIN cwmap ON s.linear_feature_id = cwmap.linear_feature_id
LEFT OUTER JOIN cwmodel ON s.linear_feature_id = cwmodel.linear_feature_id