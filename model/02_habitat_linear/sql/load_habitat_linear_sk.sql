-- ==============================================
-- SOCKEYE HABITAT POTENTIAL MODEL 
-- ==============================================

-- ---------------------
-- REARING
-- Use DFO sockeye lakes/CUs, spawning is in adjacent streams.

-- this query presumes that:
-- - known spawning lakes have no downstream natural barriers
-- - known spawning lakes are within sockeye watersheds
-- (this is currently the case in Fraser test area, but there are lakes in other regions outside of SK watersheds)
-- ---------------------
insert into bcfishpass.habitat_linear_sk (
  segmented_stream_id,
  rearing
)
select distinct
  s.segmented_stream_id,
  true as rearing
from bcfishpass.dfo_known_sockeye_lakes a
inner join whse_basemapping.fwa_lakes_poly l
on a.waterbody_poly_id = l.waterbody_poly_id
inner join bcfishpass.streams s
on l.waterbody_key = s.waterbody_key
where s.watershed_group_code = :'wsg';


-- ---------------------
-- SPAWNING, DOWNSTREAM
-- todo:
-- - use temp_spawning_sk table to support cross-watershed group downstream spawning
-- - use 5% gradient barriers rather than raw stream gradient as barriers to juveniles swimming upstream to rearing lake
-- - should downstream tribs be included?
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
  INNER JOIN bcfishpass.habitat_linear_sk h ON s.segmented_stream_id = h.segmented_stream_id
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
        av.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
      THEN true
  END AS spawning
  FROM downstream_within_3k a
  LEFT OUTER JOIN too_steep b ON a.waterbody_key = b.waterbody_key
  INNER JOIN bcfishpass.streams s ON a.segmented_stream_id = s.segmented_stream_id
  LEFT OUTER JOIN bcfishpass.streams_access_vw av on a.segmented_stream_id = av.segmented_stream_id
  INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'SK'
  left outer join whse_basemapping.fwa_stream_networks_channel_width cw on s.linear_feature_id = cw.linear_feature_id
  left outer join whse_basemapping.fwa_stream_networks_discharge mad on s.linear_feature_id = mad.linear_feature_id
  WHERE b.waterbody_key IS NULL OR a.row_number < b.row_number
)

insert into bcfishpass.habitat_linear_sk
(segmented_stream_id, spawning)
select distinct
  segmented_stream_id,
  spawning
FROM dnstr_spawning
where spawning is true
on conflict (segmented_stream_id)
do update set spawning = EXCLUDED.spawning;


-- ---------------------
-- ALL SPAWNING UPSTREAM OF REARING LAKES
-- ---------------------
insert into bcfishpass.habitat_linear_sk
(segmented_stream_id, spawning)
select distinct
  sp.segmented_stream_id,
  true as spawning
  FROM bcfishpass.temp_spawning_sk sp
  inner join bcfishpass.streams s on sp.segmented_stream_id = s.segmented_stream_id
  INNER JOIN bcfishpass.streams r
  ON FWA_Upstream(
    r.blue_line_key,
    r.downstream_route_measure,
    r.wscode_ltree,
    r.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree
  )
  inner join bcfishpass.habitat_linear_sk h on r.segmented_stream_id = h.segmented_stream_id
  where
    r.watershed_group_code = :'wsg' and
    h.rearing is true
on conflict (segmented_stream_id)
do update set spawning = EXCLUDED.spawning;