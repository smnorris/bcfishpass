
-- Create bcfishpass PSCIS table, linking PSCIS points to streams

DROP TABLE IF EXISTS bcfishpass.pscis;

CREATE TABLE bcfishpass.pscis
(
 stream_crossing_id       integer  PRIMARY KEY ,
 modelled_crossing_id     integer              ,
 pscis_status             text                 ,
 current_crossing_type_code    character varying(10) ,
 current_crossing_subtype_code    character varying(10) ,
 current_barrier_result_code text              ,
 distance_to_stream       double precision     ,
 suspect_match            character varying(17)              ,
 linear_feature_id        bigint               ,
 wscode_ltree             ltree                ,
 localcode_ltree          ltree                ,
 blue_line_key            integer              ,
 downstream_route_measure double precision     ,
 watershed_group_code     character varying(4) ,
 geom                     geometry(Point, 3005),
UNIQUE (blue_line_key, downstream_route_measure) -- do not allow duplicates in the same location
);

-- -----------
-- First, insert PSCIS points that have been manually matched to streams/modelled crossings in xref table
-- ------------

-- get PSCIS crossings manually matched to modelled crossings, finding measure of PSCIS point on stream
WITH referenced_modelled_xing AS
(
SELECT
  lut.stream_crossing_id,
  lut.modelled_crossing_id,
  ST_Distance(p.geom, s.geom) as distance_to_stream,
  m.linear_feature_id,
  m.wscode_ltree,
  m.localcode_ltree,
  m.blue_line_key,
  -- reference the point to the stream, making output measure an integer
  -- (ensuring point measure is between stream's downtream measure and upstream measure)
  CEIL(GREATEST(s.downstream_route_measure, FLOOR(LEAST(s.upstream_route_measure,
  (ST_LineLocatePoint(s.geom, ST_ClosestPoint(s.geom, p.geom)) * s.length_metre) + s.downstream_route_measure
  )))) as downstream_route_measure,
  m.watershed_group_code,
  CASE
    WHEN hc.stream_crossing_id IS NOT NULL AND p.current_pscis_status NOT IN ('REMEDIATED', 'DESIGN')
    THEN 'HABITAT CONFIRMATION'
    ELSE p.current_pscis_status
  END AS pscis_status,
  p.current_crossing_type_code,
  p.current_crossing_subtype_code,
  p.current_barrier_result_code
FROM bcfishpass.pscis_modelledcrossings_streams_xref lut
LEFT OUTER JOIN bcfishpass.modelled_stream_crossings m  -- left join because some modelled crossings may disappear
ON lut.modelled_crossing_id = m.modelled_crossing_id    -- as road mapping changes (but PSCIS should still come through)
INNER JOIN bcfishpass.pscis_points_all p
ON lut.stream_crossing_id = p.stream_crossing_id
LEFT OUTER JOIN whse_basemapping.fwa_stream_networks_sp s  -- again, left join just in case the modelled crossing in the
ON m.linear_feature_id = s.linear_feature_id               -- fix table no longer exists
LEFT OUTER JOIN whse_fish.pscis_habitat_confirmation_svw hc
ON lut.stream_crossing_id = hc.stream_crossing_id
WHERE lut.modelled_crossing_id IS NOT NULL
),

-- Get PSCIS points linked to streams, finding measure of PSCIS point
referenced_streams AS
(
  SELECT
    lut.stream_crossing_id,
    lut.modelled_crossing_id,
    ST_Distance(p.geom, s.geom) as distance_to_stream,
    s.linear_feature_id,
    s.wscode_ltree,
    s.localcode_ltree,
    s.blue_line_key,
    -- reference the point to the stream, making output measure an integer
    -- (ensuring point measure is between stream's downtream measure and upstream measure)
    CEIL(GREATEST(s.downstream_route_measure, FLOOR(LEAST(s.upstream_route_measure,
    (ST_LineLocatePoint(s.geom, ST_ClosestPoint(s.geom, p.geom)) * s.length_metre) + s.downstream_route_measure
    )))) as downstream_route_measure,
    s.watershed_group_code,
    CASE
      WHEN hc.stream_crossing_id IS NOT NULL AND p.current_pscis_status NOT IN ('REMEDIATED', 'DESIGN')
      THEN 'HABITAT CONFIRMATION'
      ELSE p.current_pscis_status
    END AS pscis_status,
    p.current_crossing_type_code,
    p.current_crossing_subtype_code,
    p.current_barrier_result_code
  FROM bcfishpass.pscis_modelledcrossings_streams_xref lut
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s
  ON lut.linear_feature_id = s.linear_feature_id
  INNER JOIN bcfishpass.pscis_points_all p
  ON lut.stream_crossing_id = p.stream_crossing_id
  LEFT OUTER JOIN whse_fish.pscis_habitat_confirmation_svw hc
  ON lut.stream_crossing_id = hc.stream_crossing_id
  WHERE lut.linear_feature_id IS NOT NULL  -- this is implicit with the inner join on linear_feature_id, make it explicit here
),

-- combine the two sets above, generate geom from the PSCIS point measure
referenced_combined AS
(SELECT
  r.*,
  (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, r.downstream_route_measure)))).geom as geom
