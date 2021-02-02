-- Create separate barrier table,
-- holding crossings that are barriers and potential barriers

DROP TABLE IF EXISTS bcfishpass.barriers_anthropogenic;

CREATE TABLE bcfishpass.barriers_anthropogenic
(LIKE bcfishpass.crossings INCLUDING ALL);


-- insert all barriers from aggregated crossings table
-- (pscis, dams, modelled xings)
-- no additonal logic required
INSERT INTO bcfishpass.barriers_anthropogenic
(
 stream_crossing_id,
 dam_id,
 modelled_crossing_id,
 crossing_source,
 crossing_type,
 pscis_road_name,
 dra_road_name,
 rail_owner_name,
 dam_name,
 ften_forest_file_id,
 ften_client_number,
 ften_client_name,
 ften_life_cycle_status_code,
 barrier_status,
 linear_feature_id,
 blue_line_key,
 downstream_route_measure,
 wscode_ltree,
 localcode_ltree,
 watershed_group_code,
 geom)
SELECT
 stream_crossing_id,
 dam_id,
 modelled_crossing_id,
 crossing_source,
 crossing_type,
 pscis_road_name,
 dra_road_name,
 rail_owner_name,
 dam_name,
 ften_forest_file_id,
 ften_client_number,
 ften_client_name,
 ften_life_cycle_status_code,
 barrier_status,
 linear_feature_id,
 blue_line_key,
 downstream_route_measure,
 wscode_ltree,
 localcode_ltree,
 c.watershed_group_code as watershed_group_code,
 c.geom as geom
FROM bcfishpass.crossings c
INNER JOIN bcfishpass.watershed_groups g
ON c.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
WHERE barrier_status IN ('BARRIER', 'POTENTIAL')
ON CONFLICT DO NOTHING;

-- add a simple dam/road/trail/rail classifier for WCRP
ALTER TABLE bcfishpass.barriers_anthropogenic
ADD COLUMN IF NOT EXISTS wcrp_type text;

UPDATE bcfishpass.barriers_anthropogenic
SET wcrp_type = 'RAIL' WHERE crossing_type = 'RAILWAY';
UPDATE bcfishpass.barriers_anthropogenic
SET wcrp_type = 'DAM' WHERE crossing_type = 'DAM';
UPDATE bcfishpass.barriers_anthropogenic
SET wcrp_type = 'TRAIL' WHERE crossing_type = 'DRA, TRAIL';
UPDATE bcfishpass.barriers_anthropogenic
SET wcrp_type = 'ROAD, DEMOGRAPHIC' WHERE crossing_type IN ('DRA, RUNWAY', 'DRA, DEMOGRAPHIC');
UPDATE bcfishpass.barriers_anthropogenic
SET wcrp_type = 'ROAD, OTHER' WHERE crossing_type IN ('OIL AND GAS ROAD','DRA, RECREATION','DRA, RESOURCE/OTHER') OR crossing_type LIKE 'FTEN%';


-- for stream visualization, we also want to create a table of pscis confirmed barriers only,
-- so we can see which streams are upstream of CONFIRMED barriers.
-- (this is deleted after coding the streams to avoid confusion)
DROP TABLE IF EXISTS bcfishpass.barriers_pscis;

CREATE TABLE bcfishpass.barriers_pscis
(
    stream_crossing_id integer primary key,
    barrier_status text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    UNIQUE (linear_feature_id, downstream_route_measure)
);
INSERT INTO bcfishpass.barriers_pscis
(
    stream_crossing_id,
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
    stream_crossing_id,
    barrier_status,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
FROM bcfishpass.barriers_anthropogenic
WHERE stream_crossing_id IS NOT NULL;



CREATE INDEX ON bcfishpass.barriers_pscis (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_pscis (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_pscis (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_pscis USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_pscis USING GIST (geom);