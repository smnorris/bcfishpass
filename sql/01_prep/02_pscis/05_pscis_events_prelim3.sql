-- Combine the two sources, matched to modelled crossings and
-- matched to streams. Retaining only the highest scored match

DROP TABLE IF EXISTS whse_fish.pscis_events_prelim3;

CREATE TABLE whse_fish.pscis_events_prelim3 AS
SELECT DISTINCT ON (stream_crossing_id) * FROM
(SELECT
  stream_crossing_id,
  model_crossing_id,
  dist_m AS distance_to_stream,
  linear_feature_id,
  fwa_watershed_code,
  local_watershed_code,
  wscode_ltree,
  localcode_ltree,
  blue_line_key,
  downstream_route_measure,
  watershed_group_code,
  total_score AS score
FROM whse_fish.pscis_model_match_pts
UNION ALL
SELECT
  stream_crossing_id,
  NULL::INT AS model_crossing_id,
  distance_to_stream,
  linear_feature_id,
  fwa_watershed_code,
  local_watershed_code,
  wscode_ltree,
  localcode_ltree,
  blue_line_key,
  downstream_route_measure,
  watershed_group_code,
  total_score AS score
FROM whse_fish.pscis_events_prelim2) AS foo
ORDER BY stream_crossing_id, score, model_crossing_id DESC NULLS LAST;

ALTER TABLE whse_fish.pscis_events_prelim3 ADD PRIMARY KEY (stream_crossing_id);