FROM referenced_modelled_xing r
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON r.linear_feature_id = s.linear_feature_id
UNION ALL
SELECT
  r.*,
  (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, r.downstream_route_measure)))).geom as geom
FROM referenced_streams r
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON r.linear_feature_id = s.linear_feature_id
)

INSERT INTO bcfishpass.pscis
(stream_crossing_id,
 modelled_crossing_id,
 pscis_status,
 current_crossing_type_code,
 current_crossing_subtype_code,
 current_barrier_result_code,
 distance_to_stream,
 linear_feature_id,
 wscode_ltree,
 localcode_ltree,
 blue_line_key,
 downstream_route_measure,
 watershed_group_code,
 geom)
SELECT
 stream_crossing_id,
 modelled_crossing_id,
 pscis_status,
 current_crossing_type_code,
 current_crossing_subtype_code,
 current_barrier_result_code,
 distance_to_stream,
 linear_feature_id,
 wscode_ltree,
 localcode_ltree,
 blue_line_key,
 downstream_route_measure,
 watershed_group_code,
 geom
FROM referenced_combined
-- sort above by linear_feature_id, measure, distance to stream
-- this will retain the closest record to the stream in case two points fall
-- at the same measure
ORDER BY linear_feature_id, downstream_route_measure, distance_to_stream asc
ON CONFLICT DO NOTHING;



-- Now insert PSCIS crossings matched to nearest stream(s).

-- extract records from source matching table,
--  - exclude bad matches entirely
--  - weight records with a modelled crossing nearby as 10% closer
--    (prioritize matching to the stream that has a known road)
with weighted_matches as
(
  select
    stream_crossing_id,
    blue_line_key,
    linear_feature_id,
    downstream_route_measure,
    watershed_group_code,
    modelled_crossing_id,
    distance_to_stream,
    name_score,
    stream_order,
    downstream_channel_width,
    width_order_score,
    crossing_type_code,
    modelled_crossing_type,
    case 
      when modelled_xing_dist_instream is not null
      then distance_to_stream - (distance_to_stream * .1)
      else distance_to_stream
    end as weighted_distance
  from bcfishpass.pscis_streams_150m
 -- filter out records that are obvious bad matches
  where 
    name_score != -100 and
    width_order_score != -100 and 
    multiple_match_ind is null
),

distinct_matches as
(
  select distinct on (stream_crossing_id)
    stream_crossing_id,
    modelled_crossing_id,
    blue_line_key,
    linear_feature_id,
    downstream_route_measure,
    watershed_group_code,
    distance_to_stream,
    case when distance_to_stream > 50 then 'DISTANCE'
         when width_order_score < 0 then 'WIDTH ORDER RATIO'
    end as suspect_match
  from weighted_matches
  -- find best matches by ordering on name match, width/order ratio, and weighted distance
  order by stream_crossing_id, name_score desc, weighted_distance
),


-- Note that many PSCIS duplicates exist, we have to weed these out if they
-- are especially bad - within 5m of each other.
-- In case of duplication retain crossing id with most recent assessment (and note duplicates for fixing)
-- Ideally the oldest crossing id should be retained here (and used for any mapping
-- before fixes happen to keep things consistent) - however mixing the id
-- with different status info would probably create too much confusion for this to be worth it

