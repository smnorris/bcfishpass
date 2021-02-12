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
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code,
  max(s.stream_order) as stream_order,
  max(s.stream_magnitude) as stream_magnitude,
  max(COALESCE(s.upstream_area_ha, 0)) + 1 as upstream_area_ha,
  max(COALESCE(s.upstream_lake_ha, 0)) + 1 as upstream_lake_ha,
  max(COALESCE(s.upstream_wetland_ha, 0)) + 1 as upstream_wetland_ha
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
      abs(
        37.3139 -
        (18.8024 * ln(s.stream_magnitude)) -
        (9.6349 * ln(s.upstream_area_ha)) -
        (5.4408 * ln(p.map_upstream)) +
        (2.8150 * ln(s.stream_magnitude) * ln(s.upstream_area_ha)) +
        (2.5106 * ln(s.stream_magnitude) * ln(p.map_upstream)) +
        (1.4870 * ln(s.upstream_area_ha) * ln(p.map_upstream)) -
        (0.3596 * ln(s.stream_magnitude) * ln(s.upstream_area_ha) * ln(p.map_upstream))
      )
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
  max(s.stream_order) as stream_order,
  max(s.stream_magnitude) as stream_magnitude,
  max(COALESCE(s.upstream_area_ha, 0)) + 1 as upstream_area_ha,
  max(COALESCE(s.upstream_lake_ha, 0)) + 1 as upstream_lake_ha,
  max(COALESCE(s.upstream_wetland_ha, 0)) + 1 as upstream_wetland_ha
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
    (
      abs(
        -81.6758 +
        (17.3956 * s.stream_order) +
        (6.9560 * ln(p.map_upstream)) +
        (5.5988 * ln(s.stream_magnitude)) -
        (2.9593 * s.stream_order * ln(p.map_upstream)) -
        (5.6570 * s.stream_order * ln(s.stream_magnitude)) -
        (0.8855 * ln(p.map_upstream) * ln(s.stream_magnitude)) +
        (0.9584 * stream_order * ln(p.map_upstream) * ln(s.stream_magnitude))
        )
    )::numeric, 2
  ) as channel_width_modelled
FROM streams s
INNER JOIN bcfishpass.mean_annual_precip p
ON s.wscode_ltree = p.wscode_ltree
AND s.localcode_ltree = p.localcode_ltree
WHERE s.upstream_area_ha IS NOT NULL;

-- ---------------------------------------------
-- HORS
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
  max(s.stream_order) as stream_order,
  max(s.stream_magnitude) as stream_magnitude,
  max(COALESCE(s.upstream_area_ha, 0)) + 1 as upstream_area_ha,
  max(COALESCE(s.upstream_lake_ha, 0)) + 1 as upstream_lake_ha,
  max(COALESCE(s.upstream_wetland_ha, 0)) + 1 as upstream_wetland_ha
FROM whse_basemapping.fwa_stream_networks_sp s
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
WHERE s.watershed_group_code = 'HORS'
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
    abs(
      210.2984 -
      (80.9966 * s.stream_order) -
      (44.0806 * ln(s.upstream_area_ha)) -
      (30.5610 * ln(p.map_upstream)) +
      (60.0370 * ln(s.upstream_lake_ha)) +
      (16.1603 * s.stream_order * ln(s.upstream_area_ha)) +
      (11.6537 * s.stream_order * ln(p.map_upstream)) +
      (6.4994 * ln(s.upstream_area_ha) * ln(p.map_upstream)) -
      (16.9901 * s.stream_order * ln(s.upstream_lake_ha)) -
      (8.0439 * ln(s.upstream_area_ha) * ln(s.upstream_lake_ha)) -
      (9.6159 * ln(p.map_upstream) * ln(s.upstream_lake_ha)) -
      (2.3420 * s.stream_order * ln(s.upstream_area_ha) * ln(p.map_upstream)) +
      (1.6302 * s.stream_order * ln(s.upstream_area_ha) * ln(s.upstream_lake_ha)) +
      (2.7289 * s.stream_order * ln(p.map_upstream) * ln(s.upstream_lake_ha)) +
      (1.3119 * ln(s.upstream_area_ha) * ln(p.map_upstream) * ln(s.upstream_lake_ha)) -
      (0.2726 * s.stream_order * ln(s.upstream_area_ha) * ln(p.map_upstream) * ln(s.upstream_lake_ha))
    )
    )::numeric, 2
  )
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
