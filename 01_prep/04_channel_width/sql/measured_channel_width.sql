-- create a table of measured channel width

-- measurements:
-- - stream sample sites
-- - PSCIS assessments

-- values are distinct for watershed code / local code combinations (stream segments between tribs),
-- where more than one measurement exists on a segment, the average is calculated

DROP TABLE IF EXISTS bcfishpass.measured_channel_width;

CREATE TABLE bcfishpass.measured_channel_width
(
  measured_channel_width_id serial primary key,
  stream_sample_site_ids integer[],
  stream_crossing_ids integer[],
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code text,
  channel_width double precision
);


-- load stream sample sites, averaging the width measures along the stream
-- where multiple measures occur
INSERT INTO bcfishpass.measured_channel_width
(
  stream_sample_site_ids,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  channel_width
)
SELECT
  array_agg(e.stream_sample_site_id) as stream_sample_sites_ids,
  e.wscode_ltree,
  e.localcode_ltree,
  s.watershed_group_code,
  avg(p.channel_width) as channel_width
FROM whse_fish.fiss_stream_sample_sites_events e
INNER JOIN whse_fish.fiss_stream_sample_sites_sp p
ON e.stream_sample_site_id = p.stream_sample_site_id
LEFT OUTER JOIN whse_basemapping.fwa_watersheds_poly w
ON ST_Intersects(p.geom, w.geom)
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON e.blue_line_key = s.blue_line_key
AND e.downstream_route_measure > s.downstream_route_measure
AND e.downstream_route_measure <= s.upstream_route_measure
WHERE p.channel_width IS NOT NULL
-- exclude outliers/bad data
AND p.stream_sample_site_id NOT IN (8486,8644,8609,8518,117,142,8627,98,10997,10356)
GROUP BY
  e.wscode_ltree,
  e.localcode_ltree,
  s.watershed_group_code;


-- insert pscis points
INSERT INTO bcfishpass.measured_channel_width
(
  stream_crossing_ids,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  channel_width
)
SELECT
  array_agg(e.stream_crossing_id) as stream_crossing_ids,
  e.wscode_ltree,
  e.localcode_ltree,
  s.watershed_group_code,
  avg(a.downstream_channel_width) as channel_width
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
AND e.watershed_group_code in ('LNIC','BULK','HORS','ELKR')
GROUP BY
  w.watershed_feature_id,
  e.blue_line_key,
  e.wscode_ltree,
  e.localcode_ltree,
  s.watershed_group_code,
  s.stream_magnitude,
  s.upstream_area_ha;

CREATE INDEX ON bcfishpass.measured_channel_width USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.measured_channel_width USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.measured_channel_width USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.measured_channel_width USING BTREE (localcode_ltree);
