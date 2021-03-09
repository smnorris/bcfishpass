-- Create measured channel width table
-- First, load measured channel widths from:
-- - stream sample sites
-- - PSCIS assessments

-- Then, for generating predicted channel width, load additional parameters for these locations from FWA/MAP

DROP TABLE IF EXISTS bcfishpass.channel_width_measured;

CREATE TABLE bcfishpass.channel_width_measured
(
  channel_width_id serial primary key,
  stream_sample_site_ids integer[],
  stream_crossing_ids integer[],
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code text,
  stream_order integer,
  stream_magnitude integer,
  gradient double precision,
  upstream_area_ha double precision,
  upstream_lake_ha double precision,
  upstream_reservoir_ha double precision,
  upstream_wetland_ha double precision,
  channel_width_measured double precision,
  map integer,
  UNIQUE (wscode_ltree, localcode_ltree)
);


-- -------------------------------------------
-- first, insert the measured stream widths
-- Measurement values are distinct for watershed code / local code combinations (stream segments between tribs),
-- where more than one measurement exists on a segment, the average is calculated
-- -------------------------------------------
WITH fiss_measurements AS
(SELECT
  e.stream_sample_site_id,
  e.wscode_ltree,
  e.localcode_ltree,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  w.watershed_group_code,
  p.channel_width as channel_width_fiss
FROM bcfishpass.fiss_stream_sample_sites_events_sp e
INNER JOIN whse_fish.fiss_stream_sample_sites_sp p
ON e.stream_sample_site_id = p.stream_sample_site_id
LEFT OUTER JOIN whse_basemapping.fwa_watersheds_poly w
ON ST_Intersects(p.geom, w.geom)
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON e.blue_line_key = s.blue_line_key
AND e.downstream_route_measure > s.downstream_route_measure
AND e.downstream_route_measure <= s.upstream_route_measure
WHERE p.channel_width IS NOT NULL
AND w.watershed_group_code in ('LNIC','BULK','HORS','ELKR','MORR')
-- exclude these records due to errors in measurement and/or linking to streams
AND p.stream_sample_site_id NOT IN (44813,44815,10997,8518,37509,37510,53526,15603,98,8644,117,8627,142,8486,8609,15609,10356)
),

pscis_measurements AS
(
SELECT
  e.stream_crossing_id,
  e.wscode_ltree,
  e.localcode_ltree,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.watershed_group_code,
  a.downstream_channel_width as channel_width_pscis
FROM bcfishpass.pscis_events_sp e
LEFT OUTER JOIN whse_fish.pscis_assessment_svw a
ON e.stream_crossing_id = a.stream_crossing_id
LEFT OUTER JOIN whse_basemapping.fwa_watersheds_poly w
ON ST_Intersects(e.geom, w.geom)
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON e.blue_line_key = s.blue_line_key
AND e.downstream_route_measure > s.downstream_route_measure
AND e.downstream_route_measure <= s.upstream_route_measure
WHERE a.downstream_channel_width is not null
AND e.watershed_group_code in ('LNIC','BULK','HORS','ELKR','MORR')
-- exclude these records due to errors in measurement and/or linking to streams
AND e.stream_crossing_id NOT IN (57592,123894,57408,124137)
),

combined AS
(SELECT
  f.stream_sample_site_id,
  p.stream_crossing_id,
  GREATEST(f.stream_order, p.stream_order) as stream_order,
  GREATEST(f.stream_magnitude, p.stream_magnitude) as stream_magnitude,
  GREATEST(f.gradient, p.gradient) as gradient,
  coalesce(f.wscode_ltree, p.wscode_ltree) as wscode_ltree,
  coalesce(f.localcode_ltree, p.localcode_ltree) as localcode_ltree,
  coalesce(f.watershed_group_code, p.watershed_group_code) as watershed_group_code,
  coalesce(f.channel_width_fiss, p.channel_width_pscis) as channel_width
FROM fiss_measurements f
FULL OUTER JOIN pscis_measurements p
ON f.wscode_ltree = p.wscode_ltree
AND f.localcode_ltree = p.localcode_ltree)

INSERT INTO bcfishpass.channel_width_measured
(
  stream_sample_site_ids,
  stream_crossing_ids,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  stream_order,
  stream_magnitude,
  gradient,
  channel_width_measured
)
SELECT
 array_agg(stream_sample_site_id) filter (where stream_sample_site_id is not null) as stream_sample_site_ids,
 array_agg(stream_crossing_id) filter (where stream_crossing_id is not null) AS stream_crossing_ids,
 wscode_ltree,
 localcode_ltree,
 watershed_group_code,
 max(stream_order) as stream_order,
 max(stream_magnitude) as stream_magnitude,
 avg(gradient) as gradient,
 round(avg(channel_width)::numeric, 2) as channel_width_measured
FROM combined
GROUP BY
 wscode_ltree,
 localcode_ltree,
 watershed_group_code;


-- -------------------------------------------
-- Insert values that come direct from streams table
-- But note that because we are working 'stream segments' as distinct watershed codes,
-- we have to aggregate slightly - upstream_area_ha will not be unique for each
-- (as it is calculated per linear_feature_id)
-- -------------------------------------------
WITH update_vals AS
(
  SELECT
    a.wscode_ltree,
    a.localcode_ltree,
    max(b.upstream_area_ha) AS upstream_area_ha,
    max(b.upstream_lake_ha) AS upstream_lake_ha,
    max(b.upstream_reservoir_ha) AS upstream_reservoir_ha,
    max(b.upstream_wetland_ha) AS upstream_wetland_ha
  FROM bcfishpass.channel_width_measured a
  INNER JOIN whse_basemapping.fwa_stream_networks_sp b
  ON a.wscode_ltree = b.wscode_ltree
  AND a.localcode_ltree = b.localcode_ltree
  AND a.watershed_group_code = b.watershed_group_code
  GROUP BY a.wscode_ltree, a.localcode_ltree
)

UPDATE bcfishpass.channel_width_measured cw
SET
  upstream_area_ha = COALESCE(u.upstream_area_ha, 0),
  upstream_lake_ha = COALESCE(u.upstream_lake_ha, 0),
  upstream_reservoir_ha = COALESCE(u.upstream_reservoir_ha, 0),
  upstream_wetland_ha = COALESCE(u.upstream_wetland_ha, 0)
FROM update_vals u
WHERE cw.wscode_ltree = u.wscode_ltree AND
cw.localcode_ltree = u.localcode_ltree;

-- ---------------------------------------------
-- and finally, insert MAP values
-- ---------------------------------------------
UPDATE bcfishpass.channel_width_measured cw
SET
  map = map.map
FROM bcfishpass.mean_annual_precip_load map
WHERE cw.wscode_ltree = map.wscode_ltree AND
cw.localcode_ltree = map.localcode_ltree;

CREATE INDEX ON bcfishpass.channel_width_measured USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.channel_width_measured USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.channel_width_measured USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.channel_width_measured USING BTREE (localcode_ltree);
