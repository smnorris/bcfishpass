-- Update modelled_crossing_id values to match values in v2.3.1 crossings.

DROP TABLE IF EXISTS fish_passage.modelled_stream_crossings_archive;
CREATE TABLE fish_passage.modelled_stream_crossings_archive
    (crossing_id integer primary key,
    modelled_crossing_type text,
    linear_feature_id bigint,
    blue_line_key integer,
    wscode_ltree ltree,
    localcode_ltree ltree,
    downstream_route_measure float,
    watershed_group_code text,
    geom geometry(Point, 3005)
);

INSERT INTO fish_passage.modelled_stream_crossings_archive
SELECT
    crossing_id,
    'CBS'::text AS modelled_crossing_type,
    linear_feature_id,
    blue_line_key,
    wscode_ltree,
    localcode_ltree,
    downstream_route_measure,
    watershed_group_code,
    geom
  FROM fish_passage.road_stream_crossings_culverts
  UNION ALL
  SELECT
    crossing_id,
    'OBS'::text AS modelled_crossing_type,
    linear_feature_id,
    blue_line_key,
    wscode_ltree,
    localcode_ltree,
    downstream_route_measure,
    watershed_group_code,
    geom
  FROM fish_passage.road_stream_crossings_other;

CREATE INDEX ON fish_passage.modelled_stream_crossings_archive USING gist (geom);


-- without any change in road linework, equivalent crossings may have shifted up to 20m because we are now
-- using DRA positions as definitive locations, not FTEN
DROP TABLE IF EXISTS fish_passage.modelled_stream_crossings_temp;

CREATE TABLE fish_passage.modelled_stream_crossings_temp
(
  temp_id integer,
  modelled_crossing_id serial primary key,
  modelled_crossing_type character varying(5),
  modelled_crossing_type_source text[],
  transport_line_id integer,
  ften_road_section_lines_id text,
  og_road_segment_permit_id integer,
  og_petrlm_dev_rd_pre06_pub_id integer,
  railway_track_id integer,
  linear_feature_id bigint,
  blue_line_key integer,
  downstream_route_measure double precision,
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code character varying(4),
  geom geometry(PointZM, 3005)
);

SELECT setval('fish_passage.modelled_stream_crossings_temp_modelled_crossing_id_seq', (SELECT max(crossing_id) FROM fish_passage.modelled_stream_crossings_archive));

CREATE INDEX ON fish_passage.modelled_stream_crossings_temp (temp_id);

WITH matched AS
(
    SELECT
      a.modelled_crossing_id,
      a.modelled_crossing_type,
      a.modelled_crossing_type_source,
      a.transport_line_id,
      a.ften_road_section_lines_id,
      a.og_road_segment_permit_id,
      a.og_petrlm_dev_rd_pre06_pub_id,
      a.railway_track_id,
      a.linear_feature_id,
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      a.watershed_group_code,
      a.geom,
      nn.crossing_id,
      nn.dist
    FROM fish_passage.modelled_stream_crossings a
    CROSS JOIN LATERAL
    (SELECT
       crossing_id,
       ST_Distance(a.geom, b.geom) as dist
     FROM fish_passage.modelled_stream_crossings_archive b
     ORDER BY a.geom <-> b.geom
     LIMIT 1) as nn
    WHERE nn.dist < 20
)

-- be sure to only return one match
-- (>1 crossing in the new layer can be matched to one xing in the old)
INSERT INTO fish_passage.modelled_stream_crossings_temp
  (
    temp_id,
    modelled_crossing_id,
    modelled_crossing_type,
    modelled_crossing_type_source,
    transport_line_id,
    ften_road_section_lines_id,
    og_road_segment_permit_id,
    og_petrlm_dev_rd_pre06_pub_id,
    railway_track_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT DISTINCT ON (crossing_id)
  modelled_crossing_id as temp_id,
  crossing_id as modelled_crossing_id,
  modelled_crossing_type,
  modelled_crossing_type_source,
  transport_line_id,
  ften_road_section_lines_id,
  og_road_segment_permit_id,
  og_petrlm_dev_rd_pre06_pub_id,
  railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
FROM matched m
ORDER BY crossing_id, dist;

-- now insert records that did not get matched
INSERT INTO fish_passage.modelled_stream_crossings_temp
(    temp_id,
    modelled_crossing_type,
    modelled_crossing_type_source,
    transport_line_id,
    ften_road_section_lines_id,
    og_road_segment_permit_id,
    og_petrlm_dev_rd_pre06_pub_id,
    railway_track_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    geom
)
SELECT
  modelled_crossing_id AS temp_id,
  modelled_crossing_type,
  modelled_crossing_type_source,
  transport_line_id,
  ften_road_section_lines_id,
  og_road_segment_permit_id,
  og_petrlm_dev_rd_pre06_pub_id,
  railway_track_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom
FROM fish_passage.modelled_stream_crossings
WHERE modelled_crossing_id NOT IN (SELECT temp_id FROM fish_passage.modelled_stream_crossings_temp);

ALTER TABLE fish_passage.modelled_stream_crossings_temp DROP COLUMN temp_id;

DROP TABLE IF EXISTS fish_passage.modelled_stream_crossings_bk;
ALTER TABLE fish_passage.modelled_stream_crossings RENAME TO modelled_stream_crossings_bk;
ALTER TABLE fish_passage.modelled_stream_crossings_temp RENAME TO modelled_stream_crossings;