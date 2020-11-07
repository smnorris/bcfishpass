-- total number of crossings by type
SELECT
  modelled_crossing_type,
  count(*) as n
FROM fish_passage.modelled_stream_crossings
GROUP BY modelled_crossing_type;