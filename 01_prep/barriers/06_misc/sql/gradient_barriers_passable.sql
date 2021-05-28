DROP TABLE IF EXISTS bcfishpass.gradient_barriers_passable;

CREATE TABLE bcfishpass.gradient_barriers_passable
(blue_line_key integer,
downstream_route_measure double precision,
watershed_group_code text,
reviewer text,
notes text,
PRIMARY KEY (blue_line_key, downstream_route_measure));
