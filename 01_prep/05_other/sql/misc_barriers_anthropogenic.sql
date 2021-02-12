DROP TABLE IF EXISTS bcfishpass.misc_barriers_anthropogenic;

-- table definition is equivalent to bcfishpass.barriers_other_definite (that this data gets loaded to)
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
