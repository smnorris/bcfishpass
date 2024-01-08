-- ---------------------
-- SOCKEYE SPAWNING
-- create temporary table holding all potential spawning streams, regardless of connectivity
-- ---------------------
drop table if exists bcfishpass.temp_spawning_sk;
create table bcfishpass.temp_spawning_sk as
SELECT
  s.segmented_stream_id,
  s.geom -- include geoms for visual qa
FROM bcfishpass.streams s
LEFT OUTER JOIN bcfishpass.discharge mad ON s.linear_feature_id = mad.linear_feature_id
LEFT OUTER JOIN bcfishpass.channel_width cw ON s.linear_feature_id = cw.linear_feature_id
INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'SK'
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
WHERE
  -- no natural barriers
  s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] AND

-- matching CW/MAD and gradient criteria
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

-- river or stream 
AND
(wb.waterbody_type = 'R' OR                  
  (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))
);

-- index
create index on bcfishpass.temp_spawning_sk (segmented_stream_id);
create index on bcfishpass.temp_spawning_sk using gist (geom);