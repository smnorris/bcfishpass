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
  -- Note how the aggregated crossing id combines the various ids to create a unique integer, after assigning PSCIS crossings their source crossing id
  -- - to avoid conflict with PSCIS ids, moelled crossings have modelled_crossing_id plus 1000000000 (max modelled crossing id is currently 24742842)
  -- - dams go into the 1100000000 bin
  -- - misc go into the 1200000000 bin
  -- postgres max integer is 2147483647 so this leaves room for 9 additional sources with this simple system
  -- (but of course it could be broken down further if neeeded)

    aggregated_crossings_id integer PRIMARY KEY GENERATED ALWAYS AS
       (COALESCE(COALESCE(COALESCE(stream_crossing_id, modelled_crossing_id + 1000000000), dam_id + 1100000000), misc_barrier_anthropogenic_id + 1200000000)) STORED,
    stream_crossing_id integer UNIQUE,
    dam_id integer UNIQUE,
    misc_barrier_anthropogenic_id integer UNIQUE,
    modelled_crossing_id integer UNIQUE,
    crossing_source text,                 -- pscis/dam/model, can be inferred from above ids

    -- basic crossing status/info - use PSCIS where available, insert model info where no PSCIS
    pscis_status text,                    -- ASSESSED/HABITAT CONFIRMATION etc
    crossing_type_code text,              -- PSCIS crossing_type_code where available, model CBS/OBS otherwise
    crossing_subtype_code text,           -- PSCIS crossing_subtype_code info (BRIDGE, FORD, ROUND etc) (NULL for modelled crossings)
    modelled_crossing_type_source text[], -- for modelled crossings, what data source(s) indicate that a modelled crossing is OBS
    barrier_status text,                  -- PSCIS barrier status if available, otherwise 'POTENTIAL' for modelled CBS, 'PASSABLE' for modelled OBS
    pscis_road_name text,

    -- DRA info
    transport_line_structured_name_1 text,
    transport_line_type_description text,
    transport_line_surface_description text,

    -- forest road tenure info
    ften_forest_file_id text,
    ften_file_type_description text,
    ften_client_number text,
    ften_client_name text,
    ften_life_cycle_status_code text,

    -- rail info
    rail_track_name text,
    rail_owner_name text,
    rail_operator_english_name text,

    -- ogc roads
    ogc_proponent text,

    -- dam info
    dam_name text,
    dam_owner text,

    -- CWF WCRP specific type (rail/road/trail/dam/weir)
    wcrp_barrier_type text,

    -- coordinates (of the point snapped to the stream)
    utm_zone  integer,
    utm_easting integer,
    utm_northing integer,

    -- FWA info
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
    pscis_road_name,

    transport_line_structured_name_1,
    transport_line_type_description,
    transport_line_surface_description,

    ften_forest_file_id,
    ften_file_type_description,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,

    rail_track_name,
    rail_owner_name,
    rail_operator_english_name,

    ogc_proponent,

    utm_zone,
    utm_easting,
    utm_northing,
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
    CASE
      WHEN f.updated_barrier_result_code IN ('PASSABLE','POTENTIAL','BARRIER') -- use manually updated barrier result code if available (but filter out NOT ACCESSIBLE)
      THEN f.updated_barrier_result_code
      ELSE  e.current_barrier_result_code
    END as barrier_status,

    a.road_name as pscis_road_name,

    dra.structured_name_1 as transport_line_structured_name_1,
    dratype.description as transport_line_type_description,
    drasurface.description as transport_line_surface_description,

    ften.forest_file_id as ften_forest_file_id,
    ften.file_type_description as ften_file_type_description,
    ften.client_number as ften_client_number,
    ften.client_name as ften_client_name,
    ften.life_cycle_status_code as ften_life_cycle_status_code,

    rail.track_name as rail_track_name,
    rail.owner_name AS rail_owner_name,
    rail.operator_english_name as rail_operator_english_name,

    COALESCE(ogc1.proponent, ogc2.proponent) as ogc_proponent,

    SUBSTRING(to_char(utmzone(e.geom),'999999') from 6 for 2)::int as utm_zone,
    ST_X(ST_Transform(e.geom, utmzone(e.geom)))::int as utm_easting,
    ST_Y(ST_Transform(e.geom, utmzone(e.geom)))::int as utm_northing,
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
LEFT OUTER JOIN whse_mineral_tenure.og_road_segment_permit_sp ogc1
ON m.og_road_segment_permit_id = ogc1.og_road_segment_permit_id
LEFT OUTER JOIN whse_mineral_tenure.og_petrlm_dev_rds_pre06_pub_sp ogc2
ON m.og_petrlm_dev_rd_pre06_pub_id = ogc2.og_petrlm_dev_rd_pre06_pub_id
LEFT OUTER JOIN whse_basemapping.transport_line_type_code dratype
ON dra.transport_line_type_code = dratype.transport_line_type_code
LEFT OUTER JOIN whse_basemapping.transport_line_surface_code drasurface
ON dra.transport_line_surface_code = drasurface.transport_line_surface_code
WHERE e.modelled_crossing_id IS NOT NULL   -- only PSCIS crossings that have been linked to a modelled crossing
ORDER BY e.stream_crossing_id
ON CONFLICT DO NOTHING;