-- Find PSCIS points not already loaded to event table and derive geoms (on the stream)
pts as
(
  SELECT
    stream_crossing_id,
    watershed_group_code,
    FWA_LocateAlong(a.blue_line_key, a.downstream_route_measure) as geom
  FROM distinct_matches a
  WHERE stream_crossing_id NOT IN
  -- DO NOT LOAD CROSSINGS IN THE LOOKUP, they are handled above, or not loaded at all
  (
    SELECT stream_crossing_id FROM bcfishpass.pscis_modelledcrossings_streams_xref
  )
  
),

-- cluster the derived geoms so we can remove duplicates within the clustering distance (5m)
clusters AS
(SELECT
  stream_crossing_id,
  watershed_group_code,
  ST_ClusterDBSCAN(geom, 5, 1) over() as cid
FROM pts),

-- when there are duplicates, retain the closest point, then the most recent asssessment
-- (note that the ids that are mapped using this will change if PSCIS fixes get applied at
-- a later date, the oldest crossing id should retained with de-duplication fixes)
de_duped AS
(
  SELECT DISTINCT ON (cid)
    c.stream_crossing_id,
    c.cid,
    p.distance_to_stream,
    ass.assessment_date,
    c.watershed_group_code
  FROM clusters c
  INNER JOIN distinct_matches p
  ON c.stream_crossing_id = p.stream_crossing_id
  LEFT OUTER JOIN whse_fish.pscis_assessment_svw ass
  ON c.stream_crossing_id = ass.stream_crossing_id
  -- note order by modelled_crossing_id to handle cases where duplicates are in the same spot and on the same day (only one pscis crossing can be associated with a modelled crossing)
  ORDER BY cid, p.distance_to_stream asc, assessment_date desc, p.modelled_crossing_id
)

INSERT INTO bcfishpass.pscis
(
 stream_crossing_id,
 modelled_crossing_id,
 distance_to_stream,
 linear_feature_id,
 wscode_ltree,
 localcode_ltree,
 blue_line_key,
 downstream_route_measure,
 watershed_group_code,
 suspect_match,
 pscis_status,
 current_crossing_type_code,
 current_crossing_subtype_code,
 current_barrier_result_code,
 geom
)
SELECT
  d.stream_crossing_id,
  p.modelled_crossing_id,
  p.distance_to_stream,
  p.linear_feature_id,
  s.wscode_ltree,
  s.localcode_ltree,
  s.blue_line_key,
  p.downstream_route_measure,
  p.watershed_group_code,
  p.suspect_match,
  CASE
    WHEN hc.stream_crossing_id IS NOT NULL AND pa.current_pscis_status NOT IN ('REMEDIATED', 'DESIGN')
    THEN 'HABITAT CONFIRMATION'
    ELSE pa.current_pscis_status
  END AS pscis_status,
  pa.current_crossing_type_code,
  pa.current_crossing_subtype_code,
  pa.current_barrier_result_code,
  ST_Force2D(FWA_LocateAlong(p.blue_line_key, p.downstream_route_measure)) as geom
FROM de_duped d
INNER JOIN distinct_matches p
ON d.stream_crossing_id = p.stream_crossing_id
INNER JOIN bcfishpass.pscis_points_all pa
ON p.stream_crossing_id = pa.stream_crossing_id
INNER JOIN whse_basemapping.fwa_stream_networks_sp s
ON p.linear_feature_id = s.linear_feature_id
LEFT OUTER JOIN whse_fish.pscis_habitat_confirmation_svw hc
ON p.stream_crossing_id = hc.stream_crossing_id
ORDER BY p.stream_crossing_id
ON CONFLICT DO NOTHING;


CREATE INDEX ON bcfishpass.pscis (modelled_crossing_id);
CREATE INDEX ON bcfishpass.pscis (linear_feature_id);
CREATE INDEX ON bcfishpass.pscis (blue_line_key);
CREATE INDEX ON bcfishpass.pscis USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.pscis USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.pscis USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.pscis USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.pscis USING GIST (geom);
