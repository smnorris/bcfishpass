-- Create table holding *all* stream crossings for reporting (not just barriers)
-- 1. PSCIS (all crossings on streams)
-- 2. Dams (major and minor)
-- 3. Modelled crossings (culverts and bridges)
-- 4. Other ?

-- --------------------------------
-- create table
-- --------------------------------
DROP TABLE IF EXISTS bcfishpass.crossings;
CREATE TABLE bcfishpass.crossings
(
    aggregated_crossings_id integer PRIMARY KEY GENERATED ALWAYS AS
       (COALESCE(COALESCE(stream_crossing_id, modelled_crossing_id + 1000000000), dam_id + 1000000000)) STORED,
    stream_crossing_id integer UNIQUE,
    dam_id integer UNIQUE,
    modelled_crossing_id integer UNIQUE,
    crossing_source text,                 -- pscis/dam/model, can be inferred from above ids

    -- basic crossing status/info - use PSCIS where available, insert model info where no PSCIS
    pscis_status text,            -- ASSESSED/HABITAT CONFIRMATION etc
    crossing_type_code text,              -- PSCIS info plus model info CBS/OBS/OTHER
    crossing_subtype_code text,           -- PSCIS crossing subtype info (BRIDGE, FORD, ROUND etc)
    modelled_crossing_type_source text[], -- what data source(s) indicate that a modelled crossing is OBS
    barrier_status text,

    -- CWF WCRP specific types (rail/road/trail/dam)
    wcrp_barrier_type_detailed text,      -- road tenure type details plus rail/trail/dam
    wcrp_barrier_type text,               -- simplified wcrp crossing type (road demographic, road forest/other, trail, dam)

    -- names where available
    pscis_road_name text,
    dra_road_name text,
    rail_owner_name text,
    dam_name text,

    -- forest road tenure info
    ften_forest_file_id text,
    ften_client_number text,
    ften_client_name text,
    ften_life_cycle_status_code text,
    -- NOTE we could insert ogc tenure data here too but ogc roads are not a priority at the moment

    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    -- add a unique constraint on linear location
    -- (so that we don't have points in the same spot messing up subsequent joins)
    UNIQUE (blue_line_key, downstream_route_measure)
);

-- --------------------------------
-- insert PSCIS crossings first, they take precedence
-- PSCIS on modelled crossings first, to get the road tenure info from model
-- --------------------------------
INSERT INTO bcfishpass.crossings
(
    stream_crossing_id,
    modelled_crossing_id,

    crossing_source,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    modelled_crossing_type_source,
    barrier_status,

    wcrp_barrier_type_detailed,
    pscis_road_name,
    dra_road_name,
    rail_owner_name,
    ften_forest_file_id,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)

SELECT
    e.stream_crossing_id,
    e.modelled_crossing_id,
    'PSCIS' AS crossing_source,
    e.pscis_status,
    e.current_crossing_type_code as crossing_type_code,
    e.current_crossing_subtype_code as crossing_subtype_code,
    CASE
      WHEN mf.structure = 'OBS' THEN array['MANUAL FIX']   -- note modelled crossings that have been manually identified as OBS
      ELSE m.modelled_crossing_type_source
    END AS modelled_crossing_type_source,
    COALESCE(f.updated_barrier_result_code, e.current_barrier_result_code) as barrier_status, -- use manually updated barrier result code if available

    -- type = rail/trail/forest road/ogc road/public road/dam - this all comes from modelled crossings
    CASE
      WHEN m.railway_track_id IS NOT NULL THEN 'RAILWAY'
      WHEN m.railway_track_id IS NULL AND
           m.ften_road_section_lines_id IS NOT NULL THEN 'FTEN, '||UPPER(ften.file_type_description)
      WHEN m.railway_track_id IS NULL AND
           m.ften_road_section_lines_id IS NULL AND
           (m.og_road_segment_permit_id IS NOT NULL OR m.og_petrlm_dev_rd_pre06_pub_id IS NOT NULL) THEN 'OIL AND GAS ROAD'
      WHEN m.railway_track_id IS NULL AND
           m.ften_road_section_lines_id IS NULL AND
           m.og_road_segment_permit_id IS NULL AND
           m.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('RA','RA1','RA2','RC1','RC2','RF','RH1','RH2','RLN','RLO','RPD','RPM','RYL','RRP','RRT','RST','RSV','RRC') THEN 'DRA, DEMOGRAPHIC'
      WHEN m.railway_track_id IS NULL AND
           m.ften_road_section_lines_id IS NULL AND
           m.og_road_segment_permit_id IS NULL AND
           m.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('REC') THEN 'DRA, RECREATION'
      WHEN m.railway_track_id IS NULL AND
           m.ften_road_section_lines_id IS NULL AND
           m.og_road_segment_permit_id IS NULL AND
           m.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('RDN','RRS','RRD','RU','RRN') THEN 'DRA, RESOURCE/OTHER'
      WHEN m.railway_track_id IS NULL AND
           m.ften_road_section_lines_id IS NULL AND
           m.og_road_segment_permit_id IS NULL AND
           m.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('T','TD','TR','TS') THEN 'DRA, TRAIL'
      WHEN m.railway_track_id IS NULL AND
           m.ften_road_section_lines_id IS NULL AND
           m.og_road_segment_permit_id IS NULL AND
           m.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('RR','RR1') THEN 'DRA, RUNWAY'
    END AS wcrp_barrier_type_detailed,
    a.road_name as pscis_road_name,
    dra.structured_name_1 as dra_road_name,
    rail.owner_name AS rail_owner_name,
    ften.forest_file_id as ften_forest_file_id,
    ften.client_number as ften_client_number,
    ften.client_name as ften_client_name,
    ften.life_cycle_status_code as ften_life_cycle_status_code,
    e.linear_feature_id,
    e.blue_line_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    e.geom
FROM bcfishpass.pscis_events_sp e
LEFT OUTER JOIN bcfishpass.pscis_barrier_result_fixes f
ON e.stream_crossing_id = f.stream_crossing_id
LEFT OUTER JOIN whse_fish.pscis_assessment_svw a
ON e.stream_crossing_id = a.stream_crossing_id
LEFT OUTER JOIN bcfishpass.modelled_stream_crossings m
ON e.modelled_crossing_id = m.modelled_crossing_id
LEFT OUTER JOIN bcfishpass.modelled_stream_crossings_fixes mf
ON m.modelled_crossing_id = mf.modelled_crossing_id
LEFT OUTER JOIN whse_basemapping.gba_railway_tracks_sp rail
ON m.railway_track_id = rail.railway_track_id
LEFT OUTER JOIN whse_basemapping.transport_line dra
ON m.transport_line_id = dra.transport_line_id
LEFT OUTER JOIN whse_forest_tenure.ften_road_section_lines_svw ften
ON m.ften_road_section_lines_id = ften.id  -- note the id supplied by WFS is the link, may be unstable?
WHERE e.modelled_crossing_id IS NOT NULL   -- only PSCIS crossings that have been linked to a modelled crossing
ORDER BY e.stream_crossing_id
ON CONFLICT DO NOTHING;


-- --------------------------------
-- Now PSCIS records NOT linked to modelled crossings.
-- This generally means they are not on a mapped stream - they may still be on a mapped road - try and get that info
-- --------------------------------
WITH rail AS
(
  SELECT
    pt.stream_crossing_id,
    nn.*
  FROM bcfishpass.pscis_events_sp as pt
  CROSS JOIN LATERAL
  (SELECT
     'RAILWAY' as wcrp_barrier_type_detailed,
     owner_name as rail_owner_name,
     NULL as dra_road_name,
     NULL as ften_forest_file_id,
     NULL AS ften_client_number,
     NULL AS ften_client_name,
     NULL AS ften_life_cycle_status_code,
     ST_Distance(rd.geom, pt.geom) as distance_to_road
   FROM whse_basemapping.gba_railway_tracks_sp AS rd
   ORDER BY rd.geom <-> pt.geom
   LIMIT 1) as nn
  INNER JOIN whse_basemapping.fwa_watershed_groups_poly wsg
  ON st_intersects(pt.geom, wsg.geom)
  AND nn.distance_to_road < 25
  WHERE pt.modelled_crossing_id IS NULL
),

dra as
(
  SELECT
    pt.stream_crossing_id,
    nn.*
  FROM bcfishpass.pscis_events_sp as pt
  CROSS JOIN LATERAL
  (SELECT
      CASE
        WHEN transport_line_type_code IN ('RA','RA1','RA2','RC1','RC2','RF','RH1','RH2','RLN','RLO','RPD','RPM','RYL','RRP','RRT','RST','RSV','RRC') THEN 'DRA, DEMOGRAPHIC'
        WHEN transport_line_type_code IN ('REC') THEN 'DRA, RECREATION'
        WHEN transport_line_type_code IN ('RDN','RRS','RRD','RU','RRN') THEN 'DRA, RESOURCE/OTHER'
        WHEN transport_line_type_code IN ('T','TD','TR','TS') THEN 'DRA, TRAIL'
        WHEN transport_line_type_code IN ('RR','RR1') THEN 'DRA, RUNWAY'
      END AS wcrp_barrier_type_detailed,
     structured_name_1,
     ST_Distance(rd.geom, pt.geom) as distance_to_road
   FROM whse_basemapping.transport_line AS rd
   ORDER BY rd.geom <-> pt.geom
   LIMIT 1) as nn
  INNER JOIN whse_basemapping.fwa_watershed_groups_poly wsg
  ON st_intersects(pt.geom, wsg.geom)
  AND nn.distance_to_road < 30
  WHERE pt.modelled_crossing_id IS NULL
),

ften as (
  SELECT
    pt.stream_crossing_id,
    nn.*
  FROM bcfishpass.pscis_events_sp as pt
  CROSS JOIN LATERAL
  (SELECT
    'FTEN, '||UPPER(file_type_description) as wcrp_barrier_type_detailed,
     forest_file_id,
     client_number,
     client_name,
     life_cycle_status_code,
     ST_Distance(rd.geom, pt.geom) as distance_to_road
   FROM whse_forest_tenure.ften_road_segment_lines_svw AS rd
   WHERE life_cycle_status_code NOT IN ('PENDING')
   ORDER BY rd.geom <-> pt.geom
   LIMIT 1) as nn
  INNER JOIN whse_basemapping.fwa_watershed_groups_poly wsg
  ON st_intersects(pt.geom, wsg.geom)
  AND nn.distance_to_road < 30
  WHERE pt.modelled_crossing_id IS NULL
),

-- combine DRA and FTEN into a road lookup
roads AS
(
  SELECT
   COALESCE(a.stream_crossing_id, b.stream_crossing_id) as stream_crossing_id,
   COALESCE(b.wcrp_barrier_type_detailed, a.wcrp_barrier_type_detailed) as wcrp_barrier_type_detailed, -- ften type is preferred
   NULL as rail_owner_name,
   a.structured_name_1 as dra_road_name,
   b.forest_file_id as ften_forest_file_id,
   b.client_number AS ften_client_number,
   b.client_name AS ften_client_name,
   b.life_cycle_status_code AS ften_life_cycle_status_code,
   COALESCE(a.distance_to_road, b.distance_to_road) as distance_to_road
  FROM dra a FULL OUTER JOIN ften b ON a.stream_crossing_id = b.stream_crossing_id
),

road_and_rail AS
(
  SELECT * FROM rail
  UNION ALL
  SELECT * FROM roads
)


INSERT INTO bcfishpass.crossings
(
    stream_crossing_id,
    crossing_source,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    barrier_status,
    wcrp_barrier_type_detailed,
    pscis_road_name,
    dra_road_name,
    rail_owner_name,
    ften_forest_file_id,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)

SELECT DISTINCT ON (stream_crossing_id)
    r.stream_crossing_id,
    'PSCIS' AS crossing_source,
    e.pscis_status,
    e.current_crossing_type_code as crossing_type_code,
    e.current_crossing_subtype_code as crossing_subtype_code,
    COALESCE(f.updated_barrier_result_code, e.current_barrier_result_code) as barrier_status, -- use manually updated barrier result code if available
    r.wcrp_barrier_type_detailed,
    a.road_name as pscis_road_name,
    r.dra_road_name,
    r.ften_forest_file_id,
    r.ften_client_number,
    r.ften_client_name,
    r.ften_life_cycle_status_code,
    r.rail_owner_name,
    e.linear_feature_id,
    e.blue_line_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    e.geom
FROM road_and_rail r
INNER JOIN bcfishpass.pscis_events_sp e
ON r.stream_crossing_id = e.stream_crossing_id
LEFT OUTER JOIN whse_fish.pscis_assessment_svw a
ON e.stream_crossing_id = a.stream_crossing_id
LEFT OUTER JOIN bcfishpass.pscis_barrier_result_fixes f
ON e.stream_crossing_id = f.stream_crossing_id
ORDER BY stream_crossing_id, distance_to_road asc
ON CONFLICT DO NOTHING;

-- --------------------------------
-- dams
-----------------------------------
INSERT INTO bcfishpass.crossings
(
    dam_id,
    crossing_source,
    crossing_type_code,
    crossing_subtype_code,
    barrier_status,
    wcrp_barrier_type_detailed,
    dam_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    d.dam_id,
    'BCDAMS' as crossing_source,
    'DAM' AS crossing_type_code,
    'DAM' AS crossing_subtype_code,
    CASE
      WHEN UPPER(d.barrier_ind) = 'Y' THEN 'BARRIER'
      WHEN UPPER(d.barrier_ind) = 'N' THEN 'PASSABLE'
    END AS barrier_status,
    'DAM' AS wcrp_barrier_type_detailed,
    d.dam_name as dam_name,
    d.linear_feature_id,
    d.blue_line_key,
    d.downstream_route_measure,
    d.wscode_ltree,
    d.localcode_ltree,
    d.watershed_group_code,
    ST_Force2D((st_Dump(d.geom)).geom)
FROM bcfishpass.bcdams_events d
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON d.linear_feature_id = s.linear_feature_id
-- ignore dams on side channels for this exercise
WHERE d.blue_line_key = s.watershed_key
-- do not include major/bc hydro dams, they are definite barriers, already in the barriers_majordams table
AND d.hydro_dam_ind = 'N'
ORDER BY dam_id
ON CONFLICT DO NOTHING;


-- --------------------------------
-- insert modelled crossings
-- --------------------------------
INSERT INTO bcfishpass.crossings
(
    modelled_crossing_id,
    crossing_source,
    modelled_crossing_type_source,
    crossing_type_code,
    barrier_status,
    wcrp_barrier_type_detailed,
    dra_road_name,
    ften_forest_file_id,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,
    rail_owner_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)

SELECT
    b.modelled_crossing_id,
    'MODELLED CROSSINGS' as crossing_source,
    CASE
      WHEN f.structure = 'OBS' THEN array['MANUAL FIX']   -- note modelled crossings that have been manually identified as OBS
      ELSE b.modelled_crossing_type_source
    END AS modelled_crossing_type_source,
    COALESCE(f.structure, b.modelled_crossing_type) as crossing_type_code,
    -- POTENTIAL is default for modelled CBS crossings
    -- assign PASSABLE if modelled as OBS or if the fix indicates it is OBS
    CASE
      WHEN modelled_crossing_type = 'CBS' AND COALESCE(f.structure, 'CBS') != 'OBS' THEN 'POTENTIAL'
      WHEN modelled_crossing_type = 'OBS' OR COALESCE(f.structure, 'CBS') = 'OBS' THEN 'PASSABLE'
    END AS barrier_status,
    -- type = rail/trail/forest road/ogc road/public road/dam - this all comes from modelled crossings
    CASE
      WHEN b.railway_track_id IS NOT NULL THEN 'RAILWAY'
      WHEN b.railway_track_id IS NULL AND
           b.ften_road_section_lines_id IS NOT NULL THEN 'FTEN, '||UPPER(ften.file_type_description)
      WHEN b.railway_track_id IS NULL AND
           b.ften_road_section_lines_id IS NULL AND
           (b.og_road_segment_permit_id IS NOT NULL OR b.og_petrlm_dev_rd_pre06_pub_id IS NOT NULL) THEN 'OIL AND GAS ROAD'
      WHEN b.railway_track_id IS NULL AND
           b.ften_road_section_lines_id IS NULL AND
           b.og_road_segment_permit_id IS NULL AND
           b.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('RA','RA1','RA2','RC1','RC2','RF','RH1','RH2','RLN','RLO','RPD','RPM','RYL','RRP','RRT','RST','RSV','RRC') THEN 'DRA, DEMOGRAPHIC'
      WHEN b.railway_track_id IS NULL AND
           b.ften_road_section_lines_id IS NULL AND
           b.og_road_segment_permit_id IS NULL AND
           b.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('REC') THEN 'DRA, RECREATION'
      WHEN b.railway_track_id IS NULL AND
           b.ften_road_section_lines_id IS NULL AND
           b.og_road_segment_permit_id IS NULL AND
           b.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('RDN','RRS','RRD','RU','RRN') THEN 'DRA, RESOURCE/OTHER'
      WHEN b.railway_track_id IS NULL AND
           b.ften_road_section_lines_id IS NULL AND
           b.og_road_segment_permit_id IS NULL AND
           b.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('T','TD','TR','TS') THEN 'DRA, TRAIL'
      WHEN b.railway_track_id IS NULL AND
           b.ften_road_section_lines_id IS NULL AND
           b.og_road_segment_permit_id IS NULL AND
           b.og_petrlm_dev_rd_pre06_pub_id IS NULL AND
           dra.transport_line_type_code IN ('RR','RR1') THEN 'DRA, RUNWAY'
    END AS wcrp_barrier_type_detailed,
    dra.structured_name_1 as dra_road_name,
    ften.forest_file_id as ften_forest_file_id,
    ften.client_number as ften_client_number,
    ften.client_name as ften_client_name,
    ften.life_cycle_status_code as ften_life_cycle_status_code,
    rail.owner_name AS rail_owner_name,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    ST_Force2D((ST_Dump(b.geom)).geom) as geom
FROM bcfishpass.modelled_stream_crossings b
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON b.linear_feature_id = s.linear_feature_id
LEFT OUTER JOIN bcfishpass.pscis_events_sp p
ON b.modelled_crossing_id = p.modelled_crossing_id
LEFT OUTER JOIN bcfishpass.modelled_stream_crossings_fixes f
ON b.modelled_crossing_id = f.modelled_crossing_id
LEFT OUTER JOIN whse_basemapping.gba_railway_tracks_sp rail
ON b.railway_track_id = rail.railway_track_id
LEFT OUTER JOIN whse_basemapping.transport_line dra
ON b.transport_line_id = dra.transport_line_id
LEFT OUTER JOIN whse_forest_tenure.ften_road_section_lines_svw ften
ON b.ften_road_section_lines_id = ften.id  -- note the id supplied by WFS is the link, may be unstable?
WHERE b.blue_line_key = s.watershed_key
AND (f.structure IS NULL OR COALESCE(f.structure, 'CBS') = 'OBS')  -- don't include crossings that have been determined to be non-existent (f.structure = 'NONE')
AND p.stream_crossing_id IS NULL  -- don't include PSCIS crossings
ORDER BY modelled_crossing_id
ON CONFLICT DO NOTHING;


-- populate the more general wcrp_barrier_type column
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'RAIL' WHERE wcrp_barrier_type_detailed = 'RAILWAY';
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'DAM' WHERE wcrp_barrier_type_detailed = 'DAM';
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'TRAIL' WHERE wcrp_barrier_type_detailed = 'DRA, TRAIL';
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'ROAD, DEMOGRAPHIC' WHERE wcrp_barrier_type_detailed IN ('DRA, RUNWAY', 'DRA, DEMOGRAPHIC');
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'ROAD, OTHER' WHERE wcrp_barrier_type_detailed IN ('OIL AND GAS ROAD','DRA, RECREATION','DRA, RESOURCE/OTHER') OR wcrp_barrier_type_detailed LIKE 'FTEN%';


-- --------------------------------
-- index for speed
-- --------------------------------
CREATE INDEX ON bcfishpass.crossings (dam_id);
CREATE INDEX ON bcfishpass.crossings (stream_crossing_id);
CREATE INDEX ON bcfishpass.crossings (modelled_crossing_id);
CREATE INDEX ON bcfishpass.crossings (linear_feature_id);
CREATE INDEX ON bcfishpass.crossings (blue_line_key);
CREATE INDEX ON bcfishpass.crossings (watershed_group_code);
CREATE INDEX ON bcfishpass.crossings USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.crossings USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.crossings USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.crossings USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.crossings USING GIST (geom);