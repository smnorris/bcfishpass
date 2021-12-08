---------------------------------------------------------------
-- create a temp table where we segment streams at point locations
---------------------------------------------------------------
CREATE TEMPORARY TABLE temp_streams AS

-- find streams to break by joining streams to the input points
WITH to_break AS (
  SELECT
    s.segmented_stream_id,
    s.linear_feature_id,
    s.downstream_route_measure AS meas_stream_ds,
    s.upstream_route_measure AS meas_stream_us,
    b.downstream_route_measure AS meas_event
  FROM
    bcfishpass.segmented_streams s
    INNER JOIN bcfishpass.breakpoints b
    ON s.blue_line_key = b.blue_line_key AND
    -- match based on measure, but only break stream lines where the
    -- barrier pt is >1m from the end of the existing stream segment
    (b.downstream_route_measure - s.downstream_route_measure) > 1 AND
    (s.upstream_route_measure - b.downstream_route_measure) > 1 AND
    s.watershed_group_code = :'wsg'
),

-- derive measures of new lines from break points
new_measures AS
(
  SELECT
    segmented_stream_id,
    linear_feature_id,
    --meas_stream_ds,
    --meas_stream_us,
    meas_event AS downstream_route_measure,
    lead(meas_event, 1, meas_stream_us) OVER (PARTITION BY segmented_stream_id
      ORDER BY meas_event) AS upstream_route_measure
  FROM
    to_break
)

-- create new geoms
SELECT
  row_number() OVER () AS id,
  n.segmented_stream_id,
  s.linear_feature_id,
  n.downstream_route_measure,
  n.upstream_route_measure,
  (ST_Dump(ST_LocateBetween
    (s.geom, n.downstream_route_measure, n.upstream_route_measure
    ))).geom AS geom
FROM new_measures n
INNER JOIN bcfishpass.segmented_streams s ON n.segmented_stream_id = s.segmented_stream_id;


---------------------------------------------------------------
-- shorten existing features
---------------------------------------------------------------
WITH min_segs AS
(
  SELECT DISTINCT ON (segmented_stream_id)
    segmented_stream_id,
    downstream_route_measure
  FROM
    temp_streams
  ORDER BY
    segmented_stream_id,
    downstream_route_measure ASC
),

shortened AS
(
  SELECT
    m.segmented_stream_id,
    ST_Length(ST_LocateBetween(s.geom, s.downstream_route_measure, m.downstream_route_measure)) as length_metre,
    (ST_Dump(ST_LocateBetween (s.geom, s.downstream_route_measure, m.downstream_route_measure))).geom as geom
  FROM min_segs m
  INNER JOIN bcfishpass.segmented_streams s
  ON m.segmented_stream_id = s.segmented_stream_id
)

UPDATE
  bcfishpass.segmented_streams a
SET
  length_metre = b.length_metre,
  geom = b.geom
FROM
  shortened b
WHERE
  b.segmented_stream_id = a.segmented_stream_id;


---------------------------------------------------------------
-- now insert new features (just the changed values and id)
---------------------------------------------------------------
INSERT INTO bcfishpass.segmented_streams
(linear_feature_id, length_metre, downstream_route_measure, geom)
SELECT
  linear_feature_id,
  ST_Length(geom) as length_metre,
  downstream_route_measure,
  geom
FROM temp_streams;

---------------------------------------------------------------
-- update standard stream values, minus generated columns
---------------------------------------------------------------
UPDATE
  bcfishpass.segmented_streams a
SET
  watershed_group_id = s.watershed_group_id,
  edge_type = s.edge_type,
  blue_line_key = s.blue_line_key,
  watershed_key = s.watershed_key,
  fwa_watershed_code = s.fwa_watershed_code,
  local_watershed_code = s.local_watershed_code,
  watershed_group_code = s.watershed_group_code,
  feature_source = s.feature_source,
  gnis_id = s.gnis_id,
  gnis_name = s.gnis_name,
  left_right_tributary = s.left_right_tributary,
  stream_order = s.stream_order,
  stream_magnitude = s.stream_magnitude,
  waterbody_key = s.waterbody_key,
  blue_line_key_50k = s.blue_line_key_50k,
  watershed_code_50k = s.watershed_code_50k,
  watershed_key_50k = s.watershed_key_50k,
  watershed_group_code_50k = s.watershed_group_code_50k,
  feature_code = s.feature_code
FROM whse_basemapping.fwa_stream_networks_sp s
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies_upstream_area wb
ON s.linear_feature_id = wb.linear_feature_id
LEFT OUTER JOIN whse_basemapping.fwa_streams_watersheds_lut l
ON s.linear_feature_id = l.linear_feature_id
LEFT OUTER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
ON l.watershed_feature_id = ua.watershed_feature_id
WHERE a.watershed_group_id IS NULL
  AND a.linear_feature_id = s.linear_feature_id;