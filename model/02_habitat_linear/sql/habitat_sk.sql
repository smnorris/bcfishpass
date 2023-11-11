-- ==============================================
-- SOCKEYE HABITAT POTENTIAL MODEL 
-- ==============================================

-- ---------------------
-- REARING
-- Sockeye rearing is simply all lakes >2km2, spawning is in adjacent streams
-- ---------------------
insert into bcfishpass.habitat_sk (
  segmented_stream_id,
  rearing
)
SELECT DISTINCT
  s.segmented_stream_id,
  true as rearing
FROM bcfishpass.streams s
INNER JOIN bcfishpass.wsg_species_presence p ON s.watershed_group_code = p.watershed_group_code
LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'SK'
LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lk ON s.waterbody_key = lk.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly res ON s.waterbody_key = res.waterbody_key
WHERE
  p.sk is true AND
  s.watershed_group_code = :'wsg' AND
  s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] AND
  (
    lk.area_ha >= t.rear_lake_ha_min OR  -- lakes
    res.area_ha >= t.rear_lake_ha_min    -- reservoirs
  );

-- ---------------------
-- SPAWNING, DOWNSTREAM
-- ---------------------
-- find outlets of the rearing lakes
WITH rearing_minimums AS
(
  SELECT DISTINCT ON (waterbody_key)
    s.waterbody_key,
    s.wscode_ltree,
    s.localcode_ltree,
    s.downstream_route_measure,
    s.blue_line_key
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.habitat_sk h ON s.segmented_stream_id = h.segmented_stream_id
  WHERE
    s.watershed_group_code = :'wsg' AND
    h.rearing is true
  ORDER BY s.waterbody_key, s.wscode_ltree, s.localcode_ltree, s.downstream_route_measure
),

-- find everything downstream of the rearing lake outlets
downstream AS
(
  SELECT
    r.waterbody_key,
    s.segmented_stream_id,
    s.blue_line_key,
    s.wscode_ltree,
    s.localcode_ltree,
    s.downstream_route_measure,
    s.gradient,
    -length_metre + sum(length_metre) OVER (PARTITION BY r.waterbody_key ORDER BY s.wscode_ltree desc, s.downstream_route_measure desc) as dist_to_lake
    FROM bcfishpass.streams s
  INNER JOIN rearing_minimums r
  ON FWA_Downstream(r.blue_line_key, r.downstream_route_measure, r.wscode_ltree, r.localcode_ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
  WHERE s.blue_line_key = s.watershed_key  -- note that to keep the instream distance to lake correct we do not include side channels in this query
  AND s.watershed_group_code = :'wsg'
),

-- we only want records within 3km of the rearing lakes,
-- create a sequential (downstream, from outlet of lake) row_number column
-- in the query result so that we can easily find streams above any 5% grade
downstream_within_3k AS
(
  SELECT row_number() over (PARTITION BY waterbody_key), *
  FROM downstream
  WHERE dist_to_lake < 3000
),

-- extract from above the segments that are too steep, acting as barriers
too_steep AS
(
  SELECT
    DISTINCT ON (waterbody_key)
    *
  FROM downstream_within_3k
  WHERE gradient > .05
  ORDER BY waterbody_key, row_number
),

-- Now find only segments that are upstream of the too_steep records
-- (or have no upstream too_streep records) by comparing the generated
-- row_number column -> these are the spawning lines
dnstr_spawning AS
(
  SELECT
    a.*,
    b.waterbody_key,
    b.row_number,
    CASE
      WHEN
        wsg.model = 'cw' AND
        s.gradient <= t.spawn_gradient_max AND
        cw.channel_width > t.spawn_channel_width_min AND
        (cw.channel_width > t.spawn_channel_width_min) AND  -- double line riv do not default to spawn cw
        cw.channel_width <= t.spawn_channel_width_max
      THEN true
      WHEN wsg.model = 'mad' AND
        s.gradient <= t.spawn_gradient_max AND
          (mad.mad_m3s > t.spawn_mad_min OR
          s.stream_order >= 8) AND
        s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
      THEN true
  END AS spawning
  FROM downstream_within_3k a
  LEFT OUTER JOIN too_steep b ON a.waterbody_key = b.waterbody_key
  INNER JOIN bcfishpass.streams s ON a.segmented_stream_id = s.segmented_stream_id
  INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'SK'
  LEFT OUTER JOIN bcfishpass.discharge mad ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.channel_width cw ON s.linear_feature_id = cw.linear_feature_id
  WHERE b.waterbody_key IS NULL OR a.row_number < b.row_number
)

insert into bcfishpass.habitat_sk
(segmented_stream_id, spawning)
select
  segmented_stream_id,
  spawning
FROM dnstr_spawning
where spawning is true
on conflict (segmented_stream_id)
do update set spawning = EXCLUDED.spawning;


-- ---------------------
-- SPAWNING, UPSTREAM
-- ---------------------
WITH spawn AS
(
  SELECT
    s.segmented_stream_id,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.geom
  FROM bcfishpass.streams s
  LEFT OUTER JOIN bcfishpass.discharge mad ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.channel_width cw ON s.linear_feature_id = cw.linear_feature_id
  INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'SK'
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
  WHERE
    s.watershed_group_code = :'wsg' AND
    s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] AND

  ((
    wsg.model = 'cw' AND
    s.gradient <= t.spawn_gradient_max AND
    cw.channel_width > t.spawn_channel_width_min AND
    (cw.channel_width > t.spawn_channel_width_min) AND  -- double line riv do not default to spawn cw
    cw.channel_width <= t.spawn_channel_width_max
  ) OR
  (
    wsg.model = 'mad' AND
    s.gradient <= t.spawn_gradient_max AND
    mad.mad_m3s > t.spawn_mad_min AND
    mad.mad_m3s <= t.spawn_mad_max
  ))

  AND
  (wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
    (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))
  )
),

