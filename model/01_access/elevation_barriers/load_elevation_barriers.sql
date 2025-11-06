-- load table holding stream locations at 1000m and 1500m elevation
-- (for breaking streams, to enable precise access model elevation cut-offs)


-- to do this, extract 1m sections of stream starting at the elevation of interest
-- with locatebetweenelevations() then dump the first point of the line to output table
BEGIN;

  TRUNCATE bcfishpass.elevation_barriers;

  INSERT INTO bcfishpass.elevation_barriers (
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    elevation
  )
  WITH z1000 as
  (
    SELECT
      blue_line_key,
      wscode,
      localcode,
      watershed_group_code,
      (st_dump(st_locatebetweenelevations(geom, 1000, 1001))).geom as geom
    FROM whse_basemapping.fwa_streams
  ),

  z1500 as
  (
    SELECT
      blue_line_key,
      wscode,
      localcode,
      watershed_group_code,
      (st_dump(st_locatebetweenelevations(geom, 1500, 1501))).geom as geom
    FROM whse_basemapping.fwa_streams
  )

  SELECT DISTINCT ON (blue_line_key, downstream_route_measure)
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    elevation
  FROM (
  SELECT
    blue_line_key,
    round(st_m(st_startpoint(geom))::numeric)::integer as downstream_route_measure,
    wscode as wscode_ltree,
    localcode as localcode_ltree,
    watershed_group_code,
    1000 as elevation
  FROM z1000
  WHERE st_z(st_startpoint(geom)) = 1000
  UNION ALL
  SELECT
    blue_line_key,
    round(st_m(st_startpoint(geom))::numeric)::integer as downstream_route_measure,
    wscode as wscode_ltree,
    localcode as localcode_ltree,
    watershed_group_code,
    1500 as elevation
  FROM z1500
  WHERE st_z(st_startpoint(geom)) = 1500
  ) as f
  ORDER BY blue_line_key, downstream_route_measure;

COMMIT;