-- --------------------------------
-- Now PSCIS records NOT linked to modelled crossings.
-- This generally means they are not on a mapped stream - they may still be on a mapped road - try and get that info
-- don't bother trying to link to OGC roads.
-- --------------------------------
WITH rail AS
(
  SELECT
    pt.stream_crossing_id,
    nn.*
  FROM bcfishpass.pscis_events_sp as pt
  CROSS JOIN LATERAL
  (SELECT

     NULL as transport_line_structured_name_1,
     NULL as transport_line_type_description,
     NULL as transport_line_surface_description,

     NULL as ften_forest_file_id,
     NULL as ften_file_type_description,
     NULL AS ften_client_number,
     NULL AS ften_client_name,
     NULL AS ften_life_cycle_status_code,


     track_name as rail_track_name,
     owner_name as rail_owner_name,
     operator_english_name as rail_operator_english_name,

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

     structured_name_1,
     transport_line_type_code,
     transport_line_surface_code,
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
     forest_file_id,
     file_type_description,
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

   a.structured_name_1 as transport_line_structured_name_1,
   dratype.description AS transport_line_type_description,
   drasurface.description AS transport_line_surface_description,

  b.forest_file_id AS ften_forest_file_id,
  b.file_type_description AS ften_file_type_description,
  b.client_number AS ften_client_number,
  b.client_name AS ften_client_name,
  b.life_cycle_status_code AS ften_life_cycle_status_code,

   NULL as rail_owner_name,
   NULL as rail_track_name,
   NULL as rail_operator_english_name,

   COALESCE(a.distance_to_road, b.distance_to_road) as distance_to_road
  FROM dra a FULL OUTER JOIN ften b ON a.stream_crossing_id = b.stream_crossing_id
  LEFT OUTER JOIN whse_basemapping.transport_line_type_code dratype
  ON a.transport_line_type_code = dratype.transport_line_type_code
  LEFT OUTER JOIN whse_basemapping.transport_line_surface_code drasurface
  ON a.transport_line_surface_code = drasurface.transport_line_surface_code

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
    pscis_road_name,

    transport_line_structured_name_1,
    transport_line_type_description,
    transport_line_surface_description,

    ften_forest_file_id,
    ften_file_type_description,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,

    rail_track_name,
    rail_owner_name,
    rail_operator_english_name,

    utm_zone,
    utm_easting,
    utm_northing,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)

SELECT DISTINCT ON (stream_crossing_id)
    e.stream_crossing_id,
    'PSCIS' AS crossing_source,
    e.pscis_status,
    e.current_crossing_type_code as crossing_type_code,
    e.current_crossing_subtype_code as crossing_subtype_code,
    COALESCE(f.updated_barrier_result_code, e.current_barrier_result_code) as barrier_status, -- use manually updated barrier result code if available
    a.road_name as pscis_road_name,

    r.transport_line_structured_name_1,
    r.transport_line_type_description,
    r.transport_line_surface_description,
    r.ften_forest_file_id,
    r.ften_file_type_description,
    r.ften_client_number,
    r.ften_client_name,
    r.ften_life_cycle_status_code,
    r.rail_track_name,
    r.rail_owner_name,
    r.rail_operator_english_name,

    SUBSTRING(to_char(utmzone(e.geom),'999999') from 6 for 2)::int as utm_zone,
    ST_X(ST_Transform(e.geom, utmzone(e.geom)))::int as utm_easting,
    ST_Y(ST_Transform(e.geom, utmzone(e.geom)))::int as utm_northing,
    e.linear_feature_id,
    e.blue_line_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    e.geom
FROM bcfishpass.pscis_events_sp e
LEFT OUTER JOIN road_and_rail r
ON r.stream_crossing_id = e.stream_crossing_id
LEFT OUTER JOIN whse_fish.pscis_assessment_svw a
ON e.stream_crossing_id = a.stream_crossing_id
LEFT OUTER JOIN bcfishpass.pscis_barrier_result_fixes f
ON e.stream_crossing_id = f.stream_crossing_id
WHERE e.modelled_crossing_id IS NULL
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
    dam_name,
    dam_owner,
    utm_zone,
    utm_easting,
    utm_northing,
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

    d.dam_name as dam_name,
    d.owner as dam_owner,

    SUBSTRING(to_char(utmzone(d.geom),'999999') from 6 for 2)::int as utm_zone,
    ST_X(ST_Transform(d.geom, utmzone(d.geom)))::int as utm_easting,
    ST_Y(ST_Transform(d.geom, utmzone(d.geom)))::int as utm_northing,
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
-- other misc anthropogenic barriers
-- --------------------------------

-- misc barriers are blue_line_key/measure only - generate geom & get wscodes etc
WITH misc_barriers AS
(
  SELECT
    b.misc_barrier_anthropogenic_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.barrier_type,
    s.linear_feature_id,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    ST_Force2D((ST_Dump(ST_LocateAlong(s.geom, b.downstream_route_measure))).geom) as geom
  FROM bcfishpass.misc_barriers_anthropogenic b
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s
  ON b.blue_line_key = s.blue_line_key
  AND b.downstream_route_measure > s.downstream_route_measure - .001
  AND b.downstream_route_measure + .001 < s.upstream_route_measure
)

INSERT INTO bcfishpass.crossings
(
    misc_barrier_anthropogenic_id,
    crossing_source,
    crossing_type_code,
    crossing_subtype_code,
    barrier_status,
    utm_zone,
    utm_easting,
    utm_northing,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    b.misc_barrier_anthropogenic_id,
    'MISC BARRIERS' as crossing_source,
    b.barrier_type AS crossing_type_code,
    b.barrier_type AS crossing_subtype_code,
    'BARRIER' AS barrier_status,
    SUBSTRING(to_char(utmzone(b.geom),'999999') from 6 for 2)::int as utm_zone,
    ST_X(ST_Transform(b.geom, utmzone(b.geom)))::int as utm_easting,
    ST_Y(ST_Transform(b.geom, utmzone(b.geom)))::int as utm_northing,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    ST_Force2D((st_Dump(b.geom)).geom)
FROM misc_barriers b
ORDER BY misc_barrier_anthropogenic_id
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

    transport_line_structured_name_1,
    transport_line_type_description,
    transport_line_surface_description,
    ften_forest_file_id,
    ften_file_type_description,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,
    rail_track_name,
    rail_owner_name,
    rail_operator_english_name,
    ogc_proponent,
    utm_zone,
    utm_northing,
    utm_easting,
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
    -- assign PASSABLE if modelled as OBS or if a data fix indicates it is OBS
    CASE
      WHEN modelled_crossing_type = 'CBS' AND COALESCE(f.structure, 'CBS') != 'OBS' THEN 'POTENTIAL'
      WHEN modelled_crossing_type = 'OBS' OR COALESCE(f.structure, 'CBS') = 'OBS' THEN 'PASSABLE'
    END AS barrier_status,

    dra.structured_name_1 as transport_line_structured_name_1,
    dratype.description AS transport_line_type_description,
    drasurface.description AS transport_line_surface_description,

    ften.forest_file_id AS ften_forest_file_id,
    ften.file_type_description AS ften_file_type_description,
    ften.client_number AS ften_client_number,
    ften.client_name AS ften_client_name,
    ften.life_cycle_status_code AS ften_life_cycle_status_code,

    rail.track_name AS rail_track_name,
    rail.owner_name AS rail_owner_name,
    rail.operator_english_name AS rail_operator_english_name,

    COALESCE(ogc1.proponent, ogc2.proponent) as ogc_proponent,

    SUBSTRING(to_char(utmzone(b.geom),'999999') from 6 for 2)::int as utm_zone,
    ST_X(ST_Transform(b.geom, utmzone(b.geom)))::int as utm_easting,
    ST_Y(ST_Transform(b.geom, utmzone(b.geom)))::int as utm_northing,
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
LEFT OUTER JOIN whse_mineral_tenure.og_road_segment_permit_sp ogc1
ON b.og_road_segment_permit_id = ogc1.og_road_segment_permit_id
LEFT OUTER JOIN whse_mineral_tenure.og_petrlm_dev_rds_pre06_pub_sp ogc2
ON b.og_petrlm_dev_rd_pre06_pub_id = ogc2.og_petrlm_dev_rd_pre06_pub_id
LEFT OUTER JOIN whse_basemapping.transport_line_type_code dratype
ON dra.transport_line_type_code = dratype.transport_line_type_code
LEFT OUTER JOIN whse_basemapping.transport_line_surface_code drasurface
ON dra.transport_line_surface_code = drasurface.transport_line_surface_code
WHERE b.blue_line_key = s.watershed_key
AND (f.structure IS NULL OR COALESCE(f.structure, 'CBS') = 'OBS')  -- don't include crossings that have been determined to be non-existent (f.structure = 'NONE')
AND p.stream_crossing_id IS NULL  -- don't include PSCIS crossings
ORDER BY modelled_crossing_id
ON CONFLICT DO NOTHING;

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


-- --------------------------------
-- populate wcrp_barrier_type column
-- --------------------------------
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'WEIR' WHERE crossing_type_code = 'WEIR';

UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'DAM' WHERE crossing_source = 'BCDAMS';

-- railway
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'RAIL'
WHERE rail_owner_name IS NOT NULL;

-- tenured roads
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'ROAD, RESOURCE TENURE'
WHERE ften_forest_file_id IS NOT NULL
OR ogc_proponent IS NOT NULL;

-- demographic roads
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'ROAD, DEMOGRAPHIC'
WHERE wcrp_barrier_type IS NULL
AND transport_line_type_description IN (
  'Road alleyway',
  'Road arterial major',
  'Road arterial minor',
  'Road collector major',
  'Road collector minor',
  'Road freeway',
  'Road highway major',
  'Road highway minor',
  'Road lane',
  'Road local',
  'Private driveway demographic',
  'Road pedestrian mall',
  'Road runway non-demographic',
  'Road recreation demographic',
  'Road ramp',
  'Road restricted',
  'Road strata',
  'Road service',
  'Road yield lane'
);

UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'TRAIL'
WHERE wcrp_barrier_type IS NULL AND
UPPER(transport_line_type_description) LIKE 'TRAIL%';

-- everything else from DRA
UPDATE bcfishpass.crossings
SET wcrp_barrier_type = 'ROAD, OTHER' WHERE wcrp_barrier_type IS NULL AND transport_line_type_description IS NOT NULL;
