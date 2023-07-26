-- reference CABD dams to FWA stream network

alter table cabd.dams alter column cabd_id type uuid using cabd_id::uuid;

DROP TABLE IF EXISTS bcfishpass.dams;

CREATE TABLE bcfishpass.dams
(dam_id text primary key,
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
    pt.cabd_id::text as dam_id,
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
    WHERE ST_Distance(str.geom, pt.geom) <= 65
    -- exclude CABD dams that get snapped incorrectly to major rivers
    AND pt.cabd_id NOT IN (
      'e8e4bd88-c3c9-407c-a7a0-15c6c51704fd', -- seton
      '6a792d8f-b9c5-44a4-a260-0f06c3b20821'  -- salmon/merton
      )
)

SELECT
    dam_id,
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

-- load placeholders for USA dams
insert into bcfishpass.dams
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

select
  (a.user_barrier_anthropogenic_id + 1200000000)::text as dam_id,
  s.linear_feature_id,
  a.blue_line_key,
  a.downstream_route_measure,
  s.wscode_ltree,
  s.localcode_ltree,
  0 as distance_to_stream,
  s.watershed_group_code,
  st_force2d((st_dump(st_locatealong(s.geom, a.downstream_route_measure))).geom) as geom
from bcfishpass.user_barriers_anthropogenic a
inner join whse_basemapping.fwa_stream_networks_sp s
on a.blue_line_key = s.blue_line_key
AND ROUND(a.downstream_route_measure::numeric) >= ROUND(s.downstream_route_measure::numeric)
AND ROUND(a.downstream_route_measure::numeric) < ROUND(s.upstream_route_measure::numeric)
where a.barrier_type = 'DAM';

CREATE INDEX ON bcfishpass.dams (linear_feature_id);
CREATE INDEX ON bcfishpass.dams (blue_line_key);
CREATE INDEX ON bcfishpass.dams (watershed_group_code);
CREATE INDEX ON bcfishpass.dams USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.dams USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.dams USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.dams USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.dams USING GIST (geom);


-- patch CABD barrier status for these likely passable features
update cabd.dams
set passability_status_code = 3
where cabd_id in (
'30b88f1b-dc21-4b42-8daa-d4cebae24142',
'3ca692b8-37cf-44e8-a783-2a315ec83102',
'ba5fe3eb-7bbe-45c1-b301-555872387c16',
'8a6b10fa-0d4f-4c45-857c-764d7e8028f8',
'48478e95-e063-4df6-a047-6aaf6087011b'
);