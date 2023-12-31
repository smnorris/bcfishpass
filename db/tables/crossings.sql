-- --------------
-- CROSSINGS
--
-- Table holding *all* stream crossings for reporting (not just barriers)
-- 1. PSCIS (all crossings on streams)
-- 2. Dams (major and minor)
-- 3. Modelled crossings (culverts and bridges)
-- 4. Other ?
-- --------------

drop table if exists bcfishpass.crossings cascade;

create table bcfishpass.crossings
(
  -- Note how the aggregated crossing id combines the various ids to create a unique integer, after assigning PSCIS crossings their source crossing id
  -- - to avoid conflict with PSCIS ids, modelled crossings have modelled_crossing_id plus 1000000000 (max modelled crossing id is currently 24742842)
  -- - dams go into the 1100000000 bin
  -- - misc go into the 1200000000 bin
  -- postgres max integer is 2147483647 so this leaves room for 9 additional sources with this simple system
  -- (but of course it could be broken down further if neeeded)

    aggregated_crossings_id text primary key,
    --integer primary key generated always as
    --  (coalesce(coalesce(coalesce(stream_crossing_id, modelled_crossing_id + 1000000000), dam_id + 1100000000), user_barrier_anthropogenic_id + 1200000000)) stored,
    stream_crossing_id integer unique,
    dam_id text,
    user_barrier_anthropogenic_id bigint unique,
    modelled_crossing_id integer unique,
    crossing_source text,                 -- pscis/dam/model, can be inferred from above ids
    crossing_feature_type text,           -- general type of crossing (rail/road/trail/dam/weir)
    
    -- basic crossing status/info
    pscis_status text,                    -- ASSESSED/HABITAT CONFIRMATION etc
    crossing_type_code text,              -- PSCIS crossing_type_code where available, model CBS/OBS otherwise
    crossing_subtype_code text,           -- PSCIS crossing_subtype_code info (BRIDGE, FORD, ROUND etc) (NULL for modelled crossings)
    modelled_crossing_type_source text[], -- for modelled crossings, what data source(s) indicate that a modelled crossing is OBS
    barrier_status text,                  -- PSCIS barrier status if available, otherwise 'POTENTIAL' for modelled CBS, 'PASSABLE' for modelled OBS, CABD status for dams

    -- basic PSCIS info
    pscis_road_name text,                 -- road name from pscis assessment
    pscis_stream_name text,               -- stream name from pscis assessment
    pscis_assessment_comment text,        -- comments from pscis assessment
    pscis_assessment_date date,
    pscis_final_score integer,

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
    dam_height double precision,
    dam_owner text,
    dam_use text,
    dam_operating_status text,

    -- coordinates (of the point snapped to the stream)
    utm_zone  integer,
    utm_easting integer,
    utm_northing integer,

    -- map tile for pdfs
    dbm_mof_50k_grid text,

    -- basic FWA info
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    gnis_stream_name text,
    
    stream_order integer,
    stream_magnitude integer,

    -- area upstream (derived by fwapg)
    -- watershed_upstr_ha double precision DEFAULT 0,

    -- distinct species upstream/downstream, derived from bcfishobs
    observedspp_dnstr text[],
    observedspp_upstr text[],
  
    geom geometry(PointZM, 3005),

    -- only one crossing per location please
    unique (blue_line_key, downstream_route_measure)
);

