CREATE TABLE whse_basemapping.transport_line_divided_code (
        transport_line_divided_code character varying(1) PRIMARY KEY,
        description character varying(20) NOT NULL,
        create_integration_session_id integer NOT NULL,
        create_integration_date timestamp with time zone,
        modify_integration_session_id integer NOT NULL,
        modify_integration_date timestamp with time zone
);

CREATE TABLE whse_basemapping.transport_line_structure_code (
        transport_line_structure_code character varying(1) PRIMARY KEY,
        description character varying(20) NOT NULL,
        create_integration_session_id integer NOT NULL,
        create_integration_date timestamp with time zone,
        modify_integration_session_id integer NOT NULL,
        modify_integration_date timestamp with time zone
);

CREATE TABLE whse_basemapping.transport_line_surface_code (
        transport_line_surface_code character varying(1) PRIMARY KEY,
        description character varying(20) NOT NULL,
        create_integration_session_id integer NOT NULL,
        create_integration_date timestamp with time zone,
        modify_integration_session_id integer NOT NULL,
        modify_integration_date timestamp with time zone
);

CREATE TABLE whse_basemapping.transport_line_type_code (
        transport_line_type_code character varying(3) PRIMARY KEY,
        description character varying(30) NOT NULL,
        demographic_ind character varying(1) NOT NULL,
        create_integration_session_id integer NOT NULL,
        create_integration_date timestamp with time zone,
        modify_integration_session_id integer NOT NULL,
        modify_integration_date timestamp with time zone,
        road_class character varying(12) NOT NULL
);

CREATE TABLE whse_basemapping.transport_line (
        transport_line_id SERIAL PRIMARY KEY,
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
        geom geometry(MultiLineStringZ,3005)
);
CREATE INDEX transport_line_geom_geom_idx ON whse_basemapping.transport_line USING GIST (geom);