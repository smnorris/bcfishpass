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
    --aggregated_crossings_id integer,
    aggregated_crossings_id integer PRIMARY KEY GENERATED ALWAYS AS
       (COALESCE(COALESCE(stream_crossing_id, modelled_crossing_id + 1000000000), dam_id + 1000000000)) STORED,
    stream_crossing_id integer UNIQUE,
    dam_id integer UNIQUE,
    modelled_crossing_id integer UNIQUE,
    crossing_source text,
    crossing_type text,
    crossing_name text,
    barrier_status text,
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
-- --------------------------------
INSERT INTO bcfishpass.crossings
(
    stream_crossing_id,
    modelled_crossing_id,
    crossing_source,
    crossing_type,
    barrier_status,
    crossing_name,
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
    e.pscis_status as crossing_source,
    e.current_crossing_subtype_code as crossing_type,
    -- use manually updated barrier result code if available
    COALESCE(f.updated_barrier_result_code, e.current_barrier_result_code) as barrier_status,
    a.road_name as crossing_name,
    e.linear_feature_id,
    e.blue_line_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    e.geom
FROM bcfishpass.pscis_events_sp e
LEFT OUTER JOIN bcfishpass.pscis_points_all p
ON e.stream_crossing_id = p.stream_crossing_id
LEFT OUTER JOIN bcfishpass.pscis_barrier_result_fixes f
ON e.stream_crossing_id = f.stream_crossing_id
LEFT OUTER JOIN whse_fish.pscis_assessment_svw a
ON e.stream_crossing_id = a.stream_crossing_id
-- only include PSCIS crossings within the watershed groups of interest for now
-- (there are some in the HARR group that fall on the fraser)
WHERE e.watershed_group_code IN ('HORS','LNIC','BULK','ELKR')
ORDER BY e.stream_crossing_id
ON CONFLICT DO NOTHING;

-- --------------------------------
-- dams
-----------------------------------
INSERT INTO bcfishpass.crossings
(
    dam_id,
    crossing_source,
    crossing_type,
    barrier_status,
    crossing_name,
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
    'DAM' AS crossing_type,
    CASE
      WHEN UPPER(d.barrier_ind) = 'Y' THEN 'BARRIER'
      WHEN UPPER(d.barrier_ind) = 'N' THEN 'PASSABLE'
    END AS barrier_status,
    d.dam_name as crossing_name,
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
-- include only watershed groups of interest for now
AND d.watershed_group_code IN ('HORS','LNIC','BULK','ELKR')
ORDER BY dam_id
ON CONFLICT DO NOTHING;


-- --------------------------------
-- insert modelled culverts
-- --------------------------------
INSERT INTO bcfishpass.crossings
(
    modelled_crossing_id,
    crossing_source,
    crossing_type,
    barrier_status,
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
    'MODELLED_CROSSINGS' as crossing_source,
    COALESCE(f.structure, modelled_crossing_type) AS crossing_type,
    CASE
      WHEN modelled_crossing_type = 'CBS' AND COALESCE(f.structure, 'CBS') != 'OBS' THEN 'POTENTIAL'
      WHEN modelled_crossing_type = 'OBS' OR COALESCE(f.structure, 'CBS') = 'OBS' THEN 'PASSABLE'
    END AS barrier_status,
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
WHERE b.blue_line_key = s.watershed_key
-- don't include crossings that have been determined to be non-existent (f.structure = 'NONE')
AND (f.structure IS NULL OR COALESCE(f.structure, 'CBS') = 'OBS')
-- don't include PSCIS crossings
AND p.stream_crossing_id IS NULL
-- just work with groups of interest for now.
AND b.watershed_group_code IN ('HORS','LNIC','BULK','ELKR')
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