-- document the columns included
comment on column bcfishpass.crossings.aggregated_crossings_id IS 'unique identifier for crossing, generated from stream_crossing_id, modelled_crossing_id + 1000000000, user_barrier_anthropogenic_id + 1200000000, cabd_id';
comment on column bcfishpass.crossings.stream_crossing_id IS 'PSCIS stream crossing unique identifier';
comment on column bcfishpass.crossings.dam_id IS 'BC Dams unique identifier';
comment on column bcfishpass.crossings.user_barrier_anthropogenic_id IS 'User added misc anthropogenic barriers unique identifier';
comment on column bcfishpass.crossings.modelled_crossing_id IS 'Modelled crossing unique identifier';
comment on column bcfishpass.crossings.crossing_source IS 'Data source for the crossing, one of: {PSCIS,MODELLED CROSSINGS,CABD,MISC BARRIERS}';
comment on column bcfishpass.crossings.crossing_feature_type IS 'The general type of feature crossing the stream, valid feature types are {DAM,RAIL,"ROAD, DEMOGRAPHIC","ROAD, RESOURCE/OTHER",TRAIL,WEIR}';
comment on column bcfishpass.crossings.pscis_status IS 'From PSCIS, the current_pscis_status of the crossing, one of: {ASSESSED,HABITAT CONFIRMATION,DESIGN,REMEDIATED}';
comment on column bcfishpass.crossings.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. Acceptable types are: OBS = Open Bottom Structure CBS = Closed Bottom Structure OTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';
comment on column bcfishpass.crossings.crossing_subtype_code IS 'Further definition of the type of crossing, one of {BRIDGE,CRTBOX,DAM,FORD,OVAL,PIPEARCH,ROUND,WEIR,WOODBOX,NULL}';
comment on column bcfishpass.crossings.modelled_crossing_type_source IS 'List of sources that indicate if a modelled crossing is open bottom, Acceptable values are: FWA_EDGE_TYPE=double line river, FWA_STREAM_ORDER=stream order >=6, GBA_RAILWAY_STRUCTURE_LINES_SP=railway structure, "MANUAL FIX"=manually identified OBS, MOT_ROAD_STRUCTURE_SP=MoT structure, TRANSPORT_LINE_STRUCTURE_CODE=DRA structure}';
comment on column bcfishpass.crossings.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. Acceptable Values are: PASSABLE - Passable, POTENTIAL - Potential or partial barrier, BARRIER - Barrier, UNKNOWN - Other';
comment on column bcfishpass.crossings.pscis_road_name  IS 'PSCIS road name, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings.pscis_stream_name  IS 'PSCIS stream name, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings.pscis_assessment_comment  IS 'PSCIS assessment_comment, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings.pscis_assessment_date  IS 'PSCIS assessment_date, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings.pscis_final_score IS 'PSCIS final_score, taken from the PSCIS assessment data submission';
comment on column bcfishpass.crossings.transport_line_structured_name_1 IS 'DRA road name, taken from the nearest DRA road (within 30m)';
comment on column bcfishpass.crossings.transport_line_type_description IS 'DRA road type, taken from the nearest DRA road (within 30m)';
comment on column bcfishpass.crossings.transport_line_surface_description IS 'DRA road surface, taken from the nearest DRA road (within 30m)';
comment on column bcfishpass.crossings.ften_forest_file_id IS 'FTEN road forest_file_id value, taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings.ften_file_type_description IS 'FTEN road tenure type (Forest Service Road, Road Permit, etc), taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings.ften_client_number IS 'FTEN road client number, taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings.ften_client_name IS 'FTEN road client name, taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings.ften_life_cycle_status_code IS 'FTEN road life_cycle_status_code (active or retired, pending roads are not included), taken from the nearest FTEN road (within 30m)';
comment on column bcfishpass.crossings.rail_track_name IS 'Railway name, taken from nearest railway (within 25m)';
comment on column bcfishpass.crossings.rail_owner_name IS 'Railway owner name, taken from nearest railway (within 25m)';
comment on column bcfishpass.crossings.rail_operator_english_name IS 'Railway operator name, taken from nearest railway (within 25m)';;
comment on column bcfishpass.crossings.ogc_proponent IS 'OGC road tenure proponent (currently modelled crossings only, taken from OGC road that crosses the stream)';
comment on column bcfishpass.crossings.dam_name IS 'See CABD dams column: dam_name_en';
comment on column bcfishpass.crossings.dam_height IS 'See CABD dams column: dam_height';
comment on column bcfishpass.crossings.dam_owner IS 'See CABD dams column: owner';
comment on column bcfishpass.crossings.dam_use IS 'See CABD table dam_use_codes';
comment on column bcfishpass.crossings.dam_operating_status IS 'See CABD dams column dam_operating_status';

comment on column bcfishpass.crossings.utm_zone IS 'UTM ZONE is a segment of the Earths surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';
comment on column bcfishpass.crossings.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';
comment on column bcfishpass.crossings.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';
comment on column bcfishpass.crossings.dbm_mof_50k_grid IS 'WHSE_BASEMAPPING.DBM_MOF_50K_GRID map_tile_display_name, used for generating planning map pdfs';
comment on column bcfishpass.crossings.linear_feature_id IS 'From BC FWA, the unique identifier for a stream segment (flow network arc)';
comment on column bcfishpass.crossings.blue_line_key IS 'From BC FWA, uniquely identifies a single flow line such that a main channel and a secondary channel with the same watershed code would have different blue line keys (the Fraser River and all side channels have different blue line keys).';
comment on column bcfishpass.crossings.watershed_key IS 'From BC FWA, a key that identifies a stream system. There is a 1:1 match between a watershed key and watershed code. The watershed key will match the blue line key for the mainstem.';
comment on column bcfishpass.crossings.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';
comment on column bcfishpass.crossings.wscode_ltree IS 'A truncated version of the BC FWA fwa_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';
comment on column bcfishpass.crossings.localcode_ltree IS 'A truncated version of the BC FWA local_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';;
comment on column bcfishpass.crossings.watershed_group_code IS 'The watershed group code associated with the feature.';
comment on column bcfishpass.crossings.gnis_stream_name IS 'The BCGNIS (BC Geographical Names Information System) name associated with the FWA stream';
comment on column bcfishpass.crossings.stream_order IS 'Order of FWA stream at point';
comment on column bcfishpass.crossings.stream_magnitude IS 'Magnitude of FWA stream at point';
--comment on column bcfishpass.crossings.watershed_upstr_ha IS 'Total watershed area upstream of point (approximate, does not include area of the fundamental watershed in which the point lies)';
comment on column bcfishpass.crossings.observedspp_dnstr IS 'Fish species observed downstream of point *within the same watershed group*';
comment on column bcfishpass.crossings.observedspp_upstr IS 'Fish species observed upstream of point *within the same watershed group*';
comment on column bcfishpass.crossings.geom IS 'The point geometry associated with the feature';

-- index for speed
create index crossings_dam_id_idx on bcfishpass.crossings (dam_id);
create index crossings_stream_crossing_id_idx on bcfishpass.crossings (stream_crossing_id);
create index crossings_modelled_crossing_id_idx on bcfishpass.crossings (modelled_crossing_id);
create index crossings_linear_feature_id_idx on bcfishpass.crossings (linear_feature_id);
create index crossings_blk_idx on bcfishpass.crossings (blue_line_key);
create index crossings_wsk_idx on bcfishpass.crossings (watershed_key);
create index crossings_wsgcode_idx on bcfishpass.crossings (watershed_group_code);
create index crossings_wscode_gidx on bcfishpass.crossings using gist (wscode_ltree);
create index crossings_wscode_bidx on bcfishpass.crossings using btree (wscode_ltree);
create index crossings_localcode_gidx on bcfishpass.crossings using gist (localcode_ltree);
create index crossings_localcode_bidx on bcfishpass.crossings using btree (localcode_ltree);
create index crossings_geom_idx on bcfishpass.crossings using gist (geom);