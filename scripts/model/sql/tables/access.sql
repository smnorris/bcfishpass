-- create various empty tables required for access model

-- --------------
-- BARRIER_LOAD
--
-- intermediate table for loading various barrier types to consistent structure/location before processing as barriers
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.barrier_load
(
    barrier_load_id int unique,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code character varying (4),
    geom geometry(Point, 3005),
    PRIMARY KEY (blue_line_key, downstream_route_measure)
);

-- --------------
-- SEGMENTED_STREAMS
--
-- a copy of fwa_stream_networks_sp for breaking at barriers/observations
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.segmented_streams
(
  segmented_stream_id bigint GENERATED ALWAYS AS (pair_ids(blue_line_key, trunc(downstream_route_measure * 1000)::bigint)) STORED PRIMARY KEY,
  linear_feature_id         bigint                           ,
  edge_type                 integer                          ,
  blue_line_key             integer                          ,
  watershed_key             integer                          ,
  watershed_group_code      character varying(4)             ,
  downstream_route_measure  double precision                 ,
  length_metre              double precision                 ,
  waterbody_key             integer                          ,
  wscode_ltree              ltree                            ,
  localcode_ltree           ltree                            ,
  gradient double precision GENERATED ALWAYS AS (round((((ST_Z (ST_PointN (geom, - 1)) - ST_Z
    (ST_PointN (geom, 1))) / ST_Length (geom))::numeric), 4)) STORED,
  upstream_route_measure double precision GENERATED ALWAYS AS (downstream_route_measure +
    ST_Length (geom)) STORED,
  geom geometry(LineStringZM,3005)
);

-- --------------
-- BREAKPOINTS
--
-- holds all barriers/observations/other where streams are to be broken
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.breakpoints
(
  blue_line_key integer,
  downstream_route_measure double precision,
  primary key (blue_line_key, downstream_route_measure)
);

-- --------------
-- OBSERVATIONS_LOAD
--
-- initial load target for all latest observation data
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.observations_load
(
  fish_obsrvtn_pnt_distinct_id integer primary key,
  linear_feature_id         bigint                           ,
  blue_line_key             integer                          ,
  wscode_ltree ltree                                         ,
  localcode_ltree ltree                                      ,
  downstream_route_measure  double precision                 ,
  watershed_group_code      character varying(4)             ,
  species_codes text[]                                      ,
  observation_ids int[] ,
  geom geometry(PointZM, 3005)
);

-- --------------
-- OBSERVATIONS
--
-- observation data to be used in model
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.observations
(
  fish_obsrvtn_pnt_distinct_id integer primary key,
  linear_feature_id         bigint                           ,
  blue_line_key             integer                          ,
  wscode_ltree ltree                                         ,
  localcode_ltree ltree                                      ,
  downstream_route_measure  double precision                 ,
  watershed_group_code      character varying(4)             ,
  species_codes text[]                                      ,
  observation_ids int[] ,
  geom geometry(PointZM, 3005)
);

