-- reference CABD dams to FWA stream network

DROP TABLE IF EXISTS bcfishpass.dams;

CREATE TABLE bcfishpass.dams
(dam_id uuid primary key,
 linear_feature_id bigint,
 blue_line_key integer,
 downstream_route_measure double precision,
 wscode_ltree ltree,
 localcode_ltree ltree,
 distance_to_stream double precision,
 watershed_group_code text,
 geom geometry(Point, 3005),
 UNIQUE (blue_line_key, downstream_route_measure)
);


INSERT INTO bcfishpass.dams
(
  dam_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  distance_to_stream,
  watershed_group_code,
  geom
)

WITH nearest AS
(
  SELECT
    pt.cabd_id as dam_id,
    str.linear_feature_id,
    str.wscode_ltree,
    str.localcode_ltree,
    str.blue_line_key,
    str.waterbody_key,
    str.length_metre,
    ST_Distance(str.geom, pt.geom) as distance_to_stream,
    str.watershed_group_code,
    str.downstream_route_measure as downstream_route_measure_str,
    (
      ST_LineLocatePoint(
        st_linemerge(str.geom),
        ST_ClosestPoint(str.geom, pt.geom)
      )
      * str.length_metre
  ) + str.downstream_route_measure AS downstream_route_measure,
  st_linemerge(str.geom) as geom_str
  FROM cabd.dams pt
  CROSS JOIN LATERAL
  (SELECT
     linear_feature_id,
     wscode_ltree,
     localcode_ltree,
     blue_line_key,
     waterbody_key,
     length_metre,
     downstream_route_measure,
     watershed_group_code,
     geom
    FROM whse_basemapping.fwa_stream_networks_sp str
    WHERE str.localcode_ltree IS NOT NULL
    AND NOT str.wscode_ltree <@ '999'
    ORDER BY str.geom <-> pt.geom
    LIMIT 1) as str
    WHERE ST_Distance(str.geom, pt.geom) <= 50
)

SELECT
    dam_id::uuid,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    ST_Force2D(
      ST_LineInterpolatePoint(geom_str,
       ROUND(
         CAST(
            (downstream_route_measure -
               downstream_route_measure_str) / length_metre AS NUMERIC
          ),
         5)
       )
    )::geometry(Point, 3005) AS geom
FROM nearest
ON CONFLICT DO NOTHING;

CREATE INDEX ON bcfishpass.dams (linear_feature_id);
CREATE INDEX ON bcfishpass.dams (blue_line_key);
CREATE INDEX ON bcfishpass.dams (watershed_group_code);
CREATE INDEX ON bcfishpass.dams USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.dams USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.dams USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.dams USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.dams USING GIST (geom);