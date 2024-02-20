-- ---------------------
-- HORSEFLY SPECIAL CASE 
--
-- Sockeye rearing for Horsefly is cross-wsg, all rearing is in Quesnel Lake
-- Simply apply the spawing model everywhere in HORS.
-- (presumably there are other cross-wsg sockeye spawn/rearing, this needs verification)
-- ---------------------
insert into bcfishpass.habitat_linear_sk
(segmented_stream_id, spawning)
SELECT
  s.segmented_stream_id,
  true as spawning
FROM bcfishpass.streams s
inner join bcfishpass.streams_access_vw av on s.segmented_stream_id = av.segmented_stream_id
left outer join whse_basemapping.fwa_stream_networks_channel_width cw on s.linear_feature_id = cw.linear_feature_id
left outer join whse_basemapping.fwa_stream_networks_discharge mad on s.linear_feature_id = mad.linear_feature_id
INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'SK'
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
WHERE
(
  wsg.model = 'mad' AND
  s.gradient <= t.spawn_gradient_max AND
  mad.mad_m3s > t.spawn_mad_min AND
  mad.mad_m3s <= t.spawn_mad_max
)
AND
(wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
  (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))
)
AND s.watershed_group_code = 'HORS'
AND av.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
on conflict (segmented_stream_id)
do update set spawning = EXCLUDED.spawning;