CREATE INDEX IF NOT EXISTS obsrvtn_linear_feature_id_idx ON bcfishpass.observations (linear_feature_id);
CREATE INDEX IF NOT EXISTS obsrvtn_blue_line_key_idx ON bcfishpass.observations (blue_line_key);
CREATE INDEX IF NOT EXISTS obsrvtn_watershed_group_code_idx ON bcfishpass.observations (watershed_group_code);
CREATE INDEX IF NOT EXISTS obsrvtn_wsc_gidx ON bcfishpass.observations USING GIST (wscode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_wsc_bidx ON bcfishpass.observations USING BTREE (wscode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_lc_gidx ON bcfishpass.observations USING GIST (localcode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_lc_bidx ON bcfishpass.observations USING BTREE (localcode_ltree);
CREATE INDEX IF NOT EXISTS obsrvtn_geom_idx ON bcfishpass.observations USING GIST (geom);


-- --------------
-- OBSERVATIONS_UPSTR
--
-- lookup relating streams to observations upstream
-- --------------
CREATE TABLE IF NOT EXISTS bcfishpass.observations_upstr
(
  blue_line_key integer,
  downstream_route_measure double precision,
  watershed_group_code character varying(4),
  obsrvtn_pnt_distinct_upstr integer[],
  obsrvtn_species_codes_upstr text[]
);

CREATE INDEX IF NOT EXISTS obsrvtnupstr_rte_idx ON bcfishpass.observations_upstr (blue_line_key, downstream_route_measure);



-- --------------
-- CROSSINGS
--
-- Table holding *all* stream crossings for reporting (not just barriers)
-- 1. PSCIS (all crossings on streams)
-- 2. Dams (major and minor)
-- 3. Modelled crossings (culverts and bridges)
-- 4. Other ?
-- --------------

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
    pscis_road_name text,                 -- road name from pscis assessment
    pscis_stream_name text,               -- stream name from pscis assessment
    pscis_assessment_comment text,        -- comments from pscis assessment

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
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    gnis_stream_name text,
    geom geometry(Point, 3005),
    -- add a unique constraint on linear location
    -- (so that we don't have points in the same spot messing up subsequent joins)
    UNIQUE (blue_line_key, downstream_route_measure)
);


-- document the columns included
COMMENT ON COLUMN bcfishpass.crossings.aggregated_crossings_id IS 'Unique identifier for crossing, generated from stream_crossing_id, modelled_crossing_id + 1000000000, dam_id + 1100000000, misc_barrier_anthropogenic_id + 1200000000';
COMMENT ON COLUMN bcfishpass.crossings.stream_crossing_id IS 'PSCIS stream crossing unique identifier';
COMMENT ON COLUMN bcfishpass.crossings.dam_id IS 'BC Dams unique identifier';
COMMENT ON COLUMN bcfishpass.crossings.misc_barrier_anthropogenic_id IS 'Misc anthropogenic barriers unique identifier';
COMMENT ON COLUMN bcfishpass.crossings.modelled_crossing_id IS 'Modelled crossing unique identifier';
COMMENT ON COLUMN bcfishpass.crossings.crossing_source IS 'Data source for the crossing, one of: {PSCIS,MODELLED CROSSINGS,BCDAMS,MISC BARRIERS}';
COMMENT ON COLUMN bcfishpass.crossings.pscis_status IS 'From PSCIS, the current_pscis_status of the crossing, one of: {ASSESSED,HABITAT CONFIRMATION,DESIGN,REMEDIATED}';
COMMENT ON COLUMN bcfishpass.crossings.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. Acceptable types are: OBS = Open Bottom Structure CBS = Closed Bottom Structure OTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';
COMMENT ON COLUMN bcfishpass.crossings.crossing_subtype_code IS 'Further definition of the type of crossing, one of {BRIDGE,CRTBOX,DAM,FORD,OVAL,PIPEARCH,ROUND,WEIR,WOODBOX,NULL}';
COMMENT ON COLUMN bcfishpass.crossings.modelled_crossing_type_source IS 'List of sources that indicate if a modelled crossing is open bottom, Acceptable values are: FWA_EDGE_TYPE=double line river, FWA_STREAM_ORDER=stream order >=6, GBA_RAILWAY_STRUCTURE_LINES_SP=railway structure, "MANUAL FIX"=manually identified OBS, MOT_ROAD_STRUCTURE_SP=MoT structure, TRANSPORT_LINE_STRUCTURE_CODE=DRA structure}';
COMMENT ON COLUMN bcfishpass.crossings.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. Acceptable Values are: PASSABLE - Passable, POTENTIAL - Potential Barrier, BARRIER - Barrier, UNKOWN - Other';
COMMENT ON COLUMN bcfishpass.crossings.pscis_road_name  IS 'PSCIS road name, taken from the PSCIS assessment data submission';
COMMENT ON COLUMN bcfishpass.crossings.pscis_road_name  IS 'PSCIS stream name, taken from the PSCIS assessment data submission';
COMMENT ON COLUMN bcfishpass.crossings.pscis_assessment_comment  IS 'PSCIS assessment_comment, taken from the PSCIS assessment data submission';
COMMENT ON COLUMN bcfishpass.crossings.transport_line_structured_name_1 IS 'DRA road name, taken from the nearest DRA road (within 30m)';
COMMENT ON COLUMN bcfishpass.crossings.transport_line_type_description IS 'DRA road type, taken from the nearest DRA road (within 30m)';
COMMENT ON COLUMN bcfishpass.crossings.transport_line_surface_description IS 'DRA road surface, taken from the nearest DRA road (within 30m)';
COMMENT ON COLUMN bcfishpass.crossings.ften_forest_file_id IS 'FTEN road forest_file_id value, taken from the nearest FTEN road (within 30m)';
COMMENT ON COLUMN bcfishpass.crossings.ften_file_type_description IS 'FTEN road tenure type (Forest Service Road, Road Permit, etc), taken from the nearest FTEN road (within 30m)';
COMMENT ON COLUMN bcfishpass.crossings.ften_client_number IS 'FTEN road client number, taken from the nearest FTEN road (within 30m)';
COMMENT ON COLUMN bcfishpass.crossings.ften_client_name IS 'FTEN road client name, taken from the nearest FTEN road (within 30m)';
COMMENT ON COLUMN bcfishpass.crossings.ften_life_cycle_status_code IS 'FTEN road life_cycle_status_code (active or retired, pending roads are not included), taken from the nearest FTEN road (within 30m)';
COMMENT ON COLUMN bcfishpass.crossings.rail_track_name IS 'Railway name, taken from nearest railway (within 25m)';
COMMENT ON COLUMN bcfishpass.crossings.rail_owner_name IS 'Railway owner name, taken from nearest railway (within 25m)';
COMMENT ON COLUMN bcfishpass.crossings.rail_operator_english_name IS 'Railway operator name, taken from nearest railway (within 25m)';;
COMMENT ON COLUMN bcfishpass.crossings.ogc_proponent IS 'OGC road tenure proponent (currently modelled crossings only, taken from OGC road that crosses the stream)';
COMMENT ON COLUMN bcfishpass.crossings.dam_name IS 'Dam name, from Canadian Wildlife Federation BCDAMS dataset, a compilation of several dam data layers';
COMMENT ON COLUMN bcfishpass.crossings.dam_owner IS 'Dam owner, from Canadian Wildlife Federation BCDAMS dataset, a compilation of several dam data layers';
COMMENT ON COLUMN bcfishpass.crossings.wcrp_barrier_type IS 'Custom barrier type classification for CWF Watershed Connectivity Restoration Planning, based on crossing_type_code, crossing_subtype_code and road info, valid types are {DAM,RAIL,"ROAD, DEMOGRAPHIC","ROAD, RESOURCE/OTHER",TRAIL,WEIR}';
COMMENT ON COLUMN bcfishpass.crossings.utm_zone IS 'UTM ZONE is a segment of the Earths surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';
COMMENT ON COLUMN bcfishpass.crossings.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';
COMMENT ON COLUMN bcfishpass.crossings.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';
COMMENT ON COLUMN bcfishpass.crossings.linear_feature_id IS 'From BC FWA, the unique identifier for a stream segment (flow network arc)';
COMMENT ON COLUMN bcfishpass.crossings.blue_line_key IS 'From BC FWA, Uniquely identifies a single flow line such that a main channel and a secondary channel with the same watershed code would have different blue line keys (the Fraser River and all side channels have different blue line keys).';
COMMENT ON COLUMN bcfishpass.crossings.watershed_key IS 'From BC FWA, a key that identifies a stream system. There is a 1:1 match between a watershed key and watershed code. The watershed key will match the blue line key for the mainstem.';
COMMENT ON COLUMN bcfishpass.crossings.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';
COMMENT ON COLUMN bcfishpass.crossings.wscode_ltree IS 'A truncated version of the BC FWA fwa_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';
COMMENT ON COLUMN bcfishpass.crossings.localcode_ltree IS 'A truncated version of the BC FWA local_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';;
COMMENT ON COLUMN bcfishpass.crossings.watershed_group_code IS 'The watershed group code associated with the feature.';
COMMENT ON COLUMN bcfishpass.crossings.gnis_stream_name IS 'The BCGNIS (BC Geographical Names Information System) name associated with the FWA stream';
COMMENT ON COLUMN bcfishpass.crossings.geom IS 'The point geometry associated with the feature';
