-- For general QA, report on duplicated crossings based on points <10m
-- apart - this is different and separate from the previous pruning of events

DROP TABLE IF EXISTS whse_fish.pscis_points_duplicates;

CREATE TABLE whse_fish.pscis_points_duplicates AS
SELECT
  a.stream_crossing_id AS id_1,
  s.stream_crossing_id AS id_2,
  s.dist_m
FROM whse_fish.pscis_points_all As a
CROSS JOIN LATERAL
   (SELECT
      stream_crossing_id,
      ST_Distance(b.geom, a.geom) AS dist_m
     FROM whse_fish.pscis_points_all As b
     WHERE a.stream_crossing_id != b.stream_crossing_id
     AND ST_DWithin(a.geom, b.geom, 10)
     ORDER BY b.geom <-> a.geom LIMIT 1
   ) AS s
ORDER BY a.stream_crossing_id, dist_m;