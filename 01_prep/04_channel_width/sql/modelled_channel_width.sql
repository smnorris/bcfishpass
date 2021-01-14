-- create channel width table, holding both measured and modelled values


DROP TABLE IF EXISTS bcfishpass.channel_width;

CREATE TABLE bcfishpass.channel_width
(
  channel_width_id serial primary key,
  stream_sample_site_ids integer[],
  stream_crossing_ids integer[],
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code text,
  channel_width_measured double precision,
  channel_width_modelled double precision,
  UNIQUE (wscode_ltree, localcode_ltree)
);


-- insert modelled channel widths, based on MAP/magnitude/upstream area


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
WHERE s.watershed_group_code = 'BULK'
-- we only want widths of streams/rivers
AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
AND s.localcode_ltree IS NOT NULL
GROUP BY wscode_ltree, localcode_ltree
)

INSERT INTO bcfishpass.channel_width
(
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  channel_width_modelled
)

SELECT
  m.wscode_ltree,
  m.localcode_ltree,
  m.watershed_group_code,
  round(
    (
      1.34962 -
      (20.81835 * ln(s.stream_magnitude)) -
      (0.67372 * ln(s.upstream_area_ha)) -
      (0.03514 * ln(m.map_upstream)) +
      (1.93418 * ln(s.stream_magnitude) * ln(s.upstream_area_ha)) +
      (3.01788 * ln(s.stream_magnitude) * ln(m.map_upstream)) +
      (0.13344 * ln(s.upstream_area_ha) * ln(m.map_upstream)) -
      (0.25580 * ln(s.stream_magnitude) * ln(s.upstream_area_ha) * ln(m.map_upstream))
    )::numeric, 2
  ) as channel_width_modelled
FROM bcfishpass.mean_annual_precip_streams m
INNER JOIN streams s
ON m.wscode_ltree = s.wscode_ltree
AND m.localcode_ltree = s.localcode_ltree
WHERE s.upstream_area_ha IS NOT NULL;

CREATE INDEX ON bcfishpass.channel_width USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.channel_width USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.channel_width USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.channel_width USING BTREE (localcode_ltree);
