
-- This function creates the combined_tracking_table_<wcrp>
create or replace function wcrp_hors.create_tracking_table(p_wcrp text)
	returns void
as
$$
begin 
    execute format('DROP TABLE if exists wcrp_%I.combined_tracking_table_%I;', p_wcrp, p_wcrp);
    execute format(
        -- reusing wcrp_hors types for all combined tracking tables
        'CREATE TABLE IF NOT EXISTS wcrp_%I.combined_tracking_table_%I
        (
            internal_name varchar,
            barrier_id varchar PRIMARY KEY,
            watercourse_name varchar,
            road_name varchar,
            structure_type wcrp_hors.tt_structure_type,
            structure_owner varchar,
            private_owner_details varchar,
            structure_list_status wcrp_hors.tt_structure_list_status_type,
            assessment_type_completed wcrp_hors.tt_assessment_type,
            reason_for_exclusion wcrp_hors.tt_excl_reason_type,
            method_of_exclusion wcrp_hors.tt_excl_method_type,
            partial_passability wcrp_hors.tt_partial_passability_type,
            partial_passability_notes wcrp_hors.tt_partial_passability_notes_type,
            upstream_habitat_quality wcrp_hors.tt_upstr_hab_quality_type,
            constructability wcrp_hors.tt_constructability_type,
            estimated_cost_$ numeric,
            priority wcrp_hors.tt_priority_type,
            type_of_rehabilitation wcrp_hors.tt_rehabilitation_type,
            rehabilitated_by varchar,
            rehabilitated_date date,
            estimated_rehabilitation_cost_$ numeric,
            actual_project_cost_$ numeric,
            next_steps wcrp_hors.tt_next_steps_type,
            timeline_for_next_steps date,
            lead_for_next_steps varchar,
            others_involved_in_next_steps varchar,
            reason varchar,
            notes varchar,
            supporting_links varchar
        );', p_wcrp, p_wcrp);


    -- reusing wcrp_hors.blank2null trigger for all combined tracking tables
    execute format(
        'create trigger tr_blank2null
        before insert or update on wcrp_%I.combined_tracking_table_%I
        for each row
        execute procedure wcrp_hors.blank2null();',
        p_wcrp,
        p_wcrp);

    
end
$$
language plpgsql;

-- creates tracking tables for all wcrps
with data (wcrp) as (
	select distinct wcrp
    from bcfishpass.wcrp_watersheds
    where wcrp is not null
)
select wcrp_hors.create_tracking_table(wcrp)
from data;