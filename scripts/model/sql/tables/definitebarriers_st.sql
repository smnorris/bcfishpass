-- steelhead barriers (20% scenario)
--drop table if exists bcfishpass.definitebarriers_st;
CREATE TABLE IF NOT EXISTS bcfishpass.definitebarriers_st
(
    definitebarriers_st_id bigint
     GENERATED ALWAYS AS ((((blue_line_key::bigint + 1) - 354087611) * 10000000) + round(downstream_route_measure::bigint)) STORED PRIMARY KEY,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree ltree,
    localcode_ltree ltree,
    watershed_group_code text,
    geom geometry(Point, 3005),
    UNIQUE (blue_line_key, downstream_route_measure)
);

CREATE INDEX IF NOT EXISTS defb_st_lftid_idx ON bcfishpass.definitebarriers_st (linear_feature_id);
CREATE INDEX IF NOT EXISTS defb_st_blk_idx ON bcfishpass.definitebarriers_st (blue_line_key);
CREATE INDEX IF NOT EXISTS defb_st_wsg_idx ON bcfishpass.definitebarriers_st (watershed_group_code);
CREATE INDEX IF NOT EXISTS defb_st_wscode_ltree_gidx ON bcfishpass.definitebarriers_st USING GIST (wscode_ltree);
CREATE INDEX IF NOT EXISTS defb_st_wscode_ltree_bidx ON bcfishpass.definitebarriers_st USING BTREE (wscode_ltree);
CREATE INDEX IF NOT EXISTS defb_st_localcode_gltree_idx ON bcfishpass.definitebarriers_st USING GIST (localcode_ltree);
CREATE INDEX IF NOT EXISTS defb_st_localcode_bltree_idx ON bcfishpass.definitebarriers_st USING BTREE (localcode_ltree);
CREATE INDEX IF NOT EXISTS defb_st_geom_idx ON bcfishpass.definitebarriers_st USING GIST (geom);