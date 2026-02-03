WITH grade AS
(
  SELECT
    sv.blue_line_key,
    ROUND(sv.downstream_route_measure::numeric, 2) as downstream_route_measure,
    -- elevation at vertex (from subquery below)
    ROUND(sv.elevation::numeric, 2) as elevation_a,
    -- interpolation of elevation 100m upstream of the vertex
    ROUND((ST_Z((ST_Dump((ST_LocateAlong(s2.geom, sv.downstream_route_measure + :'grade_dist'::int )))).geom))::numeric, 2) as elevation_b,
    -- gradient between the two points on the stream
    ROUND(((ST_Z((ST_Dump((ST_LocateAlong(s2.geom, sv.downstream_route_measure + :'grade_dist'::int )))).geom) - sv.elevation) / :'grade_dist'::int )::numeric, 4) as gradient
  FROM (
    -- get elevation of every vertex on the given stream
    SELECT
      linear_feature_id,
      blue_line_key,
      edge_type,
      ((ST_LineLocatePoint(geom, ST_PointN(geom, generate_series(1, ST_NPoints(geom) - 1))) * length_metre) + downstream_route_measure) as downstream_route_measure,
      ST_Z(ST_PointN(geom, generate_series(1, ST_NPoints(geom) - 1))) AS elevation
    FROM whse_basemapping.fwa_stream_networks_sp s
    WHERE watershed_group_code = :'wsg'
    AND blue_line_key = watershed_key
    AND edge_type != 6010
    ORDER BY blue_line_key, downstream_route_measure
  ) as sv
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s2
  ON sv.blue_line_key = s2.blue_line_key AND
     sv.downstream_route_measure + :'grade_dist'::int >= s2.downstream_route_measure AND -- find stream segment <grade_dist> upstream of given segment
     sv.downstream_route_measure + :'grade_dist'::int < s2.upstream_route_measure
  WHERE sv.edge_type IN (1000,1050,1100,1150,1250,1350,1410,2000,2300)
  AND s2.edge_type != 6010
),

-- gradients are not binned, they are rounded to the nearest percentage integer and written to grade_class
gradeclass AS
(
  SELECT
    blue_line_key,
    downstream_route_measure,
    downstream_route_measure + :'grade_dist'::int as upstream_route_measure,
    round(gradient * 100)::integer as grade_class
  FROM grade
  ORDER BY blue_line_key, downstream_route_measure
),

-- Although we are calculating slope at each vertex, we don't need to retain all this information -
-- for a given continuous set of vertices with the same slope (say 15@2400m 15@2420m 15@2500m 15@2540m),
-- only the slope at the most downstream point/minimum measure (2400m) needs to be retained.
-- Grouping continuous classes (islands) together is done via count/lag window functions (thank you Erwin B)
-- https://dba.stackexchange.com/questions/166374/grouping-or-window/166397#166397
-- NOTE - this could also be done as a recursive query, (potentially easier to read)

islands AS
(
  SELECT
    blue_line_key,
    min(downstream_route_measure) AS downstream_route_measure,
    grade_class as gradient_class
  FROM
  (
    SELECT
      blue_line_key,
      downstream_route_measure,
      grade_class,
      count(step OR NULL) OVER (ORDER BY blue_line_key, downstream_route_measure) AS grp
    FROM  (
      SELECT blue_line_key, downstream_route_measure, grade_class
           , lag(grade_class, 1, grade_class) OVER (ORDER BY blue_line_key, downstream_route_measure) <> grade_class AS step
      FROM gradeclass
    ) sub1
  WHERE grade_class != 0
  ) sub2
  GROUP BY blue_line_key, grade_class, grp
  ORDER BY blue_line_key, downstream_route_measure
)

INSERT INTO bcfishpass.gradient_barriers
(
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  gradient_class)

-- Because we are measuring each vertex, some adjacent measurements are at almost the same location.
-- Generally these will be grouped together - but it is possible to have two adjacent gradients
-- (at the same measure after rounding) that span the gradient categories
-- (eg .0104 and .0994 at 129.23m on blue_line_key=360293619).
-- To rectify this, get the maximum gradient at a given location.
SELECT
  i.blue_line_key,
  i.downstream_route_measure,
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code,
  max(i.gradient_class) as gradient_class
FROM islands i
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
  on i.blue_line_key = s.blue_line_key
  and i.downstream_route_measure >= s.downstream_route_measure
  and i.downstream_route_measure < s.upstream_route_measure + .01
GROUP BY
  i.blue_line_key,
  i.downstream_route_measure,
  s.wscode_ltree,
  s.localcode_ltree,
  s.watershed_group_code
ON CONFLICT DO NOTHING;  -- max() should ensure records are unique but just in case, ignore any duplicates