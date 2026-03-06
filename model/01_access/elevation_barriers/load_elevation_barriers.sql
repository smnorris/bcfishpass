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
  WITH z688 as
  (
    SELECT
      blue_line_key,
      wscode,
      localcode,
      watershed_group_code,
      (st_dump(st_locatebetweenelevations(geom, 688, 689))).geom as geom
    FROM whse_basemapping.fwa_streams
  ),

  z1154 as
  (
    SELECT
      blue_line_key,
      wscode,
      localcode,
      watershed_group_code,
      (st_dump(st_locatebetweenelevations(geom, 1154, 1155))).geom as geom
    FROM whse_basemapping.fwa_streams
  ),

  z1450 as
  (
    SELECT
      blue_line_key,
      wscode,
      localcode,
      watershed_group_code,
      (st_dump(st_locatebetweenelevations(geom, 1450, 1451))).geom as geom
    FROM whse_basemapping.fwa_streams
  ),

  z1466 as
  (
    SELECT
      blue_line_key,
      wscode,
      localcode,
      watershed_group_code,
      (st_dump(st_locatebetweenelevations(geom, 1466, 1467))).geom as geom
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
    688 as elevation
  FROM z688
  WHERE st_z(st_startpoint(geom)) = 688
  UNION ALL
  SELECT
    blue_line_key,
    round(st_m(st_startpoint(geom))::numeric)::integer as downstream_route_measure,
    wscode as wscode_ltree,
    localcode as localcode_ltree,
    watershed_group_code,
    1154 as elevation
  FROM z1154
  WHERE st_z(st_startpoint(geom)) = 1154
  UNION ALL
  SELECT
    blue_line_key,
    round(st_m(st_startpoint(geom))::numeric)::integer as downstream_route_measure,
    wscode as wscode_ltree,
    localcode as localcode_ltree,
    watershed_group_code,
    1450 as elevation
  FROM z1450
  WHERE st_z(st_startpoint(geom)) = 1450
  UNION ALL
  SELECT
    blue_line_key,
    round(st_m(st_startpoint(geom))::numeric)::integer as downstream_route_measure,
    wscode as wscode_ltree,
    localcode as localcode_ltree,
    watershed_group_code,
    1466 as elevation
  FROM z1466
  WHERE st_z(st_startpoint(geom)) = 1466
  ) as f
  ORDER BY blue_line_key, downstream_route_measure;

COMMIT;