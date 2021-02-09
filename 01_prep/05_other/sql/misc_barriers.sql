DROP TABLE IF EXISTS bcfishpass.misc_barriers;

-- table definition is equivalent to bcfishpass.barriers_other_definite (that this data gets loaded to)
CREATE TABLE bcfishpass.misc_barriers
(
    misc_barrier_id serial primary key,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    UNIQUE (blue_line_key, downstream_route_measure)
);

-- load the two misc barriers, just encode directly in SQL for now rather than creating a csv
INSERT INTO bcfishpass.misc_barriers
(
    barrier_type,
    barrier_name,
    blue_line_key,
    downstream_route_measure
)
VALUES
('LOCAL KNOWLEDGE','Stump Lake Creek Dam',356348366, 1012.8),
('LOCAL KNOWLEDGE','Hamilton Creek',356341914, 140),
('STREAM DISSIPATES','MISC',356332517,0),
('WEIR','MISC',356334818,3697.1915866542145),
('CASCADE','MISC',356162422,2319.8033764845),
('STEEP GRADIENT','MISC',356363343,41922.1055634285),
('FALLS','MISC',356264650,0),
('STEEP GRADIENT','MISC',356221118,2058);