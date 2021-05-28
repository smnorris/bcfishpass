begin;

DROP TABLE IF EXISTS bcfishpass.misc_barriers_definite;
CREATE TABLE bcfishpass.misc_barriers_definite
(
    blue_line_key integer,
    downstream_route_measure double precision,
    barrier_name text,
    watershed_group_code text,
    reviewer text,
    notes text,
    PRIMARY KEY (blue_line_key, downstream_route_measure)
);

\copy bcfishpass.misc_barriers_definite FROM 'data/misc_barriers_definite.csv' delimiter ',' csv header

DROP TABLE IF EXISTS bcfishpass.misc_barriers_anthropogenic;
-- We want simple integer unique ids for all anthropogenic barriers that remain constant.
-- So do not autogenerate, maintain them in the csv manually for now
CREATE TABLE bcfishpass.misc_barriers_anthropogenic
(
    misc_barrier_anthropogenic_id integer primary key,
    blue_line_key integer,
    downstream_route_measure double precision,
    barrier_type text,
    barrier_name text,
    watershed_group_code text,
    reviewer text,
    notes text,
    UNIQUE (blue_line_key, downstream_route_measure)
);

\copy bcfishpass.misc_barriers_anthropogenic FROM 'data/misc_barriers_anthropogenic.csv' delimiter ',' csv header

commit;