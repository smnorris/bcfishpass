-- Report on duplicated crossings for review and fixing
-- 1. Based on points <10m apart
-- 2. Based on events <5m (instream) apart

DROP TABLE IF EXISTS bcfishpass.pscis_points_duplicates;

CREATE TABLE bcfishpass.pscis_points_duplicates
(stream_crossing_id integer,
duplicate_10m boolean,
duplicate_5m_instream boolean,
watershed_group_code text
);



-- source points < 10m apart
INSERT INTO bcfishpass.pscis_points_duplicates
(stream_crossing_id, duplicate_10m)
SELECT
  a.stream_crossing_id,
  TRUE as duplicate_10m
FROM bcfishpass.pscis_points_all As a
CROSS JOIN LATERAL
   (SELECT
      stream_crossing_id,
      ST_Distance(b.geom, a.geom) AS dist_m
     FROM bcfishpass.pscis_points_all As b
     WHERE a.stream_crossing_id != b.stream_crossing_id
     AND ST_DWithin(a.geom, b.geom, 10)
     ORDER BY b.geom <-> a.geom LIMIT 1
   ) AS s
ORDER BY a.stream_crossing_id, dist_m;



-- points < 5m apart instream
-- below is same logic as psics.sql
with weighted_matches as
(
  select
    stream_crossing_id,
    blue_line_key,
    linear_feature_id,
    downstream_route_measure,
    watershed_group_code,
    modelled_crossing_id,
    distance_to_stream,
    name_score,
    stream_order,
    downstream_channel_width,
    width_order_score,
    crossing_type_code,
    modelled_crossing_type,
    case 
      when modelled_xing_dist_instream is not null
      then distance_to_stream - (distance_to_stream * .1)
      else distance_to_stream
    end as weighted_distance
  from bcfishpass.pscis_streams_150m
  where  
    name_score >= 0 and 
    width_order_score >= -25 
),

distinct_matches as
(
  select distinct on (stream_crossing_id)
    stream_crossing_id,
    modelled_crossing_id,
    blue_line_key,
    linear_feature_id,
    downstream_route_measure,
    watershed_group_code,
    distance_to_stream,
    case when distance_to_stream > 50 then 'DISTANCE'
         when width_order_score < 0 then 'WIDTH ORDER RATIO'
    end as suspect_match
  from weighted_matches
  -- find best matches by ordering on name match, width/order ratio, and weighted distance
  order by stream_crossing_id, name_score desc,  width_order_score desc, weighted_distance
),

dup5m AS
(
  SELECT
    a.stream_crossing_id,
    TRUE as duplicate_5m_instream
  FROM distinct_matches As a
  INNER JOIN distinct_matches b
  ON a.blue_line_key = b.blue_line_key
  AND abs(a.downstream_route_measure - b.downstream_route_measure) < 5
  AND a.stream_crossing_id != b.stream_crossing_id
)

INSERT INTO bcfishpass.pscis_points_duplicates
(stream_crossing_id, duplicate_5m_instream)
SELECT * from dup5m where stream_crossing_id not in (select stream_crossing_id from bcfishpass.pscis_points_duplicates);



-- populate wsg column
WITH wsg AS
(SELECT
  p.stream_crossing_id,
  w.watershed_group_code
FROM bcfishpass.pscis_points_all p
INNER JOIN whse_basemapping.fwa_watershed_groups_poly w
ON ST_Intersects(p.geom, w.geom)
)

UPDATE bcfishpass.pscis_points_duplicates d
SET watershed_group_code = wsg.watershed_group_code
FROM wsg
WHERE d.stream_crossing_id = wsg.stream_crossing_id;