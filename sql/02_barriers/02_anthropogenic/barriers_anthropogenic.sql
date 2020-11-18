-- Create table holding barriers and potential barriers for prioritization
-- 1. PSCIS barriers
-- 2. Dams
-- 3. Modelled closed bottom crossings (culverts)

-- --------------------------------
-- create table
-- --------------------------------
DROP TABLE IF EXISTS bcfishpass.barriers_anthropogenic;
CREATE TABLE bcfishpass.barriers_anthropogenic
(
    barrier_anthropogenic_id serial primary key,
    stream_crossing_id integer,
    dam_id integer,
    modelled_crossing_id integer,
    barrier_type text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    -- add a unique constraint so that we don't have equivalent barriers messing up subsequent joins
    UNIQUE (linear_feature_id, downstream_route_measure)
);

-- --------------------------------
-- insert PSCIS barriers first - these have field verified fish passage information
-- --------------------------------
INSERT INTO bcfishpass.barriers_anthropogenic
(
    stream_crossing_id,
    modelled_crossing_id,
    barrier_type,
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
    model_crossing_id as modelled_crossing_id,
    e.pscis_status as barrier_type,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    e.geom
FROM whse_fish.pscis_events_sp e
LEFT OUTER JOIN whse_fish.pscis_points_all p
ON e.stream_crossing_id = p.stream_crossing_id
LEFT OUTER JOIN whse_fish.pscis_assessment_svw a
ON e.stream_crossing_id = a.stream_crossing_id
WHERE (e.current_barrier_result_code IN ('BARRIER', 'POTENTIAL')
-- there are a bunch of designs with no barrier result code
-- include them for now, they should be reviewed.
OR e.current_barrier_result_code IS NULL)
-- only include PSCIS crossings within the watershed groups of interest for now
-- (there are some in the HARR group that fall on the fraser)
AND e.watershed_group_code IN ('HORS','LNIC','BULK','ELKR')
ORDER BY e.stream_crossing_id
ON CONFLICT DO NOTHING;

-- --------------------------------
-- dams
-----------------------------------
INSERT INTO bcfishpass.barriers_anthropogenic
(
    dam_id,
    barrier_type,
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
    'DAM' as barrier_type,
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
WHERE d.barrier_ind = 'Y'
AND d.hydro_dam_ind = 'N'
-- ignore points on side channels for this exercise
AND d.blue_line_key = s.watershed_key
-- include only watershed groups of interest for now
AND d.watershed_group_code IN ('HORS','LNIC','BULK','ELKR')
ORDER BY dam_id
ON CONFLICT DO NOTHING;


-- --------------------------------
-- insert modelled culverts
-- --------------------------------
INSERT INTO bcfishpass.barriers_anthropogenic
(
    modelled_crossing_id,
    barrier_type,
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
    'MODELLED_CULVERT' as barrier_type,
    b.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    ST_Force2D((st_Dump(b.geom)).geom) as geom
FROM fish_passage.modelled_stream_crossings b
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON b.linear_feature_id = s.linear_feature_id
LEFT OUTER JOIN whse_fish.pscis_events p
ON b.modelled_crossing_id = p.model_crossing_id
WHERE b.blue_line_key = s.watershed_key
-- only OBS
AND b.modelled_crossing_type = 'CBS'
-- don't include crossings that have been determined to be open bottom/non-existent
AND b.modelled_crossing_id NOT IN (SELECT modelled_crossing_id FROM bcfishpass.modelled_stream_crossings_fixes)
-- don't include crossings on >= 6th order streams, these won't be culverts
-- *EXCEPT* for this one 6th order stream under hwy 97C by Logan Lake
AND (s.stream_order < 6 OR b.modelled_crossing_id = 6201511)
-- don't include PSCIS crossings
AND p.stream_crossing_id IS NULL
-- just work with groups of interest for now.
AND b.watershed_group_code IN ('HORS','LNIC','BULK','ELKR')
ORDER BY modelled_crossing_id
ON CONFLICT DO NOTHING;


-- --------------------------------
-- index for speed
-- --------------------------------
CREATE INDEX ON bcfishpass.barriers_anthropogenic (dam_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (stream_crossing_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (modelled_crossing_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_anthropogenic (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_anthropogenic USING GIST (geom);


