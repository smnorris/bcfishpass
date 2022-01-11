-- wct barriers (20%)
--drop table if exists bcfishpass.definitebarriers_wct;
CREATE TABLE IF NOT EXISTS bcfishpass.definitebarriers_wct
(
    definitebarriers_wct_id bigint
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

CREATE INDEX IF NOT EXISTS defb_wct_lftid_idx ON bcfishpass.definitebarriers_wct (linear_feature_id);
CREATE INDEX IF NOT EXISTS defb_wct_blk_idx ON bcfishpass.definitebarriers_wct (blue_line_key);
CREATE INDEX IF NOT EXISTS defb_wct_wsg_idx ON bcfishpass.definitebarriers_wct (watershed_group_code);
CREATE INDEX IF NOT EXISTS defb_wct_wscode_ltree_gidx ON bcfishpass.definitebarriers_wct USING GIST (wscode_ltree);
CREATE INDEX IF NOT EXISTS defb_wct_wscode_ltree_bidx ON bcfishpass.definitebarriers_wct USING BTREE (wscode_ltree);
CREATE INDEX IF NOT EXISTS defb_wct_localcode_gltree_idx ON bcfishpass.definitebarriers_wct USING GIST (localcode_ltree);
CREATE INDEX IF NOT EXISTS defb_wct_localcode_bltree_idx ON bcfishpass.definitebarriers_wct USING BTREE (localcode_ltree);
CREATE INDEX IF NOT EXISTS defb_wct_geom_idx ON bcfishpass.definitebarriers_wct USING GIST (geom);