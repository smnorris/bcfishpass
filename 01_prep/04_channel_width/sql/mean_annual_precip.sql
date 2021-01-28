-- Get mean annual precipitation for each stream segment,
-- both at the stream and the average for the entire contributing area

-- create output table
DROP TABLE IF EXISTS bcfishpass.mean_annual_precip_streams;
CREATE TABLE bcfishpass.mean_annual_precip_streams
(
  id serial primary key,
  wscode_ltree ltree,
  localcode_ltree ltree,
  watershed_group_code text,
  area bigint,
  map integer,
  map_upstream integer
);

-- insert the precip on the stream, and the area of the fundamental watershed(s) associated with the stream
WITH streams_with_areas AS
(
  SELECT
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    round(sum(ST_Area(b.geom)))::bigint as area,
    avg(a.map)::integer as map
  FROM bcfishpass.mean_annual_precip_wsd a
  INNER JOIN whse_basemapping.fwa_watersheds_poly b
  ON a.watershed_feature_id = b.watershed_feature_id
  WHERE map IS NOT NULL
  AND b.watershed_group_code IN ('BULK','LNIC','HORS','ELKR','MORR')
  GROUP BY b.wscode_ltree, b.localcode_ltree, b.watershed_group_code
)

INSERT INTO bcfishpass.mean_annual_precip_streams
(
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  area,
  map
)

SELECT * FROM streams_with_areas
-- add all streams with no fundanmental watershed, they have precip but watershed area of zero
-- (set to 1 to avoid dividing by zero)
UNION ALL
SELECT
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  1 as area,
  round(map::numeric)::integer as map
FROM bcfishpass.mean_annual_precip_streams_load;

CREATE INDEX ON bcfishpass.mean_annual_precip_streams USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.mean_annual_precip_streams USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.mean_annual_precip_streams USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.mean_annual_precip_streams USING BTREE (localcode_ltree);


-- calculate the area weighted mean of precip contributing to a stream
-- Bulkley/LNIC only for now, and this should probably be parallelized if running on a large set of watersheds
WITH areas AS
(SELECT
  a.id,
  b.map,
  b.area
FROM bcfishpass.mean_annual_precip_streams a
INNER JOIN bcfishpass.mean_annual_precip_streams b
ON FWA_Upstream(a.wscode_ltree, a.localcode_ltree, b.wscode_ltree, b.localcode_ltree)
WHERE a.watershed_group_code IN ('BULK','LNIC','HORS','ELKR','MORR')
),

totals AS
(
  SELECT
  a.id,
  SUM(area) as area
  FROM areas a
  GROUP BY a.id
),

weighting AS
(
SELECT
 a.id,
 a.area,
 b.area as area_total,
 a.area / b.area as pct,
 a.map,
 (a.area / b.area) * a.map as weighted_map
FROM areas a
INNER JOIN totals b ON a.id = b.id
),

weighted_mean AS
(
SELECT
  id,
  round(sum(weighted_map)) as map_upstream
FROM weighting
GROUP BY id
)

UPDATE bcfishpass.mean_annual_precip_streams s
SET map_upstream = w.map_upstream
FROM weighted_mean w
WHERE s.id = w.id;