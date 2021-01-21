DROP TABLE IF EXISTS bcfishpass.barriers_majordams;

CREATE TABLE bcfishpass.barriers_majordams
(
    barriers_majordams_id serial primary key,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    -- add a unique constraint so that we don't have equivalent barriers messing up subsequent joins
    UNIQUE (blue_line_key, downstream_route_measure)
);

INSERT INTO bcfishpass.barriers_majordams
(
    barriers_majordams_id,
    barrier_type,
    barrier_name,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
    dam_id as barriers_majordams_id,
    'MAJOR_DAM' as barrier_type,
    d.dam_name as barrier_name,
    d.linear_feature_id,
    d.blue_line_key,
    d.downstream_route_measure,
    d.wscode_ltree,
    d.localcode_ltree,
    d.watershed_group_code,
    ST_Force2D((st_Dump(d.geom)).geom)
FROM bcfishpass.bcdams_events d
INNER JOIN bcfishpass.watershed_groups g
ON d.watershed_group_code = g.watershed_group_code
AND g.include IS TRUE
WHERE d.barrier_ind = 'Y'
AND d.hydro_dam_ind = 'Y'
ON CONFLICT DO NOTHING;



CREATE INDEX ON bcfishpass.barriers_majordams (linear_feature_id);
CREATE INDEX ON bcfishpass.barriers_majordams (blue_line_key);
CREATE INDEX ON bcfishpass.barriers_majordams (watershed_group_code);
CREATE INDEX ON bcfishpass.barriers_majordams USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_majordams USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.barriers_majordams USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_majordams USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.barriers_majordams USING GIST (geom);