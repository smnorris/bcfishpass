-- wcrp version of the output crossings view -
create materialized view bcfishpass.crossings_wcrp_vw as

-- find upstream crossings with wcrp 'all spawning rearing habitat' upstream
with upstr_wcrp_barriers as materialized (
  select distinct
   ba.aggregated_crossings_id,
   h.aggregated_crossings_id as upstr_barriers,
   h.all_spawningrearing_km
  from bcfishpass.crossings_upstr_barriers_anthropogenic ba
  inner join bcfishpass.crossings_upstream_habitat_wcrp h on h.aggregated_crossings_id = any(ba.features_upstr)
  where h.all_spawningrearing_km > 0
  order by ba.aggregated_crossings_id, h.aggregated_crossings_id
),

-- aggregate the upstream wcrp crossings into a list and count
upstr_wcrp_barriers_list as (
  select
    aggregated_crossings_id,
    array_to_string(array_agg(upstr_barriers), ';') as barriers_anthropogenic_habitat_wcrp_upstr,
    coalesce(array_length(array_agg(upstr_barriers), 1), 0) as barriers_anthropogenic_habitat_wcrp_upstr_count
  from upstr_wcrp_barriers
  group by aggregated_crossings_id
  order by aggregated_crossings_id
)

select
  -- joining to streams based on measure can be error prone due to precision.
  -- Join to streams on linear_feature_id and keep the first result
  -- (since streams are segmented there is often >1 match)
  distinct on (c.aggregated_crossings_id)
  c.aggregated_crossings_id,
  c.modelled_crossing_id,
  c.crossing_source,
  cft.crossing_feature_type,
  c.pscis_status,
  c.crossing_type_code,
  c.crossing_subtype_code,
  c.barrier_status,
  c.pscis_road_name,
  c.pscis_stream_name,
  c.pscis_assessment_comment,
  c.pscis_assessment_date,
  c.transport_line_structured_name_1,
  c.rail_track_name,
  c.dam_name,
  c.dam_height,
  c.dam_owner,
  c.dam_use,
  c.dam_operating_status,
  c.utm_zone,
  c.utm_easting,
  c.utm_northing,
  c.blue_line_key,
  c.watershed_group_code,
  c.gnis_stream_name,
  array_to_string(ad.features_dnstr, ';') as barriers_anthropogenic_dnstr,
  coalesce(array_length(ad.features_dnstr, 1), 0) as barriers_anthropogenic_dnstr_count,
  uwbl.barriers_anthropogenic_habitat_wcrp_upstr,
  uwbl.barriers_anthropogenic_habitat_wcrp_upstr_count,

  -- habitat models
  h.ch_spawning_km,
  h.ch_rearing_km,
  h.ch_spawning_belowupstrbarriers_km,
  h.ch_rearing_belowupstrbarriers_km,
  h.cm_spawning_km,
  h.cm_spawning_belowupstrbarriers_km,
  h.co_spawning_km,
  h_wcrp.co_rearing_km,
  h.co_rearing_ha,
  h.co_spawning_belowupstrbarriers_km,
  h_wcrp.co_rearing_belowupstrbarriers_km,
  h.co_rearing_belowupstrbarriers_ha,
  h.pk_spawning_km,
  h.pk_spawning_belowupstrbarriers_km,
  h.sk_spawning_km,
  h_wcrp.sk_rearing_km,
  h.sk_rearing_ha,
  h.sk_spawning_belowupstrbarriers_km,
  h_wcrp.sk_rearing_belowupstrbarriers_km,
  h.sk_rearing_belowupstrbarriers_ha,
  h.st_spawning_km,
  h.st_rearing_km,
  h.st_spawning_belowupstrbarriers_km,
  h.st_rearing_belowupstrbarriers_km,
  h.wct_spawning_km,
  h.wct_rearing_km,
  h.wct_spawning_belowupstrbarriers_km,
  h.wct_rearing_belowupstrbarriers_km,
  h_wcrp.all_spawning_km,
  h_wcrp.all_spawning_belowupstrbarriers_km,
  h_wcrp.all_rearing_km,
  h_wcrp.all_rearing_belowupstrbarriers_km,
  h_wcrp.all_spawningrearing_km,
  h_wcrp.all_spawningrearing_belowupstrbarriers_km,
  r.set_id,
  r.total_hab_gain_set,
  r.num_barriers_set,
  r.avg_gain_per_barrier,
  r.dnstr_set_ids,
  r.rank_avg_gain_per_barrier,
  r.rank_avg_gain_tiered,
  r.rank_total_upstr_hab,
  r.rank_combined,
  r.tier_combined,
  c.geom
from bcfishpass.crossings c
inner join bcfishpass.wcrp_watersheds w on c.watershed_group_code = w.watershed_group_code  -- only include crossings in WCRP watersheds
inner join bcfishpass.crossings_feature_type_vw cft on c.aggregated_crossings_id = cft.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_observations_vw cdo on c.aggregated_crossings_id = cdo.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_observations_vw cuo on c.aggregated_crossings_id = cuo.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_crossings cd on c.aggregated_crossings_id = cd.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on c.aggregated_crossings_id = ad.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_anthropogenic au on c.aggregated_crossings_id = au.aggregated_crossings_id
left outer join upstr_wcrp_barriers_list uwbl on c.aggregated_crossings_id = uwbl.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat h on c.aggregated_crossings_id = h.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat_wcrp h_wcrp on c.aggregated_crossings_id = h_wcrp.aggregated_crossings_id
left outer join bcfishpass.streams s on c.linear_feature_id = s.linear_feature_id
left outer join whse_basemapping.dbm_mof_50k_grid t ON ST_Intersects(c.geom, t.geom)
left outer join bcfishpass.wcrp_ranked_barriers r ON c.aggregated_crossings_id = r.aggregated_crossings_id
order by c.aggregated_crossings_id, s.downstream_route_measure;