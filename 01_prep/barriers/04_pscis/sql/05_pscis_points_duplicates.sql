-- Report on duplicated crossings for review and fixing
-- 1. Based on points <10m apart
-- 2. Based on events <5m (instream) apart

DROP TABLE IF EXISTS bcfishpass.pscis_points_duplicates;

CREATE TABLE bcfishpass.pscis_points_duplicates
(stream_crossing_id integer,
duplicate_10m boolean,
duplicate_5m_instream boolean);


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

-- insert new records with 5m dups
with dup5m AS
(SELECT
  a.stream_crossing_id,
  TRUE as duplicate_5m_instream
FROM bcfishpass.pscis_events_prelim2 As a
INNER JOIN bcfishpass.pscis_events_prelim2 b
ON a.blue_line_key = b.blue_line_key
AND abs(a.downstream_route_measure - b.downstream_route_measure) < 5
AND a.stream_crossing_id != b.stream_crossing_id)

INSERT INTO bcfishpass.pscis_points_duplicates
(stream_crossing_id, duplicate_5m_instream)
SELECT * from dup5m where stream_crossing_id not in (select stream_crossing_id from bcfishpass.pscis_points_duplicates);

-- update existing 10m dups as also being 5m dups
with dup5m AS
(SELECT
  a.stream_crossing_id,
  TRUE as duplicate_5m_instream
FROM bcfishpass.pscis_events_prelim2 As a
INNER JOIN bcfishpass.pscis_events_prelim2 b
ON a.blue_line_key = b.blue_line_key
AND abs(a.downstream_route_measure - b.downstream_route_measure) < 5
AND a.stream_crossing_id != b.stream_crossing_id)

UPDATE bcfishpass.pscis_points_duplicates
SET duplicate_5m_instream = TRUE
WHERE stream_crossing_id IN (select stream_crossing_id from dup5m);

ALTER TABLE bcfishpass.pscis_points_duplicates
ADD COLUMN watershed_group_code text;

-- handy to see where these are
WITH wsg AS
(SELECT
  p.stream_crossing_id,
  w.watershed_group_code
FROM bcfishpass.pscis_points_all p
INNER JOIN whse_basemapping.fwa_watershed_groups w
ON ST_Intersects(p.geom, w.geom)
)

UPDATE bcfishpass.pscis_points_duplicates d
SET watershed_group_code = wsg.watershed_group_code
FROM wsg
WHERE d.stream_crossing_id = wsg.stream_crossing_id;