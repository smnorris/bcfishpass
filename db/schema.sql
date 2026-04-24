--
-- PostgreSQL database dump
--


-- Dumped from database version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)
-- Dumped by pg_dump version 17.7 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: gba_local_reg_greenspaces_sp; Type: TABLE; Schema: whse_basemapping; Owner: -
--

CREATE TABLE whse_basemapping.gba_local_reg_greenspaces_sp (
    local_reg_greenspace_id integer NOT NULL,
    park_name character varying(200),
    park_type character varying(50),
    park_primary_use character varying(50),
    regional_district character varying(100),
    municipality character varying(100),
    civic_number numeric,
    civic_number_suffix character varying(5),
    street_name character varying(100),
    latitude numeric,
    longitude numeric,
    when_updated date,
    website_url character varying(254),
    licence_comments character varying(500),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE gba_local_reg_greenspaces_sp; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON TABLE whse_basemapping.gba_local_reg_greenspaces_sp IS 'This dataset contains spatial and attribute information for local and regional greenspaces in British Columbia. Local and regional greenspaces are municipal or regional district lands designated by local government agencies and managed for public enjoyment, ecosystem or wildlife values. Spatial boundaries were sourced from various Open Data Sources. Boundaries of parks defined by cadastral parcels were edge-matched to ParcelMap BC.  This spatial layer contains multipart polygons.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.local_reg_greenspace_id; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.local_reg_greenspace_id IS 'LOCAL_REG_GREENSPACE_ID is a system-generated unique identification number.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.park_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.park_name IS 'PARK NAME is the name of the park, e.g., Allenby Park.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.park_type; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.park_type IS 'PARK_TYPE is the type of park, e.g., Local, Regional, Regional Reserve, Private.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.park_primary_use; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.park_primary_use IS 'PARK PRIMARY USE defines the primary use of a park, whether it is a general use park or there is a specific primary use, e.g., School, Pedestrian Walkway, Golf, Civic Plaza. The default value of Park is used for general use parks and where no specific primary use has been identified.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.regional_district; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.regional_district IS 'REGIONAL_DISTRICT is the name of the regional district in which the park resides, e.g., Capital Regional District.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.municipality; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.municipality IS 'MUNICIPALITY is the name of the municipality in which the park resides, or in which the majority of the park resides, e.g., Kamloops.  If the value is null, the park is not within municipal boundaries.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.civic_number; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.civic_number IS 'CIVIC_NUMBER is the street number or nearest estimate of a street number for the park.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.civic_number_suffix; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.civic_number_suffix IS 'CIVIC_NUMBER_SUFFIX is the letter or fraction that may come after the CIVIC NUMBER, e.g., A, 1/2.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.street_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.street_name IS 'STREET_NAME is the name of the street or nearest street to the park, e.g., Burnside Rd W.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.latitude; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.latitude IS 'LATITUDE is the geographic coordinate, in decimal degrees (dd.dddddd), of the location of the feature as measured from the equator, e.g., 55.323653.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.longitude; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.longitude IS 'LONGITUDE is the geographic coordinate, in decimal degrees (dd.dddddd), of the location of the feature as measured from the prime meridian, e.g., -123.093544.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.when_updated; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.when_updated IS 'WHEN_UPDATED is the date and time the record was last modified.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.website_url; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.website_url IS 'WEBSITE_URL contains a link to the home page of the park or the parks department, where available.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.licence_comments; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.licence_comments IS 'LICENCE_COMMENTS describes the source of the data where open data restrictions specify that attribution statements must be used, e.g., Contains information licensed under the Open Government Licence - City of Surrey.';


--
-- Name: COLUMN gba_local_reg_greenspaces_sp.objectid; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_local_reg_greenspaces_sp.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: dbm_mof_50k_grid; Type: TABLE; Schema: whse_basemapping; Owner: -
--

CREATE TABLE whse_basemapping.dbm_mof_50k_grid (
    map_tile character varying(32) NOT NULL,
    map_tile_display_name character varying(32),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: COLUMN dbm_mof_50k_grid.map_tile; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.dbm_mof_50k_grid.map_tile IS 'BCGS 1:50 000 Map number';


--
-- Name: COLUMN dbm_mof_50k_grid.map_tile_display_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.dbm_mof_50k_grid.map_tile_display_name IS 'BCGS 1:50 000 Map number - conforms to BCGS Specifications Document';


--
-- Name: COLUMN dbm_mof_50k_grid.feature_code; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.dbm_mof_50k_grid.feature_code IS 'The MOEP standard  numeric code to identify the type of feature represented by the spatial data.';


--
-- Name: COLUMN dbm_mof_50k_grid.objectid; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.dbm_mof_50k_grid.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase. ';


--
-- Name: gba_railway_tracks_sp; Type: TABLE; Schema: whse_basemapping; Owner: -
--

CREATE TABLE whse_basemapping.gba_railway_tracks_sp (
    railway_track_id integer NOT NULL,
    nid character varying(32),
    track_segment_id character varying(32),
    track_name character varying(100),
    track_classification character varying(20),
    regulator character varying(10),
    transport_type character varying(10),
    use_type character varying(30),
    gauge character varying(15),
    number_of_tracks numeric,
    electrification character varying(10),
    status character varying(20),
    design_speed_freight numeric,
    design_speed_passenger numeric,
    source_id character varying(50),
    operator_english_name character varying(100),
    operator_subdiv_portion_start numeric,
    operator_subdiv_portion_end numeric,
    owner_name character varying(100),
    track_user1_english_name character varying(100),
    track_user2_english_name character varying(100),
    track_user3_english_name character varying(100),
    track_user4_english_name character varying(100),
    subdivision1_nid character varying(32),
    subdivision1_name character varying(100),
    subdivision1_start numeric,
    subdivision1_end numeric,
    subdivision2_nid character varying(32),
    subdivision2_name character varying(100),
    subdivision2_start numeric,
    subdivision2_end numeric,
    administrative_area character varying(50),
    standards_version character varying(10),
    security_classification character varying(15),
    geometry_creation_date date,
    geometry_revision_date date,
    geometry_acquisition_technque character varying(30),
    geometry_planimetric_accuracy numeric,
    geometry_provider character varying(25),
    attribute_creation_date date,
    attribute_revision_date date,
    attribute_acquisition_technque character varying(30),
    attribute_provider character varying(30),
    objectid numeric,
    geom public.geometry(MultiLineString,3005)
);


--
-- Name: TABLE gba_railway_tracks_sp; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON TABLE whse_basemapping.gba_railway_tracks_sp IS 'GBA RAILWAY TRACKS SP contains railway tracks within BC from the National Railway Network (NRWN) dataset. In the real world, a Track provides a guide for the movement of trains and other equipment. In general, one linear feature represents the two rails of a Track. A Track is bounded by two Junction points and is segmented at each change in attributes along its course. All attributes relating to distance are expressed in miles and attributes relating to speed are expressed in miles per hour.';


--
-- Name: COLUMN gba_railway_tracks_sp.railway_track_id; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.railway_track_id IS 'RAILWAY TRACK ID: An operationally generated unique identification number, e.g., 100';


--
-- Name: COLUMN gba_railway_tracks_sp.nid; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.nid IS 'NID: National identifier for the feature. This is a UUID (Universal Unique Identifier) represented by a 32-character hexadecimal string. e.g., b5654a8c9dd64509b7c33dec919d6615. It is not a unique identifier for Railway Tracks; multiple records may share the same NID.';


--
-- Name: COLUMN gba_railway_tracks_sp.track_segment_id; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.track_segment_id IS 'TRACK SEGMENT ID: Identifier assigned to the portion of a Track Segment with uniform characteristics. This is a UUID (Universal Unique Identifier) represented by a 32-character hexadecimal string.  e.g., b5654a8c9dd64509b7c33dec919d6614';


--
-- Name: COLUMN gba_railway_tracks_sp.track_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.track_name IS 'TRACK NAME: Name associated to the Track by a national or sub national agency. e.g., Seymour Industrial';


--
-- Name: COLUMN gba_railway_tracks_sp.track_classification; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.track_classification IS 'TRACK CLASSIFICATION: Functional classification based on the importance of the role that the Track performs in the connectivity of the rail network. e.g., Main';


--
-- Name: COLUMN gba_railway_tracks_sp.regulator; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.regulator IS 'REGULATOR: Level of the authority that issued the certificate of fitness to the Track Operator. e.g., Federal';


--
-- Name: COLUMN gba_railway_tracks_sp.transport_type; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.transport_type IS 'TRANSPORTTYPE: Type of railway transport used on the Track. e.g., Train';


--
-- Name: COLUMN gba_railway_tracks_sp.use_type; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.use_type IS 'USE TYPE: Identification of what is transported on the Track. e.g., Freight';


--
-- Name: COLUMN gba_railway_tracks_sp.gauge; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.gauge IS 'GAUGE: Nominal distance between the two outer rails (gauge) of a railway track. e.g., Standard';


--
-- Name: COLUMN gba_railway_tracks_sp.number_of_tracks; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.number_of_tracks IS 'NUMBER OF TRACKS: Number of Tracks represented by the Track geometry. e.g., 1';


--
-- Name: COLUMN gba_railway_tracks_sp.electrification; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.electrification IS 'ELECTRIFICATION: Indication whether the railway is provided with an electric system to power vehicles moving along it. e.g., Absence';


--
-- Name: COLUMN gba_railway_tracks_sp.status; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.status IS 'STATUS: Status of the Track feature. e.g., Operational';


--
-- Name: COLUMN gba_railway_tracks_sp.design_speed_freight; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.design_speed_freight IS 'DESIGN SPEED FREIGHT: Maximum speeds, in miles per hour, for which a Track is designed for Freight trains. e.g., 50';


--
-- Name: COLUMN gba_railway_tracks_sp.design_speed_passenger; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.design_speed_passenger IS 'DESIGN SPEED PASSENGER: Maximum speeds, in miles per hour, for which a Track is designed for Passenger trains. e.g., 60';


--
-- Name: COLUMN gba_railway_tracks_sp.source_id; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.source_id IS 'SOURCE ID: Unique identifier assigned to the Track and used internally by a national or sub national agency. e.g., Unknown';


--
-- Name: COLUMN gba_railway_tracks_sp.operator_english_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.operator_english_name IS 'OPERATOR ENGLISH NAME: Information relative to the rail company that operates the track. e.g., Canadian Pacific';


--
-- Name: COLUMN gba_railway_tracks_sp.operator_subdiv_portion_start; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.operator_subdiv_portion_start IS 'OPERATOR SUBDIV PORTION START: Location where the Subdivision or portion of a Subdivision starts (expressed as a distance in miles). e.g., 14.3';


--
-- Name: COLUMN gba_railway_tracks_sp.operator_subdiv_portion_end; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.operator_subdiv_portion_end IS 'OPERATOR SUBDIV PORTION END: Location where the Subdivision or portion of a Subdivision ends (expressed as a distance in miles). e.g., 178.4';


--
-- Name: COLUMN gba_railway_tracks_sp.owner_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.owner_name IS 'OWNER NAME: Name of the company that owns the track system. e.g., Canadian National';


--
-- Name: COLUMN gba_railway_tracks_sp.track_user1_english_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.track_user1_english_name IS 'TRACK USER1 ENGLISH NAME: Name of a company that uses railway equipment and/or facilities. e.g., VIA Rail';


--
-- Name: COLUMN gba_railway_tracks_sp.track_user2_english_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.track_user2_english_name IS 'TRACK USER2 ENGLISH NAME: Name of a company that uses railway equipment and/or facilities. e.g., Rocky Mountaineer Railtours';


--
-- Name: COLUMN gba_railway_tracks_sp.track_user3_english_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.track_user3_english_name IS 'TRACK USER3 ENGLISH NAME: Name of a company that uses railway equipment and/or facilities. e.g., Rocky Mountaineer Railtours';


--
-- Name: COLUMN gba_railway_tracks_sp.track_user4_english_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.track_user4_english_name IS 'TRACK USER4 ENGLISH NAME: Name of a company that uses railway equipment and/or facilities. e.g., Rocky Mountaineer Railtours';


--
-- Name: COLUMN gba_railway_tracks_sp.subdivision1_nid; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.subdivision1_nid IS 'SUBDIVISION1 NID: National Identifier of the first Railway Subdivision where the Structure is located.  This is a UUID (Universal Unique Identifier) represented by a 32-character hexadecimal string. e.g., b5654a8c9dd64509b7c33dec919d6613';


--
-- Name: COLUMN gba_railway_tracks_sp.subdivision1_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.subdivision1_name IS 'SUBDIVISION1 NAME: Name of the first Railway Subdivision where the Structure is located. e.g., Albreda';


--
-- Name: COLUMN gba_railway_tracks_sp.subdivision1_start; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.subdivision1_start IS 'SUBDIVISION1 START: Location where the first Railway Subdivision or portion of the first Railway Subdivision starts (expressed as a distance in miles). e.g., 45.7';


--
-- Name: COLUMN gba_railway_tracks_sp.subdivision1_end; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.subdivision1_end IS 'SUBDIVISION1 END: Location where the first Railway Subdivision or portion of the first Railway Subdivision ends (expressed as a distance in miles). e.g., 108.4';


--
-- Name: COLUMN gba_railway_tracks_sp.subdivision2_nid; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.subdivision2_nid IS 'SUBDIVISION2 NID: Unique identification number of the second Railway Subdivision where the Track is located. This is a UUID (Universal Unique Identifier) represented by a 32-character hexadecimal string. e.g., 22be2673d73b4bc2ae7ebe921b6b8e9c';


--
-- Name: COLUMN gba_railway_tracks_sp.subdivision2_name; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.subdivision2_name IS 'SUBDIVISION2 NAME: Name of the second Railway Subdivision where the Track is located. e.g., Yale';


--
-- Name: COLUMN gba_railway_tracks_sp.subdivision2_start; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.subdivision2_start IS 'SUBDIVISION2 START: Location where the second Railway Subdivision or portion of the second Railway Subdivision starts (expressed as a distance in miles). e.g., 85.5';


--
-- Name: COLUMN gba_railway_tracks_sp.subdivision2_end; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.subdivision2_end IS 'SUBDIVISION2 END: Location where the second Railway Subdivision or portion of the second Railway Subdivision ends (expressed as a distance in miles). e.g., 463.2';


--
-- Name: COLUMN gba_railway_tracks_sp.administrative_area; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.administrative_area IS 'ADMINISTRATIVE AREA: State, province, or territory covered by the dataset. e.g., British Columbia';


--
-- Name: COLUMN gba_railway_tracks_sp.standards_version; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.standards_version IS 'STANDARDS VERSION: Version number of the standards for the features. e.g., 1.0';


--
-- Name: COLUMN gba_railway_tracks_sp.security_classification; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.security_classification IS 'SECURITY CLASSIFICATION: Name of the handling restrictions of the dataset. e.g., Unclassified';


--
-- Name: COLUMN gba_railway_tracks_sp.geometry_creation_date; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.geometry_creation_date IS 'GEOMETRY CREATION DATE: Date identifies when the resource (feature) was brought into existence';


--
-- Name: COLUMN gba_railway_tracks_sp.geometry_revision_date; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.geometry_revision_date IS 'GEOMETRY REVISION DATE: Date identifies when the resource (feature) was examined or re-examined and improved or amended';


--
-- Name: COLUMN gba_railway_tracks_sp.geometry_acquisition_technque; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.geometry_acquisition_technque IS 'GEOMETRY ACQUISITION TECHNQUE: Type of data source or technique used to populate (create or revise) the object. e.g., Orthoimage';


--
-- Name: COLUMN gba_railway_tracks_sp.geometry_planimetric_accuracy; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.geometry_planimetric_accuracy IS 'GEOMETRY PLANIMETRIC ACCURACY: Planimetric accuracy of the object expressed in meters as a circular map accuracy standard (CMAS) e.g., 10';


--
-- Name: COLUMN gba_railway_tracks_sp.geometry_provider; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.geometry_provider IS 'GEOMETRY PROVIDER: Affiliation of the organization that generated (created or revised) the object. e.g., Provincial/Territorial';


--
-- Name: COLUMN gba_railway_tracks_sp.attribute_creation_date; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.attribute_creation_date IS 'ATTRIBUTE CREATION DATE: Date identifies when the resource (feature attributes) was brought into existence';


--
-- Name: COLUMN gba_railway_tracks_sp.attribute_revision_date; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.attribute_revision_date IS 'ATTRIBUTE REVISION DATE: Date identifies when the resource (feature attributes) was examined or re-examined and improved or amended';


--
-- Name: COLUMN gba_railway_tracks_sp.attribute_acquisition_technque; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.attribute_acquisition_technque IS 'ATTRIBUTE ACQUISITION TECHNQUE: Type of data source or technique used to populate (create or revise) the object. e.g., Vector Data';


--
-- Name: COLUMN gba_railway_tracks_sp.attribute_provider; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.attribute_provider IS 'ATTRIBUTE PROVIDER: Affiliation of the organization that generated (created or revised) the object. e.g., Federal';


--
-- Name: COLUMN gba_railway_tracks_sp.objectid; Type: COMMENT; Schema: whse_basemapping; Owner: -
--

COMMENT ON COLUMN whse_basemapping.gba_railway_tracks_sp.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: transport_line; Type: TABLE; Schema: whse_basemapping; Owner: -
--

CREATE TABLE whse_basemapping.transport_line (
    transport_line_id integer NOT NULL,
    custodian_partner_org character varying(110),
    data_capture_method_code character varying(30) NOT NULL,
    capture_date timestamp with time zone,
    transport_line_type_code character varying(3) NOT NULL,
    transport_line_surface_code character varying(1) NOT NULL,
    transport_line_structure_code character varying(1),
    total_number_of_lanes smallint NOT NULL,
    structured_name_1 character varying(100),
    structured_name_2 character varying(100),
    structured_name_3 character varying(100),
    structured_name_4 character varying(100),
    structured_name_5 character varying(100),
    highway_route_1 character varying(5),
    highway_exit_number character varying(5),
    geom public.geometry(MultiLineStringZ,3005)
);


--
-- Name: transport_line_type_code; Type: TABLE; Schema: whse_basemapping; Owner: -
--

CREATE TABLE whse_basemapping.transport_line_type_code (
    transport_line_type_code character varying(3) NOT NULL,
    description character varying(30) NOT NULL,
    demographic_ind character varying(1) NOT NULL,
    create_integration_session_id integer NOT NULL,
    create_integration_date timestamp with time zone,
    modify_integration_session_id integer NOT NULL,
    modify_integration_date timestamp with time zone,
    road_class character varying(12) NOT NULL
);


--
-- Name: gba_local_reg_greenspaces_sp_local_reg_greenspace_id_seq; Type: SEQUENCE; Schema: whse_basemapping; Owner: -
--

CREATE SEQUENCE whse_basemapping.gba_local_reg_greenspaces_sp_local_reg_greenspace_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gba_local_reg_greenspaces_sp_local_reg_greenspace_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_basemapping; Owner: -
--

ALTER SEQUENCE whse_basemapping.gba_local_reg_greenspaces_sp_local_reg_greenspace_id_seq OWNED BY whse_basemapping.gba_local_reg_greenspaces_sp.local_reg_greenspace_id;


--
-- Name: gba_railway_tracks_sp_railway_track_id_seq; Type: SEQUENCE; Schema: whse_basemapping; Owner: -
--

CREATE SEQUENCE whse_basemapping.gba_railway_tracks_sp_railway_track_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gba_railway_tracks_sp_railway_track_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_basemapping; Owner: -
--

ALTER SEQUENCE whse_basemapping.gba_railway_tracks_sp_railway_track_id_seq OWNED BY whse_basemapping.gba_railway_tracks_sp.railway_track_id;


--
-- Name: transport_line_divided_code; Type: TABLE; Schema: whse_basemapping; Owner: -
--

CREATE TABLE whse_basemapping.transport_line_divided_code (
    transport_line_divided_code character varying(1) NOT NULL,
    description character varying(20) NOT NULL,
    create_integration_session_id integer NOT NULL,
    create_integration_date timestamp with time zone,
    modify_integration_session_id integer NOT NULL,
    modify_integration_date timestamp with time zone
);


--
-- Name: transport_line_structure_code; Type: TABLE; Schema: whse_basemapping; Owner: -
--

CREATE TABLE whse_basemapping.transport_line_structure_code (
    transport_line_structure_code character varying(1) NOT NULL,
    description character varying(20) NOT NULL,
    create_integration_session_id integer NOT NULL,
    create_integration_date timestamp with time zone,
    modify_integration_session_id integer NOT NULL,
    modify_integration_date timestamp with time zone
);


--
-- Name: transport_line_surface_code; Type: TABLE; Schema: whse_basemapping; Owner: -
--

CREATE TABLE whse_basemapping.transport_line_surface_code (
    transport_line_surface_code character varying(1) NOT NULL,
    description character varying(20) NOT NULL,
    create_integration_session_id integer NOT NULL,
    create_integration_date timestamp with time zone,
    modify_integration_session_id integer NOT NULL,
    modify_integration_date timestamp with time zone
);


--
-- Name: transport_line_transport_line_id_seq; Type: SEQUENCE; Schema: whse_basemapping; Owner: -
--

CREATE SEQUENCE whse_basemapping.transport_line_transport_line_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transport_line_transport_line_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_basemapping; Owner: -
--

ALTER SEQUENCE whse_basemapping.transport_line_transport_line_id_seq OWNED BY whse_basemapping.transport_line.transport_line_id;


--
-- Name: gba_local_reg_greenspaces_sp local_reg_greenspace_id; Type: DEFAULT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.gba_local_reg_greenspaces_sp ALTER COLUMN local_reg_greenspace_id SET DEFAULT nextval('whse_basemapping.gba_local_reg_greenspaces_sp_local_reg_greenspace_id_seq'::regclass);


--
-- Name: gba_railway_tracks_sp railway_track_id; Type: DEFAULT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.gba_railway_tracks_sp ALTER COLUMN railway_track_id SET DEFAULT nextval('whse_basemapping.gba_railway_tracks_sp_railway_track_id_seq'::regclass);


--
-- Name: transport_line transport_line_id; Type: DEFAULT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.transport_line ALTER COLUMN transport_line_id SET DEFAULT nextval('whse_basemapping.transport_line_transport_line_id_seq'::regclass);


--
-- Name: dbm_mof_50k_grid dbm_mof_50k_grid_pkey; Type: CONSTRAINT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.dbm_mof_50k_grid
    ADD CONSTRAINT dbm_mof_50k_grid_pkey PRIMARY KEY (map_tile);


--
-- Name: gba_local_reg_greenspaces_sp gba_local_reg_greenspaces_sp_pkey; Type: CONSTRAINT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.gba_local_reg_greenspaces_sp
    ADD CONSTRAINT gba_local_reg_greenspaces_sp_pkey PRIMARY KEY (local_reg_greenspace_id);


--
-- Name: gba_railway_tracks_sp gba_railway_tracks_sp_pkey; Type: CONSTRAINT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.gba_railway_tracks_sp
    ADD CONSTRAINT gba_railway_tracks_sp_pkey PRIMARY KEY (railway_track_id);


--
-- Name: transport_line_divided_code transport_line_divided_code_pkey; Type: CONSTRAINT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.transport_line_divided_code
    ADD CONSTRAINT transport_line_divided_code_pkey PRIMARY KEY (transport_line_divided_code);


--
-- Name: transport_line transport_line_pkey; Type: CONSTRAINT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.transport_line
    ADD CONSTRAINT transport_line_pkey PRIMARY KEY (transport_line_id);


--
-- Name: transport_line_structure_code transport_line_structure_code_pkey; Type: CONSTRAINT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.transport_line_structure_code
    ADD CONSTRAINT transport_line_structure_code_pkey PRIMARY KEY (transport_line_structure_code);


--
-- Name: transport_line_surface_code transport_line_surface_code_pkey; Type: CONSTRAINT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.transport_line_surface_code
    ADD CONSTRAINT transport_line_surface_code_pkey PRIMARY KEY (transport_line_surface_code);


--
-- Name: transport_line_type_code transport_line_type_code_pkey; Type: CONSTRAINT; Schema: whse_basemapping; Owner: -
--

ALTER TABLE ONLY whse_basemapping.transport_line_type_code
    ADD CONSTRAINT transport_line_type_code_pkey PRIMARY KEY (transport_line_type_code);


--
-- Name: idx_dbm_mof_50k_grid_geom; Type: INDEX; Schema: whse_basemapping; Owner: -
--

CREATE INDEX idx_dbm_mof_50k_grid_geom ON whse_basemapping.dbm_mof_50k_grid USING gist (geom);


--
-- Name: idx_gba_local_reg_greenspaces_sp_geom; Type: INDEX; Schema: whse_basemapping; Owner: -
--

CREATE INDEX idx_gba_local_reg_greenspaces_sp_geom ON whse_basemapping.gba_local_reg_greenspaces_sp USING gist (geom);


--
-- Name: idx_gba_railway_tracks_sp_geom; Type: INDEX; Schema: whse_basemapping; Owner: -
--

CREATE INDEX idx_gba_railway_tracks_sp_geom ON whse_basemapping.gba_railway_tracks_sp USING gist (geom);


--
-- Name: transport_line_geom_geom_idx; Type: INDEX; Schema: whse_basemapping; Owner: -
--

CREATE INDEX transport_line_geom_geom_idx ON whse_basemapping.transport_line USING gist (geom);


--
-- PostgreSQL database dump complete
--


--
-- PostgreSQL database dump
--


-- Dumped from database version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)
-- Dumped by pg_dump version 17.7 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: whse_admin_boundaries; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA whse_admin_boundaries;


--
-- Name: whse_cadastre; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA whse_cadastre;


--
-- Name: whse_fish; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA whse_fish;


--
-- Name: whse_forest_tenure; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA whse_forest_tenure;


--
-- Name: whse_forest_vegetation; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA whse_forest_vegetation;


--
-- Name: whse_legal_admin_boundaries; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA whse_legal_admin_boundaries;


--
-- Name: whse_tantalis; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA whse_tantalis;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ften_range_poly_svw; Type: TABLE; Schema: whse_forest_tenure; Owner: -
--

CREATE TABLE whse_forest_tenure.ften_range_poly_svw (
    forest_file_id character varying(10),
    map_block_id character varying(10),
    map_label character varying(21),
    client_number character varying(8),
    client_location_code character varying(2),
    client_name character varying(91),
    file_type_code character varying(3),
    authorized_use numeric,
    total_annual_use numeric,
    feature_area numeric,
    feature_perimeter numeric,
    area_ha numeric,
    sum_tenure_active_area_ha numeric,
    file_status_code character varying(3),
    life_cycle_status_code character varying(10),
    retirement_date date,
    calendar_year numeric,
    admin_district_code character varying(6),
    admin_district_name character varying(100),
    feature_class_skey numeric,
    change_date_tenure date,
    change_date_geometry date,
    change_date_prov date,
    change_date_application date,
    change_date_client date,
    objectid integer NOT NULL,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE ften_range_poly_svw; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON TABLE whse_forest_tenure.ften_range_poly_svw IS 'The spatial representation for a range tenure, which is an area of Crown range over which a Range Act tenure applies.  A tenure holder may apply for a nonuse harvestable forage deduction against a tenure''s total authorized harvestable forage';


--
-- Name: COLUMN ften_range_poly_svw.forest_file_id; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.forest_file_id IS 'File identification assigned to Provincial Forest Use files. Usually the Licence, Tenure or Private Mark number.  For Range Tenures, this is the unique identifier for a Range Tenure, e.g., RAN123456.';


--
-- Name: COLUMN ften_range_poly_svw.map_block_id; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.map_block_id IS 'The identifier for blocks belonging to same tenure (FOREST_FILE_ID), e.g.,  A, B, C.  A block may be a multi-part polygon. For example if a road separates a tenure, each part has the same MAP_BLOCK_ID. Each tenure may have one or more map blocks.';


--
-- Name: COLUMN ften_range_poly_svw.map_label; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.map_label IS 'The default label to be used when displaying the feature on a map.  Consists of the FOREST_FILE_ID and MAP_BLOCK_ID, e.g., RAN075852 A.';


--
-- Name: COLUMN ften_range_poly_svw.client_number; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.client_number IS 'Sequentially assigned number to identify the primary client.';


--
-- Name: COLUMN ften_range_poly_svw.client_location_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.client_location_code IS 'A code to uniquely identify, for the primary client, the addresses of different divisions or locations at which the client operates. The location code is sequentially assigned starting with 00 for the client''s permanent address or the Joint Venture Partnership that makes up the range agreement.';


--
-- Name: COLUMN ften_range_poly_svw.client_name; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.client_name IS 'The name of the primary Ministry client - a company or individual. Entered as: the full corporate name if a Corporation; the full registered name if a Partnership; the legal name if an Individual.  There may be other clients attached to the agreement.';


--
-- Name: COLUMN ften_range_poly_svw.file_type_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.file_type_code IS 'The code to indicate the type of file, and often synonymous with a tenure or a project. For Range Tenures, this is the type of tenure that the RAN number refers to, i.e., E01 (Grazing Licence), E02 (Grazing Permit), E03 (Non-Replaceable Grazing Permit),  H01 (Haycutting Licence), H02 (Haycutting Permit), H03 (Non-Replaceable Haycutting Permit).';


--
-- Name: COLUMN ften_range_poly_svw.authorized_use; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.authorized_use IS 'The tenure licence maximum allowable annual use, measured in Animal Unit Months for Grazing (FILE_TYPE_CODE starting with E0), or tonnes for Hay Cutting (FILE_TYPE_CODE starting with H0). This does not reflecting any annual increases or decreases to the licence authorized use amount (see TOTAL_ANNUAL_USE field).  This is based on the CALENDAR_YEAR field (current year); if there are no AUMs attached to license for the year this field will be null.';


--
-- Name: COLUMN ften_range_poly_svw.total_annual_use; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.total_annual_use IS 'The tenure licence net maximum allowable annual use, measured in Animal Unit Months for Grazing (FILE_TYPE_CODE starting with E0), or tonnes for Hay Cutting (FILE_TYPE_CODE starting with H0).  The net amount reflects any annual increases or decreases to the licence authorized use amount (see AUTHORIZED_USE field).  This is based on the CALENDAR_YEAR field (current year); if there are no AUMs attached to license for the year this field will be null.';


--
-- Name: COLUMN ften_range_poly_svw.feature_area; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.feature_area IS 'Spatial feature area in square metres. This value is calculated.';


--
-- Name: COLUMN ften_range_poly_svw.feature_perimeter; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.feature_perimeter IS 'Spatial perimeter length in metres. This value is calculated.';


--
-- Name: COLUMN ften_range_poly_svw.area_ha; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.area_ha IS 'The system calculated polygon feature area, in hectares.  If the total tenure area (based on unique FOREST_FILE_ID) is required, use SUM_TENURE_ACTIVE_AREA_HA.';


--
-- Name: COLUMN ften_range_poly_svw.sum_tenure_active_area_ha; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.sum_tenure_active_area_ha IS 'The calculated sum of the active, approved blocks within the tenure for a unique FOREST_FILE_ID, in hectares.  If there is more than one block comprising a tenure, this is the sum of the individual area hectares (AREA_HA) for all active, approved blocks in the tenure.';


--
-- Name: COLUMN ften_range_poly_svw.file_status_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.file_status_code IS 'The current status of the range tenure, e.g., A (Active), AR (Archived), CA (Cancelled), I (Inactive), P (Pending), SU (Suspended).';


--
-- Name: COLUMN ften_range_poly_svw.life_cycle_status_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.life_cycle_status_code IS 'The life cycle status of the spatial feature, i.e.,  Pending, Active or Retired.';


--
-- Name: COLUMN ften_range_poly_svw.retirement_date; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.retirement_date IS 'The date and time the spatial feature was retired.';


--
-- Name: COLUMN ften_range_poly_svw.calendar_year; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.calendar_year IS 'The calendar year beginning January 1 and ending December 31. This is the year that information is entered into Forest Tenures Administration System. In iMapBC and other products, the attribute name appears as ''Year Info Entered''.';


--
-- Name: COLUMN ften_range_poly_svw.admin_district_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.admin_district_code IS 'The code of the administrative district associated with this range tenure, e.g., DCS.  This may be different than the geographic location of the tenure.';


--
-- Name: COLUMN ften_range_poly_svw.admin_district_name; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.admin_district_name IS 'The name of the administrative district associated with this range tenure, corresponding to the ADMIN_DISTRICT_CODE, e.g., Cascades Natural Resource District.  This may be different than the geographic location of the tenure.';


--
-- Name: COLUMN ften_range_poly_svw.feature_class_skey; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.feature_class_skey IS 'Unique identifier for a spatial feature class.';


--
-- Name: COLUMN ften_range_poly_svw.change_date_tenure; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.change_date_tenure IS 'The change date and time stamp for the prov_forest_use table.  That is, any change made to the permit specific data.';


--
-- Name: COLUMN ften_range_poly_svw.change_date_geometry; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.change_date_geometry IS 'The change date and time stamp for one of the two geometry tables depending on if the geometry is new or amended.';


--
-- Name: COLUMN ften_range_poly_svw.change_date_prov; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.change_date_prov IS 'The change date and time stamp for the range provision data for the permit.';


--
-- Name: COLUMN ften_range_poly_svw.change_date_application; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.change_date_application IS 'The change date and time stamp for the tenure_application (spatial submission) record.';


--
-- Name: COLUMN ften_range_poly_svw.change_date_client; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.change_date_client IS 'The change date and time stamp for the primary client (licensee) associated with the tenure.';


--
-- Name: COLUMN ften_range_poly_svw.objectid; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_range_poly_svw.objectid IS 'A column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: clab_national_parks; Type: TABLE; Schema: whse_admin_boundaries; Owner: -
--

CREATE TABLE whse_admin_boundaries.clab_national_parks (
    national_park_id integer NOT NULL,
    clab_id character varying(5),
    english_name character varying(100),
    french_name character varying(100),
    local_name character varying(100),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE clab_national_parks; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON TABLE whse_admin_boundaries.clab_national_parks IS 'This dataset provides the administrative boundaries of National Parks and National Park Reserves within the province of British Columbia. Administrative boundaries were compiled from Legal Surveys Division''s cadastral datasets and survey records archived in the Canada Lands Survey Records. Canada Lands Administrative Boundaries (CLAB) were adjusted to match British Columbia''s authoritative base mapping features. The Fresh Water Atlas (FWA) was used for streams, rivers, coastlines, and height of land. The Integrated Cadastral Fabric (ICF) was used for parcel boundaries. Tantalis Cadastre was used where ICF parcels were not available.';


--
-- Name: COLUMN clab_national_parks.national_park_id; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.clab_national_parks.national_park_id IS 'NATIONAL_PARK_ID is a system-generated unique identification number.';


--
-- Name: COLUMN clab_national_parks.clab_id; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.clab_national_parks.clab_id IS 'CLAB_ID is a 3 or 4 character abbreviated identifier for each park, e.g., PRIM for Pacific Rim National Park Reserve of Canada.';


--
-- Name: COLUMN clab_national_parks.english_name; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.clab_national_parks.english_name IS 'ENGLISH_NAME is the full, official name of the federal park or reserve in English, e.g., Kootenay National Park of Canada.';


--
-- Name: COLUMN clab_national_parks.french_name; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.clab_national_parks.french_name IS 'FRENCH_NAME is the full, official name of the federal park or reserve in French, e.g., Parc National du Canada Kootenay.';


--
-- Name: COLUMN clab_national_parks.local_name; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.clab_national_parks.local_name IS 'LOCAL_NAME is the name associated with specific areas within a federal park or reserve, e.g.,  Munroe Rock, Winter Cove, Red Islets.';


--
-- Name: COLUMN clab_national_parks.objectid; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.clab_national_parks.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase.';


--
-- Name: ta_conservancy_areas_svw; Type: TABLE; Schema: whse_tantalis; Owner: -
--

CREATE TABLE whse_tantalis.ta_conservancy_areas_svw (
    admin_area_sid integer NOT NULL,
    conservancy_area_name character varying(200),
    orcs_primary character varying(4),
    orcs_secondary character varying(2),
    establishment_date date,
    official_area_ha numeric,
    park_management_plan_url character varying(512),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE ta_conservancy_areas_svw; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON TABLE whse_tantalis.ta_conservancy_areas_svw IS 'TA_CONSERVANCY_AREAS_SVW contains the spatial representation (polygon) of the conservancy areas designated under the Park Act or by the Protected Areas of British Columbia Act, whose management and development is constrained by the Park Act. The view was created to provide a simplified view of this data from the administrative boundaries information in the Tantalis operational system.';


--
-- Name: COLUMN ta_conservancy_areas_svw.admin_area_sid; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_conservancy_areas_svw.admin_area_sid IS 'ADMIN_AREA_SID is a system-generated sequential identifier that uniquely represents the conservancy area amongst all administrative areas stored in the Tantalis system.';


--
-- Name: COLUMN ta_conservancy_areas_svw.conservancy_area_name; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_conservancy_areas_svw.conservancy_area_name IS 'CONSERVANCY_AREA _NAME is the commonly used reference in notices and correspondence for the areas designated under the Park Act or by the Protected Areas of British Columbia Act as conservancies. For example, BISHOP BAY-MONKEY BEACH CONSERVANCY refers to the extent in British Columbia British Columbia defined in the Protected Areas of British Columbia Act.';


--
-- Name: COLUMN ta_conservancy_areas_svw.orcs_primary; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_conservancy_areas_svw.orcs_primary IS 'ORCS - Operational Records Classification System means the government-widestandard for classification, filing, retrieval, vital records and freedom of information andprotection of privacy designations, and disposition scheduling of operational records.';


--
-- Name: COLUMN ta_conservancy_areas_svw.orcs_secondary; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_conservancy_areas_svw.orcs_secondary IS 'ORCS - Operational Records Classification System means the government-widestandard for classification, filing, retrieval, vital records and freedom of information andprotection of privacy designations, and disposition scheduling of operational records.';


--
-- Name: COLUMN ta_conservancy_areas_svw.establishment_date; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_conservancy_areas_svw.establishment_date IS 'Date the park, protected area or ecological reserve was established, e.g., June 29, 1999.';


--
-- Name: COLUMN ta_conservancy_areas_svw.official_area_ha; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_conservancy_areas_svw.official_area_ha IS 'Official area of the park, protected area or ecological reserve, in hectares.';


--
-- Name: COLUMN ta_conservancy_areas_svw.park_management_plan_url; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_conservancy_areas_svw.park_management_plan_url IS 'Website address for the park management plan, e.g., https://bcparks.ca/planning/mgmtplns/redfern-keily/redfern-keily-park-mp.pdf?v=1643304141070.';


--
-- Name: COLUMN ta_conservancy_areas_svw.feature_code; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_conservancy_areas_svw.feature_code IS 'FEATURE CODE is a standard alphanumeric code to identify the type of feature represented by the spatial data. A feature code is most importantly a means of linking a feature to its name and definition. For example, the code GB15300120 on a digital geographic feature links it to the name "Lake - Dry" with the definition "A lake bed from which all water has drained or evaporated." The feature code does NOT mark when it was digitized, what dataset it belongs to, how accurate it is, what it should look like when plotted, or who is responsible for updating it. It only says what it represents in the real world. It also doesn''t even matter how the lake is represented. If it is a very small lake, it may be stored as a point feature. If it is large enough to have a shape at the scale of data capture, it may be stored as an outline, or a closed polygon. The same feature code still links it to the same definition.';


--
-- Name: COLUMN ta_conservancy_areas_svw.objectid; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_conservancy_areas_svw.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase. ';


--
-- Name: ta_park_ecores_pa_svw; Type: TABLE; Schema: whse_tantalis; Owner: -
--

CREATE TABLE whse_tantalis.ta_park_ecores_pa_svw (
    admin_area_sid integer NOT NULL,
    protected_lands_name character varying(200),
    protected_lands_code character varying(8),
    protected_lands_designation character varying(50),
    park_class character varying(240),
    surveyor_general_plan_no character varying(4000),
    orcs_primary character varying(4),
    orcs_secondary character varying(2),
    establishment_date date,
    official_area_ha numeric,
    park_management_plan_url character varying(512),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: COLUMN ta_park_ecores_pa_svw.objectid; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_park_ecores_pa_svw.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase. ';


--
-- Name: veg_consolidated_cut_blocks_sp; Type: TABLE; Schema: whse_forest_vegetation; Owner: -
--

CREATE TABLE whse_forest_vegetation.veg_consolidated_cut_blocks_sp (
    vccb_sysid integer NOT NULL,
    opening_id numeric,
    harvest_start_date date,
    harvest_end_date date,
    harvest_start_year_calendar numeric,
    harvest_mid_year_calendar numeric,
    harvest_start_year_fiscal character varying(20),
    harvest_mid_year_fiscal character varying(20),
    percent_clearcut numeric,
    percent_partial_cut numeric,
    data_source character varying(255),
    data_source_date date,
    published_date date,
    area_ha numeric,
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.vccb_sysid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.vccb_sysid IS 'A system generated unique identification number.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.opening_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.opening_id IS 'A system generated value assigned by RESULTS to uniquely identify the opening. When DATA_SOURCE = Satellite Imagery - Change Detection, the field value is NULL. When DATA_SOURCE = VRI, the field value is NULL unless OPENING_ID is reported within the Veg Comp Poly, in which case it contains the reported OPENING_ID.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.harvest_start_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.harvest_start_date IS 'The estimated start date of the logging activity of an opening. For polygons where DATA_SOURCE = RESULTS, the field is populated using the activity treatment start date (e.g., ATU_START_DATE) of the earliest logging disturbance of an opening. For polygons where DATA_SOURCE = Satellite Imagery - Change Detection, the field value is estimated from dates of the satellite images used in  the change detection process.  For polygons where DATA_SOURCE = VRI, the  field is populated with the Veg Comp Poly Harvest_Year_Date field.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.harvest_end_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.harvest_end_date IS 'The estimated end date of logging activity of an opening. For polygons where DATA_SOURCE = RESULTS, the field is populated using the activity treatment completion date  (e.g., ATU_COMPLETION_DATE) of the last logging disturbance of an opening. For polygons where DATA_SOURCE = Satellite Imagery - Change Detection, the field value is estimated from dates of the satellite images used in  the change detection process.  For polygons where DATA_SOURCE = VRI, the  field is populated with the Veg Comp Poly Harvest_Year_Date field.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.harvest_start_year_calendar; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.harvest_start_year_calendar IS 'The calendar year of harvest start date of an opening. Derived from the HARVEST_START_DATE field.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.harvest_mid_year_calendar; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.harvest_mid_year_calendar IS 'The calendar year of the mid point between the harvest start date  and harvest end date of an opening. Derived from the HARVEST_START_DATE and HARVEST_END_DATE fields.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.harvest_start_year_fiscal; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.harvest_start_year_fiscal IS 'The fiscal year of harvest start date of an opening.  Derived from the HARVEST_START_DATE field.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.harvest_mid_year_fiscal; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.harvest_mid_year_fiscal IS 'The fiscal year of the mid point between the harvest start date  and harvest end date of an opening. Derived from the HARVEST_START_DATE and HARVEST_END_DATE fields.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.percent_clearcut; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.percent_clearcut IS 'The estimated percent of the polygon where clearcut was used as the silvicultural system. When DATA_SOURCE = RESULTS, it is calculated by dividing the treatment area of activities with CLEAR (clearcut) or CCRES (clearcut with reserves) silviculture system codes by the total treatment area of logging activities.  When DATA_SOURCE = VRI, it is assumed to be 100% unless OPENING_ID is present in the Veg Comp Poly, in which case the calculation method from RESULTS is used. When DATA_SOURCE = Satellite Imagery - Change Detection, the field value is assumed to be 100%.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.percent_partial_cut; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.percent_partial_cut IS 'The estimated percent of the opening where partial cut was used as the silvicultural system.  When DATA_SOURCE = RESULTS, it is calculated by dividing the treatment area of activities with PATCH (patch cut), SELEC (selection), RETEN (retention), SEEDT (seed tree), or SHELT (shelterwood) silviculture system codes by the total treatment area of logging activities. When DATA_SOURCE = VRI, it is assumed to be 0%, unless OPENING_ID is present in the Veg Comp Poly, in which case the calculation method from RESULTS is used. When DATA_SOURCE = Satellite Imagery - Change Detection, it is assumed to be 0%.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.data_source; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.data_source IS 'The data source of the polygon and corresponding attribute information. The possible data sources are VRI, RESULTS, and Satellite Imagery - Change Detection.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.data_source_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.data_source_date IS 'The date the data was retreived  from RESULTS when DATA_SOURCE = RESULTS.  When the DATA_SOURCE = VRI, it is the date the dataset was the projected to. When the DATA_SOURCE = Satellite Imagery - Change Detection, it is the date that satellite imagery was last processed on.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.published_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.published_date IS 'The date this dataset was published.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.area_ha; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.area_ha IS 'The system calculated polygon area in Hectares, calculated to 2 decimal places.';


--
-- Name: COLUMN veg_consolidated_cut_blocks_sp.objectid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_consolidated_cut_blocks_sp.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: fiss_fish_obsrvtn_pnt_sp; Type: TABLE; Schema: whse_fish; Owner: -
--

CREATE TABLE whse_fish.fiss_fish_obsrvtn_pnt_sp (
    fish_observation_point_id numeric,
    wbody_id numeric,
    species_code character varying(6),
    agency_id numeric,
    point_type_code character varying(20),
    observation_date date,
    agency_name character varying(60),
    source character varying(1000),
    source_ref character varying(4000),
    utm_zone numeric,
    utm_easting numeric,
    utm_northing numeric,
    activity_code character varying(100),
    activity character varying(300),
    life_stage_code character varying(100),
    life_stage character varying(300),
    species_name character varying(60),
    waterbody_identifier character varying(9),
    waterbody_type character varying(20),
    gazetted_name character varying(30),
    new_watershed_code character varying(56),
    trimmed_watershed_code character varying(56),
    acat_report_url character varying(254),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPoint,3005)
);


--
-- Name: TABLE fiss_fish_obsrvtn_pnt_sp; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON TABLE whse_fish.fiss_fish_obsrvtn_pnt_sp IS 'FISS FISH OBSRVTN PNT SP is an instantiated POINT layer of FISS_FISH_OBSERVATIONS_VW from the FISS operational system.  It is spatially-enabled using the UTM fields upon data load (FME).  It records direct observations of fish, or summaries of direct observations .';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.fish_observation_point_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.fish_observation_point_id IS 'FISH OBSERVATION POINT ID is a surrogate primary key';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.wbody_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.wbody_id IS 'WBODY ID is a foreign key to WDIC_WATERBODIES.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.species_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.species_code IS 'SPECIES CODE is a foreign key to SPECIES_CD.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.agency_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.agency_id IS 'AGENCY ID is a foreign key to AGENCIES.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.point_type_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.point_type_code IS 'POINT TYPE CODE indicates if the row represents a direct ''Observation'' or a ''Summary'' of directobservations.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.observation_date; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.observation_date IS 'OBSERVATION DATE is the date on which the observation occurred.  For Summary rows, this is the latest date on which the species was observed in the waterbody.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.agency_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.agency_name IS 'AGENCY NAME is the name of the agency that made the observation. This value is NULL for Summary rows.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.source; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.source IS 'SOURCE is the abbreviation, and if appropriate, the primary key, of the dataset(s) from which the data was obtained. For example: ''FDIS Database: fshclctn_id 66589''.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.source_ref; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.source_ref IS 'SOURCE REF is the concatenation of all biographical references for the source data.  This may include citations to reports that published the observations, or the name of a project under which the observations were made. Some example values for SOURCE REF are: ''A RECONNAISSANCE SURVEY OF CULTUS LAKE'', and ''Bonaparte Watershed Fish and Fish Habitat Inventory - 2000''.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.utm_zone; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.utm_zone IS 'UTM ZONE is the 2 digit numeric code identifying the UTM Zone in which the UTM EASTING and UTM NORTHING lie.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.utm_easting; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.utm_easting IS 'UTM EASTING is the UTM Easting value within the specified UTM ZONE for this observation point.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.utm_northing; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.utm_northing IS 'UTM NORTHING is the UTM Northing value within the specified UTM ZONE for this observation point.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.activity_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.activity_code IS 'ACTIVITY CODE contains the fish activity code from the source dataset, such as I for Incubating, or SPE for Spawning In Estuary.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.activity; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.activity IS 'ACTIVITY is a full textual description of the activity the fish was engaged in when it was observed, such as SPAWNING.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.life_stage_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.life_stage_code IS 'LIFE STAGE CODE is a short character code identiying the life stage of the fish species for this oberservation.  Each source dataset of observations uses its own set of LIFE STAGE CODES.  For example, in the FDIS dataset, U means Undetermined, NS means Not Specified, M means Mature, IM means Immature, and MT means Maturing.  Descriptions for each LIFE STAGE CODE are given in the LIFE STAGE attribute.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.life_stage; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.life_stage IS 'LIFE STAGE is the full textual description corresponding to the LIFE STAGE CODE';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.species_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.species_name IS 'SPECIES NAME is the common name of the fish SPECIES that was observed.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.waterbody_identifier; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.waterbody_identifier IS 'WATERBODY IDENTIFIER is a unique code identifying the waterbody in which the observation was made.  It is a 5-digit seqnce number followed by a 4-character watershed group code.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.waterbody_type; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.waterbody_type IS 'WATERBODY TYPE is a the type of waterbody in which the observation was made. For example, Stream or Lake.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.gazetted_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.gazetted_name IS 'GAZETTED NAME is the gazetted name of the waterbody in which the observation was made.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.new_watershed_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.new_watershed_code IS 'NEW WATERSHED CODE is a watershed code, formatted with dashes, as assigned in the Watershed Atlas.  For example: 900-569800-08600-00000-0000-0000-000-000-000-000-000-000.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.trimmed_watershed_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.trimmed_watershed_code IS 'TRIMMED WATERSHED CODE is the NEW WATERSHED CODE, but with trailing zeros removed.  For example, if the NEW WATERSHED CODE is 100-005200-43400-50000-0000-0000-000-000-000-000-000-000, then the TRIMMED WATERSHED CODE will be 100-005200-43400-50000.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.acat_report_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.acat_report_url IS 'ACAT REPORT URL is a URL to the ACAT REPORT which provides additional information about the FISS FISH OBSRVTN PNT SP.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.feature_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.feature_code IS 'FEATURE CODE contains a value based on the Canadian Council of Surveys and Mapping''s (CCSM) system for classification of geographic features.';


--
-- Name: COLUMN fiss_fish_obsrvtn_pnt_sp.objectid; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_fish_obsrvtn_pnt_sp.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: species_cd; Type: TABLE; Schema: whse_fish; Owner: -
--

CREATE TABLE whse_fish.species_cd (
    species_id integer NOT NULL,
    code text,
    name text,
    cdcgr_code text,
    cdclr_code text,
    scientific_name text,
    spctype_code text,
    spcgrp_code text
);


--
-- Name: adm_indian_reserves_bands_sp; Type: TABLE; Schema: whse_admin_boundaries; Owner: -
--

CREATE TABLE whse_admin_boundaries.adm_indian_reserves_bands_sp (
    clab_id character varying(5),
    english_name character varying(100),
    french_name character varying(100),
    absolute_accuracy character varying(7),
    band_number character varying(5),
    band_name character varying(80),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: COLUMN adm_indian_reserves_bands_sp.objectid; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.adm_indian_reserves_bands_sp.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase. ';


--
-- Name: adm_nr_districts_spg; Type: TABLE; Schema: whse_admin_boundaries; Owner: -
--

CREATE TABLE whse_admin_boundaries.adm_nr_districts_spg (
    district_name character varying(60),
    org_unit character varying(3),
    org_unit_name character varying(100),
    region_org_unit character varying(3),
    region_org_unit_name character varying(100),
    feature_code character varying(10),
    feature_name character varying(100),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE adm_nr_districts_spg; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON TABLE whse_admin_boundaries.adm_nr_districts_spg IS 'NR DISTRICT SP is the spatial representation for a Natural Resource (NR) District, that is an administrative area established by the Ministry, within NR Regions.These Ministry of Forests (MOF) boundaries have changed from the boundaries captured in FADM DISTRICT REGION object due to the change in administrative areas due to downsizing in 2001. The SDE entity types allowed in this layer are multi-part polygons.';


--
-- Name: COLUMN adm_nr_districts_spg.district_name; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.adm_nr_districts_spg.district_name IS 'DISTRICT NAME is the long name of the NR District, e.g., Selkirk District.';


--
-- Name: COLUMN adm_nr_districts_spg.org_unit; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.adm_nr_districts_spg.org_unit IS 'ORG UNIT is the organizational unit code obtained from the CORP ORG UNIT object, e.g., DSE.';


--
-- Name: COLUMN adm_nr_districts_spg.org_unit_name; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.adm_nr_districts_spg.org_unit_name IS 'ORG UNIT NAME is the name or title of a ministry office or section, e.g., Selkirk District.';


--
-- Name: COLUMN adm_nr_districts_spg.region_org_unit; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.adm_nr_districts_spg.region_org_unit IS 'REGION ORG UNIT is the organizational unit code obtained from the CORP ORG UNIT object, e.g., RKB. which indicates which ORG UNIT this district is within.';


--
-- Name: COLUMN adm_nr_districts_spg.region_org_unit_name; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.adm_nr_districts_spg.region_org_unit_name IS 'ORG UNIT NAME is the name or title of a Region, e.g., Kootenay Boundary Region.';


--
-- Name: COLUMN adm_nr_districts_spg.feature_code; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.adm_nr_districts_spg.feature_code IS 'FEATURE CODE contains an alphanumeric value based on the Canadian Council of Surveys and Mapping’s (CCSM) system for classification of geographic features.';


--
-- Name: COLUMN adm_nr_districts_spg.feature_name; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.adm_nr_districts_spg.feature_name IS 'FEATURE NAME is the The English name of the feature, e.g., Natural Resource District';


--
-- Name: COLUMN adm_nr_districts_spg.objectid; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.adm_nr_districts_spg.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE';


--
-- Name: pmbc_parcel_fabric_poly_svw; Type: TABLE; Schema: whse_cadastre; Owner: -
--

CREATE TABLE whse_cadastre.pmbc_parcel_fabric_poly_svw (
    parcel_fabric_poly_id integer NOT NULL,
    parcel_name character varying(50),
    plan_number character varying(128),
    pin numeric,
    pid_formatted character varying(4000),
    pid_number numeric,
    parcel_status character varying(20),
    parcel_class character varying(50),
    owner_type character varying(50),
    parcel_start_date date,
    municipality character varying(254),
    regional_district character varying(50),
    when_updated date,
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE pmbc_parcel_fabric_poly_svw; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON TABLE whse_cadastre.pmbc_parcel_fabric_poly_svw IS 'The ParcelMap BC (PMBC) parcel fabric contains all active titled parcels and surveyed provincial Crown land parcels in BC. For building strata parcels, there is a record, with PID value, for each parcel within the strata parcel; the geometry for those records is the geometry for the overall strata. This dataset is polygonal and contains just the OGL-BC-licensed parcel attributes.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.parcel_fabric_poly_id; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.parcel_fabric_poly_id IS 'PARCEL_FABRIC_POLY_ID is a system generated unique identification number.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.parcel_name; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.parcel_name IS 'PARCEL_NAME is the same as the PID, if there is one. If there is a PIN but no PID, then PARCEL_NAME is the PIN. If there is no PID nor PIN, then PARCEL_NAME is the parcel class value, e.g., COMMON OWNERSHIP, BUILDING STRATA, AIR SPACE, ROAD, PARK.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.plan_number; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.plan_number IS 'PLAN_NUMBER is the Land Act, Land Title Act, or Strata Property Act Plan Number for the land survey plan that corresponds to this parcel, e.g., VIP1632, NO_PLAN.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.pin; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.pin IS 'PIN is the Crown Land Registry Parcel Identifier, if applicable.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.pid_formatted; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.pid_formatted IS 'PID_FORMATTED is the Land Title Register parcel identifier, a left-zero-padded nine-digit number. with dashes between each group of three digits,  that uniquely identifies a parcel in the land title register of in British Columbia. The registrar assigns PID numbers to parcels for which a title is being entered as a registered title. The Land Title Act refers to the PID as the permanent parcel identifier.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.pid_number; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.pid_number IS 'PID_NUMBER is the PID, without leading zeroes.  PID is the Land Title Register parcel identifier, a nine-digit number that uniquely identifies a parcel in the land title register of in British Columbia. The registrar assigns PID numbers to parcels for which a title is being entered as a registered title. The Land Title Act refers to the PID as the permanent parcel identifier.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.parcel_status; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.parcel_status IS 'PARCEL_STATUS is the status of the parcel, according to the Land Title Register or Crown Land Registry, as appropriate, i.e., ACTIVE, CANCELLED, INACTIVE, PENDING.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.parcel_class; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.parcel_class IS 'PARCEL_CLASS is the Parcel classification for maintenance, mapping, publishing and analysis, i.e., PRIMARY, SUBDIVISION, PART OF PRIMARY, BUILDING STRATA, BARE LAND STRATA, AIR SPACE, ROAD, HIGHWAY, PARK, INTEREST, COMMON OWNERSHIP, ABSOLUTE FEE BOOK, CROWN SUBDIVISION, RETURN TO CROWN.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.owner_type; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.owner_type IS 'OWNER_TYPE is the general ownership category, e.g., PRIVATE, CROWN PROVINCIAL, MUNICIPAL.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.parcel_start_date; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.parcel_start_date IS 'PARCEL_START_DATE is the date of the legal event that created the parcel, i.e., the date the plan was filed.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.municipality; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.municipality IS 'MUNICIPALITY is the municipal area within which the parcel is located. The value is either RURAL (for parcels in unincorporated regions) or the name of a BC municipality.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.regional_district; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.regional_district IS 'REGIONAL_DISTRICT is the name of the regional district in which the parcel is located, e.g., CAPITAL REGIONAL DISTRICT.';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.when_updated; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.when_updated IS 'WHEN_UPDATED is the date and time the source record was last modified (not the time when it was loaded into, or modified in, the BC Geographic Warehouse).';


--
-- Name: COLUMN pmbc_parcel_fabric_poly_svw.objectid; Type: COMMENT; Schema: whse_cadastre; Owner: -
--

COMMENT ON COLUMN whse_cadastre.pmbc_parcel_fabric_poly_svw.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: abms_municipalities_sp; Type: TABLE; Schema: whse_legal_admin_boundaries; Owner: -
--

CREATE TABLE whse_legal_admin_boundaries.abms_municipalities_sp (
    lgl_admin_area_id integer NOT NULL,
    admin_area_name character varying(200),
    admin_area_abbreviation character varying(40),
    admin_area_boundary_type character varying(20),
    admin_area_group_name character varying(200),
    change_requested_org character varying(30),
    update_type character varying(50),
    when_updated date,
    map_status character varying(12),
    oic_mo_number character varying(7),
    oic_mo_year character varying(4),
    oic_mo_type character varying(20),
    website_url character varying(254),
    image_url character varying(254),
    affected_admin_area_abrvn character varying(120),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE abms_municipalities_sp; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON TABLE whse_legal_admin_boundaries.abms_municipalities_sp IS 'ABMS_MUNICIPALITIES_SP contains legally defined municipal administrative boundary areas in the Province of British Columbia. This spatial layer contains multipart features.';


--
-- Name: COLUMN abms_municipalities_sp.lgl_admin_area_id; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.lgl_admin_area_id IS 'An operationally-generated unique identification number, e.g., 1, 2,3.';


--
-- Name: COLUMN abms_municipalities_sp.admin_area_name; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.admin_area_name IS 'The authoritative, officially approved name given to the Administrative Area, e.g., Corporation of the Village of Tofino.';


--
-- Name: COLUMN abms_municipalities_sp.admin_area_abbreviation; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.admin_area_abbreviation IS 'A short form or commonly-known acronym for the Administrative Area name, e.g., Tofino (Corporation of the Village of Tofino).';


--
-- Name: COLUMN abms_municipalities_sp.admin_area_boundary_type; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.admin_area_boundary_type IS 'BOUNDARY TYPE is a high-level grouping of Administrative Areas used to categorise features when reporting, e.g., Census, Legal, Administrative.';


--
-- Name: COLUMN abms_municipalities_sp.admin_area_group_name; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.admin_area_group_name IS 'The name given to the larger administrative area (if there is any) of which this feature is a member, e.g., Regional District of Alberni Clayquot (This would be the ADMIN_AREA_GROUP_NAME of the feature called "The Corporation of the Village of Tofino").';


--
-- Name: COLUMN abms_municipalities_sp.change_requested_org; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.change_requested_org IS 'The government acronym of the Ministry or sub-org that last requested the change that resulted in the modification of the record, e.g., GeoBC, MMAH.';


--
-- Name: COLUMN abms_municipalities_sp.update_type; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.update_type IS 'A short description of the latest alteration of the feature''s geographic or attribute content, e.g., Inserted (added new), Change in geometry.';


--
-- Name: COLUMN abms_municipalities_sp.when_updated; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.when_updated IS 'The date and time the record was last modified.';


--
-- Name: COLUMN abms_municipalities_sp.map_status; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.map_status IS 'That the digital map has been appended to Letters Patent of the administrative area and has received cabinet or ministerial approval, i.e., "Appended": the digital map has been appended to Letters Patent of the municipality, electoral area, regional district or improvement district and has received cabinet or ministerial approval. The map is referred to as the legal map and forms Schedule 1 to Letters Patent. "Not Appended": the digital map exists but currently there is no legislative mechanism that enables the map to be appended to Letters Patent in the absence of a request for a boundary amendment. In other words, while the digital map is the exact representation of the administrative boundary, it is not considered legal until appended to Letters Patent. If there is a discrepancy in the boundary, the written metes and bounds prevail. Null values are permitted for Administrative Areas for which the map status does not apply.';


--
-- Name: COLUMN abms_municipalities_sp.oic_mo_number; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.oic_mo_number IS 'The most-recent Order-In-Council (OIC) or Ministerial Order (MO) identifier for a particular administrative area. This number is used in conjunction with the OIC_MO_YEAR and the OIC_MO_TYPE to determine the official OIC or MO Number, which is usually in the form ###/YY(YY), e.g., where OIC_MO_NUMBER is 245, the OIC_MO_YEAR is 2013 and the OIC_MO_TYPE is "OIC", the latest OIC for this administrative area is OIC 245/13 that was enacted into law in 2013. Similarily, where OIC_MO_NUMBER is 103 and the OIC_MO_YEAR is 2019 and the OIC_MO_TYPE is "MO", the latest Ministerial Order for this administrative area is MO 103/2019 enacted into law in 2019.';


--
-- Name: COLUMN abms_municipalities_sp.oic_mo_year; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.oic_mo_year IS 'The four-digit year that the most recent Order-In-Council or Ministerial Order was approved, e.g., 2014.';


--
-- Name: COLUMN abms_municipalities_sp.oic_mo_type; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.oic_mo_type IS 'The short acronym that determines the type of identifier used in the OIC_MO_NUMBER, e.g., OIC (Order-In-Council), MO (Ministerial Order), OTHER (The boundary was issued using a procedure outside of the traditional mechanisms).';


--
-- Name: COLUMN abms_municipalities_sp.website_url; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.website_url IS 'An Internet URL link to additional project information and/or files related to the OIC_MO_NUMBER.';


--
-- Name: COLUMN abms_municipalities_sp.image_url; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.image_url IS 'An Internet URL link to additional image files related to the OIC_MO_NUMBER.';


--
-- Name: COLUMN abms_municipalities_sp.affected_admin_area_abrvn; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.affected_admin_area_abrvn IS 'A semicolon-delimited list of the abbreviations (ADMIN_AREA_ABBREVIATION) of Administrative Area boundaries that are affected by the OIC number in the OIC year, e.g., NCRD-EA E / NCRD-EA H. If a record has the value "NCRD-EA E / NCRD-EA H" for AFFECTED_ADMIN_AREA_ABRVN, an ADMIN_AREA_ABBREVIATION of Prince Rupert, an OIC/MO (OIC_MO_NUMBER) value of 501/14, an OIC/MO Year (OIC_MO_YEAR) value of 2014, and an Administrative Area Group Name (ADMIN_AREA_GROUP_NAME) of North Coast Regional District, then the interpretation is that OIC 501 in the year 2014 for Prince Rupert also affects the boundaries of Electoral Areas NCRD-EA E and NCRD-EA H in the North Coast Regional District.';


--
-- Name: COLUMN abms_municipalities_sp.objectid; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_municipalities_sp.objectid IS 'A column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: abms_regional_districts_sp; Type: TABLE; Schema: whse_legal_admin_boundaries; Owner: -
--

CREATE TABLE whse_legal_admin_boundaries.abms_regional_districts_sp (
    lgl_admin_area_id numeric,
    admin_area_name character varying(200),
    admin_area_abbreviation character varying(40),
    admin_area_boundary_type character varying(20),
    admin_area_group_name character varying(200),
    change_requested_org character varying(30),
    update_type character varying(50),
    when_updated date,
    map_status character varying(12),
    oic_mo_number character varying(7),
    oic_mo_year character varying(4),
    oic_mo_type character varying(20),
    website_url character varying(254),
    image_url character varying(254),
    affected_admin_area_abrvn character varying(120),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE abms_regional_districts_sp; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON TABLE whse_legal_admin_boundaries.abms_regional_districts_sp IS 'ABMS_REGIONAL_DISTRICTS_SP contains legally defined regional disctrict administrative boundary areas in the Province of British Columbia. This spatial layer contains multipart features.';


--
-- Name: COLUMN abms_regional_districts_sp.lgl_admin_area_id; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.lgl_admin_area_id IS 'An operationally-generated unique identification number, e.g., 1, 2,3.';


--
-- Name: COLUMN abms_regional_districts_sp.admin_area_name; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.admin_area_name IS 'The authoritative, officially approved name given to the Administrative Area, e.g., Regional District of Alberni Clayquot.';


--
-- Name: COLUMN abms_regional_districts_sp.admin_area_abbreviation; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.admin_area_abbreviation IS 'A short form or commonly-known acronym for the Administrative Area name, e.g., RDAC (Regional District of Alberni Clayquot).';


--
-- Name: COLUMN abms_regional_districts_sp.admin_area_boundary_type; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.admin_area_boundary_type IS 'BOUNDARY TYPE is a high-level grouping of Administrative Areas used to categorise features when reporting, e.g., Census, Legal, Administrative.';


--
-- Name: COLUMN abms_regional_districts_sp.admin_area_group_name; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.admin_area_group_name IS 'The name given to the larger administrative area (if there is any) of which this feature is a member, e.g., Province of BC (This would be the ADMIN_AREA_GROUP_NAME of the feature called "Regional District of Alberni Clayquot").';


--
-- Name: COLUMN abms_regional_districts_sp.change_requested_org; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.change_requested_org IS 'The government acronym of the Ministry or sub-org that last requested the change that resulted in the modification of the record, e.g., GeoBC, MMAH.';


--
-- Name: COLUMN abms_regional_districts_sp.update_type; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.update_type IS 'A short description of the latest alteration of the feature''s geographic or attribute content, e.g., Inserted (added new), Change in geometry.';


--
-- Name: COLUMN abms_regional_districts_sp.when_updated; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.when_updated IS 'The date and time the record was last modified.';


--
-- Name: COLUMN abms_regional_districts_sp.map_status; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.map_status IS 'That the digital map has been appended to Letters Patent of the administrative area and has received cabinet or ministerial approval, i.e., "Appended": the digital map has been appended to Letters Patent of the municipality, electoral area, regional district or improvement district and has received cabinet or ministerial approval. The map is referred to as the legal map and forms Schedule 1 to Letters Patent. "Not Appended": the digital map exists but currently there is no legislative mechanism that enables the map to be appended to Letters Patent in the absence of a request for a boundary amendment. In other words, while the digital map is the exact representation of the administrative boundary, it is not considered legal until appended to Letters Patent. If there is a discrepancy in the boundary, the written metes and bounds prevail. Null values are permitted for Administrative Areas for which the map status does not apply.';


--
-- Name: COLUMN abms_regional_districts_sp.oic_mo_number; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.oic_mo_number IS 'The most-recent Order-In-Council (OIC) or Ministerial Order (MO) identifier for a particular administrative area. This number is used in conjunction with the OIC_MO_YEAR and the OIC_MO_TYPE to determine the official OIC or MO Number, which is usually in the form ###/YY(YY), e.g., where OIC_MO_NUMBER is 245, the OIC_MO_YEAR is 2013 and the OIC_MO_TYPE is "OIC", the latest OIC for this administrative area is OIC 245/13 that was enacted into law in 2013. Similarily, where OIC_MO_NUMBER is 103 and the OIC_MO_YEAR is 2019 and the OIC_MO_TYPE is "MO", the latest Ministerial Order for this administrative area is MO 103/2019 enacted into law in 2019.';


--
-- Name: COLUMN abms_regional_districts_sp.oic_mo_year; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.oic_mo_year IS 'The four-digit year that the most recent Order-In-Council or Ministerial Order was approved, e.g., 2014.';


--
-- Name: COLUMN abms_regional_districts_sp.oic_mo_type; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.oic_mo_type IS 'The short acronym that determines the type of identifier used in the OIC_MO_NUMBER, e.g., OIC (Order-In-Council), MO (Ministerial Order), OTHER (The boundary was issued using a procedure outside of the traditional mechanisms).';


--
-- Name: COLUMN abms_regional_districts_sp.website_url; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.website_url IS 'An Internet URL link to additional project information and/or files related to the OIC_MO_NUMBER.';


--
-- Name: COLUMN abms_regional_districts_sp.image_url; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.image_url IS 'An Internet URL link to additional image files related to the OIC_MO_NUMBER.';


--
-- Name: COLUMN abms_regional_districts_sp.affected_admin_area_abrvn; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.affected_admin_area_abrvn IS 'A semicolon-delimited list of the abbreviations (ADMIN_AREA_ABBREVIATION) of Administrative Area boundaries that are affected by the OIC number in the OIC year, e.g., NCRD-EA E / NCRD-EA H. If a record has the value "NCRD-EA E / NCRD-EA H" for AFFECTED_ADMIN_AREA_ABRVN, an ADMIN_AREA_ABBREVIATION of Prince Rupert, an OIC/MO (OIC_MO_NUMBER) value of 501/14, an OIC/MO Year (OIC_MO_YEAR) value of 2014, and an Administrative Area Group Name (ADMIN_AREA_GROUP_NAME) of North Coast Regional District, then the interpretation is that OIC 501 in the year 2014 for Prince Rupert also affects the boundaries of Electoral Areas NCRD-EA E and NCRD-EA H in the North Coast Regional District.';


--
-- Name: COLUMN abms_regional_districts_sp.objectid; Type: COMMENT; Schema: whse_legal_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_legal_admin_boundaries.abms_regional_districts_sp.objectid IS 'A column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: clab_indian_reserves; Type: TABLE; Schema: whse_admin_boundaries; Owner: -
--

CREATE TABLE whse_admin_boundaries.clab_indian_reserves (
    clab_id character varying(14) NOT NULL,
    absolute_accuracy character varying(7),
    english_name character varying(100),
    french_name character varying(100),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: COLUMN clab_indian_reserves.objectid; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.clab_indian_reserves.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase. ';


--
-- Name: clab_national_parks_national_park_id_seq; Type: SEQUENCE; Schema: whse_admin_boundaries; Owner: -
--

CREATE SEQUENCE whse_admin_boundaries.clab_national_parks_national_park_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clab_national_parks_national_park_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_admin_boundaries; Owner: -
--

ALTER SEQUENCE whse_admin_boundaries.clab_national_parks_national_park_id_seq OWNED BY whse_admin_boundaries.clab_national_parks.national_park_id;


--
-- Name: fadm_designated_areas; Type: TABLE; Schema: whse_admin_boundaries; Owner: -
--

CREATE TABLE whse_admin_boundaries.fadm_designated_areas (
    feature_id character varying(32) NOT NULL,
    designated_area_name character varying(100),
    designated_area_type character varying(10),
    oic_year character varying(4),
    oic_number character varying(14),
    bc_regulation_number character varying(10),
    effective_date date,
    expiry_date date,
    cancellation_date date,
    expired_or_cancelled character varying(1),
    description character varying(255),
    feature_code character varying(10),
    who_updated character varying(32),
    when_updated date,
    feature_class_skey numeric,
    object_version_skey numeric,
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE fadm_designated_areas; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON TABLE whse_admin_boundaries.fadm_designated_areas IS 'Defines areas protected from harvesting activities by Order-in-Council as per part 13 of the Forest Act.';


--
-- Name: COLUMN fadm_designated_areas.feature_id; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.feature_id IS 'FEATURE ID: Provincially unique identifier for an instance of a spatial feature.';


--
-- Name: COLUMN fadm_designated_areas.designated_area_name; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.designated_area_name IS 'DESIGNATED AREA NAME: this contains the name as it appears in the legislation that created the area.';


--
-- Name: COLUMN fadm_designated_areas.designated_area_type; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.designated_area_type IS 'DESIGNATED AREA TYPE: a number representing the type of designated area.';


--
-- Name: COLUMN fadm_designated_areas.oic_year; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.oic_year IS 'OIC YEAR: The year that the addition was approved via an order in council.';


--
-- Name: COLUMN fadm_designated_areas.oic_number; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.oic_number IS 'OIC NUMBER: A number assigned to the order in council.';


--
-- Name: COLUMN fadm_designated_areas.bc_regulation_number; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.bc_regulation_number IS 'BC REGULATION NUMBER: the number of the regulation from the relevant Act.';


--
-- Name: COLUMN fadm_designated_areas.effective_date; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.effective_date IS 'The date the area is made effective in the legislation.';


--
-- Name: COLUMN fadm_designated_areas.expiry_date; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.expiry_date IS 'The expiry date indicated when the area is first legislated for inclusion.';


--
-- Name: COLUMN fadm_designated_areas.cancellation_date; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.cancellation_date IS 'The date set by the Minister to cancel the area (i.e., removed from Part 13). It may occur earlier than the Expiry Date (supercedes Expiry Date).';


--
-- Name: COLUMN fadm_designated_areas.expired_or_cancelled; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.expired_or_cancelled IS 'A confirmation of whether the Part 13 legislation has expired or been cancelled.';


--
-- Name: COLUMN fadm_designated_areas.description; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.description IS 'Additional information about the Part 13 area.';


--
-- Name: COLUMN fadm_designated_areas.feature_code; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.feature_code IS 'An alphanumeric code used to identify a feature component. All CCSM feature codes are generated according to the Canadian Council on Survey and Mapping (CCSM) Draft Standard on feature code classification.';


--
-- Name: COLUMN fadm_designated_areas.who_updated; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.who_updated IS 'WHO UPDATED: the userid of the operator who updated the feature.';


--
-- Name: COLUMN fadm_designated_areas.when_updated; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.when_updated IS 'WHEN UPDATED: the date and time that the feature was updated.';


--
-- Name: COLUMN fadm_designated_areas.feature_class_skey; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.feature_class_skey IS 'A FEATURE CLASS SKEY is the unique key assigned to a Feature Class by the Ministry of Forests where a Feature Class is used to define a class of geographic items having the same basic set of characteristics. This is a spatial (class/entity) object or logical business grouping of spatial information much like a textual entity is a logical business grouping of attribute information. All features have a topology type of Polygon, Line or Point. Some examples of feature class are Bridge, Road, Activity Treatment Unit, and Lake. A "feature" differs from a "feature class" in that the feature is an instance of feature class. For example �Lake� or "Forest License Cut block" are feature classes. The features class "Lake� (and associated data) describes the standards to which all lakes are captured. Nitinat Lake is a feature within the Lake feature class and would be captured to the standards within that class (e.g. Lake is a polygon feature)."';


--
-- Name: COLUMN fadm_designated_areas.object_version_skey; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.object_version_skey IS 'An OBJECT VERSION SKEY is the unique identifer for the object instance.';


--
-- Name: COLUMN fadm_designated_areas.objectid; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_designated_areas.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase. ';


--
-- Name: fadm_tfl_all_sp; Type: TABLE; Schema: whse_admin_boundaries; Owner: -
--

CREATE TABLE whse_admin_boundaries.fadm_tfl_all_sp (
    tfl_all_sysid integer NOT NULL,
    forest_file_id character varying(10),
    tfl_type character varying(15),
    licencee character varying(60),
    feature_class_skey numeric,
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: COLUMN fadm_tfl_all_sp.tfl_all_sysid; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_tfl_all_sp.tfl_all_sysid IS 'TFL_ALL_SYSID is a system generated unique key.';


--
-- Name: COLUMN fadm_tfl_all_sp.forest_file_id; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_tfl_all_sp.forest_file_id IS 'FOREST_FILE_ID is the file identification assigned to Provincial Forest Use files.';


--
-- Name: COLUMN fadm_tfl_all_sp.tfl_type; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_tfl_all_sp.tfl_type IS 'TFL_TYPE indicates whether the TFL record is Schedule B, Schedule A, or Schedule A Timber Licence.';


--
-- Name: COLUMN fadm_tfl_all_sp.licencee; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_tfl_all_sp.licencee IS 'LICENCEE is the name of the ministry client - company or individual. entered as: the full corporate name if a corporation; the full registered name if a partnership; the legal surname if an individual.';


--
-- Name: COLUMN fadm_tfl_all_sp.feature_class_skey; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_tfl_all_sp.feature_class_skey IS 'FEATURE_CLASS_SKEY is the unique key assigned to a Feature Class by the Ministry of Forests where a Feature Class is used to define a class of geographic items having the same basic set of characteristics.';


--
-- Name: COLUMN fadm_tfl_all_sp.objectid; Type: COMMENT; Schema: whse_admin_boundaries; Owner: -
--

COMMENT ON COLUMN whse_admin_boundaries.fadm_tfl_all_sp.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase';


--
-- Name: fadm_tfl_all_sp_tfl_all_sysid_seq; Type: SEQUENCE; Schema: whse_admin_boundaries; Owner: -
--

CREATE SEQUENCE whse_admin_boundaries.fadm_tfl_all_sp_tfl_all_sysid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fadm_tfl_all_sp_tfl_all_sysid_seq; Type: SEQUENCE OWNED BY; Schema: whse_admin_boundaries; Owner: -
--

ALTER SEQUENCE whse_admin_boundaries.fadm_tfl_all_sp_tfl_all_sysid_seq OWNED BY whse_admin_boundaries.fadm_tfl_all_sp.tfl_all_sysid;


--
-- Name: pmbc_parcel_fabric_poly_svw_parcel_fabric_poly_id_seq; Type: SEQUENCE; Schema: whse_cadastre; Owner: -
--

CREATE SEQUENCE whse_cadastre.pmbc_parcel_fabric_poly_svw_parcel_fabric_poly_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pmbc_parcel_fabric_poly_svw_parcel_fabric_poly_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_cadastre; Owner: -
--

ALTER SEQUENCE whse_cadastre.pmbc_parcel_fabric_poly_svw_parcel_fabric_poly_id_seq OWNED BY whse_cadastre.pmbc_parcel_fabric_poly_svw.parcel_fabric_poly_id;


--
-- Name: fiss_obstacles_pnt_sp; Type: TABLE; Schema: whse_fish; Owner: -
--

CREATE TABLE whse_fish.fiss_obstacles_pnt_sp (
    fish_obstacle_point_id numeric,
    agency_id numeric,
    wbody_id numeric,
    obstacle_code character varying(6),
    obstacle_name character varying(60),
    agency_name character varying(60),
    source character varying(1000),
    source_ref character varying(4000),
    height numeric,
    length numeric,
    utm_zone numeric,
    utm_easting numeric,
    utm_northing numeric,
    survey_date date,
    waterbody_identifier character varying(9),
    waterbody_type character varying(20),
    gazetted_name character varying(30),
    new_watershed_code character varying(56),
    trimmed_watershed_code character varying(56),
    acat_report_url character varying(254),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPoint,3005)
);


--
-- Name: TABLE fiss_obstacles_pnt_sp; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON TABLE whse_fish.fiss_obstacles_pnt_sp IS 'FISS OBSTACLE PNT SP is an instantiated POINT layer of FISS_FISH_OBSTACLES_VW from the FISS operational system.  It is spatially-enabled using the UTM fields upon data load (FME).  It is the collection of all "obstructions" from FISS, FHIIP, and FDIS.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.fish_obstacle_point_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.fish_obstacle_point_id IS 'FISH OBSTACLE POINT ID is the primary key of the FISS POINTS record defining the location of this Obstacle.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.agency_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.agency_id IS 'AGENCY ID is a foreign key to AGENCIES.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.wbody_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.wbody_id IS 'WBODY ID is a foreign key to WDIC_WATERBODIES.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.obstacle_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.obstacle_code IS 'OBSTACLE CODE is a code used to identify the type of Obstacle.  Values depend on the source dataset for the data record.  The meaning of the OBSTACLE CODE is given in OBSTACLE NAME.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.obstacle_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.obstacle_name IS 'OBSTACLE NAME is the name of the type of Obstacle (e.g. Beaver Dam, Log Jam, etc.)';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.agency_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.agency_name IS 'AGENCY NAME is the name of the agency that reported the obstacle.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.source; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.source IS 'SOURCE is the name of the source dataset from which this record was obtained (FISS, FHIIP, or FDIS).';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.source_ref; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.source_ref IS 'SOURCE REF is the semi-colon delimited list of references from which this record was obtained.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.height; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.height IS 'HEIGHT is the height of the obstacle in meters.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.length; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.length IS 'LENGTH is the length of the obstacle in meters.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.utm_zone; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.utm_zone IS 'UTM ZONE is the NAD83 Universal Mercator (UTM) Zone coordinate for the downstream point of this obstacle.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.utm_easting; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.utm_easting IS 'UTM EASTING is the NAD83 Universal Mercator (UTM) Easting coordinate for the downstream point of this obstacle.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.utm_northing; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.utm_northing IS 'UTM NORTHING is the NAD83 Universal Mercator (UTM) Northing coordinate for the downstream point of this obstacle.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.survey_date; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.survey_date IS 'SURVEY DATE is the date on which the obstacle was recorded.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.waterbody_identifier; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.waterbody_identifier IS 'WATERBODY IDENTIFIER is a unique code identifying the waterbody in which the obstacle was recorded.  It is a 5-digit seqnce number followed by a 4-character watershed group code.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.waterbody_type; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.waterbody_type IS 'WATERBODY TYPE is a the type of waterbody in which the obstacle was recorded.  For example, Stream or Lake.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.gazetted_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.gazetted_name IS 'GAZETTED NAME is the gazetted name of the waterbody in which the obstacle was recorded.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.new_watershed_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.new_watershed_code IS 'NEW WATERSHED CODE is a watershed code, formatted with dashes, as assigned in the Watershed Atlas.  For example: 900-569800-08600-00000-0000-0000-000-000-000-000-000-000.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.trimmed_watershed_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.trimmed_watershed_code IS 'TRIMMED WATERSHED CODE is the NEW WATERSHED CODE, but with trailing zeros removed.  For example, if the NEW WATERSHED CODE is 100-005200-43400-50000-0000-0000-000-000-000-000-000-000, then the TRIMMED WATERSHED CODE will be 100-005200-43400-50000.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.acat_report_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.acat_report_url IS 'ACAT REPORT URL is a URL to the ACAT REPORT which provides additional information about the FISS OBSTACLE PNT SP.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.feature_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.feature_code IS 'FEATURE CODE contains a value based on the Canadian Council of Surveys and Mapping''s (CCSM) system for classification of geographic features.';


--
-- Name: COLUMN fiss_obstacles_pnt_sp.objectid; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_obstacles_pnt_sp.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: fiss_stream_sample_sites_sp; Type: TABLE; Schema: whse_fish; Owner: -
--

CREATE TABLE whse_fish.fiss_stream_sample_sites_sp (
    stream_sample_site_id integer NOT NULL,
    wbody_id numeric,
    data_source character varying(1000),
    source_ref character varying(4000),
    reach_number numeric,
    site_number numeric,
    field_utm_zone numeric,
    field_utm_easting numeric,
    field_utm_northing numeric,
    gis_utm_zone numeric,
    gis_utm_easting numeric,
    gis_utm_northing numeric,
    survey_date date,
    agency_name character varying(60),
    surveyed_length numeric,
    channel_width numeric,
    channel_width_comment character varying(2000),
    wetted_width numeric,
    wetted_width_comment character varying(2000),
    pool_depth numeric,
    pool_depth_comment character varying(2000),
    gradient numeric,
    gradient_comment character varying(2000),
    average_depth character varying(7),
    dominant_bed_material character varying(150),
    sub_dominant_bed_material character varying(150),
    other_bed_material_comment character varying(2000),
    dominant_size numeric,
    bed_morphology character varying(50),
    fisheries_sensitive_zone_ind character varying(3),
    crown_cover character varying(20),
    crown_closure_percent character varying(5),
    crown_closure_comment character varying(2000),
    channel_pattern character varying(30),
    visible_channel_ind character varying(3),
    stream_coupling_code character varying(30),
    stream_confinement_code character varying(30),
    confinement_comment character varying(2000),
    dewatering_ind character varying(3),
    intermittent_ind character varying(3),
    site_access_code character varying(30),
    debris_area character varying(40),
    large_woody_debris_cover character varying(30),
    large_woody_debris_amount character varying(30),
    large_woody_debris_dstrbtn character varying(30),
    small_woody_debris_cover character varying(30),
    boulder_cover character varying(30),
    undercut_cover character varying(30),
    deep_pool_cover character varying(30),
    overhanging_vegetation_cover character varying(30),
    instream_vegetation_cover character varying(30),
    instream_vegetation_code character varying(30),
    ems_number character varying(15),
    water_temperature numeric,
    water_temperature_comment character varying(2000),
    water_ph numeric,
    water_conductivity numeric,
    flood_signs character varying(30),
    flood_signs_comment character varying(2000),
    largest_moveable_particle_size numeric,
    discharge_stage character varying(30),
    discharge_comment character varying(2000),
    turbidity character varying(30),
    islands_code character varying(20),
    right_bank_riparian_vgtn_code character varying(40),
    right_bank_shape_code character varying(40),
    right_bank_vgtn_stage_code character varying(60),
    right_bank_texture character varying(120),
    left_bank_riparian_vgtn_code character varying(40),
    left_bank_shape_code character varying(40),
    left_bank_vgtn_stage_code character varying(60),
    left_bank_texture character varying(120),
    site_comments character varying(4000),
    gazetted_name character varying(100),
    new_watershed_code character varying(56),
    trimmed_watershed_code character varying(56),
    acat_report_url character varying(254),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPoint,3005)
);


--
-- Name: TABLE fiss_stream_sample_sites_sp; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON TABLE whse_fish.fiss_stream_sample_sites_sp IS 'FISS_STREAM_SAMPLE_SITES_SP is a survey of fish habitat information in a stream.  This object contains all the columns from the table FISS_STREAM_SAMPLE_SITES, plus additional columns from WDIC_WATERSHEDS and WDIC_WATERBODIES.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.stream_sample_site_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.stream_sample_site_id IS 'SAMPLE SITE ID is the unique identifier for a STREAM SAMPLE SITE.  The value is sourced from the FISS operational database.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.wbody_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.wbody_id IS 'WBODY_ID is a foreign key to WDIC_WATERBODIES.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.data_source; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.data_source IS 'DATA SOURCE is the abbreviation, and if appropriate, the primary key, of the dataset(s) from which the data were obtained.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.source_ref; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.source_ref IS 'SOURCE REF is the concatenation of all biographical references for the source data. This may include citations to reports that published the surveys or the name of a project under which the surveys were conducted.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.reach_number; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.reach_number IS 'REACH NUMBER is an agency-assigned number for the reach in which the survey occurred.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.site_number; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.site_number IS 'SITE NUMBER is an agency-assigned number for the site at which the survey occurred.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.field_utm_zone; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.field_utm_zone IS 'FIELD UTM ZONE is the zone of the site''s UTM location obtained in the field.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.field_utm_easting; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.field_utm_easting IS 'FIELD UTM EASTING is the easting coordinate of the site''s UTM location obtained in the field.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.field_utm_northing; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.field_utm_northing IS 'FIELD UTM NORTHING is the northing coordinate of the site''s UTM location obtained in the field.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.gis_utm_zone; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.gis_utm_zone IS 'GIS UTM ZONE is the zone of the site''s UTM location obtained in the field, then updated such that points are within 10 m of source line work on 1:20,000 scale maps.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.gis_utm_easting; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.gis_utm_easting IS 'GIS UTM EASTING is the easting coordinate of the site''s UTM location obtained in the field, then updated such that points are within 10 m of source line work on 1:20,000 scale maps.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.gis_utm_northing; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.gis_utm_northing IS 'GIS UTM NORTHING is the northing coordinate of the site''s UTM location obtained in the field, then updated such that points are within 10 m of source line work on 1:20,000 scale maps.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.survey_date; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.survey_date IS 'SURVEY DATE is the date that the stream site was surveyed.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.agency_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.agency_name IS 'AGENCY NAME is the name of the agency that conducted the stream survey.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.surveyed_length; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.surveyed_length IS 'SURVEYED LENGTH is the measured length of the site, in meters.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.channel_width; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.channel_width IS 'CHANNEL WIDTH is the width of the stream channel, in metres.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.channel_width_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.channel_width_comment IS 'CHANNEL WIDTH COMMENT is additional information about the method in which the channel width was estimated or pertaining to the accuracy of the channel width estimate.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.wetted_width; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.wetted_width IS 'WETTED WIDTH is the width of the stream measured at the water surface, in metres.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.wetted_width_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.wetted_width_comment IS 'WETTED WIDTH COMMENT is additional information about the method in which the wetted channel width was estimated or pertaining to the accuracy of the estimate.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.pool_depth; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.pool_depth IS 'POOL DEPTH is the depth of stream pools, in meters.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.pool_depth_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.pool_depth_comment IS 'POOL DEPTH COMMENT is additional information about the method in which the pool depth was estimated or pertaining to the accuracy of the estimate.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.gradient; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.gradient IS 'GRADIENT is the ratio of change in elevation to length of the stream segment, as a percentage.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.gradient_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.gradient_comment IS 'GRADIENT COMMENT is additional information about the method in which the stream gradient was estimated or pertaining to the accuracy of the estimate.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.average_depth; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.average_depth IS 'AVERAGE DEPTH is the average depth of the channel, in centimetres.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.dominant_bed_material; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.dominant_bed_material IS 'DOMINANT BED MATERIAL is the dominant stream bed material such as ''Boulders'', ''Cobble'', ''Gravels'', or ''Rock''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.sub_dominant_bed_material; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.sub_dominant_bed_material IS 'SUB DOMINANT BED MATERIAL is the subdominant stream bed material such as ''Boulders'', ''Cobble'', ''Gravels'', or ''Rock''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.other_bed_material_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.other_bed_material_comment IS 'OTHER BED MATERIAL COMMENT is a description of the stream bed material.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.dominant_size; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.dominant_size IS 'DOMINANT SIZE is the size of bed material larger than 95% of total substrate, in centimeters.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.bed_morphology; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.bed_morphology IS 'BED MORPHOLOGY is a description of the stream bed morphology. For example, ''Cascade Pool'', ''Large Channel'' or ''Riffle Pool''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.fisheries_sensitive_zone_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.fisheries_sensitive_zone_ind IS 'FISHERIES SENSITIVE ZONE IND indicates whether the site provides a valuable fish spawning or fry rearing habitat.  Possible values are Yes or No.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.crown_cover; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.crown_cover IS 'CROWN COVER is the total cover over of any structure in the wetted channel or within 1 m above the water surface that provides hiding, resting, or feeding places for fish. Stream cover estimates are obtained from a visual assessment of the type and amount of in-channel covers available for fish.Values are either given as percentages or as categorical data types, such as ''Abundant'', ''Moderate'' or ''None''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.crown_closure_percent; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.crown_closure_percent IS 'CROWN CLOSURE PERCENT is the approximate percentage of stream area with crown cover.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.crown_closure_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.crown_closure_comment IS 'CROWN CLOSURE COMMENT is a description of the crown cover.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.channel_pattern; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.channel_pattern IS 'CHANNEL PATTERN is a description of the channel pattern. For example, ''Irregular Meanders'', ''Sinuous'' or ''Straight''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.visible_channel_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.visible_channel_ind IS 'VISIBLE CHANNEL IND indicates whether or not a channel is visible. Possible values are Yes or No.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.stream_coupling_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.stream_coupling_code IS 'STREAM COUPLING CODE is a description of the linkage between the hillslope and the channel. Possible values are: ''Coupled'', ''Decoupled'', ''Partially Coupled'' and ''Not Specified''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.stream_confinement_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.stream_confinement_code IS 'STREAM CONFINEMENT CODE specifies the stream confinement morphology. Possible values are: Entrenched, Unconfined, Occasionally Confined, Confined, Frequently Confined, Not Applicable, Not Specified.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.confinement_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.confinement_comment IS 'CONFINEMENT COMMENT is a descrition of the stream confinement morphology.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.dewatering_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.dewatering_ind IS 'DEWATERING IND indicates whether or not dewatering was present. Possible values are Yes or No.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.intermittent_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.intermittent_ind IS 'INTERMITTENT IND indicates whether or not water flow is seasonal. Possible values are Yes or No.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.site_access_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.site_access_code IS 'SITE ACCESS CODE is a description of the type of access available to the site. Possible values are: Helicopter, Vehicle (4WD), All Terrain Vehicle, Float Plane, Horseback, Quad, Vehicle (2WD), Fixed Wing, Horse, Motorcycle, Boat, 2 Wheel Drive, Not Applicable, Fixed Wing Plane, Foot, 4 Wheel Drive.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.debris_area; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.debris_area IS 'DEBRIS AREA is the amount of channel area covered by debris. Values are given as percentages or as categorical data types such as ''Isolated Bits'', ''Few Clumps'' or ''Greater than 25% of Channel Area''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.large_woody_debris_cover; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.large_woody_debris_cover IS 'LARGE WOODY DEBRIS COVER is the amount of large woody debris at the site. Values are given either as percentages, or as categorical data types such as ''Dominant'', ''Sub-Dominant'' or ''None''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.large_woody_debris_amount; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.large_woody_debris_amount IS 'LARGE WOODY DEBRIS AMOUNT is a description of the amount of large woody debris. For example, ''Abundant'', ''Few'' or ''None''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.large_woody_debris_dstrbtn; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.large_woody_debris_dstrbtn IS 'LARGE WOODY DEBRIS DSTRBTN is a description of the distribution of large woody debris. For example, ''Evenly Distributed'' or ''Clumped''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.small_woody_debris_cover; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.small_woody_debris_cover IS 'SMALL WOODY DEBRIS COVER is the amount of small woody debris at the site. Values are given either as percentages, or as categorical data types such as ''Dominant'', ''Sub-Dominant'' or ''None''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.boulder_cover; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.boulder_cover IS 'BOULDER COVER is the amount of boulder cover, specified either as a percentage or as a categorical data type (such as ''Abundant'', ''Moderate'', etc.).';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.undercut_cover; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.undercut_cover IS 'UNDERCUT COVER is the amount of the stream covered by a bank that has had its base cut away by the water or has been man-made and overhangs part of the stream. The value is specified either as a percentage or as a categorical data type (such as ''Abundant'', ''Moderate'', etc.).';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.deep_pool_cover; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.deep_pool_cover IS 'DEEP POOL COVER is the amount of the stream with reduced current velocity at low flow that is deeper than the surrounding area, and usable by fish for resting or cover (therefore containing some surface cover of flow turbulence). The value is specified either as a percentage or as a categorical data type (such as ''Abundant'', ''Moderate'', etc.).';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.overhanging_vegetation_cover; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.overhanging_vegetation_cover IS 'OVERHANGING VEGETATION COVER is the amount of the stream covered by overhanging vegetation. The value is specified either as a percentage or as a categorical data type (such as ''Abundant'', ''Moderate'', etc.).';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.instream_vegetation_cover; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.instream_vegetation_cover IS 'INSTREAM VEGETATION COVER is the amount of the stream in which vegetative materials such as attached, filamentous algae or other aquatic plants provide protection for fish. The value is specified either as a percentage or as a categorical data type (such as ''Abundant'', ''Moderate'', etc.).';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.instream_vegetation_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.instream_vegetation_code IS 'INSTREAM VEGETATION CODE is the type of vegetative materials that provide protection for fish. Possible values are Algaea, Moss, None and Other.  A list of multiple types may be specified, separated by commas.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.ems_number; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.ems_number IS 'EMS NUMBER is the number assigned by the Environment Monitoring System (EMS). For example, E236773.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.water_temperature; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.water_temperature IS 'WATER TEMPERATURE is the temperature of the water in degrees Celsius.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.water_temperature_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.water_temperature_comment IS 'WATER TEMPERATURE COMMENT provides information about water temperature. In some cases this field also provides information about alkalinity, turbidity, air temperature or other measurables.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.water_ph; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.water_ph IS 'WATER PH is a measure of water pH.  The pH scale ranges from 0 to 14. A pH of 7 is neutral. A pH less than 7 is acidic. A pH greater than 7 is basic.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.water_conductivity; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.water_conductivity IS 'WATER CONDUCTIVITY is a measure of electrical current flow through a solution, expressed in units of microSiemens (uS). Conductivity is the reciprocal of electrical resistance (ohms).';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.flood_signs; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.flood_signs IS 'FLOOD SIGNS is a description of signs of flooding in the local area.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.flood_signs_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.flood_signs_comment IS 'FLOOD SIGNS COMMENT is an additional comment about signs of flooding in the area.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.largest_moveable_particle_size; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.largest_moveable_particle_size IS 'LARGEST MOVEABLE PARTICLE SIZE is the size of the largest movable particle in the bed, in centimeters.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.discharge_stage; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.discharge_stage IS 'DISCHARGE STAGE is the stage of discharge compared to the bankful depth - Low, Medium, or High.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.discharge_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.discharge_comment IS 'DISCHARGE COMMENT is additional information about the stream discharge, such as how it was estimated or why it was not possible to estimate the discharge.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.turbidity; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.turbidity IS 'TURBIDITY is a description of the turbidity of the water.  The value is specified either as a number (in units of cm) or as a categorical data type (''Clear'', ''Lightly Turbid'', ''Moderately Turbid'' or ''Turbid''.).';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.islands_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.islands_code IS 'ISLANDS CODE describes the presence of islands. Possible values are: Occasional, Split, None, No, Frequent, Anastomosing, Yes, Irregular, Not Specified.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.right_bank_riparian_vgtn_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.right_bank_riparian_vgtn_code IS 'RIGHT BANK RIPARIAN VEGETATION CODE is the type of riparian vegetation on the right bank. Possible values are: Grass, Deciduous, Coniferous, Mixed C/D, None, Shrubs, Wetland, Not Specified.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.right_bank_shape_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.right_bank_shape_code IS 'RIGHT BANK SHAPE CODE is the shape of the right channel bank. Possible values are: Sloping (gradual or shallow sloping), Undercut, Overhanging bank, V - shaped (steep sloping or vertical).';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.right_bank_vgtn_stage_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.right_bank_vgtn_stage_code IS 'RIGHT BANK VEGETATION STAGE CODE is the stage of vegetation development on the right bank. Possible values are: Non-vegetated or initial stage following disturbance, Mature forest, Shrub/herb stage, Pole-sapling stage, Young forest, Not Applicable, Not Specified.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.right_bank_texture; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.right_bank_texture IS 'RIGHT BANK TEXTURE is the texture of the right channel bank. For example, ''Anthropogenic (rip-rap, dikes, etc.)'', ''Boulders'', ''Bedrock'', or ''Gravels''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.left_bank_riparian_vgtn_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.left_bank_riparian_vgtn_code IS 'LEFT BANK RIPARIAN VEGETATION CODE is the type of riparian vegetation on the leftbank. Possible values are: Grass, Deciduous, Coniferous, Mixed C/D, None, Shrubs, Wetland, Not Specified.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.left_bank_shape_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.left_bank_shape_code IS 'LEFT BANK SHAPE CODE is the shape of the left channel bank. Possible values are: Sloping (gradual or shallow sloping), Undercut, Overhanging bank, V - shaped (steep sloping or vertical).';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.left_bank_vgtn_stage_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.left_bank_vgtn_stage_code IS 'LEFT BANK VEGETATION STAGE CODE is the stage of vegetation development on the left bank. Possible values are: Non-vegetated or initial stage following disturbance, Mature forest, Shrub/herb stage, Pole-sapling stage, Young forest, Not Applicable, Not Specified.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.left_bank_texture; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.left_bank_texture IS 'LEFT BANK TEXTURE the texture of the left channel bank. For example, ''Anthropogenic (rip-rap, dikes, etc.)'', ''Boulders'', ''Bedrock'', or ''Gravels''.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.site_comments; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.site_comments IS 'SITE COMMENTS is an additional comment about stream site.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.gazetted_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.gazetted_name IS 'GAZETTED NAME is the gazetted name of the waterbody in which the obstacle was recorded.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.new_watershed_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.new_watershed_code IS 'NEW WATERSHED CODE is a watershed code, formatted with dashes, as assigned in the Watershed Atlas. For example: 900-569800-08600-00000-0000-0000-000-000-000-000-000-000.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.trimmed_watershed_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.trimmed_watershed_code IS 'TRIMMED WATERSHED CODE is the NEW WATERSHED CODE, but with trailing zeros removed. For example, if the NEW WATERSHED CODE is 100-005200-43400-50000-0000-0000-000-000-000-000-000-000, then the TRIMMED WATERSHED CODE will be 100-005200-43400-50000.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.acat_report_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.acat_report_url IS 'ACAT REPORT URL is a URL to the ACAT REPORT which provides additional information about the STREAM SAMPLE SITE SP.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.feature_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.feature_code IS 'FEATURE CODE contains a value based on the Canadian Council of Surveys and Mapping''s (CCSM) system for classification of geographic features.';


--
-- Name: COLUMN fiss_stream_sample_sites_sp.objectid; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.fiss_stream_sample_sites_sp.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: fiss_stream_sample_sites_sp_stream_sample_site_id_seq; Type: SEQUENCE; Schema: whse_fish; Owner: -
--

CREATE SEQUENCE whse_fish.fiss_stream_sample_sites_sp_stream_sample_site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fiss_stream_sample_sites_sp_stream_sample_site_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_fish; Owner: -
--

ALTER SEQUENCE whse_fish.fiss_stream_sample_sites_sp_stream_sample_site_id_seq OWNED BY whse_fish.fiss_stream_sample_sites_sp.stream_sample_site_id;


--
-- Name: pscis_assessment_svw; Type: TABLE; Schema: whse_fish; Owner: -
--

CREATE TABLE whse_fish.pscis_assessment_svw (
    funding_project_number character varying(255),
    funding_project character varying(255),
    project_id numeric,
    funding_source character varying(10),
    responsible_party_name character varying(255),
    consultant_name character varying(255),
    assessment_date date,
    stream_crossing_id integer NOT NULL,
    assessment_id numeric,
    external_crossing_reference character varying(50),
    crew_members character varying(255),
    utm_zone numeric,
    utm_easting numeric,
    utm_northing numeric,
    location_confidence_ind character varying(1),
    stream_name character varying(256),
    road_name character varying(256),
    road_km_mark numeric,
    road_tenure character varying(50),
    crossing_type_code character varying(24),
    crossing_type_desc character varying(120),
    crossing_subtype_code character varying(24),
    crossing_subtype_desc character varying(120),
    diameter_or_span numeric,
    length_or_width numeric,
    continuous_embeddedment_ind character varying(1),
    average_depth_embededdment numeric,
    resemble_channel_ind character varying(1),
    backwatered_ind character varying(1),
    percentage_backwatered numeric,
    fill_depth numeric,
    outlet_drop numeric,
    outlet_pool_depth numeric,
    inlet_drop_ind character varying(1),
    culvert_slope numeric,
    downstream_channel_width numeric,
    stream_slope numeric,
    beaver_activity_ind character varying(1),
    fish_observed_ind character varying(1),
    valley_fill_code character varying(2),
    valley_fill_code_desc character varying(120),
    habitat_value_code character varying(10),
    habitat_value_desc character varying(120),
    stream_width_ratio numeric,
    stream_width_ratio_score numeric,
    culvert_length_score numeric,
    embed_score numeric,
    outlet_drop_score numeric,
    culvert_slope_score numeric,
    final_score numeric,
    barrier_result_code character varying(10),
    barrier_result_description character varying(120),
    crossing_fix_code character varying(10),
    crossing_fix_desc character varying(120),
    recommended_diameter_or_span numeric,
    assessment_comment character varying(4000),
    ecocat_url character varying(200),
    image_view_url character varying(200),
    current_pscis_status character varying(25),
    current_crossing_type_code character varying(24),
    current_crossing_type_desc character varying(120),
    current_crossing_subtype_code character varying(24),
    current_crossing_subtype_desc character varying(120),
    current_barrier_result_code character varying(10),
    current_barrier_description character varying(120),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPoint,3005)
);


--
-- Name: TABLE pscis_assessment_svw; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON TABLE whse_fish.pscis_assessment_svw IS 'This view defines the most current assessment for a stream crossing location. An assessment provides the field survey data required to determine whether a stream crossing requires remediation efforts in order to make it passable to fish habitat.';


--
-- Name: COLUMN pscis_assessment_svw.funding_project_number; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.funding_project_number IS 'The ASSMT FUNDING PROJECT NUMBER is the identifier for the project and is usually related to the funding source. For example, ''9172001b'' is the FUNDING PROJECT NUMBER associated with the project who''s name is ''Fish Passage Culvert Inspections 2009, Kootenay Lake Forest District, Kootenay Lake TSA''.';


--
-- Name: COLUMN pscis_assessment_svw.funding_project; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.funding_project IS 'The FUNDING PROJECT is the identifier for the project and is usually related to the funding source. (e.g.  ''Fish Passage Culvert Inspections 2009, Kootenay Lake Forest District, Kootenay Lake TSA'')';


--
-- Name: COLUMN pscis_assessment_svw.project_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.project_id IS 'The PROJECT ID is the system identifier for the project; this value is generated within PSCIS.';


--
-- Name: COLUMN pscis_assessment_svw.funding_source; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.funding_source IS 'FUNDING SOURCE defines the source of funding for the associated project. Eg. FIA';


--
-- Name: COLUMN pscis_assessment_svw.responsible_party_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.responsible_party_name IS 'The RESPONSIBLE PARTY NAME is the name of the provided responsible party.';


--
-- Name: COLUMN pscis_assessment_svw.consultant_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.consultant_name IS 'The CONSULTANT NAME is the name of the provided consultant.';


--
-- Name: COLUMN pscis_assessment_svw.assessment_date; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.assessment_date IS 'The ASSESSMENT DATE is the date when the assessment was completed.';


--
-- Name: COLUMN pscis_assessment_svw.stream_crossing_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.stream_crossing_id IS 'The STREAM CROSSING ID is the unique identifier for the STREAM CROSSING LOCATION POINT.';


--
-- Name: COLUMN pscis_assessment_svw.assessment_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.assessment_id IS 'The ASSESSMENT_ID is the unique identifier for the latest crossing assessment.';


--
-- Name: COLUMN pscis_assessment_svw.external_crossing_reference; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.external_crossing_reference IS 'The EXTERNAL CROSSING REFERENCE identifies the submitters name used to reference a stream crossing.';


--
-- Name: COLUMN pscis_assessment_svw.crew_members; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.crew_members IS 'CREW MEMEBERS are the initials of the crew members taking measurements usually delimited by commas.';


--
-- Name: COLUMN pscis_assessment_svw.utm_zone; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.utm_zone IS 'UTM ZONE is a segment of the Earth''s surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';


--
-- Name: COLUMN pscis_assessment_svw.utm_easting; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';


--
-- Name: COLUMN pscis_assessment_svw.utm_northing; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';


--
-- Name: COLUMN pscis_assessment_svw.location_confidence_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.location_confidence_ind IS 'The LOCATION CONFIDENCE IND may indicate if this spatial point is a duplicate. Allowable values are ''Y'' and ''N''';


--
-- Name: COLUMN pscis_assessment_svw.stream_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.stream_name IS 'The STREAM NAME is the mapped stream name. If no name is given for the watercourse, then the parent tributary name is used (i.e. Tributary to Bear Creek)';


--
-- Name: COLUMN pscis_assessment_svw.road_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.road_name IS 'The ROAD NAME is the name of the road at the crossing, usually a forest road.';


--
-- Name: COLUMN pscis_assessment_svw.road_km_mark; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.road_km_mark IS 'The ROAD KM MARK is the road kilometre position of the crossing to the nearest 0.01 km, matching the kilometre markers, if present.';


--
-- Name: COLUMN pscis_assessment_svw.road_tenure; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.road_tenure IS 'The ROAD TENURE is the best available ID for the road at the time of assessment. For example, the Forest File Id of a Road Permit or Forest Service Road.';


--
-- Name: COLUMN pscis_assessment_svw.crossing_type_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.crossing_type_code IS 'The CROSSING TYPE CODE is the code value defining the type of crossing present at the location of the stream crossing at the time of the assessment. Acceptable types are:OBS = Open Bottom StructureCBS = Closed Bottom StructureOTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN pscis_assessment_svw.crossing_type_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.crossing_type_desc IS 'CROSSING TYPE DESC describes the CROSSING TYPE CODE.';


--
-- Name: COLUMN pscis_assessment_svw.crossing_subtype_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.crossing_subtype_code IS 'The CROSSING SUBTYPE CODE further defines the value provided with the ASSMT CROSSING TYPE CODE. Valid subtypes depend on CROSSING TYPE CODE. Acceptable values are BRIDGE, PIPE ARCH, WOOD BOX CULVERT, ROUND CULVERT, OVAL CULVERT.';


--
-- Name: COLUMN pscis_assessment_svw.crossing_subtype_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.crossing_subtype_desc IS 'CROSSING SUBTYPE DESC describes the CROSSING SUBTYPE CODE.';


--
-- Name: COLUMN pscis_assessment_svw.diameter_or_span; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.diameter_or_span IS 'The DIAMETER OR SPAN is the measured structure diameter in metres, to the nearest 0.01m if it is a culvert. If it is an open bottomed structure, record a span value in metres to the nearest 0.01m.';


--
-- Name: COLUMN pscis_assessment_svw.length_or_width; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.length_or_width IS 'The LENGTH OR WIDTH is the length of the structure in metres, to the nearest 0.01m if it is a culvert. If it is a closed bottom structure enter a width value in metres, to the nearest 0.01m.';


--
-- Name: COLUMN pscis_assessment_svw.continuous_embeddedment_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.continuous_embeddedment_ind IS 'The CONTINUOUS EMBEDDEDMENT IND is an indicator value identifying if the culvert is continuously buried in the stream substrate throughout its entire length. Acceptable values are ''Y'' and ''N''.';


--
-- Name: COLUMN pscis_assessment_svw.average_depth_embededdment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.average_depth_embededdment IS 'The AVERAGE DEPTH EMBEDDEDMENT identifies the approximate average depth of the substrate within the culvert (Metres, to the nearest 0.01m)';


--
-- Name: COLUMN pscis_assessment_svw.resemble_channel_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.resemble_channel_ind IS 'The RESEMBLE CHANEL IND is an indicator value identifying if the bed of the culvert resembles the native streambed. Acceptable values are ''Y'' and ''N''.';


--
-- Name: COLUMN pscis_assessment_svw.backwatered_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.backwatered_ind IS 'The BACKWATERED IND is an indicator value identifying if the culvert is backwatered. Acceptable values are ''Y'' and ''N''. Backwatering refers to the damming of water as a result of a downstream control (weir or debris jam).';


--
-- Name: COLUMN pscis_assessment_svw.percentage_backwatered; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.percentage_backwatered IS 'The PERCENTAGE BACKWATERED is the percentage of total culvert length that the outlet pool fills back into the culvert.';


--
-- Name: COLUMN pscis_assessment_svw.fill_depth; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.fill_depth IS 'The FILL DEPTH is the avereage depth of fill over culvert in metres (to the nearest 0.01m)';


--
-- Name: COLUMN pscis_assessment_svw.outlet_drop; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.outlet_drop IS 'The OUTLET DROP value is a sum of two measures (metres , to nearest 0.01m) 1. The distance between the culvert invert and the top of the residual pool. 2. The height of the outlet control (The height of the top of the residual pool to the bottom of the outlet control)';


--
-- Name: COLUMN pscis_assessment_svw.outlet_pool_depth; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.outlet_pool_depth IS 'The OUTLET POOL DEPTH describes the residual pool depth in metres (To the nearest 0.01m). Subtrat water depth at the outlet control from the water depth of the pool downstream of the crossing.';


--
-- Name: COLUMN pscis_assessment_svw.inlet_drop_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.inlet_drop_ind IS 'The INLET DROP IND is an indicator value identifying if there is a drop between the streambed elevation and the invert of the culvert at the inlet. Acceptable values are ''Y'' and ''N''.';


--
-- Name: COLUMN pscis_assessment_svw.culvert_slope; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.culvert_slope IS 'The CULVERT SLOPE is the slope of the culvert. Looking upstream in the culvert, culvert slope is estimated by using a clinometer. If the inital culvert slope is 4% or greater, the estimated slope is recorded (as a percentage value). If the initial reading is less than 4%, the slop is measured using a more precise instrument such as a level.';


--
-- Name: COLUMN pscis_assessment_svw.downstream_channel_width; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.downstream_channel_width IS 'The DOWNSTREAM CHANNEL WIDTH describes the channel width in metres (to the nearest 0.01m). Channel width is the horizontal distance between the opposite stream banks, measured at right angles to the general orientation of the banks.';


--
-- Name: COLUMN pscis_assessment_svw.stream_slope; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.stream_slope IS 'The STREAM SLOPE describes the slope of a section of stream either upstream or downstream of the culvert, measured using a clinometer. If the stream is at the confluence of the lake, wetland, or larger river, the slope of a section of an upstream section beyond the influence of the road right-of-way is measured.';


--
-- Name: COLUMN pscis_assessment_svw.beaver_activity_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.beaver_activity_ind IS 'The BEAVER ACTIVITY IND indicates evidence of beaver activity. This is a maintenance issue and may influence restoration options. Allowable values are ''Y'' and ''N''';


--
-- Name: COLUMN pscis_assessment_svw.fish_observed_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.fish_observed_ind IS 'The FISH OBSERVED IND identifies if fish have been observed at the crossing. Allowable values are ''Y'' and ''N''';


--
-- Name: COLUMN pscis_assessment_svw.valley_fill_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.valley_fill_code IS 'The VALLEY FILL CODE is a code value indicating the depth of the fill on stream. Acceptable values are:DF - Deep Fill - No or little bedrock showing on stream.SF- Shallow Fill - Bedrock occasionally shows on stream.BR - Bedrock - A large area of the bedrock is evident on stream.';


--
-- Name: COLUMN pscis_assessment_svw.valley_fill_code_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.valley_fill_code_desc IS 'VALLEY FILL CODE DESC describes the VALLEY FILL CODE.';


--
-- Name: COLUMN pscis_assessment_svw.habitat_value_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.habitat_value_code IS 'The HABITAT VALUE CODE is a code value describing the evaluated habitat at a crossing site. Particular emphasis is on habitat upstream of the CBS as this is the habitat that will be gained when fish passage is restored. Acceptable values are HIGH, MEDIUM and LOW.';


--
-- Name: COLUMN pscis_assessment_svw.habitat_value_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.habitat_value_desc IS 'HABITAT VALUE DESC describes the usage of the HABITAT VALUE CODE.';


--
-- Name: COLUMN pscis_assessment_svw.stream_width_ratio; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.stream_width_ratio IS 'The STREAM WIDTH RATIO is the value derived by dividing the DOWNSTREAM CHANNEL WIDTH by the culvert diameter.';


--
-- Name: COLUMN pscis_assessment_svw.stream_width_ratio_score; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.stream_width_ratio_score IS 'The STREAM WIDTH RATIO SCORE defines the Fish Barrier Scoring value for the stream width ratio.<1.0 = 0>=1.0 & <1.3 = 3>=1.3 = 6';


--
-- Name: COLUMN pscis_assessment_svw.culvert_length_score; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.culvert_length_score IS 'The CULVERT LENGTH SCORE   defines the Fish Barrier Scoring value for the length of the culvert.<15m = 0>=15m & <30m = 3>=30m = 6';


--
-- Name: COLUMN pscis_assessment_svw.embed_score; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.embed_score IS 'The EMBED SCORE defines the Fish Barrier Scoring value for the level of stream embededment. The value is defined by the Average Depth Embeddedment / Culvert Diameter, or just the Average Depth Embeddedment.A value of 0 where Average Depth Embeddedment / Culvert Diameter  >= 0.2, or Average Depth Embeddedment >= 0.3mA value of 5 where Average Depth Embeddedment / Culvert Diameter  < 0.2, or Average Depth Embeddedment < 0.3mA value of 10 where CONTINUOUS EMBEDDEDMENT IND = ''N''';


--
-- Name: COLUMN pscis_assessment_svw.outlet_drop_score; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.outlet_drop_score IS 'The OUTLET DROP SCORE defines the Fish Barrier Scoring value for the outlet drop.< 0.15m = 0>=0.15m & <0.3m = 5>=0.3m = 10';


--
-- Name: COLUMN pscis_assessment_svw.culvert_slope_score; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.culvert_slope_score IS 'The CULVERT SLOPE SCORE defines the Fish Barrier Scoring value for the culvert slope.<1% = 0>=1% & <3% = 5>=3% = 10';


--
-- Name: COLUMN pscis_assessment_svw.final_score; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.final_score IS 'The FINAL SCORE describes the final accumulated Fish Barrier Score. It is the sum of the other score values, CULVERT LENGTH SCORE, EMBED SCORE, OUTLET DROP SCORE, CULVERT SLOPE SCORE, STREAM WIDTH RATIO SCORE.';


--
-- Name: COLUMN pscis_assessment_svw.barrier_result_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.barrier_result_code IS 'The BARRIER RESULT CODE is the evaluation of the crossing as a barrier to the fish passage, based on the FINAL SCORE value. Acceptable Values are:PASSABLE - PassablePOTENTIAL - Potential BarrierBARRIER - BarrierUNKOWN - Other';


--
-- Name: COLUMN pscis_assessment_svw.barrier_result_description; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.barrier_result_description IS 'BARRIER RESULT DESCRIPTION describes the usage of BARRIER RESULT CODE.';


--
-- Name: COLUMN pscis_assessment_svw.crossing_fix_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.crossing_fix_code IS 'The CROSSING FIX CODE defines the allowable culvert fix options. Acceptable values are:RM - RemovalOBS - Open Bottom StructureSS - Streambed SimulationEM - Additional substrate material and/or downstream weirsBW - Backwater.';


--
-- Name: COLUMN pscis_assessment_svw.crossing_fix_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.crossing_fix_desc IS 'CROSSING FIX DESC describes the CROSSING FIX CODE.';


--
-- Name: COLUMN pscis_assessment_svw.recommended_diameter_or_span; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.recommended_diameter_or_span IS 'The RECOMMENDED DIAMETER OR SPAN is the approximate length (streambed simulation) or span (bridge) of the proposed replacement structure. The value is provided in meters.';


--
-- Name: COLUMN pscis_assessment_svw.assessment_comment; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.assessment_comment IS 'The ASSESSMENT COMMENT is an additional note or details about a crossing assessment.';


--
-- Name: COLUMN pscis_assessment_svw.ecocat_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.ecocat_url IS 'A URL pointing at Ecocat for the related project.';


--
-- Name: COLUMN pscis_assessment_svw.image_view_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.image_view_url IS 'A URL pointing at an HTML display of the attachments.';


--
-- Name: COLUMN pscis_assessment_svw.current_pscis_status; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.current_pscis_status IS 'CURRENT PSCIS STATUS defines the current status of the crossing as either assessed, designed, or remediated. Defines the current status of the crossing as either assessed, designed, or remediated.';


--
-- Name: COLUMN pscis_assessment_svw.current_crossing_type_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.current_crossing_type_code IS 'The CURRENT CROSSING TYPE CODE is the code value defining the type of crossing present at the location of the stream crossing. Acceptable types are:OBS = Open Bottom StructureCBS = Closed Bottom StructureOTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN pscis_assessment_svw.current_crossing_type_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.current_crossing_type_desc IS 'CURRENT CROSSING TYPE DESC describes the CURRENT CROSSING TYPE.';


--
-- Name: COLUMN pscis_assessment_svw.current_crossing_subtype_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.current_crossing_subtype_code IS 'The CURRENT CROSSING SUBTYPE CODE further defines the value provided with the CURRENT CROSSING TYPE CODE. Valid subtypes depend on CURRENT CROSSING TYPE CODE. Acceptable values are BRIDGE, PIPE ARCH, WOOD BOX CULVERT, ROUND CULVERT, OVAL CULVERT.';


--
-- Name: COLUMN pscis_assessment_svw.current_crossing_subtype_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.current_crossing_subtype_desc IS 'CURRENT CROSSING SUBTYPE DESC describes the CUURENT CROSSING SUBTYPE.';


--
-- Name: COLUMN pscis_assessment_svw.current_barrier_result_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.current_barrier_result_code IS 'The CURRENT BARRIER RESULT CODE is the current evaluation of the crossing as a barrier to the fish passage, based on the FINAL SCORE value. Acceptable Values are: PASSABLE - Passable POTENTIAL - Potential Barrier BARRIER - Barrier UNKOWN - Other.';


--
-- Name: COLUMN pscis_assessment_svw.current_barrier_description; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.current_barrier_description IS 'CURRENT BARRIER DESCRIPTION describes the usage of the CURRENT BARRIER RESULT CODE.';


--
-- Name: COLUMN pscis_assessment_svw.feature_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.feature_code IS 'A feature code defines the standards for a spatial feature and is often used for defining cartography standards.';


--
-- Name: COLUMN pscis_assessment_svw.objectid; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_assessment_svw.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: pscis_assessment_svw_stream_crossing_id_seq; Type: SEQUENCE; Schema: whse_fish; Owner: -
--

CREATE SEQUENCE whse_fish.pscis_assessment_svw_stream_crossing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pscis_assessment_svw_stream_crossing_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_fish; Owner: -
--

ALTER SEQUENCE whse_fish.pscis_assessment_svw_stream_crossing_id_seq OWNED BY whse_fish.pscis_assessment_svw.stream_crossing_id;


--
-- Name: pscis_design_proposal_svw; Type: TABLE; Schema: whse_fish; Owner: -
--

CREATE TABLE whse_fish.pscis_design_proposal_svw (
    funding_project_number character varying(255),
    funding_project character varying(255),
    project_id numeric,
    funding_source character varying(10),
    responsible_party_name character varying(255),
    consultant_name character varying(255),
    proposal_date date,
    stream_crossing_id integer NOT NULL,
    remediation_proposal_id numeric,
    external_crossing_reference character varying(50),
    utm_zone numeric,
    utm_easting numeric,
    utm_northing numeric,
    location_confidence_ind character varying(1),
    stream_name character varying(256),
    road_name character varying(256),
    road_km_mark numeric,
    road_tenure character varying(50),
    crossing_fix_code character varying(120),
    crossing_fix_desc character varying(120),
    proposed_diameter_or_span numeric,
    estimated_design_cost numeric,
    cost_benefit_calc numeric,
    expiry_date date,
    ecocat_url character varying(200),
    image_view_url character varying(200),
    current_pscis_status character varying(25),
    current_crossing_type_code character varying(24),
    current_crossing_type_desc character varying(120),
    current_crossing_subtype_code character varying(24),
    current_crossing_subtype_desc character varying(120),
    current_barrier_result_code character varying(10),
    current_barrier_description character varying(120),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPoint,3005)
);


--
-- Name: TABLE pscis_design_proposal_svw; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON TABLE whse_fish.pscis_design_proposal_svw IS 'This view defines the stream crossing locations in which design proposals have been received to remediate a stream crossing that is defined as not passable.';


--
-- Name: COLUMN pscis_design_proposal_svw.funding_project_number; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.funding_project_number IS 'The FUNDING PROJECT NUMBER is the identifier for the project and is usually related to the funding source. For example, ''9172001b'' is the FUNDING PROJECT NUMBER associated with the project who''s name is ''Fish Passage Culvert Inspections 2009, Kootenay Lake Forest District, Kootenay Lake TSA''.';


--
-- Name: COLUMN pscis_design_proposal_svw.funding_project; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.funding_project IS 'The FUNDING PROJECT is the identifier for the project and is usually related to the funding source. (e.g.  ''Fish Passage Culvert Inspections 2009, Kootenay Lake Forest District, Kootenay Lake TSA'')';


--
-- Name: COLUMN pscis_design_proposal_svw.project_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.project_id IS 'The PROJECT ID is the system identifier for the project; this value is generated within PSCIS.';


--
-- Name: COLUMN pscis_design_proposal_svw.funding_source; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.funding_source IS 'FUNDING SOURCE CODE defines the source of funding for the associated project. Eg. FIA';


--
-- Name: COLUMN pscis_design_proposal_svw.responsible_party_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.responsible_party_name IS 'The RESPONSIBLE PARTY NAME is the name of the provided responsible party.';


--
-- Name: COLUMN pscis_design_proposal_svw.consultant_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.consultant_name IS 'The CONSULTANT NAME is the name of the provided consultant.';


--
-- Name: COLUMN pscis_design_proposal_svw.proposal_date; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.proposal_date IS 'The PROPOSAL DATE is the date in which the remediation proposal was recieved.';


--
-- Name: COLUMN pscis_design_proposal_svw.stream_crossing_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.stream_crossing_id IS 'The STREAM CROSSING ID is the unique identifier for the STREAM CROSSING LOCATION POINT.';


--
-- Name: COLUMN pscis_design_proposal_svw.remediation_proposal_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.remediation_proposal_id IS 'The REMEDIATION PROPOSAL ID is the unique identifier for the REMEDIATION PROPOSAL if one exists for this crossing.';


--
-- Name: COLUMN pscis_design_proposal_svw.external_crossing_reference; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.external_crossing_reference IS 'The EXTERNAL CROSSING REFERENCE identifies the submitters name used to reference a stream crossing.';


--
-- Name: COLUMN pscis_design_proposal_svw.utm_zone; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.utm_zone IS 'UTM ZONE is a segment of the Earth''s surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';


--
-- Name: COLUMN pscis_design_proposal_svw.utm_easting; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';


--
-- Name: COLUMN pscis_design_proposal_svw.utm_northing; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';


--
-- Name: COLUMN pscis_design_proposal_svw.location_confidence_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.location_confidence_ind IS 'The LOCATION CONFIDENCE IND may indicate if this spatial point is a duplicate. Allowable values are ''Y'' and ''N''';


--
-- Name: COLUMN pscis_design_proposal_svw.stream_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.stream_name IS 'The STREAM NAME is the mapped stream name. If no name is given for the watercourse, then the parent tributary name is used (i.e. Tributary to Bear Creek)';


--
-- Name: COLUMN pscis_design_proposal_svw.road_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.road_name IS 'The ROAD NAME is the name of the road at the crossing, usually a forest road.';


--
-- Name: COLUMN pscis_design_proposal_svw.road_km_mark; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.road_km_mark IS 'The ROAD KM MARK is the road kilometre position of the crossing to the nearest 0.01 km, matching the kilometre markers, if present.';


--
-- Name: COLUMN pscis_design_proposal_svw.road_tenure; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.road_tenure IS 'The ROAD TENURE is the best available ID for the road at the time of assessment. For example, the Forest File Id of a Road Permit or Forest Service Road.';


--
-- Name: COLUMN pscis_design_proposal_svw.crossing_fix_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.crossing_fix_code IS 'The CROSSING FIX CODE defines the proposed culvert fix. Acceptable values are:RM - RemovalOBS - Open Bottom StructureSS - Streambed SimulationEM - Additional substrate material and/or downstream weirsBW - Backwater';


--
-- Name: COLUMN pscis_design_proposal_svw.crossing_fix_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.crossing_fix_desc IS 'CROSSING FIX DESC describes the CROSSING FIX CODE.';


--
-- Name: COLUMN pscis_design_proposal_svw.proposed_diameter_or_span; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.proposed_diameter_or_span IS 'The PROPOSED DIAMETER OR SPAN is the approximate diameter or span (bridge) of proposed replacement structure, in metres to the nearest 0.01m.';


--
-- Name: COLUMN pscis_design_proposal_svw.estimated_design_cost; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.estimated_design_cost IS 'The ESTIMATED DESIGN COST is the estimated cost to complete the proposed remediation in canadian dollars.';


--
-- Name: COLUMN pscis_design_proposal_svw.cost_benefit_calc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.cost_benefit_calc IS 'The COST BENEFIT CALCULATION is an evaluation of the benefit of repairing or fixing a culvert or stream crossing location, in contrast to the propsed estimated cost. (ESTIMATED COST / VERIFIED HABITAT LENGTH)';


--
-- Name: COLUMN pscis_design_proposal_svw.expiry_date; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.expiry_date IS 'The EXPIRY DATE is the date when the REMEDIATION PROPOSAL will expire.';


--
-- Name: COLUMN pscis_design_proposal_svw.ecocat_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.ecocat_url IS 'A URL pointing at Ecocat for the related project.';


--
-- Name: COLUMN pscis_design_proposal_svw.image_view_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.image_view_url IS 'IMAGE VIEW URL  is a URL pointing at an HTML display of the Design attachments. e.g., http://a100.gov.bc.ca/pub/pscismap/imageViewer.do?remediationProposalid=[REMEDIATION_PROPOSAL_ID]';


--
-- Name: COLUMN pscis_design_proposal_svw.current_pscis_status; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.current_pscis_status IS 'CURRENT PSCIS STATUS defines the current status of the crossing as either assessed, designed, or remediated. Defines the current status of the crossing as either assessed, designed, or remediated.';


--
-- Name: COLUMN pscis_design_proposal_svw.current_crossing_type_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.current_crossing_type_code IS 'The CURRENT CROSSING TYPE CODE is the code value defining the type of crossing present at the location of the stream crossing. Acceptable types are:OBS = Open Bottom StructureCBS = Closed Bottom StructureOTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN pscis_design_proposal_svw.current_crossing_type_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.current_crossing_type_desc IS 'CURRENT CROSSING TYPE DESC describes the CURRENT CROSSING TYPE.';


--
-- Name: COLUMN pscis_design_proposal_svw.current_crossing_subtype_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.current_crossing_subtype_code IS 'The CURRENT CROSSING SUBTYPE CODE further defines the value provided with the CURRENT CROSSING TYPE CODE. Valid subtypes depend on CURRENT CROSSING TYPE CODE. Acceptable values are BRIDGE, PIPE ARCH, WOOD BOX CULVERT, ROUND CULVERT, OVAL CULVERT.';


--
-- Name: COLUMN pscis_design_proposal_svw.current_crossing_subtype_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.current_crossing_subtype_desc IS 'CURRENT CROSSING SUBTYPE DESC describes the CUURENT CROSSING SUBTYPE.';


--
-- Name: COLUMN pscis_design_proposal_svw.current_barrier_result_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.current_barrier_result_code IS 'The CURRENT BARRIER RESULT CODE is the current evaluation of the crossing as a barrier to the fish passage, based on the FINAL SCORE value. Acceptable Values are: PASSABLE - Passable POTENTIAL - Potential Barrier BARRIER - Barrier UNKOWN - Other.';


--
-- Name: COLUMN pscis_design_proposal_svw.current_barrier_description; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.current_barrier_description IS 'CURRENT BARRIER DESCRIPTION describes the usage of the CURRENT BARRIER RESULT CODE.';


--
-- Name: COLUMN pscis_design_proposal_svw.feature_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.feature_code IS 'A feature code defines the standards for a spatial feature and is often used for defining cartography standards.';


--
-- Name: COLUMN pscis_design_proposal_svw.objectid; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_design_proposal_svw.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: pscis_design_proposal_svw_stream_crossing_id_seq; Type: SEQUENCE; Schema: whse_fish; Owner: -
--

CREATE SEQUENCE whse_fish.pscis_design_proposal_svw_stream_crossing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pscis_design_proposal_svw_stream_crossing_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_fish; Owner: -
--

ALTER SEQUENCE whse_fish.pscis_design_proposal_svw_stream_crossing_id_seq OWNED BY whse_fish.pscis_design_proposal_svw.stream_crossing_id;


--
-- Name: pscis_habitat_confirmation_svw; Type: TABLE; Schema: whse_fish; Owner: -
--

CREATE TABLE whse_fish.pscis_habitat_confirmation_svw (
    assmt_funding_project_number character varying(255),
    assmt_funding_project character varying(255),
    assmt_project_id numeric,
    assmt_funding_source character varying(10),
    assmt_responsible_party_name character varying(255),
    assmt_consultant_name character varying(255),
    assmt_date date,
    stream_crossing_id integer NOT NULL,
    habconf_assmt_id numeric,
    habconf_id numeric,
    external_crossing_reference character varying(50),
    crew_members character varying(255),
    utm_zone numeric,
    utm_easting numeric,
    utm_northing numeric,
    location_confidence_ind character varying(1),
    stream_name character varying(256),
    road_name character varying(256),
    road_km_mark numeric,
    road_tenure character varying(50),
    habconf_proceed_ind character varying(1),
    habconf_habitat_value_code character varying(10),
    habconf_habitat_value_desc character varying(120),
    habconf_habitat_value_rtle character varying(1000),
    habconf_verified_habitat_ind character varying(1),
    habconf_verified_habitat_len numeric,
    habconf_comments character varying(2000),
    habconf_ecocat_url character varying(200),
    habconf_image_view_url character varying(200),
    current_pscis_status character varying(25),
    current_crossing_type_code character varying(24),
    current_crossing_type_desc character varying(120),
    current_crossing_subtype_code character varying(24),
    current_crossing_subtype_desc character varying(120),
    current_barrier_result_code character varying(10),
    current_barrier_description character varying(120),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPoint,3005)
);


--
-- Name: TABLE pscis_habitat_confirmation_svw; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON TABLE whse_fish.pscis_habitat_confirmation_svw IS 'PSCIS_HABITAT_CONFIRMATION_SVW represents Habitat Confirmation of Stream Crossings. The Habitat Confirmation is carried out by a biologist who does an office and field review of the fish habitat to be potentially gained by remediation of an identified failed road crossing.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.assmt_funding_project_number; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.assmt_funding_project_number IS 'The ASSMT FUNDING PROJECT NUMBER is the identifier for the project and is usually related to the funding source. For example, ''9172001b'' is the FUNDING PROJECT NUMBER associated with the project who''s name is ''Fish Passage Culvert Inspections 2009, Kootenay Lake Forest District, Kootenay Lake TSA''.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.assmt_funding_project; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.assmt_funding_project IS 'The ASSMT FUNDING PROJECT is the identifier for the project and is usually related to the funding source. (e.g.  ''Fish Passage Culvert Inspections 2009, Kootenay Lake Forest District, Kootenay Lake TSA'')';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.assmt_project_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.assmt_project_id IS 'The ASSMT PROJECT ID is the system identifier for the project; this value is generated within PSCIS.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.assmt_funding_source; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.assmt_funding_source IS 'ASSMT FUNDING SOURCE defines the source of funding for the associated project. Eg. FIA';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.assmt_responsible_party_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.assmt_responsible_party_name IS 'The ASSMT RESPONSIBLE PARTY NAME is the name of the provided responsible party.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.assmt_consultant_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.assmt_consultant_name IS 'The ASSMT CONSULTANT NAME is the name of the provided consultant.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.assmt_date; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.assmt_date IS 'The ASSMT DATE is the date when the assessment was completed.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.stream_crossing_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.stream_crossing_id IS 'The STREAM CROSSING ID is the unique identifier for the STREAM CROSSING LOCATION POINT.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_assmt_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_assmt_id IS 'HABCONF ASSMT ID is the HABITAT CONFIRMATION ASSESSMENT ID  that is the unique identifier for the CROSSING ASSESSMENT.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_id IS 'HABCONF ID is the HABITAT CONFIRMATION ID that is the unique identifier for the HABITAT CONFIRMATION.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.external_crossing_reference; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.external_crossing_reference IS 'The EXTERNAL CROSSING REFERENCE identifies the submitters name used to reference a stream crossing.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.crew_members; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.crew_members IS 'CREW MEMEBERS are the initials of the crew members taking measurements usually delimited by commas.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.utm_zone; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.utm_zone IS 'UTM ZONE is a segment of the Earth''s surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.utm_easting; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.utm_northing; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.location_confidence_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.location_confidence_ind IS 'The LOCATION CONFIDENCE IND may indicate if this spatial point is a duplicate. Allowable values are ''Y'' and ''N''';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.stream_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.stream_name IS 'The STREAM NAME is the mapped stream name. If no name is given for the watercourse, then the parent tributary name is used (i.e. Tributary to Bear Creek)';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.road_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.road_name IS 'The ROAD NAME is the name of the road at the crossing, usually a forest road.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.road_km_mark; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.road_km_mark IS 'The ROAD KM MARK is the road kilometre position of the crossing to the nearest 0.01 km, matching the kilometre markers, if present.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.road_tenure; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.road_tenure IS 'The ROAD TENURE is the best available ID for the road at the time of assessment. For example, the Forest File Id of a Road Permit or Forest Service Road.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_proceed_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_proceed_ind IS 'the HABCONF PROCEED IND indicator identifies if the site is suitable for proceeding to the design phase of the project, based on the habitat assessment.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_habitat_value_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_habitat_value_code IS 'The HABCONF HABITAT VALUE CODE is a code value describing the evaluated habitat at a crossing site. Particular emphasis is on habitat upstream of the CBS as this is the habitat that will be gained when fish passage is restored. Acceptable values are HIGH, MEDIUM and LOW.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_habitat_value_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_habitat_value_desc IS 'HABCONF HABITAT VALUE DESC describes the usage of the code value.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_habitat_value_rtle; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_habitat_value_rtle IS 'The HABCONF HABITAT VALUE RTLE is a brief description or rationale of the basic quality of the local habitat. Used for determining the importance or necessity of the remediation proposal.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_verified_habitat_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_verified_habitat_ind IS 'The HABCONF VERIFIED HABITAT IND indicator determines if there is a known downstream habitat. A value of Y indicates there is a known downstream habitat. A value of N indicates there is not.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_verified_habitat_len; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_verified_habitat_len IS 'The HABCONF VERIFIED HABITAT LEN is the field verified habitat length in linear metres (to the nearest metre).';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_comments; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_comments IS 'The HABCONF COMMENTS attribute defines any other comments that are relative to the Habtitat Confirmation.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_ecocat_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_ecocat_url IS 'HABCONF ECOCAT URL is a URL pointing at Ecocat for the related project. e.g., http://a100.gov.bc.ca/pub/acat/public/advancedSearch.do?keywords=PSCIS[ASSMT_PROJECT_ID]';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.habconf_image_view_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.habconf_image_view_url IS 'HABCONF IMAGE VIEW URL  is a URL pointing at an HTML display of the Habitat Confirmation attachments. e.g., http://a100.gov.bc.ca/pub/pscismap/imageViewer.do?habitatconfirmationid=[HABCONF_ID]';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.current_pscis_status; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.current_pscis_status IS 'CURRENT PSCIS STATUS defines the current status of the crossing as either assessed, designed, or remediated. Defines the current status of the crossing as either assessed, designed, or remediated.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.current_crossing_type_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.current_crossing_type_code IS 'The CURRENT CROSSING TYPE CODE is the code value defining the type of crossing present at the location of the stream crossing. Acceptable types are:OBS = Open Bottom StructureCBS = Closed Bottom StructureOTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.current_crossing_type_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.current_crossing_type_desc IS 'CURRENT CROSSING TYPE DESC describes the CURRENT CROSSING TYPE.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.current_crossing_subtype_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.current_crossing_subtype_code IS 'The CURRENT CROSSING SUBTYPE CODE further defines the value provided with the CURRENT CROSSING TYPE CODE. Valid subtypes depend on CURRENT CROSSING TYPE CODE. Acceptable values are BRIDGE, PIPE ARCH, WOOD BOX CULVERT, ROUND CULVERT, OVAL CULVERT.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.current_crossing_subtype_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.current_crossing_subtype_desc IS 'CURRENT CROSSING SUBTYPE DESC describes the CUURENT CROSSING SUBTYPE.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.current_barrier_result_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.current_barrier_result_code IS 'The CURRENT BARRIER RESULT CODE is the current evaluation of the crossing as a barrier to the fish passage, based on the FINAL SCORE value. Acceptable Values are: PASSABLE - Passable POTENTIAL - Potential Barrier BARRIER - Barrier UNKOWN - Other.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.current_barrier_description; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.current_barrier_description IS 'CURRENT BARRIER DESCRIPTION describes the usage of the CURRENT BARRIER RESULT CODE.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.feature_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.feature_code IS 'FEATURE CODE contains a value based on the Canadian Council of Surveys and Mapping’s (CCSM) system for classification of geographic features.';


--
-- Name: COLUMN pscis_habitat_confirmation_svw.objectid; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_habitat_confirmation_svw.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: pscis_habitat_confirmation_svw_stream_crossing_id_seq; Type: SEQUENCE; Schema: whse_fish; Owner: -
--

CREATE SEQUENCE whse_fish.pscis_habitat_confirmation_svw_stream_crossing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pscis_habitat_confirmation_svw_stream_crossing_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_fish; Owner: -
--

ALTER SEQUENCE whse_fish.pscis_habitat_confirmation_svw_stream_crossing_id_seq OWNED BY whse_fish.pscis_habitat_confirmation_svw.stream_crossing_id;


--
-- Name: pscis_remediation_svw; Type: TABLE; Schema: whse_fish; Owner: -
--

CREATE TABLE whse_fish.pscis_remediation_svw (
    funding_project_number character varying(255),
    funding_project character varying(255),
    project_id numeric,
    funding_source character varying(10),
    responsible_party_name character varying(255),
    consultant_name character varying(255),
    completion_date date,
    stream_crossing_id integer NOT NULL,
    remediation_id numeric,
    external_crossing_reference character varying(50),
    utm_zone numeric,
    utm_easting numeric,
    utm_northing numeric,
    location_confidence_ind character varying(1),
    stream_name character varying(256),
    road_name character varying(256),
    road_km_mark numeric,
    road_tenure character varying(50),
    crossing_type_code character varying(24),
    crossing_type_desc character varying(120),
    crossing_subtype_code character varying(24),
    crossing_subtype_desc character varying(120),
    crossing_fix_code character varying(10),
    crossing_fix_desc character varying(120),
    diameter_or_span numeric,
    length_or_width numeric,
    remediation_cost numeric,
    habconf_verified_habitat_len numeric,
    remed_cost_benefit numeric,
    ecocat_url character varying(200),
    image_view_url character varying(200),
    current_pscis_status character varying(25),
    current_crossing_type_code character varying(24),
    current_crossing_type_desc character varying(120),
    current_crossing_subtype_code character varying(24),
    current_crossing_subtype_desc character varying(120),
    current_barrier_result_code character varying(10),
    current_barrier_description character varying(120),
    feature_code character varying(10),
    objectid numeric,
    geom public.geometry(MultiPoint,3005)
);


--
-- Name: TABLE pscis_remediation_svw; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON TABLE whse_fish.pscis_remediation_svw IS 'This view defines all the stream crossing locations that have had remediation activities take place.';


--
-- Name: COLUMN pscis_remediation_svw.funding_project_number; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.funding_project_number IS 'The FUNDING PROJECT NUMBER is the identifier for the project and is usually related to the funding source. For example, ''9172001b'' is the FUNDING PROJECT NUMBER associated with the project who''s name is ''Fish Passage Culvert Inspections 2009, Kootenay Lake Forest District, Kootenay Lake TSA''.';


--
-- Name: COLUMN pscis_remediation_svw.funding_project; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.funding_project IS 'The FUNDING PROJECT is the identifier for the project and is usually related to the funding source. (e.g. ''Fish Passage Culvert Inspections 2009, Kootenay Lake Forest District, Kootenay Lake TSA'')';


--
-- Name: COLUMN pscis_remediation_svw.project_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.project_id IS 'The PROJECT ID is the system identifier for the project; this value is generated within PSCIS.';


--
-- Name: COLUMN pscis_remediation_svw.funding_source; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.funding_source IS 'FUNDING SOURCE defines the source of funding for the associated project. Eg. FIA';


--
-- Name: COLUMN pscis_remediation_svw.responsible_party_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.responsible_party_name IS 'The RESPONSIBLE PARTY NAME is the name of the provided responsible party.';


--
-- Name: COLUMN pscis_remediation_svw.consultant_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.consultant_name IS 'The CONSULTANT NAME is the name of the provided consultant.';


--
-- Name: COLUMN pscis_remediation_svw.completion_date; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.completion_date IS 'The COMPLETION DATE is the date in which the remediation was completed.';


--
-- Name: COLUMN pscis_remediation_svw.stream_crossing_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.stream_crossing_id IS 'The STREAM CROSSING ID is the unique identifier for the STREAM CROSSING LOCATION POINT.';


--
-- Name: COLUMN pscis_remediation_svw.remediation_id; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.remediation_id IS 'The REMEDIATION ID is the unique identifier for a Remediation.';


--
-- Name: COLUMN pscis_remediation_svw.external_crossing_reference; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.external_crossing_reference IS 'The EXTERNAL CROSSING REFERENCE identifies the submitters name used to reference a stream crossing.';


--
-- Name: COLUMN pscis_remediation_svw.utm_zone; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.utm_zone IS 'UTM ZONE is a segment of the Earth''s surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';


--
-- Name: COLUMN pscis_remediation_svw.utm_easting; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';


--
-- Name: COLUMN pscis_remediation_svw.utm_northing; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';


--
-- Name: COLUMN pscis_remediation_svw.location_confidence_ind; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.location_confidence_ind IS 'The LOCATION CONFIDENCE IND may indicate if this spatial point is a duplicate. Allowable values are ''Y'' and ''N''';


--
-- Name: COLUMN pscis_remediation_svw.stream_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.stream_name IS 'The STREAM NAME is the mapped stream name. If no name is given for the watercourse, then the parent tributary name is used (i.e. Tributary to Bear Creek)';


--
-- Name: COLUMN pscis_remediation_svw.road_name; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.road_name IS 'The ROAD NAME is the name of the road at the crossing, usually a forest road.';


--
-- Name: COLUMN pscis_remediation_svw.road_km_mark; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.road_km_mark IS 'The ROAD KM MARK is the road kilometre position of the crossing to the nearest 0.01 km, matching the kilometre markers, if present.';


--
-- Name: COLUMN pscis_remediation_svw.road_tenure; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.road_tenure IS 'The ROAD TENURE is the best available ID for the road at the time of assessment. For example, the Forest File Id of a Road Permit or Forest Service Road.';


--
-- Name: COLUMN pscis_remediation_svw.crossing_type_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.crossing_type_code IS 'The CROSSING TYPE CODE is the code value defining the type of crossing after the remediation effort. Acceptable types are:OBS = Open Bottom StructureCBS = Closed Bottom StructureOTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN pscis_remediation_svw.crossing_type_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.crossing_type_desc IS 'CROSSING TYPE DESC describes the CROSSING TYPE CODE.';


--
-- Name: COLUMN pscis_remediation_svw.crossing_subtype_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.crossing_subtype_code IS 'The CROSSING SUBTYPE CODE further defines the value provided with a CROSSING TYPE CODE. Valid subtypes depend on REMED CROSSING TYPE CODE. Acceptable values are BRIDGE, PIPE ARCH, WOOD BOX CULVERT, ROUND CULVERT, OVAL CULVERT.';


--
-- Name: COLUMN pscis_remediation_svw.crossing_subtype_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.crossing_subtype_desc IS 'CROSSING SUBTYPE DESC describes the CROSSING SUBTYPE CODE.';


--
-- Name: COLUMN pscis_remediation_svw.crossing_fix_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.crossing_fix_code IS 'The CROSSING FIX CODE defines the the crossing fix performed by the remediation. Acceptable values are:RM - RemovalOBS - Open Bottom StructureSS - Streambed SimulationEM - Additional substrate material and/or downstream weirsBW - Backwater';


--
-- Name: COLUMN pscis_remediation_svw.crossing_fix_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.crossing_fix_desc IS 'CROSSING FIX DESC describes the CROSSING FIX CODE.';


--
-- Name: COLUMN pscis_remediation_svw.diameter_or_span; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.diameter_or_span IS 'The DIAMETER OR SPAN is the measured structure diameter in metres, to the nearest 0.01m if it is a culvert. If it is an open bottomed structure, record a span value in metres to the nearest 0.01m.';


--
-- Name: COLUMN pscis_remediation_svw.length_or_width; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.length_or_width IS 'The LENGTH OR WIDTH is the length of the structure in metres, to the nearest 0.01m if it is a culvert. If it is a closed bottom structure enter a width value in metres, to the nearest 0.01m.';


--
-- Name: COLUMN pscis_remediation_svw.remediation_cost; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.remediation_cost IS 'The REMEDIATION COST is the final total cost for the remediation.';


--
-- Name: COLUMN pscis_remediation_svw.habconf_verified_habitat_len; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.habconf_verified_habitat_len IS 'The HABCONF VERIFIED HABITAT LEN is the field verified habitat length in linear metres (to the nearest metre).';


--
-- Name: COLUMN pscis_remediation_svw.remed_cost_benefit; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.remed_cost_benefit IS 'The REMED COST BENEFIT  is an evaluation of the benefit received by remediating the stream crossing. (REMEDIATION COST / VERIFIED HABITAT LENGTH)';


--
-- Name: COLUMN pscis_remediation_svw.ecocat_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.ecocat_url IS 'A URL pointing at Ecocat for the related project.';


--
-- Name: COLUMN pscis_remediation_svw.image_view_url; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.image_view_url IS 'A URL pointing at an HTML display of the attachments.';


--
-- Name: COLUMN pscis_remediation_svw.current_pscis_status; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.current_pscis_status IS 'CURRENT PSCIS STATUS defines the current status of the crossing as either assessed, designed, or remediated. Defines the current status of the crossing as either assessed, designed, or remediated.';


--
-- Name: COLUMN pscis_remediation_svw.current_crossing_type_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.current_crossing_type_code IS 'The CURRENT CROSSING TYPE CODE is the code value defining the type of crossing present at the location of the stream crossing. Acceptable types are:OBS = Open Bottom StructureCBS = Closed Bottom StructureOTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN pscis_remediation_svw.current_crossing_type_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.current_crossing_type_desc IS 'CURRENT CROSSING TYPE DESC describes the CURRENT CROSSING TYPE.';


--
-- Name: COLUMN pscis_remediation_svw.current_crossing_subtype_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.current_crossing_subtype_code IS 'The CURRENT CROSSING SUBTYPE CODE further defines the value provided with the CURRENT CROSSING TYPE CODE. Valid subtypes depend on CURRENT CROSSING TYPE CODE. Acceptable values are BRIDGE, PIPE ARCH, WOOD BOX CULVERT, ROUND CULVERT, OVAL CULVERT.';


--
-- Name: COLUMN pscis_remediation_svw.current_crossing_subtype_desc; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.current_crossing_subtype_desc IS 'CURRENT CROSSING SUBTYPE DESC describes the CUURENT CROSSING SUBTYPE.';


--
-- Name: COLUMN pscis_remediation_svw.current_barrier_result_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.current_barrier_result_code IS 'The CURRENT BARRIER RESULT CODE is the current evaluation of the crossing as a barrier to the fish passage, based on the FINAL SCORE value. Acceptable Values are: PASSABLE - Passable POTENTIAL - Potential Barrier BARRIER - Barrier UNKOWN - Other.';


--
-- Name: COLUMN pscis_remediation_svw.current_barrier_description; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.current_barrier_description IS 'CURRENT BARRIER DESCRIPTION describes the usage of the CURRENT BARRIER RESULT CODE.';


--
-- Name: COLUMN pscis_remediation_svw.feature_code; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.feature_code IS 'A feature code defines the standards for a spatial feature and is often used for defining cartography standards.';


--
-- Name: COLUMN pscis_remediation_svw.objectid; Type: COMMENT; Schema: whse_fish; Owner: -
--

COMMENT ON COLUMN whse_fish.pscis_remediation_svw.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: pscis_remediation_svw_stream_crossing_id_seq; Type: SEQUENCE; Schema: whse_fish; Owner: -
--

CREATE SEQUENCE whse_fish.pscis_remediation_svw_stream_crossing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pscis_remediation_svw_stream_crossing_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_fish; Owner: -
--

ALTER SEQUENCE whse_fish.pscis_remediation_svw_stream_crossing_id_seq OWNED BY whse_fish.pscis_remediation_svw.stream_crossing_id;


--
-- Name: wdic_waterbodies; Type: TABLE; Schema: whse_fish; Owner: -
--

CREATE TABLE whse_fish.wdic_waterbodies (
    id integer NOT NULL,
    type text,
    extinct_indicator text,
    watershed_id integer,
    sequence_number text,
    waterbody_identifier text,
    gazetted_name text,
    waterbody_mouth_identifier text,
    formatted_name text
);


--
-- Name: ften_managed_licence_poly_svw; Type: TABLE; Schema: whse_forest_tenure; Owner: -
--

CREATE TABLE whse_forest_tenure.ften_managed_licence_poly_svw (
    forest_file_id character varying(10),
    map_block_id character varying(10),
    ml_type_code character varying(10),
    ml_comment character varying(255),
    retirement_date date,
    amendment_id numeric,
    map_label character varying(30),
    feature_area numeric,
    feature_perimeter numeric,
    client_number character varying(8),
    client_name character varying(91),
    feature_class_skey numeric,
    file_status_code character varying(3),
    admin_district_code character varying(6),
    admin_district_name character varying(100),
    life_cycle_status_code character varying(10),
    objectid integer NOT NULL,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE ften_managed_licence_poly_svw; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON TABLE whse_forest_tenure.ften_managed_licence_poly_svw IS 'Community Forest Schedule A and B, Wood Lot License Schedule A and B. The Forest Tenures Section (FTS) is responsible for the creation and maintenance of digital Forest Atlas files for the province of British Columbia encompassing Forest and Range';


--
-- Name: COLUMN ften_managed_licence_poly_svw.forest_file_id; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.forest_file_id IS 'File identification assigned to Provincial Forest Use files. Assigned file number. Usually the Licence, Tenure or Private Mark number.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.map_block_id; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.map_block_id IS 'Identifier for a Managed Licence map block.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.ml_type_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.ml_type_code IS 'The type of Managed Licence.  Either Schedule A or Schedule B.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.ml_comment; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.ml_comment IS 'A comment about this managed licence.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.retirement_date; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.retirement_date IS 'The Date and time the managed licence feature was retired.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.amendment_id; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.amendment_id IS 'The amendment id for the instance';


--
-- Name: COLUMN ften_managed_licence_poly_svw.map_label; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.map_label IS 'The default label to be used when displaying the feature on a map.  Consists of the FOREST_FILE_ID, MAP_BLOCK_ID and ML_TYPE_CODE';


--
-- Name: COLUMN ften_managed_licence_poly_svw.feature_area; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.feature_area IS 'Spatial feature area in square metres. This value is calculated.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.feature_perimeter; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.feature_perimeter IS 'Spatial perimeter length in metres. This value is calculated.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.client_number; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.client_number IS 'Sequentially assigned number to identify a ministry client.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.client_name; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.client_name IS 'The name of the Ministry Client - Company or Individual.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.feature_class_skey; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.feature_class_skey IS 'Unique identifier for a spatial feature class.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.file_status_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.file_status_code IS 'The current status of the forest land use, eg., Pending - Planned, Harvesting - Suspended, Active. This is a subset of Timber_Status_Code.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.admin_district_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.admin_district_code IS 'The code of the district in which the road section is located.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.admin_district_name; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.admin_district_name IS 'The name of the district in which the road section is located.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.life_cycle_status_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.life_cycle_status_code IS 'The life cycle state of the item.  One of Pending, Active or Retired.';


--
-- Name: COLUMN ften_managed_licence_poly_svw.objectid; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_managed_licence_poly_svw.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase. ';


--
-- Name: ften_managed_licence_poly_svw_objectid_seq; Type: SEQUENCE; Schema: whse_forest_tenure; Owner: -
--

CREATE SEQUENCE whse_forest_tenure.ften_managed_licence_poly_svw_objectid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ften_managed_licence_poly_svw_objectid_seq; Type: SEQUENCE OWNED BY; Schema: whse_forest_tenure; Owner: -
--

ALTER SEQUENCE whse_forest_tenure.ften_managed_licence_poly_svw_objectid_seq OWNED BY whse_forest_tenure.ften_managed_licence_poly_svw.objectid;


--
-- Name: ften_range_poly_svw_objectid_seq; Type: SEQUENCE; Schema: whse_forest_tenure; Owner: -
--

CREATE SEQUENCE whse_forest_tenure.ften_range_poly_svw_objectid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ften_range_poly_svw_objectid_seq; Type: SEQUENCE OWNED BY; Schema: whse_forest_tenure; Owner: -
--

ALTER SEQUENCE whse_forest_tenure.ften_range_poly_svw_objectid_seq OWNED BY whse_forest_tenure.ften_range_poly_svw.objectid;


--
-- Name: ften_road_section_lines_svw; Type: TABLE; Schema: whse_forest_tenure; Owner: -
--

CREATE TABLE whse_forest_tenure.ften_road_section_lines_svw (
    forest_file_id character varying(10),
    road_section_id character varying(30),
    feature_class_skey numeric,
    road_section_name character varying(100),
    road_section_length numeric,
    retirement_date date,
    section_width numeric,
    feature_length numeric,
    amendment_id numeric,
    file_status_code character varying(3),
    file_type_code character varying(3),
    file_type_description character varying(120),
    geographic_district_code character varying(6),
    geographic_district_name character varying(100),
    award_date date,
    expiry_date date,
    client_number character varying(8),
    client_location_code character varying(2),
    client_name character varying(91),
    location character varying(120),
    life_cycle_status_code character varying(10),
    map_label character varying(41),
    objectid numeric,
    geom public.geometry(MultiLineString,3005)
);


--
-- Name: TABLE ften_road_section_lines_svw; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON TABLE whse_forest_tenure.ften_road_section_lines_svw IS 'The spatial representation of the road sections within an RP - Road Permit, FSR - Forest Service Road, or SUP - Special Use Permit road.  The geometry is the centre line of the road section.';


--
-- Name: COLUMN ften_road_section_lines_svw.forest_file_id; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.forest_file_id IS 'File identification assigned to Provincial Forest Use files. Assigned file number. Usually the Licence, Tenure or Private Mark number.';


--
-- Name: COLUMN ften_road_section_lines_svw.road_section_id; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.road_section_id IS 'Identifies one section of a road within a road permit.';


--
-- Name: COLUMN ften_road_section_lines_svw.feature_class_skey; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.feature_class_skey IS 'Unique identifier for a spatial feature class.';


--
-- Name: COLUMN ften_road_section_lines_svw.road_section_name; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.road_section_name IS 'The name assigned to one section of road within a road permit.';


--
-- Name: COLUMN ften_road_section_lines_svw.road_section_length; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.road_section_length IS 'The length of the road section in km.';


--
-- Name: COLUMN ften_road_section_lines_svw.retirement_date; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.retirement_date IS 'The date the road section was retired from the spatial conflict layer.';


--
-- Name: COLUMN ften_road_section_lines_svw.section_width; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.section_width IS 'Identifies the width of the road section in metres.';


--
-- Name: COLUMN ften_road_section_lines_svw.feature_length; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.feature_length IS 'Spatial feature length in metres. This value is calculated.';


--
-- Name: COLUMN ften_road_section_lines_svw.amendment_id; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.amendment_id IS 'The amendment id for the road section.';


--
-- Name: COLUMN ften_road_section_lines_svw.file_status_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.file_status_code IS 'The current status of the forest land use.';


--
-- Name: COLUMN ften_road_section_lines_svw.file_type_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.file_type_code IS 'The code to indicate the type of file, and often synonymous with a tenure or a project.';


--
-- Name: COLUMN ften_road_section_lines_svw.file_type_description; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.file_type_description IS 'Description of the file type.';


--
-- Name: COLUMN ften_road_section_lines_svw.geographic_district_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.geographic_district_code IS 'The code of the district in which the road section is located.';


--
-- Name: COLUMN ften_road_section_lines_svw.geographic_district_name; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.geographic_district_name IS 'The name of the district in which the road section is located.';


--
-- Name: COLUMN ften_road_section_lines_svw.award_date; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.award_date IS 'The first day of the tenure. The day the tenure legally starts.';


--
-- Name: COLUMN ften_road_section_lines_svw.expiry_date; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.expiry_date IS 'Latest expiry date due to extensions.';


--
-- Name: COLUMN ften_road_section_lines_svw.client_number; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.client_number IS 'Sequentially assigned number to identify a ministry client.';


--
-- Name: COLUMN ften_road_section_lines_svw.client_location_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.client_location_code IS 'A code to uniquely identify, within each client, the addresses of different divisions or locations at which the client operates.';


--
-- Name: COLUMN ften_road_section_lines_svw.client_name; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.client_name IS 'The name of the Ministry Client - Company or Individual. Entered as: the full corporate name if a Corporation; the full registered name if a Partnership; the legal name if an Individual.';


--
-- Name: COLUMN ften_road_section_lines_svw.location; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.location IS 'Identifies the location of the road tenure.';


--
-- Name: COLUMN ften_road_section_lines_svw.life_cycle_status_code; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.life_cycle_status_code IS 'The life cycle state of the item.  One of Pending, Active or Retired.';


--
-- Name: COLUMN ften_road_section_lines_svw.map_label; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.map_label IS 'The default label to be used when displaying the feature on a map.  Consists of the FOREST_FILE_ID and the ROAD_SECTION_ID.';


--
-- Name: COLUMN ften_road_section_lines_svw.objectid; Type: COMMENT; Schema: whse_forest_tenure; Owner: -
--

COMMENT ON COLUMN whse_forest_tenure.ften_road_section_lines_svw.objectid IS 'OBJECTID is a required attribute of feature classes and object classes in a geodatabase. ';


--
-- Name: ogsr_priority_def_area_cur_sp; Type: TABLE; Schema: whse_forest_vegetation; Owner: -
--

CREATE TABLE whse_forest_vegetation.ogsr_priority_def_area_cur_sp (
    ogsr_pdac_sysid integer NOT NULL,
    current_priority_deferral_id numeric,
    tap_priority_deferral_id numeric,
    tap_classification_label character varying(100),
    priority_big_treed_og_id numeric,
    ancient_forest_id numeric,
    remnant_old_ecosys_id numeric,
    priority_big_treed_og_descr character varying(40),
    ancient_forest_descr character varying(40),
    remnant_old_ecosys_descr character varying(40),
    region_name character varying(100),
    district_name character varying(100),
    landscape_unit_provid character varying(100),
    landscape_unit_name character varying(100),
    landscape_unit_number character varying(10),
    bgc_label character varying(50),
    source character varying(20),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE ogsr_priority_def_area_cur_sp; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON TABLE whse_forest_vegetation.ogsr_priority_def_area_cur_sp IS 'The current view of the priority old growth deferrals.  Includes updates from licensee field verification submissions.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.ogsr_pdac_sysid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.ogsr_pdac_sysid IS 'A system generated unique identification number.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.current_priority_deferral_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.current_priority_deferral_id IS 'A unique ID for each polygon that is classified as priority old growth in this current view dataset.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.tap_priority_deferral_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.tap_priority_deferral_id IS 'The original ID for each polygon that were classified as priority old growth in the TAP Old Gorwth Priority Deferral dataset.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.tap_classification_label; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.tap_classification_label IS 'The type of deferral, i.e., Priority deferral area.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.priority_big_treed_og_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.priority_big_treed_og_id IS 'The unique ID of the Priority Big-Treed Old Growth polygon contained in the area';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.ancient_forest_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.ancient_forest_id IS 'The unique ID of the Ancient Forest polygon contained in the area';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.remnant_old_ecosys_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.remnant_old_ecosys_id IS 'The unique ID of the Remnant Ecosystem Forest polygon contained in the area';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.priority_big_treed_og_descr; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.priority_big_treed_og_descr IS 'Identifying if an area is priority big-treed old growth, classified as either: Big-Treed Old Forest, Big-Treed Older Mature Forest, or Null.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.ancient_forest_descr; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.ancient_forest_descr IS 'Identifying if an area is ancient forest, classified as either: Ancient at 250+ years old, Ancient at 400+ years old or Null.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.remnant_old_ecosys_descr; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.remnant_old_ecosys_descr IS 'Identifying if an area is remnant old ecosystem, classified as either: Remnant at BEC subzone/variant scale, Remnant at landscape unit scale, or Null.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.region_name; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.region_name IS 'The long name of the Natural Resource Region e.g., Kootenay Boundary Region';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.district_name; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.district_name IS 'The long name of the Natural Resource District e.g., Selkirk District';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.landscape_unit_provid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.landscape_unit_provid IS 'The provincial identifier. Unique for any polygon (or collection of polygons for Landscape Units managed with distinct attribute values) that does not have a retirement date. Not unique for polygon features with multiple retirements. This identifier stays with the polygon feature over time as the feature changes.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.landscape_unit_name; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.landscape_unit_name IS 'The name assigned to the unit, and the unit is a spatially identified area of land and/or water used for long-term planning of resource management activities e.g., Tatshenshini River.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.landscape_unit_number; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.landscape_unit_number IS 'The regional identifier, e.g. "C37", assigned to the unit';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.bgc_label; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.bgc_label IS 'A code uniquely identifying a Biogeoclimatic Zone in BEC version 12. It is a concatenation of zone, subzone and variant e.g., ICH mw 5.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.source; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.source IS 'The source of the priority old gorwth deferral, classified as either TAP Deferral or Field Verification.';


--
-- Name: COLUMN ogsr_priority_def_area_cur_sp.objectid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.ogsr_priority_def_area_cur_sp.objectid IS 'A column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: ogsr_priority_def_area_cur_sp_ogsr_pdac_sysid_seq; Type: SEQUENCE; Schema: whse_forest_vegetation; Owner: -
--

CREATE SEQUENCE whse_forest_vegetation.ogsr_priority_def_area_cur_sp_ogsr_pdac_sysid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ogsr_priority_def_area_cur_sp_ogsr_pdac_sysid_seq; Type: SEQUENCE OWNED BY; Schema: whse_forest_vegetation; Owner: -
--

ALTER SEQUENCE whse_forest_vegetation.ogsr_priority_def_area_cur_sp_ogsr_pdac_sysid_seq OWNED BY whse_forest_vegetation.ogsr_priority_def_area_cur_sp.ogsr_pdac_sysid;


--
-- Name: veg_burn_severity_same_yr_sp; Type: TABLE; Schema: whse_forest_vegetation; Owner: -
--

CREATE TABLE whse_forest_vegetation.veg_burn_severity_same_yr_sp (
    brn_svy_sy_sysid numeric,
    fire_number character varying(10),
    fire_year numeric,
    burn_severity_rating character varying(10),
    pre_fire_image character varying(254),
    pre_fire_image_date date,
    post_fire_image character varying(254),
    post_fire_image_date date,
    area_ha numeric,
    comments character varying(254),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE veg_burn_severity_same_yr_sp; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON TABLE whse_forest_vegetation.veg_burn_severity_same_yr_sp IS 'Burn severity mapping for the same year wildfire season for fires that are 100 ha or greater in area.  The burn severity mapping is conducted using current season pre- and post-fire multispectral satellite imagery (Sentinel-2, Landsat-8/9).';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.brn_svy_sy_sysid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.brn_svy_sy_sysid IS 'A system generated unique identification number.';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.fire_number; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.fire_number IS 'A composite of the following fields: Zone, Fire ID and Fire Centre. From BC Wildfire Service.';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.fire_year; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.fire_year IS 'Represents the fire year.';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.burn_severity_rating; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.burn_severity_rating IS 'A classification of wildfire impact on the landscape (Unburned, Low, Medium, High, and Unknown).';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.pre_fire_image; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.pre_fire_image IS 'The scene ID of the pre-fire image.';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.pre_fire_image_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.pre_fire_image_date IS 'The acquisition date of the pre-fire image.';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.post_fire_image; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.post_fire_image IS 'The scene ID of the post-fire image.';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.post_fire_image_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.post_fire_image_date IS 'The acquisition date of the post-fire image.';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.area_ha; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.area_ha IS 'The system calculated area in hectares.';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.comments; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.comments IS 'Describes why features have a value of unknown in the Burn Severity Rating or any additional data quality information.';


--
-- Name: COLUMN veg_burn_severity_same_yr_sp.objectid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_same_yr_sp.objectid IS 'A column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: veg_burn_severity_sp; Type: TABLE; Schema: whse_forest_vegetation; Owner: -
--

CREATE TABLE whse_forest_vegetation.veg_burn_severity_sp (
    veg_fs_sysid numeric,
    fire_number character varying(6),
    fire_year numeric,
    burn_severity_rating character varying(10),
    pre_fire_image character varying(254),
    pre_fire_image_date date,
    post_fire_image character varying(254),
    post_fire_image_date date,
    area_ha numeric,
    comments character varying(254),
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE veg_burn_severity_sp; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON TABLE whse_forest_vegetation.veg_burn_severity_sp IS 'Burn Severity Rating for multiple years, starting in 2015 for the province of BC.';


--
-- Name: COLUMN veg_burn_severity_sp.veg_fs_sysid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.veg_fs_sysid IS 'VEG_FS_SYSID is a system generated unique identification number.';


--
-- Name: COLUMN veg_burn_severity_sp.fire_number; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.fire_number IS 'FIRE_NUMBER is a composite of the following fields: Zone, Fire ID and Fire Centre.';


--
-- Name: COLUMN veg_burn_severity_sp.fire_year; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.fire_year IS 'FIRE_YEAR represents the fiscal year, April 1 to March 31.';


--
-- Name: COLUMN veg_burn_severity_sp.burn_severity_rating; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.burn_severity_rating IS 'BURN_SEVERITY_RATING is rating of the severity to the fire, i.e., High, Moderate, Low, Unburned, Unknown.';


--
-- Name: COLUMN veg_burn_severity_sp.pre_fire_image; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.pre_fire_image IS 'PRE_FIRE_IMAGE is the file name of the image used before the fire.';


--
-- Name: COLUMN veg_burn_severity_sp.pre_fire_image_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.pre_fire_image_date IS 'PRE_FIRE_IMAGE_DATE is the date of the image used before the fire.';


--
-- Name: COLUMN veg_burn_severity_sp.post_fire_image; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.post_fire_image IS 'POST_FIRE_IMAGE is the file name of the image used after the fire.';


--
-- Name: COLUMN veg_burn_severity_sp.post_fire_image_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.post_fire_image_date IS 'POST_FIRE_IMAGE_DATE is the date of the image used after the fire.';


--
-- Name: COLUMN veg_burn_severity_sp.area_ha; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.area_ha IS 'AREA_HA contains the system calculated area in hectares.';


--
-- Name: COLUMN veg_burn_severity_sp.comments; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.comments IS 'COMMENTS is used to explain why features have a value of unknown in the Burn Severity Rating.';


--
-- Name: COLUMN veg_burn_severity_sp.objectid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_burn_severity_sp.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: veg_comp_lyr_r1_poly; Type: TABLE; Schema: whse_forest_vegetation; Owner: -
--

CREATE TABLE whse_forest_vegetation.veg_comp_lyr_r1_poly (
    feature_id integer NOT NULL,
    map_id character varying(7),
    polygon_id numeric,
    opening_ind character varying(1),
    opening_source character varying(5),
    opening_number character varying(4),
    feature_class_skey numeric,
    inventory_standard_cd character varying(10),
    polygon_area numeric,
    non_productive_descriptor_cd character varying(5),
    non_productive_cd character varying(10),
    input_date date,
    coast_interior_cd character varying(1),
    surface_expression character varying(10),
    modifying_process character varying(10),
    site_position_meso character varying(10),
    alpine_designation character varying(10),
    soil_nutrient_regime character varying(10),
    ecosys_class_data_src_cd character varying(10),
    bclcs_level_1 character varying(10),
    bclcs_level_2 character varying(10),
    bclcs_level_3 character varying(10),
    bclcs_level_4 character varying(10),
    bclcs_level_5 character varying(10),
    interpretation_date date,
    project character varying(100),
    reference_year numeric,
    special_cruise_number numeric,
    special_cruise_number_cd character varying(1),
    inventory_region numeric,
    compartment numeric,
    compartment_letter character varying(1),
    fiz_cd character varying(1),
    for_mgmt_land_base_ind character varying(1),
    attribution_base_date date,
    projected_date date,
    shrub_height numeric,
    shrub_crown_closure numeric,
    shrub_cover_pattern character varying(10),
    herb_cover_type character varying(10),
    herb_cover_pattern character varying(10),
    herb_cover_pct numeric,
    bryoid_cover_pct numeric,
    non_veg_cover_pattern_1 character varying(10),
    non_veg_cover_pct_1 numeric,
    non_veg_cover_type_1 character varying(10),
    non_veg_cover_pattern_2 character varying(10),
    non_veg_cover_pct_2 numeric,
    non_veg_cover_type_2 character varying(10),
    non_veg_cover_pattern_3 character varying(10),
    non_veg_cover_pct_3 numeric,
    non_veg_cover_type_3 character varying(10),
    land_cover_class_cd_1 character varying(10),
    est_coverage_pct_1 numeric,
    soil_moisture_regime_1 character varying(10),
    land_cover_class_cd_2 character varying(10),
    est_coverage_pct_2 numeric,
    soil_moisture_regime_2 character varying(10),
    land_cover_class_cd_3 character varying(10),
    est_coverage_pct_3 numeric,
    soil_moisture_regime_3 character varying(10),
    avail_label_height numeric,
    avail_label_width numeric,
    full_label character varying(1000),
    label_centre_x numeric,
    label_centre_y numeric,
    label_height numeric,
    label_width numeric,
    line_1_opening_number character varying(4),
    line_1_opening_symbol_cd character varying(1),
    line_2_polygon_id character varying(10),
    line_3_tree_species character varying(50),
    line_4_classes_indexes character varying(12),
    line_5_vegetation_cover character varying(11),
    line_6_site_prep_history character varying(10),
    line_7_activity_hist_symbol character varying(1),
    line_7a_stand_tending_history character varying(39),
    line_7b_disturbance_history character varying(40),
    line_8_planting_history character varying(80),
    printable_ind character varying(1),
    small_label character varying(200),
    opening_id numeric,
    org_unit_no numeric,
    org_unit_code character varying(6),
    adjusted_ind character varying(1),
    bec_zone_code character varying(4),
    bec_subzone character varying(3),
    bec_variant character varying(1),
    bec_phase character varying(1),
    cfs_ecozone numeric,
    earliest_nonlogging_dist_type character varying(10),
    earliest_nonlogging_dist_date date,
    stand_percentage_dead numeric,
    free_to_grow_ind character varying(1),
    harvest_date date,
    layer_id character varying(10),
    for_cover_rank_cd character varying(10),
    non_forest_descriptor character varying(10),
    interpreted_data_src_cd character varying(10),
    quad_diam_125 numeric,
    quad_diam_175 numeric,
    quad_diam_225 numeric,
    est_site_index_species_cd character varying(10),
    est_site_index numeric,
    est_site_index_source_cd character varying(10),
    crown_closure numeric,
    crown_closure_class_cd character varying(2),
    reference_date date,
    site_index numeric,
    dbh_limit numeric,
    basal_area numeric,
    data_source_basal_area_cd character varying(10),
    vri_live_stems_per_ha numeric,
    data_src_vri_live_stem_ha_cd character varying(10),
    vri_dead_stems_per_ha numeric,
    tree_cover_pattern character varying(10),
    vertical_complexity character varying(10),
    species_cd_1 character varying(10),
    species_pct_1 numeric,
    species_cd_2 character varying(10),
    species_pct_2 numeric,
    species_cd_3 character varying(10),
    species_pct_3 numeric,
    species_cd_4 character varying(10),
    species_pct_4 numeric,
    species_cd_5 character varying(10),
    species_pct_5 numeric,
    species_cd_6 character varying(10),
    species_pct_6 numeric,
    proj_age_1 numeric,
    proj_age_class_cd_1 character varying(1),
    proj_age_2 numeric,
    proj_age_class_cd_2 character varying(1),
    data_source_age_cd character varying(10),
    proj_height_1 numeric,
    proj_height_class_cd_1 character varying(1),
    proj_height_2 numeric,
    proj_height_class_cd_2 character varying(1),
    data_source_height_cd character varying(10),
    live_vol_per_ha_spp1_125 numeric,
    live_vol_per_ha_spp1_175 numeric,
    live_vol_per_ha_spp1_225 numeric,
    live_vol_per_ha_spp2_125 numeric,
    live_vol_per_ha_spp2_175 numeric,
    live_vol_per_ha_spp2_225 numeric,
    live_vol_per_ha_spp3_125 numeric,
    live_vol_per_ha_spp3_175 numeric,
    live_vol_per_ha_spp3_225 numeric,
    live_vol_per_ha_spp4_125 numeric,
    live_vol_per_ha_spp4_175 numeric,
    live_vol_per_ha_spp4_225 numeric,
    live_vol_per_ha_spp5_125 numeric,
    live_vol_per_ha_spp5_175 numeric,
    live_vol_per_ha_spp5_225 numeric,
    live_vol_per_ha_spp6_125 numeric,
    live_vol_per_ha_spp6_175 numeric,
    live_vol_per_ha_spp6_225 numeric,
    dead_vol_per_ha_spp1_125 numeric,
    dead_vol_per_ha_spp1_175 numeric,
    dead_vol_per_ha_spp1_225 numeric,
    dead_vol_per_ha_spp2_125 numeric,
    dead_vol_per_ha_spp2_175 numeric,
    dead_vol_per_ha_spp2_225 numeric,
    dead_vol_per_ha_spp3_125 numeric,
    dead_vol_per_ha_spp3_175 numeric,
    dead_vol_per_ha_spp3_225 numeric,
    dead_vol_per_ha_spp4_125 numeric,
    dead_vol_per_ha_spp4_175 numeric,
    dead_vol_per_ha_spp4_225 numeric,
    dead_vol_per_ha_spp5_125 numeric,
    dead_vol_per_ha_spp5_175 numeric,
    dead_vol_per_ha_spp5_225 numeric,
    dead_vol_per_ha_spp6_125 numeric,
    dead_vol_per_ha_spp6_175 numeric,
    dead_vol_per_ha_spp6_225 numeric,
    live_stand_volume_125 numeric,
    live_stand_volume_175 numeric,
    live_stand_volume_225 numeric,
    dead_stand_volume_125 numeric,
    dead_stand_volume_175 numeric,
    dead_stand_volume_225 numeric,
    whole_stem_biomass_per_ha numeric,
    branch_biomass_per_ha numeric,
    foliage_biomass_per_ha numeric,
    bark_biomass_per_ha numeric,
    objectid numeric,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE veg_comp_lyr_r1_poly; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON TABLE whse_forest_vegetation.veg_comp_lyr_r1_poly IS 'This instantiated table is a join between VEG_COMP_POLY and VEG_COMP_LYR_R1_VW on FEATURE_ID.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.feature_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.feature_id IS 'Provincially unique identifier for an instance of a spatial feature.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.map_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.map_id IS 'Identifies the Forest Cover Map corresponding to the FIP file.  It is the British Columbia Geographic System"s (BCGS) Key Reference Number of the Forest Cover Map.  The mapsheet most commonly used is the 6" X 12" BCGS mapsheet.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.polygon_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.polygon_id IS 'The polygon number is a reference  number ( non unique) assigned to each Vegetated or Non-Vegetated polygon after it is delineated. The polygon number provides a  link between the graphic and descriptive files. The business assigned unique identifier for a polygon. Typically this has been uniquely assigned within a BCGS 6 X 12 Mapsheet.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.opening_ind; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.opening_ind IS 'Indicates whether or not the polygon represents a silviculture opening.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.opening_source; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.opening_source IS 'Defines whether the opening came from ISIS or MLSIS  This field is not populated in the current data model.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.opening_number; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.opening_number IS 'A unique number assigned to each opening in the forest caused by a disturbance (e.g. fire, logging, etc.) for which there will be management activities.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.feature_class_skey; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.feature_class_skey IS 'Unique identifier for a feature class.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.inventory_standard_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.inventory_standard_cd IS 'Code indicating under which inventory standard the data was collected. Values are: "V:" for Vegetation Resources Inventory (VRI), "F" for Forest Inventory Planning (FIP) and "I" for Incomplete (when a full set of VRI attributes is not collected).';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.polygon_area; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.polygon_area IS 'The area of a polygon; usually derived from geographic information system processing software.  The total area, in hectares, of the forest cover polygon.  The total area should be equal to the sum of the areas for all resultants in that polygon.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_productive_descriptor_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_productive_descriptor_cd IS 'A unique code that references the classes or type of non-productive areas or land that is incapable of supporting commercial forests. This is a FIP classification based attribute only, and is retained for the purposes of business transition from FIP to Vegetation Inventory.  There is no expectation that this attribute would be updated or created under Vegetation Inventory classification practise.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_productive_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_productive_cd IS 'A unique numeric code that references the classes or type of non-productive areas. This is a FIP classification based attribute only, and is retained for the purposes of business transition from FIP to Vegetation Inventory.  There is no expectation that this attribute would be updated or created under Vegetation Inventory classification practise.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.input_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.input_date IS 'The date the forest cover information was entered into the Provincial Data Base.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.coast_interior_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.coast_interior_cd IS 'A code indicating that the stand is located in the Coast or Interior Region of the Province.  The Coast Region is defined as the mainland west of the Cascade and Coast Mountains, including the off-shore islands. Forest Inventory Zones (FIZ) A to C are included in the Coast region. The Interior Region is defined as the mainland east of the Cascade and Coast Mountains.  Forest Inventory Zones (FIZ) D to L are included in the Interior Region.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.surface_expression; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.surface_expression IS 'The form of surficial material apparent on the medium scale photography. A simplified attribution is used owing to the likelihood that the trees will mask surficial features. Description Source: p. 3-5, Photo Interpretation Procedures, Phase 1, May 14, 1996. Data Value Source: Table 3-2, from Description Source';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.modifying_process; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.modifying_process IS 'A natural mechanism of weathering, erosion and soil material deposition that result in the modification of surficial materials and landforms. Used for terrain classification, site classification, soil condition and identification of potential hazards such as avalanches, slope instability and flooding. Data Definition Source: p.3-7, Photo Interpretation Procedures, Phase 1, May 14, 1996 Data Value Source: Table 3-3, from Data Definition Source.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.site_position_meso; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.site_position_meso IS 'A code denoting the relative position of the sampling site within a catchment area with the intent to be consistent within the scale of topography affecting surface water flow. The vertical difference is usually between 3 and 300m, and the surface area generally exceeds 0.5 has in size. Also known as slope position or  meso site position. Definition Source: "Describing Ecosystems in the Field", MOE Manual 11, Province of B.C. 1990, p. 31.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.alpine_designation; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.alpine_designation IS 'The location of the land unit with respect to location and elevation. An interpretation is applied as to whether the tree unit is above or below the tree line, that is, the upper elevation limit of continuous tree, or potential tree if cut-over, cover. If the land unit is above the the elevation line, a code of ''A'' is applied, otherwise ''N'', the default.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.soil_nutrient_regime; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.soil_nutrient_regime IS 'A code to denote, on a relative scale, the available nutrient supply for plant growth.  The soil"s nutrient regime (trophotope) integrates many environmental and biotic parameters which, in combination, determine the actual amounts of available nutrients. Definition Source: Reference: "Describing Ecosystems in the Field", MOE Manual 11, Province of B.C. 1990, p37-40 Soil Nutrient Regime (SNR) refers to the amount of essential soil nutrients, particularly nitrogen, available to vascular plants over a period of several years.  SNR classes include A (very poor), B (poor), C (medium), D (rich), E (very rich) and F (ultra rich, saline).';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.ecosys_class_data_src_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.ecosys_class_data_src_cd IS 'The source of the data used in the interpretation of the ecological attributes (Surface expression, modifying process, site position meso, alpine designation, and soil nutrient regime) that describe the polygon.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bclcs_level_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bclcs_level_1 IS 'The code for the land cover classification.  The codes are approved by the Resource Inventory Committee, RIC.  Level 1 identifies a Vegetated or Non-vegetated state, with further dichotomous refinement to Level 5, which identifies the Vegetation Density Class related to Vegetated land, or specific Non-vegetated state cover such as beaches, mudflats etc.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bclcs_level_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bclcs_level_2 IS 'The second level of the BC land cover classification scheme classifies the polygon as to the land cover type: treed or non-treed for vegetated polygons; land or water for non-vegetated polygons.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bclcs_level_3; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bclcs_level_3 IS 'The location of the polygon relative to elevation and drainage, and is described as either alpine, wetland, or upland.  In rare cases, the polygon may be alpine wetland.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bclcs_level_4; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bclcs_level_4 IS 'Classifies the vegetation types and Non-Vegetated cover types (as described by the presence of distinct types upon the land base within the polygon).';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bclcs_level_5; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bclcs_level_5 IS 'Classifies the vegetation density classes and Non-Vegetated categories.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.interpretation_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.interpretation_date IS 'The date on which the data was photo interpreted.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.project; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.project IS 'The business assigned name of the project.  The name typically reflects a Timber Supply Area, an initiating Agency, or a land area.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.reference_year; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.reference_year IS 'The year of the source data on which the interpretation is based. Known as the "Reference Year" in the VIF file.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.special_cruise_number; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.special_cruise_number IS 'The numeric code of the Public Sustained Yield Unit(s) (PSYU) that fall within the forest cover polygon.  PSYUs are areas of land, usually a natural topographic unit determined by drainage areas.  Includes PSYUs, Tree Farm Licences (TFL), Tree Farms (TF), Major Parks and Ecological Reserves, Woodlot licences, and miscellaneous areas.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.special_cruise_number_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.special_cruise_number_cd IS 'The numbers of the Public Sustained Yield Unit (PSYU) Block(s) that fall within the forest cover polygon.  PSYU Blocks are subdivisions of a PSYU, and indicate the presence of a sub-unit survey (i.e. 1:10,000 scale inventory).';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.inventory_region; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.inventory_region IS 'The Inventory Region(s) that fall within the forest cover polygon. Inventory Regions are an administrative and planning level boundary used to subdivide the Province into 88 units.  Inventory Region is also part of the reference key for identifying the geographic location of all Inventory Branch samples.  Inventory Region, along with Inventory Compartment and Compartment Letter, form the key to identifying the Inventory samples.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.compartment; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.compartment IS 'The Inventory Compartment(s) that fall within the forest cover polygon. Inventory Compartments are a geographic subdivision of an Inventory Region, usually defining a watershed or part thereof.  Inventory Compartment is also part of the reference key for identifying the geographic location of all Inventory Branch samples.  Inventory Compartment, along with Compartment Letter and Inventory Region form the key to identifying Inventory samples.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.compartment_letter; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.compartment_letter IS 'The Compartment Letter(s) that fall within the forest cover polygon. Compartment Letter is a geographic subdivision of an Inventory Compartment.  Compartment Letter only applies to some Inventory Compartments (e.g. only in Inventory Regions 1, 3, 5, 6, 7, 9, 10, 11, 56).  Compartment Letter is also part of the reference key for identifying the geographic location of all Inventory Branch samples. Compartment Letter, along with Inventory Compartment and Inventory Region form the key to identifying Inventory samples.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.fiz_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.fiz_cd IS 'The Forest Inventory Zone(s) (FIZ) that fall within the forest cover polygon. FIZ zones were developed to provide a broadly based ecological classification of the forestland in British Columbia. FIZ zones closely follow the early Biogeoclimatic zones developed by Dr. Krajina. The province of British Columbia is split into 12 FIZ zones.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.for_mgmt_land_base_ind; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.for_mgmt_land_base_ind IS 'An indicator placing the polygon in the Forest Management Land Base.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.attribution_base_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.attribution_base_date IS 'The date that the information about this polygon is considered to be based on.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.projected_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.projected_date IS 'The date to which time dependent stand information is projected. Attributes that are projected to a future date include: - Age, - Age Class, - Height, - Height Class, - Type Identity, - Stocking Class, etc.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.shrub_height; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.shrub_height IS 'The average height of the shrubs contained in the polygon as interpreted from medium scale photography. Note that this attribute only applies to the Shrub component. Definition Source: p. 7-2, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.shrub_crown_closure; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.shrub_crown_closure IS 'Shrub crown closure is the percentage of ground area covered by the vertically projected crowns of the shrub cover visible to the photo interpreter. Shrub crown closure is expressed as a percentage of the entire polygon.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.shrub_cover_pattern; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.shrub_cover_pattern IS 'Shrub cover pattern is a code that describes the spatial distribution of the shrubs within the polygon. Shrub cover pattern is used to describe the shrub layer spatial distribution. Examples include clumps of shrubs on rocky patches or individual shrubs or solid, continuous cover';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.herb_cover_type; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.herb_cover_type IS 'This set of attributes describes the portion of herb cover that is no obscured by the vertical projection of the crowns of either trees or shrubs. Herbs are defined as non-woody (vascular) plants, including graminoids (sedges, rushes, grasses), forbs (ferns, club mosses, and horsetails) and some low, woody species and intermediate life forms.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.herb_cover_pattern; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.herb_cover_pattern IS 'Herb cover pattern is a code that describes the spatial distribution of the herbaceous species within the polygon. Herb cover pattern is used to describe the herb layer spatial distribution. Examples include clumps of herbaceous species on rock outcrops, scattered patches or individual herbs or solid, continuous herbaceous cover.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.herb_cover_pct; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.herb_cover_pct IS 'Herb cover percent is the percentage of ground area covered by herbaceous cover visible to the photo interpreter. Herb cover percent is analogous to tree and shrub crown closures and is expressed as a percentage of the entire polygon.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bryoid_cover_pct; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bryoid_cover_pct IS 'The percent cover of Bryoids: includes bryophytes (mosses, liverworts, hornworts) and non-crustose lichens.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_veg_cover_pattern_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_veg_cover_pattern_1 IS 'Non-vegetated cover pattern_1 describes the spatial distribution of the most prevalent non-vegetated cover type based on percent area covered within the polygon. Definition Source: pp.7-4 (fig. 7-2), 8-5 (fig. 8-2), same as pp. 10-7, fig. 10-2, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_veg_cover_pct_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_veg_cover_pct_1 IS 'The area the predominate non-vegetated portion covers expressed as a percentage of the entire polygons area. Definition Source: p. 10-5, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_veg_cover_type_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_veg_cover_type_1 IS 'Non-vegetated cover type_1 is the designation for the predominate   observable non-vegetated land cover within the polygon.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_veg_cover_pattern_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_veg_cover_pattern_2 IS 'Non-vegetated cover pattern_2 describes the spatial distribution of the second most prevalent non-vegetated cover type based on percent area covered  within the polygon. Definition Source: pp. 7-4 (fig. 7-2), 8-5 (fig. 8-2), same as pp. 10-7, fig. 10-2, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_veg_cover_pct_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_veg_cover_pct_2 IS 'The area the second most prevalent non-vegetated portion covers expressed as a percentage of the entire polygons area. Definition Source: p. 10-5, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_veg_cover_type_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_veg_cover_type_2 IS 'Non-vegetated cover type_2 is the designation for the second most prevalent   observable non-vegetated land cover within the polygon.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_veg_cover_pattern_3; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_veg_cover_pattern_3 IS 'Non-vegetated cover type_3 is the designation for the third most prevalent   observable non-vegetated land cover within the polygon.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_veg_cover_pct_3; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_veg_cover_pct_3 IS 'The area the third most prevalent non-vegetated portion covers expressed as a percentage of the entire polygons area. Definition Source: p. 10-5, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_veg_cover_type_3; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_veg_cover_type_3 IS 'Non-vegetated cover type_3 is the designation for the third most prevalent   observable non-vegetated land cover within the polygon.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.land_cover_class_cd_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.land_cover_class_cd_1 IS 'The Land Cover Classification Code_1 describes the predominate land cover type by percent area occupied within the polygon that contribute to the overall polygon description, but may be too small to be spatially identified. The sub-division of a polygon by a quantified Land Cover Component, allowing non-spatial resolution for modeling of wildlife habitat capability.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.est_coverage_pct_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.est_coverage_pct_1 IS 'The amount the polygon occupied by the predominate Land Cover Component.  The sub-division of a polygon by a quantified Land Cover Component allows a higher degree spatial resolution for modelling wildlife habitat capability. Generally, sizes under 10% would not be estimated. Definition Source: p. 4-6, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.soil_moisture_regime_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.soil_moisture_regime_1 IS 'The average amount of soil water annually available for evapotranspiration by vascular plants averaged over many years within the predominate cover type. Soil Moisture Regime is an interpretative attribute for estimation of site potential and site series classification. Definition Source: p. 4-7, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.land_cover_class_cd_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.land_cover_class_cd_2 IS 'The Land Cover Classification Code_2 describes the second most dominate land cover type by percent area occupied within the polygon that contribute to the overall polygon description, but may be too small to be spatially identified. The sub-division of a polygon by a quantified Land Cover Component, allowing non-spatial resolution for modelling of wildlife habitat capability.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.est_coverage_pct_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.est_coverage_pct_2 IS 'The amount the polygon occupied by the second most dominate Land Cover Component. The sub-division of a polygon by a quantified Land Cover Component allows a higher degree spatial resolution for modelling wildlife habitat capability. Generally, sizes under 10% would not be estimated. Definition Source: p. 4-6, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.soil_moisture_regime_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.soil_moisture_regime_2 IS 'The average amount of soil water annually available for evapotranspiration by vascular plants averaged over many years within the second most dominate cover type. Soil Moisture Regime is an interpretative attribute for estimation of site potential and site series classification. Definition Source: p. 4-7, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.land_cover_class_cd_3; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.land_cover_class_cd_3 IS 'The Land Cover Classification Code_3 describes the third most dominate land cover type by percent area occupied within the polygon that contribute to the overall polygon description, but may be too small to be spatially identified. The sub-division of a polygon by a quantified Land Cover Component, allowing non-spatial resolution for modelling of wildlife habitat capability.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.est_coverage_pct_3; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.est_coverage_pct_3 IS 'The amount the polygon occupied by the third most dominate Land Cover Component.  The sub-division of a polygon by a quantified Land Cover Component allows a higher degree spatial resolution for modelling wildlife habitat capability. Generally, sizes under 10% would not be estimated. Definition Source: p. 4-6, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.soil_moisture_regime_3; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.soil_moisture_regime_3 IS 'The average amount of soil water annually available for evapotranspiration by vascular plants averaged over many years within the second most dominate cover type. Soil Moisture Regime is an interpretative attribute for estimation of site potential and site series classification. Definition Source: p. 4-7, PIP';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.avail_label_height; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.avail_label_height IS 'The available height for a label, in meters for a 1:15,000 map presentation. This is derived during the label generation process to calculate if the VRI label will fit within a polygon shape or be written the map side.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.avail_label_width; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.avail_label_width IS 'The available width for a label, in meters for a 1:15,000 map presentation. This is derived during the label generation process to calculate if the VRI label will fit within a polygon shape or be written the map side.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.full_label; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.full_label IS 'The full Vegetation Map label. It contains the polygon id, Opening number, species composition, projected age, projected height, site index and crown closure, and indicator of shrub, herb, bryoid, or non vegetative components, and the historic disturbance and forest management activities. It is at most 8 lines. Back slashes represent carriage returns.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.label_centre_x; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.label_centre_x IS 'The x co-ordinate of the suggested centre of the label.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.label_centre_y; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.label_centre_y IS 'The y co-ordinate of the suggested centre of the label.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.label_height; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.label_height IS 'The height of the full label for a 1:15,000 map presentation in meters.  It is calculated as 30 times the number of lines in the full label.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.label_width; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.label_width IS 'The width of the full label for a 1:15,000 map presentation in meters.  It is calculated as 18 times the number of characters in the longest line.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_1_opening_number; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_1_opening_number IS 'The MOF District Silviculture opening number to which the polygon applies to.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_1_opening_symbol_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_1_opening_symbol_cd IS 'The opening symbol code is represented as one of the following characters: "x", "|", or "~".  If the opening number is null, line 1 is not populated, so there is no opening symbol.  If the adjoining NTS map number is in the form "num num num char num / char", it is an NTS number, the corresponding opening symbol is a hexagon with an "N" in it, and is represented here by "~".  If the adjoining NTS map number is in the form "num num num char num num num", it is a BCGS number, the corresponding opening symbol is a hexagon with an "X" in it, and is represented here by "|".  Otherwise the opening symbol is an empty hexagon, and is represented here by "x".';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_2_polygon_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_2_polygon_id IS 'The polygon ID for which this is the label.  This is followed by /L (a multi-layered stand) or /S (a separate silviculture description is available in the data base).';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_3_tree_species; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_3_tree_species IS 'A list of major species (minor species), ordered by percentage.  The species symbols are F (Douglas fir), C (western red cedar), H (hemlock), B (balsam), S (spruce), Sb (black spruce), Yc (yellow cedar), Pw (western white pine), Pa (whitebark pine), Pf (limber pine), Pl (lodgepole pine), Pj (jack pine), Py (yellow pine), L (larch), Ac (cottonwood), D (red alder), Mb (broadleaf maple), E (birch), Al (aspen).';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_4_classes_indexes; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_4_classes_indexes IS 'Line 4 is made up of 4 numerical characters followed by a hyphen, the site index, a slash, and the estimated site index. The four numerical characters represent projected age class, projected height class, projected stocking class, and crown closure class in that order.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_5_vegetation_cover; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_5_vegetation_cover IS 'A listing of the non-vegetated descriptors  or the non tree vegetative cover types ordered from most to least common. Possible values in the list are sh (shrub), he (herb), by (bryoid), or the non-vegetative cover codes.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_6_site_prep_history; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_6_site_prep_history IS 'The site preparation history represented by a list of abbreviations for the techniques used, followed by the years each technique was used.  Possible values for the abbreviations are B (broadcast burn) C (chemical), G (grass seeded), H (hand preparation), RB (range management burn), S (spot burn), M (mechanical), MS (mechanical and spot burn), and W (windrow).';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_7_activity_hist_symbol; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_7_activity_hist_symbol IS 'A symbol representing what techniques where used in the labelled area.  The symbol is a circle with 0 to 4 radius lines.  Each line represents a technique applied to the labelled area.If RESOURCE_INVENTORY_HISTORY.SILV_BASE = ST(stand tending)  then  & as circle with a radius line pointing leftIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = SI(regeneration/site preparation) then  %  draw as circle with a radius line pointing (up/down)If RESOURCE_INVENTORY_HISTORY.SILV_BASE = DI(disturbance) then  $  draw as circle with a radius line pointing rightIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = PL(regeneration/site preparation) then  %  draw as circle with a radius line pointing (up/down)If RESOURCE_INVENTORY_HISTORY.SILV_BASE = ST  then  <  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = ST  then  `  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = ST  then  :  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = SI  then  *  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = SI  then  X  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = DI  then  ;  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = ST   then  ¿  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = ST   then  @  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = PL   then  [  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = SI   then  \  draw as combination of the above circles and radius linesIf RESOURCE_INVENTORY_HISTORY.SILV_BASE = ST    then  ^  draw as combination of the above circles and radius lines';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_7a_stand_tending_history; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_7a_stand_tending_history IS 'The stand tending history represented by a list of abbreviations for the techniques used followed by the years each technique was used.  Possible values for the abbreviations are F (fertilization), H (hand and squirt), J (juvenile spacing), M (mistletoe control), P (pruning), R (conifer realize), S (sanitation spacing), T (commercial thinning), W (brushing and weeding).';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_7b_disturbance_history; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_7b_disturbance_history IS 'The disturbance history described as a list of abbreviations for the techniques along with the years each technique was employed.  Possible values are B (wildfire), BE (escaped burn), BG (ground burn), BR (range burn), BW (wildlife burn), D (disease), F (flooding), I (insect), K (fume kill), L (logging), L% (logged with percentage), R (site rehabilitation), S (slide), and W (wind throw).';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.line_8_planting_history; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.line_8_planting_history IS 'The planting (or regeneration) history described as a list of years during which artificial planting was performed.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.printable_ind; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.printable_ind IS '"Y" means print the label.  "N" means do not print the label.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.small_label; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.small_label IS 'The two-line (or Format 3) version of the label.  This label contains, at most, 2 lines build from the line 1 and 2 attributes.  A back slash represents a carriage return.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.opening_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.opening_id IS 'System generated value uniquely identifying the opening.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.org_unit_no; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.org_unit_no IS 'Number from Org Unit code table representing the organization that collected the data.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.org_unit_code; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.org_unit_code IS 'Identifies any office within the ministry.  First character identifies Exec, HQ branch, Region, or District.  Next two chars identify the office name; next two the section (HQ Branch) or program (Region or District); last char identifies the subsection.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.adjusted_ind; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.adjusted_ind IS 'Indicates whether or not the polygon has been adjusted.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bec_zone_code; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bec_zone_code IS 'Code indicating the polygon"s Biogeoclimatic Zone.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bec_subzone; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bec_subzone IS 'A code indicating the polygon"s biogeoclimatic sub zone.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bec_variant; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bec_variant IS 'A code indicating the polygon"s biogeoclimatic variant.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bec_phase; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bec_phase IS 'A code indicating the polygon"s biogeoclimatic phase.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.cfs_ecozone; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.cfs_ecozone IS 'A code indicating the polygon''s Canadian Forest Service (CFS) terrestrial ecozone.  It is used in the calculation of above-ground forest biomass using CFS volume-to-biomass models.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.earliest_nonlogging_dist_type; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.earliest_nonlogging_dist_type IS 'Represents the polygons earliest non-logging disturbance date.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.earliest_nonlogging_dist_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.earliest_nonlogging_dist_date IS 'Represents the polygons earliest non-logging disturbance date.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.stand_percentage_dead; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.stand_percentage_dead IS 'Represents the percent of the stand that has had an epidemic loss.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.free_to_grow_ind; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.free_to_grow_ind IS 'Indicates whether or not the polygon represents a Free To Grow opening.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.harvest_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.harvest_date IS 'The date in which the polygon was last harvested.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.layer_id; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.layer_id IS 'The unique business identification of a layer, or horizontal stratum, in a stand.  Each layer is normally characterized as a distinct canopy containing a common forest cover structure with timber of similar ages (at least 40 years between layers) and heights (at least 10 meters between layers).  Layers are assigned from the tallest layer downward.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.for_cover_rank_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.for_cover_rank_cd IS 'A numeric designation of the relative importance of the layer component in the stand as determined by the business. The level of importance decreases as the numeric designation increases. For Vegetation Cover originated data, this value is assigned via business rule based on the supplied order of the layer records as recorded by the interpreter. For FIP originated data, this value is known as the RANK CD, and is explicitly supplied by the interpreter. The RANK CD, or ranking, is based on Regional guidelines at the time of interpretation. This value is retained for FIP transition purposes, as tree volumes are only calculated by VDYP, the current software/mathematical model in production. The RANK CD will be superseded in time when Vegetation Inventory projection tools are developed.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.non_forest_descriptor; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.non_forest_descriptor IS 'Non commercial forest vegetation on a polygon that is capable of supporting commercial forests. Maps directly to the FIP attribute, NON FOREST DESCRIPTOR and is also utilized for the determination of the BC Land Cover Classification. This is a FIP classification based attribute only, and is retained for the purposes of business transition from FIP to Vegetation Inventory.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.interpreted_data_src_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.interpreted_data_src_cd IS 'The source of the data that contributed to the determination of the classification description.  All values taken from Table 3-1, PIP This list of values is similar, but not identical to the FIP DATA SOURCE which will be used to validate the FIP file prior to loading. Non-conforming FIP DATA SOURCE values will be converted to the VEGETATION DATA SOURCE values on load to the Vegetative Cover database.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.quad_diam_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.quad_diam_125 IS 'The quadratic mean stand diameter (breast height), at the projection date, based on the 12.5 cm utilization level. Calculated for Rank 1 stands only, type id (TYPID) 1 through 3.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.quad_diam_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.quad_diam_175 IS 'The quadratic mean stand diameter (breast height), at the projection date, based on the 17.5 cm utilization level. Calculated for Rank 1 stands only, Type id (TYPID) for 1 through 3.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.quad_diam_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.quad_diam_225 IS 'The quadratic mean stand diameter (breast height), at the projection date, based on the 22.5 cm utilization level.Calculated for Rank 1 stands only, type id (TYPID) 1 through 3.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.est_site_index_species_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.est_site_index_species_cd IS 'The species to which the estimated site index applies.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.est_site_index; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.est_site_index IS 'Estimated site index is an interpreter estimated site index for tree layers with a leading species age less than 31 years. Site index is the mean height of the dominant and codominant trees will attain at a base index age (50 years) used for the purposes of estimating forest site growth capability. The site index is based on a normalized set of coefficients calibrated to reflect the range of heights for a given tree species.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.est_site_index_source_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.est_site_index_source_cd IS 'Describes the process used to determine the estimated site index prediction for tree layers with a leading species age less than 31 years.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.crown_closure; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.crown_closure IS 'The percentage of ground area covered by the vertically projected crowns of the tree cover for each tree layer within the polygon.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.crown_closure_class_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.crown_closure_class_cd IS 'The percentage of ground area covered by the vertically projected crowns of the tree cover for each tree layer within the polygon. Represented by a code value in the code list.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.reference_date; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.reference_date IS 'The date of the source data on which the interpretation is based. Known as the "Reference Year" in the VIF file.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.site_index; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.site_index IS 'Site index is an estimate of site productivity for tree growth (height in metres at breast height age of 50 years). The mean height of the dominant and codominant trees will attain at a base index age used for the purposes of estimating forest site growth capability. The site index is based on a normalized set of coefficients calibrated to reflect the range of heights for a given tree species.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dbh_limit; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dbh_limit IS 'A code indicating the minimum diameter breast height (DBH) for measuring trees (i.e. stems) in the field sample.  For example, a code of 3 indicates that stems were measured if they had a DBH greater than or equal to 7.5cm.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.basal_area; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.basal_area IS 'Confidence indices are a subjective value that reflect confidence of the photo interpreter in the estimation of basal area for each layer.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.data_source_basal_area_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.data_source_basal_area_cd IS 'The source of data used for the interpretation of basal area.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.vri_live_stems_per_ha; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.vri_live_stems_per_ha IS 'The average number of living trees visible to the photo interpreter in the dominant, codominant and high intermediate crown positions in each tree layer in the polygon.  It is expressed as stems per hectare.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.data_src_vri_live_stem_ha_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.data_src_vri_live_stem_ha_cd IS 'The source of data used for the interpretation of stand density.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.vri_dead_stems_per_ha; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.vri_dead_stems_per_ha IS 'The number of VRI dead tree stems on an unitary per hectare basis.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.tree_cover_pattern; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.tree_cover_pattern IS 'The spatial distribution of the tree cover within each tree layer in the polygon. Definition Source: p 6-1, PIP Data Value Source; Figure 6-1';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.vertical_complexity; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.vertical_complexity IS 'The subjective classification that describes the form of each tree layer as indicated by the relative uniformity of the forest canopy as it appears on mid-scale aerial photographs.  Vertical complexity is influenced by stand age, species (succession as it relates to shade tolerance) and degree and age of past disturbances.  The tree height range is calculated as the total difference in height between the tallest and shortest visible dominant, codominant, and high intermediate trees. To most adequately represent the tree layer of interest, occasional occurrences of either very tall or very short trees should be ignored so that the vertical complexity indicated is for the majority of stems in the dominant, codominant, and high intermediate portion of each tree layer.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_cd_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_cd_1 IS 'The code indicating the type of tree species predominate or leading  in the tree layer. A "leading" species is identified as being the highest percent basal area or, if a very young stand, the relative number of stems per hectare.  Species are described in terms of Genus, Species and variety.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_pct_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_pct_1 IS 'Percentages of the layer that the leading species occupies. For older stands, tree species percentage is based on percent basal area or, if a very young stand, the relative number of stems per hectare.  Tree species percentage is estimated to the nearest percent for all living trees above a specified diameter.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_cd_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_cd_2 IS 'The code indicating the type of tree species second most dominate in the tree layer. A "second" species is identified in descending order of species percent from the "leading" species.  Species are described in terms of Genus, Species and variety.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_pct_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_pct_2 IS 'Percentages of the layer that the second most dominate species occupies. For older stands, tree species percentage is based on percent basal area or, if a very young stand, the relative number of stems per hectare.  Tree species percentage is estimated to the nearest percent for all living trees above a specified diameter.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_cd_3; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_cd_3 IS 'The code indicating the type of tree species third most dominate in the tree layer. A "third" species is identified in descending order of species percent from the "leading" species.  Species are described in terms of Genus, Species and variety.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_pct_3; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_pct_3 IS 'Percentages of the layer that the third most dominate species occupies. For older stands, tree species percentage is based on percent basal area or, if a very young stand, the relative number of stems per hectare.  Tree species percentage is estimated to the nearest percent for all living trees above a specified diameter.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_cd_4; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_cd_4 IS 'The code indicating the type of tree species fourth most dominate in the tree layer. The "fourth" species is identified in descending order of species percent from the "leading" species.  Species are described in terms of Genus, Species and variety.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_pct_4; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_pct_4 IS 'Percentages of the layer that the fourth most dominate species occupies. For older stands, tree species percentage is based on percent basal area or, if a very young stand, the relative number of stems per hectare.  Tree species percentage is estimated to the nearest percent for all living trees above a specified diameter.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_cd_5; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_cd_5 IS 'The code indicating the type of tree species fifth most dominate in the tree layer. The "fifth" species is identified in descending order of species percent from the "leading" species.  Species are described in terms of Genus, Species and variety.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_pct_5; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_pct_5 IS 'Percentages of the layer that the fifth most dominate species occupies. For older stands, tree species percentage is based on percent basal area or, if a very young stand, the relative number of stems per hectare.  Tree species percentage is estimated to the nearest percent for all living trees above a specified diameter.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_cd_6; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_cd_6 IS 'The code indicating the type of tree species sixth most dominate in the tree layer. The "sixth" species is identified in descending order of species percent from the "leading" species.  Species are described in terms of Genus, Species and variety.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.species_pct_6; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.species_pct_6 IS 'Percentages of the layer that the sixth most dominate species occupies. For older stands, tree species percentage is based on percent basal area or, if a very young stand, the relative number of stems per hectare.  Tree species percentage is estimated to the nearest percent for all living trees above a specified diameter.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.proj_age_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.proj_age_1 IS 'The age projected to the adjustment area ground sample date, for Species 1.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.proj_age_class_cd_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.proj_age_class_cd_1 IS 'The age projected to the adjustment area ground sample date, for Species 1. Classified by standard age classes.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.proj_age_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.proj_age_2 IS 'The age projected to the adjustment area ground sample date, for Species 2.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.proj_age_class_cd_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.proj_age_class_cd_2 IS 'The age projected to the adjustment area ground sample date, for Species 2. Classified by standard age classes.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.data_source_age_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.data_source_age_cd IS 'The source of data used for the interpretation of year of origin (age), for Species 1.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.proj_height_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.proj_height_1 IS 'The height projected to the adjustment area ground sample date, for Species 1.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.proj_height_class_cd_1; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.proj_height_class_cd_1 IS 'The height projected to the adjustment area ground sample date, for Species 1. Classified by standard height classes';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.proj_height_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.proj_height_2 IS 'The height projected to the adjustment area ground sample date, for Species 2.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.proj_height_class_cd_2; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.proj_height_class_cd_2 IS 'The height projected to the adjustment area ground sample date, for Species 2. Classified by standard height classes';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.data_source_height_cd; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.data_source_height_cd IS 'The source of data used for the interpretation of height, for Species 1.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp1_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp1_125 IS 'Net live volume per hectare of the leading species determined by percent basal area of the tree layer at the 12.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp1_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp1_175 IS 'Net live volume per hectare of the leading species determined by percent basal area of the tree layer at the 17.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp1_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp1_225 IS 'Net live volume per hectare of the leading species determined by percent basal area of the tree layer at the 22.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp2_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp2_125 IS 'Net live volume per hectare of the second species determined by percent basal area of the tree layer at the 12.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp2_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp2_175 IS 'Net live volume per hectare of the second species determined by percent basal area of the tree layer at the 17.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp2_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp2_225 IS 'Net live volume per hectare of the second species determined by percent basal area of the tree layer at the 22.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp3_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp3_125 IS 'Net live volume per hectare of the third species determined by percent basal area of the tree layer at the 12.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp3_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp3_175 IS 'Net live volume per hectare of the third species determined by percent basal area of the tree layer at the 17.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp3_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp3_225 IS 'Net live volume per hectare of the third species determined by percent basal area of the tree layer at the 22.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp4_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp4_125 IS 'Net live volume per hectare of the fourth species determined by percent basal area of the tree layer at the 12.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp4_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp4_175 IS 'Net live volume per hectare of the fourth species determined by percent basal area of the tree layer at the 17.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp4_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp4_225 IS 'Net live volume per hectare of the fourth species determined by percent basal area of the tree layer at the 22.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp5_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp5_125 IS 'Net live volume per hectare of the fifth species determined by percent basal area of the tree layer at the 12.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp5_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp5_175 IS 'Net live volume per hectare of the fifth species determined by percent basal area of the tree layer at the 17.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp5_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp5_225 IS 'Net live volume per hectare of the fifth species determined by percent basal area of the tree layer at the 22.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp6_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp6_125 IS 'Net live volume per hectare of the sixth species determined by percent basal area of the tree layer at the 12.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp6_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp6_175 IS 'Net live volume per hectare of the sixth species determined by percent basal area of the tree layer at the 17.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_vol_per_ha_spp6_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_vol_per_ha_spp6_225 IS 'Net live volume per hectare of the sixth species determined by percent basal area of the tree layer at the 22.5 cm utilization level.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp1_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp1_125 IS 'Net dead volume per hectare of the leading species determined by percent basal area of the tree layer at the 12.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp1_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp1_175 IS 'Net dead volume per hectare of the leading species determined by percent basal area of the tree layer at the 17.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp1_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp1_225 IS 'Net dead volume per hectare of the leading species determined by percent basal area of the tree layer at the 22.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp2_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp2_125 IS 'Net dead volume per hectare of the second species determined by percent basal area of the tree layer at the 12.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp2_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp2_175 IS 'Net dead volume per hectare of the second species determined by percent basal area of the tree layer at the 17.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp2_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp2_225 IS 'Net dead volume per hectare of the second species determined by percent basal area of the tree layer at the 22.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp3_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp3_125 IS 'Net dead volume per hectare of the third species determined by percent basal area of the tree layer at the 12.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp3_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp3_175 IS 'Net dead volume per hectare of the third species determined by percent basal area of the tree layer at the 17.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp3_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp3_225 IS 'Net dead volume per hectare of the third species determined by percent basal area of the tree layer at the 22.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp4_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp4_125 IS 'Net dead volume per hectare of the fourth species determined by percent basal area of the tree layer at the 12.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp4_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp4_175 IS 'Net dead volume per hectare of the fourth species determined by percent basal area of the tree layer at the 17.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp4_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp4_225 IS 'Net dead volume per hectare of the fourth species determined by percent basal area of the tree layer at the 22.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp5_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp5_125 IS 'Net dead volume per hectare of the fifth species determined by percent basal area of the tree layer at the 12.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp5_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp5_175 IS 'Net dead volume per hectare of the fifth species determined by percent basal area of the tree layer at the 17.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp5_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp5_225 IS 'Net dead volume per hectare of the fifth species determined by percent basal area of the tree layer at the 22.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp6_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp6_125 IS 'Net dead volume per hectare of the sixth species determined by percent basal area of the tree layer at the 12.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp6_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp6_175 IS 'Net dead volume per hectare of the sixth species determined by percent basal area of the tree layer at the 17.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_vol_per_ha_spp6_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_vol_per_ha_spp6_225 IS 'Net dead volume per hectare of the sixth species determined by percent basal area of the tree layer at the 22.5 cm utilization level and at the year of death.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_stand_volume_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_stand_volume_125 IS 'Total net volume per hectare of all live species determined by percent basal area of the tree layer at the 12.5 cm utilization level';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_stand_volume_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_stand_volume_175 IS 'Total net volume per hectare of all live species determined by percent basal area of the tree layer at the 17.5 cm utilization level';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.live_stand_volume_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.live_stand_volume_225 IS 'Total net volume per hectare of all live species determined by percent basal area of the tree layer at the 22.5 cm utilization level';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_stand_volume_125; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_stand_volume_125 IS 'Total net volume per hectare of all dead species determined by percent basal area of the tree layer at the 12.5 cm utilization level at the year of death for the stand';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_stand_volume_175; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_stand_volume_175 IS 'Total net volume per hectare of all dead species determined by percent basal area of the tree layer at the 17.5 cm utilization level at the year of death for the stand';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.dead_stand_volume_225; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.dead_stand_volume_225 IS 'Total net volume per hectare of all dead species determined by percent basal area of the tree layer at the 22.5 cm utilization level at the year of death for the stand';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.whole_stem_biomass_per_ha; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.whole_stem_biomass_per_ha IS 'The total stem biomass per hectare of all species on a minimum diameter utilization of 4.0cm  expressed as tonnes/ha.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.branch_biomass_per_ha; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.branch_biomass_per_ha IS 'The total branch biomass per hectare of all species on a minimum diameter utilization of 4.0cm  expressed as tonnes/ha.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.foliage_biomass_per_ha; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.foliage_biomass_per_ha IS 'The total foliage biomass per hectare of all species on a minimum diameter utilization of 4.0cm  expressed as tonnes/ha.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.bark_biomass_per_ha; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.bark_biomass_per_ha IS 'The total bark biomass per hectare of all species on a minimum diameter utilization of 4.0cm  expressed as tonnes/ha.';


--
-- Name: COLUMN veg_comp_lyr_r1_poly.objectid; Type: COMMENT; Schema: whse_forest_vegetation; Owner: -
--

COMMENT ON COLUMN whse_forest_vegetation.veg_comp_lyr_r1_poly.objectid IS 'OBJECTID is a column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: veg_comp_lyr_r1_poly_feature_id_seq; Type: SEQUENCE; Schema: whse_forest_vegetation; Owner: -
--

CREATE SEQUENCE whse_forest_vegetation.veg_comp_lyr_r1_poly_feature_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: veg_comp_lyr_r1_poly_feature_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_forest_vegetation; Owner: -
--

ALTER SEQUENCE whse_forest_vegetation.veg_comp_lyr_r1_poly_feature_id_seq OWNED BY whse_forest_vegetation.veg_comp_lyr_r1_poly.feature_id;


--
-- Name: veg_consolidated_cut_blocks_sp_vccb_sysid_seq; Type: SEQUENCE; Schema: whse_forest_vegetation; Owner: -
--

CREATE SEQUENCE whse_forest_vegetation.veg_consolidated_cut_blocks_sp_vccb_sysid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: veg_consolidated_cut_blocks_sp_vccb_sysid_seq; Type: SEQUENCE OWNED BY; Schema: whse_forest_vegetation; Owner: -
--

ALTER SEQUENCE whse_forest_vegetation.veg_consolidated_cut_blocks_sp_vccb_sysid_seq OWNED BY whse_forest_vegetation.veg_consolidated_cut_blocks_sp.vccb_sysid;


--
-- Name: abms_municipalities_sp_lgl_admin_area_id_seq; Type: SEQUENCE; Schema: whse_legal_admin_boundaries; Owner: -
--

CREATE SEQUENCE whse_legal_admin_boundaries.abms_municipalities_sp_lgl_admin_area_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: abms_municipalities_sp_lgl_admin_area_id_seq; Type: SEQUENCE OWNED BY; Schema: whse_legal_admin_boundaries; Owner: -
--

ALTER SEQUENCE whse_legal_admin_boundaries.abms_municipalities_sp_lgl_admin_area_id_seq OWNED BY whse_legal_admin_boundaries.abms_municipalities_sp.lgl_admin_area_id;


--
-- Name: ta_conservancy_areas_svw_admin_area_sid_seq; Type: SEQUENCE; Schema: whse_tantalis; Owner: -
--

CREATE SEQUENCE whse_tantalis.ta_conservancy_areas_svw_admin_area_sid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ta_conservancy_areas_svw_admin_area_sid_seq; Type: SEQUENCE OWNED BY; Schema: whse_tantalis; Owner: -
--

ALTER SEQUENCE whse_tantalis.ta_conservancy_areas_svw_admin_area_sid_seq OWNED BY whse_tantalis.ta_conservancy_areas_svw.admin_area_sid;


--
-- Name: ta_crown_tenures_svw; Type: TABLE; Schema: whse_tantalis; Owner: -
--

CREATE TABLE whse_tantalis.ta_crown_tenures_svw (
    intrid_sid numeric,
    tenure_stage character varying(48),
    tenure_status character varying(48),
    tenure_type character varying(35),
    tenure_subtype character varying(35),
    tenure_purpose character varying(35),
    tenure_subpurpose character varying(35),
    crown_lands_file character varying(15),
    application_type_cde character varying(30),
    tenure_document character varying(50),
    tenure_expiry date,
    tenure_location character varying(1000),
    tenure_legal_description character varying(2000),
    tenure_area_derivation character varying(240),
    tenure_area_in_hectares numeric,
    responsible_business_unit character varying(100),
    disposition_transaction_sid numeric,
    code_chr_stage character varying(1),
    feature_code character varying(10),
    objectid integer NOT NULL,
    geom public.geometry(MultiPolygon,3005)
);


--
-- Name: TABLE ta_crown_tenures_svw; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON TABLE whse_tantalis.ta_crown_tenures_svw IS 'Current Land Act tenures and applications for such tenures.';


--
-- Name: COLUMN ta_crown_tenures_svw.intrid_sid; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.intrid_sid IS 'A system-generated sequential identifier that uniquely represents the associated interest parcel amongst all interest parcels stored in the Tantalis system.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_stage; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_stage IS 'Indicates the point that a tenure has reached in the interest lifecycle. For example,  TENURE indicates that the tenure has passed the APPLICATION stage and has become a valid tenure.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_status; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_status IS 'Represents the business state of a tenure as it evolves from application to disposition and is often associated to a specific tenure stage (e.g. application, tenure). Typically the status is the result of either a business or client action. Examples: ALLOWED (application), DISPOSITION IN GOOD STANDING (tenure), SUSPENDED (tenure).  SPECIAL NOTE:  a status of HISTORIC applies to active Crown Grants retroactively entered from historic records.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_type; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_type IS 'Identifies the nature and extent of legal rights conveyed and utilizes a distinct legal instrument (contract) to do so. Term lengths, exclusivity of use or cancellation provisions may be characteristics distinguishing one type from another. For example, a Lease is issued where long term tenure is required, where substantial improvements are proposed, and/or where definite boundaries are required in order to avoid land use and property conflicts. Example Tenure Types are : Lease, Licence, Revenue Sharing Agreement.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_subtype; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_subtype IS 'A further specification of the tenure type and is used to describe the nature of the tenure. For example,  ''Lease - Purchase Option'' indicates that a clause is included that allows for the  purchase of the land from the crown according to the lease document.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_purpose; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_purpose IS 'Indicates the purpose for which the client acquired the Crown Land.  Purposes are established through policy, and each has a body of policy governing its use. For example, TRANSPORTATION indicates that the tenure will be used for activites such as a road or public wharf.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_subpurpose; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_subpurpose IS 'A subcategory of a tenure purpose. Like Purposes, Subpurposes are established through policy, and each has a body of policy governing its use.   For example, PUBLIC WHARF is a subpurpose of the TRANSPORTATION purpose.';


--
-- Name: COLUMN ta_crown_tenures_svw.crown_lands_file; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.crown_lands_file IS 'A unique seven-digit number generated by Crown Land Management offices to identify a disposition of Crown Land. This number is the basis for the ORCS number under which it will be filed and is commonly used in correspondence and physical files. For example, a file number might identify a specific Aquaculture Lease or a set of Right of Way tenures.';


--
-- Name: COLUMN ta_crown_tenures_svw.application_type_cde; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.application_type_cde IS 'A code representing the type of application.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_document; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_document IS 'The unique number assigned to the Document which forms the agreement between an individual or company and the provincial government for an interest in crown land. For example, 515744 is the tenure document number for a Right of Way agreement for the purpose of an Electric Power Line';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_expiry; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_expiry IS 'The date that a tenure agreement ceases to be in effect. The tenure expiry date is initialized to equal the commencement date plus the tenure term, but may be adjusted later for various reasons.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_location; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_location IS 'A brief text description that identifies the position of a tenure at or relative to known geographic features such as a city or town, a lake, a river, etc. For example, CAMPBELL RIVER may be the closest well known location to a Private Moorage Lease.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_legal_description; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_legal_description IS 'The formal land description of the interest parcel for a tenure. The description follows a prescribed convention.  For example, ''Block C, District Lot 1655, Rupert District'' describes the area covered under a specific aquaculture lease.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_area_derivation; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_area_derivation IS 'The method used to calculate the surface area of a tenure. For example, ''Calculated automatically'' indicates that the TENURE_AREA_IN_HECTARES value was derived from the spatial representation of the tenure.';


--
-- Name: COLUMN ta_crown_tenures_svw.tenure_area_in_hectares; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.tenure_area_in_hectares IS 'The area or size of the interest parcel, presented in the metric unit of hectares, in some case excluding area covering water bodies or roads.';


--
-- Name: COLUMN ta_crown_tenures_svw.responsible_business_unit; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.responsible_business_unit IS 'The organizational group within the British Columbia government that is responsible for the land conveyance. For example, ''PE - LAND MGMNT - PEACE FIELD OFFICE'' indicates that the Peace Field Office in the Peace Land Management Region is responsible for all government interaction with the tenure holder and the tenured lands.';


--
-- Name: COLUMN ta_crown_tenures_svw.disposition_transaction_sid; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.disposition_transaction_sid IS 'A system-generated identifier for a specific instance of a disposition transaction. It can be used for joins to other disposition transaction data so long as appropriate business and data architecture rules are applied.';


--
-- Name: COLUMN ta_crown_tenures_svw.code_chr_stage; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.code_chr_stage IS 'A short text synonym or code for TENURE_STAGE  For example the tenure stage of ''APPLICATION'' has a corresponding code value of ''A''.';


--
-- Name: COLUMN ta_crown_tenures_svw.feature_code; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.feature_code IS 'A standard alphanumeric code to identify the type of feature represented by the spatial data.';


--
-- Name: COLUMN ta_crown_tenures_svw.objectid; Type: COMMENT; Schema: whse_tantalis; Owner: -
--

COMMENT ON COLUMN whse_tantalis.ta_crown_tenures_svw.objectid IS ' column required by spatial layers that interact with ESRI ArcSDE. It is populated with unique values automatically by SDE.';


--
-- Name: ta_crown_tenures_svw_objectid_seq; Type: SEQUENCE; Schema: whse_tantalis; Owner: -
--

CREATE SEQUENCE whse_tantalis.ta_crown_tenures_svw_objectid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ta_crown_tenures_svw_objectid_seq; Type: SEQUENCE OWNED BY; Schema: whse_tantalis; Owner: -
--

ALTER SEQUENCE whse_tantalis.ta_crown_tenures_svw_objectid_seq OWNED BY whse_tantalis.ta_crown_tenures_svw.objectid;


--
-- Name: ta_park_ecores_pa_svw_admin_area_sid_seq; Type: SEQUENCE; Schema: whse_tantalis; Owner: -
--

CREATE SEQUENCE whse_tantalis.ta_park_ecores_pa_svw_admin_area_sid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ta_park_ecores_pa_svw_admin_area_sid_seq; Type: SEQUENCE OWNED BY; Schema: whse_tantalis; Owner: -
--

ALTER SEQUENCE whse_tantalis.ta_park_ecores_pa_svw_admin_area_sid_seq OWNED BY whse_tantalis.ta_park_ecores_pa_svw.admin_area_sid;


--
-- Name: clab_national_parks national_park_id; Type: DEFAULT; Schema: whse_admin_boundaries; Owner: -
--

ALTER TABLE ONLY whse_admin_boundaries.clab_national_parks ALTER COLUMN national_park_id SET DEFAULT nextval('whse_admin_boundaries.clab_national_parks_national_park_id_seq'::regclass);


--
-- Name: fadm_tfl_all_sp tfl_all_sysid; Type: DEFAULT; Schema: whse_admin_boundaries; Owner: -
--

ALTER TABLE ONLY whse_admin_boundaries.fadm_tfl_all_sp ALTER COLUMN tfl_all_sysid SET DEFAULT nextval('whse_admin_boundaries.fadm_tfl_all_sp_tfl_all_sysid_seq'::regclass);


--
-- Name: pmbc_parcel_fabric_poly_svw parcel_fabric_poly_id; Type: DEFAULT; Schema: whse_cadastre; Owner: -
--

ALTER TABLE ONLY whse_cadastre.pmbc_parcel_fabric_poly_svw ALTER COLUMN parcel_fabric_poly_id SET DEFAULT nextval('whse_cadastre.pmbc_parcel_fabric_poly_svw_parcel_fabric_poly_id_seq'::regclass);


--
-- Name: fiss_stream_sample_sites_sp stream_sample_site_id; Type: DEFAULT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.fiss_stream_sample_sites_sp ALTER COLUMN stream_sample_site_id SET DEFAULT nextval('whse_fish.fiss_stream_sample_sites_sp_stream_sample_site_id_seq'::regclass);


--
-- Name: pscis_assessment_svw stream_crossing_id; Type: DEFAULT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.pscis_assessment_svw ALTER COLUMN stream_crossing_id SET DEFAULT nextval('whse_fish.pscis_assessment_svw_stream_crossing_id_seq'::regclass);


--
-- Name: pscis_design_proposal_svw stream_crossing_id; Type: DEFAULT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.pscis_design_proposal_svw ALTER COLUMN stream_crossing_id SET DEFAULT nextval('whse_fish.pscis_design_proposal_svw_stream_crossing_id_seq'::regclass);


--
-- Name: pscis_habitat_confirmation_svw stream_crossing_id; Type: DEFAULT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.pscis_habitat_confirmation_svw ALTER COLUMN stream_crossing_id SET DEFAULT nextval('whse_fish.pscis_habitat_confirmation_svw_stream_crossing_id_seq'::regclass);


--
-- Name: pscis_remediation_svw stream_crossing_id; Type: DEFAULT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.pscis_remediation_svw ALTER COLUMN stream_crossing_id SET DEFAULT nextval('whse_fish.pscis_remediation_svw_stream_crossing_id_seq'::regclass);


--
-- Name: ften_managed_licence_poly_svw objectid; Type: DEFAULT; Schema: whse_forest_tenure; Owner: -
--

ALTER TABLE ONLY whse_forest_tenure.ften_managed_licence_poly_svw ALTER COLUMN objectid SET DEFAULT nextval('whse_forest_tenure.ften_managed_licence_poly_svw_objectid_seq'::regclass);


--
-- Name: ften_range_poly_svw objectid; Type: DEFAULT; Schema: whse_forest_tenure; Owner: -
--

ALTER TABLE ONLY whse_forest_tenure.ften_range_poly_svw ALTER COLUMN objectid SET DEFAULT nextval('whse_forest_tenure.ften_range_poly_svw_objectid_seq'::regclass);


--
-- Name: ogsr_priority_def_area_cur_sp ogsr_pdac_sysid; Type: DEFAULT; Schema: whse_forest_vegetation; Owner: -
--

ALTER TABLE ONLY whse_forest_vegetation.ogsr_priority_def_area_cur_sp ALTER COLUMN ogsr_pdac_sysid SET DEFAULT nextval('whse_forest_vegetation.ogsr_priority_def_area_cur_sp_ogsr_pdac_sysid_seq'::regclass);


--
-- Name: veg_comp_lyr_r1_poly feature_id; Type: DEFAULT; Schema: whse_forest_vegetation; Owner: -
--

ALTER TABLE ONLY whse_forest_vegetation.veg_comp_lyr_r1_poly ALTER COLUMN feature_id SET DEFAULT nextval('whse_forest_vegetation.veg_comp_lyr_r1_poly_feature_id_seq'::regclass);


--
-- Name: veg_consolidated_cut_blocks_sp vccb_sysid; Type: DEFAULT; Schema: whse_forest_vegetation; Owner: -
--

ALTER TABLE ONLY whse_forest_vegetation.veg_consolidated_cut_blocks_sp ALTER COLUMN vccb_sysid SET DEFAULT nextval('whse_forest_vegetation.veg_consolidated_cut_blocks_sp_vccb_sysid_seq'::regclass);


--
-- Name: abms_municipalities_sp lgl_admin_area_id; Type: DEFAULT; Schema: whse_legal_admin_boundaries; Owner: -
--

ALTER TABLE ONLY whse_legal_admin_boundaries.abms_municipalities_sp ALTER COLUMN lgl_admin_area_id SET DEFAULT nextval('whse_legal_admin_boundaries.abms_municipalities_sp_lgl_admin_area_id_seq'::regclass);


--
-- Name: ta_conservancy_areas_svw admin_area_sid; Type: DEFAULT; Schema: whse_tantalis; Owner: -
--

ALTER TABLE ONLY whse_tantalis.ta_conservancy_areas_svw ALTER COLUMN admin_area_sid SET DEFAULT nextval('whse_tantalis.ta_conservancy_areas_svw_admin_area_sid_seq'::regclass);


--
-- Name: ta_crown_tenures_svw objectid; Type: DEFAULT; Schema: whse_tantalis; Owner: -
--

ALTER TABLE ONLY whse_tantalis.ta_crown_tenures_svw ALTER COLUMN objectid SET DEFAULT nextval('whse_tantalis.ta_crown_tenures_svw_objectid_seq'::regclass);


--
-- Name: ta_park_ecores_pa_svw admin_area_sid; Type: DEFAULT; Schema: whse_tantalis; Owner: -
--

ALTER TABLE ONLY whse_tantalis.ta_park_ecores_pa_svw ALTER COLUMN admin_area_sid SET DEFAULT nextval('whse_tantalis.ta_park_ecores_pa_svw_admin_area_sid_seq'::regclass);


--
-- Name: clab_indian_reserves clab_indian_reserves_pkey; Type: CONSTRAINT; Schema: whse_admin_boundaries; Owner: -
--

ALTER TABLE ONLY whse_admin_boundaries.clab_indian_reserves
    ADD CONSTRAINT clab_indian_reserves_pkey PRIMARY KEY (clab_id);


--
-- Name: clab_national_parks clab_national_parks_pkey; Type: CONSTRAINT; Schema: whse_admin_boundaries; Owner: -
--

ALTER TABLE ONLY whse_admin_boundaries.clab_national_parks
    ADD CONSTRAINT clab_national_parks_pkey PRIMARY KEY (national_park_id);


--
-- Name: fadm_designated_areas fadm_designated_areas_pkey; Type: CONSTRAINT; Schema: whse_admin_boundaries; Owner: -
--

ALTER TABLE ONLY whse_admin_boundaries.fadm_designated_areas
    ADD CONSTRAINT fadm_designated_areas_pkey PRIMARY KEY (feature_id);


--
-- Name: fadm_tfl_all_sp fadm_tfl_all_sp_pkey; Type: CONSTRAINT; Schema: whse_admin_boundaries; Owner: -
--

ALTER TABLE ONLY whse_admin_boundaries.fadm_tfl_all_sp
    ADD CONSTRAINT fadm_tfl_all_sp_pkey PRIMARY KEY (tfl_all_sysid);


--
-- Name: pmbc_parcel_fabric_poly_svw pmbc_parcel_fabric_poly_svw_pkey; Type: CONSTRAINT; Schema: whse_cadastre; Owner: -
--

ALTER TABLE ONLY whse_cadastre.pmbc_parcel_fabric_poly_svw
    ADD CONSTRAINT pmbc_parcel_fabric_poly_svw_pkey PRIMARY KEY (parcel_fabric_poly_id);


--
-- Name: fiss_stream_sample_sites_sp fiss_stream_sample_sites_sp_pkey; Type: CONSTRAINT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.fiss_stream_sample_sites_sp
    ADD CONSTRAINT fiss_stream_sample_sites_sp_pkey PRIMARY KEY (stream_sample_site_id);


--
-- Name: pscis_assessment_svw pscis_assessment_svw_pkey; Type: CONSTRAINT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.pscis_assessment_svw
    ADD CONSTRAINT pscis_assessment_svw_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: pscis_design_proposal_svw pscis_design_proposal_svw_pkey; Type: CONSTRAINT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.pscis_design_proposal_svw
    ADD CONSTRAINT pscis_design_proposal_svw_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: pscis_habitat_confirmation_svw pscis_habitat_confirmation_svw_pkey; Type: CONSTRAINT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.pscis_habitat_confirmation_svw
    ADD CONSTRAINT pscis_habitat_confirmation_svw_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: pscis_remediation_svw pscis_remediation_svw_pkey; Type: CONSTRAINT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.pscis_remediation_svw
    ADD CONSTRAINT pscis_remediation_svw_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: species_cd species_cd_pkey; Type: CONSTRAINT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.species_cd
    ADD CONSTRAINT species_cd_pkey PRIMARY KEY (species_id);


--
-- Name: species_cd uq_species_code; Type: CONSTRAINT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.species_cd
    ADD CONSTRAINT uq_species_code UNIQUE (code);


--
-- Name: wdic_waterbodies wdic_waterbodies_pkey; Type: CONSTRAINT; Schema: whse_fish; Owner: -
--

ALTER TABLE ONLY whse_fish.wdic_waterbodies
    ADD CONSTRAINT wdic_waterbodies_pkey PRIMARY KEY (id);


--
-- Name: ften_managed_licence_poly_svw ften_managed_licence_poly_svw_pkey; Type: CONSTRAINT; Schema: whse_forest_tenure; Owner: -
--

ALTER TABLE ONLY whse_forest_tenure.ften_managed_licence_poly_svw
    ADD CONSTRAINT ften_managed_licence_poly_svw_pkey PRIMARY KEY (objectid);


--
-- Name: ften_range_poly_svw ften_range_poly_svw_pkey; Type: CONSTRAINT; Schema: whse_forest_tenure; Owner: -
--

ALTER TABLE ONLY whse_forest_tenure.ften_range_poly_svw
    ADD CONSTRAINT ften_range_poly_svw_pkey PRIMARY KEY (objectid);


--
-- Name: ogsr_priority_def_area_cur_sp ogsr_priority_def_area_cur_sp_pkey; Type: CONSTRAINT; Schema: whse_forest_vegetation; Owner: -
--

ALTER TABLE ONLY whse_forest_vegetation.ogsr_priority_def_area_cur_sp
    ADD CONSTRAINT ogsr_priority_def_area_cur_sp_pkey PRIMARY KEY (ogsr_pdac_sysid);


--
-- Name: veg_comp_lyr_r1_poly veg_comp_lyr_r1_poly_pkey; Type: CONSTRAINT; Schema: whse_forest_vegetation; Owner: -
--

ALTER TABLE ONLY whse_forest_vegetation.veg_comp_lyr_r1_poly
    ADD CONSTRAINT veg_comp_lyr_r1_poly_pkey PRIMARY KEY (feature_id);


--
-- Name: veg_consolidated_cut_blocks_sp veg_consolidated_cut_blocks_sp_pkey; Type: CONSTRAINT; Schema: whse_forest_vegetation; Owner: -
--

ALTER TABLE ONLY whse_forest_vegetation.veg_consolidated_cut_blocks_sp
    ADD CONSTRAINT veg_consolidated_cut_blocks_sp_pkey PRIMARY KEY (vccb_sysid);


--
-- Name: abms_municipalities_sp abms_municipalities_sp_pkey; Type: CONSTRAINT; Schema: whse_legal_admin_boundaries; Owner: -
--

ALTER TABLE ONLY whse_legal_admin_boundaries.abms_municipalities_sp
    ADD CONSTRAINT abms_municipalities_sp_pkey PRIMARY KEY (lgl_admin_area_id);


--
-- Name: ta_conservancy_areas_svw ta_conservancy_areas_svw_pkey; Type: CONSTRAINT; Schema: whse_tantalis; Owner: -
--

ALTER TABLE ONLY whse_tantalis.ta_conservancy_areas_svw
    ADD CONSTRAINT ta_conservancy_areas_svw_pkey PRIMARY KEY (admin_area_sid);


--
-- Name: ta_crown_tenures_svw ta_crown_tenures_svw_pkey; Type: CONSTRAINT; Schema: whse_tantalis; Owner: -
--

ALTER TABLE ONLY whse_tantalis.ta_crown_tenures_svw
    ADD CONSTRAINT ta_crown_tenures_svw_pkey PRIMARY KEY (objectid);


--
-- Name: ta_park_ecores_pa_svw ta_park_ecores_pa_svw_pkey; Type: CONSTRAINT; Schema: whse_tantalis; Owner: -
--

ALTER TABLE ONLY whse_tantalis.ta_park_ecores_pa_svw
    ADD CONSTRAINT ta_park_ecores_pa_svw_pkey PRIMARY KEY (admin_area_sid);


--
-- Name: idx_adm_indian_reserves_bands_sp_geom; Type: INDEX; Schema: whse_admin_boundaries; Owner: -
--

CREATE INDEX idx_adm_indian_reserves_bands_sp_geom ON whse_admin_boundaries.adm_indian_reserves_bands_sp USING gist (geom);


--
-- Name: idx_adm_nr_districts_spg_geom; Type: INDEX; Schema: whse_admin_boundaries; Owner: -
--

CREATE INDEX idx_adm_nr_districts_spg_geom ON whse_admin_boundaries.adm_nr_districts_spg USING gist (geom);


--
-- Name: idx_clab_indian_reserves_geom; Type: INDEX; Schema: whse_admin_boundaries; Owner: -
--

CREATE INDEX idx_clab_indian_reserves_geom ON whse_admin_boundaries.clab_indian_reserves USING gist (geom);


--
-- Name: idx_clab_national_parks_geom; Type: INDEX; Schema: whse_admin_boundaries; Owner: -
--

CREATE INDEX idx_clab_national_parks_geom ON whse_admin_boundaries.clab_national_parks USING gist (geom);


--
-- Name: idx_fadm_designated_areas_geom; Type: INDEX; Schema: whse_admin_boundaries; Owner: -
--

CREATE INDEX idx_fadm_designated_areas_geom ON whse_admin_boundaries.fadm_designated_areas USING gist (geom);


--
-- Name: idx_fadm_tfl_all_sp_geom; Type: INDEX; Schema: whse_admin_boundaries; Owner: -
--

CREATE INDEX idx_fadm_tfl_all_sp_geom ON whse_admin_boundaries.fadm_tfl_all_sp USING gist (geom);


--
-- Name: idx_pmbc_parcel_fabric_poly_svw_geom; Type: INDEX; Schema: whse_cadastre; Owner: -
--

CREATE INDEX idx_pmbc_parcel_fabric_poly_svw_geom ON whse_cadastre.pmbc_parcel_fabric_poly_svw USING gist (geom);


--
-- Name: idx_fiss_fish_obsrvtn_pnt_sp_geom; Type: INDEX; Schema: whse_fish; Owner: -
--

CREATE INDEX idx_fiss_fish_obsrvtn_pnt_sp_geom ON whse_fish.fiss_fish_obsrvtn_pnt_sp USING gist (geom);


--
-- Name: idx_fiss_obstacles_pnt_sp_geom; Type: INDEX; Schema: whse_fish; Owner: -
--

CREATE INDEX idx_fiss_obstacles_pnt_sp_geom ON whse_fish.fiss_obstacles_pnt_sp USING gist (geom);


--
-- Name: idx_fiss_stream_sample_sites_sp_geom; Type: INDEX; Schema: whse_fish; Owner: -
--

CREATE INDEX idx_fiss_stream_sample_sites_sp_geom ON whse_fish.fiss_stream_sample_sites_sp USING gist (geom);


--
-- Name: idx_pscis_assessment_svw_geom; Type: INDEX; Schema: whse_fish; Owner: -
--

CREATE INDEX idx_pscis_assessment_svw_geom ON whse_fish.pscis_assessment_svw USING gist (geom);


--
-- Name: idx_pscis_design_proposal_svw_geom; Type: INDEX; Schema: whse_fish; Owner: -
--

CREATE INDEX idx_pscis_design_proposal_svw_geom ON whse_fish.pscis_design_proposal_svw USING gist (geom);


--
-- Name: idx_pscis_habitat_confirmation_svw_geom; Type: INDEX; Schema: whse_fish; Owner: -
--

CREATE INDEX idx_pscis_habitat_confirmation_svw_geom ON whse_fish.pscis_habitat_confirmation_svw USING gist (geom);


--
-- Name: idx_pscis_remediation_svw_geom; Type: INDEX; Schema: whse_fish; Owner: -
--

CREATE INDEX idx_pscis_remediation_svw_geom ON whse_fish.pscis_remediation_svw USING gist (geom);


--
-- Name: wdic_waterbodies_typeidx; Type: INDEX; Schema: whse_fish; Owner: -
--

CREATE INDEX wdic_waterbodies_typeidx ON whse_fish.wdic_waterbodies USING btree (type);


--
-- Name: wdic_waterbodies_wbtrimidx; Type: INDEX; Schema: whse_fish; Owner: -
--

CREATE INDEX wdic_waterbodies_wbtrimidx ON whse_fish.wdic_waterbodies USING btree (ltrim(waterbody_identifier, '0'::text));


--
-- Name: idx_ften_managed_licence_poly_svw_geom; Type: INDEX; Schema: whse_forest_tenure; Owner: -
--

CREATE INDEX idx_ften_managed_licence_poly_svw_geom ON whse_forest_tenure.ften_managed_licence_poly_svw USING gist (geom);


--
-- Name: idx_ften_range_poly_svw_geom; Type: INDEX; Schema: whse_forest_tenure; Owner: -
--

CREATE INDEX idx_ften_range_poly_svw_geom ON whse_forest_tenure.ften_range_poly_svw USING gist (geom);


--
-- Name: idx_ften_road_section_lines_svw_geom; Type: INDEX; Schema: whse_forest_tenure; Owner: -
--

CREATE INDEX idx_ften_road_section_lines_svw_geom ON whse_forest_tenure.ften_road_section_lines_svw USING gist (geom);


--
-- Name: idx_ogsr_priority_def_area_cur_sp_geom; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX idx_ogsr_priority_def_area_cur_sp_geom ON whse_forest_vegetation.ogsr_priority_def_area_cur_sp USING gist (geom);


--
-- Name: idx_veg_burn_severity_same_yr_sp_geom; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX idx_veg_burn_severity_same_yr_sp_geom ON whse_forest_vegetation.veg_burn_severity_same_yr_sp USING gist (geom);


--
-- Name: idx_veg_burn_severity_sp_geom; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX idx_veg_burn_severity_sp_geom ON whse_forest_vegetation.veg_burn_severity_sp USING gist (geom);


--
-- Name: idx_veg_comp_lyr_r1_poly_geom; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX idx_veg_comp_lyr_r1_poly_geom ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING gist (geom);


--
-- Name: idx_veg_consolidated_cut_blocks_sp_geom; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX idx_veg_consolidated_cut_blocks_sp_geom ON whse_forest_vegetation.veg_consolidated_cut_blocks_sp USING gist (geom);


--
-- Name: veg_comp_lyr_r1_poly_bclcs_level_1_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_bclcs_level_1_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (bclcs_level_1);


--
-- Name: veg_comp_lyr_r1_poly_bclcs_level_2_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_bclcs_level_2_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (bclcs_level_2);


--
-- Name: veg_comp_lyr_r1_poly_bclcs_level_3_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_bclcs_level_3_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (bclcs_level_3);


--
-- Name: veg_comp_lyr_r1_poly_bclcs_level_4_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_bclcs_level_4_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (bclcs_level_4);


--
-- Name: veg_comp_lyr_r1_poly_bclcs_level_5_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_bclcs_level_5_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (bclcs_level_5);


--
-- Name: veg_comp_lyr_r1_poly_for_mgmt_land_base_ind_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_for_mgmt_land_base_ind_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (for_mgmt_land_base_ind);


--
-- Name: veg_comp_lyr_r1_poly_inventory_standard_cd_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_inventory_standard_cd_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (inventory_standard_cd);


--
-- Name: veg_comp_lyr_r1_poly_map_id_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_map_id_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (map_id);


--
-- Name: veg_comp_lyr_r1_poly_non_productive_descriptor_cd_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_non_productive_descriptor_cd_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (non_productive_descriptor_cd);


--
-- Name: veg_comp_lyr_r1_poly_site_index_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_site_index_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (site_index);


--
-- Name: veg_comp_lyr_r1_poly_species_cd_1_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_species_cd_1_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (species_cd_1);


--
-- Name: veg_comp_lyr_r1_poly_species_pct_1_idx; Type: INDEX; Schema: whse_forest_vegetation; Owner: -
--

CREATE INDEX veg_comp_lyr_r1_poly_species_pct_1_idx ON whse_forest_vegetation.veg_comp_lyr_r1_poly USING btree (species_pct_1);


--
-- Name: idx_abms_municipalities_sp_geom; Type: INDEX; Schema: whse_legal_admin_boundaries; Owner: -
--

CREATE INDEX idx_abms_municipalities_sp_geom ON whse_legal_admin_boundaries.abms_municipalities_sp USING gist (geom);


--
-- Name: idx_abms_regional_districts_sp_geom; Type: INDEX; Schema: whse_legal_admin_boundaries; Owner: -
--

CREATE INDEX idx_abms_regional_districts_sp_geom ON whse_legal_admin_boundaries.abms_regional_districts_sp USING gist (geom);


--
-- Name: idx_ta_conservancy_areas_svw_geom; Type: INDEX; Schema: whse_tantalis; Owner: -
--

CREATE INDEX idx_ta_conservancy_areas_svw_geom ON whse_tantalis.ta_conservancy_areas_svw USING gist (geom);


--
-- Name: idx_ta_crown_tenures_svw_geom; Type: INDEX; Schema: whse_tantalis; Owner: -
--

CREATE INDEX idx_ta_crown_tenures_svw_geom ON whse_tantalis.ta_crown_tenures_svw USING gist (geom);


--
-- Name: idx_ta_park_ecores_pa_svw_geom; Type: INDEX; Schema: whse_tantalis; Owner: -
--

CREATE INDEX idx_ta_park_ecores_pa_svw_geom ON whse_tantalis.ta_park_ecores_pa_svw USING gist (geom);


--
-- PostgreSQL database dump complete
--


--
-- PostgreSQL database dump
--


-- Dumped from database version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)
-- Dumped by pg_dump version 17.7 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bcdata; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bcdata;


--
-- Name: bcfishobs; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bcfishobs;


--
-- Name: bcfishpass; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bcfishpass;


--
-- Name: cabd; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA cabd;


--
-- Name: aw_linear_summary(); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.aw_linear_summary() RETURNS TABLE(assessment_watershed_id integer, length_total numeric, length_naturallyaccessible_obsrvd_bt numeric, length_naturallyaccessible_obsrvd_bt_access_a numeric, length_naturallyaccessible_obsrvd_bt_access_b numeric, length_naturallyaccessible_model_bt numeric, length_naturallyaccessible_model_bt_access_a numeric, length_naturallyaccessible_model_bt_access_b numeric, length_naturallyaccessible_obsrvd_ch numeric, length_naturallyaccessible_obsrvd_ch_access_a numeric, length_naturallyaccessible_obsrvd_ch_access_b numeric, length_naturallyaccessible_model_ch numeric, length_naturallyaccessible_model_ch_access_a numeric, length_naturallyaccessible_model_ch_access_b numeric, length_naturallyaccessible_obsrvd_cm numeric, length_naturallyaccessible_obsrvd_cm_access_a numeric, length_naturallyaccessible_obsrvd_cm_access_b numeric, length_naturallyaccessible_model_cm numeric, length_naturallyaccessible_model_cm_access_a numeric, length_naturallyaccessible_model_cm_access_b numeric, length_naturallyaccessible_obsrvd_co numeric, length_naturallyaccessible_obsrvd_co_access_a numeric, length_naturallyaccessible_obsrvd_co_access_b numeric, length_naturallyaccessible_model_co numeric, length_naturallyaccessible_model_co_access_a numeric, length_naturallyaccessible_model_co_access_b numeric, length_naturallyaccessible_obsrvd_pk numeric, length_naturallyaccessible_obsrvd_pk_access_a numeric, length_naturallyaccessible_obsrvd_pk_access_b numeric, length_naturallyaccessible_model_pk numeric, length_naturallyaccessible_model_pk_access_a numeric, length_naturallyaccessible_model_pk_access_b numeric, length_naturallyaccessible_obsrvd_sk numeric, length_naturallyaccessible_obsrvd_sk_access_a numeric, length_naturallyaccessible_obsrvd_sk_access_b numeric, length_naturallyaccessible_model_sk numeric, length_naturallyaccessible_model_sk_access_a numeric, length_naturallyaccessible_model_sk_access_b numeric, length_naturallyaccessible_obsrvd_salmon numeric, length_naturallyaccessible_obsrvd_salmon_access_a numeric, length_naturallyaccessible_obsrvd_salmon_access_b numeric, length_naturallyaccessible_model_salmon numeric, length_naturallyaccessible_model_salmon_access_a numeric, length_naturallyaccessible_model_salmon_access_b numeric, length_naturallyaccessible_obsrvd_st numeric, length_naturallyaccessible_obsrvd_st_access_a numeric, length_naturallyaccessible_obsrvd_st_access_b numeric, length_naturallyaccessible_model_st numeric, length_naturallyaccessible_model_st_access_a numeric, length_naturallyaccessible_model_st_access_b numeric, length_naturallyaccessible_obsrvd_wct numeric, length_naturallyaccessible_obsrvd_wct_access_a numeric, length_naturallyaccessible_obsrvd_wct_access_b numeric, length_naturallyaccessible_model_wct numeric, length_naturallyaccessible_model_wct_access_a numeric, length_naturallyaccessible_model_wct_access_b numeric, length_spawningrearing_obsrvd_bt numeric, length_spawningrearing_obsrvd_bt_access_a numeric, length_spawningrearing_obsrvd_bt_access_b numeric, length_spawningrearing_model_bt numeric, length_spawningrearing_model_bt_access_a numeric, length_spawningrearing_model_bt_access_b numeric, length_spawningrearing_obsrvd_ch numeric, length_spawningrearing_obsrvd_ch_access_a numeric, length_spawningrearing_obsrvd_ch_access_b numeric, length_spawningrearing_model_ch numeric, length_spawningrearing_model_ch_access_a numeric, length_spawningrearing_model_ch_access_b numeric, length_spawningrearing_obsrvd_cm numeric, length_spawningrearing_obsrvd_cm_access_a numeric, length_spawningrearing_obsrvd_cm_access_b numeric, length_spawningrearing_model_cm numeric, length_spawningrearing_model_cm_access_a numeric, length_spawningrearing_model_cm_access_b numeric, length_spawningrearing_obsrvd_co numeric, length_spawningrearing_obsrvd_co_access_a numeric, length_spawningrearing_obsrvd_co_access_b numeric, length_spawningrearing_model_co numeric, length_spawningrearing_model_co_access_a numeric, length_spawningrearing_model_co_access_b numeric, length_spawningrearing_obsrvd_pk numeric, length_spawningrearing_obsrvd_pk_access_a numeric, length_spawningrearing_obsrvd_pk_access_b numeric, length_spawningrearing_model_pk numeric, length_spawningrearing_model_pk_access_a numeric, length_spawningrearing_model_pk_access_b numeric, length_spawningrearing_obsrvd_sk numeric, length_spawningrearing_obsrvd_sk_access_a numeric, length_spawningrearing_obsrvd_sk_access_b numeric, length_spawningrearing_model_sk numeric, length_spawningrearing_model_sk_access_a numeric, length_spawningrearing_model_sk_access_b numeric, length_spawningrearing_obsrvd_st numeric, length_spawningrearing_obsrvd_st_access_a numeric, length_spawningrearing_obsrvd_st_access_b numeric, length_spawningrearing_model_st numeric, length_spawningrearing_model_st_access_a numeric, length_spawningrearing_model_st_access_b numeric, length_spawningrearing_obsrvd_wct numeric, length_spawningrearing_obsrvd_wct_access_a numeric, length_spawningrearing_obsrvd_wct_access_b numeric, length_spawningrearing_model_wct numeric, length_spawningrearing_model_wct_access_a numeric, length_spawningrearing_model_wct_access_b numeric, length_spawningrearing_obsrvd_salmon numeric, length_spawningrearing_obsrvd_salmon_access_a numeric, length_spawningrearing_obsrvd_salmon_access_b numeric, length_spawningrearing_model_salmon numeric, length_spawningrearing_model_salmon_access_a numeric, length_spawningrearing_model_salmon_access_b numeric, length_spawningrearing_obsrvd_salmon_st numeric, length_spawningrearing_obsrvd_salmon_st_access_a numeric, length_spawningrearing_obsrvd_salmon_st_access_b numeric, length_spawningrearing_model_salmon_st numeric, length_spawningrearing_model_salmon_st_access_a numeric, length_spawningrearing_model_salmon_st_access_b numeric)
    LANGUAGE sql
    AS $$

with accessible as
(
  select
    aw.assmnt_watershed_id as assessment_watershed_id,
    s.watershed_group_code,
    sum(st_length(geom)) length_total,

    sum(st_length(geom)) filter (where s.access_bt = 2) as length_naturallyaccessible_obsrvd_bt,
    sum(st_length(geom)) filter (where s.access_bt = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_bt_access_a,
    sum(st_length(geom)) filter (where s.access_bt = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_bt_access_b,
    sum(st_length(geom)) filter (where s.access_bt = 1) as length_naturallyaccessible_model_bt,
    sum(st_length(geom)) filter (where s.access_bt = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_bt_access_a,
    sum(st_length(geom)) filter (where s.access_bt = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_bt_access_b,

    sum(st_length(geom)) filter (where s.access_ch = 2) as length_naturallyaccessible_obsrvd_ch,
    sum(st_length(geom)) filter (where s.access_ch = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_ch_access_a,
    sum(st_length(geom)) filter (where s.access_ch = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_ch_access_b,
    sum(st_length(geom)) filter (where s.access_ch = 1) as length_naturallyaccessible_model_ch,
    sum(st_length(geom)) filter (where s.access_ch = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_ch_access_a,
    sum(st_length(geom)) filter (where s.access_ch = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_ch_access_b,

    sum(st_length(geom)) filter (where s.access_cm = 2) as length_naturallyaccessible_obsrvd_cm,
    sum(st_length(geom)) filter (where s.access_cm = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_cm_access_a,
    sum(st_length(geom)) filter (where s.access_cm = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_cm_access_b,
    sum(st_length(geom)) filter (where s.access_cm = 1) as length_naturallyaccessible_model_cm,
    sum(st_length(geom)) filter (where s.access_cm = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_cm_access_a,
    sum(st_length(geom)) filter (where s.access_cm = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_cm_access_b,

    sum(st_length(geom)) filter (where s.access_co = 2) as length_naturallyaccessible_obsrvd_co,
    sum(st_length(geom)) filter (where s.access_co = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_co_access_a,
    sum(st_length(geom)) filter (where s.access_co = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_co_access_b,
    sum(st_length(geom)) filter (where s.access_co = 1) as length_naturallyaccessible_model_co,
    sum(st_length(geom)) filter (where s.access_co = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_co_access_a,
    sum(st_length(geom)) filter (where s.access_co = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_co_access_b,

    sum(st_length(geom)) filter (where s.access_pk = 2) as length_naturallyaccessible_obsrvd_pk,
    sum(st_length(geom)) filter (where s.access_pk = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_pk_access_a,
    sum(st_length(geom)) filter (where s.access_pk = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_pk_access_b,
    sum(st_length(geom)) filter (where s.access_pk = 1) as length_naturallyaccessible_model_pk,
    sum(st_length(geom)) filter (where s.access_pk = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_pk_access_a,
    sum(st_length(geom)) filter (where s.access_pk = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_pk_access_b,

    sum(st_length(geom)) filter (where s.access_sk = 2) as length_naturallyaccessible_obsrvd_sk,
    sum(st_length(geom)) filter (where s.access_sk = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_sk_access_a,
    sum(st_length(geom)) filter (where s.access_sk = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_sk_access_b,
    sum(st_length(geom)) filter (where s.access_sk = 1) as length_naturallyaccessible_model_sk,
    sum(st_length(geom)) filter (where s.access_sk = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_sk_access_a,
    sum(st_length(geom)) filter (where s.access_sk = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_sk_access_b,

    sum(st_length(geom)) filter (where s.access_salmon = 2) as length_naturallyaccessible_obsrvd_salmon,
    sum(st_length(geom)) filter (where s.access_salmon = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_salmon_access_a,
    sum(st_length(geom)) filter (where s.access_salmon = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_salmon_access_b,
    sum(st_length(geom)) filter (where s.access_salmon = 1) as length_naturallyaccessible_model_salmon,
    sum(st_length(geom)) filter (where s.access_salmon = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_salmon_access_a,
    sum(st_length(geom)) filter (where s.access_salmon = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_salmon_access_b,

    sum(st_length(geom)) filter (where s.access_st = 2) as length_naturallyaccessible_obsrvd_st,
    sum(st_length(geom)) filter (where s.access_st = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_st_access_a,
    sum(st_length(geom)) filter (where s.access_st = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_st_access_b,
    sum(st_length(geom)) filter (where s.access_st = 1) as length_naturallyaccessible_model_st,
    sum(st_length(geom)) filter (where s.access_st = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_st_access_a,
    sum(st_length(geom)) filter (where s.access_st = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_st_access_b,

    sum(st_length(geom)) filter (where s.access_wct = 2) as length_naturallyaccessible_obsrvd_wct,
    sum(st_length(geom)) filter (where s.access_wct = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_wct_access_a,
    sum(st_length(geom)) filter (where s.access_wct = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_wct_access_b,
    sum(st_length(geom)) filter (where s.access_wct = 1) as length_naturallyaccessible_model_wct,
    sum(st_length(geom)) filter (where s.access_wct = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_wct_access_a,
    sum(st_length(geom)) filter (where s.access_wct = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_wct_access_b
  from bcfishpass.streams_vw s
  inner join whse_basemapping.fwa_assessment_watersheds_streams_lut aw on s.linear_feature_id = aw.linear_feature_id
  group by aw.assmnt_watershed_id, s.watershed_group_code
),

spawning_rearing as (
  select
    aw.assmnt_watershed_id as assessment_watershed_id,
    s.watershed_group_code,

    -- bt
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) = 1) as length_spawningrearing_model_bt,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_bt_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_bt_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) >= 2) as length_spawningrearing_obsrvd_bt,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_bt_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_bt_access_b,

    -- ch
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) = 1) as length_spawningrearing_model_ch,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_ch_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_ch_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) >= 2) as length_spawningrearing_obsrvd_ch,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_ch_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_ch_access_b,

    -- cm
    sum(st_length(geom)) filter (where spawning_cm = 1) as length_spawningrearing_model_cm,
    sum(st_length(geom)) filter (where spawning_cm = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_cm_access_a,
    sum(st_length(geom)) filter (where spawning_cm = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_cm_access_b,
    sum(st_length(geom)) filter (where spawning_cm >= 2) as length_spawningrearing_obsrvd_cm,
    sum(st_length(geom)) filter (where spawning_cm >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_cm_access_a,
    sum(st_length(geom)) filter (where spawning_cm >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_cm_access_b,

    -- co
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) = 1) as length_spawningrearing_model_co,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_co_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_co_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) >= 2) as length_spawningrearing_obsrvd_co,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_co_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_co_access_b,

    -- pk
    sum(st_length(geom)) filter (where spawning_pk = 1) as length_spawningrearing_model_pk,
    sum(st_length(geom)) filter (where spawning_pk = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_pk_access_a,
    sum(st_length(geom)) filter (where spawning_pk = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_pk_access_b,
    sum(st_length(geom)) filter (where spawning_pk >= 2) as length_spawningrearing_obsrvd_pk,
    sum(st_length(geom)) filter (where spawning_pk >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_pk_access_a,
    sum(st_length(geom)) filter (where spawning_pk >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_pk_access_b,

    -- sk
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) = 1) as length_spawningrearing_model_sk,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_sk_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_sk_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) >= 2) as length_spawningrearing_obsrvd_sk,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_sk_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_sk_access_b,

    -- st
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) = 1) as length_spawningrearing_model_st,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_st_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_st_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) >= 2) as length_spawningrearing_obsrvd_st,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_st_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_st_access_b,

    -- wct
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) = 1) as length_spawningrearing_model_wct,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_wct_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_wct_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) >= 2) as length_spawningrearing_obsrvd_wct,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_wct_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_wct_access_b,

    -- all salmon
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) = 1
    ) as length_spawningrearing_model_salmon,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) = 1
        and barriers_dams_dnstr is null
        and barriers_pscis_dnstr is null
    ) as length_spawningrearing_model_salmon_access_a,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) = 1
        and barriers_anthropogenic_dnstr is null
    ) as length_spawningrearing_model_salmon_access_b,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) >= 2
    ) as length_spawningrearing_obsrvd_salmon,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) >= 2
        and barriers_dams_dnstr is null
        and barriers_pscis_dnstr is null
    ) as length_spawningrearing_obsrvd_salmon_access_a,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) >= 2
        and barriers_anthropogenic_dnstr is null
      ) as length_spawningrearing_obsrvd_salmon_access_b,

    -- all salmon AND steelhead
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) = 1
    ) as length_spawningrearing_model_salmon_st,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) = 1
        and barriers_dams_dnstr is null
        and barriers_pscis_dnstr is null
    ) as length_spawningrearing_model_salmon_st_access_a,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) = 1
        and barriers_anthropogenic_dnstr is null
    ) as length_spawningrearing_model_salmon_st_access_b,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) >= 2
    ) as length_spawningrearing_obsrvd_salmon_st,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) >= 2
        and barriers_dams_dnstr is null
        and barriers_pscis_dnstr is null
    ) as length_spawningrearing_obsrvd_salmon_st_access_a,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) >= 2
        and barriers_anthropogenic_dnstr is null
    ) as length_spawningrearing_obsrvd_salmon_st_access_b
  from bcfishpass.streams_vw s
  inner join whse_basemapping.fwa_assessment_watersheds_streams_lut aw on s.linear_feature_id = aw.linear_feature_id
  group by aw.assmnt_watershed_id, s.watershed_group_code
)

-- set to km, round to nearest cm (keep the high precision because this data gets rolled up to watershed group)
select
  a.assessment_watershed_id,
  round((coalesce(a.length_total, 0) / 1000)::numeric, 5) as length_total,
  round((coalesce(a.length_naturallyaccessible_obsrvd_bt, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_bt,
  round((coalesce(a.length_naturallyaccessible_obsrvd_bt_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_bt_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_bt_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_bt_access_b,
  round((coalesce(a.length_naturallyaccessible_model_bt, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_bt,
  round((coalesce(a.length_naturallyaccessible_model_bt_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_bt_access_a,
  round((coalesce(a.length_naturallyaccessible_model_bt_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_bt_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_ch, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_ch,
  round((coalesce(a.length_naturallyaccessible_obsrvd_ch_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_ch_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_ch_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_ch_access_b,
  round((coalesce(a.length_naturallyaccessible_model_ch, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_ch,
  round((coalesce(a.length_naturallyaccessible_model_ch_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_ch_access_a,
  round((coalesce(a.length_naturallyaccessible_model_ch_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_ch_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_cm, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_cm,
  round((coalesce(a.length_naturallyaccessible_obsrvd_cm_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_cm_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_cm_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_cm_access_b,
  round((coalesce(a.length_naturallyaccessible_model_cm, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_cm,
  round((coalesce(a.length_naturallyaccessible_model_cm_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_cm_access_a,
  round((coalesce(a.length_naturallyaccessible_model_cm_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_cm_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_co, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_co,
  round((coalesce(a.length_naturallyaccessible_obsrvd_co_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_co_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_co_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_co_access_b,
  round((coalesce(a.length_naturallyaccessible_model_co, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_co,
  round((coalesce(a.length_naturallyaccessible_model_co_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_co_access_a,
  round((coalesce(a.length_naturallyaccessible_model_co_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_co_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_pk, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_pk,
  round((coalesce(a.length_naturallyaccessible_obsrvd_pk_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_pk_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_pk_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_pk_access_b,
  round((coalesce(a.length_naturallyaccessible_model_pk, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_pk,
  round((coalesce(a.length_naturallyaccessible_model_pk_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_pk_access_a,
  round((coalesce(a.length_naturallyaccessible_model_pk_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_pk_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_sk, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_sk,
  round((coalesce(a.length_naturallyaccessible_obsrvd_sk_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_sk_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_sk_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_sk_access_b,
  round((coalesce(a.length_naturallyaccessible_model_sk, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_sk,
  round((coalesce(a.length_naturallyaccessible_model_sk_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_sk_access_a,
  round((coalesce(a.length_naturallyaccessible_model_sk_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_sk_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_salmon, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_salmon,
  round((coalesce(a.length_naturallyaccessible_obsrvd_salmon_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_salmon_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_salmon_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_salmon_access_b,
  round((coalesce(a.length_naturallyaccessible_model_salmon, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_salmon,
  round((coalesce(a.length_naturallyaccessible_model_salmon_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_salmon_access_a,
  round((coalesce(a.length_naturallyaccessible_model_salmon_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_salmon_access_b,
  round((coalesce(a.length_naturallyaccessible_obsrvd_st, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_st,
  round((coalesce(a.length_naturallyaccessible_obsrvd_st_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_st_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_st_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_st_access_b,
  round((coalesce(a.length_naturallyaccessible_model_st, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_st,
  round((coalesce(a.length_naturallyaccessible_model_st_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_st_access_a,
  round((coalesce(a.length_naturallyaccessible_model_st_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_st_access_b,
  round((coalesce(a.length_naturallyaccessible_obsrvd_wct, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_wct,
  round((coalesce(a.length_naturallyaccessible_obsrvd_wct_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_wct_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_wct_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_wct_access_b,
  round((coalesce(a.length_naturallyaccessible_model_wct, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_wct,
  round((coalesce(a.length_naturallyaccessible_model_wct_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_wct_access_a,
  round((coalesce(a.length_naturallyaccessible_model_wct_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_wct_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_bt, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_bt,
  round((coalesce(h.length_spawningrearing_obsrvd_bt_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_bt_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_bt_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_bt_access_b,
  round((coalesce(h.length_spawningrearing_model_bt, 0) / 1000)::numeric, 5) as length_spawningrearing_model_bt,
  round((coalesce(h.length_spawningrearing_model_bt_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_bt_access_a,
  round((coalesce(h.length_spawningrearing_model_bt_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_bt_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_ch, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_ch,
  round((coalesce(h.length_spawningrearing_obsrvd_ch_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_ch_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_ch_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_ch_access_b,
  round((coalesce(h.length_spawningrearing_model_ch, 0) / 1000)::numeric, 5) as length_spawningrearing_model_ch,
  round((coalesce(h.length_spawningrearing_model_ch_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_ch_access_a,
  round((coalesce(h.length_spawningrearing_model_ch_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_ch_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_cm, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_cm,
  round((coalesce(h.length_spawningrearing_obsrvd_cm_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_cm_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_cm_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_cm_access_b,
  round((coalesce(h.length_spawningrearing_model_cm, 0) / 1000)::numeric, 5) as length_spawningrearing_model_cm,
  round((coalesce(h.length_spawningrearing_model_cm_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_cm_access_a,
  round((coalesce(h.length_spawningrearing_model_cm_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_cm_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_co, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_co,
  round((coalesce(h.length_spawningrearing_obsrvd_co_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_co_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_co_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_co_access_b,
  round((coalesce(h.length_spawningrearing_model_co, 0) / 1000)::numeric, 5) as length_spawningrearing_model_co,
  round((coalesce(h.length_spawningrearing_model_co_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_co_access_a,
  round((coalesce(h.length_spawningrearing_model_co_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_co_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_pk, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_pk,
  round((coalesce(h.length_spawningrearing_obsrvd_pk_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_pk_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_pk_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_pk_access_b,
  round((coalesce(h.length_spawningrearing_model_pk, 0) / 1000)::numeric, 5) as length_spawningrearing_model_pk,
  round((coalesce(h.length_spawningrearing_model_pk_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_pk_access_a,
  round((coalesce(h.length_spawningrearing_model_pk_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_pk_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_sk, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_sk,
  round((coalesce(h.length_spawningrearing_obsrvd_sk_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_sk_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_sk_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_sk_access_b,
  round((coalesce(h.length_spawningrearing_model_sk, 0) / 1000)::numeric, 5) as length_spawningrearing_model_sk,
  round((coalesce(h.length_spawningrearing_model_sk_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_sk_access_a,
  round((coalesce(h.length_spawningrearing_model_sk_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_sk_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_st, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_st,
  round((coalesce(h.length_spawningrearing_obsrvd_st_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_st_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_st_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_st_access_b,
  round((coalesce(h.length_spawningrearing_model_st, 0) / 1000)::numeric, 5) as length_spawningrearing_model_st,
  round((coalesce(h.length_spawningrearing_model_st_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_st_access_a,
  round((coalesce(h.length_spawningrearing_model_st_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_st_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_wct, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_wct,
  round((coalesce(h.length_spawningrearing_obsrvd_wct_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_wct_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_wct_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_wct_access_b,
  round((coalesce(h.length_spawningrearing_model_wct, 0) / 1000)::numeric, 5) as length_spawningrearing_model_wct,
  round((coalesce(h.length_spawningrearing_model_wct_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_wct_access_a,
  round((coalesce(h.length_spawningrearing_model_wct_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_wct_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_access_b,
  round((coalesce(h.length_spawningrearing_model_salmon, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon,
  round((coalesce(h.length_spawningrearing_model_salmon_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_access_a,
  round((coalesce(h.length_spawningrearing_model_salmon_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_st, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_st,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_st_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_st_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_st_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_st_access_b,
  round((coalesce(h.length_spawningrearing_model_salmon_st, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_st,
  round((coalesce(h.length_spawningrearing_model_salmon_st_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_st_access_a,
  round((coalesce(h.length_spawningrearing_model_salmon_st_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_st_access_b
from accessible a
left outer join spawning_rearing h on a.assessment_watershed_id = h.assessment_watershed_id
order by a.assessment_watershed_id

$$;


--
-- Name: break_streams(text, text); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.break_streams(point_table text, wsg text) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

  EXECUTE format('
    ---------------------------------------------------------------
    -- create a temp table where we segment streams at point locations
    ---------------------------------------------------------------
    CREATE TEMPORARY TABLE temp_streams AS
    WITH breakpoints AS
    (
    -- because we are rounding the measure, collapse any duplicates with DISTINCT
    -- note that rounding only works (does not potentially shift the point off of stream of interest)
    -- because we are joining only if the point is not within 1m of the endpoint
      SELECT DISTINCT
        blue_line_key,
        round(downstream_route_measure::numeric)::integer as downstream_route_measure
      FROM bcfishpass.%I
      WHERE watershed_group_code = %L
    ),

    to_break AS
    (
      SELECT
        s.segmented_stream_id,
        s.linear_feature_id,
        s.downstream_route_measure AS meas_stream_ds,
        s.upstream_route_measure AS meas_stream_us,
        b.downstream_route_measure AS meas_event
      FROM
        bcfishpass.streams s
        INNER JOIN breakpoints b
        ON s.blue_line_key = b.blue_line_key AND
        -- match based on measure, but only break stream lines where the
        -- barrier pt is >1m from the end of the existing stream segment
        (b.downstream_route_measure - s.downstream_route_measure) > 1 AND
        (s.upstream_route_measure - b.downstream_route_measure) > 1
    ),

    -- derive measures of new lines from break points
    new_measures AS
    (
      SELECT
        segmented_stream_id,
        linear_feature_id,
        --meas_stream_ds,
        --meas_stream_us,
        meas_event AS downstream_route_measure,
        lead(meas_event, 1, meas_stream_us) OVER (PARTITION BY segmented_stream_id
          ORDER BY meas_event) AS upstream_route_measure
      FROM
        to_break
    )

    -- create new geoms
    SELECT
      n.segmented_stream_id,
      s.linear_feature_id,
      n.downstream_route_measure,
      n.upstream_route_measure,
      s.upstream_area_ha             ,
      s.stream_order_parent          ,
      s.stream_order_max             ,
      s.map_upstream                 ,
      s.channel_width                ,
      s.mad_m3s                      ,
      (ST_Dump(ST_LocateBetween
        (s.geom, n.downstream_route_measure, n.upstream_route_measure
        ))).geom AS geom
    FROM new_measures n
    INNER JOIN bcfishpass.streams s ON n.segmented_stream_id = s.segmented_stream_id;


    ---------------------------------------------------------------
    -- shorten existing stream features
    ---------------------------------------------------------------
    WITH min_segs AS
    (
      SELECT DISTINCT ON (segmented_stream_id)
        segmented_stream_id,
        downstream_route_measure
      FROM
        temp_streams
      ORDER BY
        segmented_stream_id,
        downstream_route_measure ASC
    ),

    shortened AS
    (
      SELECT
        m.segmented_stream_id,
        ST_Length(ST_LocateBetween(s.geom, s.downstream_route_measure, m.downstream_route_measure)) as length_metre,
        (ST_Dump(ST_LocateBetween (s.geom, s.downstream_route_measure, m.downstream_route_measure))).geom as geom
      FROM min_segs m
      INNER JOIN bcfishpass.streams s
      ON m.segmented_stream_id = s.segmented_stream_id
    )

    UPDATE
      bcfishpass.streams a
    SET
      geom = b.geom
    FROM
      shortened b
    WHERE
      b.segmented_stream_id = a.segmented_stream_id;


    ---------------------------------------------------------------
    -- now insert new features
    ---------------------------------------------------------------
    INSERT INTO bcfishpass.streams
    (
      linear_feature_id,
      edge_type,
      blue_line_key,
      watershed_key,
      watershed_group_code,
      waterbody_key,
      wscode_ltree,
      localcode_ltree,
      gnis_name,
      stream_order,
      stream_magnitude,
      feature_code,
      upstream_area_ha             ,
      stream_order_parent          ,
      stream_order_max             ,
      map_upstream                 ,
      channel_width                ,
      mad_m3s                      ,
      geom
    )
    SELECT
      t.linear_feature_id,
      s.edge_type,
      s.blue_line_key,
      s.watershed_key,
      s.watershed_group_code,
      s.waterbody_key,
      s.wscode_ltree,
      s.localcode_ltree,
      s.gnis_name,
      s.stream_order,
      s.stream_magnitude,
      s.feature_code,
      t.upstream_area_ha             ,
      t.stream_order_parent          ,
      t.stream_order_max             ,
      t.map_upstream                 ,
      t.channel_width                ,
      t.mad_m3s                      ,
      t.geom
    FROM temp_streams t
    INNER JOIN whse_basemapping.fwa_stream_networks_sp s
    ON t.linear_feature_id = s.linear_feature_id
    ON CONFLICT DO NOTHING;',
    point_table,
    wsg
  );

END
$$;


--
-- Name: create_barrier_table(text); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.create_barrier_table(barriertype text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    EXECUTE format('
        DROP TABLE IF EXISTS bcfishpass.%I;

        CREATE UNLOGGED TABLE bcfishpass.%I
        (
            %I text primary key,
            barrier_type text,
            barrier_name text,
            linear_feature_id integer,
            blue_line_key integer,
            watershed_key integer,
            downstream_route_measure double precision,
            wscode_ltree ltree,
            localcode_ltree ltree,
            watershed_group_code character varying (4),
            geom geometry(Point, 3005),
            UNIQUE (blue_line_key, downstream_route_measure)
        );',
        'barriers_' || barriertype,
        'barriers_' || barriertype,
        'barriers_' || barriertype || '_id'
    );

    EXECUTE format('
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (linear_feature_id);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (blue_line_key);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (watershed_key);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (blue_line_key, downstream_route_measure);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (watershed_group_code);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING GIST (wscode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING BTREE (wscode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING GIST (localcode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING BTREE (localcode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING GIST (geom);',
        'br_' || barriertype || '_linear_feature_id_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_blue_line_key_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_wskey_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_blk_meas_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_watershed_group_code_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_wscode_ltree_gidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_wscode_ltree_bidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_localcode_ltree_gidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_localcode_ltree_bidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_geom_idx',
        'barriers_' || barriertype
    );

END
$$;


--
-- Name: load_dnstr(text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.load_dnstr(table_a text, table_a_id text, table_b text, table_b_id text, out_table text, dnstr_id text, include_equivalents text, wsg text) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

  EXECUTE format('

    insert into %5$s
    (%2$s, %6$s)

    select
      %2$s,
      array_agg(downstream_id) filter (where downstream_id is not null) as %6$s
    from
        (select
            a.%2$s,
            b.%4$s as downstream_id
        from
            %1$s a
        inner join %3$s b on
        fwa_downstream(
            a.blue_line_key,
            a.downstream_route_measure,
            a.wscode_ltree,
            a.localcode_ltree,
            b.blue_line_key,
            b.downstream_route_measure,
            b.wscode_ltree,
            b.localcode_ltree,
            %7$s,
            1
        )
        where a.watershed_group_code = %8$L
        order by
          a.%2$s,
          b.wscode_ltree desc,
          b.localcode_ltree desc,
          b.downstream_route_measure desc
        ) as d
    group by %2$s

    on conflict ( %2$s )
    do update set %6$s = EXCLUDED.%6$s;',
table_a,
table_a_id,
table_b,
table_b_id,
out_table,
dnstr_id,
include_equivalents,
wsg);

END
$_$;


--
-- Name: load_dnstr_chunked(text, text, text, text, text, text, text, integer, integer); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.load_dnstr_chunked(table_a text, table_a_id text, table_b text, table_b_id text, out_table text, dnstr_id text, include_equivalents text, chunk_limit integer, chunk_offset integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

  EXECUTE format('

    with chunk as (
      select * 
      from %1$s 
      limit %8$s offset %9$s
    )

    insert into %5$s
    (%2$s, %6$s)

    select
      %2$s,
      array_agg(downstream_id) filter (where downstream_id is not null) as %6$s
    from
        (select
            a.%2$s,
            b.%4$s as downstream_id
        from
            chunk a
        inner join %3$s b on
        fwa_downstream(
            a.blue_line_key,
            a.downstream_route_measure,
            a.wscode_ltree,
            a.localcode_ltree,
            b.blue_line_key,
            b.downstream_route_measure,
            b.wscode_ltree,
            b.localcode_ltree,
            %7$s,
            1
        )
        order by
          a.%2$s,
          b.wscode_ltree desc,
          b.localcode_ltree desc,
          b.downstream_route_measure desc
        ) as d
    group by %2$s;',
table_a,
table_a_id,
table_b,
table_b_id,
out_table,
dnstr_id,
include_equivalents,
chunk_limit,
chunk_offset);

END
$_$;


--
-- Name: load_upstr(text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.load_upstr(table_a text, table_a_id text, table_b text, table_b_id text, out_table text, upstr_id text, include_equivalents text, wsg text) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

  EXECUTE format('

    insert into %5$s
    (%2$s, %6$s)

    select
      %2$s,
      array_agg(upstream_id) filter (where upstream_id is not null) as %6$s
    from
        (select
            a.%2$s,
            b.%4$s as upstream_id
        from
            %1$s a
        inner join %3$s b on
        fwa_upstream(
            a.blue_line_key,
            a.downstream_route_measure,
            a.wscode_ltree,
            a.localcode_ltree,
            b.blue_line_key,
            b.downstream_route_measure,
            b.wscode_ltree,
            b.localcode_ltree,
            %7$s,
            1
        )
        where a.watershed_group_code = %8$L
        order by
          a.%2$s,
          b.wscode_ltree desc,
          b.localcode_ltree desc,
          b.downstream_route_measure desc
        ) as d
    group by %2$s;',
table_a,
table_a_id,
table_b,
table_b_id,
out_table,
upstr_id,
include_equivalents,
wsg);

END
$_$;


--
-- Name: streamsasmvt(integer, integer, integer); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.streamsasmvt(z integer, x integer, y integer) RETURNS bytea
    LANGUAGE plpgsql STABLE PARALLEL SAFE
    AS $$
DECLARE
    result bytea;
BEGIN
    WITH
    
    bounds AS (
      SELECT ST_TileEnvelope(z, x, y) AS geom
    ), 

    mvtgeom AS (
      SELECT
        s.segmented_stream_id,
        s.linear_feature_id,
        s.edge_type,
        s.blue_line_key,
        s.watershed_key,
        s.watershed_group_code,
        s.downstream_route_measure,
        s.length_metre,
        s.waterbody_key,
        s.wscode_ltree,
        s.localcode_ltree,
        s.gnis_name,
        s.stream_order,
        s.stream_magnitude,
        s.gradient,
        s.feature_code,
        s.upstream_route_measure,
        s.upstream_area_ha,
        s.stream_order_parent,
        s.stream_order_max,
        s.map_upstream,
        s.channel_width,
        s.mad_m3s,
        s.barriers_anthropogenic_dnstr,
        s.barriers_pscis_dnstr,
        s.barriers_dams_dnstr,
        s.barriers_dams_hydro_dnstr,
        s.barriers_bt_dnstr,
        s.barriers_ch_cm_co_pk_sk_dnstr,
        s.barriers_ct_dv_rb_dnstr,
        s.barriers_st_dnstr,
        s.barriers_wct_dnstr,
        s.crossings_dnstr,
        s.dam_dnstr_ind,
        s.dam_hydro_dnstr_ind,
        s.remediated_dnstr_ind,
        s.obsrvtn_event_upstr,
        s.obsrvtn_species_codes_upstr,
        s.species_codes_dnstr,
        s.model_spawning_bt,
        s.model_spawning_ch,
        s.model_spawning_cm,
        s.model_spawning_co,
        s.model_spawning_pk,
        s.model_spawning_sk,
        s.model_spawning_st,
        s.model_spawning_wct,
        s.model_rearing_bt,
        s.model_rearing_ch,
        s.model_rearing_co,
        s.model_rearing_sk,
        s.model_rearing_st,
        s.model_rearing_wct,
        s.mapping_code_bt,
        s.mapping_code_ch,
        s.mapping_code_cm,
        s.mapping_code_co,
        s.mapping_code_pk,
        s.mapping_code_sk,
        s.mapping_code_st,
        s.mapping_code_wct,
        s.mapping_code_salmon,
        ST_AsMVTGeom(ST_Transform(ST_Force2D(s.geom), 3857), bounds.geom)
      FROM bcfishpass.streams s, bounds
      WHERE ST_Intersects(s.geom, ST_Transform((select geom from bounds), 3005))
      AND s.edge_type != 6010 
      AND s.wscode_ltree is not null
      AND s.stream_order_max >= (-z + 13)
     )

    SELECT ST_AsMVT(mvtgeom, 'default')
    INTO result
    FROM mvtgeom;

    RETURN result;
END;
$$;


--
-- Name: FUNCTION streamsasmvt(z integer, x integer, y integer); Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON FUNCTION bcfishpass.streamsasmvt(z integer, x integer, y integer) IS 'Zoom-level dependent bcfishpass streams';


--
-- Name: utmzone(public.geometry); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.utmzone(public.geometry) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
 DECLARE
     geomgeog geometry;
     zone int;
     pref int;

 BEGIN
     geomgeog:= ST_Transform($1, 4326);

     IF (ST_Y(geomgeog))>0 THEN
        pref:=32600;
     ELSE
        pref:=32700;
     END IF;

     zone:=floor((ST_X(geomgeog)+180)/6)+1;

     RETURN zone+pref;
 END;
 $_$;


--
-- Name: wsg_crossing_summary(); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.wsg_crossing_summary() RETURNS TABLE(watershed_group_code text, crossing_feature_type text, n_crossings_total integer, n_passable_total integer, n_barriers_total integer, n_potential_total integer, n_unknown_total integer, n_barriers_accessible_bt integer, n_potential_accessible_bt integer, n_unknown_accessible_bt integer, n_barriers_accessible_ch_cm_co_pk_sk integer, n_potential_accessible_ch_cm_co_pk_sk integer, n_unknown_accessible_ch_cm_co_pk_sk integer, n_barriers_accessible_st integer, n_potential_accessible_st integer, n_unknown_accessible_st integer, n_barriers_accessible_wct integer, n_potential_accessible_wct integer, n_unknown_accessible_wct integer, n_barriers_habitat_bt integer, n_potential_habitat_bt integer, n_unknown_habitat_bt integer, n_barriers_habitat_ch integer, n_potential_habitat_ch integer, n_unknown_habitat_ch integer, n_barriers_habitat_cm integer, n_potential_habitat_cm integer, n_unknown_habitat_cm integer, n_barriers_habitat_co integer, n_potential_habitat_co integer, n_unknown_habitat_co integer, n_barriers_habitat_pk integer, n_potential_habitat_pk integer, n_unknown_habitat_pk integer, n_barriers_habitat_sk integer, n_potential_habitat_sk integer, n_unknown_habitat_sk integer, n_barriers_habitat_salmon integer, n_potential_habitat_salmon integer, n_unknown_habitat_salmon integer, n_barriers_habitat_st integer, n_potential_habitat_st integer, n_unknown_habitat_st integer, n_barriers_habitat_wct integer, n_potential_habitat_wct integer, n_unknown_habitat_wct integer)
    LANGUAGE sql
    AS $$

select
  watershed_group_code,
  crossing_feature_type,
  count(*) as n_crossings_total,
  count(*) filter (where barrier_status = 'PASSABLE') as n_passable_total, -- just report on passable for totals, we are more interested in barriers
  count(*) filter (where barrier_status = 'BARRIER') as n_barriers_total,
  count(*) filter (where barrier_status = 'POTENTIAL') as n_potential_total,
  count(*) filter (where barrier_status = 'UNKNOWN') as n_unknown_total,

  -- crossings on potentially accessible streams
  count(*) filter (where barrier_status = 'BARRIER' and barriers_bt_dnstr = '') as n_barriers_accessible_bt,
  count(*) filter (where barrier_status = 'POTENTIAL' and barriers_bt_dnstr = '') as n_potential_accessible_bt,
  count(*) filter (where barrier_status = 'UNKNOWN' and barriers_bt_dnstr = '') as n_unknown_accessible_bt,

  count(*) filter (where barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_barriers_accessible_ch_cm_co_pk_sk,
  count(*) filter (where barrier_status = 'POTENTIAL' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_potential_accessible_ch_cm_co_pk_sk,
  count(*) filter (where barrier_status = 'UNKNOWN' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_unknown_accessible_ch_cm_co_pk_sk,

  count(*) filter (where barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_barriers_accessible_st,
  count(*) filter (where barrier_status = 'POTENTIAL' and barriers_st_dnstr = '') as n_potential_accessible_st,
  count(*) filter (where barrier_status = 'UNKNOWN' and barriers_st_dnstr = '') as n_unknown_accessible_st,

  count(*) filter (where barrier_status = 'BARRIER' and barriers_wct_dnstr = '') as n_barriers_accessible_wct,
  count(*) filter (where barrier_status = 'POTENTIAL' and barriers_wct_dnstr = '') as n_potential_accessible_wct,
  count(*) filter (where barrier_status = 'UNKNOWN' and barriers_wct_dnstr = '') as n_unknown_accessible_wct,

  -- crossings with modelled/known habitat upstream
  count(*) filter (where barrier_status = 'BARRIER' and (
    bt_spawning_km > 0 or
    bt_rearing_km > 0)
   ) as n_barriers_habitat_bt,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    bt_spawning_km > 0 or
    bt_rearing_km > 0)
   ) as n_potential_habitat_bt,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    bt_spawning_km > 0 or
    bt_rearing_km > 0)
   ) as n_unknown_habitat_bt,

  count(*) filter (where barrier_status = 'BARRIER' and (
    ch_spawning_km > 0 or
    ch_rearing_km > 0)
   ) as n_barriers_habitat_ch,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    ch_spawning_km > 0 or
    ch_rearing_km > 0)
   ) as n_potential_habitat_ch,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    ch_spawning_km > 0 or
    ch_rearing_km > 0)
   ) as n_unknown_habitat_ch,

  count(*) filter (where barrier_status = 'BARRIER' and cm_spawning_km > 0) as n_barriers_habitat_cm,
  count(*) filter (where barrier_status = 'POTENTIAL' and cm_spawning_km > 0) as n_potential_habitat_cm,
  count(*) filter (where barrier_status = 'UNKNOWN' and cm_spawning_km > 0) as n_unknown_habitat_cm,

  count(*) filter (where barrier_status = 'BARRIER' and (
    co_spawning_km > 0 or
    co_rearing_km > 0)
   ) as n_barriers_habitat_co,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    co_spawning_km > 0 or
    co_rearing_km > 0)
   ) as n_potential_habitat_co,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    co_spawning_km > 0 or
    co_rearing_km > 0)
   ) as n_unknown_habitat_co,

  count(*) filter (where barrier_status = 'BARRIER' and pk_spawning_km > 0) as n_barriers_habitat_pk,
  count(*) filter (where barrier_status = 'POTENTIAL' and pk_spawning_km > 0) as n_potential_habitat_pk,
  count(*) filter (where barrier_status = 'UNKNOWN' and pk_spawning_km > 0) as n_unknown_habitat_pk,

  count(*) filter (where barrier_status = 'BARRIER' and (
    sk_spawning_km > 0 or
    sk_rearing_km > 0)
   ) as n_barriers_habitat_sk,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    sk_spawning_km > 0 or
    sk_rearing_km > 0)
   ) as n_potential_habitat_sk,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    sk_spawning_km > 0 or
    sk_rearing_km > 0)
   ) as n_unknown_habitat_sk,

  count(*) filter (where barrier_status = 'BARRIER' and (
    ch_spawning_km > 0 or 
    ch_rearing_km > 0 or 
    cm_spawning_km > 0 or 
    co_spawning_km > 0 or 
    co_rearing_km > 0 or 
    pk_spawning_km > 0 or 
    sk_spawning_km > 0 or 
    sk_rearing_km > 0)
   ) as n_barriers_habitat_salmon,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    ch_spawning_km > 0 or 
    ch_rearing_km > 0 or 
    cm_spawning_km > 0 or 
    co_spawning_km > 0 or 
    co_rearing_km > 0 or 
    pk_spawning_km > 0 or 
    sk_spawning_km > 0 or 
    sk_rearing_km > 0)
   ) as n_potential_habitat_salmon,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    ch_spawning_km > 0 or 
    ch_rearing_km > 0 or 
    cm_spawning_km > 0 or 
    co_spawning_km > 0 or 
    co_rearing_km > 0 or 
    pk_spawning_km > 0 or 
    sk_spawning_km > 0 or 
    sk_rearing_km > 0)
   ) as n_unknown_habitat_salmon,

  count(*) filter (where barrier_status = 'BARRIER' and (
    st_spawning_km > 0 or
    st_rearing_km > 0)
   ) as n_barriers_habitat_st,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    st_spawning_km > 0 or
    st_rearing_km > 0)
   ) as n_potential_habitat_st,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    st_spawning_km > 0 or
    st_rearing_km > 0)
   ) as n_unknown_habitat_st,

  count(*) filter (where barrier_status = 'BARRIER' and (
    wct_spawning_km > 0 or
    wct_rearing_km > 0)
   ) as n_barriers_habitat_wct,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    wct_spawning_km > 0 or
    wct_rearing_km > 0)
   ) as n_potential_habitat_wct,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    wct_spawning_km > 0 or
    wct_rearing_km > 0)
   ) as n_unknown_habitat_wct

from bcfishpass.crossings_vw
group by watershed_group_code, crossing_feature_type
order by watershed_group_code, crossing_feature_type;

$$;


--
-- Name: wsg_linear_summary(); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.wsg_linear_summary() RETURNS TABLE(watershed_group_code text, length_total numeric, length_potentiallyaccessible_bt numeric, length_potentiallyaccessible_bt_observed numeric, length_potentiallyaccessible_bt_accessible_a numeric, length_potentiallyaccessible_bt_accessible_b numeric, length_obsrvd_spawning_rearing_bt numeric, length_obsrvd_spawning_rearing_bt_accessible_a numeric, length_obsrvd_spawning_rearing_bt_accessible_b numeric, length_spawning_rearing_bt numeric, length_spawning_rearing_bt_accessible_a numeric, length_spawning_rearing_bt_accessible_b numeric, length_potentiallyaccessible_ch_cm_co_pk_sk numeric, length_potentiallyaccessible_ch_cm_co_pk_sk_observed numeric, length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a numeric, length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b numeric, length_obsrvd_spawning_rearing_ch numeric, length_obsrvd_spawning_rearing_ch_accessible_a numeric, length_obsrvd_spawning_rearing_ch_accessible_b numeric, length_spawning_rearing_ch numeric, length_spawning_rearing_ch_accessible_a numeric, length_spawning_rearing_ch_accessible_b numeric, length_obsrvd_spawning_rearing_cm numeric, length_obsrvd_spawning_rearing_cm_accessible_a numeric, length_obsrvd_spawning_rearing_cm_accessible_b numeric, length_spawning_rearing_cm numeric, length_spawning_rearing_cm_accessible_a numeric, length_spawning_rearing_cm_accessible_b numeric, length_obsrvd_spawning_rearing_co numeric, length_obsrvd_spawning_rearing_co_accessible_a numeric, length_obsrvd_spawning_rearing_co_accessible_b numeric, length_spawning_rearing_co numeric, length_spawning_rearing_co_accessible_a numeric, length_spawning_rearing_co_accessible_b numeric, length_obsrvd_spawning_rearing_pk numeric, length_obsrvd_spawning_rearing_pk_accessible_a numeric, length_obsrvd_spawning_rearing_pk_accessible_b numeric, length_spawning_rearing_pk numeric, length_spawning_rearing_pk_accessible_a numeric, length_spawning_rearing_pk_accessible_b numeric, length_obsrvd_spawning_rearing_sk numeric, length_obsrvd_spawning_rearing_sk_accessible_a numeric, length_obsrvd_spawning_rearing_sk_accessible_b numeric, length_spawning_rearing_sk numeric, length_spawning_rearing_sk_accessible_a numeric, length_spawning_rearing_sk_accessible_b numeric, length_potentiallyaccessible_st numeric, length_potentiallyaccessible_st_observed numeric, length_potentiallyaccessible_st_accessible_a numeric, length_potentiallyaccessible_st_accessible_b numeric, length_obsrvd_spawning_rearing_st numeric, length_obsrvd_spawning_rearing_st_accessible_a numeric, length_obsrvd_spawning_rearing_st_accessible_b numeric, length_spawning_rearing_st numeric, length_spawning_rearing_st_accessible_a numeric, length_spawning_rearing_st_accessible_b numeric, length_potentiallyaccessible_wct numeric, length_potentiallyaccessible_wct_observed numeric, length_potentiallyaccessible_wct_accessible_a numeric, length_potentiallyaccessible_wct_accessible_b numeric, length_obsrvd_spawning_rearing_wct numeric, length_obsrvd_spawning_rearing_wct_accessible_a numeric, length_obsrvd_spawning_rearing_wct_accessible_b numeric, length_spawning_rearing_wct numeric, length_spawning_rearing_wct_accessible_a numeric, length_spawning_rearing_wct_accessible_b numeric)
    LANGUAGE sql
    AS $$

with accessible as
(
  select
    s.watershed_group_code,
    sum(st_length(geom)) length_total,    
    
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[]) as length_potentiallyaccessible_bt,
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[] and 'BT' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_bt_observed,
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_bt_accessible_a,
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_bt_accessible_b,

    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]) as length_potentiallyaccessible_ch_cm_co_pk_sk,
    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and obsrvtn_species_codes_upstr && array['CH','CM','CO','PK','SK']) as length_potentiallyaccessible_ch_cm_co_pk_sk_observed,
    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a,
    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b,

    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[]) as length_potentiallyaccessible_st,
    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[] and 'ST' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_st_observed,
    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_st_accessible_a,
    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_st_accessible_b,
    
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[]) as length_potentiallyaccessible_wct,
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[] and 'WCT' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_wct_observed,
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_wct_accessible_a,
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_wct_accessible_b
  from bcfishpass.streams_access_vw sv
  inner join bcfishpass.streams s on sv.segmented_stream_id = s.segmented_stream_id
  group by watershed_group_code
),

spawning_rearing_observed as (
  select
    s.watershed_group_code,
    sum(st_length(geom)) filter (where h.spawning_bt is true or h.rearing_bt is true) as length_obsrvd_spawning_rearing_bt,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_bt_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_bt_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_ch is true or h.rearing_ch is true) as length_obsrvd_spawning_rearing_ch,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_ch_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_ch_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_cm is true) as length_obsrvd_spawning_rearing_cm,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_cm_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_cm_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_co is true or h.rearing_co is true) as length_obsrvd_spawning_rearing_co,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_co_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_co_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_pk is true) as length_obsrvd_spawning_rearing_pk,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_pk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_pk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_sk is true or h.rearing_sk is true) as length_obsrvd_spawning_rearing_sk,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_sk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_sk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_st is true or h.rearing_st is true) as length_obsrvd_spawning_rearing_st,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_st_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_st_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_wct is true or h.rearing_wct is true) as length_obsrvd_spawning_rearing_wct,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_wct_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_wct_accessible_b
  from bcfishpass.streams_access_vw sv
  left outer join bcfishpass.streams_habitat_known_vw h on sv.segmented_stream_id = h.segmented_stream_id
  inner join bcfishpass.streams s on sv.segmented_stream_id = s.segmented_stream_id
  group by watershed_group_code
),

spawning_rearing_modelled as (
  select
    s.watershed_group_code,
    sum(st_length(geom)) filter (where h.spawning_bt is true or h.rearing_bt is true) as length_spawning_rearing_bt,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_bt_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_bt_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_ch is true or h.rearing_ch is true) as length_spawning_rearing_ch,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_ch_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_ch_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_cm is true) as length_spawning_rearing_cm,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_cm_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_cm_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_co is true or h.rearing_co is true) as length_spawning_rearing_co,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_co_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_co_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_pk is true) as length_spawning_rearing_pk,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_pk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_pk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_sk is true or h.rearing_sk is true) as length_spawning_rearing_sk,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_sk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_sk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_st is true or h.rearing_st is true) as length_spawning_rearing_st,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_st_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_st_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_wct is true or h.rearing_wct is true) as length_spawning_rearing_wct,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_wct_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_wct_accessible_b
  from bcfishpass.streams_access_vw sv
  left outer join bcfishpass.streams_habitat_linear_vw h on sv.segmented_stream_id = h.segmented_stream_id
  inner join bcfishpass.streams s on sv.segmented_stream_id = s.segmented_stream_id
  group by watershed_group_code
)

-- round to nearest km
select
  a.watershed_group_code,
  round((coalesce(a.length_total, 0) / 1000)::numeric, 2) as length_total,
  -- bull trout
  round((coalesce(a.length_potentiallyaccessible_bt, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt,
  round((coalesce(a.length_potentiallyaccessible_bt_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt_observed,
  round((coalesce(a.length_potentiallyaccessible_bt_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_bt_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt_accessible_b,
  round((coalesce(o.length_obsrvd_spawning_rearing_bt, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_bt,
  round((coalesce(o.length_obsrvd_spawning_rearing_bt_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_bt_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_bt_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_bt_accessible_b,
  round((coalesce(m.length_spawning_rearing_bt, 0) / 1000)::numeric, 2) as length_spawning_rearing_bt,
  round((coalesce(m.length_spawning_rearing_bt_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_bt_accessible_a,
  round((coalesce(m.length_spawning_rearing_bt_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_bt_accessible_b,

  -- salmon access
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk,
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk_observed,
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b,
  
  --ch/cm/co/pk/sk spawning/rearing reported separately
  round((coalesce(o.length_obsrvd_spawning_rearing_ch, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_ch,
  round((coalesce(o.length_obsrvd_spawning_rearing_ch_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_ch_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_ch_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_ch_accessible_b,
  round((coalesce(m.length_spawning_rearing_ch, 0) / 1000)::numeric, 2) as length_spawning_rearing_ch,
  round((coalesce(m.length_spawning_rearing_ch_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_ch_accessible_a,
  round((coalesce(m.length_spawning_rearing_ch_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_ch_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_cm, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_cm,
  round((coalesce(o.length_obsrvd_spawning_rearing_cm_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_cm_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_cm_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_cm_accessible_b,
  round((coalesce(m.length_spawning_rearing_cm, 0) / 1000)::numeric, 2) as length_spawning_rearing_cm,
  round((coalesce(m.length_spawning_rearing_cm_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_cm_accessible_a,
  round((coalesce(m.length_spawning_rearing_cm_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_cm_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_co, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_co,
  round((coalesce(o.length_obsrvd_spawning_rearing_co_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_co_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_co_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_co_accessible_b,
  round((coalesce(m.length_spawning_rearing_co, 0) / 1000)::numeric, 2) as length_spawning_rearing_co,
  round((coalesce(m.length_spawning_rearing_co_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_co_accessible_a,
  round((coalesce(m.length_spawning_rearing_co_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_co_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_pk, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_pk,
  round((coalesce(o.length_obsrvd_spawning_rearing_pk_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_pk_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_pk_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_pk_accessible_b,
  round((coalesce(m.length_spawning_rearing_pk, 0) / 1000)::numeric, 2) as length_spawning_rearing_pk,
  round((coalesce(m.length_spawning_rearing_pk_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_pk_accessible_a,
  round((coalesce(m.length_spawning_rearing_pk_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_pk_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_sk, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_sk,
  round((coalesce(o.length_obsrvd_spawning_rearing_sk_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_sk_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_sk_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_sk_accessible_b,
  round((coalesce(m.length_spawning_rearing_sk, 0) / 1000)::numeric, 2) as length_spawning_rearing_sk,
  round((coalesce(m.length_spawning_rearing_sk_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_sk_accessible_a,
  round((coalesce(m.length_spawning_rearing_sk_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_sk_accessible_b,

  -- steelhead
  round((coalesce(a.length_potentiallyaccessible_st, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st,
  round((coalesce(a.length_potentiallyaccessible_st_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st_observed,
  round((coalesce(a.length_potentiallyaccessible_st_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_st_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st_accessible_b,
  round((coalesce(o.length_obsrvd_spawning_rearing_st, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_st,
  round((coalesce(o.length_obsrvd_spawning_rearing_st_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_st_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_st_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_st_accessible_b,
  round((coalesce(m.length_spawning_rearing_st, 0) / 1000)::numeric, 2) as length_spawning_rearing_st,
  round((coalesce(m.length_spawning_rearing_st_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_st_accessible_a,
  round((coalesce(m.length_spawning_rearing_st_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_st_accessible_b,

  -- wct
  round((coalesce(a.length_potentiallyaccessible_wct, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct,
  round((coalesce(a.length_potentiallyaccessible_wct_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct_observed,
  round((coalesce(a.length_potentiallyaccessible_wct_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_wct_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct_accessible_b,
  round((coalesce(o.length_obsrvd_spawning_rearing_wct, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_wct,
  round((coalesce(o.length_obsrvd_spawning_rearing_wct_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_wct_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_wct_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_wct_accessible_b,
  round((coalesce(m.length_spawning_rearing_wct, 0) / 1000)::numeric, 2) as length_spawning_rearing_wct,
  round((coalesce(m.length_spawning_rearing_wct_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_wct_accessible_a,
  round((coalesce(m.length_spawning_rearing_wct_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_wct_accessible_b

from accessible a
left outer join spawning_rearing_observed o on a.watershed_group_code = o.watershed_group_code
left outer join spawning_rearing_modelled m  on a.watershed_group_code = m.watershed_group_code
order by a.watershed_group_code;

$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ften_range_poly_carto_vw; Type: MATERIALIZED VIEW; Schema: bcdata; Owner: -
--

CREATE MATERIALIZED VIEW bcdata.ften_range_poly_carto_vw AS
 WITH rings AS (
         SELECT public.st_exteriorring((public.st_dumprings((public.st_dump(ften_range_poly_svw.geom)).geom)).geom) AS geom
           FROM whse_forest_tenure.ften_range_poly_svw
        ), lines AS (
         SELECT (public.st_dump(public.st_union(rings.geom, (0.1)::double precision))).geom AS geom
           FROM rings
        ), flattened AS (
         SELECT (public.st_dump(public.st_polygonize(lines.geom))).geom AS geom
           FROM lines
        ), sorted AS (
         SELECT d.objectid,
            d.forest_file_id,
            d.client_number,
            d.client_name,
            f.geom
           FROM (flattened f
             LEFT JOIN whse_forest_tenure.ften_range_poly_svw d ON (public.st_contains(d.geom, public.st_pointonsurface(f.geom))))
          ORDER BY d.objectid
        )
 SELECT row_number() OVER () AS id,
    array_agg(forest_file_id ORDER BY objectid) AS forest_file_id,
    array_agg(client_number ORDER BY objectid) AS client_number,
    array_agg(client_name ORDER BY objectid) AS client_name,
    (geom)::public.geometry(Polygon,3005) AS geom
   FROM sorted
  GROUP BY geom
  WITH NO DATA;


--
-- Name: log; Type: TABLE; Schema: bcdata; Owner: -
--

CREATE TABLE bcdata.log (
    table_name text NOT NULL,
    latest_download timestamp with time zone
);


--
-- Name: parks; Type: MATERIALIZED VIEW; Schema: bcdata; Owner: -
--

CREATE MATERIALIZED VIEW bcdata.parks AS
 SELECT row_number() OVER () AS id,
    source,
    designation,
    name,
    geom
   FROM ( SELECT 'whse_admin_boundaries.clab_national_parks'::text AS source,
            'NATIONAL PARK'::character varying AS designation,
            clab_national_parks.english_name AS name,
            (public.st_multi(public.st_union(clab_national_parks.geom)))::public.geometry(MultiPolygon,3005) AS geom
           FROM whse_admin_boundaries.clab_national_parks
          GROUP BY clab_national_parks.english_name
        UNION ALL
         SELECT 'whse_tantalis.ta_park_ecores_pa_svw'::text AS source,
            ta_park_ecores_pa_svw.protected_lands_designation AS designation,
            ta_park_ecores_pa_svw.protected_lands_name AS name,
            (public.st_multi(ta_park_ecores_pa_svw.geom))::public.geometry(MultiPolygon,3005) AS geom
           FROM whse_tantalis.ta_park_ecores_pa_svw
        UNION ALL
         SELECT 'whse_tantalis.ta_conservancy_areas_svw'::text AS source,
            'CONSERVANCY'::character varying AS designation,
            ta_conservancy_areas_svw.conservancy_area_name AS name,
            (public.st_multi(ta_conservancy_areas_svw.geom))::public.geometry(MultiPolygon,3005) AS geom
           FROM whse_tantalis.ta_conservancy_areas_svw
        UNION ALL
         SELECT 'whse_basemapping.gba_local_reg_greenspaces_sp'::text AS source,
            ((upper((gba_local_reg_greenspaces_sp.park_type)::text) || ' '::text) || upper((gba_local_reg_greenspaces_sp.park_primary_use)::text)) AS designation,
            gba_local_reg_greenspaces_sp.park_name AS name,
            (public.st_multi(gba_local_reg_greenspaces_sp.geom))::public.geometry(MultiPolygon,3005) AS geom
           FROM whse_basemapping.gba_local_reg_greenspaces_sp) p
  WITH NO DATA;


--
-- Name: private; Type: TABLE; Schema: bcdata; Owner: -
--

CREATE TABLE bcdata.private (
    private_id integer NOT NULL,
    name text,
    geom public.geometry(Polygon,3005)
);


--
-- Name: private_private_id_seq; Type: SEQUENCE; Schema: bcdata; Owner: -
--

CREATE SEQUENCE bcdata.private_private_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: private_private_id_seq; Type: SEQUENCE OWNED BY; Schema: bcdata; Owner: -
--

ALTER SEQUENCE bcdata.private_private_id_seq OWNED BY bcdata.private.private_id;


--
-- Name: veg_consolidated_cut_blocks_decade_vw; Type: VIEW; Schema: bcdata; Owner: -
--

CREATE VIEW bcdata.veg_consolidated_cut_blocks_decade_vw AS
 SELECT vccb_sysid,
    harvest_start_year_calendar AS harvest_year,
    harvest_start_date,
    harvest_end_date,
    data_source,
        CASE
            WHEN (harvest_start_year_calendar < (1950)::numeric) THEN 0
            WHEN ((harvest_start_year_calendar < (1960)::numeric) AND (harvest_start_year_calendar >= (1950)::numeric)) THEN 1
            WHEN ((harvest_start_year_calendar < (1970)::numeric) AND (harvest_start_year_calendar >= (1960)::numeric)) THEN 2
            WHEN ((harvest_start_year_calendar < (1980)::numeric) AND (harvest_start_year_calendar >= (1970)::numeric)) THEN 3
            WHEN ((harvest_start_year_calendar < (1990)::numeric) AND (harvest_start_year_calendar >= (1980)::numeric)) THEN 4
            WHEN ((harvest_start_year_calendar < (2000)::numeric) AND (harvest_start_year_calendar >= (1990)::numeric)) THEN 5
            WHEN ((harvest_start_year_calendar < (2010)::numeric) AND (harvest_start_year_calendar >= (2000)::numeric)) THEN 6
            WHEN ((harvest_start_year_calendar < (2020)::numeric) AND (harvest_start_year_calendar >= (2010)::numeric)) THEN 7
            WHEN (harvest_start_year_calendar >= (2020)::numeric) THEN 8
            ELSE NULL::integer
        END AS harvest_decade_idx,
    geom
   FROM whse_forest_vegetation.veg_consolidated_cut_blocks_sp;


--
-- Name: fiss_fish_obsrvtn_events; Type: TABLE; Schema: bcfishobs; Owner: -
--

CREATE TABLE bcfishobs.fiss_fish_obsrvtn_events (
    fish_obsrvtn_event_id bigint GENERATED ALWAYS AS (((((((blue_line_key)::bigint + 1) - 354087611) * 10000000))::double precision + round(((downstream_route_measure)::bigint)::double precision))) STORED NOT NULL,
    linear_feature_id integer,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    blue_line_key integer,
    watershed_group_code character varying(4),
    downstream_route_measure double precision,
    match_types text[],
    obs_ids integer[],
    species_codes text[],
    species_ids integer[],
    maximal_species integer[],
    distances_to_stream double precision[],
    geom public.geometry(PointZM,3005)
);


--
-- Name: TABLE fiss_fish_obsrvtn_events; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON TABLE bcfishobs.fiss_fish_obsrvtn_events IS 'Unique locations of BC Fish Observations snapped to FWA streams';


--
-- Name: COLUMN fiss_fish_obsrvtn_events.fish_obsrvtn_event_id; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events.fish_obsrvtn_event_id IS 'Unique identifier, linked to blue_line_key and measure';


--
-- Name: COLUMN fiss_fish_obsrvtn_events.match_types; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events.match_types IS 'Notes on how the observation(s) were matched to the stream';


--
-- Name: COLUMN fiss_fish_obsrvtn_events.obs_ids; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events.obs_ids IS 'fish_observation_point_id for observations associated with the location';


--
-- Name: COLUMN fiss_fish_obsrvtn_events.species_codes; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events.species_codes IS 'BC fish species codes, see https://raw.githubusercontent.com/smnorris/fishbc/master/data-raw/whse_fish_species_cd/whse_fish_species_cd.csv';


--
-- Name: COLUMN fiss_fish_obsrvtn_events.species_ids; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events.species_ids IS 'Species IDs, see https://raw.githubusercontent.com/smnorris/fishbc/master/data-raw/whse_fish_species_cd/whse_fish_species_cd.csv';


--
-- Name: COLUMN fiss_fish_obsrvtn_events.maximal_species; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events.maximal_species IS 'Indicates if the observation is the most upstream for the given species (no additional observations upstream)';


--
-- Name: COLUMN fiss_fish_obsrvtn_events.distances_to_stream; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events.distances_to_stream IS 'Distances (m) from source observations to output point';


--
-- Name: COLUMN fiss_fish_obsrvtn_events.geom; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events.geom IS 'Geometry of observation(s) on the FWA stream (measure rounded to the nearest metre)';


--
-- Name: fiss_fish_obsrvtn_events_vw; Type: VIEW; Schema: bcfishobs; Owner: -
--

CREATE VIEW bcfishobs.fiss_fish_obsrvtn_events_vw AS
 WITH all_obs AS (
         SELECT unnest(e.obs_ids) AS fish_observation_point_id,
            e.fish_obsrvtn_event_id,
            s.linear_feature_id,
            s.wscode_ltree,
            s.localcode_ltree,
            e.blue_line_key,
            s.waterbody_key,
            e.downstream_route_measure,
            unnest(e.distances_to_stream) AS distance_to_stream,
            unnest(e.match_types) AS match_type,
            s.watershed_group_code,
            e.geom
           FROM (bcfishobs.fiss_fish_obsrvtn_events e
             JOIN whse_basemapping.fwa_stream_networks_sp s ON ((e.linear_feature_id = s.linear_feature_id)))
        )
 SELECT a.fish_observation_point_id,
    a.fish_obsrvtn_event_id,
    a.linear_feature_id,
    a.wscode_ltree,
    a.localcode_ltree,
    a.blue_line_key,
    a.waterbody_key,
    a.downstream_route_measure,
    a.distance_to_stream,
    a.match_type,
    a.watershed_group_code,
    sp.species_id,
    b.species_code,
    b.agency_id,
    b.observation_date,
    b.agency_name,
    b.source,
    b.source_ref,
    b.activity_code,
    b.activity,
    b.life_stage_code,
    b.life_stage,
    b.acat_report_url,
    ((public.st_dump(a.geom)).geom)::public.geometry(PointZM,3005) AS geom
   FROM ((all_obs a
     JOIN whse_fish.fiss_fish_obsrvtn_pnt_sp b ON (((a.fish_observation_point_id)::numeric = b.fish_observation_point_id)))
     JOIN whse_fish.species_cd sp ON (((b.species_code)::text = sp.code)));


--
-- Name: VIEW fiss_fish_obsrvtn_events_vw; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON VIEW bcfishobs.fiss_fish_obsrvtn_events_vw IS 'BC Fish Observations snapped to FWA streams';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.fish_observation_point_id; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.fish_observation_point_id IS 'Source observation primary key';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.fish_obsrvtn_event_id; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.fish_obsrvtn_event_id IS 'Links to fiss_fish_obsrvtn_events, a unique location on the stream network based on blue_line_key and measure';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.distance_to_stream; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.distance_to_stream IS 'Distance (m) from source observation to output point';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.match_type; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.match_type IS 'Notes on how the observation was matched to the stream';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.species_id; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.species_id IS 'Species ID, see https://raw.githubusercontent.com/smnorris/fishbc/master/data-raw/whse_fish_species_cd/whse_fish_species_cd.csv';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.species_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.species_code IS 'BC fish species code, see https://raw.githubusercontent.com/smnorris/fishbc/master/data-raw/whse_fish_species_cd/whse_fish_species_cd.csv';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.observation_date; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.observation_date IS 'The date on which the observation occurred.';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.agency_name; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.agency_name IS 'The name of the agency that made the observation.';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.source; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.source IS 'The abbreviation, and if appropriate, the primary key, of the dataset(s) from which the data was obtained. For example: FDIS Database: fshclctn_id 66589';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.source_ref; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.source_ref IS 'The concatenation of all biographical references for the source data.  This may include citations to reports that published the observations, or the name of a project under which the observations were made. Some example values for SOURCE REF are: A RECONNAISSANCE SURVEY OF CULTUS LAKE, and Bonaparte Watershed Fish and Fish Habitat Inventory - 2000';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.activity_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.activity_code IS 'ACTIVITY CODE contains the fish activity code from the source dataset, such as I for Incubating, or SPE for Spawning In Estuary.';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.activity; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.activity IS 'ACTIVITY is a full textual description of the activity the fish was engaged in when it was observed, such as SPAWNING.';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.life_stage_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.life_stage_code IS 'LIFE STAGE CODE is a short character code identiying the life stage of the fish species for this oberservation.  Each source dataset of observations uses its own set of LIFE STAGE CODES.  For example, in the FDIS dataset, U means Undetermined, NS means Not Specified, M means Mature, IM means Immature, and MT means Maturing.  Descriptions for each LIFE STAGE CODE are given in the LIFE STAGE attribute.';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.life_stage; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.life_stage IS 'LIFE STAGE is the full textual description corresponding to the LIFE STAGE CODE';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.acat_report_url; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.acat_report_url IS 'ACAT REPORT URL is a URL to the ACAT REPORT which provides additional information about the FISS FISH OBSRVTN PNT SP.';


--
-- Name: COLUMN fiss_fish_obsrvtn_events_vw.geom; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.fiss_fish_obsrvtn_events_vw.geom IS 'Geometry of observation on the FWA stream (measure rounded to the nearest metre)';


--
-- Name: fiss_fish_obsrvtn_unmatched; Type: TABLE; Schema: bcfishobs; Owner: -
--

CREATE TABLE bcfishobs.fiss_fish_obsrvtn_unmatched (
    fish_obsrvtn_pnt_distinct_id integer NOT NULL,
    obs_ids integer[],
    species_ids integer[],
    distance_to_stream double precision,
    geom public.geometry(Point,3005)
);


--
-- Name: observations; Type: TABLE; Schema: bcfishobs; Owner: -
--

CREATE TABLE bcfishobs.observations (
    observation_key text NOT NULL,
    fish_observation_point_id numeric,
    wbody_id numeric,
    species_code character varying(6),
    agency_id numeric,
    point_type_code character varying(20),
    observation_date date,
    agency_name character varying(60),
    source character varying(1000),
    source_ref character varying(4000),
    utm_zone integer,
    utm_easting integer,
    utm_northing integer,
    activity_code character varying(100),
    activity character varying(300),
    life_stage_code character varying(100),
    life_stage character varying(300),
    species_name character varying(60),
    waterbody_identifier character varying(9),
    waterbody_type character varying(20),
    gazetted_name character varying(30),
    new_watershed_code character varying(56),
    trimmed_watershed_code character varying(56),
    acat_report_url character varying(254),
    feature_code character varying(10),
    linear_feature_id bigint,
    wscode public.ltree,
    localcode public.ltree,
    blue_line_key integer,
    watershed_group_code character varying(4),
    downstream_route_measure double precision,
    match_type text,
    distance_to_stream double precision,
    geom public.geometry(PointZ,3005)
);


--
-- Name: TABLE observations; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON TABLE bcfishobs.observations IS 'BC Fish Observations snapped to FWA streams';


--
-- Name: COLUMN observations.observation_key; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.observation_key IS 'Stable unique id, a hash of columns [source, species_code, observation_date, utm_zone, utm_easting, utm_northing, life_stage_code, activity_code]';


--
-- Name: COLUMN observations.fish_observation_point_id; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.fish_observation_point_id IS 'Source observation primary key (unstable)';


--
-- Name: COLUMN observations.wbody_id; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.wbody_id IS 'WBODY ID is a foreign key to WDIC_WATERBODIES.';


--
-- Name: COLUMN observations.species_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.species_code IS 'BC fish species code, see https://raw.githubusercontent.com/smnorris/fishbc/master/data-raw/whse_fish_species_cd/whse_fish_species_cd.csv';


--
-- Name: COLUMN observations.agency_id; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.agency_id IS 'AGENCY ID is a foreign key to AGENCIES.';


--
-- Name: COLUMN observations.point_type_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.point_type_code IS 'POINT TYPE CODE indicates if the row represents a direct Observation or a Summary of direct observations.';


--
-- Name: COLUMN observations.observation_date; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.observation_date IS 'The date on which the observation occurred.';


--
-- Name: COLUMN observations.agency_name; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.agency_name IS 'The name of the agency that made the observation.';


--
-- Name: COLUMN observations.source; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.source IS 'The abbreviation, and if appropriate, the primary key, of the dataset(s) from which the data was obtained. For example: FDIS Database: fshclctn_id 66589';


--
-- Name: COLUMN observations.source_ref; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.source_ref IS 'The concatenation of all biographical references for the source data.  This may include citations to reports that published the observations, or the name of a project under which the observations were made. Some example values for SOURCE REF are: A RECONNAISSANCE SURVEY OF CULTUS LAKE, and Bonaparte Watershed Fish and Fish Habitat Inventory - 2000';


--
-- Name: COLUMN observations.utm_zone; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.utm_zone IS 'UTM ZONE is the 2 digit numeric code identifying the UTM Zone in which the UTM EASTING and UTM NORTHING lie.';


--
-- Name: COLUMN observations.utm_easting; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.utm_easting IS 'UTM EASTING is the UTM Easting value within the specified UTM ZONE for this observation point.';


--
-- Name: COLUMN observations.utm_northing; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.utm_northing IS 'UTM NORTHING is the UTM Northing value within the specified UTM ZONE for this observation point.';


--
-- Name: COLUMN observations.activity_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.activity_code IS 'ACTIVITY CODE contains the fish activity code from the source dataset, such as I for Incubating, or SPE for Spawning In Estuary.';


--
-- Name: COLUMN observations.activity; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.activity IS 'ACTIVITY is a full textual description of the activity the fish was engaged in when it was observed, such as SPAWNING.';


--
-- Name: COLUMN observations.life_stage_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.life_stage_code IS 'LIFE STAGE CODE is a short character code identiying the life stage of the fish species for this oberservation.  Each source dataset of observations uses its own set of LIFE STAGE CODES.  For example, in the FDIS dataset, U means Undetermined, NS means Not Specified, M means Mature, IM means Immature, and MT means Maturing.  Descriptions for each LIFE STAGE CODE are given in the LIFE STAGE attribute.';


--
-- Name: COLUMN observations.life_stage; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.life_stage IS 'LIFE STAGE is the full textual description corresponding to the LIFE STAGE CODE';


--
-- Name: COLUMN observations.species_name; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.species_name IS 'SPECIES NAME is the common name of the fish SPECIES that was observed.';


--
-- Name: COLUMN observations.waterbody_identifier; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.waterbody_identifier IS 'WATERBODY IDENTIFIER is a unique code identifying the waterbody in which the observation was made. It is a 5-digit seqnce number followed by a 4-character watershed group code.';


--
-- Name: COLUMN observations.waterbody_type; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.waterbody_type IS 'WATERBODY TYPE is a the type of waterbody in which the observation was made. For example, Stream or Lake.';


--
-- Name: COLUMN observations.gazetted_name; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.gazetted_name IS 'GAZETTED NAME is the gazetted name of the waterbody in which the observation was made.';


--
-- Name: COLUMN observations.new_watershed_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.new_watershed_code IS 'NEW WATERSHED CODE is a watershed code, formatted with dashes, as assigned in the Watershed Atlas. For example: 900-569800-08600-00000-0000-0000-000-000-000-000-000-000.';


--
-- Name: COLUMN observations.trimmed_watershed_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.trimmed_watershed_code IS 'TRIMMED WATERSHED CODE is the NEW WATERSHED CODE, but with trailing zeros removed. For example, if the NEW WATERSHED CODE is 100-005200-43400-50000-0000-0000-000-000-000-000-000-000, then the TRIMMED WATERSHED CODE will be 100-005200-43400-50000.';


--
-- Name: COLUMN observations.acat_report_url; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.acat_report_url IS 'ACAT REPORT URL is a URL to the ACAT REPORT which provides additional information about the FISS FISH OBSRVTN PNT SP.';


--
-- Name: COLUMN observations.feature_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.feature_code IS 'FEATURE CODE contains a value based on the Canadian Council of Surveys and Mappings (CCSM) system for classification of geographic features.';


--
-- Name: COLUMN observations.linear_feature_id; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.linear_feature_id IS 'See FWA documentation';


--
-- Name: COLUMN observations.wscode; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.wscode IS 'Truncated FWA fwa_watershed_code';


--
-- Name: COLUMN observations.localcode; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.localcode IS 'Truncated FWA local_watershed_code';


--
-- Name: COLUMN observations.blue_line_key; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.blue_line_key IS 'See FWA documentation';


--
-- Name: COLUMN observations.watershed_group_code; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.watershed_group_code IS 'See FWA documentation';


--
-- Name: COLUMN observations.downstream_route_measure; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.downstream_route_measure IS 'See FWA documentation';


--
-- Name: COLUMN observations.match_type; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.match_type IS 'Description of how the observation was matched to the stream';


--
-- Name: COLUMN observations.distance_to_stream; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.distance_to_stream IS 'Distance (m) from source observation to output point';


--
-- Name: COLUMN observations.geom; Type: COMMENT; Schema: bcfishobs; Owner: -
--

COMMENT ON COLUMN bcfishobs.observations.geom IS 'Geometry of observation as snapped to the FWA stream network';


--
-- Name: summary; Type: TABLE; Schema: bcfishobs; Owner: -
--

CREATE TABLE bcfishobs.summary (
    match_type text,
    n_distinct_events integer,
    n_observations integer
);


--
-- Name: log; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log (
    model_run_id integer NOT NULL,
    model_type text NOT NULL,
    date_completed timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    model_version text NOT NULL,
    CONSTRAINT log_model_type_check CHECK ((model_type = ANY (ARRAY['LINEAR'::text, 'LATERAL'::text])))
);


--
-- Name: log_aw_linear_summary; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_aw_linear_summary (
    model_run_id integer,
    assessment_watershed_id integer,
    length_total numeric,
    length_naturallyaccessible_obsrvd_bt numeric,
    length_naturallyaccessible_obsrvd_bt_access_a numeric,
    length_naturallyaccessible_obsrvd_bt_access_b numeric,
    length_naturallyaccessible_model_bt numeric,
    length_naturallyaccessible_model_bt_access_a numeric,
    length_naturallyaccessible_model_bt_access_b numeric,
    length_naturallyaccessible_obsrvd_ch numeric,
    length_naturallyaccessible_obsrvd_ch_access_a numeric,
    length_naturallyaccessible_obsrvd_ch_access_b numeric,
    length_naturallyaccessible_model_ch numeric,
    length_naturallyaccessible_model_ch_access_a numeric,
    length_naturallyaccessible_model_ch_access_b numeric,
    length_naturallyaccessible_obsrvd_cm numeric,
    length_naturallyaccessible_obsrvd_cm_access_a numeric,
    length_naturallyaccessible_obsrvd_cm_access_b numeric,
    length_naturallyaccessible_model_cm numeric,
    length_naturallyaccessible_model_cm_access_a numeric,
    length_naturallyaccessible_model_cm_access_b numeric,
    length_naturallyaccessible_obsrvd_co numeric,
    length_naturallyaccessible_obsrvd_co_access_a numeric,
    length_naturallyaccessible_obsrvd_co_access_b numeric,
    length_naturallyaccessible_model_co numeric,
    length_naturallyaccessible_model_co_access_a numeric,
    length_naturallyaccessible_model_co_access_b numeric,
    length_naturallyaccessible_obsrvd_pk numeric,
    length_naturallyaccessible_obsrvd_pk_access_a numeric,
    length_naturallyaccessible_obsrvd_pk_access_b numeric,
    length_naturallyaccessible_model_pk numeric,
    length_naturallyaccessible_model_pk_access_a numeric,
    length_naturallyaccessible_model_pk_access_b numeric,
    length_naturallyaccessible_obsrvd_sk numeric,
    length_naturallyaccessible_obsrvd_sk_access_a numeric,
    length_naturallyaccessible_obsrvd_sk_access_b numeric,
    length_naturallyaccessible_model_sk numeric,
    length_naturallyaccessible_model_sk_access_a numeric,
    length_naturallyaccessible_model_sk_access_b numeric,
    length_naturallyaccessible_obsrvd_salmon numeric,
    length_naturallyaccessible_obsrvd_salmon_access_a numeric,
    length_naturallyaccessible_obsrvd_salmon_access_b numeric,
    length_naturallyaccessible_model_salmon numeric,
    length_naturallyaccessible_model_salmon_access_a numeric,
    length_naturallyaccessible_model_salmon_access_b numeric,
    length_naturallyaccessible_obsrvd_st numeric,
    length_naturallyaccessible_obsrvd_st_access_a numeric,
    length_naturallyaccessible_obsrvd_st_access_b numeric,
    length_naturallyaccessible_model_st numeric,
    length_naturallyaccessible_model_st_access_a numeric,
    length_naturallyaccessible_model_st_access_b numeric,
    length_naturallyaccessible_obsrvd_wct numeric,
    length_naturallyaccessible_obsrvd_wct_access_a numeric,
    length_naturallyaccessible_obsrvd_wct_access_b numeric,
    length_naturallyaccessible_model_wct numeric,
    length_naturallyaccessible_model_wct_access_a numeric,
    length_naturallyaccessible_model_wct_access_b numeric,
    length_spawningrearing_obsrvd_bt numeric,
    length_spawningrearing_obsrvd_bt_access_a numeric,
    length_spawningrearing_obsrvd_bt_access_b numeric,
    length_spawningrearing_model_bt numeric,
    length_spawningrearing_model_bt_access_a numeric,
    length_spawningrearing_model_bt_access_b numeric,
    length_spawningrearing_obsrvd_ch numeric,
    length_spawningrearing_obsrvd_ch_access_a numeric,
    length_spawningrearing_obsrvd_ch_access_b numeric,
    length_spawningrearing_model_ch numeric,
    length_spawningrearing_model_ch_access_a numeric,
    length_spawningrearing_model_ch_access_b numeric,
    length_spawningrearing_obsrvd_cm numeric,
    length_spawningrearing_obsrvd_cm_access_a numeric,
    length_spawningrearing_obsrvd_cm_access_b numeric,
    length_spawningrearing_model_cm numeric,
    length_spawningrearing_model_cm_access_a numeric,
    length_spawningrearing_model_cm_access_b numeric,
    length_spawningrearing_obsrvd_co numeric,
    length_spawningrearing_obsrvd_co_access_a numeric,
    length_spawningrearing_obsrvd_co_access_b numeric,
    length_spawningrearing_model_co numeric,
    length_spawningrearing_model_co_access_a numeric,
    length_spawningrearing_model_co_access_b numeric,
    length_spawningrearing_obsrvd_pk numeric,
    length_spawningrearing_obsrvd_pk_access_a numeric,
    length_spawningrearing_obsrvd_pk_access_b numeric,
    length_spawningrearing_model_pk numeric,
    length_spawningrearing_model_pk_access_a numeric,
    length_spawningrearing_model_pk_access_b numeric,
    length_spawningrearing_obsrvd_sk numeric,
    length_spawningrearing_obsrvd_sk_access_a numeric,
    length_spawningrearing_obsrvd_sk_access_b numeric,
    length_spawningrearing_model_sk numeric,
    length_spawningrearing_model_sk_access_a numeric,
    length_spawningrearing_model_sk_access_b numeric,
    length_spawningrearing_obsrvd_st numeric,
    length_spawningrearing_obsrvd_st_access_a numeric,
    length_spawningrearing_obsrvd_st_access_b numeric,
    length_spawningrearing_model_st numeric,
    length_spawningrearing_model_st_access_a numeric,
    length_spawningrearing_model_st_access_b numeric,
    length_spawningrearing_obsrvd_wct numeric,
    length_spawningrearing_obsrvd_wct_access_a numeric,
    length_spawningrearing_obsrvd_wct_access_b numeric,
    length_spawningrearing_model_wct numeric,
    length_spawningrearing_model_wct_access_a numeric,
    length_spawningrearing_model_wct_access_b numeric,
    length_spawningrearing_obsrvd_salmon numeric,
    length_spawningrearing_obsrvd_salmon_access_a numeric,
    length_spawningrearing_obsrvd_salmon_access_b numeric,
    length_spawningrearing_model_salmon numeric,
    length_spawningrearing_model_salmon_access_a numeric,
    length_spawningrearing_model_salmon_access_b numeric,
    length_spawningrearing_obsrvd_salmon_st numeric,
    length_spawningrearing_obsrvd_salmon_st_access_a numeric,
    length_spawningrearing_obsrvd_salmon_st_access_b numeric,
    length_spawningrearing_model_salmon_st numeric,
    length_spawningrearing_model_salmon_st_access_a numeric,
    length_spawningrearing_model_salmon_st_access_b numeric
);


--
-- Name: aw_linear_summary_current; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.aw_linear_summary_current AS
 SELECT DISTINCT ON (s.assessment_watershed_id) s.assessment_watershed_id,
    s.length_total,
    s.length_naturallyaccessible_obsrvd_bt,
    s.length_naturallyaccessible_obsrvd_bt_access_a,
    s.length_naturallyaccessible_obsrvd_bt_access_b,
    s.length_naturallyaccessible_model_bt,
    s.length_naturallyaccessible_model_bt_access_a,
    s.length_naturallyaccessible_model_bt_access_b,
    s.length_naturallyaccessible_obsrvd_ch,
    s.length_naturallyaccessible_obsrvd_ch_access_a,
    s.length_naturallyaccessible_obsrvd_ch_access_b,
    s.length_naturallyaccessible_model_ch,
    s.length_naturallyaccessible_model_ch_access_a,
    s.length_naturallyaccessible_model_ch_access_b,
    s.length_naturallyaccessible_obsrvd_cm,
    s.length_naturallyaccessible_obsrvd_cm_access_a,
    s.length_naturallyaccessible_obsrvd_cm_access_b,
    s.length_naturallyaccessible_model_cm,
    s.length_naturallyaccessible_model_cm_access_a,
    s.length_naturallyaccessible_model_cm_access_b,
    s.length_naturallyaccessible_obsrvd_co,
    s.length_naturallyaccessible_obsrvd_co_access_a,
    s.length_naturallyaccessible_obsrvd_co_access_b,
    s.length_naturallyaccessible_model_co,
    s.length_naturallyaccessible_model_co_access_a,
    s.length_naturallyaccessible_model_co_access_b,
    s.length_naturallyaccessible_obsrvd_pk,
    s.length_naturallyaccessible_obsrvd_pk_access_a,
    s.length_naturallyaccessible_obsrvd_pk_access_b,
    s.length_naturallyaccessible_model_pk,
    s.length_naturallyaccessible_model_pk_access_a,
    s.length_naturallyaccessible_model_pk_access_b,
    s.length_naturallyaccessible_obsrvd_sk,
    s.length_naturallyaccessible_obsrvd_sk_access_a,
    s.length_naturallyaccessible_obsrvd_sk_access_b,
    s.length_naturallyaccessible_model_sk,
    s.length_naturallyaccessible_model_sk_access_a,
    s.length_naturallyaccessible_model_sk_access_b,
    s.length_naturallyaccessible_obsrvd_salmon,
    s.length_naturallyaccessible_obsrvd_salmon_access_a,
    s.length_naturallyaccessible_obsrvd_salmon_access_b,
    s.length_naturallyaccessible_model_salmon,
    s.length_naturallyaccessible_model_salmon_access_a,
    s.length_naturallyaccessible_model_salmon_access_b,
    s.length_naturallyaccessible_obsrvd_st,
    s.length_naturallyaccessible_obsrvd_st_access_a,
    s.length_naturallyaccessible_obsrvd_st_access_b,
    s.length_naturallyaccessible_model_st,
    s.length_naturallyaccessible_model_st_access_a,
    s.length_naturallyaccessible_model_st_access_b,
    s.length_naturallyaccessible_obsrvd_wct,
    s.length_naturallyaccessible_obsrvd_wct_access_a,
    s.length_naturallyaccessible_obsrvd_wct_access_b,
    s.length_naturallyaccessible_model_wct,
    s.length_naturallyaccessible_model_wct_access_a,
    s.length_naturallyaccessible_model_wct_access_b,
    s.length_spawningrearing_obsrvd_bt,
    s.length_spawningrearing_obsrvd_bt_access_a,
    s.length_spawningrearing_obsrvd_bt_access_b,
    s.length_spawningrearing_model_bt,
    s.length_spawningrearing_model_bt_access_a,
    s.length_spawningrearing_model_bt_access_b,
    s.length_spawningrearing_obsrvd_ch,
    s.length_spawningrearing_obsrvd_ch_access_a,
    s.length_spawningrearing_obsrvd_ch_access_b,
    s.length_spawningrearing_model_ch,
    s.length_spawningrearing_model_ch_access_a,
    s.length_spawningrearing_model_ch_access_b,
    s.length_spawningrearing_obsrvd_cm,
    s.length_spawningrearing_obsrvd_cm_access_a,
    s.length_spawningrearing_obsrvd_cm_access_b,
    s.length_spawningrearing_model_cm,
    s.length_spawningrearing_model_cm_access_a,
    s.length_spawningrearing_model_cm_access_b,
    s.length_spawningrearing_obsrvd_co,
    s.length_spawningrearing_obsrvd_co_access_a,
    s.length_spawningrearing_obsrvd_co_access_b,
    s.length_spawningrearing_model_co,
    s.length_spawningrearing_model_co_access_a,
    s.length_spawningrearing_model_co_access_b,
    s.length_spawningrearing_obsrvd_pk,
    s.length_spawningrearing_obsrvd_pk_access_a,
    s.length_spawningrearing_obsrvd_pk_access_b,
    s.length_spawningrearing_model_pk,
    s.length_spawningrearing_model_pk_access_a,
    s.length_spawningrearing_model_pk_access_b,
    s.length_spawningrearing_obsrvd_sk,
    s.length_spawningrearing_obsrvd_sk_access_a,
    s.length_spawningrearing_obsrvd_sk_access_b,
    s.length_spawningrearing_model_sk,
    s.length_spawningrearing_model_sk_access_a,
    s.length_spawningrearing_model_sk_access_b,
    s.length_spawningrearing_obsrvd_st,
    s.length_spawningrearing_obsrvd_st_access_a,
    s.length_spawningrearing_obsrvd_st_access_b,
    s.length_spawningrearing_model_st,
    s.length_spawningrearing_model_st_access_a,
    s.length_spawningrearing_model_st_access_b,
    s.length_spawningrearing_obsrvd_wct,
    s.length_spawningrearing_obsrvd_wct_access_a,
    s.length_spawningrearing_obsrvd_wct_access_b,
    s.length_spawningrearing_model_wct,
    s.length_spawningrearing_model_wct_access_a,
    s.length_spawningrearing_model_wct_access_b,
    s.length_spawningrearing_obsrvd_salmon,
    s.length_spawningrearing_obsrvd_salmon_access_a,
    s.length_spawningrearing_obsrvd_salmon_access_b,
    s.length_spawningrearing_model_salmon,
    s.length_spawningrearing_model_salmon_access_a,
    s.length_spawningrearing_model_salmon_access_b,
    s.length_spawningrearing_obsrvd_salmon_st,
    s.length_spawningrearing_obsrvd_salmon_st_access_a,
    s.length_spawningrearing_obsrvd_salmon_st_access_b,
    s.length_spawningrearing_model_salmon_st,
    s.length_spawningrearing_model_salmon_st_access_a,
    s.length_spawningrearing_model_salmon_st_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_bt_access_b + s.length_naturallyaccessible_model_bt_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_bt + s.length_naturallyaccessible_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_bt_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_ch_access_b + s.length_naturallyaccessible_model_ch_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_ch + s.length_naturallyaccessible_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_ch_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_cm_access_b + s.length_naturallyaccessible_model_cm_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_cm + s.length_naturallyaccessible_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_cm_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_co_access_b + s.length_naturallyaccessible_model_co_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_co + s.length_naturallyaccessible_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_co_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_pk_access_b + s.length_naturallyaccessible_model_pk_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_pk + s.length_naturallyaccessible_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_pk_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_sk_access_b + s.length_naturallyaccessible_model_sk_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_sk + s.length_naturallyaccessible_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_sk_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_salmon_access_b + s.length_naturallyaccessible_model_salmon_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_salmon + s.length_naturallyaccessible_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_salmon_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_st_access_b + s.length_naturallyaccessible_model_st_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_st + s.length_naturallyaccessible_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_st_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_wct_access_b + s.length_naturallyaccessible_model_wct_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_wct + s.length_naturallyaccessible_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_wct_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_bt_access_b + s.length_spawningrearing_model_bt_access_b) / NULLIF((s.length_spawningrearing_obsrvd_bt + s.length_spawningrearing_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_bt_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_ch_access_b + s.length_spawningrearing_model_ch_access_b) / NULLIF((s.length_spawningrearing_obsrvd_ch + s.length_spawningrearing_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_ch_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_cm_access_b + s.length_spawningrearing_model_cm_access_b) / NULLIF((s.length_spawningrearing_obsrvd_cm + s.length_spawningrearing_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_cm_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_co_access_b + s.length_spawningrearing_model_co_access_b) / NULLIF((s.length_spawningrearing_obsrvd_co + s.length_spawningrearing_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_co_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_pk_access_b + s.length_spawningrearing_model_pk_access_b) / NULLIF((s.length_spawningrearing_obsrvd_pk + s.length_spawningrearing_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_pk_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_sk_access_b + s.length_spawningrearing_model_sk_access_b) / NULLIF((s.length_spawningrearing_obsrvd_sk + s.length_spawningrearing_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_sk_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_st_access_b + s.length_spawningrearing_model_st_access_b) / NULLIF((s.length_spawningrearing_obsrvd_st + s.length_spawningrearing_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_st_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_wct_access_b + s.length_spawningrearing_model_wct_access_b) / NULLIF((s.length_spawningrearing_obsrvd_wct + s.length_spawningrearing_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_wct_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_salmon_access_b + s.length_spawningrearing_model_salmon_access_b) / NULLIF((s.length_spawningrearing_obsrvd_salmon + s.length_spawningrearing_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_salmon_st_access_b + s.length_spawningrearing_model_salmon_st_access_b) / NULLIF((s.length_spawningrearing_obsrvd_salmon_st + s.length_spawningrearing_model_salmon_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_st_access_b
   FROM ((bcfishpass.log_aw_linear_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
     JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON ((s.assessment_watershed_id = aw.watershed_feature_id)))
  ORDER BY s.assessment_watershed_id, l.date_completed DESC;


--
-- Name: aw_linear_summary_previous; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.aw_linear_summary_previous AS
 SELECT DISTINCT ON (s.assessment_watershed_id) s.assessment_watershed_id,
    s.length_total,
    s.length_naturallyaccessible_obsrvd_bt,
    s.length_naturallyaccessible_obsrvd_bt_access_a,
    s.length_naturallyaccessible_obsrvd_bt_access_b,
    s.length_naturallyaccessible_model_bt,
    s.length_naturallyaccessible_model_bt_access_a,
    s.length_naturallyaccessible_model_bt_access_b,
    s.length_naturallyaccessible_obsrvd_ch,
    s.length_naturallyaccessible_obsrvd_ch_access_a,
    s.length_naturallyaccessible_obsrvd_ch_access_b,
    s.length_naturallyaccessible_model_ch,
    s.length_naturallyaccessible_model_ch_access_a,
    s.length_naturallyaccessible_model_ch_access_b,
    s.length_naturallyaccessible_obsrvd_cm,
    s.length_naturallyaccessible_obsrvd_cm_access_a,
    s.length_naturallyaccessible_obsrvd_cm_access_b,
    s.length_naturallyaccessible_model_cm,
    s.length_naturallyaccessible_model_cm_access_a,
    s.length_naturallyaccessible_model_cm_access_b,
    s.length_naturallyaccessible_obsrvd_co,
    s.length_naturallyaccessible_obsrvd_co_access_a,
    s.length_naturallyaccessible_obsrvd_co_access_b,
    s.length_naturallyaccessible_model_co,
    s.length_naturallyaccessible_model_co_access_a,
    s.length_naturallyaccessible_model_co_access_b,
    s.length_naturallyaccessible_obsrvd_pk,
    s.length_naturallyaccessible_obsrvd_pk_access_a,
    s.length_naturallyaccessible_obsrvd_pk_access_b,
    s.length_naturallyaccessible_model_pk,
    s.length_naturallyaccessible_model_pk_access_a,
    s.length_naturallyaccessible_model_pk_access_b,
    s.length_naturallyaccessible_obsrvd_sk,
    s.length_naturallyaccessible_obsrvd_sk_access_a,
    s.length_naturallyaccessible_obsrvd_sk_access_b,
    s.length_naturallyaccessible_model_sk,
    s.length_naturallyaccessible_model_sk_access_a,
    s.length_naturallyaccessible_model_sk_access_b,
    s.length_naturallyaccessible_obsrvd_salmon,
    s.length_naturallyaccessible_obsrvd_salmon_access_a,
    s.length_naturallyaccessible_obsrvd_salmon_access_b,
    s.length_naturallyaccessible_model_salmon,
    s.length_naturallyaccessible_model_salmon_access_a,
    s.length_naturallyaccessible_model_salmon_access_b,
    s.length_naturallyaccessible_obsrvd_st,
    s.length_naturallyaccessible_obsrvd_st_access_a,
    s.length_naturallyaccessible_obsrvd_st_access_b,
    s.length_naturallyaccessible_model_st,
    s.length_naturallyaccessible_model_st_access_a,
    s.length_naturallyaccessible_model_st_access_b,
    s.length_naturallyaccessible_obsrvd_wct,
    s.length_naturallyaccessible_obsrvd_wct_access_a,
    s.length_naturallyaccessible_obsrvd_wct_access_b,
    s.length_naturallyaccessible_model_wct,
    s.length_naturallyaccessible_model_wct_access_a,
    s.length_naturallyaccessible_model_wct_access_b,
    s.length_spawningrearing_obsrvd_bt,
    s.length_spawningrearing_obsrvd_bt_access_a,
    s.length_spawningrearing_obsrvd_bt_access_b,
    s.length_spawningrearing_model_bt,
    s.length_spawningrearing_model_bt_access_a,
    s.length_spawningrearing_model_bt_access_b,
    s.length_spawningrearing_obsrvd_ch,
    s.length_spawningrearing_obsrvd_ch_access_a,
    s.length_spawningrearing_obsrvd_ch_access_b,
    s.length_spawningrearing_model_ch,
    s.length_spawningrearing_model_ch_access_a,
    s.length_spawningrearing_model_ch_access_b,
    s.length_spawningrearing_obsrvd_cm,
    s.length_spawningrearing_obsrvd_cm_access_a,
    s.length_spawningrearing_obsrvd_cm_access_b,
    s.length_spawningrearing_model_cm,
    s.length_spawningrearing_model_cm_access_a,
    s.length_spawningrearing_model_cm_access_b,
    s.length_spawningrearing_obsrvd_co,
    s.length_spawningrearing_obsrvd_co_access_a,
    s.length_spawningrearing_obsrvd_co_access_b,
    s.length_spawningrearing_model_co,
    s.length_spawningrearing_model_co_access_a,
    s.length_spawningrearing_model_co_access_b,
    s.length_spawningrearing_obsrvd_pk,
    s.length_spawningrearing_obsrvd_pk_access_a,
    s.length_spawningrearing_obsrvd_pk_access_b,
    s.length_spawningrearing_model_pk,
    s.length_spawningrearing_model_pk_access_a,
    s.length_spawningrearing_model_pk_access_b,
    s.length_spawningrearing_obsrvd_sk,
    s.length_spawningrearing_obsrvd_sk_access_a,
    s.length_spawningrearing_obsrvd_sk_access_b,
    s.length_spawningrearing_model_sk,
    s.length_spawningrearing_model_sk_access_a,
    s.length_spawningrearing_model_sk_access_b,
    s.length_spawningrearing_obsrvd_st,
    s.length_spawningrearing_obsrvd_st_access_a,
    s.length_spawningrearing_obsrvd_st_access_b,
    s.length_spawningrearing_model_st,
    s.length_spawningrearing_model_st_access_a,
    s.length_spawningrearing_model_st_access_b,
    s.length_spawningrearing_obsrvd_wct,
    s.length_spawningrearing_obsrvd_wct_access_a,
    s.length_spawningrearing_obsrvd_wct_access_b,
    s.length_spawningrearing_model_wct,
    s.length_spawningrearing_model_wct_access_a,
    s.length_spawningrearing_model_wct_access_b,
    s.length_spawningrearing_obsrvd_salmon,
    s.length_spawningrearing_obsrvd_salmon_access_a,
    s.length_spawningrearing_obsrvd_salmon_access_b,
    s.length_spawningrearing_model_salmon,
    s.length_spawningrearing_model_salmon_access_a,
    s.length_spawningrearing_model_salmon_access_b,
    s.length_spawningrearing_obsrvd_salmon_st,
    s.length_spawningrearing_obsrvd_salmon_st_access_a,
    s.length_spawningrearing_obsrvd_salmon_st_access_b,
    s.length_spawningrearing_model_salmon_st,
    s.length_spawningrearing_model_salmon_st_access_a,
    s.length_spawningrearing_model_salmon_st_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_bt_access_b + s.length_naturallyaccessible_model_bt_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_bt + s.length_naturallyaccessible_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_bt_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_ch_access_b + s.length_naturallyaccessible_model_ch_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_ch + s.length_naturallyaccessible_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_ch_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_cm_access_b + s.length_naturallyaccessible_model_cm_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_cm + s.length_naturallyaccessible_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_cm_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_co_access_b + s.length_naturallyaccessible_model_co_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_co + s.length_naturallyaccessible_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_co_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_pk_access_b + s.length_naturallyaccessible_model_pk_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_pk + s.length_naturallyaccessible_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_pk_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_sk_access_b + s.length_naturallyaccessible_model_sk_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_sk + s.length_naturallyaccessible_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_sk_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_salmon_access_b + s.length_naturallyaccessible_model_salmon_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_salmon + s.length_naturallyaccessible_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_salmon_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_st_access_b + s.length_naturallyaccessible_model_st_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_st + s.length_naturallyaccessible_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_st_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_wct_access_b + s.length_naturallyaccessible_model_wct_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_wct + s.length_naturallyaccessible_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_wct_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_bt_access_b + s.length_spawningrearing_model_bt_access_b) / NULLIF((s.length_spawningrearing_obsrvd_bt + s.length_spawningrearing_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_bt_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_ch_access_b + s.length_spawningrearing_model_ch_access_b) / NULLIF((s.length_spawningrearing_obsrvd_ch + s.length_spawningrearing_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_ch_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_cm_access_b + s.length_spawningrearing_model_cm_access_b) / NULLIF((s.length_spawningrearing_obsrvd_cm + s.length_spawningrearing_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_cm_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_co_access_b + s.length_spawningrearing_model_co_access_b) / NULLIF((s.length_spawningrearing_obsrvd_co + s.length_spawningrearing_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_co_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_pk_access_b + s.length_spawningrearing_model_pk_access_b) / NULLIF((s.length_spawningrearing_obsrvd_pk + s.length_spawningrearing_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_pk_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_sk_access_b + s.length_spawningrearing_model_sk_access_b) / NULLIF((s.length_spawningrearing_obsrvd_sk + s.length_spawningrearing_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_sk_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_st_access_b + s.length_spawningrearing_model_st_access_b) / NULLIF((s.length_spawningrearing_obsrvd_st + s.length_spawningrearing_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_st_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_wct_access_b + s.length_spawningrearing_model_wct_access_b) / NULLIF((s.length_spawningrearing_obsrvd_wct + s.length_spawningrearing_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_wct_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_salmon_access_b + s.length_spawningrearing_model_salmon_access_b) / NULLIF((s.length_spawningrearing_obsrvd_salmon + s.length_spawningrearing_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_salmon_st_access_b + s.length_spawningrearing_model_salmon_st_access_b) / NULLIF((s.length_spawningrearing_obsrvd_salmon_st + s.length_spawningrearing_model_salmon_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_st_access_b
   FROM ((bcfishpass.log_aw_linear_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
     JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON ((s.assessment_watershed_id = aw.watershed_feature_id)))
  WHERE (l.date_completed = ( SELECT log.date_completed
           FROM bcfishpass.log
          ORDER BY log.date_completed DESC
         OFFSET 1
         LIMIT 1))
  ORDER BY s.assessment_watershed_id, l.date_completed DESC;


--
-- Name: aw_linear_summary_diff; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.aw_linear_summary_diff AS
 SELECT a.assessment_watershed_id,
    a.length_total,
    (a.length_naturallyaccessible_obsrvd_bt - b.length_naturallyaccessible_obsrvd_bt) AS length_naturallyaccessible_obsrvd_bt,
    (a.length_naturallyaccessible_obsrvd_bt_access_a - b.length_naturallyaccessible_obsrvd_bt_access_a) AS length_naturallyaccessible_obsrvd_bt_access_a,
    (a.length_naturallyaccessible_obsrvd_bt_access_b - b.length_naturallyaccessible_obsrvd_bt_access_b) AS length_naturallyaccessible_obsrvd_bt_access_b,
    (a.length_naturallyaccessible_model_bt - b.length_naturallyaccessible_model_bt) AS length_naturallyaccessible_model_bt,
    (a.length_naturallyaccessible_model_bt_access_a - b.length_naturallyaccessible_model_bt_access_a) AS length_naturallyaccessible_model_bt_access_a,
    (a.length_naturallyaccessible_model_bt_access_b - b.length_naturallyaccessible_model_bt_access_b) AS length_naturallyaccessible_model_bt_access_b,
    (a.length_naturallyaccessible_obsrvd_ch - b.length_naturallyaccessible_obsrvd_ch) AS length_naturallyaccessible_obsrvd_ch,
    (a.length_naturallyaccessible_obsrvd_ch_access_a - b.length_naturallyaccessible_obsrvd_ch_access_a) AS length_naturallyaccessible_obsrvd_ch_access_a,
    (a.length_naturallyaccessible_obsrvd_ch_access_b - b.length_naturallyaccessible_obsrvd_ch_access_b) AS length_naturallyaccessible_obsrvd_ch_access_b,
    (a.length_naturallyaccessible_model_ch - b.length_naturallyaccessible_model_ch) AS length_naturallyaccessible_model_ch,
    (a.length_naturallyaccessible_model_ch_access_a - b.length_naturallyaccessible_model_ch_access_a) AS length_naturallyaccessible_model_ch_access_a,
    (a.length_naturallyaccessible_model_ch_access_b - b.length_naturallyaccessible_model_ch_access_b) AS length_naturallyaccessible_model_ch_access_b,
    (a.length_naturallyaccessible_obsrvd_cm - b.length_naturallyaccessible_obsrvd_cm) AS length_naturallyaccessible_obsrvd_cm,
    (a.length_naturallyaccessible_obsrvd_cm_access_a - b.length_naturallyaccessible_obsrvd_cm_access_a) AS length_naturallyaccessible_obsrvd_cm_access_a,
    (a.length_naturallyaccessible_obsrvd_cm_access_b - b.length_naturallyaccessible_obsrvd_cm_access_b) AS length_naturallyaccessible_obsrvd_cm_access_b,
    (a.length_naturallyaccessible_model_cm - b.length_naturallyaccessible_model_cm) AS length_naturallyaccessible_model_cm,
    (a.length_naturallyaccessible_model_cm_access_a - b.length_naturallyaccessible_model_cm_access_a) AS length_naturallyaccessible_model_cm_access_a,
    (a.length_naturallyaccessible_model_cm_access_b - b.length_naturallyaccessible_model_cm_access_b) AS length_naturallyaccessible_model_cm_access_b,
    (a.length_naturallyaccessible_obsrvd_co - b.length_naturallyaccessible_obsrvd_co) AS length_naturallyaccessible_obsrvd_co,
    (a.length_naturallyaccessible_obsrvd_co_access_a - b.length_naturallyaccessible_obsrvd_co_access_a) AS length_naturallyaccessible_obsrvd_co_access_a,
    (a.length_naturallyaccessible_obsrvd_co_access_b - b.length_naturallyaccessible_obsrvd_co_access_b) AS length_naturallyaccessible_obsrvd_co_access_b,
    (a.length_naturallyaccessible_model_co - b.length_naturallyaccessible_model_co) AS length_naturallyaccessible_model_co,
    (a.length_naturallyaccessible_model_co_access_a - b.length_naturallyaccessible_model_co_access_a) AS length_naturallyaccessible_model_co_access_a,
    (a.length_naturallyaccessible_model_co_access_b - b.length_naturallyaccessible_model_co_access_b) AS length_naturallyaccessible_model_co_access_b,
    (a.length_naturallyaccessible_obsrvd_pk - b.length_naturallyaccessible_obsrvd_pk) AS length_naturallyaccessible_obsrvd_pk,
    (a.length_naturallyaccessible_obsrvd_pk_access_a - b.length_naturallyaccessible_obsrvd_pk_access_a) AS length_naturallyaccessible_obsrvd_pk_access_a,
    (a.length_naturallyaccessible_obsrvd_pk_access_b - b.length_naturallyaccessible_obsrvd_pk_access_b) AS length_naturallyaccessible_obsrvd_pk_access_b,
    (a.length_naturallyaccessible_model_pk - b.length_naturallyaccessible_model_pk) AS length_naturallyaccessible_model_pk,
    (a.length_naturallyaccessible_model_pk_access_a - b.length_naturallyaccessible_model_pk_access_a) AS length_naturallyaccessible_model_pk_access_a,
    (a.length_naturallyaccessible_model_pk_access_b - b.length_naturallyaccessible_model_pk_access_b) AS length_naturallyaccessible_model_pk_access_b,
    (a.length_naturallyaccessible_obsrvd_sk - b.length_naturallyaccessible_obsrvd_sk) AS length_naturallyaccessible_obsrvd_sk,
    (a.length_naturallyaccessible_obsrvd_sk_access_a - b.length_naturallyaccessible_obsrvd_sk_access_a) AS length_naturallyaccessible_obsrvd_sk_access_a,
    (a.length_naturallyaccessible_obsrvd_sk_access_b - b.length_naturallyaccessible_obsrvd_sk_access_b) AS length_naturallyaccessible_obsrvd_sk_access_b,
    (a.length_naturallyaccessible_model_sk - b.length_naturallyaccessible_model_sk) AS length_naturallyaccessible_model_sk,
    (a.length_naturallyaccessible_model_sk_access_a - b.length_naturallyaccessible_model_sk_access_a) AS length_naturallyaccessible_model_sk_access_a,
    (a.length_naturallyaccessible_model_sk_access_b - b.length_naturallyaccessible_model_sk_access_b) AS length_naturallyaccessible_model_sk_access_b,
    (a.length_naturallyaccessible_obsrvd_salmon - b.length_naturallyaccessible_obsrvd_salmon) AS length_naturallyaccessible_obsrvd_salmon,
    (a.length_naturallyaccessible_obsrvd_salmon_access_a - b.length_naturallyaccessible_obsrvd_salmon_access_a) AS length_naturallyaccessible_obsrvd_salmon_access_a,
    (a.length_naturallyaccessible_obsrvd_salmon_access_b - b.length_naturallyaccessible_obsrvd_salmon_access_b) AS length_naturallyaccessible_obsrvd_salmon_access_b,
    (a.length_naturallyaccessible_model_salmon - b.length_naturallyaccessible_model_salmon) AS length_naturallyaccessible_model_salmon,
    (a.length_naturallyaccessible_model_salmon_access_a - b.length_naturallyaccessible_model_salmon_access_a) AS length_naturallyaccessible_model_salmon_access_a,
    (a.length_naturallyaccessible_model_salmon_access_b - b.length_naturallyaccessible_model_salmon_access_b) AS length_naturallyaccessible_model_salmon_access_b,
    (a.length_naturallyaccessible_obsrvd_st - b.length_naturallyaccessible_obsrvd_st) AS length_naturallyaccessible_obsrvd_st,
    (a.length_naturallyaccessible_obsrvd_st_access_a - b.length_naturallyaccessible_obsrvd_st_access_a) AS length_naturallyaccessible_obsrvd_st_access_a,
    (a.length_naturallyaccessible_obsrvd_st_access_b - b.length_naturallyaccessible_obsrvd_st_access_b) AS length_naturallyaccessible_obsrvd_st_access_b,
    (a.length_naturallyaccessible_model_st - b.length_naturallyaccessible_model_st) AS length_naturallyaccessible_model_st,
    (a.length_naturallyaccessible_model_st_access_a - b.length_naturallyaccessible_model_st_access_a) AS length_naturallyaccessible_model_st_access_a,
    (a.length_naturallyaccessible_model_st_access_b - b.length_naturallyaccessible_model_st_access_b) AS length_naturallyaccessible_model_st_access_b,
    (a.length_naturallyaccessible_obsrvd_wct - b.length_naturallyaccessible_obsrvd_wct) AS length_naturallyaccessible_obsrvd_wct,
    (a.length_naturallyaccessible_obsrvd_wct_access_a - b.length_naturallyaccessible_obsrvd_wct_access_a) AS length_naturallyaccessible_obsrvd_wct_access_a,
    (a.length_naturallyaccessible_obsrvd_wct_access_b - b.length_naturallyaccessible_obsrvd_wct_access_b) AS length_naturallyaccessible_obsrvd_wct_access_b,
    (a.length_naturallyaccessible_model_wct - b.length_naturallyaccessible_model_wct) AS length_naturallyaccessible_model_wct,
    (a.length_naturallyaccessible_model_wct_access_a - b.length_naturallyaccessible_model_wct_access_a) AS length_naturallyaccessible_model_wct_access_a,
    (a.length_naturallyaccessible_model_wct_access_b - b.length_naturallyaccessible_model_wct_access_b) AS length_naturallyaccessible_model_wct_access_b,
    (a.length_spawningrearing_obsrvd_bt - b.length_spawningrearing_obsrvd_bt) AS length_spawningrearing_obsrvd_bt,
    (a.length_spawningrearing_obsrvd_bt_access_a - b.length_spawningrearing_obsrvd_bt_access_a) AS length_spawningrearing_obsrvd_bt_access_a,
    (a.length_spawningrearing_obsrvd_bt_access_b - b.length_spawningrearing_obsrvd_bt_access_b) AS length_spawningrearing_obsrvd_bt_access_b,
    (a.length_spawningrearing_model_bt - b.length_spawningrearing_model_bt) AS length_spawningrearing_model_bt,
    (a.length_spawningrearing_model_bt_access_a - b.length_spawningrearing_model_bt_access_a) AS length_spawningrearing_model_bt_access_a,
    (a.length_spawningrearing_model_bt_access_b - b.length_spawningrearing_model_bt_access_b) AS length_spawningrearing_model_bt_access_b,
    (a.length_spawningrearing_obsrvd_ch - b.length_spawningrearing_obsrvd_ch) AS length_spawningrearing_obsrvd_ch,
    (a.length_spawningrearing_obsrvd_ch_access_a - b.length_spawningrearing_obsrvd_ch_access_a) AS length_spawningrearing_obsrvd_ch_access_a,
    (a.length_spawningrearing_obsrvd_ch_access_b - b.length_spawningrearing_obsrvd_ch_access_b) AS length_spawningrearing_obsrvd_ch_access_b,
    (a.length_spawningrearing_model_ch - b.length_spawningrearing_model_ch) AS length_spawningrearing_model_ch,
    (a.length_spawningrearing_model_ch_access_a - b.length_spawningrearing_model_ch_access_a) AS length_spawningrearing_model_ch_access_a,
    (a.length_spawningrearing_model_ch_access_b - b.length_spawningrearing_model_ch_access_b) AS length_spawningrearing_model_ch_access_b,
    (a.length_spawningrearing_obsrvd_cm - b.length_spawningrearing_obsrvd_cm) AS length_spawningrearing_obsrvd_cm,
    (a.length_spawningrearing_obsrvd_cm_access_a - b.length_spawningrearing_obsrvd_cm_access_a) AS length_spawningrearing_obsrvd_cm_access_a,
    (a.length_spawningrearing_obsrvd_cm_access_b - b.length_spawningrearing_obsrvd_cm_access_b) AS length_spawningrearing_obsrvd_cm_access_b,
    (a.length_spawningrearing_model_cm - b.length_spawningrearing_model_cm) AS length_spawningrearing_model_cm,
    (a.length_spawningrearing_model_cm_access_a - b.length_spawningrearing_model_cm_access_a) AS length_spawningrearing_model_cm_access_a,
    (a.length_spawningrearing_model_cm_access_b - b.length_spawningrearing_model_cm_access_b) AS length_spawningrearing_model_cm_access_b,
    (a.length_spawningrearing_obsrvd_co - b.length_spawningrearing_obsrvd_co) AS length_spawningrearing_obsrvd_co,
    (a.length_spawningrearing_obsrvd_co_access_a - b.length_spawningrearing_obsrvd_co_access_a) AS length_spawningrearing_obsrvd_co_access_a,
    (a.length_spawningrearing_obsrvd_co_access_b - b.length_spawningrearing_obsrvd_co_access_b) AS length_spawningrearing_obsrvd_co_access_b,
    (a.length_spawningrearing_model_co - b.length_spawningrearing_model_co) AS length_spawningrearing_model_co,
    (a.length_spawningrearing_model_co_access_a - b.length_spawningrearing_model_co_access_a) AS length_spawningrearing_model_co_access_a,
    (a.length_spawningrearing_model_co_access_b - b.length_spawningrearing_model_co_access_b) AS length_spawningrearing_model_co_access_b,
    (a.length_spawningrearing_obsrvd_pk - b.length_spawningrearing_obsrvd_pk) AS length_spawningrearing_obsrvd_pk,
    (a.length_spawningrearing_obsrvd_pk_access_a - b.length_spawningrearing_obsrvd_pk_access_a) AS length_spawningrearing_obsrvd_pk_access_a,
    (a.length_spawningrearing_obsrvd_pk_access_b - b.length_spawningrearing_obsrvd_pk_access_b) AS length_spawningrearing_obsrvd_pk_access_b,
    (a.length_spawningrearing_model_pk - b.length_spawningrearing_model_pk) AS length_spawningrearing_model_pk,
    (a.length_spawningrearing_model_pk_access_a - b.length_spawningrearing_model_pk_access_a) AS length_spawningrearing_model_pk_access_a,
    (a.length_spawningrearing_model_pk_access_b - b.length_spawningrearing_model_pk_access_b) AS length_spawningrearing_model_pk_access_b,
    (a.length_spawningrearing_obsrvd_sk - b.length_spawningrearing_obsrvd_sk) AS length_spawningrearing_obsrvd_sk,
    (a.length_spawningrearing_obsrvd_sk_access_a - b.length_spawningrearing_obsrvd_sk_access_a) AS length_spawningrearing_obsrvd_sk_access_a,
    (a.length_spawningrearing_obsrvd_sk_access_b - b.length_spawningrearing_obsrvd_sk_access_b) AS length_spawningrearing_obsrvd_sk_access_b,
    (a.length_spawningrearing_model_sk - b.length_spawningrearing_model_sk) AS length_spawningrearing_model_sk,
    (a.length_spawningrearing_model_sk_access_a - b.length_spawningrearing_model_sk_access_a) AS length_spawningrearing_model_sk_access_a,
    (a.length_spawningrearing_model_sk_access_b - b.length_spawningrearing_model_sk_access_b) AS length_spawningrearing_model_sk_access_b,
    (a.length_spawningrearing_obsrvd_st - b.length_spawningrearing_obsrvd_st) AS length_spawningrearing_obsrvd_st,
    (a.length_spawningrearing_obsrvd_st_access_a - b.length_spawningrearing_obsrvd_st_access_a) AS length_spawningrearing_obsrvd_st_access_a,
    (a.length_spawningrearing_obsrvd_st_access_b - b.length_spawningrearing_obsrvd_st_access_b) AS length_spawningrearing_obsrvd_st_access_b,
    (a.length_spawningrearing_model_st - b.length_spawningrearing_model_st) AS length_spawningrearing_model_st,
    (a.length_spawningrearing_model_st_access_a - b.length_spawningrearing_model_st_access_a) AS length_spawningrearing_model_st_access_a,
    (a.length_spawningrearing_model_st_access_b - b.length_spawningrearing_model_st_access_b) AS length_spawningrearing_model_st_access_b,
    (a.length_spawningrearing_obsrvd_wct - b.length_spawningrearing_obsrvd_wct) AS length_spawningrearing_obsrvd_wct,
    (a.length_spawningrearing_obsrvd_wct_access_a - b.length_spawningrearing_obsrvd_wct_access_a) AS length_spawningrearing_obsrvd_wct_access_a,
    (a.length_spawningrearing_obsrvd_wct_access_b - b.length_spawningrearing_obsrvd_wct_access_b) AS length_spawningrearing_obsrvd_wct_access_b,
    (a.length_spawningrearing_model_wct - b.length_spawningrearing_model_wct) AS length_spawningrearing_model_wct,
    (a.length_spawningrearing_model_wct_access_a - b.length_spawningrearing_model_wct_access_a) AS length_spawningrearing_model_wct_access_a,
    (a.length_spawningrearing_model_wct_access_b - b.length_spawningrearing_model_wct_access_b) AS length_spawningrearing_model_wct_access_b,
    (a.length_spawningrearing_obsrvd_salmon - b.length_spawningrearing_obsrvd_salmon) AS length_spawningrearing_obsrvd_salmon,
    (a.length_spawningrearing_obsrvd_salmon_access_a - b.length_spawningrearing_obsrvd_salmon_access_a) AS length_spawningrearing_obsrvd_salmon_access_a,
    (a.length_spawningrearing_obsrvd_salmon_access_b - b.length_spawningrearing_obsrvd_salmon_access_b) AS length_spawningrearing_obsrvd_salmon_access_b,
    (a.length_spawningrearing_model_salmon - b.length_spawningrearing_model_salmon) AS length_spawningrearing_model_salmon,
    (a.length_spawningrearing_model_salmon_access_a - b.length_spawningrearing_model_salmon_access_a) AS length_spawningrearing_model_salmon_access_a,
    (a.length_spawningrearing_model_salmon_access_b - b.length_spawningrearing_model_salmon_access_b) AS length_spawningrearing_model_salmon_access_b,
    (a.length_spawningrearing_obsrvd_salmon_st - b.length_spawningrearing_obsrvd_salmon_st) AS length_spawningrearing_obsrvd_salmon_st,
    (a.length_spawningrearing_obsrvd_salmon_st_access_a - b.length_spawningrearing_obsrvd_salmon_st_access_a) AS length_spawningrearing_obsrvd_salmon_st_access_a,
    (a.length_spawningrearing_obsrvd_salmon_st_access_b - b.length_spawningrearing_obsrvd_salmon_st_access_b) AS length_spawningrearing_obsrvd_salmon_st_access_b,
    (a.length_spawningrearing_model_salmon_st - b.length_spawningrearing_model_salmon_st) AS length_spawningrearing_model_salmon_st,
    (a.length_spawningrearing_model_salmon_st_access_a - b.length_spawningrearing_model_salmon_st_access_a) AS length_spawningrearing_model_salmon_st_access_a,
    (a.length_spawningrearing_model_salmon_st_access_b - b.length_spawningrearing_model_salmon_st_access_b) AS length_spawningrearing_model_salmon_st_access_b,
    (a.pct_naturallyaccessible_bt_access_b - b.pct_naturallyaccessible_bt_access_b) AS pct_naturallyaccessible_bt_access_b,
    (a.pct_naturallyaccessible_ch_access_b - b.pct_naturallyaccessible_ch_access_b) AS pct_naturallyaccessible_ch_access_b,
    (a.pct_naturallyaccessible_cm_access_b - b.pct_naturallyaccessible_cm_access_b) AS pct_naturallyaccessible_cm_access_b,
    (a.pct_naturallyaccessible_co_access_b - b.pct_naturallyaccessible_co_access_b) AS pct_naturallyaccessible_co_access_b,
    (a.pct_naturallyaccessible_pk_access_b - b.pct_naturallyaccessible_pk_access_b) AS pct_naturallyaccessible_pk_access_b,
    (a.pct_naturallyaccessible_sk_access_b - b.pct_naturallyaccessible_sk_access_b) AS pct_naturallyaccessible_sk_access_b,
    (a.pct_naturallyaccessible_salmon_access_b - b.pct_naturallyaccessible_salmon_access_b) AS pct_naturallyaccessible_salmon_access_b,
    (a.pct_naturallyaccessible_st_access_b - b.pct_naturallyaccessible_st_access_b) AS pct_naturallyaccessible_st_access_b,
    (a.pct_naturallyaccessible_wct_access_b - b.pct_naturallyaccessible_wct_access_b) AS pct_naturallyaccessible_wct_access_b,
    (a.pct_spawningrearing_bt_access_b - b.pct_spawningrearing_bt_access_b) AS pct_spawningrearing_bt_access_b,
    (a.pct_spawningrearing_ch_access_b - b.pct_spawningrearing_ch_access_b) AS pct_spawningrearing_ch_access_b,
    (a.pct_spawningrearing_cm_access_b - b.pct_spawningrearing_cm_access_b) AS pct_spawningrearing_cm_access_b,
    (a.pct_spawningrearing_co_access_b - b.pct_spawningrearing_co_access_b) AS pct_spawningrearing_co_access_b,
    (a.pct_spawningrearing_pk_access_b - b.pct_spawningrearing_pk_access_b) AS pct_spawningrearing_pk_access_b,
    (a.pct_spawningrearing_sk_access_b - b.pct_spawningrearing_sk_access_b) AS pct_spawningrearing_sk_access_b,
    (a.pct_spawningrearing_st_access_b - b.pct_spawningrearing_st_access_b) AS pct_spawningrearing_st_access_b,
    (a.pct_spawningrearing_wct_access_b - b.pct_spawningrearing_wct_access_b) AS pct_spawningrearing_wct_access_b,
    (a.pct_spawningrearing_salmon_access_b - b.pct_spawningrearing_salmon_access_b) AS pct_spawningrearing_salmon_access_b,
    (a.pct_spawningrearing_salmon_st_access_b - b.pct_spawningrearing_salmon_st_access_b) AS pct_spawningrearing_salmon_st_access_b
   FROM (bcfishpass.aw_linear_summary_current a
     JOIN bcfishpass.aw_linear_summary_previous b ON ((a.assessment_watershed_id = b.assessment_watershed_id)))
  ORDER BY a.assessment_watershed_id;


--
-- Name: barriers_anthropogenic; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_anthropogenic (
    barriers_anthropogenic_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_anthropogenic_dnstr_barriers_anthropogenic; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic (
    barriers_anthropogenic_id text NOT NULL,
    features_dnstr text[]
);


--
-- Name: barriers_bt; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_bt (
    barriers_bt_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: barriers_ch_cm_co_pk_sk; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_ch_cm_co_pk_sk (
    barriers_ch_cm_co_pk_sk_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: barriers_ct_dv_rb; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_ct_dv_rb (
    barriers_ct_dv_rb_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: barriers_dams; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_dams (
    barriers_dams_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_dams_hydro; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_dams_hydro (
    barriers_dams_hydro_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_falls; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_falls (
    barriers_falls_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_gradient; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_gradient (
    barriers_gradient_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_pscis; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_pscis (
    barriers_pscis_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_remediations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_remediations (
    barriers_remediations_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_st; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_st (
    barriers_st_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: barriers_subsurfaceflow; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_subsurfaceflow (
    barriers_subsurfaceflow_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_user_definite; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_user_definite (
    barriers_user_definite_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_wct; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_wct (
    barriers_wct_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: cabd_additions; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.cabd_additions (
    feature_type text,
    name text,
    height numeric,
    barrier_ind boolean,
    blue_line_key integer NOT NULL,
    downstream_route_measure integer NOT NULL,
    reviewer_name text,
    review_date date,
    source text,
    notes text,
    CONSTRAINT cabd_additions_feature_type_check CHECK ((feature_type = ANY (ARRAY['dams'::text, 'waterfalls'::text])))
);


--
-- Name: TABLE cabd_additions; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.cabd_additions IS 'Insert falls or dams required for bcfishpass but not present in CABD. Includes placeholders for dams outside of BC';


--
-- Name: COLUMN cabd_additions.feature_type; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.feature_type IS 'Feature type, either waterfalls or dams';


--
-- Name: COLUMN cabd_additions.name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.name IS 'Name of waterfalls or dam';


--
-- Name: COLUMN cabd_additions.height; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.height IS 'Height (m) of waterfalls or dam';


--
-- Name: COLUMN cabd_additions.barrier_ind; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.barrier_ind IS 'Barrier status of waterfalls or dam (true/false)';


--
-- Name: COLUMN cabd_additions.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.blue_line_key IS 'FWA blue_line_key (flow line) on which the feature lies';


--
-- Name: COLUMN cabd_additions.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';


--
-- Name: COLUMN cabd_additions.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN cabd_additions.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN cabd_additions.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.source IS 'Description or link to the source(s) documenting the feature';


--
-- Name: COLUMN cabd_additions.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.notes IS 'Reviewer notes on rationale for addition of the feature and/or how the source were interpreted';


--
-- Name: cabd_blkey_xref; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.cabd_blkey_xref (
    cabd_id text,
    blue_line_key integer,
    reviewer_name text,
    review_date date,
    notes text
);


--
-- Name: TABLE cabd_blkey_xref; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.cabd_blkey_xref IS 'Cross reference CABD features to FWA flow lines (blue_line_key), used when CABD feature location is closest to an inapproprate flow line';


--
-- Name: COLUMN cabd_blkey_xref.cabd_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.cabd_id IS 'CABD unique identifier';


--
-- Name: COLUMN cabd_blkey_xref.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.blue_line_key IS 'FWA blue_line_key (flow line) to which the CABD feature should be linked';


--
-- Name: COLUMN cabd_blkey_xref.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN cabd_blkey_xref.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN cabd_blkey_xref.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.notes IS 'Reviewer notes on rationale for fix and/or how the source(s) were interpreted';


--
-- Name: cabd_exclusions; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.cabd_exclusions (
    cabd_id text NOT NULL,
    feature_type text,
    reviewer_name text,
    review_date date,
    source text,
    notes text,
    CONSTRAINT cabd_exclusions_feature_type_check CHECK ((feature_type = ANY (ARRAY['dams'::text, 'waterfalls'::text])))
);


--
-- Name: TABLE cabd_exclusions; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.cabd_exclusions IS 'Exclude CABD records (waterfalls and dams) from bcfishpass usage';


--
-- Name: COLUMN cabd_exclusions.cabd_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.cabd_id IS 'CABD unique identifier';


--
-- Name: COLUMN cabd_exclusions.feature_type; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.feature_type IS 'Feature type, either waterfalls or dams';


--
-- Name: COLUMN cabd_exclusions.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN cabd_exclusions.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN cabd_exclusions.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.source IS 'Description or link to the source(s) indicating why the feature should be excluded';


--
-- Name: COLUMN cabd_exclusions.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.notes IS 'Reviewer notes on rationale for exclusion and/or how the source were interpreted';


--
-- Name: cabd_passability_status_updates; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.cabd_passability_status_updates (
    cabd_id text NOT NULL,
    passability_status_code integer,
    reviewer_name text,
    review_date date,
    source text,
    notes text,
    CONSTRAINT cabd_passability_status_updates_passability_status_code_check CHECK (((passability_status_code > 0) AND (passability_status_code < 7)))
);


--
-- Name: TABLE cabd_passability_status_updates; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.cabd_passability_status_updates IS 'Update the passability_status_code (within bcfishpass) of existing CABD features (dams or waterfalls)';


--
-- Name: COLUMN cabd_passability_status_updates.cabd_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.cabd_id IS 'CABD unique identifier';


--
-- Name: COLUMN cabd_passability_status_updates.passability_status_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.passability_status_code IS 'Code referencing the degree to which the feature acts as a barrier to fish in the upstream direction. (1=Barrier, 2=Partial barrier, 3=Passable, 4=Unknown, 5=NA-No Structure, 6=NA-Decommissioned/Removed)';


--
-- Name: COLUMN cabd_passability_status_updates.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN cabd_passability_status_updates.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN cabd_passability_status_updates.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.source IS 'Description or link to the source(s) documenting the passability status of the feature';


--
-- Name: COLUMN cabd_passability_status_updates.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.notes IS 'Reviewer notes on rationale for fix and/or how the source(s) were interpreted';


--
-- Name: crossings; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings (
    aggregated_crossings_id text NOT NULL,
    stream_crossing_id integer,
    dam_id text,
    user_crossing_misc_id bigint,
    modelled_crossing_id integer,
    crossing_source text,
    pscis_status text,
    crossing_type_code text,
    crossing_subtype_code text,
    modelled_crossing_type_source text[],
    barrier_status text,
    pscis_road_name text,
    pscis_stream_name text,
    pscis_assessment_comment text,
    pscis_assessment_date date,
    pscis_final_score integer,
    transport_line_structured_name_1 text,
    transport_line_type_description text,
    transport_line_surface_description text,
    ften_forest_file_id text,
    ften_road_section_id text,
    ften_file_type_description text,
    ften_client_number text,
    ften_client_name text,
    ften_life_cycle_status_code text,
    ften_map_label text,
    rail_track_name text,
    rail_owner_name text,
    rail_operator_english_name text,
    ogc_proponent text,
    dam_name text,
    dam_height double precision,
    dam_owner text,
    dam_use text,
    dam_operating_status text,
    utm_zone integer,
    utm_easting integer,
    utm_northing integer,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code text,
    gnis_stream_name text,
    stream_order integer,
    stream_magnitude integer,
    geom public.geometry(PointZM,3005),
    crossing_feature_type text
);


--
-- Name: COLUMN crossings.aggregated_crossings_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.aggregated_crossings_id IS 'unique identifier for crossing, generated from stream_crossing_id, modelled_crossing_id + 1000000000, user_barrier_anthropogenic_id + 1200000000, cabd_id';


--
-- Name: COLUMN crossings.stream_crossing_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.stream_crossing_id IS 'PSCIS stream crossing unique identifier';


--
-- Name: COLUMN crossings.dam_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_id IS 'BC Dams unique identifier';


--
-- Name: COLUMN crossings.user_crossing_misc_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.user_crossing_misc_id IS 'User added misc anthropogenic barriers unique identifier';


--
-- Name: COLUMN crossings.modelled_crossing_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.modelled_crossing_id IS 'Modelled crossing unique identifier';


--
-- Name: COLUMN crossings.crossing_source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.crossing_source IS 'Data source for the crossing, one of: {PSCIS,MODELLED CROSSINGS,CABD,MISC BARRIERS}';


--
-- Name: COLUMN crossings.pscis_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_status IS 'From PSCIS, the current_pscis_status of the crossing, one of: {ASSESSED,HABITAT CONFIRMATION,DESIGN,REMEDIATED}';


--
-- Name: COLUMN crossings.crossing_type_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. Acceptable types are: OBS = Open Bottom Structure CBS = Closed Bottom Structure OTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN crossings.crossing_subtype_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.crossing_subtype_code IS 'Further definition of the type of crossing, one of {BRIDGE,CRTBOX,DAM,FORD,OVAL,PIPEARCH,ROUND,WEIR,WOODBOX,NULL}';


--
-- Name: COLUMN crossings.modelled_crossing_type_source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.modelled_crossing_type_source IS 'List of sources that indicate if a modelled crossing is open bottom, Acceptable values are: FWA_EDGE_TYPE=double line river, FWA_STREAM_ORDER=stream order >=6, GBA_RAILWAY_STRUCTURE_LINES_SP=railway structure, "MANUAL FIX"=manually identified OBS, MOT_ROAD_STRUCTURE_SP=MoT structure, TRANSPORT_LINE_STRUCTURE_CODE=DRA structure}';


--
-- Name: COLUMN crossings.barrier_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. Acceptable Values are: PASSABLE - Passable, POTENTIAL - Potential or partial barrier, BARRIER - Barrier, UNKNOWN - Other';


--
-- Name: COLUMN crossings.pscis_road_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_road_name IS 'PSCIS road name, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.pscis_stream_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_stream_name IS 'PSCIS stream name, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.pscis_assessment_comment; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_assessment_comment IS 'PSCIS assessment_comment, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.pscis_assessment_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_assessment_date IS 'PSCIS assessment_date, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.pscis_final_score; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_final_score IS 'PSCIS final_score, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.transport_line_structured_name_1; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.transport_line_structured_name_1 IS 'DRA road name, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings.transport_line_type_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.transport_line_type_description IS 'DRA road type, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings.transport_line_surface_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.transport_line_surface_description IS 'DRA road surface, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings.ften_forest_file_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_forest_file_id IS 'FTEN road forest_file_id value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_road_section_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_road_section_id IS 'FTEN road road_section_id value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_file_type_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_file_type_description IS 'FTEN road tenure type (Forest Service Road, Road Permit, etc), taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_client_number; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_client_number IS 'FTEN road client number, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_client_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_client_name IS 'FTEN road client name, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_life_cycle_status_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_life_cycle_status_code IS 'FTEN road life_cycle_status_code (active or retired, pending roads are not included), taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_map_label; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_map_label IS 'FTEN road map_label value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.rail_track_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.rail_track_name IS 'Railway name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings.rail_owner_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.rail_owner_name IS 'Railway owner name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings.rail_operator_english_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.rail_operator_english_name IS 'Railway operator name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings.ogc_proponent; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ogc_proponent IS 'OGC road tenure proponent (currently modelled crossings only, taken from OGC road that crosses the stream)';


--
-- Name: COLUMN crossings.dam_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_name IS 'See CABD dams column: dam_name_en';


--
-- Name: COLUMN crossings.dam_height; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_height IS 'See CABD dams column: dam_height';


--
-- Name: COLUMN crossings.dam_owner; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_owner IS 'See CABD dams column: owner';


--
-- Name: COLUMN crossings.dam_use; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_use IS 'See CABD table dam_use_codes';


--
-- Name: COLUMN crossings.dam_operating_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_operating_status IS 'See CABD dams column dam_operating_status';


--
-- Name: COLUMN crossings.utm_zone; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.utm_zone IS 'UTM ZONE is a segment of the Earths surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';


--
-- Name: COLUMN crossings.utm_easting; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';


--
-- Name: COLUMN crossings.utm_northing; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';


--
-- Name: COLUMN crossings.linear_feature_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.linear_feature_id IS 'From BC FWA, the unique identifier for a stream segment (flow network arc)';


--
-- Name: COLUMN crossings.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.blue_line_key IS 'From BC FWA, uniquely identifies a single flow line such that a main channel and a secondary channel with the same watershed code would have different blue line keys (the Fraser River and all side channels have different blue line keys).';


--
-- Name: COLUMN crossings.watershed_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.watershed_key IS 'From BC FWA, a key that identifies a stream system. There is a 1:1 match between a watershed key and watershed code. The watershed key will match the blue line key for the mainstem.';


--
-- Name: COLUMN crossings.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';


--
-- Name: COLUMN crossings.wscode_ltree; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.wscode_ltree IS 'A truncated version of the BC FWA fwa_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';


--
-- Name: COLUMN crossings.localcode_ltree; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.localcode_ltree IS 'A truncated version of the BC FWA local_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';


--
-- Name: COLUMN crossings.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.watershed_group_code IS 'The watershed group code associated with the feature.';


--
-- Name: COLUMN crossings.gnis_stream_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.gnis_stream_name IS 'The BCGNIS (BC Geographical Names Information System) name associated with the FWA stream';


--
-- Name: COLUMN crossings.stream_order; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.stream_order IS 'Order of FWA stream at point';


--
-- Name: COLUMN crossings.stream_magnitude; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.stream_magnitude IS 'Magnitude of FWA stream at point';


--
-- Name: COLUMN crossings.geom; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.geom IS 'The point geometry associated with the feature';


--
-- Name: crossings_admin_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.crossings_admin_vw AS
 SELECT DISTINCT ON (c.aggregated_crossings_id) c.aggregated_crossings_id,
    rd.admin_area_abbreviation AS abms_regional_district,
    muni.admin_area_abbreviation AS abms_municipality,
    ir.english_name AS clab_indian_reserve_name,
    ir.band_name AS clab_indian_reserve_band_name,
    np.english_name AS clab_national_park_name,
    pp.protected_lands_name AS bc_protected_lands_name,
    pmbc.owner_type AS pmbc_owner_type,
    nr.region_org_unit_name AS adm_nr_region,
    nr.district_name AS adm_nr_district
   FROM (((((((bcfishpass.crossings c
     LEFT JOIN whse_legal_admin_boundaries.abms_regional_districts_sp rd ON (public.st_intersects(c.geom, rd.geom)))
     LEFT JOIN whse_legal_admin_boundaries.abms_municipalities_sp muni ON (public.st_intersects(c.geom, muni.geom)))
     LEFT JOIN whse_admin_boundaries.adm_indian_reserves_bands_sp ir ON (public.st_intersects(c.geom, ir.geom)))
     LEFT JOIN whse_admin_boundaries.clab_national_parks np ON (public.st_intersects(c.geom, np.geom)))
     LEFT JOIN whse_tantalis.ta_park_ecores_pa_svw pp ON (public.st_intersects(c.geom, pp.geom)))
     LEFT JOIN whse_cadastre.pmbc_parcel_fabric_poly_svw pmbc ON (public.st_intersects(c.geom, pmbc.geom)))
     LEFT JOIN whse_admin_boundaries.adm_nr_districts_spg nr ON (public.st_intersects(c.geom, pmbc.geom)))
  ORDER BY c.aggregated_crossings_id, rd.admin_area_abbreviation, muni.admin_area_abbreviation, ir.english_name, pp.protected_lands_name, pmbc.owner_type, nr.district_name
  WITH NO DATA;


--
-- Name: crossings_dnstr_barriers_anthropogenic; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_dnstr_barriers_anthropogenic (
    aggregated_crossings_id text NOT NULL,
    features_dnstr text[]
);


--
-- Name: crossings_dnstr_crossings; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_dnstr_crossings (
    aggregated_crossings_id text NOT NULL,
    features_dnstr text[]
);


--
-- Name: crossings_dnstr_observations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_dnstr_observations (
    aggregated_crossings_id text NOT NULL,
    observedspp_dnstr text[]
);


--
-- Name: crossings_upstr_barriers_anthropogenic; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstr_barriers_anthropogenic (
    aggregated_crossings_id text NOT NULL,
    features_upstr text[]
);


--
-- Name: crossings_upstr_barriers_per_model; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstr_barriers_per_model (
    aggregated_crossings_id text,
    barriers_upstr_bt text[],
    barriers_upstr_ch_cm_co_pk_sk text[],
    barriers_upstr_ct_dv_rb text[],
    barriers_upstr_st text[],
    barriers_upstr_wct text[]
);


--
-- Name: crossings_upstr_observations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstr_observations (
    aggregated_crossings_id text NOT NULL,
    observedspp_upstr text[]
);


--
-- Name: crossings_upstream_access; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstream_access (
    aggregated_crossings_id text NOT NULL,
    watershed_group_code character varying(4),
    gradient double precision,
    total_network_km double precision DEFAULT 0,
    total_stream_km double precision DEFAULT 0,
    total_lakereservoir_ha double precision DEFAULT 0,
    total_wetland_ha double precision DEFAULT 0,
    total_slopeclass03_waterbodies_km double precision DEFAULT 0,
    total_slopeclass03_km double precision DEFAULT 0,
    total_slopeclass05_km double precision DEFAULT 0,
    total_slopeclass08_km double precision DEFAULT 0,
    total_slopeclass15_km double precision DEFAULT 0,
    total_slopeclass22_km double precision DEFAULT 0,
    total_slopeclass30_km double precision DEFAULT 0,
    total_belowupstrbarriers_network_km double precision DEFAULT 0,
    total_belowupstrbarriers_stream_km double precision DEFAULT 0,
    total_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    total_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_bt_dnstr text[],
    bt_network_km double precision DEFAULT 0,
    bt_stream_km double precision DEFAULT 0,
    bt_lakereservoir_ha double precision DEFAULT 0,
    bt_wetland_ha double precision DEFAULT 0,
    bt_slopeclass03_waterbodies_km double precision DEFAULT 0,
    bt_slopeclass03_km double precision DEFAULT 0,
    bt_slopeclass05_km double precision DEFAULT 0,
    bt_slopeclass08_km double precision DEFAULT 0,
    bt_slopeclass15_km double precision DEFAULT 0,
    bt_slopeclass22_km double precision DEFAULT 0,
    bt_slopeclass30_km double precision DEFAULT 0,
    bt_belowupstrbarriers_network_km double precision DEFAULT 0,
    bt_belowupstrbarriers_stream_km double precision DEFAULT 0,
    bt_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    bt_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_ch_cm_co_pk_sk_dnstr text[],
    ch_cm_co_pk_sk_network_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_stream_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_lakereservoir_ha double precision DEFAULT 0,
    ch_cm_co_pk_sk_wetland_ha double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass03_waterbodies_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass03_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass05_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass08_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass15_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass22_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass30_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_network_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_stream_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_ct_dv_rb_dnstr text[],
    ct_dv_rb_network_km double precision DEFAULT 0,
    ct_dv_rb_stream_km double precision DEFAULT 0,
    ct_dv_rb_lakereservoir_ha double precision DEFAULT 0,
    ct_dv_rb_wetland_ha double precision DEFAULT 0,
    ct_dv_rb_slopeclass03_waterbodies_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass03_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass05_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass08_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass15_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass22_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass30_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_network_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_stream_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_st_dnstr text[],
    st_network_km double precision DEFAULT 0,
    st_stream_km double precision DEFAULT 0,
    st_lakereservoir_ha double precision DEFAULT 0,
    st_wetland_ha double precision DEFAULT 0,
    st_slopeclass03_waterbodies_km double precision DEFAULT 0,
    st_slopeclass03_km double precision DEFAULT 0,
    st_slopeclass05_km double precision DEFAULT 0,
    st_slopeclass08_km double precision DEFAULT 0,
    st_slopeclass15_km double precision DEFAULT 0,
    st_slopeclass22_km double precision DEFAULT 0,
    st_slopeclass30_km double precision DEFAULT 0,
    st_belowupstrbarriers_network_km double precision DEFAULT 0,
    st_belowupstrbarriers_stream_km double precision DEFAULT 0,
    st_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    st_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_wct_dnstr text[],
    wct_network_km double precision DEFAULT 0,
    wct_stream_km double precision DEFAULT 0,
    wct_lakereservoir_ha double precision DEFAULT 0,
    wct_wetland_ha double precision DEFAULT 0,
    wct_slopeclass03_waterbodies_km double precision DEFAULT 0,
    wct_slopeclass03_km double precision DEFAULT 0,
    wct_slopeclass05_km double precision DEFAULT 0,
    wct_slopeclass08_km double precision DEFAULT 0,
    wct_slopeclass15_km double precision DEFAULT 0,
    wct_slopeclass22_km double precision DEFAULT 0,
    wct_slopeclass30_km double precision DEFAULT 0,
    wct_belowupstrbarriers_network_km double precision DEFAULT 0,
    wct_belowupstrbarriers_stream_km double precision DEFAULT 0,
    wct_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    wct_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0
);


--
-- Name: crossings_upstream_habitat; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstream_habitat (
    aggregated_crossings_id text NOT NULL,
    watershed_group_code character varying(4),
    bt_spawning_km double precision DEFAULT 0,
    bt_rearing_km double precision DEFAULT 0,
    bt_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    bt_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    ch_spawning_km double precision DEFAULT 0,
    ch_rearing_km double precision DEFAULT 0,
    ch_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    ch_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    cm_spawning_km double precision DEFAULT 0,
    cm_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    co_spawning_km double precision DEFAULT 0,
    co_rearing_km double precision DEFAULT 0,
    co_rearing_ha double precision DEFAULT 0,
    co_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    co_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    co_rearing_belowupstrbarriers_ha double precision DEFAULT 0,
    pk_spawning_km double precision DEFAULT 0,
    pk_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    sk_spawning_km double precision DEFAULT 0,
    sk_rearing_km double precision DEFAULT 0,
    sk_rearing_ha double precision DEFAULT 0,
    sk_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    sk_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    sk_rearing_belowupstrbarriers_ha double precision DEFAULT 0,
    st_spawning_km double precision DEFAULT 0,
    st_rearing_km double precision DEFAULT 0,
    st_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    st_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    wct_spawning_km double precision DEFAULT 0,
    wct_rearing_km double precision DEFAULT 0,
    wct_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    wct_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    bt_spawningrearing_km double precision DEFAULT 0,
    bt_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    ch_spawningrearing_km double precision DEFAULT 0,
    ch_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    co_spawningrearing_km double precision DEFAULT 0,
    co_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    sk_spawningrearing_km double precision DEFAULT 0,
    sk_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    st_spawningrearing_km double precision DEFAULT 0,
    st_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    salmon_spawningrearing_km double precision DEFAULT 0,
    salmon_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    salmonsteelhead_spawningrearing_km double precision DEFAULT 0,
    salmonsteelhead_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    wct_spawningrearing_km double precision DEFAULT 0,
    wct_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0
);


--
-- Name: crossings_upstream_habitat_wcrp; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstream_habitat_wcrp (
    aggregated_crossings_id text NOT NULL,
    watershed_group_code character varying(4),
    co_rearing_km double precision DEFAULT 0,
    co_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    sk_rearing_km double precision DEFAULT 0,
    sk_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    all_spawning_km double precision DEFAULT 0,
    all_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    all_rearing_km double precision DEFAULT 0,
    all_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    all_spawningrearing_km double precision DEFAULT 0,
    all_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    co_spawningrearing_km double precision DEFAULT 0,
    co_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    sk_spawningrearing_km double precision DEFAULT 0,
    sk_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0
);


--
-- Name: streams; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams (
    segmented_stream_id text GENERATED ALWAYS AS ((((blue_line_key)::text || '.'::text) || (round((public.st_m(public.st_pointn(geom, 1)) * (1000)::double precision)))::text)) STORED NOT NULL,
    linear_feature_id bigint,
    edge_type integer,
    blue_line_key integer,
    watershed_key integer,
    watershed_group_code character varying(4),
    downstream_route_measure double precision GENERATED ALWAYS AS (public.st_m(public.st_pointn(geom, 1))) STORED,
    length_metre double precision GENERATED ALWAYS AS (public.st_length(geom)) STORED,
    waterbody_key integer,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    gnis_name character varying(80),
    stream_order integer,
    stream_magnitude integer,
    gradient double precision GENERATED ALWAYS AS (round((((public.st_z(public.st_pointn(geom, '-1'::integer)) - public.st_z(public.st_pointn(geom, 1))) / public.st_length(geom)))::numeric, 4)) STORED,
    feature_code character varying(10),
    upstream_route_measure double precision GENERATED ALWAYS AS (public.st_m(public.st_pointn(geom, '-1'::integer))) STORED,
    upstream_area_ha double precision,
    stream_order_parent integer,
    stream_order_max integer,
    map_upstream integer,
    channel_width double precision,
    mad_m3s double precision,
    geom public.geometry(LineStringZM,3005)
);


--
-- Name: crossings_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.crossings_vw AS
 SELECT DISTINCT ON (c.aggregated_crossings_id) c.aggregated_crossings_id,
    c.stream_crossing_id,
    c.dam_id,
    c.user_crossing_misc_id,
    c.modelled_crossing_id,
    c.crossing_source,
    c.crossing_feature_type,
    c.pscis_status,
    c.crossing_type_code,
    c.crossing_subtype_code,
    array_to_string(c.modelled_crossing_type_source, ';'::text) AS modelled_crossing_type_source,
    c.barrier_status,
    c.pscis_road_name,
    c.pscis_stream_name,
    c.pscis_assessment_comment,
    c.pscis_assessment_date,
    c.pscis_final_score,
    c.transport_line_structured_name_1,
    c.transport_line_type_description,
    c.transport_line_surface_description,
    c.ften_forest_file_id,
    c.ften_road_section_id,
    c.ften_file_type_description,
    c.ften_client_number,
    c.ften_client_name,
    c.ften_life_cycle_status_code,
    c.ften_map_label,
    c.rail_track_name,
    c.rail_owner_name,
    c.rail_operator_english_name,
    c.ogc_proponent,
    c.dam_name,
    c.dam_height,
    c.dam_owner,
    c.dam_use,
    c.dam_operating_status,
    c.utm_zone,
    c.utm_easting,
    c.utm_northing,
    t.map_tile_display_name AS dbm_mof_50k_grid,
    c.linear_feature_id,
    c.blue_line_key,
    c.watershed_key,
    c.downstream_route_measure,
    c.wscode_ltree AS wscode,
    c.localcode_ltree AS localcode,
    c.watershed_group_code,
    c.gnis_stream_name,
    c.stream_order,
    c.stream_magnitude,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(cdo.observedspp_dnstr, ';'::text) AS observedspp_dnstr,
    array_to_string(cuo.observedspp_upstr, ';'::text) AS observedspp_upstr,
    array_to_string(cd.features_dnstr, ';'::text) AS crossings_dnstr,
    array_to_string(ad.features_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    COALESCE(array_length(ad.features_dnstr, 1), 0) AS barriers_anthropogenic_dnstr_count,
    array_to_string(au.features_upstr, ';'::text) AS barriers_anthropogenic_upstr,
    COALESCE(array_length(au.features_upstr, 1), 0) AS barriers_anthropogenic_upstr_count,
    array_to_string(aum.barriers_upstr_bt, ';'::text) AS barriers_anthropogenic_bt_upstr,
    COALESCE(array_length(aum.barriers_upstr_bt, 1), 0) AS barriers_anthropogenic_upstr_bt_count,
    array_to_string(aum.barriers_upstr_ch_cm_co_pk_sk, ';'::text) AS barriers_anthropogenic_ch_cm_co_pk_sk_upstr,
    COALESCE(array_length(aum.barriers_upstr_ch_cm_co_pk_sk, 1), 0) AS barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count,
    array_to_string(aum.barriers_upstr_st, ';'::text) AS barriers_anthropogenic_st_upstr,
    COALESCE(array_length(aum.barriers_upstr_st, 1), 0) AS barriers_anthropogenic_st_upstr_count,
    array_to_string(aum.barriers_upstr_wct, ';'::text) AS barriers_anthropogenic_wct_upstr,
    COALESCE(array_length(aum.barriers_upstr_wct, 1), 0) AS barriers_anthropogenic_wct_upstr_count,
    a.gradient,
    a.total_network_km,
    a.total_stream_km,
    a.total_lakereservoir_ha,
    a.total_wetland_ha,
    a.total_slopeclass03_waterbodies_km,
    a.total_slopeclass03_km,
    a.total_slopeclass05_km,
    a.total_slopeclass08_km,
    a.total_slopeclass15_km,
    a.total_slopeclass22_km,
    a.total_slopeclass30_km,
    a.total_belowupstrbarriers_network_km,
    a.total_belowupstrbarriers_stream_km,
    a.total_belowupstrbarriers_lakereservoir_ha,
    a.total_belowupstrbarriers_wetland_ha,
    a.total_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.total_belowupstrbarriers_slopeclass03_km,
    a.total_belowupstrbarriers_slopeclass05_km,
    a.total_belowupstrbarriers_slopeclass08_km,
    a.total_belowupstrbarriers_slopeclass15_km,
    a.total_belowupstrbarriers_slopeclass22_km,
    a.total_belowupstrbarriers_slopeclass30_km,
    array_to_string(a.barriers_bt_dnstr, ';'::text) AS barriers_bt_dnstr,
    a.bt_network_km,
    a.bt_stream_km,
    a.bt_lakereservoir_ha,
    a.bt_wetland_ha,
    a.bt_slopeclass03_waterbodies_km,
    a.bt_slopeclass03_km,
    a.bt_slopeclass05_km,
    a.bt_slopeclass08_km,
    a.bt_slopeclass15_km,
    a.bt_slopeclass22_km,
    a.bt_slopeclass30_km,
    a.bt_belowupstrbarriers_network_km,
    a.bt_belowupstrbarriers_stream_km,
    a.bt_belowupstrbarriers_lakereservoir_ha,
    a.bt_belowupstrbarriers_wetland_ha,
    a.bt_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.bt_belowupstrbarriers_slopeclass03_km,
    a.bt_belowupstrbarriers_slopeclass05_km,
    a.bt_belowupstrbarriers_slopeclass08_km,
    a.bt_belowupstrbarriers_slopeclass15_km,
    a.bt_belowupstrbarriers_slopeclass22_km,
    a.bt_belowupstrbarriers_slopeclass30_km,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    a.ch_cm_co_pk_sk_network_km,
    a.ch_cm_co_pk_sk_stream_km,
    a.ch_cm_co_pk_sk_lakereservoir_ha,
    a.ch_cm_co_pk_sk_wetland_ha,
    a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
    a.ch_cm_co_pk_sk_slopeclass03_km,
    a.ch_cm_co_pk_sk_slopeclass05_km,
    a.ch_cm_co_pk_sk_slopeclass08_km,
    a.ch_cm_co_pk_sk_slopeclass15_km,
    a.ch_cm_co_pk_sk_slopeclass22_km,
    a.ch_cm_co_pk_sk_slopeclass30_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
    a.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    a.st_network_km,
    a.st_stream_km,
    a.st_lakereservoir_ha,
    a.st_wetland_ha,
    a.st_slopeclass03_waterbodies_km,
    a.st_slopeclass03_km,
    a.st_slopeclass05_km,
    a.st_slopeclass08_km,
    a.st_slopeclass15_km,
    a.st_slopeclass22_km,
    a.st_slopeclass30_km,
    a.st_belowupstrbarriers_network_km,
    a.st_belowupstrbarriers_stream_km,
    a.st_belowupstrbarriers_lakereservoir_ha,
    a.st_belowupstrbarriers_wetland_ha,
    a.st_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.st_belowupstrbarriers_slopeclass03_km,
    a.st_belowupstrbarriers_slopeclass05_km,
    a.st_belowupstrbarriers_slopeclass08_km,
    a.st_belowupstrbarriers_slopeclass15_km,
    a.st_belowupstrbarriers_slopeclass22_km,
    a.st_belowupstrbarriers_slopeclass30_km,
    array_to_string(a.barriers_wct_dnstr, ';'::text) AS barriers_wct_dnstr,
    a.wct_network_km,
    a.wct_stream_km,
    a.wct_lakereservoir_ha,
    a.wct_wetland_ha,
    a.wct_slopeclass03_waterbodies_km,
    a.wct_slopeclass03_km,
    a.wct_slopeclass05_km,
    a.wct_slopeclass08_km,
    a.wct_slopeclass15_km,
    a.wct_slopeclass22_km,
    a.wct_slopeclass30_km,
    a.wct_belowupstrbarriers_network_km,
    a.wct_belowupstrbarriers_stream_km,
    a.wct_belowupstrbarriers_lakereservoir_ha,
    a.wct_belowupstrbarriers_wetland_ha,
    a.wct_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.wct_belowupstrbarriers_slopeclass03_km,
    a.wct_belowupstrbarriers_slopeclass05_km,
    a.wct_belowupstrbarriers_slopeclass08_km,
    a.wct_belowupstrbarriers_slopeclass15_km,
    a.wct_belowupstrbarriers_slopeclass22_km,
    a.wct_belowupstrbarriers_slopeclass30_km,
    h.bt_spawning_km,
    h.bt_rearing_km,
    h.bt_spawningrearing_km,
    h.bt_spawning_belowupstrbarriers_km,
    h.bt_rearing_belowupstrbarriers_km,
    h.bt_spawningrearing_belowupstrbarriers_km,
    h.ch_spawning_km,
    h.ch_rearing_km,
    h.ch_spawningrearing_km,
    h.ch_spawning_belowupstrbarriers_km,
    h.ch_rearing_belowupstrbarriers_km,
    h.ch_spawningrearing_belowupstrbarriers_km,
    h.cm_spawning_km,
    h.cm_spawning_belowupstrbarriers_km,
    h.co_spawning_km,
    h.co_rearing_km,
    h.co_rearing_ha,
    h.co_spawningrearing_km,
    h.co_spawning_belowupstrbarriers_km,
    h.co_rearing_belowupstrbarriers_km,
    h.co_rearing_belowupstrbarriers_ha,
    h.co_spawningrearing_belowupstrbarriers_km,
    h.pk_spawning_km,
    h.pk_spawning_belowupstrbarriers_km,
    h.sk_spawning_km,
    h.sk_rearing_km,
    h.sk_rearing_ha,
    h.sk_spawningrearing_km,
    h.sk_spawning_belowupstrbarriers_km,
    h.sk_rearing_belowupstrbarriers_km,
    h.sk_rearing_belowupstrbarriers_ha,
    h.sk_spawningrearing_belowupstrbarriers_km,
    h.st_spawning_km,
    h.st_rearing_km,
    h.st_spawningrearing_km,
    h.st_spawning_belowupstrbarriers_km,
    h.st_rearing_belowupstrbarriers_km,
    h.st_spawningrearing_belowupstrbarriers_km,
    h.salmon_spawningrearing_km,
    h.salmon_spawningrearing_belowupstrbarriers_km,
    h.salmonsteelhead_spawningrearing_km,
    h.salmonsteelhead_spawningrearing_belowupstrbarriers_km,
    h.wct_spawning_km,
    h.wct_rearing_km,
    h.wct_spawningrearing_km,
    h.wct_spawning_belowupstrbarriers_km,
    h.wct_rearing_belowupstrbarriers_km,
    h.wct_spawningrearing_belowupstrbarriers_km,
    c.geom
   FROM ((((((((((bcfishpass.crossings c
     LEFT JOIN bcfishpass.crossings_dnstr_observations cdo ON ((c.aggregated_crossings_id = cdo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_observations cuo ON ((c.aggregated_crossings_id = cuo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_crossings cd ON ((c.aggregated_crossings_id = cd.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_barriers_anthropogenic ad ON ((c.aggregated_crossings_id = ad.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_barriers_anthropogenic au ON ((c.aggregated_crossings_id = au.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_barriers_per_model aum ON ((c.aggregated_crossings_id = aum.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_access a ON ((c.aggregated_crossings_id = a.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_habitat h ON ((c.aggregated_crossings_id = h.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.streams s ON ((c.linear_feature_id = s.linear_feature_id)))
     LEFT JOIN whse_basemapping.dbm_mof_50k_grid t ON (public.st_intersects(c.geom, t.geom)))
  ORDER BY c.aggregated_crossings_id, s.downstream_route_measure
  WITH NO DATA;


--
-- Name: COLUMN crossings_vw.aggregated_crossings_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.aggregated_crossings_id IS 'unique identifier for crossing, generated from stream_crossing_id, modelled_crossing_id + 1000000000, user_barrier_anthropogenic_id + 1200000000, cabd_id';


--
-- Name: COLUMN crossings_vw.stream_crossing_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_crossing_id IS 'PSCIS stream crossing unique identifier';


--
-- Name: COLUMN crossings_vw.dam_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_id IS 'BC Dams unique identifier';


--
-- Name: COLUMN crossings_vw.user_crossing_misc_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.user_crossing_misc_id IS 'Misc user added crossings unique identifier';


--
-- Name: COLUMN crossings_vw.modelled_crossing_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.modelled_crossing_id IS 'Modelled crossing unique identifier';


--
-- Name: COLUMN crossings_vw.crossing_source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.crossing_source IS 'Data source for the crossing, one of: {PSCIS,MODELLED CROSSINGS,CABD,MISC BARRIERS}';


--
-- Name: COLUMN crossings_vw.pscis_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_status IS 'From PSCIS, the current_pscis_status of the crossing, one of: {ASSESSED,HABITAT CONFIRMATION,DESIGN,REMEDIATED}';


--
-- Name: COLUMN crossings_vw.crossing_type_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. Acceptable types are: OBS = Open Bottom Structure CBS = Closed Bottom Structure OTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN crossings_vw.crossing_subtype_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.crossing_subtype_code IS 'Further definition of the type of crossing, one of {BRIDGE,CRTBOX,DAM,FORD,OVAL,PIPEARCH,ROUND,WEIR,WOODBOX,NULL}';


--
-- Name: COLUMN crossings_vw.modelled_crossing_type_source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.modelled_crossing_type_source IS 'List of sources that indicate if a modelled crossing is open bottom, Acceptable values are: FWA_EDGE_TYPE=double line river, FWA_STREAM_ORDER=stream order >=6, GBA_RAILWAY_STRUCTURE_LINES_SP=railway structure, "MANUAL FIX"=manually identified OBS, MOT_ROAD_STRUCTURE_SP=MoT structure, TRANSPORT_LINE_STRUCTURE_CODE=DRA structure}';


--
-- Name: COLUMN crossings_vw.barrier_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. Acceptable Values are: PASSABLE - Passable, POTENTIAL - Potential or partial barrier, BARRIER - Barrier, UNKNOWN - Other';


--
-- Name: COLUMN crossings_vw.pscis_road_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_road_name IS 'PSCIS road name, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.pscis_stream_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_stream_name IS 'PSCIS stream name, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.pscis_assessment_comment; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_assessment_comment IS 'PSCIS assessment_comment, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.pscis_assessment_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_assessment_date IS 'PSCIS assessment_date, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.pscis_final_score; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_final_score IS 'PSCIS final_score, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.transport_line_structured_name_1; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.transport_line_structured_name_1 IS 'DRA road name, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings_vw.transport_line_type_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.transport_line_type_description IS 'DRA road type, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings_vw.transport_line_surface_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.transport_line_surface_description IS 'DRA road surface, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_forest_file_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_forest_file_id IS 'FTEN road forest_file_id value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_road_section_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_road_section_id IS 'FTEN road road_section_id value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_file_type_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_file_type_description IS 'FTEN road tenure type (Forest Service Road, Road Permit, etc), taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_client_number; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_client_number IS 'FTEN road client number, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_client_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_client_name IS 'FTEN road client name, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_life_cycle_status_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_life_cycle_status_code IS 'FTEN road life_cycle_status_code (active or retired, pending roads are not included), taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_map_label; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_map_label IS 'FTEN road map_label value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.rail_track_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.rail_track_name IS 'Railway name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings_vw.rail_owner_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.rail_owner_name IS 'Railway owner name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings_vw.rail_operator_english_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.rail_operator_english_name IS 'Railway operator name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings_vw.ogc_proponent; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ogc_proponent IS 'OGC road tenure proponent (currently modelled crossings only, taken from OGC road that crosses the stream)';


--
-- Name: COLUMN crossings_vw.dam_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_name IS 'See CABD dams column: dam_name_en';


--
-- Name: COLUMN crossings_vw.dam_height; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_height IS 'See CABD dams column: dam_height';


--
-- Name: COLUMN crossings_vw.dam_owner; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_owner IS 'See CABD dams column: owner';


--
-- Name: COLUMN crossings_vw.dam_use; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_use IS 'See CABD table dam_use_codes';


--
-- Name: COLUMN crossings_vw.dam_operating_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_operating_status IS 'See CABD dams column dam_operating_status';


--
-- Name: COLUMN crossings_vw.utm_zone; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.utm_zone IS 'UTM ZONE is a segment of the Earths surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';


--
-- Name: COLUMN crossings_vw.utm_easting; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';


--
-- Name: COLUMN crossings_vw.utm_northing; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';


--
-- Name: COLUMN crossings_vw.linear_feature_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.linear_feature_id IS 'From BC FWA, the unique identifier for a stream segment (flow network arc)';


--
-- Name: COLUMN crossings_vw.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.blue_line_key IS 'From BC FWA, uniquely identifies a single flow line such that a main channel and a secondary channel with the same watershed code would have different blue line keys (the Fraser River and all side channels have different blue line keys).';


--
-- Name: COLUMN crossings_vw.watershed_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.watershed_key IS 'From BC FWA, a key that identifies a stream system. There is a 1:1 match between a watershed key and watershed code. The watershed key will match the blue line key for the mainstem.';


--
-- Name: COLUMN crossings_vw.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';


--
-- Name: COLUMN crossings_vw.wscode; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wscode IS 'A truncated version of the BC FWA fwa_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';


--
-- Name: COLUMN crossings_vw.localcode; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.localcode IS 'A truncated version of the BC FWA local_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';


--
-- Name: COLUMN crossings_vw.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.watershed_group_code IS 'The watershed group code associated with the feature.';


--
-- Name: COLUMN crossings_vw.gnis_stream_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.gnis_stream_name IS 'The BCGNIS (BC Geographical Names Information System) name associated with the FWA stream';


--
-- Name: COLUMN crossings_vw.stream_order; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_order IS 'Order of FWA stream at point';


--
-- Name: COLUMN crossings_vw.stream_magnitude; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_magnitude IS 'Magnitude of FWA stream at point';


--
-- Name: COLUMN crossings_vw.upstream_area_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.upstream_area_ha IS 'Cumulative area upstream of the end of the stream (as defined by linear_feature_id)';


--
-- Name: COLUMN crossings_vw.stream_order_parent; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_order_parent IS 'Stream order of the stream into which the stream drains';


--
-- Name: COLUMN crossings_vw.stream_order_max; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_order_max IS 'Maximum stream order associated with the stream (as defined by blue_line_key)';


--
-- Name: COLUMN crossings_vw.map_upstream; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.map_upstream IS 'Mean annual precipitation for the watershed upstream of the stream segment (as defined by linear_feature_id)';


--
-- Name: COLUMN crossings_vw.channel_width; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.channel_width IS 'Modelled channel width of the stream (m)';


--
-- Name: COLUMN crossings_vw.mad_m3s; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.mad_m3s IS 'Modelled mean annual discharge of the stream (m3/s)';


--
-- Name: COLUMN crossings_vw.observedspp_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.observedspp_dnstr IS 'Species codes of downstream fish observations';


--
-- Name: COLUMN crossings_vw.observedspp_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.observedspp_upstr IS 'Species codes of upstream fish observations';


--
-- Name: COLUMN crossings_vw.crossings_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.crossings_dnstr IS 'aggregated_crossings_id value for all downstream crossings';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_dnstr IS 'aggregated_crossings_id value for all downstream anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_dnstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_dnstr_count IS 'Count of anthropogenic downstream barriers';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_upstr IS 'aggregated_crossings_id value for all upstream anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_upstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_upstr_count IS 'Count of all upstream anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_bt_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_bt_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Bull Trout';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_upstr_bt_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_upstr_bt_count IS 'Count of upstream anthropogenic barriers on streams accessible to Bull Trout';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Pacific Salmon';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Pacific Salmon';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_st_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_st_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Steelhead';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_st_upstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_st_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Steelhead';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_wct_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_wct_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to West Slope Cutthroat Trout';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_wct_upstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_wct_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Bull Trout';


--
-- Name: COLUMN crossings_vw.gradient; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.gradient IS 'Gradient of stream segment at crossing (defined by stream_segment_id)';


--
-- Name: COLUMN crossings_vw.total_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_network_km IS 'Total upstream length of FWA stream network (km)';


--
-- Name: COLUMN crossings_vw.total_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_stream_km IS 'Total upstream length of FWA streams (single and double line, km)';


--
-- Name: COLUMN crossings_vw.total_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs (ha)';


--
-- Name: COLUMN crossings_vw.total_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_wetland_ha IS 'Total upstream area of wetlands (ha)';


--
-- Name: COLUMN crossings_vw.total_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass03_km IS 'Total upstream length of stream < 3% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass05_km IS 'Total upstream length of stream < 5% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass08_km IS 'Total upstream length of stream < 8% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass15_km IS 'Total upstream length of stream < 15% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass22_km IS 'Total upstream length of stream < 22% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass30_km IS 'Total upstream length of stream < 30% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.barriers_bt_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_bt_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Bull Trout';


--
-- Name: COLUMN crossings_vw.bt_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_network_km IS 'Total upstream length of FWA stream network accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_stream_km IS 'Total upstream length of FWA streams accessible to Bull Trout (single and double line, km)';


--
-- Name: COLUMN crossings_vw.bt_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Bull Trout (ha)';


--
-- Name: COLUMN crossings_vw.bt_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_wetland_ha IS 'Total upstream area of wetlands accessible to Bull Trout (ha)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Bull Trout, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Bull Trout, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Bull Trout, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.barriers_ch_cm_co_pk_sk_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_ch_cm_co_pk_sk_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Pacific Salmon';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_network_km IS 'Total upstream length of FWA stream network accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_stream_km IS 'Total upstream length of FWA streams accessible to Pacific Salmon (single and double line, km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Pacific Salmon (ha)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_wetland_ha IS 'Total upstream area of wetlands accessible to Pacific Salmon (ha)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Pacific Salmon, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Pacific Salmon, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Pacific Salmon, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.barriers_st_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_st_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Steelhead';


--
-- Name: COLUMN crossings_vw.st_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_network_km IS 'Total upstream length of FWA stream network accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_stream_km IS 'Total upstream length of FWA streams accessible to Steelhead (single and double line, km)';


--
-- Name: COLUMN crossings_vw.st_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Steelhead (ha)';


--
-- Name: COLUMN crossings_vw.st_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_wetland_ha IS 'Total upstream area of wetlands accessible to Steelhead (ha)';


--
-- Name: COLUMN crossings_vw.st_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Steelhead, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Steelhead, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Steelhead, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.barriers_wct_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_wct_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to West Slope Cutthroat Trout';


--
-- Name: COLUMN crossings_vw.wct_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_network_km IS 'Total upstream length of FWA stream network accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_stream_km IS 'Total upstream length of FWA streams accessible to West Slope Cutthroat Trout (single and double line, km)';


--
-- Name: COLUMN crossings_vw.wct_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to West Slope Cutthroat Trout (ha)';


--
-- Name: COLUMN crossings_vw.wct_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_wetland_ha IS 'Total upstream area of wetlands accessible to West Slope Cutthroat Trout (ha)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_spawning_km IS 'Upstream length of modelled/observed Bull Trout spawning';


--
-- Name: COLUMN crossings_vw.bt_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_rearing_km IS 'Upstream length of modelled/observed Bull Trout rearing';


--
-- Name: COLUMN crossings_vw.bt_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_spawningrearing_km IS 'Upstream length of modelled/observed Bull Trout spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.bt_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Bull Trout spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.bt_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Bull Trout rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.ch_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_spawning_km IS 'Upstream length of modelled/observed Chinook spawning';


--
-- Name: COLUMN crossings_vw.ch_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_rearing_km IS 'Upstream length of modelled/observed Chinook rearing';


--
-- Name: COLUMN crossings_vw.ch_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_spawningrearing_km IS 'Upstream length of modelled/observed Chinook spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.ch_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.ch_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.ch_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.cm_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.cm_spawning_km IS 'Upstream length of modelled/observed Chum spawning';


--
-- Name: COLUMN crossings_vw.cm_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.cm_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chum spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.co_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_spawning_km IS 'Upstream length of modelled/observed Coho spawning';


--
-- Name: COLUMN crossings_vw.co_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_rearing_km IS 'Upstream length of modelled/observed Coho rearing';


--
-- Name: COLUMN crossings_vw.co_rearing_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_rearing_ha IS 'Upstream area (wetlands) of modelled/observed Coho rearing';


--
-- Name: COLUMN crossings_vw.co_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_spawningrearing_km IS 'Upstream length of modelled/observed Coho spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.co_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.co_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.co_rearing_belowupstrbarriers_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_rearing_belowupstrbarriers_ha IS 'Upstream area (wetlands) of modelled/observed Coho rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.co_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.pk_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pk_spawning_km IS 'Upstream length of modelled/observed Pink spawning';


--
-- Name: COLUMN crossings_vw.pk_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pk_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Pink spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.sk_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_spawning_km IS 'Upstream length of modelled/observed Sockeye spawning';


--
-- Name: COLUMN crossings_vw.sk_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_rearing_km IS 'Upstream length of modelled/observed Sockeye rearing';


--
-- Name: COLUMN crossings_vw.sk_rearing_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_rearing_ha IS 'Upstream area (lakes) of modelled/observed Sockeye rearing';


--
-- Name: COLUMN crossings_vw.sk_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_spawningrearing_km IS 'Upstream length of modelled/observed Sockeye spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.sk_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Sockeye spawning';


--
-- Name: COLUMN crossings_vw.sk_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Sockeye rearing';


--
-- Name: COLUMN crossings_vw.sk_rearing_belowupstrbarriers_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_rearing_belowupstrbarriers_ha IS 'Upstream area (lakes) of modelled/observed Sockeye rearing';


--
-- Name: COLUMN crossings_vw.st_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_spawning_km IS 'Upstream length of modelled/observed Steelhead spawning';


--
-- Name: COLUMN crossings_vw.st_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_rearing_km IS 'Upstream length of modelled/observed Steelhead rearing';


--
-- Name: COLUMN crossings_vw.st_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_spawningrearing_km IS 'Upstream length of modelled/observed Steelhead spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.st_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.st_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.st_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.salmon_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.salmon_spawningrearing_km IS 'Upstream length of modelled/observed Salmon spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.salmon_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.salmon_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Salmon spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.salmonsteelhead_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.salmonsteelhead_spawningrearing_km IS 'Upstream length of modelled/observed Salmon and/or Steelhead spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.salmonsteelhead_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.salmonsteelhead_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Salmon and/or Steelhead spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.wct_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_spawning_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning';


--
-- Name: COLUMN crossings_vw.wct_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_rearing_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout rearing';


--
-- Name: COLUMN crossings_vw.wct_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_spawningrearing_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.wct_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.wct_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.wct_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.geom; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.geom IS 'The point geometry associated with the feature';


--
-- Name: wcrp_ranked_barriers; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_ranked_barriers (
    aggregated_crossings_id text NOT NULL,
    set_id numeric,
    total_hab_gain_set numeric,
    num_barriers_set integer,
    avg_gain_per_barrier numeric,
    dnstr_set_ids character varying[],
    rank_avg_gain_per_barrier numeric,
    rank_avg_gain_tiered numeric,
    rank_total_upstr_hab numeric,
    rank_combined numeric,
    tier_combined character varying
);


--
-- Name: wcrp_watersheds; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_watersheds (
    watershed_group_code character varying(4),
    ch boolean,
    cm boolean,
    co boolean,
    pk boolean,
    sk boolean,
    st boolean,
    wct boolean,
    notes text,
    wcrp character varying(32),
    bt boolean
);


--
-- Name: crossings_wcrp_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.crossings_wcrp_vw AS
 WITH upstr_wcrp_barriers AS MATERIALIZED (
         SELECT DISTINCT ba.aggregated_crossings_id,
            h_1.aggregated_crossings_id AS upstr_barriers,
            h_1.all_spawningrearing_km
           FROM (bcfishpass.crossings_upstr_barriers_anthropogenic ba
             JOIN bcfishpass.crossings_upstream_habitat_wcrp h_1 ON ((h_1.aggregated_crossings_id = ANY (ba.features_upstr))))
          WHERE (h_1.all_spawningrearing_km > (0)::double precision)
          ORDER BY ba.aggregated_crossings_id, h_1.aggregated_crossings_id
        ), upstr_wcrp_barriers_list AS (
         SELECT upstr_wcrp_barriers.aggregated_crossings_id,
            array_to_string(array_agg(upstr_wcrp_barriers.upstr_barriers), ';'::text) AS barriers_anthropogenic_habitat_wcrp_upstr,
            COALESCE(array_length(array_agg(upstr_wcrp_barriers.upstr_barriers), 1), 0) AS barriers_anthropogenic_habitat_wcrp_upstr_count
           FROM upstr_wcrp_barriers
          GROUP BY upstr_wcrp_barriers.aggregated_crossings_id
          ORDER BY upstr_wcrp_barriers.aggregated_crossings_id
        )
 SELECT DISTINCT ON (c.aggregated_crossings_id) c.aggregated_crossings_id,
    c.modelled_crossing_id,
    c.crossing_source,
    c.crossing_feature_type,
    c.pscis_status,
    c.crossing_type_code,
    c.crossing_subtype_code,
    c.barrier_status,
    c.pscis_road_name,
    c.pscis_stream_name,
    c.pscis_assessment_comment,
    c.pscis_assessment_date,
    c.transport_line_structured_name_1,
    c.rail_track_name,
    c.dam_name,
    c.dam_height,
    c.dam_owner,
    c.dam_use,
    c.dam_operating_status,
    c.utm_zone,
    c.utm_easting,
    c.utm_northing,
    c.blue_line_key,
    c.downstream_route_measure,
    c.wscode_ltree AS wscode,
    c.localcode_ltree AS localcode,
    c.watershed_group_code,
    c.gnis_stream_name,
    array_to_string(ad.features_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    COALESCE(array_length(ad.features_dnstr, 1), 0) AS barriers_anthropogenic_dnstr_count,
    uwbl.barriers_anthropogenic_habitat_wcrp_upstr,
    uwbl.barriers_anthropogenic_habitat_wcrp_upstr_count,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    array_to_string(a.barriers_wct_dnstr, ';'::text) AS barriers_wct_dnstr,
    h.ch_spawning_km,
    h.ch_rearing_km,
    h.ch_spawningrearing_km,
    h.ch_spawning_belowupstrbarriers_km,
    h.ch_rearing_belowupstrbarriers_km,
    h.ch_spawningrearing_belowupstrbarriers_km,
    h.cm_spawning_km,
    h.cm_spawning_belowupstrbarriers_km,
    h.co_spawning_km,
    h_wcrp.co_rearing_km,
    h_wcrp.co_spawningrearing_km,
    h.co_rearing_ha,
    h.co_spawning_belowupstrbarriers_km,
    h_wcrp.co_rearing_belowupstrbarriers_km,
    h_wcrp.co_spawningrearing_belowupstrbarriers_km,
    h.co_rearing_belowupstrbarriers_ha,
    h.pk_spawning_km,
    h.pk_spawning_belowupstrbarriers_km,
    h.sk_spawning_km,
    h_wcrp.sk_rearing_km,
    h_wcrp.sk_spawningrearing_km,
    h.sk_rearing_ha,
    h.sk_spawning_belowupstrbarriers_km,
    h_wcrp.sk_rearing_belowupstrbarriers_km,
    h_wcrp.sk_spawningrearing_belowupstrbarriers_km,
    h.sk_rearing_belowupstrbarriers_ha,
    h.st_spawning_km,
    h.st_rearing_km,
    h.st_spawningrearing_km,
    h.st_spawning_belowupstrbarriers_km,
    h.st_rearing_belowupstrbarriers_km,
    h.st_spawningrearing_belowupstrbarriers_km,
    h.wct_spawning_km,
    h.wct_rearing_km,
    h.wct_spawningrearing_km,
    h.wct_spawning_belowupstrbarriers_km,
    h.wct_rearing_belowupstrbarriers_km,
    h.wct_spawningrearing_belowupstrbarriers_km,
    h_wcrp.all_spawning_km,
    h_wcrp.all_spawning_belowupstrbarriers_km,
    h_wcrp.all_rearing_km,
    h_wcrp.all_rearing_belowupstrbarriers_km,
    h_wcrp.all_spawningrearing_km,
    h_wcrp.all_spawningrearing_belowupstrbarriers_km,
    r.set_id,
    r.total_hab_gain_set,
    r.num_barriers_set,
    r.avg_gain_per_barrier,
    r.dnstr_set_ids,
    r.rank_avg_gain_per_barrier,
    r.rank_avg_gain_tiered,
    r.rank_total_upstr_hab,
    r.rank_combined,
    r.tier_combined,
    c.geom
   FROM (((((((((((((bcfishpass.crossings c
     JOIN bcfishpass.wcrp_watersheds w ON ((c.watershed_group_code = (w.watershed_group_code)::text)))
     LEFT JOIN bcfishpass.crossings_dnstr_observations cdo ON ((c.aggregated_crossings_id = cdo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_observations cuo ON ((c.aggregated_crossings_id = cuo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_crossings cd ON ((c.aggregated_crossings_id = cd.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_barriers_anthropogenic ad ON ((c.aggregated_crossings_id = ad.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_barriers_anthropogenic au ON ((c.aggregated_crossings_id = au.aggregated_crossings_id)))
     LEFT JOIN upstr_wcrp_barriers_list uwbl ON ((c.aggregated_crossings_id = uwbl.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_access a ON ((c.aggregated_crossings_id = a.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_habitat h ON ((c.aggregated_crossings_id = h.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_habitat_wcrp h_wcrp ON ((c.aggregated_crossings_id = h_wcrp.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.streams s ON ((c.linear_feature_id = s.linear_feature_id)))
     LEFT JOIN whse_basemapping.dbm_mof_50k_grid t ON (public.st_intersects(c.geom, t.geom)))
     LEFT JOIN bcfishpass.wcrp_ranked_barriers r ON ((c.aggregated_crossings_id = r.aggregated_crossings_id)))
  WHERE (COALESCE(c.stream_crossing_id, 0) <> ALL (ARRAY[199427, 197789, 197838, 197861, 197805, 125961, 199428, 197891, 203633, 198883]))
  ORDER BY c.aggregated_crossings_id, s.downstream_route_measure
  WITH NO DATA;


--
-- Name: dams; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.dams (
    dam_id text NOT NULL,
    linear_feature_id bigint,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    distance_to_stream double precision,
    watershed_group_code character varying(4),
    dam_name_en text,
    height_m double precision,
    owner text,
    dam_use text,
    operating_status text,
    passability_status_code integer,
    geom public.geometry(Point,3005)
);


--
-- Name: dams; Type: TABLE; Schema: cabd; Owner: -
--

CREATE TABLE cabd.dams (
    cabd_id text,
    use_pollution_code integer,
    maintenance_last date,
    use_fish text,
    height_m double precision,
    use_irrigation text,
    catchment_area_skm double precision,
    facility_name_en text,
    use_invasivespecies_code text,
    use_electricity text,
    waterbody_name_fr text,
    last_modified date,
    use_pollution text,
    updates_pending boolean,
    assess_schedule text,
    dam_name_fr text,
    facility_name_fr text,
    waterbody_name_en text,
    generating_capacity_mwh double precision,
    use_floodcontrol_code integer,
    upstream_linear_km text,
    reservoir_present boolean,
    use_other_code integer,
    length_m double precision,
    lake_control text,
    condition_code integer,
    reservoir_name_fr text,
    removed_year text,
    passability_status_code integer,
    passability_status_note text,
    latitude double precision,
    federal_flow_req text,
    size_class text,
    dam_name_en text,
    use_electricity_code integer,
    turbine_type text,
    reservoir_depth_m double precision,
    province_territory_code text,
    up_passage_type text,
    passability_status text,
    use_irrigation_code integer,
    down_passage_route text,
    url text,
    complete_level_code integer,
    construction_year integer,
    spillway_capacity text,
    reservoir_name_en text,
    construction_material_code integer,
    ownership_type text,
    municipality text,
    turbine_number text,
    up_passage_type_code integer,
    operating_status_code integer,
    function_code integer,
    use_floodcontrol text,
    spillway_type_code integer,
    hydro_peaking_system boolean,
    expected_end_of_life text,
    longitude double precision,
    complete_level text,
    provincial_compliance_status text,
    use_fish_code integer,
    spillway_type text,
    use_recreation text,
    use_recreation_code integer,
    use_analysis boolean,
    structure_type_code integer,
    avg_rate_of_discharge_ls double precision,
    nhn_watershed_name text,
    use_code integer,
    lake_control_code integer,
    structure_type text,
    use_navigation_code integer,
    federal_compliance_status text,
    use_supply_code integer,
    size_class_code integer,
    use_supply text,
    provincial_flow_req text,
    maintenance_next text,
    operating_status text,
    turbine_type_code integer,
    use_invasivespecies text,
    nhn_watershed_id text,
    use_conservation text,
    degree_of_regulation_pc double precision,
    owner text,
    construction_material text,
    comments text,
    dam_condition text,
    down_passage_route_code text,
    ownership_type_code integer,
    use_other text,
    reservoir_area_skm double precision,
    feature_type text,
    function_name text,
    operating_notes text,
    storage_capacity_mcm double precision,
    province_territory text,
    dam_use text,
    use_conservation_code text,
    use_navigation text,
    datasource_url text,
    geom public.geometry(Point,4326)
);


--
-- Name: dams_not_matched_to_streams; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.dams_not_matched_to_streams AS
 SELECT a.cabd_id,
    a.dam_name_en
   FROM (cabd.dams a
     LEFT JOIN bcfishpass.dams b ON ((a.cabd_id = b.dam_id)))
  WHERE (b.dam_id IS NULL)
  ORDER BY a.cabd_id;


--
-- Name: dams_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.dams_vw AS
 SELECT dam_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    dam_name_en,
    height_m,
    owner,
    dam_use,
    operating_status,
    passability_status_code,
    geom
   FROM bcfishpass.dams;


--
-- Name: db_version; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.db_version (
    tag text NOT NULL,
    applied_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: dfo_known_sockeye_lakes; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.dfo_known_sockeye_lakes (
    waterbody_poly_id integer NOT NULL
);


--
-- Name: falls; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.falls (
    falls_id text NOT NULL,
    linear_feature_id bigint,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    distance_to_stream double precision,
    watershed_group_code character varying(4),
    falls_name text,
    height_m double precision,
    barrier_ind boolean,
    geom public.geometry(Point,3005)
);


--
-- Name: waterfalls; Type: TABLE; Schema: cabd; Owner: -
--

CREATE TABLE cabd.waterfalls (
    cabd_id text,
    fall_name_fr text,
    fall_height_m double precision,
    complete_level text,
    passability_status_code integer,
    comments text,
    updates_pending boolean,
    fall_name_en text,
    latitude double precision,
    passability_status text,
    municipality text,
    url text,
    use_analysis boolean,
    feature_type text,
    complete_level_code integer,
    waterbody_name_en text,
    province_territory text,
    province_territory_code text,
    waterbody_name_fr text,
    last_modified date,
    nhn_watershed_name text,
    nhn_watershed_id text,
    longitude double precision,
    datasource_url text,
    geom public.geometry(Point,4326)
);


--
-- Name: falls_not_matched_to_streams; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.falls_not_matched_to_streams AS
 SELECT a.cabd_id,
    a.fall_name_en
   FROM (cabd.waterfalls a
     LEFT JOIN bcfishpass.falls b ON ((a.cabd_id = b.falls_id)))
  WHERE (b.falls_id IS NULL)
  ORDER BY a.cabd_id;


--
-- Name: falls_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.falls_vw AS
 SELECT falls_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    falls_name,
    height_m,
    barrier_ind,
    geom
   FROM bcfishpass.falls;


--
-- Name: fptwg_summary_roads_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.fptwg_summary_roads_vw AS
 WITH roads AS (
         SELECT w.watershed_feature_id,
                CASE
                    WHEN ((c.description)::text = ANY ((ARRAY['Road alleyway'::character varying, 'Road arterial major'::character varying, 'Road arterial minor'::character varying, 'Road collector major'::character varying, 'Road collector minor'::character varying, 'Road freeway'::character varying, 'Road highway major'::character varying, 'Road highway minor'::character varying, 'Road lane'::character varying, 'Road local'::character varying, 'Private driveway demographic'::character varying, 'Road pedestrian mall'::character varying, 'Road runway non-demographic'::character varying, 'Road recreation demographic'::character varying, 'Road ramp'::character varying, 'Road restricted'::character varying, 'Road strata'::character varying, 'Road service'::character varying, 'Road yield lane'::character varying])::text[])) THEN 'ROAD, DEMOGRAPHIC'::text
                    WHEN (upper((c.description)::text) ~~ 'TRAIL%'::text) THEN 'TRAIL'::text
                    WHEN (c.description IS NOT NULL) THEN 'ROAD, RESOURCE/OTHER'::text
                    ELSE NULL::text
                END AS road_type,
                CASE
                    WHEN public.st_coveredby(r.geom, w.geom) THEN r.geom
                    ELSE public.st_intersection(r.geom, w.geom)
                END AS geom
           FROM ((whse_basemapping.fwa_assessment_watersheds_poly w
             JOIN whse_basemapping.transport_line r ON (public.st_intersects(w.geom, r.geom)))
             JOIN whse_basemapping.transport_line_type_code c ON (((r.transport_line_type_code)::text = (c.transport_line_type_code)::text)))
          WHERE (((r.transport_line_type_code)::text <> ALL ((ARRAY['F'::character varying, 'FP'::character varying, 'FR'::character varying, 'T'::character varying, 'TR'::character varying, 'TS'::character varying, 'RP'::character varying, 'RWA'::character varying])::text[])) AND ((r.transport_line_surface_code)::text <> 'D'::text) AND ((COALESCE(r.transport_line_structure_code, ''::character varying))::text <> 'T'::text))
        UNION ALL
         SELECT w.watershed_feature_id,
            'RAIL'::text AS road_type,
                CASE
                    WHEN public.st_coveredby(r.geom, w.geom) THEN r.geom
                    ELSE public.st_intersection(r.geom, w.geom)
                END AS geom
           FROM (whse_basemapping.fwa_assessment_watersheds_poly w
             JOIN whse_basemapping.gba_railway_tracks_sp r ON (public.st_intersects(w.geom, r.geom)))
          WHERE ((r.track_classification)::text <> ALL ((ARRAY['Ferry Route'::character varying, 'Yard'::character varying, 'Siding'::character varying])::text[]))
        )
 SELECT watershed_feature_id,
    sum(public.st_length(geom)) FILTER (WHERE (road_type = 'RAIL'::text)) AS length_rail,
    sum(public.st_length(geom)) FILTER (WHERE (road_type = 'ROAD, RESOURCE/OTHER'::text)) AS length_resourceroad,
    sum(public.st_length(geom)) FILTER (WHERE (road_type = 'ROAD, DEMOGRAPHIC'::text)) AS length_demographicroad,
    sum(public.st_length(geom)) FILTER (WHERE (road_type = 'TRAIL'::text)) AS length_trail
   FROM roads
  WHERE (public.st_dimension(geom) = 1)
  GROUP BY watershed_feature_id
  WITH NO DATA;


--
-- Name: streams_access; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_access (
    segmented_stream_id text NOT NULL,
    barriers_anthropogenic_dnstr text[],
    barriers_pscis_dnstr text[],
    barriers_dams_dnstr text[],
    barriers_dams_hydro_dnstr text[],
    barriers_bt_dnstr text[],
    barriers_ch_cm_co_pk_sk_dnstr text[],
    barriers_ct_dv_rb_dnstr text[],
    barriers_st_dnstr text[],
    barriers_wct_dnstr text[],
    access_bt integer,
    access_ch integer,
    access_cm integer,
    access_co integer,
    access_pk integer,
    access_sk integer,
    access_salmon integer,
    access_ct_dv_rb integer,
    access_st integer,
    access_wct integer,
    observation_key_upstr text[],
    obsrvtn_species_codes_upstr text[],
    species_codes_dnstr text[],
    crossings_dnstr text[],
    remediated_dnstr_ind boolean,
    dam_dnstr_ind boolean,
    dam_hydro_dnstr_ind boolean
);


--
-- Name: streams_habitat_linear; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_habitat_linear (
    segmented_stream_id text NOT NULL,
    spawning_bt integer,
    spawning_ch integer,
    spawning_cm integer,
    spawning_co integer,
    spawning_pk integer,
    spawning_sk integer,
    spawning_st integer,
    spawning_wct integer,
    rearing_bt integer,
    rearing_ch integer,
    rearing_co integer,
    rearing_sk integer,
    rearing_st integer,
    rearing_wct integer
);


--
-- Name: freshwater_fish_habitat_accessibility_model_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.freshwater_fish_habitat_accessibility_model_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.downstream_route_measure,
    s.upstream_route_measure,
    s.watershed_group_code,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.feature_code,
        CASE
            WHEN (a.access_salmon = 2) THEN 'OBSERVED'::text
            WHEN (a.access_salmon = 1) THEN 'INFERRED'::text
            WHEN (a.access_salmon = 0) THEN 'NATURAL_BARRIER'::text
            ELSE NULL::text
        END AS model_access_salmon,
        CASE
            WHEN (a.access_st = 2) THEN 'OBSERVED'::text
            WHEN (a.access_st = 1) THEN 'INFERRED'::text
            WHEN (a.access_st = 0) THEN 'NATURAL_BARRIER'::text
            ELSE NULL::text
        END AS model_access_steelhead,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    s.geom
   FROM ((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)));


--
-- Name: fwa_assessment_watersheds_waterbodies_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.fwa_assessment_watersheds_waterbodies_vw AS
 WITH lakes AS (
         SELECT w_1.watershed_feature_id,
            wb.waterbody_poly_id,
                CASE
                    WHEN public.st_coveredby(wb.geom, w_1.geom) THEN wb.geom
                    ELSE public.st_intersection(wb.geom, w_1.geom)
                END AS geom
           FROM (whse_basemapping.fwa_assessment_watersheds_poly w_1
             JOIN whse_basemapping.fwa_lakes_poly wb ON ((public.st_intersects(w_1.geom, wb.geom) AND ((w_1.watershed_group_code)::text = (wb.watershed_group_code)::text))))
        ), reservoirs AS (
         SELECT w_1.watershed_feature_id,
            wb.waterbody_poly_id,
                CASE
                    WHEN public.st_coveredby(wb.geom, w_1.geom) THEN wb.geom
                    ELSE public.st_intersection(wb.geom, w_1.geom)
                END AS geom
           FROM (whse_basemapping.fwa_assessment_watersheds_poly w_1
             JOIN whse_basemapping.fwa_manmade_waterbodies_poly wb ON ((public.st_intersects(w_1.geom, wb.geom) AND ((w_1.watershed_group_code)::text = (wb.watershed_group_code)::text))))
        ), wetlands AS (
         SELECT w_1.watershed_feature_id,
            wb.waterbody_poly_id,
                CASE
                    WHEN public.st_coveredby(wb.geom, w_1.geom) THEN wb.geom
                    ELSE public.st_intersection(wb.geom, w_1.geom)
                END AS geom
           FROM (whse_basemapping.fwa_assessment_watersheds_poly w_1
             JOIN whse_basemapping.fwa_manmade_waterbodies_poly wb ON ((public.st_intersects(w_1.geom, wb.geom) AND ((w_1.watershed_group_code)::text = (wb.watershed_group_code)::text))))
        )
 SELECT a.watershed_feature_id,
    count(DISTINCT l.waterbody_poly_id) AS n_lakes,
    round(((sum(public.st_area(l.geom)) / (10000)::double precision))::numeric, 2) AS area_lakes,
    count(DISTINCT m.waterbody_poly_id) AS n_manmade_waterbodies,
    round(((sum(public.st_area(m.geom)) / (10000)::double precision))::numeric, 2) AS area_manmade_waterbodies,
    count(DISTINCT w.waterbody_poly_id) AS n_wetlands,
    round(((sum(public.st_area(w.geom)) / (10000)::double precision))::numeric, 2) AS area_wetlands
   FROM (((whse_basemapping.fwa_assessment_watersheds_poly a
     LEFT JOIN lakes l ON ((a.watershed_feature_id = l.watershed_feature_id)))
     LEFT JOIN reservoirs m ON ((a.watershed_feature_id = m.watershed_feature_id)))
     LEFT JOIN wetlands w ON ((a.watershed_feature_id = w.watershed_feature_id)))
  GROUP BY a.watershed_feature_id
  ORDER BY a.watershed_feature_id
  WITH NO DATA;


--
-- Name: gradient_barriers; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.gradient_barriers (
    gradient_barrier_id bigint GENERATED ALWAYS AS (((((((blue_line_key)::bigint + 1) - 354087611) * 10000000))::double precision + round(((downstream_route_measure)::bigint)::double precision))) STORED NOT NULL,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    gradient_class integer
);


--
-- Name: habitat_linear_bt; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_bt (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_ch; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_ch (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_cm; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_cm (
    segmented_stream_id text NOT NULL,
    spawning boolean
);


--
-- Name: habitat_linear_co; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_co (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_pk; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_pk (
    segmented_stream_id text NOT NULL,
    spawning boolean
);


--
-- Name: habitat_linear_sk; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_sk (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_st; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_st (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_wct; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_wct (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: log_model_run_id_seq; Type: SEQUENCE; Schema: bcfishpass; Owner: -
--

CREATE SEQUENCE bcfishpass.log_model_run_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_model_run_id_seq; Type: SEQUENCE OWNED BY; Schema: bcfishpass; Owner: -
--

ALTER SEQUENCE bcfishpass.log_model_run_id_seq OWNED BY bcfishpass.log.model_run_id;


--
-- Name: log_objectstorage; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_objectstorage (
    model_run_id integer NOT NULL,
    object_name text NOT NULL,
    version_id text,
    etag text
);


--
-- Name: log_parameters_habitat_method; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_parameters_habitat_method (
    model_run_id integer,
    watershed_group_code character varying(4),
    model text
);


--
-- Name: log_parameters_habitat_thresholds; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_parameters_habitat_thresholds (
    model_run_id integer,
    species_code text,
    spawn_gradient_max numeric,
    spawn_channel_width_min numeric,
    spawn_channel_width_max numeric,
    spawn_mad_min numeric,
    spawn_mad_max numeric,
    rear_gradient_max numeric,
    rear_channel_width_min numeric,
    rear_channel_width_max numeric,
    rear_mad_min numeric,
    rear_mad_max numeric,
    rear_lake_ha_min integer
);


--
-- Name: log_replication; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_replication (
    object_name text NOT NULL,
    version_id text,
    etag text,
    replication_timestamp timestamp without time zone
);


--
-- Name: log_wsg_crossing_summary; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_wsg_crossing_summary (
    model_run_id integer,
    watershed_group_code text,
    crossing_feature_type text,
    n_crossings_total integer,
    n_passable_total integer,
    n_barriers_total integer,
    n_potential_total integer,
    n_unknown_total integer,
    n_barriers_accessible_bt integer,
    n_potential_accessible_bt integer,
    n_unknown_accessible_bt integer,
    n_barriers_accessible_ch_cm_co_pk_sk integer,
    n_potential_accessible_ch_cm_co_pk_sk integer,
    n_unknown_accessible_ch_cm_co_pk_sk integer,
    n_barriers_accessible_st integer,
    n_potential_accessible_st integer,
    n_unknown_accessible_st integer,
    n_barriers_accessible_wct integer,
    n_potential_accessible_wct integer,
    n_unknown_accessible_wct integer,
    n_barriers_habitat_bt integer,
    n_potential_habitat_bt integer,
    n_unknown_habitat_bt integer,
    n_barriers_habitat_ch integer,
    n_potential_habitat_ch integer,
    n_unknown_habitat_ch integer,
    n_barriers_habitat_cm integer,
    n_potential_habitat_cm integer,
    n_unknown_habitat_cm integer,
    n_barriers_habitat_co integer,
    n_potential_habitat_co integer,
    n_unknown_habitat_co integer,
    n_barriers_habitat_pk integer,
    n_potential_habitat_pk integer,
    n_unknown_habitat_pk integer,
    n_barriers_habitat_sk integer,
    n_potential_habitat_sk integer,
    n_unknown_habitat_sk integer,
    n_barriers_habitat_salmon integer,
    n_potential_habitat_salmon integer,
    n_unknown_habitat_salmon integer,
    n_barriers_habitat_st integer,
    n_potential_habitat_st integer,
    n_unknown_habitat_st integer,
    n_barriers_habitat_wct integer,
    n_potential_habitat_wct integer,
    n_unknown_habitat_wct integer
);


--
-- Name: log_wsg_linear_summary; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_wsg_linear_summary (
    model_run_id integer,
    watershed_group_code text,
    length_total numeric,
    length_potentiallyaccessible_bt numeric,
    length_potentiallyaccessible_bt_observed numeric,
    length_potentiallyaccessible_bt_accessible_a numeric,
    length_potentiallyaccessible_bt_accessible_b numeric,
    length_obsrvd_spawning_rearing_bt numeric,
    length_obsrvd_spawning_rearing_bt_accessible_a numeric,
    length_obsrvd_spawning_rearing_bt_accessible_b numeric,
    length_spawning_rearing_bt numeric,
    length_spawning_rearing_bt_accessible_a numeric,
    length_spawning_rearing_bt_accessible_b numeric,
    length_potentiallyaccessible_ch_cm_co_pk_sk numeric,
    length_potentiallyaccessible_ch_cm_co_pk_sk_observed numeric,
    length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a numeric,
    length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b numeric,
    length_obsrvd_spawning_rearing_ch numeric,
    length_obsrvd_spawning_rearing_ch_accessible_a numeric,
    length_obsrvd_spawning_rearing_ch_accessible_b numeric,
    length_spawning_rearing_ch numeric,
    length_spawning_rearing_ch_accessible_a numeric,
    length_spawning_rearing_ch_accessible_b numeric,
    length_obsrvd_spawning_rearing_cm numeric,
    length_obsrvd_spawning_rearing_cm_accessible_a numeric,
    length_obsrvd_spawning_rearing_cm_accessible_b numeric,
    length_spawning_rearing_cm numeric,
    length_spawning_rearing_cm_accessible_a numeric,
    length_spawning_rearing_cm_accessible_b numeric,
    length_obsrvd_spawning_rearing_co numeric,
    length_obsrvd_spawning_rearing_co_accessible_a numeric,
    length_obsrvd_spawning_rearing_co_accessible_b numeric,
    length_spawning_rearing_co numeric,
    length_spawning_rearing_co_accessible_a numeric,
    length_spawning_rearing_co_accessible_b numeric,
    length_obsrvd_spawning_rearing_pk numeric,
    length_obsrvd_spawning_rearing_pk_accessible_a numeric,
    length_obsrvd_spawning_rearing_pk_accessible_b numeric,
    length_spawning_rearing_pk numeric,
    length_spawning_rearing_pk_accessible_a numeric,
    length_spawning_rearing_pk_accessible_b numeric,
    length_obsrvd_spawning_rearing_sk numeric,
    length_obsrvd_spawning_rearing_sk_accessible_a numeric,
    length_obsrvd_spawning_rearing_sk_accessible_b numeric,
    length_spawning_rearing_sk numeric,
    length_spawning_rearing_sk_accessible_a numeric,
    length_spawning_rearing_sk_accessible_b numeric,
    length_potentiallyaccessible_st numeric,
    length_potentiallyaccessible_st_observed numeric,
    length_potentiallyaccessible_st_accessible_a numeric,
    length_potentiallyaccessible_st_accessible_b numeric,
    length_obsrvd_spawning_rearing_st numeric,
    length_obsrvd_spawning_rearing_st_accessible_a numeric,
    length_obsrvd_spawning_rearing_st_accessible_b numeric,
    length_spawning_rearing_st numeric,
    length_spawning_rearing_st_accessible_a numeric,
    length_spawning_rearing_st_accessible_b numeric,
    length_potentiallyaccessible_wct numeric,
    length_potentiallyaccessible_wct_observed numeric,
    length_potentiallyaccessible_wct_accessible_a numeric,
    length_potentiallyaccessible_wct_accessible_b numeric,
    length_obsrvd_spawning_rearing_wct numeric,
    length_obsrvd_spawning_rearing_wct_accessible_a numeric,
    length_obsrvd_spawning_rearing_wct_accessible_b numeric,
    length_spawning_rearing_wct numeric,
    length_spawning_rearing_wct_accessible_a numeric,
    length_spawning_rearing_wct_accessible_b numeric
);


--
-- Name: modelled_stream_crossings; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.modelled_stream_crossings (
    modelled_crossing_id integer NOT NULL,
    modelled_crossing_type character varying(5),
    modelled_crossing_type_source text[],
    transport_line_id integer,
    ften_road_section_lines_id integer,
    og_road_segment_permit_id integer,
    og_petrlm_dev_rd_pre06_pub_id integer,
    railway_track_id integer,
    linear_feature_id bigint,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(PointZM,3005)
);


--
-- Name: modelled_stream_crossings_modelled_crossing_id_seq; Type: SEQUENCE; Schema: bcfishpass; Owner: -
--

CREATE SEQUENCE bcfishpass.modelled_stream_crossings_modelled_crossing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modelled_stream_crossings_modelled_crossing_id_seq; Type: SEQUENCE OWNED BY; Schema: bcfishpass; Owner: -
--

ALTER SEQUENCE bcfishpass.modelled_stream_crossings_modelled_crossing_id_seq OWNED BY bcfishpass.modelled_stream_crossings.modelled_crossing_id;


--
-- Name: observation_exclusions; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.observation_exclusions (
    observation_key text NOT NULL,
    data_error boolean,
    release_exclude boolean,
    release_include boolean,
    reviewer_name text,
    review_date date,
    source_1 text,
    source_2 text,
    notes text
);


--
-- Name: TABLE observation_exclusions; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.observation_exclusions IS 'Flag FISS observation points as data error; temporary/one time release/stocking/enhancement; ongoing release/stocking/enhancement';


--
-- Name: COLUMN observation_exclusions.observation_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.observation_key IS 'bcfishobs created stable unique id, a hash of columns [source, species_code, observation_date, utm_zone, utm_easting, utm_northing, life_stage_code, activity_code]';


--
-- Name: COLUMN observation_exclusions.data_error; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.data_error IS 'True if record contains a confirmed/conclusive data error, exclude it from bcfishpass (most commonly, point is in the wrong location)';


--
-- Name: COLUMN observation_exclusions.release_exclude; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.release_exclude IS 'True if record is related to a limited/one time release/stocking/enhancement event, exclude from bcfishpass habitat modelling';


--
-- Name: COLUMN observation_exclusions.release_include; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.release_include IS 'True if record is related to an ongoing release/stocking/enhancement program, include in bcfishpass habitat modelling but exclude from QA of barriers';


--
-- Name: COLUMN observation_exclusions.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN observation_exclusions.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN observation_exclusions.source_1; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.source_1 IS 'Description or link to the primary source(s) documenting the observation or related information';


--
-- Name: COLUMN observation_exclusions.source_2; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.source_2 IS 'Description or link to the secondary source(s) documenting the observation or related information';


--
-- Name: COLUMN observation_exclusions.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.notes IS 'Reviewer notes on rationale for fix and/or how the source(s) were interpreted';


--
-- Name: observations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.observations (
    observation_key text NOT NULL,
    fish_observation_point_id numeric,
    wbody_id numeric,
    species_code character varying(6),
    agency_id numeric,
    point_type_code character varying(20),
    observation_date date,
    agency_name character varying(60),
    source character varying(1000),
    source_ref character varying(4000),
    utm_zone integer,
    utm_easting integer,
    utm_northing integer,
    activity_code character varying(100),
    activity character varying(300),
    life_stage_code character varying(100),
    life_stage character varying(300),
    species_name character varying(60),
    waterbody_identifier character varying(9),
    waterbody_type character varying(20),
    gazetted_name character varying(30),
    new_watershed_code character varying(56),
    trimmed_watershed_code character varying(56),
    acat_report_url character varying(254),
    feature_code character varying(10),
    linear_feature_id bigint,
    wscode public.ltree,
    localcode public.ltree,
    blue_line_key integer,
    watershed_group_code character varying(4),
    downstream_route_measure double precision,
    match_type text,
    distance_to_stream double precision,
    geom public.geometry(PointZ,3005),
    release boolean
);


--
-- Name: COLUMN observations.observation_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.observation_key IS 'Stable unique id, a hash of columns [source, species_code, observation_date, utm_zone, utm_easting, utm_northing, life_stage_code, activity_code]';


--
-- Name: COLUMN observations.fish_observation_point_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.fish_observation_point_id IS 'Source observation primary key (unstable)';


--
-- Name: COLUMN observations.wbody_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.wbody_id IS 'WBODY ID is a foreign key to WDIC_WATERBODIES.';


--
-- Name: COLUMN observations.species_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.species_code IS 'BC fish species code, see https://raw.githubusercontent.com/smnorris/fishbc/master/data-raw/whse_fish_species_cd/whse_fish_species_cd.csv';


--
-- Name: COLUMN observations.agency_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.agency_id IS 'AGENCY ID is a foreign key to AGENCIES.';


--
-- Name: COLUMN observations.point_type_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.point_type_code IS 'POINT TYPE CODE indicates if the row represents a direct Observation or a Summary of direct observations.';


--
-- Name: COLUMN observations.observation_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.observation_date IS 'The date on which the observation occurred.';


--
-- Name: COLUMN observations.agency_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.agency_name IS 'The name of the agency that made the observation.';


--
-- Name: COLUMN observations.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.source IS 'The abbreviation, and if appropriate, the primary key, of the dataset(s) from which the data was obtained. For example: FDIS Database: fshclctn_id 66589';


--
-- Name: COLUMN observations.source_ref; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.source_ref IS 'The concatenation of all biographical references for the source data.  This may include citations to reports that published the observations, or the name of a project under which the observations were made. Some example values for SOURCE REF are: A RECONNAISSANCE SURVEY OF CULTUS LAKE, and Bonaparte Watershed Fish and Fish Habitat Inventory - 2000';


--
-- Name: COLUMN observations.utm_zone; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.utm_zone IS 'UTM ZONE is the 2 digit numeric code identifying the UTM Zone in which the UTM EASTING and UTM NORTHING lie.';


--
-- Name: COLUMN observations.utm_easting; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.utm_easting IS 'UTM EASTING is the UTM Easting value within the specified UTM ZONE for this observation point.';


--
-- Name: COLUMN observations.utm_northing; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.utm_northing IS 'UTM NORTHING is the UTM Northing value within the specified UTM ZONE for this observation point.';


--
-- Name: COLUMN observations.activity_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.activity_code IS 'ACTIVITY CODE contains the fish activity code from the source dataset, such as I for Incubating, or SPE for Spawning In Estuary.';


--
-- Name: COLUMN observations.activity; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.activity IS 'ACTIVITY is a full textual description of the activity the fish was engaged in when it was observed, such as SPAWNING.';


--
-- Name: COLUMN observations.life_stage_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.life_stage_code IS 'LIFE STAGE CODE is a short character code identiying the life stage of the fish species for this oberservation.  Each source dataset of observations uses its own set of LIFE STAGE CODES.  For example, in the FDIS dataset, U means Undetermined, NS means Not Specified, M means Mature, IM means Immature, and MT means Maturing.  Descriptions for each LIFE STAGE CODE are given in the LIFE STAGE attribute.';


--
-- Name: COLUMN observations.life_stage; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.life_stage IS 'LIFE STAGE is the full textual description corresponding to the LIFE STAGE CODE';


--
-- Name: COLUMN observations.species_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.species_name IS 'SPECIES NAME is the common name of the fish SPECIES that was observed.';


--
-- Name: COLUMN observations.waterbody_identifier; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.waterbody_identifier IS 'WATERBODY IDENTIFIER is a unique code identifying the waterbody in which the observation was made. It is a 5-digit seqnce number followed by a 4-character watershed group code.';


--
-- Name: COLUMN observations.waterbody_type; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.waterbody_type IS 'WATERBODY TYPE is a the type of waterbody in which the observation was made. For example, Stream or Lake.';


--
-- Name: COLUMN observations.gazetted_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.gazetted_name IS 'GAZETTED NAME is the gazetted name of the waterbody in which the observation was made.';


--
-- Name: COLUMN observations.new_watershed_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.new_watershed_code IS 'NEW WATERSHED CODE is a watershed code, formatted with dashes, as assigned in the Watershed Atlas. For example: 900-569800-08600-00000-0000-0000-000-000-000-000-000-000.';


--
-- Name: COLUMN observations.trimmed_watershed_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.trimmed_watershed_code IS 'TRIMMED WATERSHED CODE is the NEW WATERSHED CODE, but with trailing zeros removed. For example, if the NEW WATERSHED CODE is 100-005200-43400-50000-0000-0000-000-000-000-000-000-000, then the TRIMMED WATERSHED CODE will be 100-005200-43400-50000.';


--
-- Name: COLUMN observations.acat_report_url; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.acat_report_url IS 'ACAT REPORT URL is a URL to the ACAT REPORT which provides additional information about the FISS FISH OBSRVTN PNT SP.';


--
-- Name: COLUMN observations.feature_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.feature_code IS 'FEATURE CODE contains a value based on the Canadian Council of Surveys and Mappings (CCSM) system for classification of geographic features.';


--
-- Name: COLUMN observations.linear_feature_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.linear_feature_id IS 'See FWA documentation';


--
-- Name: COLUMN observations.wscode; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.wscode IS 'Truncated FWA fwa_watershed_code';


--
-- Name: COLUMN observations.localcode; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.localcode IS 'Truncated FWA local_watershed_code';


--
-- Name: COLUMN observations.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.blue_line_key IS 'See FWA documentation';


--
-- Name: COLUMN observations.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.watershed_group_code IS 'See FWA documentation';


--
-- Name: COLUMN observations.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.downstream_route_measure IS 'See FWA documentation';


--
-- Name: COLUMN observations.match_type; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.match_type IS 'Description of how the observation was matched to the stream';


--
-- Name: COLUMN observations.distance_to_stream; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.distance_to_stream IS 'Distance (m) from source observation to output point';


--
-- Name: COLUMN observations.geom; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.geom IS 'Geometry of observation as snapped to the FWA stream network';


--
-- Name: observations_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.observations_vw AS
 SELECT observation_key,
    fish_observation_point_id,
    wbody_id,
    species_code,
    agency_id,
    point_type_code,
    observation_date,
    agency_name,
    source,
    source_ref,
    utm_zone,
    utm_easting,
    utm_northing,
    activity_code,
    activity,
    life_stage_code,
    life_stage,
    species_name,
    waterbody_identifier,
    waterbody_type,
    gazetted_name,
    new_watershed_code,
    trimmed_watershed_code,
    acat_report_url,
    feature_code,
    linear_feature_id,
    wscode,
    localcode,
    blue_line_key,
    watershed_group_code,
    downstream_route_measure,
    match_type,
    distance_to_stream,
    geom
   FROM bcfishpass.observations;


--
-- Name: parameters_habitat_method; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.parameters_habitat_method (
    watershed_group_code character varying(4),
    model text
);


--
-- Name: parameters_habitat_thresholds; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.parameters_habitat_thresholds (
    species_code text,
    spawn_gradient_max numeric,
    spawn_channel_width_min numeric,
    spawn_channel_width_max numeric,
    spawn_mad_min numeric,
    spawn_mad_max numeric,
    rear_gradient_max numeric,
    rear_channel_width_min numeric,
    rear_channel_width_max numeric,
    rear_mad_min numeric,
    rear_mad_max numeric,
    rear_lake_ha_min integer
);


--
-- Name: pscis; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis (
    stream_crossing_id integer NOT NULL,
    modelled_crossing_id integer,
    pscis_status text,
    current_crossing_type_code character varying(10),
    current_crossing_subtype_code character varying(10),
    current_barrier_result_code text,
    distance_to_stream double precision,
    suspect_match character varying(17),
    linear_feature_id bigint,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    blue_line_key integer,
    downstream_route_measure double precision,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: pscis_modelledcrossings_streams_xref; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_modelledcrossings_streams_xref (
    stream_crossing_id integer NOT NULL,
    modelled_crossing_id integer,
    linear_feature_id integer,
    watershed_group_code character varying(4),
    reviewer text,
    notes text
);


--
-- Name: pscis_not_matched_to_streams; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_not_matched_to_streams (
    stream_crossing_id integer NOT NULL,
    current_pscis_status text,
    current_barrier_result_code text,
    current_crossing_type_code text,
    current_crossing_subtype_code text,
    watershed_group_code text,
    geom public.geometry(Point)
);


--
-- Name: pscis_points_all; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_points_all (
    stream_crossing_id integer NOT NULL,
    current_pscis_status text,
    current_barrier_result_code text,
    current_crossing_type_code text,
    current_crossing_subtype_code text,
    geom public.geometry(Point,3005)
);


--
-- Name: pscis_points_duplicates; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_points_duplicates (
    stream_crossing_id integer,
    duplicate_10m boolean,
    duplicate_5m_instream boolean,
    watershed_group_code text
);


--
-- Name: pscis_streams_150m; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_streams_150m (
    id bigint,
    stream_crossing_id integer,
    modelled_crossing_id integer,
    linear_feature_id bigint,
    blue_line_key integer,
    downstream_route_measure double precision,
    watershed_group_code character varying(4),
    distance_to_stream double precision,
    gnis_name character varying(80),
    stream_name character varying(256),
    name_score integer,
    stream_order integer,
    downstream_channel_width numeric,
    width_order_score integer,
    crossing_type_code character varying(24),
    modelled_crossing_type character varying(5),
    modelled_xing_dist double precision,
    modelled_xing_dist_instream numeric,
    multiple_match_ind boolean
);


--
-- Name: qa_naturalbarriers_ch_cm_co_pk_sk_st; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk_st (
    barrier_id text NOT NULL,
    barrier_type text,
    watershed_group_code text,
    observations_upstr text,
    n_observations_upstr integer,
    n_ch_upstr integer,
    n_cm_upstr integer,
    n_co_upstr integer,
    n_pk_upstr integer,
    n_sk_upstr integer,
    n_st_upstr integer
);


--
-- Name: qa_observations_ch_cm_co_pk_sk_st; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.qa_observations_ch_cm_co_pk_sk_st (
    observation_key text NOT NULL,
    species_code character varying(6),
    observation_date date,
    activity_code character varying(100),
    activity character varying(300),
    life_stage_code character varying(100),
    life_stage character varying(300),
    acat_report_url character varying(254),
    agency_name character varying(60),
    source character varying(1000),
    source_ref character varying(4000),
    release boolean,
    watershed_group_code character varying(4),
    gradient_15_dnstr text,
    gradient_20_dnstr text,
    gradient_25_dnstr text,
    gradient_30_dnstr text,
    falls_dnstr text,
    subsurfaceflow_dnstr text,
    gradient_15_dnstr_count integer,
    gradient_20_dnstr_count integer,
    gradient_25_dnstr_count integer,
    gradient_30_dnstr_count integer,
    falls_dnstr_count integer,
    subsurfaceflow_dnstr_count integer
);


--
-- Name: streams_mapping_code; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_mapping_code (
    segmented_stream_id text NOT NULL,
    mapping_code_bt text,
    mapping_code_ch text,
    mapping_code_cm text,
    mapping_code_co text,
    mapping_code_pk text,
    mapping_code_sk text,
    mapping_code_st text,
    mapping_code_wct text,
    mapping_code_salmon text
);


--
-- Name: streams_bt_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_bt_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_bt_dnstr, ';'::text) AS barriers_bt_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_bt AS access,
        CASE
            WHEN (a.access_bt = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_bt
        END AS spawning,
        CASE
            WHEN (a.access_bt = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_bt
        END AS rearing,
    m.mapping_code_bt AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_bt > 0);


--
-- Name: streams_ch_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_ch_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_ch AS access,
        CASE
            WHEN (a.access_ch = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_ch
        END AS spawning,
        CASE
            WHEN (a.access_ch = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_ch
        END AS rearing,
    m.mapping_code_ch AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_ch > 0);


--
-- Name: streams_cm_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_cm_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_cm AS access,
        CASE
            WHEN (a.access_cm = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_cm
        END AS spawning,
    m.mapping_code_cm AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_cm > 0);


--
-- Name: streams_co_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_co_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_co AS access,
        CASE
            WHEN (a.access_co = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_co
        END AS spawning,
        CASE
            WHEN (a.access_co = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_co
        END AS rearing,
    m.mapping_code_co AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_co > 0);


--
-- Name: streams_ct_dv_rb_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_ct_dv_rb_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ct_dv_rb_dnstr, ';'::text) AS barriers_ct_dv_rb_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_ct_dv_rb AS access,
    NULL::text AS spawning,
    NULL::text AS rearing,
    NULL::text AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_ct_dv_rb > 0);


--
-- Name: streams_dnstr_barriers; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_dnstr_barriers (
    segmented_stream_id text NOT NULL,
    barriers_anthropogenic_dnstr text[],
    barriers_pscis_dnstr text[],
    barriers_dams_dnstr text[],
    barriers_dams_hydro_dnstr text[],
    barriers_bt_dnstr text[],
    barriers_ct_dv_rb_dnstr text[],
    barriers_ch_cm_co_pk_sk_dnstr text[],
    barriers_st_dnstr text[],
    barriers_wct_dnstr text[]
);


--
-- Name: streams_dnstr_barriers_remediations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_dnstr_barriers_remediations (
    segmented_stream_id text NOT NULL,
    remediations_barriers_dnstr text[]
);


--
-- Name: streams_dnstr_crossings; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_dnstr_crossings (
    segmented_stream_id text NOT NULL,
    crossings_dnstr text[]
);


--
-- Name: streams_dnstr_species; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_dnstr_species (
    segmented_stream_id text NOT NULL,
    species_codes_dnstr text[]
);


--
-- Name: streams_habitat_known; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_habitat_known (
    segmented_stream_id text NOT NULL,
    spawning_bt integer,
    spawning_ch integer,
    spawning_cm integer,
    spawning_co integer,
    spawning_pk integer,
    spawning_sk integer,
    spawning_st integer,
    spawning_wct integer,
    rearing_bt integer,
    rearing_ch integer,
    rearing_co integer,
    rearing_sk integer,
    rearing_st integer,
    rearing_wct integer
);


--
-- Name: streams_pk_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_pk_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_pk,
        CASE
            WHEN (a.access_pk = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_pk
        END AS spawning,
    m.mapping_code_pk AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_pk > 0);


--
-- Name: streams_salmon_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_salmon_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_salmon AS access,
    GREATEST(h.spawning_ch, h.spawning_cm, h.spawning_co, h.spawning_pk, h.spawning_sk) AS spawning,
    GREATEST(h.rearing_ch, h.rearing_co, h.rearing_sk) AS rearing,
    m.mapping_code_salmon AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_salmon > 0);


--
-- Name: streams_sk_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_sk_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_sk AS access,
        CASE
            WHEN (a.access_sk = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_sk
        END AS spawning,
        CASE
            WHEN (a.access_sk = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_sk
        END AS rearing,
    m.mapping_code_sk AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_sk > 0);


--
-- Name: streams_st_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_st_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_st AS access,
        CASE
            WHEN (a.access_st = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_st
        END AS spawning,
        CASE
            WHEN (a.access_st = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_st
        END AS rearing,
    m.mapping_code_st AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_st > 0);


--
-- Name: streams_upstr_observations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_upstr_observations (
    segmented_stream_id text NOT NULL,
    observation_key_upstr text[],
    obsrvtn_species_codes_upstr text[]
);


--
-- Name: streams_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_bt_dnstr, ';'::text) AS barriers_bt_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.barriers_ct_dv_rb_dnstr, ';'::text) AS barriers_ct_dv_rb_dnstr,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    array_to_string(a.barriers_wct_dnstr, ';'::text) AS barriers_wct_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_bt,
    a.access_ch,
    a.access_cm,
    a.access_co,
    a.access_pk,
    a.access_sk,
    a.access_st,
    a.access_wct,
    a.access_salmon,
        CASE
            WHEN (a.access_bt = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_bt
        END AS spawning_bt,
        CASE
            WHEN (a.access_ch = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_ch
        END AS spawning_ch,
        CASE
            WHEN (a.access_cm = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_cm
        END AS spawning_cm,
        CASE
            WHEN (a.access_co = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_co
        END AS spawning_co,
        CASE
            WHEN (a.access_pk = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_pk
        END AS spawning_pk,
        CASE
            WHEN (a.access_sk = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_sk
        END AS spawning_sk,
        CASE
            WHEN (a.access_st = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_st
        END AS spawning_st,
        CASE
            WHEN (a.access_wct = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_wct
        END AS spawning_wct,
        CASE
            WHEN (a.access_bt = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_bt
        END AS rearing_bt,
        CASE
            WHEN (a.access_ch = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_ch
        END AS rearing_ch,
        CASE
            WHEN (a.access_co = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_co
        END AS rearing_co,
        CASE
            WHEN (a.access_sk = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_sk
        END AS rearing_sk,
        CASE
            WHEN (a.access_st = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_st
        END AS rearing_st,
        CASE
            WHEN (a.access_wct = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_wct
        END AS rearing_wct,
    m.mapping_code_bt,
    m.mapping_code_ch,
    m.mapping_code_cm,
    m.mapping_code_co,
    m.mapping_code_pk,
    m.mapping_code_sk,
    m.mapping_code_st,
    m.mapping_code_wct,
    m.mapping_code_salmon,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)));


--
-- Name: streams_wct_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_wct_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_wct_dnstr, ';'::text) AS barriers_wct_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_wct AS access,
        CASE
            WHEN (a.access_wct = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_wct
        END AS spawning,
        CASE
            WHEN (a.access_wct = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_wct
        END AS rearing,
    m.mapping_code_wct AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_wct > 0);


--
-- Name: user_barriers_definite; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_barriers_definite (
    barrier_type text,
    barrier_name text,
    blue_line_key integer NOT NULL,
    downstream_route_measure double precision NOT NULL,
    watershed_group_code character varying(4),
    reviewer_name text,
    review_date date,
    source text,
    notes text
);


--
-- Name: user_barriers_definite_control; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_barriers_definite_control (
    blue_line_key integer NOT NULL,
    downstream_route_measure integer NOT NULL,
    barrier_type text,
    barrier_ind boolean,
    watershed_group_code text,
    reviewer_name text,
    review_date date,
    source text,
    notes text
);


--
-- Name: user_crossings_misc; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_crossings_misc (
    user_crossing_misc_id integer NOT NULL,
    blue_line_key integer NOT NULL,
    downstream_route_measure double precision NOT NULL,
    crossing_type_code text NOT NULL,
    crossing_subtype_code text NOT NULL,
    barrier_status text NOT NULL,
    watershed_group_code character varying(4) NOT NULL,
    reviewer_name text NOT NULL,
    review_date date NOT NULL,
    source text NOT NULL,
    notes text,
    CONSTRAINT user_crossings_misc_barrier_status_check CHECK ((barrier_status = ANY (ARRAY['BARRIER'::text, 'PASSABLE'::text, 'POTENTIAL'::text, 'UNKNOWN'::text]))),
    CONSTRAINT user_crossings_misc_crossing_subtype_code_check CHECK (((crossing_subtype_code ~ '^[A-Z0-9_]+$'::text) AND (char_length(crossing_subtype_code) <= 20))),
    CONSTRAINT user_crossings_misc_crossing_type_code_check CHECK ((crossing_type_code = ANY (ARRAY['CBS'::text, 'OBS'::text, 'OTHER'::text])))
);


--
-- Name: COLUMN user_crossings_misc.user_crossing_misc_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.user_crossing_misc_id IS 'User defined primary key - ensure this is unique';


--
-- Name: COLUMN user_crossings_misc.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.blue_line_key IS 'See FWA documentation';


--
-- Name: COLUMN user_crossings_misc.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.downstream_route_measure IS 'See FWA documentation';


--
-- Name: COLUMN user_crossings_misc.crossing_type_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. One of: {OBS=Open Bottom Structure CBS=Closed Bottom Structure OTHER=Crossing structure does not fit into the above categories (ford/wier)}';


--
-- Name: COLUMN user_crossings_misc.crossing_subtype_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.crossing_subtype_code IS 'Further definition of the type of crossing. One of {BRIDGE; CRTBOX; DAM; FORD; OVAL; PIPEARCH; ROUND; WEIR; WOODBOX; NULL}';


--
-- Name: COLUMN user_crossings_misc.barrier_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. One of: {PASSABLE - Passable; POTENTIAL - Potential or partial barrier; BARRIER - Barrier; UNKNOWN - Other}';


--
-- Name: COLUMN user_crossings_misc.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.watershed_group_code IS 'See FWA documentation';


--
-- Name: COLUMN user_crossings_misc.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN user_crossings_misc.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN user_crossings_misc.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.source IS 'Description or link to the source(s) documenting the feature';


--
-- Name: COLUMN user_crossings_misc.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.notes IS 'Reviewer notes on rationale for addition of the feature and/or how the source were interpreted';


--
-- Name: user_habitat_classification; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_habitat_classification (
    blue_line_key integer NOT NULL,
    downstream_route_measure double precision NOT NULL,
    upstream_route_measure double precision NOT NULL,
    watershed_group_code character varying(4),
    species_code text NOT NULL,
    spawning integer,
    rearing integer,
    reviewer_name text,
    review_date date,
    source text,
    notes text
);


--
-- Name: COLUMN user_habitat_classification.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.blue_line_key IS 'See FWA documentation';


--
-- Name: COLUMN user_habitat_classification.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.downstream_route_measure IS 'Measure of stream at point where user habitat classification begins';


--
-- Name: COLUMN user_habitat_classification.upstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.upstream_route_measure IS 'Measure of stream at point where user habitat classification ends';


--
-- Name: COLUMN user_habitat_classification.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.watershed_group_code IS 'See FWA documentation';


--
-- Name: COLUMN user_habitat_classification.species_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.species_code IS 'Habitat classification applies to this species - see whse_fish.species_cd for values';


--
-- Name: COLUMN user_habitat_classification.spawning; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.spawning IS 'Spawning classification (-1: known non-spawning; 1: known spawning, -4: mining altered stream)';


--
-- Name: COLUMN user_habitat_classification.rearing; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.rearing IS 'Rearing classification (-1: known non-rearing; 1: known rearing, -4: mining altered stream)';


--
-- Name: COLUMN user_habitat_classification.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN user_habitat_classification.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN user_habitat_classification.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.source IS 'Description or link to the source(s) documenting the feature';


--
-- Name: COLUMN user_habitat_classification.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.notes IS 'Reviewer notes on rationale for addition of the feature and/or how the source were interpreted';


--
-- Name: user_habitat_classification_endpoints; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_habitat_classification_endpoints (
    blue_line_key integer NOT NULL,
    downstream_route_measure double precision NOT NULL,
    linear_feature_id bigint,
    watershed_group_code character varying(4)
);


--
-- Name: user_habitat_codes; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_habitat_codes (
    habitat_code integer NOT NULL,
    habitat_value text NOT NULL
);


--
-- Name: user_modelled_crossing_fixes; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_modelled_crossing_fixes (
    modelled_crossing_id integer NOT NULL,
    structure text,
    watershed_group_code character varying(4),
    reviewer_name text,
    review_date date,
    source text,
    notes text
);


--
-- Name: user_pscis_barrier_status; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_pscis_barrier_status (
    stream_crossing_id integer NOT NULL,
    user_barrier_status text,
    watershed_group_code character varying(4),
    reviewer_name text,
    reviewer_date date,
    notes text
);


--
-- Name: wcrp_barrier_count_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wcrp_barrier_count_vw AS
 WITH model_status AS (
         SELECT c_1.aggregated_crossings_id,
                CASE
                    WHEN ((((h.ch_spawning_km > (0)::double precision) OR (h.ch_rearing_km > (0)::double precision)) AND (w_1.ch IS TRUE)) OR (((h.co_spawning_km > (0)::double precision) OR (h.co_rearing_km > (0)::double precision)) AND (w_1.co IS TRUE)) OR (((h.sk_spawning_km > (0)::double precision) OR (h.sk_rearing_km > (0)::double precision)) AND (w_1.sk IS TRUE)) OR (((h.st_spawning_km > (0)::double precision) OR (h.st_rearing_km > (0)::double precision)) AND (w_1.st IS TRUE)) OR (((h.wct_spawning_km > (0)::double precision) OR (h.wct_rearing_km > (0)::double precision)) AND (w_1.wct IS TRUE))) THEN 'HABITAT'::text
                    WHEN (((w_1.ch IS TRUE) AND (cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0)) OR ((w_1.co IS TRUE) AND (cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0)) OR ((w_1.sk IS TRUE) AND (cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0)) OR ((w_1.st IS TRUE) AND (cardinality(a.barriers_st_dnstr) = 0)) OR ((w_1.wct IS TRUE) AND (cardinality(a.barriers_wct_dnstr) = 0))) THEN 'ACCESSIBLE'::text
                    ELSE 'NATURAL_BARRIER'::text
                END AS model_status
           FROM (((bcfishpass.crossings c_1
             LEFT JOIN bcfishpass.crossings_upstream_access a ON ((c_1.aggregated_crossings_id = a.aggregated_crossings_id)))
             LEFT JOIN bcfishpass.crossings_upstream_habitat h ON ((c_1.aggregated_crossings_id = h.aggregated_crossings_id)))
             LEFT JOIN bcfishpass.wcrp_watersheds w_1 ON ((c_1.watershed_group_code = (w_1.watershed_group_code)::text)))
        )
 SELECT c.watershed_group_code,
    ms.model_status,
    c.crossing_feature_type,
    count(*) FILTER (WHERE (c.barrier_status = 'PASSABLE'::text)) AS n_passable,
    count(*) FILTER (WHERE (c.barrier_status = 'BARRIER'::text)) AS n_barrier,
    count(*) FILTER (WHERE (c.barrier_status = 'POTENTIAL'::text)) AS n_potential,
    count(*) FILTER (WHERE (c.barrier_status = 'UNKNOWN'::text)) AS n_unknown,
    count(*) AS total
   FROM ((bcfishpass.crossings c
     LEFT JOIN model_status ms ON ((c.aggregated_crossings_id = ms.aggregated_crossings_id)))
     JOIN bcfishpass.wcrp_watersheds w ON ((c.watershed_group_code = (w.watershed_group_code)::text)))
  WHERE ((c.wscode_ltree OPERATOR(public.<@) '300.602565.854327.993941.902282.132363'::public.ltree) IS FALSE)
  GROUP BY c.watershed_group_code, ms.model_status, c.crossing_feature_type
  ORDER BY c.watershed_group_code, ms.model_status, c.crossing_feature_type;


--
-- Name: wcrp_confirmed_barriers; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_confirmed_barriers (
    aggregated_crossings_id text NOT NULL,
    internal_name text,
    watercourse_name text,
    road_name text,
    easting integer,
    northing integer,
    zone integer,
    barrier_type text,
    barrier_owner text,
    assessment_step_completed text,
    partial_passability_notes text,
    upstream_habitat_quality text,
    constructability text,
    estimated_cost integer,
    cost_benefit_ratio integer,
    priority text,
    next_steps text,
    next_steps_timeline text,
    next_steps_lead text,
    next_steps_others_involved text,
    reason text,
    comments text,
    CONSTRAINT wcrp_confirmed_barriers_assessment_step_completed_check CHECK ((assessment_step_completed = ANY (ARRAY['Informal assessment'::text, 'Barrier assessment'::text, 'Habitat confirmation'::text, 'Detailed habitat investigation'::text]))),
    CONSTRAINT wcrp_confirmed_barriers_next_steps_check CHECK ((next_steps = ANY (ARRAY['Engage with barrier owner'::text, 'Bring barrier to regulator'::text, 'Commission engineering designs'::text, 'Remove'::text, 'Replace'::text, 'Leave until end of life cycle'::text, 'identify barrier owner'::text, 'Engage in public consultation'::text, 'Fundraise'::text]))),
    CONSTRAINT wcrp_confirmed_barriers_priority_check CHECK ((priority = ANY (ARRAY['High'::text, 'Medium'::text, 'Low'::text])))
);


--
-- Name: wcrp_data_deficient_structures; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_data_deficient_structures (
    aggregated_crossings_id text NOT NULL,
    internal_name text,
    watercourse_name text,
    road_name text,
    easting integer,
    northing integer,
    zone integer,
    structure_type text,
    assessment_step_completed text,
    structure_owner text,
    next_steps text,
    next_steps_lead text,
    comments text,
    CONSTRAINT wcrp_data_deficient_structures_assessment_step_completed_check CHECK ((assessment_step_completed = ANY (ARRAY['Informal assessment'::text, 'Barrier assessment'::text, 'Habitat confirmation'::text, 'Detailed habitat investigation'::text]))),
    CONSTRAINT wcrp_data_deficient_structures_next_steps_check CHECK ((next_steps = ANY (ARRAY['Barrier assessment'::text, 'Habitat confirmation'::text, 'Detailed habitat investigation'::text, 'Other'::text, 'Passage study'::text])))
);


--
-- Name: wcrp_excluded_structures; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_excluded_structures (
    aggregated_crossings_id text NOT NULL,
    internal_name text,
    watercourse_name text,
    road_name text,
    easting integer,
    northing integer,
    zone integer,
    exclusion_reason text,
    exclusion_method text,
    comments text,
    supporting_links text,
    CONSTRAINT wcrp_excluded_structures_exclusion_method_check CHECK ((exclusion_method = ANY (ARRAY['Imagery review'::text, 'Field assessment'::text, 'Local knowledge'::text, 'Informal assessment'::text]))),
    CONSTRAINT wcrp_excluded_structures_exclusion_reason_check CHECK ((exclusion_reason = ANY (ARRAY['Passable'::text, 'No structure'::text, 'No key upstream habitat'::text, 'No structure/key upstream habitat'::text])))
);


--
-- Name: wcrp_habitat_connectivity_status_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wcrp_habitat_connectivity_status_vw AS
 WITH length_totals AS (
         SELECT s.watershed_group_code,
            'SPAWNING'::text AS habitat_type,
            COALESCE(round(((sum(public.st_length(s.geom)) FILTER (WHERE (((h.spawning_ch > 0) AND (w.ch IS TRUE)) OR ((h.spawning_co > 0) AND (w.co IS TRUE)) OR ((h.spawning_st > 0) AND (w.st IS TRUE)) OR ((h.spawning_sk > 0) AND (w.sk IS TRUE)) OR ((h.spawning_wct > 0) AND (w.wct IS TRUE)))) / (1000)::double precision))::numeric, 2), (0)::numeric) AS total_km,
            COALESCE(round(((sum(public.st_length(s.geom)) FILTER (WHERE ((((h.spawning_ch > 0) AND (w.ch IS TRUE)) OR ((h.spawning_co > 0) AND (w.co IS TRUE)) OR ((h.spawning_st > 0) AND (w.st IS TRUE)) OR ((h.spawning_sk > 0) AND (w.sk IS TRUE)) OR ((h.spawning_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr IS NULL))) / (1000)::double precision))::numeric, 2), (0)::numeric) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          GROUP BY s.watershed_group_code
        UNION ALL
         SELECT s.watershed_group_code,
            'REARING'::text AS habitat_type,
            round(((((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((h.rearing_ch > 0) AND (w.ch IS TRUE)) OR ((h.rearing_st > 0) AND (w.st IS TRUE)) OR ((h.rearing_sk > 0) AND (w.sk IS TRUE)) OR ((h.rearing_co > 0) AND (w.co IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE)))), (0)::double precision) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_co > 0) AND (w.co IS TRUE) AND (s.edge_type = 1050))), (0)::double precision)) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_sk > 0) AND (w.sk IS TRUE))), (0)::double precision)) / (1000)::double precision))::numeric, 2) AS total_km,
            round(((((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE ((((h.rearing_ch > 0) AND (w.ch IS TRUE)) OR ((h.rearing_co > 0) AND (w.co IS TRUE)) OR ((h.rearing_st > 0) AND (w.st IS TRUE)) OR ((h.rearing_sk > 0) AND (w.sk IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_co > 0) AND (w.co IS TRUE) AND (s.edge_type = 1050) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision)) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_sk > 0) AND (w.sk IS TRUE) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision)) / (1000)::double precision))::numeric, 2) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          GROUP BY s.watershed_group_code
        UNION ALL
         SELECT s.watershed_group_code,
            'ALL'::text AS habitat_type,
            round(((((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((h.spawning_ch > 0) AND (w.ch IS TRUE)) OR ((h.spawning_co > 0) AND (w.co IS TRUE)) OR ((h.spawning_st > 0) AND (w.st IS TRUE)) OR ((h.spawning_sk > 0) AND (w.sk IS TRUE)) OR ((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_ch > 0) AND (w.ch IS TRUE)) OR ((h.rearing_co > 0) AND (w.co IS TRUE)) OR ((h.rearing_st > 0) AND (w.st IS TRUE)) OR ((h.rearing_sk > 0) AND (w.sk IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE)))), (0)::double precision) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_co > 0) AND (w.co IS TRUE) AND (s.edge_type = 1050))), (0)::double precision)) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_sk > 0) AND (w.sk IS TRUE))), (0)::double precision)) / (1000)::double precision))::numeric, 2) AS total_km,
            round(((((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE ((((h.spawning_ch > 0) AND (w.ch IS TRUE)) OR ((h.spawning_co > 0) AND (w.co IS TRUE)) OR ((h.spawning_st > 0) AND (w.st IS TRUE)) OR ((h.spawning_sk > 0) AND (w.sk IS TRUE)) OR ((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_ch > 0) AND (w.ch IS TRUE)) OR ((h.rearing_co > 0) AND (w.co IS TRUE)) OR ((h.rearing_st > 0) AND (w.st IS TRUE)) OR ((h.rearing_sk > 0) AND (w.sk IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_co > 0) AND (s.edge_type = 1050) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision)) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_sk > 0) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision)) / (1000)::double precision))::numeric, 2) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          GROUP BY s.watershed_group_code
        UNION ALL
         SELECT s.watershed_group_code,
            'UPSTREAM_ELKO'::text AS habitat_type,
            round(((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE)))), (0)::double precision) / (1000)::double precision))::numeric, 2) AS total_km,
            round(((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE ((((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr = ( SELECT a_1.barriers_anthropogenic_dnstr
                   FROM ((bcfishpass.streams s_1
                     JOIN bcfishpass.streams_habitat_linear h_1 USING (segmented_stream_id))
                     JOIN bcfishpass.streams_access a_1 USING (segmented_stream_id))
                  WHERE (s_1.segmented_stream_id ~~ '356570562.22912000'::text))))), (0)::double precision) / (1000)::double precision))::numeric, 2) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          WHERE whse_basemapping.fwa_upstream(356570562, (22910)::double precision, (22910)::double precision, '300.625474.584724'::public.ltree, '300.625474.584724.100997'::public.ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
          GROUP BY s.watershed_group_code
        UNION ALL
         SELECT s.watershed_group_code,
            'DOWNSTREAM_ELKO'::text AS habitat_type,
            round(((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE)))), (0)::double precision) / (1000)::double precision))::numeric, 2) AS total_km,
            round(((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr IS NULL) AND (a.barriers_wct_dnstr = ARRAY[]::text[])) OR (a.barriers_anthropogenic_dnstr = ( SELECT DISTINCT a_1.barriers_anthropogenic_dnstr
                   FROM ((bcfishpass.streams s_1
                     JOIN bcfishpass.streams_habitat_linear h_1 USING (segmented_stream_id))
                     JOIN bcfishpass.streams_access a_1 USING (segmented_stream_id))
                  WHERE (s_1.linear_feature_id = 706872063))))), (0)::double precision) / (1000)::double precision))::numeric, 2) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          WHERE ((s.wscode_ltree OPERATOR(public.<@) '300.625474.584724'::public.ltree) AND (NOT whse_basemapping.fwa_upstream(356570562, (22910)::double precision, (22910)::double precision, '300.625474.584724'::public.ltree, '300.625474.584724.100997'::public.ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)))
          GROUP BY s.watershed_group_code
        )
 SELECT watershed_group_code,
    habitat_type,
    total_km,
    accessible_km,
    round(((accessible_km / (total_km + 0.0001)) * (100)::numeric), 2) AS pct_accessible
   FROM length_totals
  ORDER BY watershed_group_code, habitat_type DESC;


--
-- Name: wcrp_rehabilitiated_structures; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_rehabilitiated_structures (
    aggregated_crossing_id text NOT NULL,
    internal_name text,
    watercourse_name text,
    road_name text,
    easting integer,
    northing integer,
    zone integer,
    rehabilitation_type text,
    rehabilitated_by text,
    rehabilitation_date date,
    rehabilitation_cost_estimate integer,
    rehabilitation_cost_actual integer,
    comments text,
    supporting_links text,
    CONSTRAINT wcrp_rehabilitiated_structures_rehabilitation_type_check CHECK ((rehabilitation_type = ANY (ARRAY['Removal'::text, 'Replacement - OBS'::text, 'Replacement - CBS'::text, 'Decommissioning'::text])))
);


--
-- Name: wsg_crossing_summary_current; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_crossing_summary_current AS
 SELECT s.model_run_id,
    s.watershed_group_code,
    s.crossing_feature_type,
    s.n_crossings_total,
    s.n_passable_total,
    s.n_barriers_total,
    s.n_potential_total,
    s.n_unknown_total,
    s.n_barriers_accessible_bt,
    s.n_potential_accessible_bt,
    s.n_unknown_accessible_bt,
    s.n_barriers_accessible_ch_cm_co_pk_sk,
    s.n_potential_accessible_ch_cm_co_pk_sk,
    s.n_unknown_accessible_ch_cm_co_pk_sk,
    s.n_barriers_accessible_st,
    s.n_potential_accessible_st,
    s.n_unknown_accessible_st,
    s.n_barriers_accessible_wct,
    s.n_potential_accessible_wct,
    s.n_unknown_accessible_wct,
    s.n_barriers_habitat_bt,
    s.n_potential_habitat_bt,
    s.n_unknown_habitat_bt,
    s.n_barriers_habitat_ch,
    s.n_potential_habitat_ch,
    s.n_unknown_habitat_ch,
    s.n_barriers_habitat_cm,
    s.n_potential_habitat_cm,
    s.n_unknown_habitat_cm,
    s.n_barriers_habitat_co,
    s.n_potential_habitat_co,
    s.n_unknown_habitat_co,
    s.n_barriers_habitat_pk,
    s.n_potential_habitat_pk,
    s.n_unknown_habitat_pk,
    s.n_barriers_habitat_sk,
    s.n_potential_habitat_sk,
    s.n_unknown_habitat_sk,
    s.n_barriers_habitat_salmon,
    s.n_potential_habitat_salmon,
    s.n_unknown_habitat_salmon,
    s.n_barriers_habitat_st,
    s.n_potential_habitat_st,
    s.n_unknown_habitat_st,
    s.n_barriers_habitat_wct,
    s.n_potential_habitat_wct,
    s.n_unknown_habitat_wct
   FROM (bcfishpass.log_wsg_crossing_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
  WHERE (l.model_run_id = ( SELECT log.model_run_id
           FROM bcfishpass.log
          ORDER BY log.model_run_id DESC
         LIMIT 1))
  ORDER BY s.watershed_group_code, s.crossing_feature_type;


--
-- Name: wsg_crossing_summary_previous; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_crossing_summary_previous AS
 SELECT s.model_run_id,
    s.watershed_group_code,
    s.crossing_feature_type,
    s.n_crossings_total,
    s.n_passable_total,
    s.n_barriers_total,
    s.n_potential_total,
    s.n_unknown_total,
    s.n_barriers_accessible_bt,
    s.n_potential_accessible_bt,
    s.n_unknown_accessible_bt,
    s.n_barriers_accessible_ch_cm_co_pk_sk,
    s.n_potential_accessible_ch_cm_co_pk_sk,
    s.n_unknown_accessible_ch_cm_co_pk_sk,
    s.n_barriers_accessible_st,
    s.n_potential_accessible_st,
    s.n_unknown_accessible_st,
    s.n_barriers_accessible_wct,
    s.n_potential_accessible_wct,
    s.n_unknown_accessible_wct,
    s.n_barriers_habitat_bt,
    s.n_potential_habitat_bt,
    s.n_unknown_habitat_bt,
    s.n_barriers_habitat_ch,
    s.n_potential_habitat_ch,
    s.n_unknown_habitat_ch,
    s.n_barriers_habitat_cm,
    s.n_potential_habitat_cm,
    s.n_unknown_habitat_cm,
    s.n_barriers_habitat_co,
    s.n_potential_habitat_co,
    s.n_unknown_habitat_co,
    s.n_barriers_habitat_pk,
    s.n_potential_habitat_pk,
    s.n_unknown_habitat_pk,
    s.n_barriers_habitat_sk,
    s.n_potential_habitat_sk,
    s.n_unknown_habitat_sk,
    s.n_barriers_habitat_salmon,
    s.n_potential_habitat_salmon,
    s.n_unknown_habitat_salmon,
    s.n_barriers_habitat_st,
    s.n_potential_habitat_st,
    s.n_unknown_habitat_st,
    s.n_barriers_habitat_wct,
    s.n_potential_habitat_wct,
    s.n_unknown_habitat_wct
   FROM (bcfishpass.log_wsg_crossing_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
  WHERE (l.model_run_id = ( SELECT log.model_run_id
           FROM bcfishpass.log
          ORDER BY log.model_run_id DESC
         OFFSET 1
         LIMIT 1))
  ORDER BY s.watershed_group_code;


--
-- Name: wsg_crossing_summary_diff; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_crossing_summary_diff AS
 SELECT a.watershed_group_code,
    a.crossing_feature_type,
    (a.n_crossings_total - b.n_crossings_total) AS n_crossings_total,
    (a.n_passable_total - b.n_passable_total) AS n_passable_total,
    (a.n_barriers_total - b.n_barriers_total) AS n_barriers_total,
    (a.n_potential_total - b.n_potential_total) AS n_potential_total,
    (a.n_unknown_total - b.n_unknown_total) AS n_unknown_total,
    (a.n_barriers_accessible_bt - b.n_barriers_accessible_bt) AS n_barriers_accessible_bt,
    (a.n_potential_accessible_bt - b.n_potential_accessible_bt) AS n_potential_accessible_bt,
    (a.n_unknown_accessible_bt - b.n_unknown_accessible_bt) AS n_unknown_accessible_bt,
    (a.n_barriers_accessible_ch_cm_co_pk_sk - b.n_barriers_accessible_ch_cm_co_pk_sk) AS n_barriers_accessible_ch_cm_co_pk_sk,
    (a.n_potential_accessible_ch_cm_co_pk_sk - b.n_potential_accessible_ch_cm_co_pk_sk) AS n_potential_accessible_ch_cm_co_pk_sk,
    (a.n_unknown_accessible_ch_cm_co_pk_sk - b.n_unknown_accessible_ch_cm_co_pk_sk) AS n_unknown_accessible_ch_cm_co_pk_sk,
    (a.n_barriers_accessible_st - b.n_barriers_accessible_st) AS n_barriers_accessible_st,
    (a.n_potential_accessible_st - b.n_potential_accessible_st) AS n_potential_accessible_st,
    (a.n_unknown_accessible_st - b.n_unknown_accessible_st) AS n_unknown_accessible_st,
    (a.n_barriers_accessible_wct - b.n_barriers_accessible_wct) AS n_barriers_accessible_wct,
    (a.n_potential_accessible_wct - b.n_potential_accessible_wct) AS n_potential_accessible_wct,
    (a.n_unknown_accessible_wct - b.n_unknown_accessible_wct) AS n_unknown_accessible_wct,
    (a.n_barriers_habitat_bt - b.n_barriers_habitat_bt) AS n_barriers_habitat_bt,
    (a.n_potential_habitat_bt - b.n_potential_habitat_bt) AS n_potential_habitat_bt,
    (a.n_unknown_habitat_bt - b.n_unknown_habitat_bt) AS n_unknown_habitat_bt,
    (a.n_barriers_habitat_ch - b.n_barriers_habitat_ch) AS n_barriers_habitat_ch,
    (a.n_potential_habitat_ch - b.n_potential_habitat_ch) AS n_potential_habitat_ch,
    (a.n_unknown_habitat_ch - b.n_unknown_habitat_ch) AS n_unknown_habitat_ch,
    (a.n_barriers_habitat_cm - b.n_barriers_habitat_cm) AS n_barriers_habitat_cm,
    (a.n_potential_habitat_cm - b.n_potential_habitat_cm) AS n_potential_habitat_cm,
    (a.n_unknown_habitat_cm - b.n_unknown_habitat_cm) AS n_unknown_habitat_cm,
    (a.n_barriers_habitat_co - b.n_barriers_habitat_co) AS n_barriers_habitat_co,
    (a.n_potential_habitat_co - b.n_potential_habitat_co) AS n_potential_habitat_co,
    (a.n_unknown_habitat_co - b.n_unknown_habitat_co) AS n_unknown_habitat_co,
    (a.n_barriers_habitat_pk - b.n_barriers_habitat_pk) AS n_barriers_habitat_pk,
    (a.n_potential_habitat_pk - b.n_potential_habitat_pk) AS n_potential_habitat_pk,
    (a.n_unknown_habitat_pk - b.n_unknown_habitat_pk) AS n_unknown_habitat_pk,
    (a.n_barriers_habitat_sk - b.n_barriers_habitat_sk) AS n_barriers_habitat_sk,
    (a.n_potential_habitat_sk - b.n_potential_habitat_sk) AS n_potential_habitat_sk,
    (a.n_unknown_habitat_sk - b.n_unknown_habitat_sk) AS n_unknown_habitat_sk,
    (a.n_barriers_habitat_salmon - b.n_barriers_habitat_salmon) AS n_barriers_habitat_salmon,
    (a.n_potential_habitat_salmon - b.n_potential_habitat_salmon) AS n_potential_habitat_salmon,
    (a.n_unknown_habitat_salmon - b.n_unknown_habitat_salmon) AS n_unknown_habitat_salmon,
    (a.n_barriers_habitat_st - b.n_barriers_habitat_st) AS n_barriers_habitat_st,
    (a.n_potential_habitat_st - b.n_potential_habitat_st) AS n_potential_habitat_st,
    (a.n_unknown_habitat_st - b.n_unknown_habitat_st) AS n_unknown_habitat_st,
    (a.n_barriers_habitat_wct - b.n_barriers_habitat_wct) AS n_barriers_habitat_wct,
    (a.n_potential_habitat_wct - b.n_potential_habitat_wct) AS n_potential_habitat_wct,
    (a.n_unknown_habitat_wct - b.n_unknown_habitat_wct) AS n_unknown_habitat_wct
   FROM (bcfishpass.wsg_crossing_summary_current a
     JOIN bcfishpass.wsg_crossing_summary_previous b ON (((a.watershed_group_code = b.watershed_group_code) AND (a.crossing_feature_type = b.crossing_feature_type))))
  ORDER BY a.watershed_group_code;


--
-- Name: wsg_linear_summary_current; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_linear_summary_current AS
 WITH sums AS (
         SELECT aw.watershed_group_code,
            sum(s_1.length_total) AS length_total,
            sum(s_1.length_naturallyaccessible_obsrvd_bt) AS length_naturallyaccessible_obsrvd_bt,
            sum(s_1.length_naturallyaccessible_obsrvd_bt_access_a) AS length_naturallyaccessible_obsrvd_bt_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_bt_access_b) AS length_naturallyaccessible_obsrvd_bt_access_b,
            sum(s_1.length_naturallyaccessible_model_bt) AS length_naturallyaccessible_model_bt,
            sum(s_1.length_naturallyaccessible_model_bt_access_a) AS length_naturallyaccessible_model_bt_access_a,
            sum(s_1.length_naturallyaccessible_model_bt_access_b) AS length_naturallyaccessible_model_bt_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_ch) AS length_naturallyaccessible_obsrvd_ch,
            sum(s_1.length_naturallyaccessible_obsrvd_ch_access_a) AS length_naturallyaccessible_obsrvd_ch_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_ch_access_b) AS length_naturallyaccessible_obsrvd_ch_access_b,
            sum(s_1.length_naturallyaccessible_model_ch) AS length_naturallyaccessible_model_ch,
            sum(s_1.length_naturallyaccessible_model_ch_access_a) AS length_naturallyaccessible_model_ch_access_a,
            sum(s_1.length_naturallyaccessible_model_ch_access_b) AS length_naturallyaccessible_model_ch_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_cm) AS length_naturallyaccessible_obsrvd_cm,
            sum(s_1.length_naturallyaccessible_obsrvd_cm_access_a) AS length_naturallyaccessible_obsrvd_cm_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_cm_access_b) AS length_naturallyaccessible_obsrvd_cm_access_b,
            sum(s_1.length_naturallyaccessible_model_cm) AS length_naturallyaccessible_model_cm,
            sum(s_1.length_naturallyaccessible_model_cm_access_a) AS length_naturallyaccessible_model_cm_access_a,
            sum(s_1.length_naturallyaccessible_model_cm_access_b) AS length_naturallyaccessible_model_cm_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_co) AS length_naturallyaccessible_obsrvd_co,
            sum(s_1.length_naturallyaccessible_obsrvd_co_access_a) AS length_naturallyaccessible_obsrvd_co_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_co_access_b) AS length_naturallyaccessible_obsrvd_co_access_b,
            sum(s_1.length_naturallyaccessible_model_co) AS length_naturallyaccessible_model_co,
            sum(s_1.length_naturallyaccessible_model_co_access_a) AS length_naturallyaccessible_model_co_access_a,
            sum(s_1.length_naturallyaccessible_model_co_access_b) AS length_naturallyaccessible_model_co_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_pk) AS length_naturallyaccessible_obsrvd_pk,
            sum(s_1.length_naturallyaccessible_obsrvd_pk_access_a) AS length_naturallyaccessible_obsrvd_pk_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_pk_access_b) AS length_naturallyaccessible_obsrvd_pk_access_b,
            sum(s_1.length_naturallyaccessible_model_pk) AS length_naturallyaccessible_model_pk,
            sum(s_1.length_naturallyaccessible_model_pk_access_a) AS length_naturallyaccessible_model_pk_access_a,
            sum(s_1.length_naturallyaccessible_model_pk_access_b) AS length_naturallyaccessible_model_pk_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_sk) AS length_naturallyaccessible_obsrvd_sk,
            sum(s_1.length_naturallyaccessible_obsrvd_sk_access_a) AS length_naturallyaccessible_obsrvd_sk_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_sk_access_b) AS length_naturallyaccessible_obsrvd_sk_access_b,
            sum(s_1.length_naturallyaccessible_model_sk) AS length_naturallyaccessible_model_sk,
            sum(s_1.length_naturallyaccessible_model_sk_access_a) AS length_naturallyaccessible_model_sk_access_a,
            sum(s_1.length_naturallyaccessible_model_sk_access_b) AS length_naturallyaccessible_model_sk_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon) AS length_naturallyaccessible_obsrvd_salmon,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon_access_a) AS length_naturallyaccessible_obsrvd_salmon_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon_access_b) AS length_naturallyaccessible_obsrvd_salmon_access_b,
            sum(s_1.length_naturallyaccessible_model_salmon) AS length_naturallyaccessible_model_salmon,
            sum(s_1.length_naturallyaccessible_model_salmon_access_a) AS length_naturallyaccessible_model_salmon_access_a,
            sum(s_1.length_naturallyaccessible_model_salmon_access_b) AS length_naturallyaccessible_model_salmon_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_st) AS length_naturallyaccessible_obsrvd_st,
            sum(s_1.length_naturallyaccessible_obsrvd_st_access_a) AS length_naturallyaccessible_obsrvd_st_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_st_access_b) AS length_naturallyaccessible_obsrvd_st_access_b,
            sum(s_1.length_naturallyaccessible_model_st) AS length_naturallyaccessible_model_st,
            sum(s_1.length_naturallyaccessible_model_st_access_a) AS length_naturallyaccessible_model_st_access_a,
            sum(s_1.length_naturallyaccessible_model_st_access_b) AS length_naturallyaccessible_model_st_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_wct) AS length_naturallyaccessible_obsrvd_wct,
            sum(s_1.length_naturallyaccessible_obsrvd_wct_access_a) AS length_naturallyaccessible_obsrvd_wct_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_wct_access_b) AS length_naturallyaccessible_obsrvd_wct_access_b,
            sum(s_1.length_naturallyaccessible_model_wct) AS length_naturallyaccessible_model_wct,
            sum(s_1.length_naturallyaccessible_model_wct_access_a) AS length_naturallyaccessible_model_wct_access_a,
            sum(s_1.length_naturallyaccessible_model_wct_access_b) AS length_naturallyaccessible_model_wct_access_b,
            sum(s_1.length_spawningrearing_obsrvd_bt) AS length_spawningrearing_obsrvd_bt,
            sum(s_1.length_spawningrearing_obsrvd_bt_access_a) AS length_spawningrearing_obsrvd_bt_access_a,
            sum(s_1.length_spawningrearing_obsrvd_bt_access_b) AS length_spawningrearing_obsrvd_bt_access_b,
            sum(s_1.length_spawningrearing_model_bt) AS length_spawningrearing_model_bt,
            sum(s_1.length_spawningrearing_model_bt_access_a) AS length_spawningrearing_model_bt_access_a,
            sum(s_1.length_spawningrearing_model_bt_access_b) AS length_spawningrearing_model_bt_access_b,
            sum(s_1.length_spawningrearing_obsrvd_ch) AS length_spawningrearing_obsrvd_ch,
            sum(s_1.length_spawningrearing_obsrvd_ch_access_a) AS length_spawningrearing_obsrvd_ch_access_a,
            sum(s_1.length_spawningrearing_obsrvd_ch_access_b) AS length_spawningrearing_obsrvd_ch_access_b,
            sum(s_1.length_spawningrearing_model_ch) AS length_spawningrearing_model_ch,
            sum(s_1.length_spawningrearing_model_ch_access_a) AS length_spawningrearing_model_ch_access_a,
            sum(s_1.length_spawningrearing_model_ch_access_b) AS length_spawningrearing_model_ch_access_b,
            sum(s_1.length_spawningrearing_obsrvd_cm) AS length_spawningrearing_obsrvd_cm,
            sum(s_1.length_spawningrearing_obsrvd_cm_access_a) AS length_spawningrearing_obsrvd_cm_access_a,
            sum(s_1.length_spawningrearing_obsrvd_cm_access_b) AS length_spawningrearing_obsrvd_cm_access_b,
            sum(s_1.length_spawningrearing_model_cm) AS length_spawningrearing_model_cm,
            sum(s_1.length_spawningrearing_model_cm_access_a) AS length_spawningrearing_model_cm_access_a,
            sum(s_1.length_spawningrearing_model_cm_access_b) AS length_spawningrearing_model_cm_access_b,
            sum(s_1.length_spawningrearing_obsrvd_co) AS length_spawningrearing_obsrvd_co,
            sum(s_1.length_spawningrearing_obsrvd_co_access_a) AS length_spawningrearing_obsrvd_co_access_a,
            sum(s_1.length_spawningrearing_obsrvd_co_access_b) AS length_spawningrearing_obsrvd_co_access_b,
            sum(s_1.length_spawningrearing_model_co) AS length_spawningrearing_model_co,
            sum(s_1.length_spawningrearing_model_co_access_a) AS length_spawningrearing_model_co_access_a,
            sum(s_1.length_spawningrearing_model_co_access_b) AS length_spawningrearing_model_co_access_b,
            sum(s_1.length_spawningrearing_obsrvd_pk) AS length_spawningrearing_obsrvd_pk,
            sum(s_1.length_spawningrearing_obsrvd_pk_access_a) AS length_spawningrearing_obsrvd_pk_access_a,
            sum(s_1.length_spawningrearing_obsrvd_pk_access_b) AS length_spawningrearing_obsrvd_pk_access_b,
            sum(s_1.length_spawningrearing_model_pk) AS length_spawningrearing_model_pk,
            sum(s_1.length_spawningrearing_model_pk_access_a) AS length_spawningrearing_model_pk_access_a,
            sum(s_1.length_spawningrearing_model_pk_access_b) AS length_spawningrearing_model_pk_access_b,
            sum(s_1.length_spawningrearing_obsrvd_sk) AS length_spawningrearing_obsrvd_sk,
            sum(s_1.length_spawningrearing_obsrvd_sk_access_a) AS length_spawningrearing_obsrvd_sk_access_a,
            sum(s_1.length_spawningrearing_obsrvd_sk_access_b) AS length_spawningrearing_obsrvd_sk_access_b,
            sum(s_1.length_spawningrearing_model_sk) AS length_spawningrearing_model_sk,
            sum(s_1.length_spawningrearing_model_sk_access_a) AS length_spawningrearing_model_sk_access_a,
            sum(s_1.length_spawningrearing_model_sk_access_b) AS length_spawningrearing_model_sk_access_b,
            sum(s_1.length_spawningrearing_obsrvd_st) AS length_spawningrearing_obsrvd_st,
            sum(s_1.length_spawningrearing_obsrvd_st_access_a) AS length_spawningrearing_obsrvd_st_access_a,
            sum(s_1.length_spawningrearing_obsrvd_st_access_b) AS length_spawningrearing_obsrvd_st_access_b,
            sum(s_1.length_spawningrearing_model_st) AS length_spawningrearing_model_st,
            sum(s_1.length_spawningrearing_model_st_access_a) AS length_spawningrearing_model_st_access_a,
            sum(s_1.length_spawningrearing_model_st_access_b) AS length_spawningrearing_model_st_access_b,
            sum(s_1.length_spawningrearing_obsrvd_wct) AS length_spawningrearing_obsrvd_wct,
            sum(s_1.length_spawningrearing_obsrvd_wct_access_a) AS length_spawningrearing_obsrvd_wct_access_a,
            sum(s_1.length_spawningrearing_obsrvd_wct_access_b) AS length_spawningrearing_obsrvd_wct_access_b,
            sum(s_1.length_spawningrearing_model_wct) AS length_spawningrearing_model_wct,
            sum(s_1.length_spawningrearing_model_wct_access_a) AS length_spawningrearing_model_wct_access_a,
            sum(s_1.length_spawningrearing_model_wct_access_b) AS length_spawningrearing_model_wct_access_b,
            sum(s_1.length_spawningrearing_obsrvd_salmon) AS length_spawningrearing_obsrvd_salmon,
            sum(s_1.length_spawningrearing_obsrvd_salmon_access_a) AS length_spawningrearing_obsrvd_salmon_access_a,
            sum(s_1.length_spawningrearing_obsrvd_salmon_access_b) AS length_spawningrearing_obsrvd_salmon_access_b,
            sum(s_1.length_spawningrearing_model_salmon) AS length_spawningrearing_model_salmon,
            sum(s_1.length_spawningrearing_model_salmon_access_a) AS length_spawningrearing_model_salmon_access_a,
            sum(s_1.length_spawningrearing_model_salmon_access_b) AS length_spawningrearing_model_salmon_access_b,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st) AS length_spawningrearing_obsrvd_salmon_st,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st_access_a) AS length_spawningrearing_obsrvd_salmon_st_access_a,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st_access_b) AS length_spawningrearing_obsrvd_salmon_st_access_b,
            sum(s_1.length_spawningrearing_model_salmon_st) AS length_spawningrearing_model_salmon_st,
            sum(s_1.length_spawningrearing_model_salmon_st_access_a) AS length_spawningrearing_model_salmon_st_access_a,
            sum(s_1.length_spawningrearing_model_salmon_st_access_b) AS length_spawningrearing_model_salmon_st_access_b
           FROM ((bcfishpass.log_aw_linear_summary s_1
             JOIN bcfishpass.log l ON ((s_1.model_run_id = l.model_run_id)))
             JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON ((s_1.assessment_watershed_id = aw.watershed_feature_id)))
          WHERE (l.date_completed = ( SELECT log.date_completed
                   FROM bcfishpass.log
                  ORDER BY log.date_completed DESC
                 LIMIT 1))
          GROUP BY aw.watershed_group_code
          ORDER BY aw.watershed_group_code
        )
 SELECT watershed_group_code,
    length_total,
    length_naturallyaccessible_obsrvd_bt,
    length_naturallyaccessible_obsrvd_bt_access_a,
    length_naturallyaccessible_obsrvd_bt_access_b,
    length_naturallyaccessible_model_bt,
    length_naturallyaccessible_model_bt_access_a,
    length_naturallyaccessible_model_bt_access_b,
    length_naturallyaccessible_obsrvd_ch,
    length_naturallyaccessible_obsrvd_ch_access_a,
    length_naturallyaccessible_obsrvd_ch_access_b,
    length_naturallyaccessible_model_ch,
    length_naturallyaccessible_model_ch_access_a,
    length_naturallyaccessible_model_ch_access_b,
    length_naturallyaccessible_obsrvd_cm,
    length_naturallyaccessible_obsrvd_cm_access_a,
    length_naturallyaccessible_obsrvd_cm_access_b,
    length_naturallyaccessible_model_cm,
    length_naturallyaccessible_model_cm_access_a,
    length_naturallyaccessible_model_cm_access_b,
    length_naturallyaccessible_obsrvd_co,
    length_naturallyaccessible_obsrvd_co_access_a,
    length_naturallyaccessible_obsrvd_co_access_b,
    length_naturallyaccessible_model_co,
    length_naturallyaccessible_model_co_access_a,
    length_naturallyaccessible_model_co_access_b,
    length_naturallyaccessible_obsrvd_pk,
    length_naturallyaccessible_obsrvd_pk_access_a,
    length_naturallyaccessible_obsrvd_pk_access_b,
    length_naturallyaccessible_model_pk,
    length_naturallyaccessible_model_pk_access_a,
    length_naturallyaccessible_model_pk_access_b,
    length_naturallyaccessible_obsrvd_sk,
    length_naturallyaccessible_obsrvd_sk_access_a,
    length_naturallyaccessible_obsrvd_sk_access_b,
    length_naturallyaccessible_model_sk,
    length_naturallyaccessible_model_sk_access_a,
    length_naturallyaccessible_model_sk_access_b,
    length_naturallyaccessible_obsrvd_salmon,
    length_naturallyaccessible_obsrvd_salmon_access_a,
    length_naturallyaccessible_obsrvd_salmon_access_b,
    length_naturallyaccessible_model_salmon,
    length_naturallyaccessible_model_salmon_access_a,
    length_naturallyaccessible_model_salmon_access_b,
    length_naturallyaccessible_obsrvd_st,
    length_naturallyaccessible_obsrvd_st_access_a,
    length_naturallyaccessible_obsrvd_st_access_b,
    length_naturallyaccessible_model_st,
    length_naturallyaccessible_model_st_access_a,
    length_naturallyaccessible_model_st_access_b,
    length_naturallyaccessible_obsrvd_wct,
    length_naturallyaccessible_obsrvd_wct_access_a,
    length_naturallyaccessible_obsrvd_wct_access_b,
    length_naturallyaccessible_model_wct,
    length_naturallyaccessible_model_wct_access_a,
    length_naturallyaccessible_model_wct_access_b,
    length_spawningrearing_obsrvd_bt,
    length_spawningrearing_obsrvd_bt_access_a,
    length_spawningrearing_obsrvd_bt_access_b,
    length_spawningrearing_model_bt,
    length_spawningrearing_model_bt_access_a,
    length_spawningrearing_model_bt_access_b,
    length_spawningrearing_obsrvd_ch,
    length_spawningrearing_obsrvd_ch_access_a,
    length_spawningrearing_obsrvd_ch_access_b,
    length_spawningrearing_model_ch,
    length_spawningrearing_model_ch_access_a,
    length_spawningrearing_model_ch_access_b,
    length_spawningrearing_obsrvd_cm,
    length_spawningrearing_obsrvd_cm_access_a,
    length_spawningrearing_obsrvd_cm_access_b,
    length_spawningrearing_model_cm,
    length_spawningrearing_model_cm_access_a,
    length_spawningrearing_model_cm_access_b,
    length_spawningrearing_obsrvd_co,
    length_spawningrearing_obsrvd_co_access_a,
    length_spawningrearing_obsrvd_co_access_b,
    length_spawningrearing_model_co,
    length_spawningrearing_model_co_access_a,
    length_spawningrearing_model_co_access_b,
    length_spawningrearing_obsrvd_pk,
    length_spawningrearing_obsrvd_pk_access_a,
    length_spawningrearing_obsrvd_pk_access_b,
    length_spawningrearing_model_pk,
    length_spawningrearing_model_pk_access_a,
    length_spawningrearing_model_pk_access_b,
    length_spawningrearing_obsrvd_sk,
    length_spawningrearing_obsrvd_sk_access_a,
    length_spawningrearing_obsrvd_sk_access_b,
    length_spawningrearing_model_sk,
    length_spawningrearing_model_sk_access_a,
    length_spawningrearing_model_sk_access_b,
    length_spawningrearing_obsrvd_st,
    length_spawningrearing_obsrvd_st_access_a,
    length_spawningrearing_obsrvd_st_access_b,
    length_spawningrearing_model_st,
    length_spawningrearing_model_st_access_a,
    length_spawningrearing_model_st_access_b,
    length_spawningrearing_obsrvd_wct,
    length_spawningrearing_obsrvd_wct_access_a,
    length_spawningrearing_obsrvd_wct_access_b,
    length_spawningrearing_model_wct,
    length_spawningrearing_model_wct_access_a,
    length_spawningrearing_model_wct_access_b,
    length_spawningrearing_obsrvd_salmon,
    length_spawningrearing_obsrvd_salmon_access_a,
    length_spawningrearing_obsrvd_salmon_access_b,
    length_spawningrearing_model_salmon,
    length_spawningrearing_model_salmon_access_a,
    length_spawningrearing_model_salmon_access_b,
    length_spawningrearing_obsrvd_salmon_st,
    length_spawningrearing_obsrvd_salmon_st_access_a,
    length_spawningrearing_obsrvd_salmon_st_access_b,
    length_spawningrearing_model_salmon_st,
    length_spawningrearing_model_salmon_st_access_a,
    length_spawningrearing_model_salmon_st_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_bt_access_b + length_naturallyaccessible_model_bt_access_b) / NULLIF((length_naturallyaccessible_obsrvd_bt + length_naturallyaccessible_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_bt_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_ch_access_b + length_naturallyaccessible_model_ch_access_b) / NULLIF((length_naturallyaccessible_obsrvd_ch + length_naturallyaccessible_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_ch_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_cm_access_b + length_naturallyaccessible_model_cm_access_b) / NULLIF((length_naturallyaccessible_obsrvd_cm + length_naturallyaccessible_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_cm_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_co_access_b + length_naturallyaccessible_model_co_access_b) / NULLIF((length_naturallyaccessible_obsrvd_co + length_naturallyaccessible_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_co_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_pk_access_b + length_naturallyaccessible_model_pk_access_b) / NULLIF((length_naturallyaccessible_obsrvd_pk + length_naturallyaccessible_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_pk_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_sk_access_b + length_naturallyaccessible_model_sk_access_b) / NULLIF((length_naturallyaccessible_obsrvd_sk + length_naturallyaccessible_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_sk_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_salmon_access_b + length_naturallyaccessible_model_salmon_access_b) / NULLIF((length_naturallyaccessible_obsrvd_salmon + length_naturallyaccessible_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_salmon_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_st_access_b + length_naturallyaccessible_model_st_access_b) / NULLIF((length_naturallyaccessible_obsrvd_st + length_naturallyaccessible_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_st_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_wct_access_b + length_naturallyaccessible_model_wct_access_b) / NULLIF((length_naturallyaccessible_obsrvd_wct + length_naturallyaccessible_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_wct_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_bt_access_b + length_spawningrearing_model_bt_access_b) / NULLIF((length_spawningrearing_obsrvd_bt + length_spawningrearing_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_bt_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_ch_access_b + length_spawningrearing_model_ch_access_b) / NULLIF((length_spawningrearing_obsrvd_ch + length_spawningrearing_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_ch_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_cm_access_b + length_spawningrearing_model_cm_access_b) / NULLIF((length_spawningrearing_obsrvd_cm + length_spawningrearing_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_cm_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_co_access_b + length_spawningrearing_model_co_access_b) / NULLIF((length_spawningrearing_obsrvd_co + length_spawningrearing_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_co_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_pk_access_b + length_spawningrearing_model_pk_access_b) / NULLIF((length_spawningrearing_obsrvd_pk + length_spawningrearing_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_pk_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_sk_access_b + length_spawningrearing_model_sk_access_b) / NULLIF((length_spawningrearing_obsrvd_sk + length_spawningrearing_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_sk_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_st_access_b + length_spawningrearing_model_st_access_b) / NULLIF((length_spawningrearing_obsrvd_st + length_spawningrearing_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_st_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_wct_access_b + length_spawningrearing_model_wct_access_b) / NULLIF((length_spawningrearing_obsrvd_wct + length_spawningrearing_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_wct_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_salmon_access_b + length_spawningrearing_model_salmon_access_b) / NULLIF((length_spawningrearing_obsrvd_salmon + length_spawningrearing_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_salmon_st_access_b + length_spawningrearing_model_salmon_st_access_b) / NULLIF((length_spawningrearing_obsrvd_salmon_st + length_spawningrearing_model_salmon_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_st_access_b
   FROM sums s;


--
-- Name: wsg_linear_summary_previous; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_linear_summary_previous AS
 WITH sums AS (
         SELECT aw.watershed_group_code,
            sum(s_1.length_total) AS length_total,
            sum(s_1.length_naturallyaccessible_obsrvd_bt) AS length_naturallyaccessible_obsrvd_bt,
            sum(s_1.length_naturallyaccessible_obsrvd_bt_access_a) AS length_naturallyaccessible_obsrvd_bt_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_bt_access_b) AS length_naturallyaccessible_obsrvd_bt_access_b,
            sum(s_1.length_naturallyaccessible_model_bt) AS length_naturallyaccessible_model_bt,
            sum(s_1.length_naturallyaccessible_model_bt_access_a) AS length_naturallyaccessible_model_bt_access_a,
            sum(s_1.length_naturallyaccessible_model_bt_access_b) AS length_naturallyaccessible_model_bt_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_ch) AS length_naturallyaccessible_obsrvd_ch,
            sum(s_1.length_naturallyaccessible_obsrvd_ch_access_a) AS length_naturallyaccessible_obsrvd_ch_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_ch_access_b) AS length_naturallyaccessible_obsrvd_ch_access_b,
            sum(s_1.length_naturallyaccessible_model_ch) AS length_naturallyaccessible_model_ch,
            sum(s_1.length_naturallyaccessible_model_ch_access_a) AS length_naturallyaccessible_model_ch_access_a,
            sum(s_1.length_naturallyaccessible_model_ch_access_b) AS length_naturallyaccessible_model_ch_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_cm) AS length_naturallyaccessible_obsrvd_cm,
            sum(s_1.length_naturallyaccessible_obsrvd_cm_access_a) AS length_naturallyaccessible_obsrvd_cm_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_cm_access_b) AS length_naturallyaccessible_obsrvd_cm_access_b,
            sum(s_1.length_naturallyaccessible_model_cm) AS length_naturallyaccessible_model_cm,
            sum(s_1.length_naturallyaccessible_model_cm_access_a) AS length_naturallyaccessible_model_cm_access_a,
            sum(s_1.length_naturallyaccessible_model_cm_access_b) AS length_naturallyaccessible_model_cm_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_co) AS length_naturallyaccessible_obsrvd_co,
            sum(s_1.length_naturallyaccessible_obsrvd_co_access_a) AS length_naturallyaccessible_obsrvd_co_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_co_access_b) AS length_naturallyaccessible_obsrvd_co_access_b,
            sum(s_1.length_naturallyaccessible_model_co) AS length_naturallyaccessible_model_co,
            sum(s_1.length_naturallyaccessible_model_co_access_a) AS length_naturallyaccessible_model_co_access_a,
            sum(s_1.length_naturallyaccessible_model_co_access_b) AS length_naturallyaccessible_model_co_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_pk) AS length_naturallyaccessible_obsrvd_pk,
            sum(s_1.length_naturallyaccessible_obsrvd_pk_access_a) AS length_naturallyaccessible_obsrvd_pk_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_pk_access_b) AS length_naturallyaccessible_obsrvd_pk_access_b,
            sum(s_1.length_naturallyaccessible_model_pk) AS length_naturallyaccessible_model_pk,
            sum(s_1.length_naturallyaccessible_model_pk_access_a) AS length_naturallyaccessible_model_pk_access_a,
            sum(s_1.length_naturallyaccessible_model_pk_access_b) AS length_naturallyaccessible_model_pk_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_sk) AS length_naturallyaccessible_obsrvd_sk,
            sum(s_1.length_naturallyaccessible_obsrvd_sk_access_a) AS length_naturallyaccessible_obsrvd_sk_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_sk_access_b) AS length_naturallyaccessible_obsrvd_sk_access_b,
            sum(s_1.length_naturallyaccessible_model_sk) AS length_naturallyaccessible_model_sk,
            sum(s_1.length_naturallyaccessible_model_sk_access_a) AS length_naturallyaccessible_model_sk_access_a,
            sum(s_1.length_naturallyaccessible_model_sk_access_b) AS length_naturallyaccessible_model_sk_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon) AS length_naturallyaccessible_obsrvd_salmon,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon_access_a) AS length_naturallyaccessible_obsrvd_salmon_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon_access_b) AS length_naturallyaccessible_obsrvd_salmon_access_b,
            sum(s_1.length_naturallyaccessible_model_salmon) AS length_naturallyaccessible_model_salmon,
            sum(s_1.length_naturallyaccessible_model_salmon_access_a) AS length_naturallyaccessible_model_salmon_access_a,
            sum(s_1.length_naturallyaccessible_model_salmon_access_b) AS length_naturallyaccessible_model_salmon_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_st) AS length_naturallyaccessible_obsrvd_st,
            sum(s_1.length_naturallyaccessible_obsrvd_st_access_a) AS length_naturallyaccessible_obsrvd_st_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_st_access_b) AS length_naturallyaccessible_obsrvd_st_access_b,
            sum(s_1.length_naturallyaccessible_model_st) AS length_naturallyaccessible_model_st,
            sum(s_1.length_naturallyaccessible_model_st_access_a) AS length_naturallyaccessible_model_st_access_a,
            sum(s_1.length_naturallyaccessible_model_st_access_b) AS length_naturallyaccessible_model_st_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_wct) AS length_naturallyaccessible_obsrvd_wct,
            sum(s_1.length_naturallyaccessible_obsrvd_wct_access_a) AS length_naturallyaccessible_obsrvd_wct_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_wct_access_b) AS length_naturallyaccessible_obsrvd_wct_access_b,
            sum(s_1.length_naturallyaccessible_model_wct) AS length_naturallyaccessible_model_wct,
            sum(s_1.length_naturallyaccessible_model_wct_access_a) AS length_naturallyaccessible_model_wct_access_a,
            sum(s_1.length_naturallyaccessible_model_wct_access_b) AS length_naturallyaccessible_model_wct_access_b,
            sum(s_1.length_spawningrearing_obsrvd_bt) AS length_spawningrearing_obsrvd_bt,
            sum(s_1.length_spawningrearing_obsrvd_bt_access_a) AS length_spawningrearing_obsrvd_bt_access_a,
            sum(s_1.length_spawningrearing_obsrvd_bt_access_b) AS length_spawningrearing_obsrvd_bt_access_b,
            sum(s_1.length_spawningrearing_model_bt) AS length_spawningrearing_model_bt,
            sum(s_1.length_spawningrearing_model_bt_access_a) AS length_spawningrearing_model_bt_access_a,
            sum(s_1.length_spawningrearing_model_bt_access_b) AS length_spawningrearing_model_bt_access_b,
            sum(s_1.length_spawningrearing_obsrvd_ch) AS length_spawningrearing_obsrvd_ch,
            sum(s_1.length_spawningrearing_obsrvd_ch_access_a) AS length_spawningrearing_obsrvd_ch_access_a,
            sum(s_1.length_spawningrearing_obsrvd_ch_access_b) AS length_spawningrearing_obsrvd_ch_access_b,
            sum(s_1.length_spawningrearing_model_ch) AS length_spawningrearing_model_ch,
            sum(s_1.length_spawningrearing_model_ch_access_a) AS length_spawningrearing_model_ch_access_a,
            sum(s_1.length_spawningrearing_model_ch_access_b) AS length_spawningrearing_model_ch_access_b,
            sum(s_1.length_spawningrearing_obsrvd_cm) AS length_spawningrearing_obsrvd_cm,
            sum(s_1.length_spawningrearing_obsrvd_cm_access_a) AS length_spawningrearing_obsrvd_cm_access_a,
            sum(s_1.length_spawningrearing_obsrvd_cm_access_b) AS length_spawningrearing_obsrvd_cm_access_b,
            sum(s_1.length_spawningrearing_model_cm) AS length_spawningrearing_model_cm,
            sum(s_1.length_spawningrearing_model_cm_access_a) AS length_spawningrearing_model_cm_access_a,
            sum(s_1.length_spawningrearing_model_cm_access_b) AS length_spawningrearing_model_cm_access_b,
            sum(s_1.length_spawningrearing_obsrvd_co) AS length_spawningrearing_obsrvd_co,
            sum(s_1.length_spawningrearing_obsrvd_co_access_a) AS length_spawningrearing_obsrvd_co_access_a,
            sum(s_1.length_spawningrearing_obsrvd_co_access_b) AS length_spawningrearing_obsrvd_co_access_b,
            sum(s_1.length_spawningrearing_model_co) AS length_spawningrearing_model_co,
            sum(s_1.length_spawningrearing_model_co_access_a) AS length_spawningrearing_model_co_access_a,
            sum(s_1.length_spawningrearing_model_co_access_b) AS length_spawningrearing_model_co_access_b,
            sum(s_1.length_spawningrearing_obsrvd_pk) AS length_spawningrearing_obsrvd_pk,
            sum(s_1.length_spawningrearing_obsrvd_pk_access_a) AS length_spawningrearing_obsrvd_pk_access_a,
            sum(s_1.length_spawningrearing_obsrvd_pk_access_b) AS length_spawningrearing_obsrvd_pk_access_b,
            sum(s_1.length_spawningrearing_model_pk) AS length_spawningrearing_model_pk,
            sum(s_1.length_spawningrearing_model_pk_access_a) AS length_spawningrearing_model_pk_access_a,
            sum(s_1.length_spawningrearing_model_pk_access_b) AS length_spawningrearing_model_pk_access_b,
            sum(s_1.length_spawningrearing_obsrvd_sk) AS length_spawningrearing_obsrvd_sk,
            sum(s_1.length_spawningrearing_obsrvd_sk_access_a) AS length_spawningrearing_obsrvd_sk_access_a,
            sum(s_1.length_spawningrearing_obsrvd_sk_access_b) AS length_spawningrearing_obsrvd_sk_access_b,
            sum(s_1.length_spawningrearing_model_sk) AS length_spawningrearing_model_sk,
            sum(s_1.length_spawningrearing_model_sk_access_a) AS length_spawningrearing_model_sk_access_a,
            sum(s_1.length_spawningrearing_model_sk_access_b) AS length_spawningrearing_model_sk_access_b,
            sum(s_1.length_spawningrearing_obsrvd_st) AS length_spawningrearing_obsrvd_st,
            sum(s_1.length_spawningrearing_obsrvd_st_access_a) AS length_spawningrearing_obsrvd_st_access_a,
            sum(s_1.length_spawningrearing_obsrvd_st_access_b) AS length_spawningrearing_obsrvd_st_access_b,
            sum(s_1.length_spawningrearing_model_st) AS length_spawningrearing_model_st,
            sum(s_1.length_spawningrearing_model_st_access_a) AS length_spawningrearing_model_st_access_a,
            sum(s_1.length_spawningrearing_model_st_access_b) AS length_spawningrearing_model_st_access_b,
            sum(s_1.length_spawningrearing_obsrvd_wct) AS length_spawningrearing_obsrvd_wct,
            sum(s_1.length_spawningrearing_obsrvd_wct_access_a) AS length_spawningrearing_obsrvd_wct_access_a,
            sum(s_1.length_spawningrearing_obsrvd_wct_access_b) AS length_spawningrearing_obsrvd_wct_access_b,
            sum(s_1.length_spawningrearing_model_wct) AS length_spawningrearing_model_wct,
            sum(s_1.length_spawningrearing_model_wct_access_a) AS length_spawningrearing_model_wct_access_a,
            sum(s_1.length_spawningrearing_model_wct_access_b) AS length_spawningrearing_model_wct_access_b,
            sum(s_1.length_spawningrearing_obsrvd_salmon) AS length_spawningrearing_obsrvd_salmon,
            sum(s_1.length_spawningrearing_obsrvd_salmon_access_a) AS length_spawningrearing_obsrvd_salmon_access_a,
            sum(s_1.length_spawningrearing_obsrvd_salmon_access_b) AS length_spawningrearing_obsrvd_salmon_access_b,
            sum(s_1.length_spawningrearing_model_salmon) AS length_spawningrearing_model_salmon,
            sum(s_1.length_spawningrearing_model_salmon_access_a) AS length_spawningrearing_model_salmon_access_a,
            sum(s_1.length_spawningrearing_model_salmon_access_b) AS length_spawningrearing_model_salmon_access_b,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st) AS length_spawningrearing_obsrvd_salmon_st,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st_access_a) AS length_spawningrearing_obsrvd_salmon_st_access_a,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st_access_b) AS length_spawningrearing_obsrvd_salmon_st_access_b,
            sum(s_1.length_spawningrearing_model_salmon_st) AS length_spawningrearing_model_salmon_st,
            sum(s_1.length_spawningrearing_model_salmon_st_access_a) AS length_spawningrearing_model_salmon_st_access_a,
            sum(s_1.length_spawningrearing_model_salmon_st_access_b) AS length_spawningrearing_model_salmon_st_access_b
           FROM ((bcfishpass.log_aw_linear_summary s_1
             JOIN bcfishpass.log l ON ((s_1.model_run_id = l.model_run_id)))
             JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON ((s_1.assessment_watershed_id = aw.watershed_feature_id)))
          WHERE (l.date_completed = ( SELECT log.date_completed
                   FROM bcfishpass.log
                  ORDER BY log.date_completed DESC
                 OFFSET 1
                 LIMIT 1))
          GROUP BY aw.watershed_group_code
          ORDER BY aw.watershed_group_code
        )
 SELECT watershed_group_code,
    length_total,
    length_naturallyaccessible_obsrvd_bt,
    length_naturallyaccessible_obsrvd_bt_access_a,
    length_naturallyaccessible_obsrvd_bt_access_b,
    length_naturallyaccessible_model_bt,
    length_naturallyaccessible_model_bt_access_a,
    length_naturallyaccessible_model_bt_access_b,
    length_naturallyaccessible_obsrvd_ch,
    length_naturallyaccessible_obsrvd_ch_access_a,
    length_naturallyaccessible_obsrvd_ch_access_b,
    length_naturallyaccessible_model_ch,
    length_naturallyaccessible_model_ch_access_a,
    length_naturallyaccessible_model_ch_access_b,
    length_naturallyaccessible_obsrvd_cm,
    length_naturallyaccessible_obsrvd_cm_access_a,
    length_naturallyaccessible_obsrvd_cm_access_b,
    length_naturallyaccessible_model_cm,
    length_naturallyaccessible_model_cm_access_a,
    length_naturallyaccessible_model_cm_access_b,
    length_naturallyaccessible_obsrvd_co,
    length_naturallyaccessible_obsrvd_co_access_a,
    length_naturallyaccessible_obsrvd_co_access_b,
    length_naturallyaccessible_model_co,
    length_naturallyaccessible_model_co_access_a,
    length_naturallyaccessible_model_co_access_b,
    length_naturallyaccessible_obsrvd_pk,
    length_naturallyaccessible_obsrvd_pk_access_a,
    length_naturallyaccessible_obsrvd_pk_access_b,
    length_naturallyaccessible_model_pk,
    length_naturallyaccessible_model_pk_access_a,
    length_naturallyaccessible_model_pk_access_b,
    length_naturallyaccessible_obsrvd_sk,
    length_naturallyaccessible_obsrvd_sk_access_a,
    length_naturallyaccessible_obsrvd_sk_access_b,
    length_naturallyaccessible_model_sk,
    length_naturallyaccessible_model_sk_access_a,
    length_naturallyaccessible_model_sk_access_b,
    length_naturallyaccessible_obsrvd_salmon,
    length_naturallyaccessible_obsrvd_salmon_access_a,
    length_naturallyaccessible_obsrvd_salmon_access_b,
    length_naturallyaccessible_model_salmon,
    length_naturallyaccessible_model_salmon_access_a,
    length_naturallyaccessible_model_salmon_access_b,
    length_naturallyaccessible_obsrvd_st,
    length_naturallyaccessible_obsrvd_st_access_a,
    length_naturallyaccessible_obsrvd_st_access_b,
    length_naturallyaccessible_model_st,
    length_naturallyaccessible_model_st_access_a,
    length_naturallyaccessible_model_st_access_b,
    length_naturallyaccessible_obsrvd_wct,
    length_naturallyaccessible_obsrvd_wct_access_a,
    length_naturallyaccessible_obsrvd_wct_access_b,
    length_naturallyaccessible_model_wct,
    length_naturallyaccessible_model_wct_access_a,
    length_naturallyaccessible_model_wct_access_b,
    length_spawningrearing_obsrvd_bt,
    length_spawningrearing_obsrvd_bt_access_a,
    length_spawningrearing_obsrvd_bt_access_b,
    length_spawningrearing_model_bt,
    length_spawningrearing_model_bt_access_a,
    length_spawningrearing_model_bt_access_b,
    length_spawningrearing_obsrvd_ch,
    length_spawningrearing_obsrvd_ch_access_a,
    length_spawningrearing_obsrvd_ch_access_b,
    length_spawningrearing_model_ch,
    length_spawningrearing_model_ch_access_a,
    length_spawningrearing_model_ch_access_b,
    length_spawningrearing_obsrvd_cm,
    length_spawningrearing_obsrvd_cm_access_a,
    length_spawningrearing_obsrvd_cm_access_b,
    length_spawningrearing_model_cm,
    length_spawningrearing_model_cm_access_a,
    length_spawningrearing_model_cm_access_b,
    length_spawningrearing_obsrvd_co,
    length_spawningrearing_obsrvd_co_access_a,
    length_spawningrearing_obsrvd_co_access_b,
    length_spawningrearing_model_co,
    length_spawningrearing_model_co_access_a,
    length_spawningrearing_model_co_access_b,
    length_spawningrearing_obsrvd_pk,
    length_spawningrearing_obsrvd_pk_access_a,
    length_spawningrearing_obsrvd_pk_access_b,
    length_spawningrearing_model_pk,
    length_spawningrearing_model_pk_access_a,
    length_spawningrearing_model_pk_access_b,
    length_spawningrearing_obsrvd_sk,
    length_spawningrearing_obsrvd_sk_access_a,
    length_spawningrearing_obsrvd_sk_access_b,
    length_spawningrearing_model_sk,
    length_spawningrearing_model_sk_access_a,
    length_spawningrearing_model_sk_access_b,
    length_spawningrearing_obsrvd_st,
    length_spawningrearing_obsrvd_st_access_a,
    length_spawningrearing_obsrvd_st_access_b,
    length_spawningrearing_model_st,
    length_spawningrearing_model_st_access_a,
    length_spawningrearing_model_st_access_b,
    length_spawningrearing_obsrvd_wct,
    length_spawningrearing_obsrvd_wct_access_a,
    length_spawningrearing_obsrvd_wct_access_b,
    length_spawningrearing_model_wct,
    length_spawningrearing_model_wct_access_a,
    length_spawningrearing_model_wct_access_b,
    length_spawningrearing_obsrvd_salmon,
    length_spawningrearing_obsrvd_salmon_access_a,
    length_spawningrearing_obsrvd_salmon_access_b,
    length_spawningrearing_model_salmon,
    length_spawningrearing_model_salmon_access_a,
    length_spawningrearing_model_salmon_access_b,
    length_spawningrearing_obsrvd_salmon_st,
    length_spawningrearing_obsrvd_salmon_st_access_a,
    length_spawningrearing_obsrvd_salmon_st_access_b,
    length_spawningrearing_model_salmon_st,
    length_spawningrearing_model_salmon_st_access_a,
    length_spawningrearing_model_salmon_st_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_bt_access_b + length_naturallyaccessible_model_bt_access_b) / NULLIF((length_naturallyaccessible_obsrvd_bt + length_naturallyaccessible_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_bt_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_ch_access_b + length_naturallyaccessible_model_ch_access_b) / NULLIF((length_naturallyaccessible_obsrvd_ch + length_naturallyaccessible_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_ch_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_cm_access_b + length_naturallyaccessible_model_cm_access_b) / NULLIF((length_naturallyaccessible_obsrvd_cm + length_naturallyaccessible_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_cm_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_co_access_b + length_naturallyaccessible_model_co_access_b) / NULLIF((length_naturallyaccessible_obsrvd_co + length_naturallyaccessible_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_co_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_pk_access_b + length_naturallyaccessible_model_pk_access_b) / NULLIF((length_naturallyaccessible_obsrvd_pk + length_naturallyaccessible_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_pk_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_sk_access_b + length_naturallyaccessible_model_sk_access_b) / NULLIF((length_naturallyaccessible_obsrvd_sk + length_naturallyaccessible_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_sk_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_salmon_access_b + length_naturallyaccessible_model_salmon_access_b) / NULLIF((length_naturallyaccessible_obsrvd_salmon + length_naturallyaccessible_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_salmon_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_st_access_b + length_naturallyaccessible_model_st_access_b) / NULLIF((length_naturallyaccessible_obsrvd_st + length_naturallyaccessible_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_st_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_wct_access_b + length_naturallyaccessible_model_wct_access_b) / NULLIF((length_naturallyaccessible_obsrvd_wct + length_naturallyaccessible_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_wct_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_bt_access_b + length_spawningrearing_model_bt_access_b) / NULLIF((length_spawningrearing_obsrvd_bt + length_spawningrearing_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_bt_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_ch_access_b + length_spawningrearing_model_ch_access_b) / NULLIF((length_spawningrearing_obsrvd_ch + length_spawningrearing_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_ch_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_cm_access_b + length_spawningrearing_model_cm_access_b) / NULLIF((length_spawningrearing_obsrvd_cm + length_spawningrearing_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_cm_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_co_access_b + length_spawningrearing_model_co_access_b) / NULLIF((length_spawningrearing_obsrvd_co + length_spawningrearing_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_co_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_pk_access_b + length_spawningrearing_model_pk_access_b) / NULLIF((length_spawningrearing_obsrvd_pk + length_spawningrearing_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_pk_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_sk_access_b + length_spawningrearing_model_sk_access_b) / NULLIF((length_spawningrearing_obsrvd_sk + length_spawningrearing_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_sk_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_st_access_b + length_spawningrearing_model_st_access_b) / NULLIF((length_spawningrearing_obsrvd_st + length_spawningrearing_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_st_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_wct_access_b + length_spawningrearing_model_wct_access_b) / NULLIF((length_spawningrearing_obsrvd_wct + length_spawningrearing_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_wct_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_salmon_access_b + length_spawningrearing_model_salmon_access_b) / NULLIF((length_spawningrearing_obsrvd_salmon + length_spawningrearing_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_salmon_st_access_b + length_spawningrearing_model_salmon_st_access_b) / NULLIF((length_spawningrearing_obsrvd_salmon_st + length_spawningrearing_model_salmon_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_st_access_b
   FROM sums s;


--
-- Name: wsg_linear_summary_diff; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_linear_summary_diff AS
 SELECT a.watershed_group_code,
    a.length_total,
    (a.length_naturallyaccessible_obsrvd_bt - b.length_naturallyaccessible_obsrvd_bt) AS length_naturallyaccessible_obsrvd_bt,
    (a.length_naturallyaccessible_obsrvd_bt_access_a - b.length_naturallyaccessible_obsrvd_bt_access_a) AS length_naturallyaccessible_obsrvd_bt_access_a,
    (a.length_naturallyaccessible_obsrvd_bt_access_b - b.length_naturallyaccessible_obsrvd_bt_access_b) AS length_naturallyaccessible_obsrvd_bt_access_b,
    (a.length_naturallyaccessible_model_bt - b.length_naturallyaccessible_model_bt) AS length_naturallyaccessible_model_bt,
    (a.length_naturallyaccessible_model_bt_access_a - b.length_naturallyaccessible_model_bt_access_a) AS length_naturallyaccessible_model_bt_access_a,
    (a.length_naturallyaccessible_model_bt_access_b - b.length_naturallyaccessible_model_bt_access_b) AS length_naturallyaccessible_model_bt_access_b,
    (a.length_naturallyaccessible_obsrvd_ch - b.length_naturallyaccessible_obsrvd_ch) AS length_naturallyaccessible_obsrvd_ch,
    (a.length_naturallyaccessible_obsrvd_ch_access_a - b.length_naturallyaccessible_obsrvd_ch_access_a) AS length_naturallyaccessible_obsrvd_ch_access_a,
    (a.length_naturallyaccessible_obsrvd_ch_access_b - b.length_naturallyaccessible_obsrvd_ch_access_b) AS length_naturallyaccessible_obsrvd_ch_access_b,
    (a.length_naturallyaccessible_model_ch - b.length_naturallyaccessible_model_ch) AS length_naturallyaccessible_model_ch,
    (a.length_naturallyaccessible_model_ch_access_a - b.length_naturallyaccessible_model_ch_access_a) AS length_naturallyaccessible_model_ch_access_a,
    (a.length_naturallyaccessible_model_ch_access_b - b.length_naturallyaccessible_model_ch_access_b) AS length_naturallyaccessible_model_ch_access_b,
    (a.length_naturallyaccessible_obsrvd_cm - b.length_naturallyaccessible_obsrvd_cm) AS length_naturallyaccessible_obsrvd_cm,
    (a.length_naturallyaccessible_obsrvd_cm_access_a - b.length_naturallyaccessible_obsrvd_cm_access_a) AS length_naturallyaccessible_obsrvd_cm_access_a,
    (a.length_naturallyaccessible_obsrvd_cm_access_b - b.length_naturallyaccessible_obsrvd_cm_access_b) AS length_naturallyaccessible_obsrvd_cm_access_b,
    (a.length_naturallyaccessible_model_cm - b.length_naturallyaccessible_model_cm) AS length_naturallyaccessible_model_cm,
    (a.length_naturallyaccessible_model_cm_access_a - b.length_naturallyaccessible_model_cm_access_a) AS length_naturallyaccessible_model_cm_access_a,
    (a.length_naturallyaccessible_model_cm_access_b - b.length_naturallyaccessible_model_cm_access_b) AS length_naturallyaccessible_model_cm_access_b,
    (a.length_naturallyaccessible_obsrvd_co - b.length_naturallyaccessible_obsrvd_co) AS length_naturallyaccessible_obsrvd_co,
    (a.length_naturallyaccessible_obsrvd_co_access_a - b.length_naturallyaccessible_obsrvd_co_access_a) AS length_naturallyaccessible_obsrvd_co_access_a,
    (a.length_naturallyaccessible_obsrvd_co_access_b - b.length_naturallyaccessible_obsrvd_co_access_b) AS length_naturallyaccessible_obsrvd_co_access_b,
    (a.length_naturallyaccessible_model_co - b.length_naturallyaccessible_model_co) AS length_naturallyaccessible_model_co,
    (a.length_naturallyaccessible_model_co_access_a - b.length_naturallyaccessible_model_co_access_a) AS length_naturallyaccessible_model_co_access_a,
    (a.length_naturallyaccessible_model_co_access_b - b.length_naturallyaccessible_model_co_access_b) AS length_naturallyaccessible_model_co_access_b,
    (a.length_naturallyaccessible_obsrvd_pk - b.length_naturallyaccessible_obsrvd_pk) AS length_naturallyaccessible_obsrvd_pk,
    (a.length_naturallyaccessible_obsrvd_pk_access_a - b.length_naturallyaccessible_obsrvd_pk_access_a) AS length_naturallyaccessible_obsrvd_pk_access_a,
    (a.length_naturallyaccessible_obsrvd_pk_access_b - b.length_naturallyaccessible_obsrvd_pk_access_b) AS length_naturallyaccessible_obsrvd_pk_access_b,
    (a.length_naturallyaccessible_model_pk - b.length_naturallyaccessible_model_pk) AS length_naturallyaccessible_model_pk,
    (a.length_naturallyaccessible_model_pk_access_a - b.length_naturallyaccessible_model_pk_access_a) AS length_naturallyaccessible_model_pk_access_a,
    (a.length_naturallyaccessible_model_pk_access_b - b.length_naturallyaccessible_model_pk_access_b) AS length_naturallyaccessible_model_pk_access_b,
    (a.length_naturallyaccessible_obsrvd_sk - b.length_naturallyaccessible_obsrvd_sk) AS length_naturallyaccessible_obsrvd_sk,
    (a.length_naturallyaccessible_obsrvd_sk_access_a - b.length_naturallyaccessible_obsrvd_sk_access_a) AS length_naturallyaccessible_obsrvd_sk_access_a,
    (a.length_naturallyaccessible_obsrvd_sk_access_b - b.length_naturallyaccessible_obsrvd_sk_access_b) AS length_naturallyaccessible_obsrvd_sk_access_b,
    (a.length_naturallyaccessible_model_sk - b.length_naturallyaccessible_model_sk) AS length_naturallyaccessible_model_sk,
    (a.length_naturallyaccessible_model_sk_access_a - b.length_naturallyaccessible_model_sk_access_a) AS length_naturallyaccessible_model_sk_access_a,
    (a.length_naturallyaccessible_model_sk_access_b - b.length_naturallyaccessible_model_sk_access_b) AS length_naturallyaccessible_model_sk_access_b,
    (a.length_naturallyaccessible_obsrvd_salmon - b.length_naturallyaccessible_obsrvd_salmon) AS length_naturallyaccessible_obsrvd_salmon,
    (a.length_naturallyaccessible_obsrvd_salmon_access_a - b.length_naturallyaccessible_obsrvd_salmon_access_a) AS length_naturallyaccessible_obsrvd_salmon_access_a,
    (a.length_naturallyaccessible_obsrvd_salmon_access_b - b.length_naturallyaccessible_obsrvd_salmon_access_b) AS length_naturallyaccessible_obsrvd_salmon_access_b,
    (a.length_naturallyaccessible_model_salmon - b.length_naturallyaccessible_model_salmon) AS length_naturallyaccessible_model_salmon,
    (a.length_naturallyaccessible_model_salmon_access_a - b.length_naturallyaccessible_model_salmon_access_a) AS length_naturallyaccessible_model_salmon_access_a,
    (a.length_naturallyaccessible_model_salmon_access_b - b.length_naturallyaccessible_model_salmon_access_b) AS length_naturallyaccessible_model_salmon_access_b,
    (a.length_naturallyaccessible_obsrvd_st - b.length_naturallyaccessible_obsrvd_st) AS length_naturallyaccessible_obsrvd_st,
    (a.length_naturallyaccessible_obsrvd_st_access_a - b.length_naturallyaccessible_obsrvd_st_access_a) AS length_naturallyaccessible_obsrvd_st_access_a,
    (a.length_naturallyaccessible_obsrvd_st_access_b - b.length_naturallyaccessible_obsrvd_st_access_b) AS length_naturallyaccessible_obsrvd_st_access_b,
    (a.length_naturallyaccessible_model_st - b.length_naturallyaccessible_model_st) AS length_naturallyaccessible_model_st,
    (a.length_naturallyaccessible_model_st_access_a - b.length_naturallyaccessible_model_st_access_a) AS length_naturallyaccessible_model_st_access_a,
    (a.length_naturallyaccessible_model_st_access_b - b.length_naturallyaccessible_model_st_access_b) AS length_naturallyaccessible_model_st_access_b,
    (a.length_naturallyaccessible_obsrvd_wct - b.length_naturallyaccessible_obsrvd_wct) AS length_naturallyaccessible_obsrvd_wct,
    (a.length_naturallyaccessible_obsrvd_wct_access_a - b.length_naturallyaccessible_obsrvd_wct_access_a) AS length_naturallyaccessible_obsrvd_wct_access_a,
    (a.length_naturallyaccessible_obsrvd_wct_access_b - b.length_naturallyaccessible_obsrvd_wct_access_b) AS length_naturallyaccessible_obsrvd_wct_access_b,
    (a.length_naturallyaccessible_model_wct - b.length_naturallyaccessible_model_wct) AS length_naturallyaccessible_model_wct,
    (a.length_naturallyaccessible_model_wct_access_a - b.length_naturallyaccessible_model_wct_access_a) AS length_naturallyaccessible_model_wct_access_a,
    (a.length_naturallyaccessible_model_wct_access_b - b.length_naturallyaccessible_model_wct_access_b) AS length_naturallyaccessible_model_wct_access_b,
    (a.length_spawningrearing_obsrvd_bt - b.length_spawningrearing_obsrvd_bt) AS length_spawningrearing_obsrvd_bt,
    (a.length_spawningrearing_obsrvd_bt_access_a - b.length_spawningrearing_obsrvd_bt_access_a) AS length_spawningrearing_obsrvd_bt_access_a,
    (a.length_spawningrearing_obsrvd_bt_access_b - b.length_spawningrearing_obsrvd_bt_access_b) AS length_spawningrearing_obsrvd_bt_access_b,
    (a.length_spawningrearing_model_bt - b.length_spawningrearing_model_bt) AS length_spawningrearing_model_bt,
    (a.length_spawningrearing_model_bt_access_a - b.length_spawningrearing_model_bt_access_a) AS length_spawningrearing_model_bt_access_a,
    (a.length_spawningrearing_model_bt_access_b - b.length_spawningrearing_model_bt_access_b) AS length_spawningrearing_model_bt_access_b,
    (a.length_spawningrearing_obsrvd_ch - b.length_spawningrearing_obsrvd_ch) AS length_spawningrearing_obsrvd_ch,
    (a.length_spawningrearing_obsrvd_ch_access_a - b.length_spawningrearing_obsrvd_ch_access_a) AS length_spawningrearing_obsrvd_ch_access_a,
    (a.length_spawningrearing_obsrvd_ch_access_b - b.length_spawningrearing_obsrvd_ch_access_b) AS length_spawningrearing_obsrvd_ch_access_b,
    (a.length_spawningrearing_model_ch - b.length_spawningrearing_model_ch) AS length_spawningrearing_model_ch,
    (a.length_spawningrearing_model_ch_access_a - b.length_spawningrearing_model_ch_access_a) AS length_spawningrearing_model_ch_access_a,
    (a.length_spawningrearing_model_ch_access_b - b.length_spawningrearing_model_ch_access_b) AS length_spawningrearing_model_ch_access_b,
    (a.length_spawningrearing_obsrvd_cm - b.length_spawningrearing_obsrvd_cm) AS length_spawningrearing_obsrvd_cm,
    (a.length_spawningrearing_obsrvd_cm_access_a - b.length_spawningrearing_obsrvd_cm_access_a) AS length_spawningrearing_obsrvd_cm_access_a,
    (a.length_spawningrearing_obsrvd_cm_access_b - b.length_spawningrearing_obsrvd_cm_access_b) AS length_spawningrearing_obsrvd_cm_access_b,
    (a.length_spawningrearing_model_cm - b.length_spawningrearing_model_cm) AS length_spawningrearing_model_cm,
    (a.length_spawningrearing_model_cm_access_a - b.length_spawningrearing_model_cm_access_a) AS length_spawningrearing_model_cm_access_a,
    (a.length_spawningrearing_model_cm_access_b - b.length_spawningrearing_model_cm_access_b) AS length_spawningrearing_model_cm_access_b,
    (a.length_spawningrearing_obsrvd_co - b.length_spawningrearing_obsrvd_co) AS length_spawningrearing_obsrvd_co,
    (a.length_spawningrearing_obsrvd_co_access_a - b.length_spawningrearing_obsrvd_co_access_a) AS length_spawningrearing_obsrvd_co_access_a,
    (a.length_spawningrearing_obsrvd_co_access_b - b.length_spawningrearing_obsrvd_co_access_b) AS length_spawningrearing_obsrvd_co_access_b,
    (a.length_spawningrearing_model_co - b.length_spawningrearing_model_co) AS length_spawningrearing_model_co,
    (a.length_spawningrearing_model_co_access_a - b.length_spawningrearing_model_co_access_a) AS length_spawningrearing_model_co_access_a,
    (a.length_spawningrearing_model_co_access_b - b.length_spawningrearing_model_co_access_b) AS length_spawningrearing_model_co_access_b,
    (a.length_spawningrearing_obsrvd_pk - b.length_spawningrearing_obsrvd_pk) AS length_spawningrearing_obsrvd_pk,
    (a.length_spawningrearing_obsrvd_pk_access_a - b.length_spawningrearing_obsrvd_pk_access_a) AS length_spawningrearing_obsrvd_pk_access_a,
    (a.length_spawningrearing_obsrvd_pk_access_b - b.length_spawningrearing_obsrvd_pk_access_b) AS length_spawningrearing_obsrvd_pk_access_b,
    (a.length_spawningrearing_model_pk - b.length_spawningrearing_model_pk) AS length_spawningrearing_model_pk,
    (a.length_spawningrearing_model_pk_access_a - b.length_spawningrearing_model_pk_access_a) AS length_spawningrearing_model_pk_access_a,
    (a.length_spawningrearing_model_pk_access_b - b.length_spawningrearing_model_pk_access_b) AS length_spawningrearing_model_pk_access_b,
    (a.length_spawningrearing_obsrvd_sk - b.length_spawningrearing_obsrvd_sk) AS length_spawningrearing_obsrvd_sk,
    (a.length_spawningrearing_obsrvd_sk_access_a - b.length_spawningrearing_obsrvd_sk_access_a) AS length_spawningrearing_obsrvd_sk_access_a,
    (a.length_spawningrearing_obsrvd_sk_access_b - b.length_spawningrearing_obsrvd_sk_access_b) AS length_spawningrearing_obsrvd_sk_access_b,
    (a.length_spawningrearing_model_sk - b.length_spawningrearing_model_sk) AS length_spawningrearing_model_sk,
    (a.length_spawningrearing_model_sk_access_a - b.length_spawningrearing_model_sk_access_a) AS length_spawningrearing_model_sk_access_a,
    (a.length_spawningrearing_model_sk_access_b - b.length_spawningrearing_model_sk_access_b) AS length_spawningrearing_model_sk_access_b,
    (a.length_spawningrearing_obsrvd_st - b.length_spawningrearing_obsrvd_st) AS length_spawningrearing_obsrvd_st,
    (a.length_spawningrearing_obsrvd_st_access_a - b.length_spawningrearing_obsrvd_st_access_a) AS length_spawningrearing_obsrvd_st_access_a,
    (a.length_spawningrearing_obsrvd_st_access_b - b.length_spawningrearing_obsrvd_st_access_b) AS length_spawningrearing_obsrvd_st_access_b,
    (a.length_spawningrearing_model_st - b.length_spawningrearing_model_st) AS length_spawningrearing_model_st,
    (a.length_spawningrearing_model_st_access_a - b.length_spawningrearing_model_st_access_a) AS length_spawningrearing_model_st_access_a,
    (a.length_spawningrearing_model_st_access_b - b.length_spawningrearing_model_st_access_b) AS length_spawningrearing_model_st_access_b,
    (a.length_spawningrearing_obsrvd_wct - b.length_spawningrearing_obsrvd_wct) AS length_spawningrearing_obsrvd_wct,
    (a.length_spawningrearing_obsrvd_wct_access_a - b.length_spawningrearing_obsrvd_wct_access_a) AS length_spawningrearing_obsrvd_wct_access_a,
    (a.length_spawningrearing_obsrvd_wct_access_b - b.length_spawningrearing_obsrvd_wct_access_b) AS length_spawningrearing_obsrvd_wct_access_b,
    (a.length_spawningrearing_model_wct - b.length_spawningrearing_model_wct) AS length_spawningrearing_model_wct,
    (a.length_spawningrearing_model_wct_access_a - b.length_spawningrearing_model_wct_access_a) AS length_spawningrearing_model_wct_access_a,
    (a.length_spawningrearing_model_wct_access_b - b.length_spawningrearing_model_wct_access_b) AS length_spawningrearing_model_wct_access_b,
    (a.length_spawningrearing_obsrvd_salmon - b.length_spawningrearing_obsrvd_salmon) AS length_spawningrearing_obsrvd_salmon,
    (a.length_spawningrearing_obsrvd_salmon_access_a - b.length_spawningrearing_obsrvd_salmon_access_a) AS length_spawningrearing_obsrvd_salmon_access_a,
    (a.length_spawningrearing_obsrvd_salmon_access_b - b.length_spawningrearing_obsrvd_salmon_access_b) AS length_spawningrearing_obsrvd_salmon_access_b,
    (a.length_spawningrearing_model_salmon - b.length_spawningrearing_model_salmon) AS length_spawningrearing_model_salmon,
    (a.length_spawningrearing_model_salmon_access_a - b.length_spawningrearing_model_salmon_access_a) AS length_spawningrearing_model_salmon_access_a,
    (a.length_spawningrearing_model_salmon_access_b - b.length_spawningrearing_model_salmon_access_b) AS length_spawningrearing_model_salmon_access_b,
    (a.length_spawningrearing_obsrvd_salmon_st - b.length_spawningrearing_obsrvd_salmon_st) AS length_spawningrearing_obsrvd_salmon_st,
    (a.length_spawningrearing_obsrvd_salmon_st_access_a - b.length_spawningrearing_obsrvd_salmon_st_access_a) AS length_spawningrearing_obsrvd_salmon_st_access_a,
    (a.length_spawningrearing_obsrvd_salmon_st_access_b - b.length_spawningrearing_obsrvd_salmon_st_access_b) AS length_spawningrearing_obsrvd_salmon_st_access_b,
    (a.length_spawningrearing_model_salmon_st - b.length_spawningrearing_model_salmon_st) AS length_spawningrearing_model_salmon_st,
    (a.length_spawningrearing_model_salmon_st_access_a - b.length_spawningrearing_model_salmon_st_access_a) AS length_spawningrearing_model_salmon_st_access_a,
    (a.length_spawningrearing_model_salmon_st_access_b - b.length_spawningrearing_model_salmon_st_access_b) AS length_spawningrearing_model_salmon_st_access_b,
    (a.pct_naturallyaccessible_bt_access_b - b.pct_naturallyaccessible_bt_access_b) AS pct_naturallyaccessible_bt_access_b,
    (a.pct_naturallyaccessible_ch_access_b - b.pct_naturallyaccessible_ch_access_b) AS pct_naturallyaccessible_ch_access_b,
    (a.pct_naturallyaccessible_cm_access_b - b.pct_naturallyaccessible_cm_access_b) AS pct_naturallyaccessible_cm_access_b,
    (a.pct_naturallyaccessible_co_access_b - b.pct_naturallyaccessible_co_access_b) AS pct_naturallyaccessible_co_access_b,
    (a.pct_naturallyaccessible_pk_access_b - b.pct_naturallyaccessible_pk_access_b) AS pct_naturallyaccessible_pk_access_b,
    (a.pct_naturallyaccessible_sk_access_b - b.pct_naturallyaccessible_sk_access_b) AS pct_naturallyaccessible_sk_access_b,
    (a.pct_naturallyaccessible_salmon_access_b - b.pct_naturallyaccessible_salmon_access_b) AS pct_naturallyaccessible_salmon_access_b,
    (a.pct_naturallyaccessible_st_access_b - b.pct_naturallyaccessible_st_access_b) AS pct_naturallyaccessible_st_access_b,
    (a.pct_naturallyaccessible_wct_access_b - b.pct_naturallyaccessible_wct_access_b) AS pct_naturallyaccessible_wct_access_b,
    (a.pct_spawningrearing_bt_access_b - b.pct_spawningrearing_bt_access_b) AS pct_spawningrearing_bt_access_b,
    (a.pct_spawningrearing_ch_access_b - b.pct_spawningrearing_ch_access_b) AS pct_spawningrearing_ch_access_b,
    (a.pct_spawningrearing_cm_access_b - b.pct_spawningrearing_cm_access_b) AS pct_spawningrearing_cm_access_b,
    (a.pct_spawningrearing_co_access_b - b.pct_spawningrearing_co_access_b) AS pct_spawningrearing_co_access_b,
    (a.pct_spawningrearing_pk_access_b - b.pct_spawningrearing_pk_access_b) AS pct_spawningrearing_pk_access_b,
    (a.pct_spawningrearing_sk_access_b - b.pct_spawningrearing_sk_access_b) AS pct_spawningrearing_sk_access_b,
    (a.pct_spawningrearing_st_access_b - b.pct_spawningrearing_st_access_b) AS pct_spawningrearing_st_access_b,
    (a.pct_spawningrearing_wct_access_b - b.pct_spawningrearing_wct_access_b) AS pct_spawningrearing_wct_access_b,
    (a.pct_spawningrearing_salmon_access_b - b.pct_spawningrearing_salmon_access_b) AS pct_spawningrearing_salmon_access_b,
    (a.pct_spawningrearing_salmon_st_access_b - b.pct_spawningrearing_salmon_st_access_b) AS pct_spawningrearing_salmon_st_access_b
   FROM (bcfishpass.wsg_linear_summary_current a
     JOIN bcfishpass.wsg_linear_summary_previous b ON (((a.watershed_group_code)::text = (b.watershed_group_code)::text)))
  ORDER BY a.watershed_group_code;


--
-- Name: wsg_species_presence; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wsg_species_presence (
    watershed_group_code character varying(4),
    bt boolean,
    ch boolean,
    cm boolean,
    co boolean,
    ct boolean,
    dv boolean,
    gr boolean,
    pk boolean,
    rb boolean,
    sk boolean,
    st boolean,
    wct boolean,
    notes text
);


--
-- Name: private private_id; Type: DEFAULT; Schema: bcdata; Owner: -
--

ALTER TABLE ONLY bcdata.private ALTER COLUMN private_id SET DEFAULT nextval('bcdata.private_private_id_seq'::regclass);


--
-- Name: log model_run_id; Type: DEFAULT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log ALTER COLUMN model_run_id SET DEFAULT nextval('bcfishpass.log_model_run_id_seq'::regclass);


--
-- Name: modelled_stream_crossings modelled_crossing_id; Type: DEFAULT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.modelled_stream_crossings ALTER COLUMN modelled_crossing_id SET DEFAULT nextval('bcfishpass.modelled_stream_crossings_modelled_crossing_id_seq'::regclass);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: bcdata; Owner: -
--

ALTER TABLE ONLY bcdata.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (table_name);


--
-- Name: private private_pkey; Type: CONSTRAINT; Schema: bcdata; Owner: -
--

ALTER TABLE ONLY bcdata.private
    ADD CONSTRAINT private_pkey PRIMARY KEY (private_id);


--
-- Name: fiss_fish_obsrvtn_events fiss_fish_obsrvtn_events_pkey; Type: CONSTRAINT; Schema: bcfishobs; Owner: -
--

ALTER TABLE ONLY bcfishobs.fiss_fish_obsrvtn_events
    ADD CONSTRAINT fiss_fish_obsrvtn_events_pkey PRIMARY KEY (fish_obsrvtn_event_id);


--
-- Name: fiss_fish_obsrvtn_unmatched fiss_fish_obsrvtn_unmatched_pkey; Type: CONSTRAINT; Schema: bcfishobs; Owner: -
--

ALTER TABLE ONLY bcfishobs.fiss_fish_obsrvtn_unmatched
    ADD CONSTRAINT fiss_fish_obsrvtn_unmatched_pkey PRIMARY KEY (fish_obsrvtn_pnt_distinct_id);


--
-- Name: observations observations_pkey; Type: CONSTRAINT; Schema: bcfishobs; Owner: -
--

ALTER TABLE ONLY bcfishobs.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (observation_key);


--
-- Name: barriers_anthropogenic barriers_anthropogenic_blue_line_key_downstream_route_measu_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_anthropogenic
    ADD CONSTRAINT barriers_anthropogenic_blue_line_key_downstream_route_measu_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_anthropogenic_dnstr_barriers_anthropogenic barriers_anthropogenic_dnstr_barriers_anthropogenic_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic
    ADD CONSTRAINT barriers_anthropogenic_dnstr_barriers_anthropogenic_pkey PRIMARY KEY (barriers_anthropogenic_id);


--
-- Name: barriers_anthropogenic barriers_anthropogenic_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_anthropogenic
    ADD CONSTRAINT barriers_anthropogenic_pkey PRIMARY KEY (barriers_anthropogenic_id);


--
-- Name: barriers_bt barriers_bt_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_bt
    ADD CONSTRAINT barriers_bt_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_bt barriers_bt_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_bt
    ADD CONSTRAINT barriers_bt_pkey PRIMARY KEY (barriers_bt_id);


--
-- Name: barriers_ch_cm_co_pk_sk barriers_ch_cm_co_pk_sk_blue_line_key_downstream_route_meas_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_ch_cm_co_pk_sk
    ADD CONSTRAINT barriers_ch_cm_co_pk_sk_blue_line_key_downstream_route_meas_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_ch_cm_co_pk_sk barriers_ch_cm_co_pk_sk_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_ch_cm_co_pk_sk
    ADD CONSTRAINT barriers_ch_cm_co_pk_sk_pkey PRIMARY KEY (barriers_ch_cm_co_pk_sk_id);


--
-- Name: barriers_ct_dv_rb barriers_ct_dv_rb_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_ct_dv_rb
    ADD CONSTRAINT barriers_ct_dv_rb_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_ct_dv_rb barriers_ct_dv_rb_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_ct_dv_rb
    ADD CONSTRAINT barriers_ct_dv_rb_pkey PRIMARY KEY (barriers_ct_dv_rb_id);


--
-- Name: barriers_dams barriers_dams_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_dams
    ADD CONSTRAINT barriers_dams_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_dams_hydro barriers_dams_hydro_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_dams_hydro
    ADD CONSTRAINT barriers_dams_hydro_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_dams_hydro barriers_dams_hydro_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_dams_hydro
    ADD CONSTRAINT barriers_dams_hydro_pkey PRIMARY KEY (barriers_dams_hydro_id);


--
-- Name: barriers_dams barriers_dams_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_dams
    ADD CONSTRAINT barriers_dams_pkey PRIMARY KEY (barriers_dams_id);


--
-- Name: barriers_falls barriers_falls_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_falls
    ADD CONSTRAINT barriers_falls_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_falls barriers_falls_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_falls
    ADD CONSTRAINT barriers_falls_pkey PRIMARY KEY (barriers_falls_id);


--
-- Name: barriers_gradient barriers_gradient_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_gradient
    ADD CONSTRAINT barriers_gradient_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_gradient barriers_gradient_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_gradient
    ADD CONSTRAINT barriers_gradient_pkey PRIMARY KEY (barriers_gradient_id);


--
-- Name: barriers_pscis barriers_pscis_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_pscis
    ADD CONSTRAINT barriers_pscis_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_pscis barriers_pscis_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_pscis
    ADD CONSTRAINT barriers_pscis_pkey PRIMARY KEY (barriers_pscis_id);


--
-- Name: barriers_remediations barriers_remediations_blue_line_key_downstream_route_measur_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_remediations
    ADD CONSTRAINT barriers_remediations_blue_line_key_downstream_route_measur_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_remediations barriers_remediations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_remediations
    ADD CONSTRAINT barriers_remediations_pkey PRIMARY KEY (barriers_remediations_id);


--
-- Name: barriers_st barriers_st_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_st
    ADD CONSTRAINT barriers_st_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_st barriers_st_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_st
    ADD CONSTRAINT barriers_st_pkey PRIMARY KEY (barriers_st_id);


--
-- Name: barriers_subsurfaceflow barriers_subsurfaceflow_blue_line_key_downstream_route_meas_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_subsurfaceflow
    ADD CONSTRAINT barriers_subsurfaceflow_blue_line_key_downstream_route_meas_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_subsurfaceflow barriers_subsurfaceflow_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_subsurfaceflow
    ADD CONSTRAINT barriers_subsurfaceflow_pkey PRIMARY KEY (barriers_subsurfaceflow_id);


--
-- Name: barriers_user_definite barriers_user_definite_blue_line_key_downstream_route_measu_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_user_definite
    ADD CONSTRAINT barriers_user_definite_blue_line_key_downstream_route_measu_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_user_definite barriers_user_definite_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_user_definite
    ADD CONSTRAINT barriers_user_definite_pkey PRIMARY KEY (barriers_user_definite_id);


--
-- Name: barriers_wct barriers_wct_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_wct
    ADD CONSTRAINT barriers_wct_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_wct barriers_wct_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_wct
    ADD CONSTRAINT barriers_wct_pkey PRIMARY KEY (barriers_wct_id);


--
-- Name: cabd_additions cabd_additions_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.cabd_additions
    ADD CONSTRAINT cabd_additions_pkey PRIMARY KEY (blue_line_key, downstream_route_measure);


--
-- Name: cabd_exclusions cabd_exclusions_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.cabd_exclusions
    ADD CONSTRAINT cabd_exclusions_pkey PRIMARY KEY (cabd_id);


--
-- Name: cabd_passability_status_updates cabd_passability_status_updates_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.cabd_passability_status_updates
    ADD CONSTRAINT cabd_passability_status_updates_pkey PRIMARY KEY (cabd_id);


--
-- Name: crossings crossings_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: crossings_dnstr_barriers_anthropogenic crossings_dnstr_barriers_anthropogenic_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_dnstr_barriers_anthropogenic
    ADD CONSTRAINT crossings_dnstr_barriers_anthropogenic_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_dnstr_crossings crossings_dnstr_crossings_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_dnstr_crossings
    ADD CONSTRAINT crossings_dnstr_crossings_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_dnstr_observations crossings_dnstr_observations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_dnstr_observations
    ADD CONSTRAINT crossings_dnstr_observations_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings crossings_modelled_crossing_id_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_modelled_crossing_id_key UNIQUE (modelled_crossing_id);


--
-- Name: crossings crossings_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings crossings_stream_crossing_id_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_stream_crossing_id_key UNIQUE (stream_crossing_id);


--
-- Name: crossings_upstr_barriers_anthropogenic crossings_upstr_barriers_anthropogenic_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstr_barriers_anthropogenic
    ADD CONSTRAINT crossings_upstr_barriers_anthropogenic_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_upstr_observations crossings_upstr_observations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstr_observations
    ADD CONSTRAINT crossings_upstr_observations_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_upstream_access crossings_upstream_access_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstream_access
    ADD CONSTRAINT crossings_upstream_access_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_upstream_habitat crossings_upstream_habitat_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstream_habitat
    ADD CONSTRAINT crossings_upstream_habitat_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_upstream_habitat_wcrp crossings_upstream_habitat_wcrp_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstream_habitat_wcrp
    ADD CONSTRAINT crossings_upstream_habitat_wcrp_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings crossings_user_barrier_anthropogenic_id_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_user_barrier_anthropogenic_id_key UNIQUE (user_crossing_misc_id);


--
-- Name: dams dams_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.dams
    ADD CONSTRAINT dams_pkey PRIMARY KEY (dam_id);


--
-- Name: dfo_known_sockeye_lakes dfo_known_sockeye_lakes_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.dfo_known_sockeye_lakes
    ADD CONSTRAINT dfo_known_sockeye_lakes_pkey PRIMARY KEY (waterbody_poly_id);


--
-- Name: falls falls_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.falls
    ADD CONSTRAINT falls_pkey PRIMARY KEY (falls_id);


--
-- Name: gradient_barriers gradient_barriers_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.gradient_barriers
    ADD CONSTRAINT gradient_barriers_pkey PRIMARY KEY (gradient_barrier_id);


--
-- Name: habitat_linear_bt habitat_linear_bt_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_bt
    ADD CONSTRAINT habitat_linear_bt_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_ch habitat_linear_ch_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_ch
    ADD CONSTRAINT habitat_linear_ch_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_cm habitat_linear_cm_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_cm
    ADD CONSTRAINT habitat_linear_cm_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_co habitat_linear_co_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_co
    ADD CONSTRAINT habitat_linear_co_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_pk habitat_linear_pk_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_pk
    ADD CONSTRAINT habitat_linear_pk_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_sk habitat_linear_sk_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_sk
    ADD CONSTRAINT habitat_linear_sk_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_st habitat_linear_st_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_st
    ADD CONSTRAINT habitat_linear_st_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_wct habitat_linear_wct_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_wct
    ADD CONSTRAINT habitat_linear_wct_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: log_objectstorage log_objectstorage_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_objectstorage
    ADD CONSTRAINT log_objectstorage_pkey PRIMARY KEY (model_run_id, object_name);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (model_run_id);


--
-- Name: log_replication log_replication_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_replication
    ADD CONSTRAINT log_replication_pkey PRIMARY KEY (object_name);


--
-- Name: modelled_stream_crossings modelled_stream_crossings_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.modelled_stream_crossings
    ADD CONSTRAINT modelled_stream_crossings_pkey PRIMARY KEY (modelled_crossing_id);


--
-- Name: observation_exclusions observation_exclusions_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.observation_exclusions
    ADD CONSTRAINT observation_exclusions_pkey PRIMARY KEY (observation_key);


--
-- Name: observations observations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (observation_key);


--
-- Name: pscis pscis_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis
    ADD CONSTRAINT pscis_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: pscis_modelledcrossings_streams_xref pscis_modelledcrossings_streams_xref_modelled_crossing_id_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis_modelledcrossings_streams_xref
    ADD CONSTRAINT pscis_modelledcrossings_streams_xref_modelled_crossing_id_key UNIQUE (modelled_crossing_id);


--
-- Name: pscis_modelledcrossings_streams_xref pscis_modelledcrossings_streams_xref_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis_modelledcrossings_streams_xref
    ADD CONSTRAINT pscis_modelledcrossings_streams_xref_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: pscis_not_matched_to_streams pscis_not_matched_to_streams_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis_not_matched_to_streams
    ADD CONSTRAINT pscis_not_matched_to_streams_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: pscis pscis_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis
    ADD CONSTRAINT pscis_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: pscis_points_all pscis_points_all_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis_points_all
    ADD CONSTRAINT pscis_points_all_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: qa_naturalbarriers_ch_cm_co_pk_sk_st qa_naturalbarriers_ch_cm_co_pk_sk_st_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk_st
    ADD CONSTRAINT qa_naturalbarriers_ch_cm_co_pk_sk_st_pkey PRIMARY KEY (barrier_id);


--
-- Name: qa_observations_ch_cm_co_pk_sk_st qa_observations_ch_cm_co_pk_sk_st_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.qa_observations_ch_cm_co_pk_sk_st
    ADD CONSTRAINT qa_observations_ch_cm_co_pk_sk_st_pkey PRIMARY KEY (observation_key);


--
-- Name: streams_access streams_access_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_access
    ADD CONSTRAINT streams_access_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_dnstr_barriers streams_dnstr_barriers_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_dnstr_barriers
    ADD CONSTRAINT streams_dnstr_barriers_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_dnstr_barriers_remediations streams_dnstr_barriers_remediations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_dnstr_barriers_remediations
    ADD CONSTRAINT streams_dnstr_barriers_remediations_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_dnstr_crossings streams_dnstr_crossings_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_dnstr_crossings
    ADD CONSTRAINT streams_dnstr_crossings_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_dnstr_species streams_dnstr_species_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_dnstr_species
    ADD CONSTRAINT streams_dnstr_species_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_habitat_known streams_habitat_known_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_habitat_known
    ADD CONSTRAINT streams_habitat_known_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_habitat_linear streams_habitat_linear_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_habitat_linear
    ADD CONSTRAINT streams_habitat_linear_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_mapping_code streams_mapping_code_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_mapping_code
    ADD CONSTRAINT streams_mapping_code_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams streams_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams
    ADD CONSTRAINT streams_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_upstr_observations streams_upstr_observations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_upstr_observations
    ADD CONSTRAINT streams_upstr_observations_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: user_barriers_definite_control user_barriers_definite_control_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_barriers_definite_control
    ADD CONSTRAINT user_barriers_definite_control_pkey PRIMARY KEY (blue_line_key, downstream_route_measure);


--
-- Name: user_barriers_definite user_barriers_definite_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_barriers_definite
    ADD CONSTRAINT user_barriers_definite_pkey PRIMARY KEY (blue_line_key, downstream_route_measure);


--
-- Name: user_crossings_misc user_crossings_misc_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_crossings_misc
    ADD CONSTRAINT user_crossings_misc_pkey PRIMARY KEY (user_crossing_misc_id);


--
-- Name: user_habitat_classification_endpoints user_habitat_classification_endpoints_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification_endpoints
    ADD CONSTRAINT user_habitat_classification_endpoints_pkey PRIMARY KEY (blue_line_key, downstream_route_measure);


--
-- Name: user_habitat_classification user_habitat_classification_temp_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification
    ADD CONSTRAINT user_habitat_classification_temp_pkey PRIMARY KEY (blue_line_key, downstream_route_measure, upstream_route_measure, species_code);


--
-- Name: user_habitat_codes user_habitat_codes_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_codes
    ADD CONSTRAINT user_habitat_codes_pkey PRIMARY KEY (habitat_code);


--
-- Name: user_modelled_crossing_fixes user_modelled_crossing_fixes_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_modelled_crossing_fixes
    ADD CONSTRAINT user_modelled_crossing_fixes_pkey PRIMARY KEY (modelled_crossing_id);


--
-- Name: user_pscis_barrier_status user_pscis_barrier_status_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_pscis_barrier_status
    ADD CONSTRAINT user_pscis_barrier_status_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: wcrp_confirmed_barriers wcrp_confirmed_barriers_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_confirmed_barriers
    ADD CONSTRAINT wcrp_confirmed_barriers_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: wcrp_data_deficient_structures wcrp_data_deficient_structures_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_data_deficient_structures
    ADD CONSTRAINT wcrp_data_deficient_structures_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: wcrp_excluded_structures wcrp_excluded_structures_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_excluded_structures
    ADD CONSTRAINT wcrp_excluded_structures_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: wcrp_ranked_barriers wcrp_ranked_barriers_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_ranked_barriers
    ADD CONSTRAINT wcrp_ranked_barriers_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: wcrp_rehabilitiated_structures wcrp_rehabilitiated_structures_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_rehabilitiated_structures
    ADD CONSTRAINT wcrp_rehabilitiated_structures_pkey PRIMARY KEY (aggregated_crossing_id);


--
-- Name: ften_range_poly_carto_vw_geom_idx; Type: INDEX; Schema: bcdata; Owner: -
--

CREATE INDEX ften_range_poly_carto_vw_geom_idx ON bcdata.ften_range_poly_carto_vw USING gist (geom);


--
-- Name: parks_geom_idx; Type: INDEX; Schema: bcdata; Owner: -
--

CREATE INDEX parks_geom_idx ON bcdata.parks USING gist (geom);


--
-- Name: fiss_fish_obsrvtn_events_blue_line_key_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_events_blue_line_key_idx ON bcfishobs.fiss_fish_obsrvtn_events USING btree (blue_line_key);


--
-- Name: fiss_fish_obsrvtn_events_geom_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_events_geom_idx ON bcfishobs.fiss_fish_obsrvtn_events USING gist (geom);


--
-- Name: fiss_fish_obsrvtn_events_linear_feature_id_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_events_linear_feature_id_idx ON bcfishobs.fiss_fish_obsrvtn_events USING btree (linear_feature_id);


--
-- Name: fiss_fish_obsrvtn_events_localcode_ltree_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_events_localcode_ltree_idx ON bcfishobs.fiss_fish_obsrvtn_events USING btree (localcode_ltree);


--
-- Name: fiss_fish_obsrvtn_events_localcode_ltree_idx1; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_events_localcode_ltree_idx1 ON bcfishobs.fiss_fish_obsrvtn_events USING gist (localcode_ltree);


--
-- Name: fiss_fish_obsrvtn_events_obs_ids_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_events_obs_ids_idx ON bcfishobs.fiss_fish_obsrvtn_events USING gist (obs_ids public.gist__intbig_ops);


--
-- Name: fiss_fish_obsrvtn_events_species_ids_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_events_species_ids_idx ON bcfishobs.fiss_fish_obsrvtn_events USING gist (species_ids public.gist__intbig_ops);


--
-- Name: fiss_fish_obsrvtn_events_wscode_ltree_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_events_wscode_ltree_idx ON bcfishobs.fiss_fish_obsrvtn_events USING btree (wscode_ltree);


--
-- Name: fiss_fish_obsrvtn_events_wscode_ltree_idx1; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_events_wscode_ltree_idx1 ON bcfishobs.fiss_fish_obsrvtn_events USING gist (wscode_ltree);


--
-- Name: fiss_fish_obsrvtn_unmatched_geom_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX fiss_fish_obsrvtn_unmatched_geom_idx ON bcfishobs.fiss_fish_obsrvtn_unmatched USING gist (geom);


--
-- Name: observations_blue_line_key_downstream_route_measure_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX observations_blue_line_key_downstream_route_measure_idx ON bcfishobs.observations USING btree (blue_line_key, downstream_route_measure);


--
-- Name: observations_blue_line_key_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX observations_blue_line_key_idx ON bcfishobs.observations USING btree (blue_line_key);


--
-- Name: observations_geom_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX observations_geom_idx ON bcfishobs.observations USING gist (geom);


--
-- Name: observations_linear_feature_id_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX observations_linear_feature_id_idx ON bcfishobs.observations USING btree (linear_feature_id);


--
-- Name: observations_localcode_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX observations_localcode_idx ON bcfishobs.observations USING btree (localcode);


--
-- Name: observations_localcode_idx1; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX observations_localcode_idx1 ON bcfishobs.observations USING gist (localcode);


--
-- Name: observations_wscode_idx; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX observations_wscode_idx ON bcfishobs.observations USING btree (wscode);


--
-- Name: observations_wscode_idx1; Type: INDEX; Schema: bcfishobs; Owner: -
--

CREATE INDEX observations_wscode_idx1 ON bcfishobs.observations USING gist (wscode);


--
-- Name: br_anthropogenic_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_blk_meas_idx ON bcfishpass.barriers_anthropogenic USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_anthropogenic_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_blue_line_key_idx ON bcfishpass.barriers_anthropogenic USING btree (blue_line_key);


--
-- Name: br_anthropogenic_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_geom_idx ON bcfishpass.barriers_anthropogenic USING gist (geom);


--
-- Name: br_anthropogenic_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_linear_feature_id_idx ON bcfishpass.barriers_anthropogenic USING btree (linear_feature_id);


--
-- Name: br_anthropogenic_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_localcode_ltree_bidx ON bcfishpass.barriers_anthropogenic USING btree (localcode_ltree);


--
-- Name: br_anthropogenic_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_localcode_ltree_gidx ON bcfishpass.barriers_anthropogenic USING gist (localcode_ltree);


--
-- Name: br_anthropogenic_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_watershed_group_code_idx ON bcfishpass.barriers_anthropogenic USING btree (watershed_group_code);


--
-- Name: br_anthropogenic_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_wscode_ltree_bidx ON bcfishpass.barriers_anthropogenic USING btree (wscode_ltree);


--
-- Name: br_anthropogenic_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_wscode_ltree_gidx ON bcfishpass.barriers_anthropogenic USING gist (wscode_ltree);


--
-- Name: br_anthropogenic_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_wskey_idx ON bcfishpass.barriers_anthropogenic USING btree (watershed_key);


--
-- Name: br_bt_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_blk_meas_idx ON bcfishpass.barriers_bt USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_bt_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_blue_line_key_idx ON bcfishpass.barriers_bt USING btree (blue_line_key);


--
-- Name: br_bt_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_geom_idx ON bcfishpass.barriers_bt USING gist (geom);


--
-- Name: br_bt_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_linear_feature_id_idx ON bcfishpass.barriers_bt USING btree (linear_feature_id);


--
-- Name: br_bt_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_localcode_ltree_bidx ON bcfishpass.barriers_bt USING btree (localcode_ltree);


--
-- Name: br_bt_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_localcode_ltree_gidx ON bcfishpass.barriers_bt USING gist (localcode_ltree);


--
-- Name: br_bt_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_watershed_group_code_idx ON bcfishpass.barriers_bt USING btree (watershed_group_code);


--
-- Name: br_bt_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_wscode_ltree_bidx ON bcfishpass.barriers_bt USING btree (wscode_ltree);


--
-- Name: br_bt_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_wscode_ltree_gidx ON bcfishpass.barriers_bt USING gist (wscode_ltree);


--
-- Name: br_bt_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_wskey_idx ON bcfishpass.barriers_bt USING btree (watershed_key);


--
-- Name: br_ch_cm_co_pk_sk_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_blk_meas_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_ch_cm_co_pk_sk_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_blue_line_key_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (blue_line_key);


--
-- Name: br_ch_cm_co_pk_sk_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_geom_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING gist (geom);


--
-- Name: br_ch_cm_co_pk_sk_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_linear_feature_id_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (linear_feature_id);


--
-- Name: br_ch_cm_co_pk_sk_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_localcode_ltree_bidx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (localcode_ltree);


--
-- Name: br_ch_cm_co_pk_sk_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_localcode_ltree_gidx ON bcfishpass.barriers_ch_cm_co_pk_sk USING gist (localcode_ltree);


--
-- Name: br_ch_cm_co_pk_sk_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_watershed_group_code_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (watershed_group_code);


--
-- Name: br_ch_cm_co_pk_sk_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_wscode_ltree_bidx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (wscode_ltree);


--
-- Name: br_ch_cm_co_pk_sk_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_wscode_ltree_gidx ON bcfishpass.barriers_ch_cm_co_pk_sk USING gist (wscode_ltree);


--
-- Name: br_ch_cm_co_pk_sk_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_wskey_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (watershed_key);


--
-- Name: br_ct_dv_rb_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_blk_meas_idx ON bcfishpass.barriers_ct_dv_rb USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_ct_dv_rb_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_blue_line_key_idx ON bcfishpass.barriers_ct_dv_rb USING btree (blue_line_key);


--
-- Name: br_ct_dv_rb_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_geom_idx ON bcfishpass.barriers_ct_dv_rb USING gist (geom);


--
-- Name: br_ct_dv_rb_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_linear_feature_id_idx ON bcfishpass.barriers_ct_dv_rb USING btree (linear_feature_id);


--
-- Name: br_ct_dv_rb_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_localcode_ltree_bidx ON bcfishpass.barriers_ct_dv_rb USING btree (localcode_ltree);


--
-- Name: br_ct_dv_rb_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_localcode_ltree_gidx ON bcfishpass.barriers_ct_dv_rb USING gist (localcode_ltree);


--
-- Name: br_ct_dv_rb_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_watershed_group_code_idx ON bcfishpass.barriers_ct_dv_rb USING btree (watershed_group_code);


--
-- Name: br_ct_dv_rb_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_wscode_ltree_bidx ON bcfishpass.barriers_ct_dv_rb USING btree (wscode_ltree);


--
-- Name: br_ct_dv_rb_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_wscode_ltree_gidx ON bcfishpass.barriers_ct_dv_rb USING gist (wscode_ltree);


--
-- Name: br_ct_dv_rb_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_wskey_idx ON bcfishpass.barriers_ct_dv_rb USING btree (watershed_key);


--
-- Name: br_dams_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_blk_meas_idx ON bcfishpass.barriers_dams USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_dams_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_blue_line_key_idx ON bcfishpass.barriers_dams USING btree (blue_line_key);


--
-- Name: br_dams_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_geom_idx ON bcfishpass.barriers_dams USING gist (geom);


--
-- Name: br_dams_hydro_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_blk_meas_idx ON bcfishpass.barriers_dams_hydro USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_dams_hydro_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_blue_line_key_idx ON bcfishpass.barriers_dams_hydro USING btree (blue_line_key);


--
-- Name: br_dams_hydro_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_geom_idx ON bcfishpass.barriers_dams_hydro USING gist (geom);


--
-- Name: br_dams_hydro_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_linear_feature_id_idx ON bcfishpass.barriers_dams_hydro USING btree (linear_feature_id);


--
-- Name: br_dams_hydro_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_localcode_ltree_bidx ON bcfishpass.barriers_dams_hydro USING btree (localcode_ltree);


--
-- Name: br_dams_hydro_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_localcode_ltree_gidx ON bcfishpass.barriers_dams_hydro USING gist (localcode_ltree);


--
-- Name: br_dams_hydro_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_watershed_group_code_idx ON bcfishpass.barriers_dams_hydro USING btree (watershed_group_code);


--
-- Name: br_dams_hydro_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_wscode_ltree_bidx ON bcfishpass.barriers_dams_hydro USING btree (wscode_ltree);


--
-- Name: br_dams_hydro_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_wscode_ltree_gidx ON bcfishpass.barriers_dams_hydro USING gist (wscode_ltree);


--
-- Name: br_dams_hydro_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_wskey_idx ON bcfishpass.barriers_dams_hydro USING btree (watershed_key);


--
-- Name: br_dams_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_linear_feature_id_idx ON bcfishpass.barriers_dams USING btree (linear_feature_id);


--
-- Name: br_dams_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_localcode_ltree_bidx ON bcfishpass.barriers_dams USING btree (localcode_ltree);


--
-- Name: br_dams_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_localcode_ltree_gidx ON bcfishpass.barriers_dams USING gist (localcode_ltree);


--
-- Name: br_dams_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_watershed_group_code_idx ON bcfishpass.barriers_dams USING btree (watershed_group_code);


--
-- Name: br_dams_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_wscode_ltree_bidx ON bcfishpass.barriers_dams USING btree (wscode_ltree);


--
-- Name: br_dams_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_wscode_ltree_gidx ON bcfishpass.barriers_dams USING gist (wscode_ltree);


--
-- Name: br_dams_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_wskey_idx ON bcfishpass.barriers_dams USING btree (watershed_key);


--
-- Name: br_falls_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_blk_meas_idx ON bcfishpass.barriers_falls USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_falls_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_blue_line_key_idx ON bcfishpass.barriers_falls USING btree (blue_line_key);


--
-- Name: br_falls_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_geom_idx ON bcfishpass.barriers_falls USING gist (geom);


--
-- Name: br_falls_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_linear_feature_id_idx ON bcfishpass.barriers_falls USING btree (linear_feature_id);


--
-- Name: br_falls_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_localcode_ltree_bidx ON bcfishpass.barriers_falls USING btree (localcode_ltree);


--
-- Name: br_falls_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_localcode_ltree_gidx ON bcfishpass.barriers_falls USING gist (localcode_ltree);


--
-- Name: br_falls_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_watershed_group_code_idx ON bcfishpass.barriers_falls USING btree (watershed_group_code);


--
-- Name: br_falls_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_wscode_ltree_bidx ON bcfishpass.barriers_falls USING btree (wscode_ltree);


--
-- Name: br_falls_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_wscode_ltree_gidx ON bcfishpass.barriers_falls USING gist (wscode_ltree);


--
-- Name: br_falls_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_wskey_idx ON bcfishpass.barriers_falls USING btree (watershed_key);


--
-- Name: br_gradient_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_blk_meas_idx ON bcfishpass.barriers_gradient USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_gradient_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_blue_line_key_idx ON bcfishpass.barriers_gradient USING btree (blue_line_key);


--
-- Name: br_gradient_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_geom_idx ON bcfishpass.barriers_gradient USING gist (geom);


--
-- Name: br_gradient_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_linear_feature_id_idx ON bcfishpass.barriers_gradient USING btree (linear_feature_id);


--
-- Name: br_gradient_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_localcode_ltree_bidx ON bcfishpass.barriers_gradient USING btree (localcode_ltree);


--
-- Name: br_gradient_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_localcode_ltree_gidx ON bcfishpass.barriers_gradient USING gist (localcode_ltree);


--
-- Name: br_gradient_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_watershed_group_code_idx ON bcfishpass.barriers_gradient USING btree (watershed_group_code);


--
-- Name: br_gradient_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_wscode_ltree_bidx ON bcfishpass.barriers_gradient USING btree (wscode_ltree);


--
-- Name: br_gradient_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_wscode_ltree_gidx ON bcfishpass.barriers_gradient USING gist (wscode_ltree);


--
-- Name: br_gradient_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_wskey_idx ON bcfishpass.barriers_gradient USING btree (watershed_key);


--
-- Name: br_pscis_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_blk_meas_idx ON bcfishpass.barriers_pscis USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_pscis_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_blue_line_key_idx ON bcfishpass.barriers_pscis USING btree (blue_line_key);


--
-- Name: br_pscis_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_geom_idx ON bcfishpass.barriers_pscis USING gist (geom);


--
-- Name: br_pscis_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_linear_feature_id_idx ON bcfishpass.barriers_pscis USING btree (linear_feature_id);


--
-- Name: br_pscis_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_localcode_ltree_bidx ON bcfishpass.barriers_pscis USING btree (localcode_ltree);


--
-- Name: br_pscis_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_localcode_ltree_gidx ON bcfishpass.barriers_pscis USING gist (localcode_ltree);


--
-- Name: br_pscis_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_watershed_group_code_idx ON bcfishpass.barriers_pscis USING btree (watershed_group_code);


--
-- Name: br_pscis_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_wscode_ltree_bidx ON bcfishpass.barriers_pscis USING btree (wscode_ltree);


--
-- Name: br_pscis_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_wscode_ltree_gidx ON bcfishpass.barriers_pscis USING gist (wscode_ltree);


--
-- Name: br_pscis_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_wskey_idx ON bcfishpass.barriers_pscis USING btree (watershed_key);


--
-- Name: br_remediations_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_blk_meas_idx ON bcfishpass.barriers_remediations USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_remediations_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_blue_line_key_idx ON bcfishpass.barriers_remediations USING btree (blue_line_key);


--
-- Name: br_remediations_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_geom_idx ON bcfishpass.barriers_remediations USING gist (geom);


--
-- Name: br_remediations_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_linear_feature_id_idx ON bcfishpass.barriers_remediations USING btree (linear_feature_id);


--
-- Name: br_remediations_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_localcode_ltree_bidx ON bcfishpass.barriers_remediations USING btree (localcode_ltree);


--
-- Name: br_remediations_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_localcode_ltree_gidx ON bcfishpass.barriers_remediations USING gist (localcode_ltree);


--
-- Name: br_remediations_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_watershed_group_code_idx ON bcfishpass.barriers_remediations USING btree (watershed_group_code);


--
-- Name: br_remediations_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_wscode_ltree_bidx ON bcfishpass.barriers_remediations USING btree (wscode_ltree);


--
-- Name: br_remediations_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_wscode_ltree_gidx ON bcfishpass.barriers_remediations USING gist (wscode_ltree);


--
-- Name: br_remediations_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_wskey_idx ON bcfishpass.barriers_remediations USING btree (watershed_key);


--
-- Name: br_st_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_blk_meas_idx ON bcfishpass.barriers_st USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_st_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_blue_line_key_idx ON bcfishpass.barriers_st USING btree (blue_line_key);


--
-- Name: br_st_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_geom_idx ON bcfishpass.barriers_st USING gist (geom);


--
-- Name: br_st_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_linear_feature_id_idx ON bcfishpass.barriers_st USING btree (linear_feature_id);


--
-- Name: br_st_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_localcode_ltree_bidx ON bcfishpass.barriers_st USING btree (localcode_ltree);


--
-- Name: br_st_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_localcode_ltree_gidx ON bcfishpass.barriers_st USING gist (localcode_ltree);


--
-- Name: br_st_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_watershed_group_code_idx ON bcfishpass.barriers_st USING btree (watershed_group_code);


--
-- Name: br_st_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_wscode_ltree_bidx ON bcfishpass.barriers_st USING btree (wscode_ltree);


--
-- Name: br_st_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_wscode_ltree_gidx ON bcfishpass.barriers_st USING gist (wscode_ltree);


--
-- Name: br_st_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_wskey_idx ON bcfishpass.barriers_st USING btree (watershed_key);


--
-- Name: br_subsurfaceflow_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_blk_meas_idx ON bcfishpass.barriers_subsurfaceflow USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_subsurfaceflow_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_blue_line_key_idx ON bcfishpass.barriers_subsurfaceflow USING btree (blue_line_key);


--
-- Name: br_subsurfaceflow_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_geom_idx ON bcfishpass.barriers_subsurfaceflow USING gist (geom);


--
-- Name: br_subsurfaceflow_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_linear_feature_id_idx ON bcfishpass.barriers_subsurfaceflow USING btree (linear_feature_id);


--
-- Name: br_subsurfaceflow_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_localcode_ltree_bidx ON bcfishpass.barriers_subsurfaceflow USING btree (localcode_ltree);


--
-- Name: br_subsurfaceflow_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_localcode_ltree_gidx ON bcfishpass.barriers_subsurfaceflow USING gist (localcode_ltree);


--
-- Name: br_subsurfaceflow_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_watershed_group_code_idx ON bcfishpass.barriers_subsurfaceflow USING btree (watershed_group_code);


--
-- Name: br_subsurfaceflow_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_wscode_ltree_bidx ON bcfishpass.barriers_subsurfaceflow USING btree (wscode_ltree);


--
-- Name: br_subsurfaceflow_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_wscode_ltree_gidx ON bcfishpass.barriers_subsurfaceflow USING gist (wscode_ltree);


--
-- Name: br_subsurfaceflow_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_wskey_idx ON bcfishpass.barriers_subsurfaceflow USING btree (watershed_key);


--
-- Name: br_user_definite_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_blk_meas_idx ON bcfishpass.barriers_user_definite USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_user_definite_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_blue_line_key_idx ON bcfishpass.barriers_user_definite USING btree (blue_line_key);


--
-- Name: br_user_definite_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_geom_idx ON bcfishpass.barriers_user_definite USING gist (geom);


--
-- Name: br_user_definite_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_linear_feature_id_idx ON bcfishpass.barriers_user_definite USING btree (linear_feature_id);


--
-- Name: br_user_definite_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_localcode_ltree_bidx ON bcfishpass.barriers_user_definite USING btree (localcode_ltree);


--
-- Name: br_user_definite_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_localcode_ltree_gidx ON bcfishpass.barriers_user_definite USING gist (localcode_ltree);


--
-- Name: br_user_definite_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_watershed_group_code_idx ON bcfishpass.barriers_user_definite USING btree (watershed_group_code);


--
-- Name: br_user_definite_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_wscode_ltree_bidx ON bcfishpass.barriers_user_definite USING btree (wscode_ltree);


--
-- Name: br_user_definite_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_wscode_ltree_gidx ON bcfishpass.barriers_user_definite USING gist (wscode_ltree);


--
-- Name: br_user_definite_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_wskey_idx ON bcfishpass.barriers_user_definite USING btree (watershed_key);


--
-- Name: br_wct_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_blk_meas_idx ON bcfishpass.barriers_wct USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_wct_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_blue_line_key_idx ON bcfishpass.barriers_wct USING btree (blue_line_key);


--
-- Name: br_wct_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_geom_idx ON bcfishpass.barriers_wct USING gist (geom);


--
-- Name: br_wct_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_linear_feature_id_idx ON bcfishpass.barriers_wct USING btree (linear_feature_id);


--
-- Name: br_wct_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_localcode_ltree_bidx ON bcfishpass.barriers_wct USING btree (localcode_ltree);


--
-- Name: br_wct_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_localcode_ltree_gidx ON bcfishpass.barriers_wct USING gist (localcode_ltree);


--
-- Name: br_wct_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_watershed_group_code_idx ON bcfishpass.barriers_wct USING btree (watershed_group_code);


--
-- Name: br_wct_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_wscode_ltree_bidx ON bcfishpass.barriers_wct USING btree (wscode_ltree);


--
-- Name: br_wct_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_wscode_ltree_gidx ON bcfishpass.barriers_wct USING gist (wscode_ltree);


--
-- Name: br_wct_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_wskey_idx ON bcfishpass.barriers_wct USING btree (watershed_key);


--
-- Name: crossings_blk_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_blk_idx ON bcfishpass.crossings USING btree (blue_line_key);


--
-- Name: crossings_dam_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_dam_id_idx ON bcfishpass.crossings USING btree (dam_id);


--
-- Name: crossings_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_geom_idx ON bcfishpass.crossings USING gist (geom);


--
-- Name: crossings_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_linear_feature_id_idx ON bcfishpass.crossings USING btree (linear_feature_id);


--
-- Name: crossings_localcode_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_localcode_bidx ON bcfishpass.crossings USING btree (localcode_ltree);


--
-- Name: crossings_localcode_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_localcode_gidx ON bcfishpass.crossings USING gist (localcode_ltree);


--
-- Name: crossings_modelled_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_modelled_crossing_id_idx ON bcfishpass.crossings USING btree (modelled_crossing_id);


--
-- Name: crossings_stream_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_stream_crossing_id_idx ON bcfishpass.crossings USING btree (stream_crossing_id);


--
-- Name: crossings_vw_aggregated_crossings_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE UNIQUE INDEX crossings_vw_aggregated_crossings_id_idx ON bcfishpass.crossings_vw USING btree (aggregated_crossings_id);


--
-- Name: crossings_vw_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_vw_geom_idx ON bcfishpass.crossings_vw USING gist (geom);


--
-- Name: crossings_wscode_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_wscode_bidx ON bcfishpass.crossings USING btree (wscode_ltree);


--
-- Name: crossings_wscode_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_wscode_gidx ON bcfishpass.crossings USING gist (wscode_ltree);


--
-- Name: crossings_wsgcode_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_wsgcode_idx ON bcfishpass.crossings USING btree (watershed_group_code);


--
-- Name: crossings_wsk_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_wsk_idx ON bcfishpass.crossings USING btree (watershed_key);


--
-- Name: dams_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX dams_geom_idx ON bcfishpass.dams USING gist (geom);


--
-- Name: falls_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX falls_geom_idx ON bcfishpass.falls USING gist (geom);


--
-- Name: fptwg_summary_roads_vw_watershed_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX fptwg_summary_roads_vw_watershed_feature_id_idx ON bcfishpass.fptwg_summary_roads_vw USING btree (watershed_feature_id);


--
-- Name: fwa_assessment_watersheds_waterbodies__watershed_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX fwa_assessment_watersheds_waterbodies__watershed_feature_id_idx ON bcfishpass.fwa_assessment_watersheds_waterbodies_vw USING btree (watershed_feature_id);


--
-- Name: grdntbr_blk_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_blk_idx ON bcfishpass.gradient_barriers USING btree (blue_line_key);


--
-- Name: grdntbr_localcode_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_localcode_bidx ON bcfishpass.gradient_barriers USING btree (localcode_ltree);


--
-- Name: grdntbr_localcode_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_localcode_gidx ON bcfishpass.gradient_barriers USING gist (localcode_ltree);


--
-- Name: grdntbr_wscode_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_wscode_bidx ON bcfishpass.gradient_barriers USING btree (wscode_ltree);


--
-- Name: grdntbr_wscode_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_wscode_gidx ON bcfishpass.gradient_barriers USING gist (wscode_ltree);


--
-- Name: grdntbr_wsgcode_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_wsgcode_idx ON bcfishpass.gradient_barriers USING btree (watershed_group_code);


--
-- Name: modelled_stream_crossings_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_blue_line_key_idx ON bcfishpass.modelled_stream_crossings USING btree (blue_line_key);


--
-- Name: modelled_stream_crossings_ften_road_section_lines_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_ften_road_section_lines_id_idx ON bcfishpass.modelled_stream_crossings USING btree (ften_road_section_lines_id);


--
-- Name: modelled_stream_crossings_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_geom_idx ON bcfishpass.modelled_stream_crossings USING gist (geom);


--
-- Name: modelled_stream_crossings_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_linear_feature_id_idx ON bcfishpass.modelled_stream_crossings USING btree (linear_feature_id);


--
-- Name: modelled_stream_crossings_localcode_ltree_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_localcode_ltree_idx ON bcfishpass.modelled_stream_crossings USING gist (localcode_ltree);


--
-- Name: modelled_stream_crossings_localcode_ltree_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_localcode_ltree_idx1 ON bcfishpass.modelled_stream_crossings USING btree (localcode_ltree);


--
-- Name: modelled_stream_crossings_og_petrlm_dev_rd_pre06_pub_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_og_petrlm_dev_rd_pre06_pub_id_idx ON bcfishpass.modelled_stream_crossings USING btree (og_petrlm_dev_rd_pre06_pub_id);


--
-- Name: modelled_stream_crossings_og_road_segment_permit_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_og_road_segment_permit_id_idx ON bcfishpass.modelled_stream_crossings USING btree (og_road_segment_permit_id);


--
-- Name: modelled_stream_crossings_railway_track_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_railway_track_id_idx ON bcfishpass.modelled_stream_crossings USING btree (railway_track_id);


--
-- Name: modelled_stream_crossings_transport_line_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_transport_line_id_idx ON bcfishpass.modelled_stream_crossings USING btree (transport_line_id);


--
-- Name: modelled_stream_crossings_wscode_ltree_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_wscode_ltree_idx ON bcfishpass.modelled_stream_crossings USING gist (wscode_ltree);


--
-- Name: modelled_stream_crossings_wscode_ltree_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_wscode_ltree_idx1 ON bcfishpass.modelled_stream_crossings USING btree (wscode_ltree);


--
-- Name: observations_blue_line_key_downstream_route_measure_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_blue_line_key_downstream_route_measure_idx ON bcfishpass.observations USING btree (blue_line_key, downstream_route_measure);


--
-- Name: observations_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_blue_line_key_idx ON bcfishpass.observations USING btree (blue_line_key);


--
-- Name: observations_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_geom_idx ON bcfishpass.observations USING gist (geom);


--
-- Name: observations_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_linear_feature_id_idx ON bcfishpass.observations USING btree (linear_feature_id);


--
-- Name: observations_localcode_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_localcode_idx ON bcfishpass.observations USING btree (localcode);


--
-- Name: observations_localcode_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_localcode_idx1 ON bcfishpass.observations USING gist (localcode);


--
-- Name: observations_wscode_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_wscode_idx ON bcfishpass.observations USING btree (wscode);


--
-- Name: observations_wscode_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_wscode_idx1 ON bcfishpass.observations USING gist (wscode);


--
-- Name: pscis_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_blue_line_key_idx ON bcfishpass.pscis USING btree (blue_line_key);


--
-- Name: pscis_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_geom_idx ON bcfishpass.pscis USING gist (geom);


--
-- Name: pscis_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_linear_feature_id_idx ON bcfishpass.pscis USING btree (linear_feature_id);


--
-- Name: pscis_localcode_ltree_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_localcode_ltree_idx ON bcfishpass.pscis USING gist (localcode_ltree);


--
-- Name: pscis_localcode_ltree_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_localcode_ltree_idx1 ON bcfishpass.pscis USING btree (localcode_ltree);


--
-- Name: pscis_modelled_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_modelled_crossing_id_idx ON bcfishpass.pscis USING btree (modelled_crossing_id);


--
-- Name: pscis_not_matched_to_streams_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_not_matched_to_streams_geom_idx ON bcfishpass.pscis_not_matched_to_streams USING gist (geom);


--
-- Name: pscis_points_all_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_points_all_geom_idx ON bcfishpass.pscis_points_all USING gist (geom);


--
-- Name: pscis_streams_150m_modelled_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_streams_150m_modelled_crossing_id_idx ON bcfishpass.pscis_streams_150m USING btree (modelled_crossing_id);


--
-- Name: pscis_streams_150m_stream_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_streams_150m_stream_crossing_id_idx ON bcfishpass.pscis_streams_150m USING btree (stream_crossing_id);


--
-- Name: pscis_wscode_ltree_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_wscode_ltree_idx ON bcfishpass.pscis USING gist (wscode_ltree);


--
-- Name: pscis_wscode_ltree_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_wscode_ltree_idx1 ON bcfishpass.pscis USING btree (wscode_ltree);


--
-- Name: streams_blkey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_blkey_idx ON bcfishpass.streams USING btree (blue_line_key);


--
-- Name: streams_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_geom_idx ON bcfishpass.streams USING gist (geom);


--
-- Name: streams_lc_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_lc_bidx ON bcfishpass.streams USING btree (localcode_ltree);


--
-- Name: streams_lc_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_lc_gidx ON bcfishpass.streams USING gist (localcode_ltree);


--
-- Name: streams_lfeatid_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_lfeatid_idx ON bcfishpass.streams USING btree (linear_feature_id);


--
-- Name: streams_wbkey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_wbkey_idx ON bcfishpass.streams USING btree (waterbody_key);


--
-- Name: streams_wsc_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_wsc_bidx ON bcfishpass.streams USING btree (wscode_ltree);


--
-- Name: streams_wsc_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_wsc_gidx ON bcfishpass.streams USING gist (wscode_ltree);


--
-- Name: streams_wsg_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_wsg_idx ON bcfishpass.streams USING btree (watershed_group_code);


--
-- Name: user_modelled_crossing_fixes_modelled_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX user_modelled_crossing_fixes_modelled_crossing_id_idx ON bcfishpass.user_modelled_crossing_fixes USING btree (modelled_crossing_id);


--
-- Name: log_aw_linear_summary log_aw_linear_summary_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_aw_linear_summary
    ADD CONSTRAINT log_aw_linear_summary_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: log_parameters_habitat_method log_parameters_habitat_method_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_parameters_habitat_method
    ADD CONSTRAINT log_parameters_habitat_method_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: log_parameters_habitat_thresholds log_parameters_habitat_thresholds_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_parameters_habitat_thresholds
    ADD CONSTRAINT log_parameters_habitat_thresholds_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: log_wsg_crossing_summary log_wsg_crossing_summary_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_wsg_crossing_summary
    ADD CONSTRAINT log_wsg_crossing_summary_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: log_wsg_linear_summary log_wsg_linear_summary_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_wsg_linear_summary
    ADD CONSTRAINT log_wsg_linear_summary_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: user_habitat_classification user_habitat_classification_temp_rearing_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification
    ADD CONSTRAINT user_habitat_classification_temp_rearing_fkey FOREIGN KEY (rearing) REFERENCES bcfishpass.user_habitat_codes(habitat_code);


--
-- Name: user_habitat_classification user_habitat_classification_temp_spawning_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification
    ADD CONSTRAINT user_habitat_classification_temp_spawning_fkey FOREIGN KEY (spawning) REFERENCES bcfishpass.user_habitat_codes(habitat_code);


--
-- Name: user_habitat_classification user_habitat_classification_temp_species_code_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification
    ADD CONSTRAINT user_habitat_classification_temp_species_code_fkey FOREIGN KEY (species_code) REFERENCES whse_fish.species_cd(code);


--
-- PostgreSQL database dump complete
--