-- find spawn upstream of rearing
spawn_upstream AS
(
  SELECT DISTINCT
    sp.*
  FROM spawn sp
  INNER JOIN bcfishpass.streams r
  ON FWA_Upstream(
    r.blue_line_key,
    r.downstream_route_measure,
    r.wscode_ltree,
    r.localcode_ltree,
    sp.blue_line_key,
    sp.downstream_route_measure,
    sp.wscode_ltree,
    sp.localcode_ltree
  )
  inner join bcfishpass.habitat_sk h on r.segmented_stream_id = h.segmented_stream_id
  where
    r.watershed_group_code = :'wsg' and
    h.rearing is true
),

-- cluster the spawning
clusters as
(
  SELECT
    segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cid,
    geom
  FROM spawn_upstream
  ORDER BY segmented_stream_id
),

-- find the rearing lakes nearby
-- (spatial query on just a few lake geoms is much faster than relating
-- streams classified as rearing back to lakes, and then to the geoms)
clusters_near_rearing as
(
  select
    c.cid,
    bool_or(lk.waterbody_key IS NOT NULL) as wb
  from clusters c
  left outer join whse_basemapping.fwa_lakes_poly lk
  on st_dwithin(c.geom, lk.geom, 2)
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t
  ON t.species_code = 'SK'
  where lk.area_ha >= t.rear_lake_ha_min  -- lakes
  group by c.cid
  union all
  select distinct
    c.cid,
    bool_or(res.waterbody_key IS NOT NULL) as wb
  from clusters c
  left outer join whse_basemapping.fwa_manmade_waterbodies_poly res
  on st_dwithin(c.geom, res.geom, 2)
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t
  ON t.species_code = 'SK'
  where res.area_ha >= t.rear_lake_ha_min    -- reservoirs
  group by c.cid
)

-- finally, insert the streams that compose the clusters connected to lakes
insert into bcfishpass.habitat_sk
(segmented_stream_id, spawning)
select
  segmented_stream_id,
  true as spawning
FROM clusters_near_rearing a
INNER JOIN clusters b
ON a.cid = b.cid
WHERE a.wb is true
on conflict (segmented_stream_id)
do update set spawning = EXCLUDED.spawning;


