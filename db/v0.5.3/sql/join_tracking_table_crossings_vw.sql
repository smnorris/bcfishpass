-- This function joins the tracking table to bcfishpass.crossings_wcrp_vw on the barrier ID
create or replace function wcrp_hors.join_tracking_table_crossings_wcrp_vw(p_wcrp text)
	returns void
as
$$
begin 
	execute format('create or replace view wcrp_%I.combined_tracking_table_crossings_wcrp_vw_%I as
				  select 
				  case
				    	when tt.barrier_id is not null then tt.barrier_id
						else cv.aggregated_crossings_id
					end as barrier_id,
				  cv.crossing_source,
					cv.crossing_feature_type,
					cv.pscis_status,
					cv.crossing_type_code,
					cv.crossing_subtype_code,
					cv.barrier_status,
					cv.pscis_road_name,
					cv.pscis_stream_name,
					cv.pscis_assessment_comment,
					cv.pscis_assessment_date,
					cv.transport_line_structured_name_1,
					cv.rail_track_name,
					cv.dam_name,
					cv.dam_height,
					cv.dam_owner,
					cv.dam_use,
					cv.dam_operating_status,
					cv.utm_zone,
					cv.utm_easting,
					cv.utm_northing,
					cv.blue_line_key,
					cv.downstream_route_measure,
					cv.wscode,
					cv.localcode,
					cv.watershed_group_code,
					cv.gnis_stream_name,
					cv.barriers_anthropogenic_dnstr,
					cv.barriers_anthropogenic_dnstr_count,
					cv.barriers_anthropogenic_habitat_wcrp_upstr
					cv.barriers_antrhopogenic_habitat_wcrp_upstr_count,
					cv.barriers_ch_cm_co_pk_sk_dnstr,
					cv.barriers_st_dnstr,
					cv.barriers_wct_dnstr,
					cv.ch_spawning_km,
					cv.ch_rearing_km,
					cv.ch_spawning_belowupstrbarriers_km,
					cv.ch_rearing_belowupstrbarriers_km,
					cv.cm_spawning_km,
					cv.cm_spawning_belowupstrbarriers_km,
					cv.co_spawning_km,
					cv.co_rearing_km,
					cv.co_rearing_ha,
					cv.co_spawning_belowupstrbarriers_km,
					cv.co_rearing_belowupstrbarriers_km,
					cv.co_rearing_belowupstrbarriers_ha,
					cv.pk_spawning_km,
					cv.pk_spawning_belowupstrbarriers_km,
					cv.sk_spawning_km,
					cv.sk_rearing_km,
					cv.sk_rearing_ha,
					cv.sk_spawning_belowupstrbarriers_km,
					cv.sk_rearing_belowupstrbarriers_km,
					cv.sk_rearing_belowupstrbarriers_ha,
					cv.st_spawning_km,
					cv.st_rearing_km,
					cv.st_spawning_belowupstrbarriers_km,
					cv.st_rearing_belowupstrbarriers_km,
					cv.wct_spawning_km,
					cv.wct_rearing_km,
					cv.wct_spawning_belowupstrbarriers_km,
					cv.wct_rearing_belowupstrbarriers_km,
					cv.all_spawning_km,
					cv.all_spawning_belowupstrbarriers_km,
					cv.all_rearing_km,
					cv.all_rearing_belowupstrbarriers_km,
					cv.all_spawningrearing_km,
					cv.all_spawningrearing_belowupstrbarriers_km,
					cv.set_id,
					cv.total_hab_gain_set,
					cv.num_barriers_set,
					cv.avg_gain_per_barrier,
					cv.dnstr_set_ids,
					cv.rank_avg_gain_per_barrier,
					cv.rank_avg_gain_tiered,
					cv.rank_total_upstr_hab,
					cv.rank_combined,
					cv.tier_combined,
					cv.geom,
				  tt.internal_name,
					tt.watercourse_name,
					tt.road_name,
					tt.structure_type,
					tt.structure_owner,
					tt.private_owner_details,
					tt.structure_list_status,
					tt.assessment_type_completed,
					tt.reason_for_exclusion,
					tt.method_of_exclusion,
					tt.partial_passability,
					tt.partial_passability_notes,
					tt.upstream_habitat_quality,
					tt.constructability,
					tt.estimated_cost_$,
					tt.priority,
					tt.type_of_rehabilitation,
					tt.rehabilitated_by,
					tt.rehabilitated_date,
					tt.estimated_rehabilitation_cost_$,
					tt.actual_project_cost_$,
					tt.next_steps,
					tt.timeline_for_next_steps,
					tt.lead_for_next_steps,
					tt.others_involved_in_next_steps,
					tt.reason,
					tt.notes,
					tt.supporting_links
				   from bcfishpass.crossings_wcrp_vw cv
				  full outer join wcrp_%I.combined_tracking_table_%I tt 
				   	on tt.barrier_id = cv.aggregated_crossings_id
					where (cv.watershed_group_code in 
						(select watershed_group_code 
						from bcfishpass.wcrp_watersheds 
						where wcrp ilike %L)
						and cv.all_spawningrearing_km > 0) 
						or tt.barrier_id is not null', p_wcrp, p_wcrp, p_wcrp, p_wcrp, p_wcrp);
end
$$
language plpgsql;

-- loop through each WCRP and create a view for each one
with data (wcrp) as (
	select wcrp
	from bcfishpass.wcrp_watersheds
)
select wcrp_hors.join_tracking_table_crossings_wcrp_vw(wcrp)
from data;