-- Load mean annual precipitation for each stream segment.
-- Insert the precip on the stream, and the area of the fundamental watershed(s) associated with the stream

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
  WHERE a.map IS NOT NULL AND b.wscode_ltree IS NOT NULL AND b.localcode_ltree IS NOT NULL
  AND b.watershed_group_code = :'wsg'
  GROUP BY b.wscode_ltree, b.localcode_ltree, b.watershed_group_code
)

INSERT INTO bcfishpass.mean_annual_precip
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
FROM bcfishpass.mean_annual_precip_load
WHERE wscode_ltree IS NOT NULL AND localcode_ltree IS NOT NULL
ON CONFLICT DO NOTHING;