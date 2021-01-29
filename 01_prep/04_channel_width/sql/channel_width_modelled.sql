-- create channel width table, holding both measured and modelled values


DROP TABLE IF EXISTS bcfishpass.channel_width_modelled;

CREATE TABLE bcfishpass.channel_width_modelled
(
  channel_width_id serial primary key,
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code text,
  channel_width_modelled double precision,
  UNIQUE (wscode_ltree, localcode_ltree)
);


-- Insert modelled channel widths, based on MAP/magnitude/upstream area/wetland upstream area

-- NOTE - the models are per watershed group
-- The formula for predicting channel width based on these inputs
-- is based on a regression done in R - each regression is done
-- seperately per watershed group and a new formula is provided.

-- ---------------------------------------------
-- BULK
-- ---------------------------------------------
WITH streams AS
(
SELECT
-- a given watershed code combination can have more than one magnitude (side channels)
-- and more than one upstream area (several watershed polys can have with the same codes)
-- So, to get distinct codes, simply take the maximum of each, this won't make much/any
-- difference in the output
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  max(stream_magnitude) as stream_magnitude,
  max(upstream_area_ha) as upstream_area_ha
FROM whse_basemapping.fwa_stream_networks_sp s
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
WHERE s.watershed_group_code = 'BULK'
-- we only want widths of streams/rivers
AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
AND s.localcode_ltree IS NOT NULL
GROUP BY wscode_ltree, localcode_ltree, watershed_group_code
)

INSERT INTO bcfishpass.channel_width_modelled
(
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  channel_width_modelled
)

SELECT
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code,
  round(
    (
      1.34962 -
      (20.81835 * ln(s.stream_magnitude)) -
      (0.67372 * ln(s.upstream_area_ha)) -
      (0.03514 * ln(p.map_upstream)) +
      (1.93418 * ln(s.stream_magnitude) * ln(s.upstream_area_ha)) +
      (3.01788 * ln(s.stream_magnitude) * ln(p.map_upstream)) +
      (0.13344 * ln(s.upstream_area_ha) * ln(p.map_upstream)) -
      (0.25580 * ln(s.stream_magnitude) * ln(s.upstream_area_ha) * ln(p.map_upstream))
    )::numeric, 2
  ) as channel_width_modelled
FROM streams s
INNER JOIN bcfishpass.mean_annual_precip p
ON s.wscode_ltree = p.wscode_ltree
AND s.localcode_ltree = p.localcode_ltree
WHERE s.upstream_area_ha IS NOT NULL;

-- ---------------------------------------------
-- LNIC
-- ---------------------------------------------
WITH streams AS
(
-- a given watershed code combination can have more than one magnitude (side channels)
-- and more than one upstream area (several watershed polys can have with the same codes)
-- So, to get distinct codes, simply take the maximum of each, this won't make much/any
-- difference in the output
SELECT
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code,
  coalesce(max(s.upstream_wetland_ha),0) as upstream_wetland_ha,
  max(s.stream_magnitude) as stream_magnitude,
  max(s.upstream_area_ha) as upstream_area_ha
FROM whse_basemapping.fwa_stream_networks_sp s
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
WHERE s.watershed_group_code = 'LNIC'
-- we only want widths of streams/rivers
AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
AND s.localcode_ltree IS NOT NULL
GROUP BY wscode_ltree, localcode_ltree, watershed_group_code
)

INSERT INTO bcfishpass.channel_width_modelled
(
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  channel_width_modelled
)

SELECT
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code,
  round(
    abs(
        81.6758 -
        (18.9492 * ln(s.upstream_area_ha)) -
        (13.6090 * ln(p.map_upstream)) +
        (4.1731 * ln(s.upstream_wetland_ha + 1)) +
        (0.6629 * ln(s.upstream_wetland_ha + 1) * ln(s.upstream_area_ha)) -
        (0.6818 * ln(s.upstream_wetland_ha + 1) * ln(p.map_upstream)) +
        (3.1850 * ln(s.upstream_area_ha) * ln(p.map_upstream)) -
        (0.1093 * ln(s.upstream_wetland_ha + 1) * ln(s.upstream_area_ha) * ln(p.map_upstream))
      )::numeric, 2)
   as channel_width_modelled
FROM streams s
INNER JOIN bcfishpass.mean_annual_precip p
ON s.wscode_ltree = p.wscode_ltree
AND s.localcode_ltree = p.localcode_ltree
WHERE s.upstream_area_ha IS NOT NULL;


CREATE INDEX ON bcfishpass.channel_width_modelled USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.channel_width_modelled USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.channel_width_modelled USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.channel_width_modelled USING BTREE (localcode_ltree);
