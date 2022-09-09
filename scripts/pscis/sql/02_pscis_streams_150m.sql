-- match pscis points to all streams within 150m,
-- then do some crude calculations for subsequent evaluation of multiple matches


drop table if exists bcfishpass.pscis_streams_150m;
CREATE TABLE bcfishpass.pscis_streams_150m AS

WITH snapped AS
 ( SELECT
    pt.stream_crossing_id,
    nn.linear_feature_id,
    nn.wscode_ltree,
    nn.localcode_ltree,
    nn.fwa_watershed_code,
    nn.local_watershed_code,
    nn.blue_line_key,
    -- for matching on name, trim most common stream/river suffix from name
    case 
      when upper(substr(nn.gnis_name, length(nn.gnis_name) - 5, 6)) = ' CREEK' OR upper(substr(nn.gnis_name, length(nn.gnis_name) - 5, 6)) = ' RIVER' OR upper(substr(nn.gnis_name, length(nn.gnis_name) - 5, 6)) = ' DITCH' OR upper(substr(nn.gnis_name, length(nn.gnis_name) - 5, 6)) = ' BROOK' 
      then substr(nn.gnis_name, 0, length(nn.gnis_name) - 5)
      when upper(substr(nn.gnis_name, length(nn.gnis_name) - 6, 7)) = ' STREAM' or upper(substr(nn.gnis_name, length(nn.gnis_name) - 6, 7)) = ' SLOUGH' 
      then substr(nn.gnis_name, 0, length(nn.gnis_name) - 6)
      when upper(substr(nn.gnis_name, length(nn.gnis_name) - 7, 8)) = ' CHANNEL' 
      then substr(nn.gnis_name, 0, length(nn.gnis_name) - 7)
      else nn.gnis_name
    end as name_trimmed,
    nn.length_metre,
    nn.downstream_route_measure,
    nn.upstream_route_measure,
    nn.distance_to_stream,
    nn.watershed_group_code,
    ST_LineMerge(nn.geom) AS geom
  FROM bcfishpass.pscis_points_all as pt
  CROSS JOIN LATERAL
  (SELECT
     str.linear_feature_id,
     str.wscode_ltree,
     str.localcode_ltree,
     str.fwa_watershed_code,
     str.local_watershed_code,
     str.blue_line_key,
     str.length_metre,
     str.gnis_name,
     str.downstream_route_measure,
     str.upstream_route_measure,
     str.watershed_group_code,
     str.geom,
     ST_Distance(str.geom, pt.geom) as distance_to_stream
    FROM whse_basemapping.fwa_stream_networks_sp AS str
    WHERE str.localcode_ltree IS NOT NULL
    AND NOT str.wscode_ltree <@ '999'
    ORDER BY str.geom <-> pt.geom
    LIMIT 20) as nn
  WHERE nn.distance_to_stream < 150
),

-- ensure we are matching to distinct blue_line_key, pick the closest point on matching streams
matched_distinct as
(
  SELECT DISTINCT ON (stream_crossing_id, blue_line_key)
  c.stream_crossing_id,
  c.linear_feature_id,
  c.blue_line_key,
  c.name_trimmed,
  CEIL(
    GREATEST(c.downstream_route_measure,
      FLOOR(
        LEAST(c.upstream_route_measure,
          (ST_LineLocatePoint(c.geom, ST_ClosestPoint(c.geom, pts.geom)) * c.length_metre) + c.downstream_route_measure
  )))) as downstream_route_measure,
  c.distance_to_stream
FROM snapped c
INNER JOIN bcfishpass.pscis_points_all pts ON c.stream_crossing_id = pts.stream_crossing_id
ORDER BY c.stream_crossing_id, c.blue_line_key, c.distance_to_stream
)


