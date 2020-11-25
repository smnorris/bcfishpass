-- -----------------------------------------------
-- Find open bottom structures as best as possible
-- -----------------------------------------------

-- Start with stream order
UPDATE bcfishpass.modelled_stream_crossings x
SET
  modelled_crossing_type = 'OBS',
  modelled_crossing_type_source = ARRAY['FWA_STREAM_ORDER']
FROM whse_basemapping.fwa_stream_networks_sp s
WHERE x.linear_feature_id = s.linear_feature_id
AND s.stream_order >= 6
-- this is a office identified culvert.
-- if we are going to flag culverts on streams of order 6 and greater
-- a lookup should be maintained but this single crossing is fine in here for now
AND s.linear_feature_id != 701296585;

-- double line streams/waterbodies
UPDATE bcfishpass.modelled_stream_crossings x
SET
  modelled_crossing_type = 'OBS',
  modelled_crossing_type_source = modelled_crossing_type_source||ARRAY['FWA_EDGE_TYPE']
FROM whse_basemapping.fwa_stream_networks_sp s
WHERE x.linear_feature_id = s.linear_feature_id
AND s.edge_type IN (1200, 1250, 1300, 1350, 1400, 1450, 1475);

-- MOT structures, find crossings with 15m
WITH mot_bridges AS
(
  SELECT
    a.hwy_structure_class_id,
    nn.modelled_crossing_id
  FROM whse_imagery_and_base_maps.mot_road_structure_sp a
  CROSS JOIN LATERAL
    (SELECT
       modelled_crossing_id,
       ST_Distance(a.geom, b.geom) as dist
     FROM bcfishpass.modelled_stream_crossings b
     ORDER BY a.geom <-> b.geom
     LIMIT 1) as nn
  WHERE UPPER(a.bmis_structure_type) = 'BRIDGE'
  AND UPPER(a.bmis_struct_status_type_desc) = 'OPEN/IN USE'
  AND nn.dist < 15
)
UPDATE bcfishpass.modelled_stream_crossings x
SET modelled_crossing_type = 'OBS',
modelled_crossing_type_source = modelled_crossing_type_source||ARRAY['MOT_ROAD_STRUCTURE_SP']
FROM mot_bridges y
WHERE x.modelled_crossing_id = y.modelled_crossing_id;

-- DRA structures, simply join on id
UPDATE bcfishpass.modelled_stream_crossings x
SET
  modelled_crossing_type = 'OBS',
  modelled_crossing_type_source = modelled_crossing_type_source||ARRAY['TRANSPORT_LINE_STRUCTURE_CODE']
FROM whse_basemapping.transport_line r
WHERE x.transport_line_id = r.transport_line_id
AND r.transport_line_structure_code IN ('B','C','E','F','O','R','V');

-- Railway structures don't join back to railway tracks 1:1, find crossings
-- within 10.5m of the bridges (because crossings were clustered to 20m)
UPDATE bcfishpass.modelled_stream_crossings x
SET
  modelled_crossing_type = 'OBS',
  modelled_crossing_type_source = modelled_crossing_type_source||ARRAY['GBA_RAILWAY_STRUCTURE_LINES_SP']
FROM whse_basemapping.gba_railway_structure_lines_sp r
WHERE ST_Intersects(ST_Buffer(x.geom, 10.01), r.geom)
AND UPPER(r.structure_type) LIKE 'BRIDGE%'
AND x.railway_track_id IS NOT NULL;

-- default everything else to CBS
-- (but note that PSCIS will replace many of these with OBS)
UPDATE bcfishpass.modelled_stream_crossings x
SET modelled_crossing_type = 'CBS'
WHERE modelled_crossing_type IS NULL;

