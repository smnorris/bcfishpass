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
    {stream_schema}.{stream_table} s
    INNER JOIN {point_schema}.{point_table} b ON s.linear_feature_id = b.linear_feature_id
    -- *Only break stream lines where the barrier pt is >1m from the end*
    -- Also, this restriction ensures we are matching the correct segment
    -- when there is more than 1 equivalent linear_feature_id (rather than
    -- selecting DISTINCT ON and ordering by measure) - because the difference
    -- between barrier and segment dnstr measure is positive and the difference
    -- between the segment upstr measure and the barrier is positive.
    WHERE (b.downstream_route_measure - s.downstream_route_measure) > 1 AND
          (s.upstream_route_measure - b.downstream_route_measure) > 1 AND
          s.watershed_group_code = %s
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
INNER JOIN {stream_schema}.{stream_table} s ON n.segmented_stream_id = s.segmented_stream_id;


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
  INNER JOIN {stream_schema}.{stream_table} s
  ON m.segmented_stream_id = s.segmented_stream_id
)

UPDATE
  {stream_schema}.{stream_table} a
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
INSERT INTO {stream_schema}.{stream_table}
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
  {stream_schema}.{stream_table} a
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
  feature_code = s.feature_code,
  upstream_area_ha = ua.upstream_area_ha,
  upstream_lake_ha = wb.upstream_lake_ha,
  upstream_reservoir_ha = wb.upstream_reservoir_ha,
  upstream_wetland_ha = wb.upstream_wetland_ha
FROM whse_basemapping.fwa_stream_networks_sp s
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies_upstream_area wb
ON s.linear_feature_id = wb.linear_feature_id
LEFT OUTER JOIN whse_basemapping.fwa_streams_watersheds_lut l
ON s.linear_feature_id = l.linear_feature_id
LEFT OUTER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
ON l.watershed_feature_id = ua.watershed_feature_id
WHERE a.watershed_group_id IS NULL
  AND a.linear_feature_id = s.linear_feature_id;