-- try and find:
-- 1. good matches (exact name match) 
-- 2. bad matches:
--   - large distance to stream
--   - names almost match but 'trib' is in assessment stream name 
--     (and point is not within 15m of matched stream, the 'trib' flag in names is not 100% reliable)
--   - relationship of fwa stream order and measured channel width does not make sense
SELECT
  row_number() over() as id,
  e.stream_crossing_id,
  m.modelled_crossing_id,
  e.linear_feature_id,
  e.blue_line_key,
  e.downstream_route_measure,
  str.watershed_group_code,
  e.distance_to_stream,
  
  str.gnis_name,
  a.stream_name,
  -- rate match based on FWA stream name and PSCIS stream name,
  -- exact match = 100 (after replacing cr. abbrev with creek)
  -- PSCIS assessment name contains 'trib' and the fwa stream name = -100 
  -- otherwise zero
  CASE
    WHEN replace(UPPER(a.stream_name), ' CR.', ' CREEK') = UPPER(str.gnis_name) THEN 100  
    WHEN UPPER(a.stream_name) like '%TRIB%' and UPPER(a.stream_name) like '%'||UPPER(e.name_trimmed)||'%' and UPPER(a.stream_name) != UPPER(str.gnis_name) and distance_to_stream > 15 THEN -100
    ELSE 0
  END AS name_score,
  
  str.stream_order,
  a.downstream_channel_width,
  
  -- compare FWA stream order and measured channel width
  -- We only want to flag the obvious problems - these width/order relationships are not based on any comprehensive review
  CASE
    -- speculate that order 1 should probably be <5m, most likely under 10
    WHEN stream_order = 1 AND downstream_channel_width !=0 AND downstream_channel_width >= 5 AND downstream_channel_width < 10 THEN -25
    WHEN stream_order = 1 AND downstream_channel_width !=0 AND downstream_channel_width >= 10 THEN -100

    -- order 2 probably under 7, likely under 15m
    WHEN stream_order = 2 AND downstream_channel_width !=0 AND downstream_channel_width > 7 AND downstream_channel_width < 15 THEN -25
    WHEN stream_order = 2 AND downstream_channel_width !=0 AND downstream_channel_width >= 15 THEN -100

    -- order 3 probably less than 20, but hard to guess minimum, it could still be very dry
    WHEN stream_order = 3 AND downstream_channel_width !=0 AND downstream_channel_width >= 20 THEN -25

    -- order 4 should be more than 1m, probably more than 2
    WHEN stream_order = 4 AND downstream_channel_width !=0 AND downstream_channel_width < 1 THEN -100
    WHEN stream_order = 4 AND downstream_channel_width !=0 AND downstream_channel_width >= 1 AND downstream_channel_width < 2 THEN -25

    -- order 5 def more than 2, probably more than 5
    WHEN stream_order = 5 AND downstream_channel_width !=0 AND downstream_channel_width < 2 THEN -100
    WHEN stream_order = 5 AND downstream_channel_width !=0 AND downstream_channel_width >= 2 AND downstream_channel_width < 5 THEN -25

    -- everything else should be fairly big
    WHEN stream_order >= 6 AND downstream_channel_width !=0 AND downstream_channel_width < 2 THEN -100
    WHEN stream_order >= 6 AND downstream_channel_width !=0 AND downstream_channel_width < 10 THEN -25

    -- also, we know what streams are polygonal. If channel width is <4m on a polygonal river feature, something is definitely wrong
    WHEN r.waterbody_key IS NOT NULL AND downstream_channel_width !=0 AND downstream_channel_width < 4 THEN -100

  ELSE 0
  END as width_order_score,

  a.crossing_type_code,
  m.modelled_crossing_type,
  COALESCE(ST_Distance(p.geom, m.geom), 0) as modelled_xing_dist, -- set distance to zero if no modelled xing present
  round(ABS(e.downstream_route_measure - m.downstream_route_measure)::numeric, 1) as modelled_xing_dist_instream

FROM matched_distinct e
INNER JOIN bcfishpass.pscis_points_all p 
ON e.stream_crossing_id = p.stream_crossing_id
INNER JOIN whse_basemapping.fwa_stream_networks_sp str
ON e.linear_feature_id = str.linear_feature_id
LEFT OUTER JOIN whse_fish.pscis_assessment_svw a ON e.stream_crossing_id = a.stream_crossing_id
LEFT OUTER JOIN bcfishpass.modelled_stream_crossings m
ON e.blue_line_key = m.blue_line_key AND
   ABS(e.downstream_route_measure - m.downstream_route_measure) < 100
LEFT OUTER JOIN whse_basemapping.fwa_rivers_poly r ON str.waterbody_key = r.waterbody_key;

CREATE INDEX ON bcfishpass.pscis_streams_150m (stream_crossing_id);
CREATE INDEX ON bcfishpass.pscis_streams_150m (modelled_crossing_id);

-- Above query matches modelled crossings to PSCIS crossings within 100m instream distance on the same stream.
-- A single modelled crossing can thus be matched to more than one PSCIS crossing.
-- Correct for this here by ensuring a given modelled crossing is matched only to the nearest PSCIS 
-- crossing (within 100m instream)
-- Find records that are matched to the same modelled crossing
with dups as 
(
  SELECT modelled_crossing_id, count(*) as n
  FROM bcfishpass.pscis_streams_150m
  where modelled_crossing_id is not null
  GROUP BY modelled_crossing_id
  HAVING count(*) > 1
),

-- find which one should actually be matched (minimum distance)
to_retain AS
(
  SELECT DISTINCT ON (modelled_crossing_id)
    p.stream_crossing_id,
    p.modelled_crossing_id,
    p.modelled_xing_dist
  FROM bcfishpass.pscis_streams_150m p
  INNER JOIN dups ON p.modelled_crossing_id = dups.modelled_crossing_id
  ORDER BY modelled_crossing_id, modelled_xing_dist asc
),

-- based on which one should be matched, set modelled crossing id for the rest to NULL
to_update AS
(
  SELECT
    p.stream_crossing_id,
    p.modelled_crossing_id,
    p.modelled_xing_dist
  FROM bcfishpass.pscis_streams_150m p
  INNER JOIN dups ON p.modelled_crossing_id = dups.modelled_crossing_id
  LEFT OUTER JOIN to_retain r ON p.stream_crossing_id = r.stream_crossing_id
  WHERE r.stream_crossing_id IS NULL
)

UPDATE bcfishpass.pscis_streams_150m e
SET
  modelled_crossing_id = NULL,
  modelled_xing_dist_instream = NULL,
  modelled_crossing_type = NULL
WHERE stream_crossing_id IN (SELECT stream_crossing_id FROM to_update);


-- A single PSCIS crossing can also be matched to more than one modelled crossing.
-- While this may often be spots where there should only be one crossing and one modelled crossing should be removed,
-- force PSCIS crossings to only match to a single modelled crossing on given stream.

with nearest as
(
  select distinct on (stream_crossing_id)
    id,
    stream_crossing_id,
    blue_line_key,
    modelled_crossing_id,
    modelled_xing_dist_instream,
    distance_to_stream
  from bcfishpass.pscis_streams_150m
  where modelled_crossing_id is not null
  order by stream_crossing_id, distance_to_stream
)

update bcfishpass.pscis_streams_150m a
set 
 modelled_crossing_id = NULL,
 modelled_xing_dist_instream = NULL,
 modelled_crossing_type = NULL
from
nearest n  
where a.stream_crossing_id = n.stream_crossing_id
and a.id != n.id;
