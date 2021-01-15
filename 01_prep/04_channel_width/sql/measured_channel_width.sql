-- load measured channel widths from:
-- - stream sample sites
-- - PSCIS assessments

-- values are distinct for watershed code / local code combinations (stream segments between tribs),
-- where more than one measurement exists on a segment, the average is calculated


WITH fiss_measurements AS
(SELECT
  e.stream_sample_site_id,
  e.wscode_ltree,
  e.localcode_ltree,
  w.watershed_group_code,
  p.channel_width as channel_width_fiss
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
AND w.watershed_group_code in ('LNIC','BULK','HORS','ELKR')
-- exclude these records due to errors in measurement and/or linking to streams
AND p.stream_sample_site_id NOT IN (44813,44815,10997,8518,37509,37510,53526,15603,98,8644,117,8627,142,8486,8609,15609,10356)
),

pscis_measurements AS
(
SELECT
  e.stream_crossing_id,
  e.wscode_ltree,
  e.localcode_ltree,
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
AND e.watershed_group_code in ('LNIC','BULK','HORS','ELKR')
AND e.stream_crossing_id NOT IN (57592,123894,57408,124137)
),

combined AS
(SELECT
  f.stream_sample_site_id,
  p.stream_crossing_id,
  coalesce(f.wscode_ltree, p.wscode_ltree) as wscode_ltree,
  coalesce(f.localcode_ltree, p.localcode_ltree) as localcode_ltree,
  coalesce(f.watershed_group_code, p.watershed_group_code) as watershed_group_code,
  coalesce(f.channel_width_fiss, p.channel_width_pscis) as channel_width
FROM fiss_measurements f
FULL OUTER JOIN pscis_measurements p
ON f.wscode_ltree = p.wscode_ltree
AND f.localcode_ltree = p.localcode_ltree),

measurements AS
(SELECT
 wscode_ltree,
 localcode_ltree,
 array_agg(stream_sample_site_id) filter (where stream_sample_site_id is not null) as stream_sample_site_ids,
 array_agg(stream_crossing_id) filter (where stream_crossing_id is not null) AS stream_crossing_ids,
 round(avg(channel_width)::numeric, 2) as channel_width
FROM combined
GROUP BY
 wscode_ltree,
 localcode_ltree
)

UPDATE bcfishpass.channel_width c
SET
  stream_sample_site_ids = m.stream_sample_site_ids,
  stream_crossing_ids = m.stream_crossing_ids,
  channel_width_measured = m.channel_width
FROM measurements m
WHERE c.wscode_ltree = m.wscode_ltree
AND c.localcode_ltree = m.localcode_ltree;