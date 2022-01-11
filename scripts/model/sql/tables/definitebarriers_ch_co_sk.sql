-- CHINOOK COHO SOCKEYE BARRIERS (15%)
--drop table if exists bcfishpass.definitebarriers_ch_co_sk;

CREATE TABLE IF NOT EXISTS bcfishpass.definitebarriers_ch_co_sk
(
    definitebarriers_ch_co_sk_id bigint
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

CREATE INDEX IF NOT EXISTS defb_ch_co_sk_lftid_idx ON bcfishpass.definitebarriers_ch_co_sk (linear_feature_id);
CREATE INDEX IF NOT EXISTS defb_ch_co_sk_blk_idx ON bcfishpass.definitebarriers_ch_co_sk (blue_line_key);
CREATE INDEX IF NOT EXISTS defb_ch_co_sk_wsg_idx ON bcfishpass.definitebarriers_ch_co_sk (watershed_group_code);
CREATE INDEX IF NOT EXISTS defb_ch_co_sk_wscode_ltree_gidx ON bcfishpass.definitebarriers_ch_co_sk USING GIST (wscode_ltree);
CREATE INDEX IF NOT EXISTS defb_ch_co_sk_wscode_ltree_bidx ON bcfishpass.definitebarriers_ch_co_sk USING BTREE (wscode_ltree);
CREATE INDEX IF NOT EXISTS defb_ch_co_sk_localcode_gltree_idx ON bcfishpass.definitebarriers_ch_co_sk USING GIST (localcode_ltree);
CREATE INDEX IF NOT EXISTS defb_ch_co_sk_localcode_bltree_idx ON bcfishpass.definitebarriers_ch_co_sk USING BTREE (localcode_ltree);
CREATE INDEX IF NOT EXISTS defb_ch_co_sk_geom_idx ON bcfishpass.definitebarriers_ch_co_sk USING GIST (geom);