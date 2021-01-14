-- insert modelled channel widths, based on MAP/magnitude/upstream area

INSERT INTO bcfishpass.channel_width
(
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  channel_width_modelled
)
WITH streams AS
(
SELECT
  wscode_ltree,
  localcode_ltree,
  max(stream_magnitude) as stream_magnitude,
  max(upstream_area_ha) as upstream_area_ha
FROM whse_basemapping.fwa_stream_networks_sp s
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
WHERE watershed_group_code = 'BULK'
-- we only want widths of streams/rivers
AND wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))
GROUP BY wscode_ltree, localcode_ltree
)

SELECT
  m.wscode_ltree,
  m.localcode_ltree,
  m.watershed_group_code,
  1.34962 -
  20.81835 * log(s.stream_magnitude) -
  0.67372 * log(s.upstream_area_ha) -
  0.03514 * log(m.map) +
  1.93418 * log(s.stream_magnitude) * log(s.upstream_area_ha) +
  3.01788 * log(s.stream_magnitude) * log(m.map) +
  0.13344 * log(s.upstream_area_ha) * log(m.map) -
  0.25580 * log(s.stream_magnitude) * log(s.upstream_area_ha) * log(m.map) as channel_width_modelled
FROM bcfishpass.mean_annual_precip_streams m
INNER JOIN streams s
ON m.wscode_ltree = s.wscode_ltree
AND m.localcode_ltree = s.localcode_ltree;